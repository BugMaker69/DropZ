# E-Shop Pro  
**A Full-Featured E-Commerce App (Customer + Seller) – Amazon & Noon Style**

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.19-blue.svg" alt="Flutter">
  <img src="https://img.shields.io/badge/Platform-Android%20%26%20iOS-green.svg" alt="Platform">
  <img src="https://img.shields.io/badge/Status-v1.0.0%20Ready%20for%20Release-success.svg" alt="Status">
  <img src="https://img.shields.io/badge/License-MIT-blue.svg" alt="License">
</p>

---

## Key Features

| Role | Features |
|------|---------|
| **Customer** | Login / Register – Home – Search – Products – Reviews – Cart – Wishlist – Edit Profile |
| **Seller** | Add Product – Edit Product – Delete Product – Seller Dashboard |
| **System** | Offline Support – Real-time Updates – Role-based Routing – Multi-language (EN/AR) |

---

## Screens & Features

| Screen | Features |
|-------|--------|
| **Splash** | Smart loading + network detection + role-based navigation |
| **Login / Register** | Email & password validation + session persistence |
| **Home** | Featured products + categories + image slider |
| **Search** | Instant search + filtering |
| **Products List** | Grid/List view + rating + add to cart/wishlist |
| **Product Details** | Image gallery + description + average rating + reviews + "Add to Cart" |
| **Reviews** | Add review (stars + comment ≥8 chars) – Edit – Delete – Real-time update |
| **Cart** | Add/Remove/Update quantity – Subtotal – Real-time sync |
| **Wishlist** | Heart icon toggle – Real-time update – Success messages |
| **Edit Profile** | Update photo, name, email, phone |
| **Seller: Add Product** | Upload images – title – price – description – stock |
| **Seller: Edit/Delete Product** | Full edit – permanent delete |
| **Offline Mode** | "No Internet" banner – Show cached data – Retry button |

---

## Tech Stack

```yaml
Flutter: 3.19.0
Dart: 3.3.0
State Management: Bloc + Cubit
Routing: GoRouter
API: Dio + Interceptors
Cache: SharedPreferences + In-Memory
Network: connectivity_plus + internet_connection_checker
Localization: flutter_localizations
