import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService extends ChangeNotifier {
  static const String baseUrl = 'https://gym-backend-two-bay.vercel.app';
  
  String? _token;
  Map<String, dynamic>? _user;
  bool _isLoading = true;
  
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

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
      // Trigger the Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
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
    } catch (e) {
      debugPrint('Google sign in error: $e');
      return {'success': false, 'error': 'Failed to sign in with Google'};
    }
  }
}
