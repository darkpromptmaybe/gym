import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:html' as html show window;

class AuthService extends ChangeNotifier {
  static const String baseUrl = 'https://gym-backend-two-bay.vercel.app';
  
  String? _token;
  Map<String, dynamic>? _user;
  bool _isLoading = true;

  bool get isAuthenticated => _token != null;
  bool get isLoading => _isLoading;
  Map<String, dynamic>? get user => _user;

  AuthService() {
    _loadToken();
  }

  Future<void> _loadToken() async {
    try {
      // Check for pending OAuth callback on web
      if (kIsWeb) {
        final pendingToken = html.window.sessionStorage['pending_token'];
        final pendingUser = html.window.sessionStorage['pending_user'];
        
        if (pendingToken != null && pendingUser != null) {
          await handleGoogleCallback(pendingToken, pendingUser);
          html.window.sessionStorage.remove('pending_token');
          html.window.sessionStorage.remove('pending_user');
          _isLoading = false;
          notifyListeners();
          return;
        }
      }
      
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

  // Google Sign-In using backend OAuth flow
  String getGoogleSignInUrl() {
    // Get current URL for redirect back
    final currentUrl = kIsWeb ? Uri.base.toString().split('?')[0] : 'http://localhost:54321';
    return '$baseUrl/api/auth/google/login?redirect=$currentUrl';
  }

  Future<Map<String, dynamic>> handleGoogleCallback(String token, String userJson) async {
    try {
      _token = token;
      _user = jsonDecode(userJson);
      
      // Save to local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', _token!);
      await prefs.setString('user_data', jsonEncode(_user));
      
      notifyListeners();
      return {'success': true};
    } catch (e) {
      debugPrint('Google callback error: $e');
      return {'success': false, 'error': 'Failed to process Google sign-in'};
    }
  }
}
