# Google OAuth Setup Guide

To enable Google Sign-In in your Gym App, follow these steps:

## 1. Create Google OAuth Credentials

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select an existing one
3. Navigate to **APIs & Services** > **Credentials**
4. Click **+ CREATE CREDENTIALS** > **OAuth 2.0 Client ID**
5. Configure the OAuth consent screen if you haven't already:
   - User Type: External (for testing) or Internal (for organization)
   - Add app name, user support email, and developer contact
   - Add scopes: `email` and `profile`

## 2. Create OAuth 2.0 Client ID

### For Web Application:
1. Select **Web application** as Application type
2. Add a name (e.g., "Gym App Web")
3. Add Authorized JavaScript origins:
   - `http://localhost:54321` (for local development)
   - `https://your-production-domain.com` (for production)
4. Add Authorized redirect URIs:
   - `http://localhost:54321` (for local development)
   - `https://your-production-domain.com` (for production)
5. Click **CREATE**
6. Copy the **Client ID** (looks like: `123456789-abc123.apps.googleusercontent.com`)

## 3. Configure the Flutter App

### Option A: Using Meta Tag (Recommended for Web)
Edit `app/web/index.html` and uncomment/update the Google Sign-In meta tag:
```html
<meta name="google-signin-client_id" content="YOUR_CLIENT_ID_HERE.apps.googleusercontent.com">
```

### Option B: Using Code (For all platforms)
Edit `app/lib/services/auth_service.dart` and update the GoogleSignIn initialization:
```dart
GoogleSignIn? _googleSignIn;

GoogleSignIn get googleSignIn {
  _googleSignIn ??= GoogleSignIn(
    scopes: ['email', 'profile'],
    clientId: 'YOUR_CLIENT_ID_HERE.apps.googleusercontent.com', // Add this line
  );
  return _googleSignIn!;
}
```

## 4. Backend Configuration

The backend at `backend/app/api/auth/google/route.ts` is already configured to handle Google authentication. No changes needed.

## 5. Test the Integration

1. Start your Flutter app: `flutter run -d chrome --web-port=54321`
2. Click the "Sign in with Google" button
3. Select a Google account
4. Grant permissions
5. You should be redirected back and logged in

## Troubleshooting

### Error: "ClientID not set"
- Make sure you've added the meta tag in `web/index.html` OR passed `clientId` in code
- Restart the Flutter app after making changes

### Error: "redirect_uri_mismatch"
- Ensure the URL you're running on (e.g., `http://localhost:54321`) is added to Authorized JavaScript origins
- Check that there are no trailing slashes or typos

### Error: "Access blocked: This app's request is invalid"
- Make sure you've configured the OAuth consent screen
- Add test users if the app is in testing mode
- Verify that scopes `email` and `profile` are added

## Production Deployment

When deploying to production:
1. Add your production domain to Authorized JavaScript origins
2. Update the meta tag or clientId with your production Client ID
3. Ensure your Vercel deployment URL is authorized
4. Update the OAuth consent screen with production details

## Security Notes

- Never commit your Client ID to public repositories if it's linked to sensitive data
- Use environment variables for production Client IDs
- Regularly review authorized domains in Google Cloud Console
- Keep your OAuth consent screen information up to date
