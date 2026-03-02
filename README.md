# 💪 Gym App

Full-stack gym management application with authentication, user profiles, and cross-platform support.

## 🚀 Live Demo

- **Backend API**: https://gym-backend-two-bay.vercel.app
- **Web App**: Open `app/index.html` in your browser

## 📁 Project Structure

```
gym/
├── app/                    # Web application
│   ├── index.html         # Single-page web app with auth
│   └── API_INTEGRATION.md # API documentation and examples
├── backend/               # Next.js backend API
│   ├── app/api/          # API routes
│   ├── lib/              # Database and auth utilities
│   ├── scripts/          # Helper scripts
│   └── middleware.ts     # JWT authentication middleware
└── README.md
```

## ✨ Features

### Backend API
- ✅ Email/Password Authentication
- ✅ Google OAuth Sign-In (setup required)
- ✅ JWT Token-based Authentication
- ✅ User Registration & Login
- ✅ Token Verification
- ✅ User Profile Management
- ✅ PostgreSQL Database (Neon)
- ✅ Secure Password Hashing
- ✅ Automated API Testing

### Web App
- ✅ Beautiful Gradient UI
- ✅ Sign In / Sign Up Forms
- ✅ User Profile Display
- ✅ Local Storage for Session
- ✅ Google Sign-In Button (ready for OAuth)
- ✅ Responsive Design
- ✅ Real-time Form Validation

## 🛠️ Tech Stack

**Backend:**
- Next.js 14
- TypeScript
- Neon PostgreSQL
- Better Auth
- JWT (jsonwebtoken)
- bcryptjs
- Vercel (hosting)

**Web App:**
- HTML5
- CSS3 (Gradient UI)
- Vanilla JavaScript
- Fetch API

## 🚀 Quick Start

### Backend Setup

1. **Install dependencies:**
   ```bash
   cd backend
   npm install
   ```

2. **Set up environment variables:**
   Create `.env` file:
   ```env
   DATABASE_URL=your_neon_database_url
   DATABASE_URL_UNPOOLED=your_neon_unpooled_url
   NEXTAUTH_SECRET=your_secret_key
   BETTER_AUTH_SECRET=your_secret_key
   BETTER_AUTH_URL=https://gym-backend-two-bay.vercel.app
   GOOGLE_CLIENT_ID=your_google_client_id
   GOOGLE_CLIENT_SECRET=your_google_client_secret
   ```

3. **Run database migration:**
   ```bash
   npm run migrate
   ```

4. **Start development server:**
   ```bash
   npm run dev
   ```

5. **Test the API:**
   ```bash
   npm run test-api
   ```

### Web App Setup

1. **Open the web app:**
   ```bash
   cd app
   # Open index.html in your browser
   # Or use a local server:
   python -m http.server 8000
   # Then visit: http://localhost:8000
   ```

2. **Use the app:**
   - Sign up with email/password
   - Sign in to your account
   - View your profile
   - Sign out

## 📚 API Documentation

See [app/API_INTEGRATION.md](app/API_INTEGRATION.md) for complete API documentation and integration examples.

### Quick API Reference

**Base URL:** `https://gym-backend-two-bay.vercel.app`

- `POST /api/auth/register` - Register new user
- `POST /api/auth/sign-in` - Sign in with email/password
- `POST /api/auth/google` - Sign in with Google
- `GET /api/auth/verify` - Verify JWT token
- `GET /api/data/profile` - Get user profile (requires auth)

## 🔧 Available Scripts

### Backend Scripts

```bash
npm run dev         # Start development server
npm run build       # Build for production
npm run start       # Start production server
npm run migrate     # Run database migrations
npm run test-api    # Test all API endpoints
npm run add-env     # Sync .env to vercel.json
```

## 🔐 Google OAuth Setup

See [backend/GOOGLE_OAUTH_SETUP.md](backend/GOOGLE_OAUTH_SETUP.md) for detailed instructions on setting up Google Sign-In.

## 🚀 Deployment

### Backend (Vercel)

1. **Deploy to Vercel:**
   ```bash
   cd backend
   vercel deploy --prod
   ```

2. **Set environment variables in Vercel dashboard**

### Web App

Deploy to any static hosting:
- GitHub Pages
- Netlify
- Vercel
- Firebase Hosting

## 📝 Database Schema

```sql
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255),
  name VARCHAR(255),
  photo_url TEXT,
  google_id VARCHAR(255) UNIQUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## 🧪 Testing

Run comprehensive API tests:
```bash
cd backend
npm run test-api
```

Tests include:
- ✅ User Registration
- ✅ Duplicate Email Prevention
- ✅ Sign In with Wrong Password
- ✅ Sign In with Correct Credentials
- ✅ Token Verification
- ✅ Google OAuth
- ✅ Protected Routes

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

MIT License

## 🔗 Links

- **GitHub**: https://github.com/darkpromptmaybe/gym
- **Backend Repo**: https://github.com/darkpromptmaybe/gym-backend
- **Live API**: https://gym-backend-two-bay.vercel.app

## 👨‍💻 Author

darkpromptmaybe

---

Made with ❤️ and 💪
