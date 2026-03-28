<p align="center">
 <img width="1920" height="960" alt="Cover" src="https://github.com/user-attachments/assets/345a2c8c-08c1-40a4-9577-a0da274612ac" />

</p>

<h1 align="center">AthirCare - Doctor Appointment App</h1>

<p align="center">
  A comprehensive doctor appointment booking application built with Flutter, featuring doctor discovery, specialization filtering, appointment scheduling, and user profile management.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.7+-blue?logo=flutter" alt="Flutter"/>
  <img src="https://img.shields.io/badge/Dart-3.7+-blue?logo=dart" alt="Dart"/>
  <img src="https://img.shields.io/badge/Architecture-Clean+MVVM-green" alt="Architecture"/>
  <img src="https://img.shields.io/badge/State-Cubit/BLoC-purple" alt="State Management"/>
</p>

---

## Screenshots

| Onboarding | Home | Explore | Filter |
|:---:|:---:|:---:|:---:|
| Splash & Get Started | Specializations & Doctors | Search & Doctor List | Speciality Filter |

| Doctor Detail | Book Appointment | My Appointments | Profile |
|:---:|:---:|:---:|:---:|
| About, Location, Reviews | Date, Time & Payment | Upcoming & Past | Personal Info & Settings |

---

## Features

- **Onboarding** — Welcome screen with app introduction
- **Authentication** — Login & Sign Up with form validation
- **Home Dashboard** — Doctor specializations, recommendation list
- **Explore Doctors** — Search doctors by name, filter by specialization
- **Doctor Details** — About, location, and reviews tabs
- **Appointment Booking** — Multi-step booking with date/time selection and payment summary
- **My Appointments** — View upcoming and past appointments, reschedule
- **Profile Management** — View/edit personal information, medical ID, logout
- **Biometric Auth** — Local authentication support via `local_auth`
- **Secure Storage** — Token & sensitive data stored with `flutter_secure_storage`
- **Native Splash Screen** — Custom branded splash for Android & iOS

---

## Architecture

The project follows **Clean Architecture** with **MVVM** pattern using **BLoC (Cubit)** for state management.

```
lib/
├── core/                          # Shared app-wide utilities
│   ├── di/                        # Dependency Injection (GetIt)
│   ├── helpers/                   # Extensions, validators, constants
│   ├── networking/                # Dio, Retrofit, API error handling
│   ├── routing/                   # Named routes & AppRouter
│   ├── theming/                   # Colors, typography, font weights
│   └── widgets/                   # Reusable UI components
│
├── features/                      # Feature modules
│   ├── onboarding/                # Welcome & get started
│   ├── login/                     # Login flow
│   ├── sign_up/                   # Registration flow
│   ├── main_layout/               # Bottom navigation shell
│   ├── home/                      # Dashboard with specializations
│   ├── explore/                   # Doctor search, filter, details
│   ├── booking/                   # Appointment booking flow
│   ├── my_appointments/           # Appointment history & reschedule
│   └── profile/                   # User profile & settings
│
├── doc_app.dart                   # App root widget
├── main_development.dart          # Development entry point
└── main_production.dart           # Production entry point
```

### Each Feature Module

```
feature/
├── data/
│   ├── data_sources/              # Retrofit API service
│   ├── models/                    # Request/Response models (json_serializable)
│   └── repos/                     # Repository (ApiResult<T> pattern)
├── logic/
│   └── cubit/                     # Cubit + Freezed states
└── ui/
    ├── feature_screen.dart        # Main screen
    └── widgets/                   # Feature-specific widgets
```

---

## Tech Stack

| Category | Technology |
|---|---|
| **Framework** | Flutter 3.7+ |
| **Language** | Dart 3.7+ |
| **State Management** | flutter_bloc (Cubit) |
| **Immutable States** | Freezed |
| **Networking** | Dio + Retrofit |
| **Serialization** | json_serializable + json_annotation |
| **Dependency Injection** | GetIt |
| **Routing** | Navigator 1.0 (named routes) |
| **Responsive UI** | flutter_screenutil |
| **Secure Storage** | flutter_secure_storage |
| **Biometrics** | local_auth |
| **Local Storage** | shared_preferences |
| **Image Handling** | cached_network_image, image_picker |
| **UI Components** | google_nav_bar, shimmer, flutter_svg, easy_date_timeline |
| **Splash** | flutter_native_splash |
| **Font** | Poppins (Regular, Medium, Bold) |

---

## Getting Started

### Prerequisites

- Flutter SDK `>=3.7.0`
- Dart SDK `>=3.7.0`
- Android Studio / VS Code
- Android SDK (minSdk 21, targetSdk 34)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/doc_app.git
   cd doc_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run code generation**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Generate splash screen**
   ```bash
   dart run flutter_native_splash:create
   ```

5. **Run the app**
   ```bash
   # Development
   flutter run --flavor development -t lib/main_development.dart

   # Production
   flutter run --flavor production -t lib/main_production.dart
   ```

---

## Build Flavors

| Flavor | App Name | Application ID |
|---|---|---|
| Development | Doctor Development | `com.example.doctor.development` |
| Production | Doctor | `com.example.doctor.production` |

---

## API

The app communicates with the **VCare API**:

| Endpoint | Method | Description |
|---|---|---|
| `auth/login` | POST | User login |
| `auth/register` | POST | User registration |
| `auth/logout` | POST | User logout |
| `user/profile` | GET | Get user profile |
| `user/update` | POST | Update user profile |
| `home/index` | GET | Home screen data |
| `specialization/index` | GET | List all specializations |
| `doctor/index` | GET | List all doctors |
| `doctor/doctor-search` | GET | Search doctors by name |
| `doctor/doctor-filter` | GET | Filter doctors by specialization |
| `appointment/store` | POST | Book an appointment |
| `appointment/index` | GET | Get user appointments |

---

## Project Structure Highlights

- **API Error Handling** — Centralized `ErrorHandler` with `ApiResult<T>` (Success/Failure) union type using Freezed
- **Dio Factory** — Singleton Dio instance with auth token interceptor and pretty logging
- **Responsive Design** — Custom responsive helpers + ScreenUtil for adaptive UI
- **Shimmer Loading** — Skeleton loading states across all list screens
- **Debounced Search** — 500ms debounce on doctor search to minimize API calls
- **Filter System** — Bottom sheet with specialization chips, fetched from API
- **Cross-Feature Navigation** — Tapping a speciality on Home navigates to Explore with active filter

---

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## License

This project is for educational and portfolio purposes.
