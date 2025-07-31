# LenShine: A Mobile Booking Application for Shine Spot Studio

LenShine is a mobile booking application developed for **Shine Spot Studio**, designed to streamline the appointment scheduling process. This project is a partial fulfillment of the course requirements for IT-331 - Application Development and Emerging Technologies at Batangas State University.

## 🌟 Overview

LenShine addresses the inefficiencies of manual scheduling and fragmented operations in photography studios. By providing an intuitive platform for automated bookings, the application aims to simplify studio management, minimize errors, and enhance the overall customer experience.  

## ✨ App Features

The application comes packed with features to ensure a seamless user experience for both clients and studio administrators.

* **User Authentication**: Secure sign-up and login functionality using email and password, complete with a password reset flow.  
* **Package Browse**: Users can browse through various photography packages, including Self-Shoot, Party, Wedding, and Christening, with detailed descriptions and pricing.  
* **Seamless Booking System**: An intuitive booking process where users can select their desired package, date, and time, and provide necessary details.  
* **Dynamic Content**: Packages and other content are dynamically loaded from a custom backend API.  
* **Payment Simulation**: Includes a simulated payment process, allowing users to confirm their bookings.  
* **Location Mapping**: An integrated map feature to help users find the studio's location.  
* **User Profile Management**: Users can view and manage their profile information.
* **Integrated Chatbot**: An "ASKLenShine" feature provides users with instant support and answers to frequently asked questions.  

## 🧐 Overview  
In progress

### High-Fidelity Wireframes

**Sign-in and Sign-up Flow**  
![Sign-in and Sign-up](https://storage.googleapis.com/maker-media-tool-store/b0d71a17-380d-402a-9642-887498c4d156)

**Main User Flow (Booking, Profile, etc.)** 
![User Flow](https://storage.googleapis.com/maker-media-tool-store/a5b4c10c-3bb1-4475-ae90-7d721111d4e0)

## 🛠️ Technologies Used

## ✨ Features
- **Authentication:** Email/password sign-up, login, and password reset via Firebase Auth :contentReference[oaicite:11]{index=11}  
- **ReCAPTCHA Security:** Bot protection with reCAPTCHA Enterprise :contentReference[oaicite:12]{index=12}  
- **Booking Flow:** Browse packages, select dates, confirm, and simulate payments :contentReference[oaicite:13]{index=13}  
- **User Profile:** View and edit profile, session persistence with SharedPreferences :contentReference[oaicite:14]{index=14}  
- **Navigation:** Custom bottom navigation bar for Home, Map, Chatbot, Profile :contentReference[oaicite:15]{index=15}  
- **Receipt:** Dynamically generate and display booking receipts  

## 🚀 For Developers: Getting Started

Follow these instructions to get a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

Make sure you have the following installed on your machine:

* **Flutter SDK**: [Official Installation Guide](https://docs.flutter.dev/get-started/install)  
* **Node.js**: Required for running the MySQL database connection. 
* **Android Studio** or **VS Code** as your IDE.  
* **XAMPP**: To run the local MySQL database for the custom backend.  
* A **Firebase account** for authentication services.  

### Setup and Installation

1.  **Clone the Repository**
    ```sh
    git clone [https://github.com/Julius-Tindugan/lenshine.git](https://github.com/Julius-Tindugan/lenshine.git)
    cd lenshine
    ```

2.  **Configure Firebase**
    * Create a new project on the [Firebase Console](https://console.firebase.google.com/).  
    * Add an **Android** and/or **iOS** app to your Firebase project.  
    * Download the `google-services.json` file and place it in the `android/app/` directory.  
    * Enable **Email/Password** authentication in the Firebase console.  

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
    * Connect a physical device or start an emulator.  
    * Run the app using the following command:
        ```sh
        flutter run
        ```

## 📂 Project Structure

The source code is organized into a logical directory structure to maintain clarity and scalability.  

* lenshine/
* ├── android/            # Android platform-specific files
* ├── ios/                # iOS platform-specific files
* ├── lib/                # Main Dart source code
* │   ├── models/         # Data models (PackageItem, BookingDetails, etc.)
* │   ├── screens/        # All application screens (UI)
* │   ├── services/       # API and other service classes (ApiService)
* │   ├── widgets/        # Custom reusable widgets
* │   └── main.dart       # Application entry point
* ├── test/               # Test files
* └── pubspec.yaml        # Flutter dependencies and project configuration

## 🤝 The Team

This project was developed by a team of dedicated students:

* **Kristine Merylle M. Lalong-isip** - Project Manager/UI Designer 
* **Julius C. Tindugan** - Full Stack Developer 
* **Reymark M. Arguelles** - Data Analyst

Under the guidance of **Mr. Melandro V. Floro**, Course Instructor.  
