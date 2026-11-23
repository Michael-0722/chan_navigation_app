# Laboratory Activity: Firebase Setup and Configuration for Flutter Web

## Student Information
- **Student Name**: Michael Chan
- **Student ID**: 555842
- **Email**: m.chan.555842@umindanao.edu.ph
- **Course & Section**: BS Information Technology / Computer Science
- **GitHub Repository**: [https://github.com/Michael-0722/chan_navigation_app](https://github.com/Michael-0722/chan_navigation_app)
- **Firebase Project Name**: Chan Student App
- **Firebase Project ID**: `chan-student-app`
- **Firebase Web App ID**: `1:374122341196:web:671f13670c5add1dd0e5e9`

---

## 1. Activity Overview & Environment Setup
This activity configures Google Firebase into an existing Flutter navigation application (`chan_navigation_app`). The application targets Google Chrome (Web) to ensure cross-platform consistency.

### Tool & Environment Versions
| Tool | Command | Version / Status |
| :--- | :--- | :--- |
| **Flutter SDK** | `flutter --version` | Flutter 3.47.7 (Channel stable) |
| **Dart SDK** | `dart --version` | Dart 3.13.5 (stable) |
| **Node.js** | `node -v` | v24.20.0 |
| **npm** | `npm -v` | 11.19.0 |
| **Firebase CLI** | `firebase --version` | 15.37.0 |
| **FlutterFire CLI** | `flutterfire --version` | 1.5.0 |
| **Operating System** | Windows 11 (25H2, windows_x64) | Developer Mode / PATH Configured |

---

## 2. Verification Table

| Check | Expected Result | Pass / Fail | Actual Output / Evidence |
| :--- | :--- | :---: | :--- |
| **`firebase --version`** | Displays a version number. | **PASS** | `15.37.0` |
| **`firebase projects:list`** | Lists your Firebase project. | **PASS** | `Chan Student App` (`chan-student-app`, ID `374122341196`) |
| **`flutterfire --version`** | Displays a version number. | **PASS** | `1.5.0` |
| **Check `pubspec.yaml`** | Contains `firebase_core`. | **PASS** | `firebase_core: ^5.2.0` under `dependencies` |
| **Check the `lib` folder** | Contains `firebase_options.dart`. | **PASS** | File generated at `lib/firebase_options.dart` |
| **Open Firebase Console** | Web app is registered in project. | **PASS** | Web App registered (`1:374122341196:web:671f13670c5add1dd0e5e9`) |
| **Run in Chrome** | Login opens without Firebase error. | **PASS** | Initialized cleanly before `runApp()`; `flutter build web` passed |
| **Test existing application** | Login and navigation still work. | **PASS** | `DemoAuth` credentials (`admin` / `admin123`) functional |

---

## 3. Guide Questions & Detailed Answers

### Question 1: What is the difference between the Firebase CLI and FlutterFire CLI?
> The Firebase CLI (`firebase-tools`) is Google's universal command-line utility for managing Firebase cloud infrastructure, hosting, deployment, and backend configurations across all supported environments. In contrast, the FlutterFire CLI (`flutterfire_cli`) is a Flutter-specific companion tool that connects Flutter projects to Firebase projects by generating platform-tailored configuration code (`firebase_options.dart`). While Firebase CLI manages cloud resources, FlutterFire CLI configures the local client application to consume those resources.

### Question 2: Why must configuration commands run inside the Flutter project root?
> Configuration commands such as `flutter pub add` and `flutterfire configure` must execute within the Flutter project root because they rely on locating `pubspec.yaml` to detect project structure, dependencies, and configured target platforms. Executing commands from the root ensures generated files—including `firebase_options.dart` in `lib/` and `firebase.json` at root—are placed into their standard directories without path corruption. Running commands in subdirectories like `lib/` fails because the tools cannot find the package manifest.

### Question 3: What is the purpose of `firebase_options.dart`?
> `firebase_options.dart` provides strongly typed, compile-time Dart configuration constants holding Firebase credentials (API Key, App ID, Messaging Sender ID, and Project ID) for each supported target platform. This eliminates the necessity of manually handling platform-specific JSON or plist files during cross-platform development. It enables the application to invoke `Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)` to dynamically apply the exact configuration matching the current runtime environment.

### Question 4: Why is Firebase initialized before `runApp()`?
> Firebase is initialized prior to `runApp()` so that core communication channels, authentication listeners, and backend services are operational before any user interface widgets are inflated and mounted. Initializing within `main()` using `await Firebase.initializeApp()` ensures asynchronous configuration finishes before screens attempt to read Firebase state. Invoking `WidgetsFlutterBinding.ensureInitialized()` beforehand guarantees Flutter's binary messaging bridge is accessible before running asynchronous native code.

### Question 5: Why does installing Firebase not automatically replace DemoAuth?
> Installing `firebase_core` and configuring Firebase merely installs the runtime SDK and establishes a cloud communication gateway; it does not alter existing Dart application logic or UI code. `DemoAuth` remains the active authentication mechanism because the login form still references `DemoAuth.login()` until developers deliberately refactor the code to call `FirebaseAuth.instance.signInWithEmailAndPassword()`. Adding Firebase infrastructure provides capabilities but does not refactor legacy local authentication workflows automatically.

---

## 4. Key Source Code

### `lib/main.dart`
```dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const StudentApp());
}

class StudentApp extends StatelessWidget {
  const StudentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Navigation App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
        ),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
```

### `lib/firebase_options.dart` (Web Platform Configuration)
```dart
// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    // ...
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSy...',
    appId: '1:374122341196:web:671f13670c5add1dd0e5e9',
    messagingSenderId: '374122341196',
    projectId: 'chan-student-app',
    authDomain: 'chan-student-app.firebaseapp.com',
    storageBucket: 'chan-student-app.firebasestorage.app',
  );
}
```

---

## 5. Automated Verification & Use Case Test Results
An automated test suite was implemented in `test/widget_test.dart` to validate Firebase options, login rendering, DemoAuth authentication, and page navigation.

```text
00:00 +0: loading C:/Users/micha/Desktop/Flutter/chan_navigation_app/test/widget_test.dart
00:00 +0: Laboratory Activity 8 - Firebase & App Use Case Tests Use Case 1: Firebase Options Configuration Check
00:00 +1: Laboratory Activity 8 - Firebase & App Use Case Tests Use Case 2: Login Screen Renders Successfully
00:00 +2: Laboratory Activity 8 - Firebase & App Use Case Tests Use Case 3: DemoAuth Successful Login Navigates to Dashboard
00:01 +3: Laboratory Activity 8 - Firebase & App Use Case Tests Use Case 4: Navigation through Calculator, Social, and Profile
00:02 +4: All tests passed!
```

---

## 6. Checklist of Screenshots Required for PDF
1. **CLI Versions & Authentication**:
   - Terminal showing `firebase --version` (`15.37.0`) and `flutterfire --version` (`1.5.0`).
   - Terminal showing `firebase projects:list` displaying `Chan Student App`.
2. **Firebase Console**:
   - Screenshot of the **Project Settings -> General** page showing Project Name (`Chan Student App`), Project ID (`chan-student-app`), and registered Web App (`1:374122341196:web:...`).
3. **VS Code Project Explorer**:
   - Explorer sidebar showing `lib/firebase_options.dart` and `firebase.json`.
4. **Code Editor**:
   - `lib/main.dart` showing `WidgetsFlutterBinding.ensureInitialized()` and `Firebase.initializeApp(...)`.
5. **Application Running in Chrome**:
   - Browser showing the Login screen running on `localhost`.
   - Browser showing successful login to Dashboard with `admin` credentials.
