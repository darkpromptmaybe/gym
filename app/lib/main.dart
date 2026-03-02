import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html;
import 'screens/auth/login_screen.dart';
import 'screens/home/home_screen.dart';
import 'services/auth_service.dart';

void main() {
  // Check for OAuth callback on web
  if (kIsWeb) {
    final uri = Uri.base;
    final token = uri.queryParameters['token'];
    final userJson = uri.queryParameters['user'];
    final error = uri.queryParameters['error'];
    final errorMessage = uri.queryParameters['message'];
    
    if (token != null && userJson != null) {
      // Store temporarily for auth service to pick up
      html.window.sessionStorage['pending_token'] = token;
      html.window.sessionStorage['pending_user'] = userJson;
      
      // Remove query params from URL
      html.window.history.replaceState(null, '', uri.path);
    } else if (error != null) {
      // Store error for display
      html.window.sessionStorage['oauth_error'] = error;
      if (errorMessage != null) {
        html.window.sessionStorage['oauth_error_message'] = errorMessage;
      }
      
      // Remove query params from URL
      html.window.history.replaceState(null, '', uri.path);
    }
  }
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gym App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: Consumer<AuthService>(
        builder: (context, auth, _) {
          if (auth.isLoading) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          
          return auth.isAuthenticated ? const HomeScreen() : const LoginScreen();
        },
      ),
    );
  }
}
