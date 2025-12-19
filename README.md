# E-Shop Pro  
**A Full-Featured E-Commerce App (Customer + Seller) – Amazon & Noon Style**

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.19-blue.svg" alt="Flutter">
  <img src="https://img.shields.io/badge/Platform-Android%20%26%20iOS-green.svg" alt="Platform">
  <img src="https://img.shields.io/badge/Status-v1.0.0%20Ready%20for%20Release-success.svg" alt="Status">
  <img src="https://img.shields.io/badge/License-MIT-blue.svg" alt="License">
</p>

# DropZ

A **modern, production‑grade E‑Commerce mobile application** built with **Flutter**.
DropZ is designed to demonstrate how a real-world shopping app is engineered: secure payments, biometric verification, scalable architecture, and clean, maintainable code.

> This project is built as a **professional portfolio showcase**, following patterns and practices used in large-scale mobile products.

---

## 🚀 What is DropZ?

DropZ simulates a complete online shopping experience — from discovering products to securely paying and contacting support — while focusing heavily on **architecture quality**, **user experience**, and **security**.

The goal is not just to make the app work, but to make it **scalable, readable, and production-ready**.

---

## ✨ Key Capabilities

* Full E‑Commerce flow (Browse → Cart → Checkout → Payment)
* Secure payments with **Paymob**
* **Biometric verification** before payment confirmation
* Light & Dark theme with persistence
* Feature‑based scalable architecture
* Clean separation of UI, state, and data layers

---

## 🧩 Features Breakdown

### Authentication

* Secure login & registration
* Token‑based session handling
* Persistent authentication state

### Product Discovery

* Home with featured products & categories
* Product listing with pagination
* Product details (images, price, description, reviews)

### Search

* Keyword-based product search
* Optimized result handling
* Empty & error state support

### Wishlist

* Save products for later
* User‑specific persistence

### Cart

* Add, remove, and update items
* Real‑time price calculation
* Persistent cart across sessions

### Checkout & Payments

* Structured checkout flow
* Address selection
* **Biometric authentication (Fingerprint / Face ID)**
* **Paymob payment gateway integration**
* Robust success & failure handling

### Address Management

* Add, edit, delete addresses
* Default address support

### Reviews System

* Product ratings & reviews
* Average rating calculation

### Profile & Settings

* User profile management
* **Light / Dark theme switching**
* Preferences persistence

### Support

* In‑app **support ticket system**
* Direct communication channel with support

---

## 🏗 Architecture

DropZ follows a **Feature‑Based Clean Architecture**, inspired by enterprise Flutter applications.

Each feature is isolated, self‑contained, and independently maintainable.

```
lib/
 ├── core/               # Shared & cross‑feature logic
 │    ├── network/       # Dio, interceptors
 │    ├── storage/       # Local persistence
 │    ├── theme/         # App theming
 │    └── widgets/       # Reusable UI components
 │
 ├── features/           # App features (vertical slices)
 │    ├── auth/
 │    ├── home/
 │    ├── products/
 │    ├── cart/
 │    ├── checkout/
 │    ├── address/
 │    ├── wishlist/
 │    ├── reviews/
 │    ├── profile/
 │    ├── settings/
 │    └── support/
 │
 └── main.dart
```

### Why this architecture?

* Easy to scale
* Easy to test
* Easy for teams to collaborate
* Avoids massive, tightly coupled codebases

---

## 🌱 Git Workflow

Development follows a **feature‑branch workflow**:

```
feature/auth
feature/home
feature/products
feature/cart
feature/checkout
feature/address
feature/reviews-system
feature/profile
feature/settings
feature/support
```

This mirrors how professional teams manage parallel development.

---

## 🛠 Tech Stack

* **Flutter / Dart**
* **Bloc / Cubit** – State management
* **Dio** – Networking & API handling
* **SharedPreferences / Hive** – Local storage
* **Paymob** – Online payments
* **Biometric Authentication** – Payment verification

---

## ▶️ Running the Project

```bash
git clone https://github.com/BugMaker69/DropZ.git
cd DropZ
flutter pub get
flutter run
```

---

## 🔮 Planned Enhancements

* Order history & tracking
* Push notifications
* Unit & widget testing
* CI/CD pipeline

---

## 👤 Author

**Omar**
Mobile Developer (Flutter & Android)

GitHub: **BugMaker69**

---

⭐ If you find this project valuable, consider giving it a star.
