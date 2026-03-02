# Gym App API Integration

## Backend API

**Base URL:** `https://gym-backend-two-bay.vercel.app`

## Endpoints

### Authentication

#### Register New User
```
POST /api/auth/register
Content-Type: application/json

Body:
{
  "email": "user@example.com",
  "password": "your_password",
  "name": "Your Name"  // optional
}

Response:
{
  "success": true,
  "data": {
    "id": "1",
    "email": "user@example.com",
    "name": "Your Name",
    "photo_url": null,
    "access_token": "jwt_token_here"
  }
}
```

#### Sign In
```
POST /api/auth/sign-in
Content-Type: application/json

Body:
{
  "email": "user@example.com",
  "password": "your_password"
}

Response:
{
  "success": true,
  "data": {
    "id": "1",
    "email": "user@example.com",
    "name": "Your Name",
    "photo_url": null,
    "access_token": "jwt_token_here"
  }
}
```

#### Google OAuth Sign In
```
POST /api/auth/google
Content-Type: application/json

Body:
{
  "email": "user@gmail.com",
  "google_id": "google_user_id",
  "name": "Your Name",
  "photo_url": "https://..."  // optional
}

Response:
{
  "success": true,
  "data": {
    "id": "1",
    "email": "user@gmail.com",
    "name": "Your Name",
    "photo_url": "https://...",
    "access_token": "jwt_token_here"
  }
}
```

#### Verify Token
```
GET /api/auth/verify
Authorization: Bearer {access_token}

Response:
{
  "success": true,
  "data": {
    "id": "1",
    "email": "user@example.com",
    "name": "Your Name"
  }
}
```

### User Data

#### Get Profile
```
GET /api/data/profile
Authorization: Bearer {access_token}

Response:
{
  "success": true,
  "data": {
    "id": "1",
    "email": "user@example.com",
    "name": "Your Name",
    "photo_url": null,
    "created_at": "2026-03-02T..."
  }
}
```

## Error Responses

All error responses follow this format:
```json
{
  "error": "Error message here"
}
```

Common status codes:
- `200` - Success
- `201` - Created (for registration)
- `400` - Bad Request (missing fields)
- `401` - Unauthorized (invalid credentials or token)
- `409` - Conflict (email already exists)
- `500` - Internal Server Error

## Flutter Integration Example

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://gym-backend-two-bay.vercel.app';
  
  // Sign In
  static Future<Map<String, dynamic>> signIn(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/sign-in'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    return jsonDecode(response.body);
  }
  
  // Register
  static Future<Map<String, dynamic>> register(String email, String password, String name) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password, 'name': name}),
    );
    return jsonDecode(response.body);
  }
  
  // Get Profile
  static Future<Map<String, dynamic>> getProfile(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/data/profile'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return jsonDecode(response.body);
  }
  
  // Verify Token
  static Future<Map<String, dynamic>> verifyToken(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/auth/verify'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return jsonDecode(response.body);
  }
}
```

## Web App

Open `app/index.html` in a browser to test the web interface.

To serve locally:
```bash
# Using Python
python -m http.server 8000

# Using Node.js
npx http-server

# Then open: http://localhost:8000/app/
```

## Testing

Run the API test suite:
```bash
cd backend
npm run test-api
```
