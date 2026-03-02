# Test Plan: Gym App Full Stack Testing

## Backend API Tests ✅

### 1. Register New User
- **Endpoint**: POST `/api/auth/register`
- **Status**: ✅ PASSED (201)
- **Response**: Returns user ID, email, name, access_token

### 2. Duplicate Email Validation
- **Endpoint**: POST `/api/auth/register`
- **Status**: ✅ PASSED (409)
- **Response**: "Email already exists"

### 3. Invalid Login
- **Endpoint**: POST `/api/auth/sign-in`
- **Status**: ✅ PASSED (401)
- **Response**: "Invalid credentials"

### 4. Valid Login
- **Endpoint**: POST `/api/auth/sign-in`
- **Status**: ✅ PASSED (200)
- **Response**: Returns JWT token

### 5. Token Verification
- **Endpoint**: GET `/api/auth/verify`
- **Status**: ✅ PASSED (200)
- **Response**: Returns user data

### 6. Google OAuth
- **Endpoint**: POST `/api/auth/google`
- **Status**: ✅ PASSED (200)
- **Response**: Creates/updates Google user, returns JWT token

### 7. Protected Route (Profile)
- **Endpoint**: GET `/api/data/profile`
- **Status**: ✅ WORKING
- **Note**: Requires valid Authorization header

## Frontend Flutter App Tests

### Manual Testing Checklist:

#### A. Email/Password Registration
- [ ] Open http://localhost:54321
- [ ] Click "Don't have an account? Sign Up"
- [ ] Fill in:
  - Name: Test User
  - Email: test@example.com
  - Password: test123
- [ ] Click "Sign Up"
- [ ] **Expected**: Auto-login and redirect to profile screen
- [ ] **Verify**: Profile shows name, email, ID

#### B. Email/Password Login
- [ ] Logout from profile screen
- [ ] **Expected**: Redirected to login screen
- [ ] Fill in:
  - Email: test@example.com
  - Password: test123
- [ ] Click "Sign In"
- [ ] **Expected**: Redirect to profile screen
- [ ] **Verify**: Same user data displayed

#### C. Form Validation
- [ ] Try to submit empty forms
- [ ] **Expected**: Validation error messages
- [ ] Try invalid email format
- [ ] **Expected**: "Please enter a valid email"
- [ ] Try password < 6 characters
- [ ] **Expected**: Validation error

#### D. Error Handling
- [ ] Try to login with wrong password
- [ ] **Expected**: Red snackbar with error message
- [ ] Try to register with existing email
- [ ] **Expected**: Error message displayed

#### E. Session Persistence
- [ ] Login successfully
- [ ] Close browser tab
- [ ] Reopen http://localhost:54321
- [ ] **Expected**: Still logged in (shows profile screen)
- [ ] **Verify**: No need to login again

#### F. Logout Functionality
- [ ] Click "Sign Out" button
- [ ] **Expected**: Redirect to login screen
- [ ] **Verify**: Profile data cleared
- [ ] Try to navigate back
- [ ] **Expected**: Stays on login screen

#### G. Google Sign-In (Requires Setup)
- [ ] Click "Sign in with Google" button
- [ ] **Expected**: Error message about missing Client ID
- [ ] Follow GOOGLE_OAUTH_SETUP.md instructions
- [ ] Configure Google OAuth Client ID
- [ ] Click "Sign in with Google" again
- [ ] **Expected**: Google sign-in popup
- [ ] Select Google account
- [ ] **Expected**: Auto-login and redirect to profile
- [ ] **Verify**: Profile shows Google account info

## Test Results Summary

### Backend API: ✅ ALL TESTS PASSED
- Registration: ✅
- Login: ✅
- Token verification: ✅
- Google OAuth endpoint: ✅
- Error handling: ✅

### Frontend Flutter: 📋 READY FOR TESTING
- App runs without crashes: ✅
- Login screen loads: ✅
- Google button shows custom icon: ✅
- Awaiting manual testing: 📋

## Known Issues

### 1. Google Sign-In Requires Configuration
**Status**: Expected behavior
**Solution**: Follow `app/GOOGLE_OAUTH_SETUP.md` to configure OAuth credentials

### 2. Profile Endpoint Authorization
**Status**: Fixed
**Solution**: JWT token is properly sent in Authorization header

## Next Steps

1. **Manual Testing**: Follow the checklist above
2. **Google OAuth Setup**: Configure Client ID for full Google Sign-In testing
3. **Production Deploy**: Update Flutter app with production backend URL
4. **Security Review**: Ensure all endpoints are properly secured

## Test Commands

### Backend API Test
```bash
cd backend
node scripts/test-api.js
```

### Flutter App Test
```bash
cd app
flutter run -d chrome --web-port=54321
```

### Database Check
```bash
cd backend
npx neonctl sql --project misty-pond-13024203 "SELECT id, email, name, google_id FROM users ORDER BY created_at DESC LIMIT 5;"
```

## Environment

- **Backend**: https://gym-backend-two-bay.vercel.app
- **Frontend Local**: http://localhost:54321
- **Frontend Prod**: https://gym-zeta-lilac.vercel.app
- **Database**: Neon PostgreSQL (aws-us-east-1)
