# Flutter Developer Technical Task – Softvence Agency

## 📌 Overview

This project was developed as part of a **Flutter technical interview task** for **Softvence Agency**.
The focus was on **clean architecture, proper GetX usage, and real-world Firebase integration**, rather than UI only.

---

## 🧱 Architecture & Structure

The application follows a **clean and feature-based architecture**.

* **Navigation** is handled centrally using **GetX routes** (`routes/` folder)
* **Business logic** is handled entirely inside **GetX Controllers**
* **UI (presentation layer)** contains only widgets and reactive state listeners
* No logic is written directly inside UI files

```
lib/
├── core/              → data models & services
├── presentation/      → feature-wise UI & controllers
├── routes/            → centralized GetX navigation
├── utils/             → reusable helpers & widgets
└── main.dart          → app initialization
```

---

## 🔧 Key Implementation Decisions

* **GetX** used strictly for:

    * State management
    * Dependency injection
    * Navigation
* **Firebase Authentication**

    * Google Sign-In
    * Facebook Login
* **Firebase Cloud Messaging**

    * Foreground, background & terminated handling
    * Notification tap navigation
* Clean separation between:

    * UI
    * Controllers
    * Services

---

## 📸 Screenshots

*(Screenshots are added below to demonstrate core features)*

* Splash Screen
* Login Screen
* Home Screen
* Push Notification
* Notification Detail Screen

---

## ⏱ Development Time

**1–2 days**, prioritizing **code quality, clarity, and structure**.

---

## 📝 Note

This task reflects a real-world Flutter development approach with emphasis on **engineering discipline, maintainability, and ownership**.
