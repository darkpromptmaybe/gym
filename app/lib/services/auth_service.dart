import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService extends ChangeNotifier {
  static const String baseUrl = 'https://gym-backend-two-bay.vercel.app';
  
  String? _token;
  Map<String, dynamic>? _user;
  bool _isLoading = true;
  
  // GoogleSignIn will only be initialized when needed (when user clicks button)
  GoogleSignIn? _googleSignIn;

  bool get isAuthenticated => _token != null;
  bool get isLoading => _isLoading;
  Map<String, dynamic>? get user => _user;

  AuthService() {
    _loadToken();
  }

  Future<void> _loadToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString('auth_token');
      final userJson = prefs.getString('user_data');
      
      if (userJson != null) {
        _user = jsonDecode(userJson);
      }
      
      if (_token != null) {
        // Verify token is still valid
        final isValid = await verifyToken();
        if (!isValid) {
          await logout();
        }
      }
    } catch (e) {
      debugPrint('Error loading token: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> verifyToken() async {
    if (_token == null) return false;
    
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/auth/verify'),
        headers: {'Authorization': 'Bearer $_token'},
      );
      
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Error verifying token: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> signIn(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/sign-in'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        _token = data['data']['access_token'];
        _user = data['data'];
        
        // Save to local storage
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', _token!);
        await prefs.setString('user_data', jsonEncode(_user));
        
        notifyListeners();
        return {'success': true};
      } else {
        return {'success': false, 'error': data['error'] ?? 'Sign in failed'};
      }
    } catch (e) {
      debugPrint('Sign in error: $e');
      return {'success': false, 'error': 'Network error. Please try again.'};
    }
  }

  Future<Map<String, dynamic>> signUp(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 && data['success'] == true) {
        _token = data['data']['access_token'];
        _user = data['data'];
        
        // Save to local storage
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', _token!);
        await prefs.setString('user_data', jsonEncode(_user));
        
        notifyListeners();
        return {'success': true};
      } else {
        return {'success': false, 'error': data['error'] ?? 'Sign up failed'};
      }
    } catch (e) {
      debugPrint('Sign up error: $e');
      return {'success': false, 'error': 'Network error. Please try again.'};
    }
  }

  Future<void> logout() async {
    _token = null;
    _user = null;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_data');
    
    notifyListeners();
  }

  Future<Map<String, dynamic>?> getProfile() async {
    if (_token == null) return null;
    
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/data/profile'),
        headers: {'Authorization': 'Bearer $_token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'];
      }
      return null;
    } catch (e) {
      debugPrint('Get profile error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      // Initialize GoogleSignIn only when needed
      _googleSignIn ??= GoogleSignIn(
        scopes: ['email', 'profile'],
        // For web, clientId will be read from meta tag in index.html
        // For production, set your Google OAuth Client ID here or in meta tag
      );
      
      // Trigger the Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn!.signIn();
      
      if (googleUser == null) {
        return {'success': false, 'error': 'Sign in cancelled'};
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Send Google user data to backend
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/google'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': googleUser.email,
          'google_id': googleUser.id,
          'name': googleUser.displayName ?? 'User',
          'photo_url': googleUser.photoUrl,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        _token = data['data']['access_token'];
        _user = data['data'];
        
        // Save to local storage
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', _token!);
        await prefs.setString('user_data', jsonEncode(_user));
        
        notifyListeners();
        return {'success': true};
      } else {
        return {'success': false, 'error': data['error'] ?? 'Google sign in failed'};
      }
    } on PlatformException catch (e) {
      debugPrint('Google sign in platform error: $e');
      if (e.code == 'sign_in_failed' && e.message != null && e.message!.contains('ClientID')) {
        return {'success': false, 'error': 'Google Sign-In not configured. Please add Client ID in web/index.html'};
      }
      return {'success': false, 'error': 'Google Sign-In error: ${e.message}'};
    } catch (e) {
      debugPrint('Google sign in error: $e');
      String errorMsg = e.toString();
      if (errorMsg.contains('ClientID') || errorMsg.contains('appClientId')) {
        return {'success': false, 'error': 'Google Sign-In not configured. See GOOGLE_OAUTH_SETUP.md'};
      }
      return {'success': false, 'error': 'Failed to sign in with Google. Check console for details.'};
    }
  }
}
