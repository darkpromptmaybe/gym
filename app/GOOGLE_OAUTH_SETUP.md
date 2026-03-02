# Google OAuth Setup Guide (Backend-Only Flow)

The Gym App uses a **backend-only Google OAuth flow**, which means:
- ✅ **No Client ID needed in frontend**
- ✅ **All OAuth handled by backend**
- ✅ **More secure** - client secrets stay on server
- ✅ **Simpler frontend** - just redirects to backend

## How It Works

1. User clicks "Sign in with Google" in Flutter app
2. App redirects to backend: `/api/auth/google/login`
3. Backend redirects to Google OAuth
4. User authorizes on Google
5. Google redirects back to backend: `/api/auth/google/callback`
6. Backend exchanges code for token, gets user info
7. Backend creates/updates user in database
8. Backend redirects to frontend with JWT token
9. Frontend saves token and logs in user

## Setup Instructions

### 1. Create Google OAuth Credentials

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select an existing one
3. Navigate to **APIs & Services** > **Credentials**
4. Click **+ CREATE CREDENTIALS** > **OAuth 2.0 Client ID**
5. Configure the OAuth consent screen if you haven't already:
   - User Type: External (for testing) or Internal (for organization)
   - Add app name, user support email, and developer contact
   - Add scopes: `openid`, `email`, and `profile`

### 2. Create OAuth 2.0 Client ID for Web Application

1. Select **Web application** as Application type
2. Add a name (e.g., "Gym App Backend")
3. Add Authorized JavaScript origins:
   - `http://localhost:3000` (for local backend)
   - `https://gym-backend-two-bay.vercel.app` (for production backend)
4. Add Authorized redirect URIs:
   - `http://localhost:3000/api/auth/google/callback` (for local)
   - `https://gym-backend-two-bay.vercel.app/api/auth/google/callback` (for production)
5. Click **CREATE**
6. Copy the **Client ID** and **Client Secret**

### 3. Configure Backend Environment Variables

Add to your backend `.env` file or environment variables:

```env
GOOGLE_CLIENT_ID=your-client-id-here.apps.googleusercontent.com
GOOGLE_CLIENT_SECRET=your-client-secret-here
GOOGLE_REDIRECT_URI=http://localhost:3000/api/auth/google/callback
```

For production (Vercel):
```env
GOOGLE_CLIENT_ID=your-client-id-here.apps.googleusercontent.com
GOOGLE_CLIENT_SECRET=your-client-secret-here
GOOGLE_REDIRECT_URI=https://gym-backend-two-bay.vercel.app/api/auth/google/callback
```

### 4. No Frontend Configuration Needed!

The frontend automatically works with the backend OAuth flow. No configuration required!

## Testing

### Local Development
1. Start backend: `cd backend && npm run dev`
2. Start Flutter app: `cd app && flutter run -d chrome`
3. Click "Sign in with Google"
4. Should redirect through backend and authenticate

### Production
1. Deploy backend to Vercel with environment variables
2. Deploy Flutter app to Vercel
3. Update `GOOGLE_REDIRECT_URI` to production URL
4. Test Google Sign-In flow

## Troubleshooting

### Error: "redirect_uri_mismatch"
- Check that `GOOGLE_REDIRECT_URI` in backend matches exactly with the redirect URI in Google Cloud Console
- Make sure to include the full path: `/api/auth/google/callback`

### Error: "Google OAuth not configured"
- Ensure `GOOGLE_CLIENT_ID` and `GOOGLE_CLIENT_SECRET` are set in backend environment variables
- Check that variables are properly loaded (not undefined)

### User not redirected back
- Check browser console for errors
- Verify Flutter app URL is correct in backend callback
- Ensure `url_launcher` package is installed in Flutter app

## API Endpoints

The backend provides these OAuth endpoints:

- `GET /api/auth/google/login?redirect=<frontend-url>` - Initiates Google OAuth
- `GET /api/auth/google/callback?code=<auth-code>&state=<redirect-url>` - Handles OAuth callback

The frontend will be redirected back with:
- `?token=<jwt-token>` - JWT authentication token
- `&user=<user-json>` - User data as JSON string

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
