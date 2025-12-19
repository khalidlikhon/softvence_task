# Flutter Developer Technical Task – Softvence Agency

## 📌 Overview

This project was developed as part of a **Flutter Developer technical interview task** for **Softvence Agency**.
The primary focus of this task was to demonstrate **clean architecture, proper GetX usage, and real-world Firebase integration**, rather than UI only.

---

## 🎯 Objective

To build a production-ready Flutter application that reflects:

* Clean and scalable architecture
* Proper separation of UI and business logic
* Correct usage of GetX for state management, dependency injection, and navigation
* Firebase Authentication and Push Notification handling

---

## 🧱 Architecture & Project Structure

The application follows a **clean, modular, and feature-based architecture**.

* **Navigation** is handled centrally using **GetX routes**
* **Business logic** is managed strictly inside **GetX Controllers**
* **UI layer** contains only presentation logic (widgets)
* No Firebase or business logic is written inside UI files

```
lib/
├── core/              → data models & services
├── presentation/      → feature-wise UI & controllers
├── routes/            → centralized GetX navigation
├── utils/             → reusable helpers & widgets
└── main.dart          → app initialization
```

---

## 🔧 Core Features Implemented

### Authentication (Firebase)

* Google Sign-In
* Facebook Login (partial – see note below)
* Persistent login session
* Logout functionality
* User info display (name, email, profile photo)

### Push Notifications (Firebase Cloud Messaging)

* Permission handling (Android & iOS)
* Foreground, background & terminated state handling
* Notification data display inside app
* Notification tap navigation to detail screen/dialog

---

## 📱 Screens Implemented

* **Splash Screen** – checks authentication state
* **Login Screen** – Google & Facebook authentication
* **Signup Screen** – manual user registration with:
    * Name
    * Email
    * Phone number
    * Profile picture upload
* **Home Screen** – displays user information, logout option, and notification test/display
* **Notification Detail Screen / Dialog** – displays Firebase Cloud Messaging payload


---

## 🧠 Key Implementation Decisions

* **GetX** used strictly for:

    * State management
    * Dependency injection
    * Navigation
* Feature-based presentation layer
* Clean separation between:

    * UI
    * Controllers
    * Services
* User-friendly error handling

---

## 📸 Screenshots

<table align="center">
  <tr>
    <td style="padding:10px 16px;"><img width="150" src="https://github.com/user-attachments/assets/3f783f15-907d-4c0b-8a16-f4bd6b8fe23d" alt="Splash Screen"/></td>
    <td style="padding:10px 16px;"><img width="150" src="https://github.com/user-attachments/assets/523ed753-fb02-4db4-914d-2e1c5f9b064b" alt="Login Screen"/></td>
    <td style="padding:10px 16px;"><img width="150" src="https://github.com/user-attachments/assets/f50d4650-2749-445e-81b0-bfc6124a61f5" alt="Signup Screen"/></td>
  </tr>
  <tr>
    <td style="padding:10px 16px;"><img width="150" src="https://github.com/user-attachments/assets/1efe30ec-e465-4091-b02f-a5f935cbf46d" alt="Home Screen"/></td>
    <td style="padding:10px 16px;"><img width="150" src="https://github.com/user-attachments/assets/e0ed6f54-cf43-4680-89c0-c35f11ee608f" alt="Push Notification"/></td>
    <td style="padding:10px 16px;"><img width="150" src="https://github.com/user-attachments/assets/e6e1e8ca-4025-43e6-b32a-a08661719464" alt="Notification Detail Screen"/></td>
  </tr>
</table>

* Splash Screen
* Login Screen
* Signup Screen
* Home Screen
* Push Notification
* Notification Detail Screen

---

## 📝 Note (Facebook Login)

Due to a **technical configuration issue**, the **Facebook Login** feature could not be fully finalized within the given timeframe.

The main reason was a **delay in reviewing the task email**, which reduced the available setup window.
The remaining issue is **configuration-related only**, and the implementation flow is already in place.

With additional time, this can be **fully resolved in a subsequent commit** without any architectural changes.

The project was submitted on time with priority given to:

* Clean architecture
* GetX discipline
* Overall code quality and structure

---

## ⏱ Development Time

**1–2 days**, prioritizing **quality, clarity, and maintainability** over speed.

---

## 📝 Final Note

This project reflects a **real-world Flutter development approach**, emphasizing engineering judgment, ownership, and clean code practices.
