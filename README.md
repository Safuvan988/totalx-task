# TotalX Task — User Management App

A Flutter application built as a technical assessment for **TotalX**. It demonstrates Clean Architecture, BLoC state management, MSG91 OTP authentication, local persistence with Hive, and lazy-loading user lists.

---

## 📱 Features

| Feature | Details |
|---|---|
| **OTP Login** | MSG91-based mobile authentication (mock mode included for testing) |
| **Add User** | Name, Phone, Age, and profile image (camera/gallery) |
| **Search** | Real-time search by name or phone with 300ms debounce |
| **Sort by Age** | All / Elder (≥ 60) / Younger (< 60) filter via bottom sheet |
| **Lazy Loading** | Paginated user list (10 per page), auto-fetches next page on scroll |

---

## 🏗️ Architecture — Clean Architecture (Feature-First)

```
lib/
├── core/
│   ├── constants/      # AppColors, AppConstants (MSG91 keys, page size)
│   ├── errors/         # Failure classes
│   ├── router/         # GoRouter configuration
│   ├── theme/          # AppTheme (Poppins, colour palette)
│   └── utils/          # Validators, phone formatter
│
├── features/
│   ├── auth/
│   │   ├── data/       # MSG91 datasource + AuthRepositoryImpl
│   │   ├── domain/     # AuthEntity, AuthRepository, SendOtp/VerifyOtp usecases
│   │   └── presentation/ # AuthBloc + PhoneInputPage + OtpVerifyPage
│   │
│   └── users/
│       ├── data/       # Hive UserModel + UserLocalDataSource + UserRepositoryImpl
│       ├── domain/     # UserEntity, UserRepository, GetUsers/AddUser/Search/Sort usecases
│       └── presentation/ # UserBloc + UserListPage + AddUserSheet + SortSheet
│
├── injection_container.dart   # GetIt service locator
└── main.dart
```

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Language | Dart / Flutter |
| State Management | **flutter_bloc** (BLoC pattern) |
| Architecture | **Clean Architecture** |
| Navigation | **go_router** |
| DI | **get_it** |
| Local DB | **Hive** (with Hive Flutter) |
| OTP Auth | **MSG91** (`sendotp_flutter_sdk` — mock mode) |
| Image Picker | **image_picker** |
| Fonts | **Google Fonts** (Poppins) |

---

## 🚀 Getting Started

### 1. Install dependencies
```bash
flutter pub get
```

### 2. Run the app
```bash
flutter run
```

### 3. Test OTP login (mock mode)
- Enter any 10-digit phone number → tap **Get OTP**
- On the OTP screen type **`123456`** → tap **Verify**
- You will land on the User List screen

> **To use real MSG91:** Open `lib/core/constants/app_constants.dart`, set `useMockOtp = false`, and fill in your `msg91WidgetId` + `msg91AuthToken`.

---

## 📦 Commit History

The repository has **15 commits** showing the full incremental development process:

1. `chore: initial Flutter project scaffold`
2. `chore: add all dependencies to pubspec.yaml`
3. `feat(core): add theme, constants, router, validators, and failure classes`
4. `feat(auth): implement domain layer - AuthEntity, repository, use cases`
5. `feat(auth): add MSG91 remote datasource with mock OTP fallback`
6. `feat(auth): build AuthBloc with OTP event handlers and state transitions`
7. `feat(auth): create phone input page with custom numeric keypad`
8. `feat(auth): create OTP verification page with countdown timer`
9. `feat(users): implement user domain layer - entity, repository, use cases`
10. `feat(users): add Hive UserModel, UserLocalDataSource, and UserRepositoryImpl`
11. `feat(users): build UserBloc with lazy loading, search, and sort`
12. `feat(users): create user list page with lazy scroll, search, and sort trigger`
13. `feat(users): add AddUser bottom sheet and Sort bottom sheet`
14. `feat: wire up GetIt DI, initialize Hive in main.dart`
15. `docs: add comprehensive README`

---

## 📋 Requirements Coverage

- [x] Mobile Authentication via MSG91 OTP
- [x] Add User (Name, Phone, Age, Image)
- [x] Search by Name or Phone
- [x] Sort by Age Category (Elder ≥ 60 / Younger < 60)
- [x] BLoC State Management
- [x] Clean Architecture
- [x] Lazy Loading for user list
- [x] Multiple commits showing development process
- [x] Clean and well-structured code
