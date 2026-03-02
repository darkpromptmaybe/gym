# 🚀 Flutter App Quick Start Guide

## 📱 What's New

Your gym app is now a **full Flutter mobile application** with:
- ✅ Cross-platform support (Android, iOS, Web)
- ✅ Beautiful Material Design 3 UI
- ✅ JWT authentication with backend API
- ✅ Persistent sessions
- ✅ Profile management
- ✅ Form validation
- ✅ Responsive layouts

## 🎯 Running the App

### Web (Easiest - Already Running!)

```bash
flutter run -d chrome
```

The app is now running in Chrome at: http://localhost:PORT

### Android Emulator

1. Start Android Emulator from Android Studio
2. Run:
   ```bash
   flutter run -d android
   ```

### iOS Simulator (macOS only)

```bash
flutter run -d ios
```

### Physical Device

Connect your phone and enable USB debugging, then:
```bash
flutter run
```

## 📂 Project Structure

```
lib/
├── main.dart                          # App entry point with Provider setup
├── services/
│   └── auth_service.dart             # API integration & state management
└── screens/
    ├── auth/
    │   ├── login_screen.dart         # Login page
    │   └── register_screen.dart      # Registration page
    └── home/
        └── home_screen.dart          # Profile/Home page
```

## 🔧 Key Features

### 1. Authentication Service (`lib/services/auth_service.dart`)

```dart
// Sign in with email/password
await authService.signIn(email, password);

// Register new user
await authService.signUp(name, email, password);

// Check authentication status
bool isAuthenticated = authService.isAuthenticated;

// Get current user
Map<String, dynamic>? user = authService.user;

// Sign out
await authService.logout();
```

### 2. State Management

Uses **Provider** for reactive state management:
- Automatically updates UI when auth state changes
- Persists tokens with SharedPreferences
- Handles navigation based on auth status

### 3. API Integration

All API calls to: `https://gym-backend-two-bay.vercel.app`

Endpoints:
- `POST /api/auth/register` - Register new user
- `POST /api/auth/sign-in` - Login
- `GET /api/auth/verify` - Verify token
- `GET /api/data/profile` - Get user profile

## 🎨 UI Screens

### Login Screen
- Email/password input with validation
- Password visibility toggle
- Sign up navigation
- Gradient background
- Loading states

### Register Screen
- Name, email, password inputs
- Form validation
- Password strength requirements
- Auto-login after registration

### Home Screen
- User profile display
- Avatar with name initial
- Email and user ID
- Sign out button
- Gradient design

## 🔐 Security Features

- JWT token authentication
- Secure password handling (never stored locally)
- Automatic token verification on startup
- HTTPS communication
- Token stored in SharedPreferences

## 📦 Dependencies

```yaml
http: ^1.1.0                    # API requests
shared_preferences: ^2.2.2      # Local storage
provider: ^6.1.1                # State management
google_sign_in: ^6.1.6         # Google OAuth (future feature)
```

## 🛠️ Development Commands

### Run App
```bash
flutter run -d chrome         # Web
flutter run -d android        # Android
flutter run -d ios           # iOS
```

### Build for Production
```bash
flutter build apk --release   # Android APK
flutter build web --release   # Web
flutter build ios --release   # iOS
```

### Hot Reload
Press `r` while app is running to hot reload changes.

### Hot Restart
Press `R` to hot restart (full restart).

## 🧪 Testing the App

1. **Sign Up Flow:**
   - Open app → Tap "Don't have an account? Sign Up"
   - Enter: Name, Email, Password (min 6 chars)
   - Tap "Sign Up"
   - Should auto-login and show profile

2. **Sign In Flow:**
   - Enter email and password
   - Tap "Sign In"
   - Should show profile screen

3. **Session Persistence:**
   - Close app completely
   - Reopen app
   - Should still be logged in (if token valid)

4. **Sign Out:**
   - Tap logout icon or "Sign Out" button
   - Should return to login screen

## 📊 API Response Format

All API responses follow this format:

```json
{
  "success": true,
  "data": {
    "id": 123,
    "email": "user@example.com",
    "name": "User Name",
    "access_token": "jwt_token_here"
  }
}
```

Error responses:
```json
{
  "success": false,
  "error": "Error message here"
}
```

## 🐛 Common Issues & Solutions

### "No connected devices"
- For web: Make sure Chrome is installed
- For Android: Start emulator or connect phone
- For iOS: Open simulator

### Build errors
```bash
flutter clean
flutter pub get
flutter run
```

### Token expired
- App automatically checks token on startup
- Invalid tokens trigger logout
- User needs to sign in again

## 🚀 Deployment

### Android - Google Play Store
1. Build release APK: `flutter build apk --release`
2. Sign the APK with your keystore
3. Upload to Play Console

### iOS - App Store
1. Build release: `flutter build ios --release`
2. Open in Xcode
3. Archive and submit to App Store Connect

### Web - Static Hosting
1. Build: `flutter build web --release`
2. Deploy `build/web/` to:
   - Vercel
   - Netlify
   - Firebase Hosting
   - GitHub Pages

## 📚 Documentation

- **Flutter README:** [FLUTTER_README.md](FLUTTER_README.md)
- **Backend API:** [backend/README.md](backend/README.md)
- **API Integration:** [app/API_INTEGRATION.md](app/API_INTEGRATION.md)

## 🎯 Next Steps

1. **Test the app** - Run `flutter run -d chrome` and test all features
2. **Build for mobile** - Try Android/iOS if you have emulators
3. **Customize** - Update colors, add features, modify UI
4. **Deploy** - Build and deploy to app stores

## 💡 Tips

- Use **Hot Reload (r)** during development for instant updates
- Check **DevTools** for debugging: http://localhost:9100
- Use **Provider DevTools** to monitor state changes
- Keep `auth_service.dart` for all API calls

## 🔗 Links

- Backend API: https://gym-backend-two-bay.vercel.app
- GitHub Repo: https://github.com/darkpromptmaybe/gym
- Flutter Docs: https://docs.flutter.dev

---

**Your Flutter app is ready! 🎉**

Run `flutter run -d chrome` to get started!
