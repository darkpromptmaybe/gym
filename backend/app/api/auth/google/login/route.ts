import { NextRequest, NextResponse } from 'next/server';

// Google OAuth 2.0 configuration
const GOOGLE_CLIENT_ID = process.env.GOOGLE_CLIENT_ID;
const GOOGLE_REDIRECT_URI = process.env.GOOGLE_REDIRECT_URI || 'http://localhost:3000/api/auth/google/callback';

export async function GET(request: NextRequest) {
  if (!GOOGLE_CLIENT_ID) {
    return NextResponse.json(
      { error: 'Google OAuth not configured. Please set GOOGLE_CLIENT_ID in environment variables.' },
      { status: 500 }
    );
  }

  // Get the redirect URL from query params (where to send user after auth)
  const searchParams = request.nextUrl.searchParams;
  const redirectUrl = searchParams.get('redirect') || 'http://localhost:54321';

  // Build Google OAuth URL
  const googleAuthUrl = new URL('https://accounts.google.com/o/oauth2/v2/auth');
  googleAuthUrl.searchParams.set('client_id', GOOGLE_CLIENT_ID);
  googleAuthUrl.searchParams.set('redirect_uri', GOOGLE_REDIRECT_URI);
  googleAuthUrl.searchParams.set('response_type', 'code');
  googleAuthUrl.searchParams.set('scope', 'openid email profile');
  googleAuthUrl.searchParams.set('access_type', 'offline');
  googleAuthUrl.searchParams.set('prompt', 'select_account');
  googleAuthUrl.searchParams.set('state', redirectUrl); // Store redirect URL in state

  // Redirect user to Google
  return NextResponse.redirect(googleAuthUrl.toString());
}
