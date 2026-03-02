# 💪 Gym App - Flutter Mobile Application

A full-featured gym management mobile application built with Flutter, featuring user authentication, profile management, and seamless integration with the backend API.

## ✨ Features

- 🔐 **User Authentication**
  - Email/Password registration and login
  - JWT token-based authentication
  - Secure password handling
  - Persistent sessions with SharedPreferences

- 👤 **User Profile Management**
  - View user profile information
  - Display user name, email, and ID
  - Beautiful gradient UI design

- 📱 **Cross-Platform Support**
  - Android
  - iOS
  - Web (Chrome, Edge, Safari)

- 🎨 **Modern UI/UX**
  - Material Design 3
  - Gradient backgrounds
  - Smooth animations
  - Responsive layouts

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK
- Android Studio / Xcode (for mobile development)
- Chrome (for web development)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/darkpromptmaybe/gym.git
   cd gym
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   
   For Web:
   ```bash
   flutter run -d chrome
   ```
   
   For Android:
   ```bash
   flutter run -d android
   ```
   
   For iOS:
   ```bash
   flutter run -d ios
   ```

## 📁 Project Structure

```
lib/
├── main.dart                 # App entry point
├── services/
│   └── auth_service.dart    # Authentication service with API integration
├── screens/
│   ├── auth/
│   │   ├── login_screen.dart    # Login page
│   │   └── register_screen.dart # Registration page
│   └── home/
│       └── home_screen.dart     # Home/Profile page
```

## 🔧 Configuration

### Backend API

The app connects to the backend API at:
```
https://gym-backend-two-bay.vercel.app
```

To change the API endpoint, update the `baseUrl` in [lib/services/auth_service.dart](lib/services/auth_service.dart):

```dart
static const String baseUrl = 'YOUR_API_URL_HERE';
```

## 📡 API Integration

### Authentication Service

The `AuthService` class handles all API interactions:

- **Sign In**: POST `/api/auth/sign-in`
- **Sign Up**: POST `/api/auth/register`
- **Verify Token**: GET `/api/auth/verify`
- **Get Profile**: GET `/api/data/profile`

### State Management

Uses Provider for state management:
- `AuthService` is a `ChangeNotifier` that notifies listeners of auth state changes
- Automatically persists auth tokens using `SharedPreferences`
- Verifies token validity on app startup

## 🎯 Usage

### Sign Up Flow

1. Open the app
2. Tap "Don't have an account? Sign Up"
3. Enter name, email, and password
4. Tap "Sign Up"
5. Automatically redirected to home screen

### Sign In Flow

1. Enter email and password
2. Tap "Sign In"
3. Upon success, redirected to home screen with profile information

### Profile View

- Displays user's name, email, and ID
- Beautiful card-based layout
- Sign out button to end session

## 🔒 Security

- JWT tokens stored securely in SharedPreferences
- Passwords never stored locally
- Automatic token verification on app startup
- Secure HTTPS communication with backend

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0                    # HTTP client
  shared_preferences: ^2.2.2      # Local storage
  provider: ^6.1.1                # State management
  google_sign_in: ^6.1.6         # Google OAuth (future)
  cupertino_icons: ^1.0.6        # iOS-style icons
```

## 🐛 Troubleshooting

### Build Issues

If you encounter build issues, try:

```bash
flutter clean
flutter pub get
flutter run
```

### Android Issues

Make sure you have:
- Android SDK installed
- Minimum SDK version: 21 (Android 5.0)
- Update Gradle if needed

### iOS Issues

Make sure you have:
- Xcode installed
- CocoaPods installed
- iOS deployment target: 12.0 or higher

### Web Issues

Make sure you have:
- Chrome browser installed
- Run `flutter config --enable-web` if web support is missing

## 🚀 Deployment

### Android

```bash
flutter build apk --release
```

APK location: `build/app/outputs/flutter-apk/app-release.apk`

### iOS

```bash
flutter build ios --release
```

### Web

```bash
flutter build web --release
```

Output: `build/web/`

## 📱 Screenshots

### Login Screen
- Beautiful gradient background
- Email and password inputs
- Form validation
- "Sign Up" navigation

### Register Screen
- Name, email, and password inputs
- Password visibility toggle
- Form validation with error messages

### Home Screen
- User profile card
- Avatar with initial letter
- Email and ID display
- Sign out functionality

## 🛠️ Development

### Running Tests

```bash
flutter test
```

### Code Analysis

```bash
flutter analyze
```

### Format Code

```bash
flutter format .
```

## 📄 License

This project is licensed under the MIT License.

## 👥 Contributors

- Backend API: [gym-backend](https://github.com/darkpromptmaybe/gym-backend)
- Mobile App: Flutter

## 📞 Support

For issues and questions:
- Create an issue on GitHub
- Check the backend API documentation at [backend/README.md](backend/README.md)

## 🔮 Future Enhancements

- [ ] Google Sign-In integration
- [ ] Workout tracking
- [ ] Gym check-in functionality
- [ ] Trainer management
- [ ] Progress photos
- [ ] Workout plans
- [ ] Exercise library
- [ ] Social features
- [ ] Push notifications

## 🌐 Backend Repository

Backend API: [https://github.com/darkpromptmaybe/gym-backend](https://github.com/darkpromptmaybe/gym-backend)

## 📚 Documentation

- [Flutter Documentation](https://docs.flutter.dev/)
- [Backend API Documentation](backend/README.md)
- [API Integration Guide](app/API_INTEGRATION.md)

---

Made with ❤️ and Flutter
