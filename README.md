# 📱 TotalX Task — User Management App

A scalable Flutter application demonstrating **user management, OTP authentication, and clean architecture principles** using **BLoC state management**. Built as a technical assessment for **TotalX**.

---

## 🚀 Key Highlights

* Clean Architecture (feature-first modular structure)
* BLoC state management (predictable state handling)
* OTP-based authentication using MSG91 (mock supported)
* Lazy loading with pagination
* Search and filtering
* Local persistence using Hive
* Dependency injection using GetIt

---

## 📱 Features

| Feature          | Details                                                |
| ---------------- | ------------------------------------------------------ |
| **OTP Login**    | MSG91-based mobile authentication (mock mode included) |
| **Add User**     | Name, Phone, Age, and profile image                    |
| **Search**       | Real-time search with debounce                         |
| **Sort by Age**  | Elder (≥60) / Younger (<60)                            |
| **Lazy Loading** | Pagination (10 users per page)                         |

---

## 🧱 Architecture — Clean Architecture

```
lib/
├── core/               → constants, theme, router, utils
├── features/
│   ├── auth/           → data, domain, presentation
│   └── users/          → data, domain, presentation
├── injection_container.dart
└── main.dart
```

---

## 🧠 State Management

* `flutter_bloc` (BLoC pattern)
* Separate `Bloc`, `Event`, and `State` files per feature
* `MultiBlocProvider` at the app root

---

## 🛠️ Tech Stack

| Package          | Purpose                        |
| ---------------- | ------------------------------ |
| `flutter_bloc`   | BLoC state management          |
| `hive_flutter`   | Local persistence              |
| `get_it`         | Dependency injection           |
| `go_router`      | Declarative navigation         |
| `image_picker`   | Camera / Gallery image upload  |
| `google_fonts`   | Poppins typography             |
| `uuid`           | Unique user ID generation      |

---

## ⚙️ Setup

```bash
flutter pub get
flutter run
```

---

## 📌 Notes

* OTP is mocked using `123456` for testing
* MSG91 integration can be enabled by setting `useMockOtp = false` in `app_constants.dart` and providing a real `widgetId` and `authToken`

---

## 📈 Development Approach

* Incremental commits reflecting real development progression
* Feature-based modular development
* Clean and maintainable code structure

---

## 📋 Requirements Coverage

- ✅ Mobile Authentication (MSG91 OTP)
- ✅ Add User (Name, Phone, Age, Image)
- ✅ Search by Name or Phone
- ✅ Sort by Age Category (Elder / Younger)
- ✅ Lazy Loading
- ✅ Clean Architecture
- ✅ BLoC State Management
- ✅ Multiple Git Commits

---

## 👨‍💻 Author

**Safuvan M M**
