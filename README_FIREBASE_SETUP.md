# Firebase Setup Instructions

## Prerequisites
1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Enable Authentication and Firestore Database in your Firebase project

## Setup Steps

### 1. Firebase Project Configuration
1. Go to Firebase Console and create a new project
2. Enable **Authentication** service
3. Enable **Email/Password** sign-in method in Authentication > Sign-in method
4. Enable **Firestore Database** in Database section

### 2. Android Configuration
1. In Firebase Console, add an Android app to your project
2. Use package name: `com.example.brightsprings_ads`
3. Download the `google-services.json` file
4. Place it in `android/app/` directory (replace the template file)

### 3. iOS Configuration (Optional)
1. In Firebase Console, add an iOS app to your project
2. Use bundle ID: `com.example.brightspringsAds`
3. Download the `GoogleService-Info.plist` file
4. Add it to your iOS project in Xcode

### 4. Firestore Security Rules
Add these rules to your Firestore Database:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read and write their own user document
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Allow authenticated users to read/write their own data
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

### 5. Test User Accounts
Create test accounts for each role:
- Parent: `parent@test.com` / `password123`
- Child: `child@test.com` / `password123`  
- Psychologist: `psychologist@test.com` / `password123`

## Running the App
1. Run `flutter pub get` to install dependencies
2. Run `flutter run` to start the app
3. Test authentication with different user roles

## Troubleshooting
- Ensure `google-services.json` is in the correct location
- Check that Firebase project has Authentication and Firestore enabled
- Verify package name matches in Firebase Console and `android/app/build.gradle`
