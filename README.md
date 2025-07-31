# LenShine: A Mobile Booking Application for Shine Spot Studio

LenShine is a mobile booking application developed for **Shine Spot Studio**, designed to streamline the appointment scheduling process. This project is a partial fulfillment of the course requirements for IT-331 - Application Development and Emerging Technologies at Batangas State University.

## 🌟 Overview

[cite_start]LenShine addresses the inefficiencies of manual scheduling and fragmented operations in photography studios. [cite: 29] [cite_start]By providing an intuitive platform for automated bookings, the application aims to simplify studio management, minimize errors, and enhance the overall customer experience. [cite: 30]

## ✨ App Features

The application comes packed with features to ensure a seamless user experience for both clients and studio administrators.

* [cite_start]**User Authentication**: Secure sign-up and login functionality using email and password, complete with a password reset flow. [cite: 226, 227, 228]
* [cite_start]**Package Browse**: Users can browse through various photography packages, including Self-Shoot, Party, Wedding, and Christening, with detailed descriptions and pricing. [cite: 231, 246]
* [cite_start]**Seamless Booking System**: An intuitive booking process where users can select their desired package, date, and time, and provide necessary details. [cite: 217, 232]
* [cite_start]**Dynamic Content**: Packages and other content are dynamically loaded from a custom backend API. [cite: 250]
* [cite_start]**Payment Simulation**: Includes a simulated payment process, allowing users to confirm their bookings. [cite: 243]
* [cite_start]**Location Mapping**: An integrated map feature to help users find the studio's location. [cite: 248]
* **User Profile Management**: Users can view and manage their profile information.
* [cite_start]**Integrated Chatbot**: An "ASKLenShine" feature provides users with instant support and answers to frequently asked questions. [cite: 107, 219, 286]

## 📸 Screenshots

Here’s a glimpse of the LenShine application, from wireframes to the final design.

### High-Fidelity Wireframes

[cite_start]**Sign-in and Sign-up Flow** [cite: 63]
![Sign-in and Sign-up](https://storage.googleapis.com/maker-media-tool-store/b0d71a17-380d-402a-9642-887498c4d156)

[cite_start]**Main User Flow (Booking, Profile, etc.)** [cite: 94, 95]
![User Flow](https://storage.googleapis.com/maker-media-tool-store/a5b4c10c-3bb1-4475-ae90-7d721111d4e0)

## 🛠️ Technologies Used

This project was built using a combination of modern mobile development technologies:

* [cite_start]**Framework**: [Flutter](https://flutter.dev/) [cite: 165]
* [cite_start]**Programming Language**: [Dart](https://dart.dev/) [cite: 166]
* **Backend as a Service (BaaS)**: [Firebase](https://firebase.google.com/)
    * [cite_start]**Firebase Authentication** for user management. [cite: 191, 252]
    * [cite_start]**Firebase Core** for connecting the app to the Firebase project. [cite: 193]
* **Database**:
    * [cite_start]**MySQL** managed via **XAMPP** for the custom backend. [cite: 171]
* **APIs**:
    * Custom **REST API** for fetching package data, managing user profiles, and handling bookings.
    * [cite_start]**reCAPTCHA Enterprise** for bot protection and enhanced security. [cite: 196, 253, 266]
* [cite_start]**State Management**: Stateful widget architecture with `SharedPreferences` for session persistence. [cite: 198, 229]
* **Development Tools**:
    * [cite_start]**Visual Studio Code** [cite: 168]
    * [cite_start]**Android Studio** (for emulators) [cite: 167]
    * **Git** for version control.

## 🚀 For Developers: Getting Started

Follow these instructions to get a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

Make sure you have the following installed on your machine:

* [cite_start]**Flutter SDK**: [Official Installation Guide](https://docs.flutter.dev/get-started/install) [cite: 165, 173]
* [cite_start]**Node.js**: Required for running the MySQL database connection. [cite: 174]
* [cite_start]**Android Studio** or **VS Code** as your IDE. [cite: 167, 168]
* [cite_start]**XAMPP**: To run the local MySQL database for the custom backend. [cite: 171]
* [cite_start]A **Firebase account** for authentication services. [cite: 169]

### Setup and Installation

1.  **Clone the Repository**
    ```sh
    git clone [https://github.com/your-username/lenshine.git](https://github.com/your-username/lenshine.git)
    cd lenshine
    ```

2.  **Configure Firebase**
    * [cite_start]Create a new project on the [Firebase Console](https://console.firebase.google.com/). [cite: 187]
    * [cite_start]Add an **Android** and/or **iOS** app to your Firebase project. [cite: 188]
    * [cite_start]Download the `google-services.json` file and place it in the `android/app/` directory. [cite: 189]
    * [cite_start]Enable **Email/Password** authentication in the Firebase console. [cite: 191]

3.  **Set Up the Backend**
    * Start **XAMPP** and ensure the Apache and MySQL services are running.
    * Import the provided `.sql` file into your phpMyAdmin to set up the database schema.
    * Make sure the backend server (Node.js) is running.

4.  **Install Dependencies**
    * Run the following command in your terminal to fetch all the required Flutter packages:
        ```sh
        flutter pub get
        ```

5.  **Run the Application**
    * [cite_start]Connect a physical device or start an emulator. [cite: 170]
    * Run the app using the following command:
        ```sh
        flutter run
        ```

## 📂 Project Structure

[cite_start]The source code is organized into a logical directory structure to maintain clarity and scalability. [cite: 274]

lenshine/
├── android/            # Android platform-specific files
├── ios/                # iOS platform-specific files
├── lib/                # Main Dart source code
│   ├── models/         # Data models (PackageItem, BookingDetails, etc.)
│   ├── screens/        # All application screens (UI)
│   ├── services/       # API and other service classes (ApiService)
│   ├── widgets/        # Custom reusable widgets
│   └── main.dart       # Application entry point
├── test/               # Test files
└── pubspec.yaml        # Flutter dependencies and project configuration

## 🤝 The Team

This project was developed by a team of dedicated students:

* [cite_start]**Kristine Merylle M. Lalong-isip** - Project Manager/UI Designer [cite: 13]
* [cite_start]**Julius C. Tindugan** - Full Stack Developer [cite: 14]
* **Reymark M. Arguelles** - Data Analyst

Under the guidance of **Mr. [cite_start]Melandro V. Floro**, Course Instructor. [cite: 15]