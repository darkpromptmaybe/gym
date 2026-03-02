# 🚀 Deploying to Vercel

## Prerequisites
- Git repository initialized ✅
- Vercel account (sign up at [vercel.com](https://vercel.com))
- Neon database set up

## Option 1: Deploy via Vercel CLI (Recommended)

### 1. Install Vercel CLI
```bash
npm install -g vercel
```

### 2. Login to Vercel
```bash
vercel login
```

### 3. Deploy from backend folder
```bash
cd backend
vercel
```

Follow the prompts:
- Set up and deploy? **Y**
- Which scope? Select your account
- Link to existing project? **N**
- What's your project's name? **gym-auth-backend**
- In which directory is your code located? **./**
- Want to override settings? **N**

### 4. Add Environment Variables

After initial deployment, add your environment variables:

```bash
vercel env add DATABASE_URL
vercel env add NEXTAUTH_SECRET
vercel env add BETTER_AUTH_SECRET
vercel env add BETTER_AUTH_URL
```

For each variable:
- Choose environment: **Production**
- Paste the value when prompted

Example values:
- `DATABASE_URL`: Your Neon connection string
- `NEXTAUTH_SECRET`: Random 32+ character string
- `BETTER_AUTH_SECRET`: Another random 32+ character string
- `BETTER_AUTH_URL`: Your Vercel deployment URL (e.g., `https://gym-auth-backend.vercel.app`)

### 5. Redeploy with Environment Variables
```bash
vercel --prod
```

---

## Option 2: Deploy via Vercel Dashboard

### 1. Push to GitHub (if not done)

```bash
# In backend folder
git remote add origin https://github.com/your-username/gym-auth-backend.git
git branch -M main
git push -u origin main
```

### 2. Import to Vercel

1. Go to [vercel.com](https://vercel.com)
2. Click **"Add New Project"**
3. Import your Git repository
4. Configure:
   - **Framework Preset:** Next.js
   - **Root Directory:** `./`
   - **Build Command:** `next build`
   - **Output Directory:** `.next`

### 3. Add Environment Variables

In the project settings, add:

| Name | Value |
|------|-------|
| `DATABASE_URL` | Your Neon connection string |
| `NEXTAUTH_SECRET` | Random 32+ char string |
| `BETTER_AUTH_SECRET` | Another random string |
| `BETTER_AUTH_URL` | Your Vercel URL |

### 4. Deploy

Click **"Deploy"** and wait for the build to complete!

---

## After Deployment

### 1. Update Flutter App

In your Flutter app's `api_client.dart`, update the base URL:

```dart
static const String baseUrl = 'https://your-app.vercel.app/api';
```

### 2. Update BETTER_AUTH_URL

Go back to Vercel environment variables and update:
```
BETTER_AUTH_URL=https://your-actual-vercel-url.vercel.app
```

Redeploy for changes to take effect.

### 3. Test Your API

```bash
# Register a user
curl -X POST https://your-app.vercel.app/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123","name":"Test"}'

# Login
curl -X POST https://your-app.vercel.app/api/auth/sign-in \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123"}'
```

---

## Troubleshooting

### Build Fails
- Check that all dependencies are in `package.json`
- Verify TypeScript has no errors: `npm run build` locally

### Environment Variables Not Working
- Make sure you added them for **Production** environment
- Redeploy after adding variables: `vercel --prod`

### Database Connection Issues
- Verify your Neon database URL is correct
- Check that Neon database allows connections from Vercel IPs
- Neon automatically allows all connections

### CORS Errors
- Check `next.config.js` has proper CORS headers
- Update allowed origins if needed

---

## Security Checklist

Before going live:
- [ ] Strong `NEXTAUTH_SECRET` (32+ random characters)
- [ ] Strong `BETTER_AUTH_SECRET` (32+ random characters)
- [ ] Database URL secured
- [ ] CORS configured for your Flutter app domain only
- [ ] HTTPS enabled (automatic on Vercel)
- [ ] Environment variables not committed to git

---

## Continuous Deployment

Once set up, every push to your repository automatically:
1. Builds the project
2. Runs tests (if configured)
3. Deploys to production

Make changes → Commit → Push → Auto-deploy! 🚀

---

## Your Vercel URL

After deployment, your API will be available at:
```
https://your-project-name.vercel.app
```

Use this URL in your Flutter app!
