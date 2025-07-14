# Expense Tracker - Authentication System

## Overview

This Flutter app includes a complete authentication system with login, registration, and JWT token management.

## Features

- ✅ **User Registration** - Create new accounts with username, email, and password
- ✅ **User Login** - Secure authentication with JWT tokens
- ✅ **JWT Token Storage** - Automatic token persistence using SharedPreferences
- ✅ **Role-based Access** - Support for different user roles (ADMIN, USER)
- ✅ **Beautiful UI** - Modern gradient design with Material Design 3
- ✅ **Form Validation** - Client-side validation for all input fields
- ✅ **Loading States** - Smooth loading indicators during authentication
- ✅ **Error Handling** - User-friendly error messages
- ✅ **Auto-login** - Automatic login if valid token exists

## Project Structure

```
lib/
├── models/
│   └── user.dart              # User and AuthResponse models
├── services/
│   └── auth_service.dart      # Authentication API calls and token management
├── providers/
│   └── auth_provider.dart     # State management for authentication
├── screens/
│   ├── splash_screen.dart     # App loading screen
│   ├── login_screen.dart      # User login interface
│   ├── register_screen.dart   # User registration interface
│   └── home_screen.dart       # Main app screen after login
└── main.dart                  # App entry point with Provider setup
```

## Dependencies

The following packages are used for authentication:

```yaml
dependencies:
  http: ^1.1.0                    # HTTP requests for API calls
  shared_preferences: ^2.2.2      # JWT token storage
  provider: ^6.1.1                # State management
  form_validator: ^2.1.1          # Form validation
  flutter_spinkit: ^5.2.0         # Loading indicators
```

## API Endpoints

The app expects the following Spring Boot API endpoints:

### Authentication Endpoints
- `POST /api/auth/login` - User login
- `POST /api/auth/register` - User registration

### Request/Response Format

**Login Request:**
```json
{
  "username": "user123",
  "password": "password123"
}
```

**Register Request:**
```json
{
  "username": "user123",
  "email": "user@example.com",
  "password": "password123"
}
```

**Success Response:**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": 1,
    "username": "user123",
    "email": "user@example.com",
    "role": "USER",
    "createdAt": "2024-01-01T00:00:00Z"
  }
}
```

## Configuration

### Backend URL
Update the backend URL in `lib/services/auth_service.dart`:

```dart
static const String baseUrl = 'http://your-backend-url:8080/api';
```

### JWT Token Storage
Tokens are automatically stored in device storage using SharedPreferences:
- Token key: `jwt_token`
- User data key: `user_data`

## Usage

### Running the App

1. Install dependencies:
```bash
flutter pub get
```

2. Run the app:
```bash
flutter run
```

### Authentication Flow

1. **App Launch**: Shows splash screen while checking for existing tokens
2. **Token Check**: If valid token exists, user is automatically logged in
3. **Login Screen**: If no token, user sees login screen
4. **Registration**: Users can navigate to registration screen
5. **Home Screen**: After successful authentication, user sees main app

### State Management

The app uses Provider for state management:
- `AuthProvider` manages authentication state
- Automatically handles loading states and error messages
- Provides methods for login, register, and logout

## Security Features

- **Password Validation**: Minimum 6 characters required
- **Email Validation**: Proper email format validation
- **Token Persistence**: Secure token storage in device
- **Auto-logout**: Token removal on logout
- **Error Handling**: Secure error messages without exposing sensitive data

## UI/UX Features

- **Modern Design**: Gradient backgrounds and Material Design 3
- **Responsive Layout**: Works on different screen sizes
- **Loading States**: Smooth loading indicators
- **Form Validation**: Real-time validation feedback
- **Error Messages**: Clear, user-friendly error display
- **Navigation**: Smooth transitions between screens

## Next Steps

The authentication system is ready for integration with:
- Expense management screens
- Category management
- Budget tracking
- Analytics and reporting
- Role-based feature access

## Troubleshooting

### Common Issues

1. **Network Error**: Check if backend server is running and accessible
2. **Token Issues**: Clear app data or reinstall to reset tokens
3. **Validation Errors**: Ensure all required fields are filled correctly

### Debug Mode

Enable debug mode to see detailed error messages and API responses. 