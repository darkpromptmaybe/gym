# Quick Setup Guide - Google OAuth Backend-Only

## Problem Fixed ✅
- **Before:** Frontend required Google Client ID → Error: "Set Google Cloud ID"
- **After:** All OAuth handled by backend → No frontend config needed!

## Setup Steps

### 1. Google Cloud Console (5 minutes)

1. Go to https://console.cloud.google.com/
2. **APIs & Services** → **Credentials** → **Create OAuth Client ID**
3. **Application type:** Web application
4. **Authorized redirect URIs:**
   ```
   http://localhost:3000/api/auth/google/callback
   https://gym-backend-two-bay.vercel.app/api/auth/google/callback
   ```
5. Copy **Client ID** and **Client Secret**

### 2. Backend Environment Variables

**Local (`.env` file):**
```env
GOOGLE_CLIENT_ID=your-client-id.apps.googleusercontent.com
GOOGLE_CLIENT_SECRET=your-client-secret
GOOGLE_REDIRECT_URI=http://localhost:3000/api/auth/google/callback
DATABASE_URL=your-database-url
NEXTAUTH_SECRET=your-secret-key
```

**Vercel (Environment Variables):**
```env
GOOGLE_CLIENT_ID=your-client-id.apps.googleusercontent.com
GOOGLE_CLIENT_SECRET=your-client-secret
GOOGLE_REDIRECT_URI=https://gym-backend-two-bay.vercel.app/api/auth/google/callback
DATABASE_URL=your-database-url
NEXTAUTH_SECRET=your-secret-key
```

### 3. Frontend - No Config Needed! 🎉

The Flutter app automatically works with the backend OAuth flow.

## Test It

### Local Test
```bash
# Terminal 1 - Backend
cd backend
npm run dev

# Terminal 2 - Flutter
cd app
flutter run -d chrome
```

Click "Sign in with Google" → Should redirect through backend → Auto login!

### Production Test
1. Deploy backend with environment variables to Vercel
2. Deploy Flutter app to Vercel
3. Test Google Sign-In

## How It Works

```
User clicks "Sign in with Google"
    ↓
Flutter redirects to: GET /api/auth/google/login
    ↓
Backend redirects to: Google OAuth consent screen
    ↓
User authorizes on Google
    ↓
Google redirects to: GET /api/auth/google/callback
    ↓
Backend:
  - Exchanges code for access token
  - Gets user info from Google
  - Creates/updates user in database
  - Generates JWT token
    ↓
Backend redirects to: Flutter app with token
    ↓
Flutter saves token and logs in user
```

## Endpoints

| Endpoint | Purpose |
|----------|---------|
| `GET /api/auth/google/login` | Start OAuth flow |
| `GET /api/auth/google/callback` | Handle OAuth callback |

## Benefits

✅ **No Client ID in frontend** - More secure  
✅ **Client Secret stays on server** - Never exposed  
✅ **Standard OAuth 2.0 flow** - Industry best practice  
✅ **Simpler frontend** - Just redirect and handle callback  
✅ **Works everywhere** - Web, iOS, Android  

## Troubleshooting

### "redirect_uri_mismatch"
- Check `GOOGLE_REDIRECT_URI` matches Google Cloud Console exactly
- Must include full path: `/api/auth/google/callback`

### "Google OAuth not configured"
- Verify `GOOGLE_CLIENT_ID` and `GOOGLE_CLIENT_SECRET` in backend env vars
- Check they're not undefined in logs

### Not redirected back
- Check browser console for errors
- Verify `url_launcher` package installed in Flutter
- Check network tab for redirect responses

## Files Changed

✅ Backend:
- `backend/app/api/auth/google/login/route.ts` (NEW)
- `backend/app/api/auth/google/callback/route.ts` (NEW)

✅ Frontend:
- `app/lib/services/auth_service.dart` (Updated)
- `app/lib/screens/auth/login_screen.dart` (Updated)
- `app/lib/main.dart` (Updated)
- `app/pubspec.yaml` (Removed google_sign_in, added url_launcher)

## Done! 🎉

No more "Set Google Cloud ID" errors in frontend!
