import 'dart:async';
import 'package:flutter/material.dart';

// Import Data Models
 // Adjust 'lenshine' to your project name
import 'package:lenshine/models/package_item.dart'; // Adjust 'lenshine' to your project name
import 'package:lenshine/models/booking_details.dart'; // Adjust 'lenshine' to your project name

// Import Widgets
import 'package:lenshine/widgets/custom_bottom_navigation_bar.dart'; // Adjust 'lenshine' to your project name

// Import Authentication Screens
import 'package:lenshine/screens/auth/landing_screen.dart'; // Adjust 'lenshine' to your project name
import 'package:lenshine/screens/auth/after_landing_screen.dart'; // Adjust 'lenshine' to your project name
import 'package:lenshine/screens/auth/create_account_screen.dart'; // Adjust 'lenshine' to your project name
import 'package:lenshine/screens/auth/login_screen.dart'; // Adjust 'lenshine' to your project name
import 'package:lenshine/screens/auth/forgot_password_screen.dart'; // Adjust 'lenshine' to your project name
import 'package:lenshine/screens/auth/forgot_password_code_screen.dart'; // Adjust 'lenshine' to your project name
import 'package:lenshine/screens/auth/forgot_password_sms_code_screen.dart'; // Adjust 'lenshine' to your project name
import 'package:lenshine/screens/auth/enter_password_to_login_screen.dart'; // Adjust 'lenshine' to your project name
import 'package:lenshine/screens/auth/reset_password_screen.dart'; // Adjust 'lenshine' to your project name

// Import Main App Screens (placeholders if not provided in original file)
import 'package:lenshine/screens/home/home_landing_screen.dart'; // Adjust 'lenshine' to your project name
import 'package:lenshine/screens/map/map_screen.dart'; // Adjust 'lenshine' to your project name
import 'package:lenshine/screens/profile/profile_screen.dart'; // Adjust 'lenshine' to your project name
import 'package:lenshine/screens/booking/booking_screen.dart'; // Adjust 'lenshine' to your project name
import 'package:lenshine/screens/booking/booking_screen_two.dart'; // Adjust 'lenshine' to your project name
import 'package:lenshine/screens/booking/self_shoot_details_screen.dart'; // Adjust 'lenshine' to your project name
import 'package:lenshine/screens/booking/party_details_screen.dart'; // Adjust 'lenshine' to your project name
import 'package:lenshine/screens/booking/wedding_details_screen.dart'; // Adjust 'lenshine' to your project name
import 'package:lenshine/screens/booking/christening_details_screen.dart'; // Adjust 'lenshine' to your project name
import 'package:lenshine/screens/chatbot/chatbot_screen.dart'; // Adjust 'lenshine' to your project name
import 'package:lenshine/screens/booking/confirmation_screen.dart'; // Adjust 'lenshine' to your project name
import 'package:lenshine/screens/booking/payment_screen.dart'; // Adjust 'lenshine' to your project name
import 'package:lenshine/screens/booking/receipt_screen.dart'; // Adjust 'lenshine' to your project name
import 'package:lenshine/screens/auth/try_another_way_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lenshine',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'YourAppFont', // Set a default font for consistency
      ),
      debugShowCheckedModeBanner: false,
      home: const Scaffold(
        body: MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Navigation State
  bool showLanding = true;
  bool showCreateAccount = false;
  bool showLogin = false;
  bool showForgotPassword = false;
  bool showForgotPasswordCode = false;
  bool showTryAnotherWay = false;
  bool showResetPassword = false;
  bool showForgotPasswordSmsCode = false;
  bool showEnterPasswordToLogin = false;
  bool isLoggedIn = false;
  bool showChatbot = false;

  // Details & Booking Flow State
  bool showSelfShootDetails = false;
  bool showPartyDetails = false;
  bool showWeddingDetails = false;
  bool showChristeningDetails = false;
  PackageItem? christeningPackageToShow;
  PackageItem? bookingPackage;
  String bookingLabel = "";
  bool showConfirmationScreen = false;
  BookingDetails? bookingDetails;
  bool showPaymentScreen = false;
  bool showReceiptScreen = false;

  // Bottom Nav State
  int selectedIndex = 0;

  // Placeholder for christeningPackage, if it's a global constant
  final PackageItem christeningPackage = const PackageItem(
    title: "Christening Package",
    price: "PHP 5000",
    imageAsset: "assets/images/christening_placeholder.png",
    inclusions: ["Photo coverage", "Video coverage"],
    freeItems: ["Photo album"],
  );

  @override
  void initState() {
    super.initState();
    // Simulate the splash screen delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          showLanding = false;
        });
      }
    });
  }

  void _resetToHome() {
    setState(() {
      showReceiptScreen = false;
      showPaymentScreen = false;
      showConfirmationScreen = false;
      bookingPackage = null;
      bookingLabel = "";
      bookingDetails = null;
      showSelfShootDetails = false;
      showPartyDetails = false;
      showWeddingDetails = false;
      showChristeningDetails = false;
      selectedIndex = 0; // Navigate back to Home
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isLoggedIn) {
      // --- Authentication Flow ---
      if (showLanding) {
        return const LandingScreen();
      } else if (showCreateAccount) {
        return CreateAccountScreen(
          onBack: () => setState(() => showCreateAccount = false),
          onLoginClick: () => setState(() {
            showCreateAccount = false;
            showLogin = true;
          }),
        );
      } else if (showForgotPasswordCode) {
        return ForgotPasswordCodeScreen(
          onBack: () => setState(() {
            showForgotPasswordCode = false;
            showForgotPassword = true;
          }),
          onContinue: () => setState(() {
            showForgotPasswordCode = false;
            showResetPassword = true;
          }),
          onTryAnotherWay: () => setState(() {
            showForgotPasswordCode = false;
            showTryAnotherWay = true;
          }),
        );
      } else if (showForgotPassword) {
        return ForgotPasswordScreen(
          onBack: () => setState(() {
            showForgotPassword = false;
            showLogin = true;
          }),
          onContinue: () => setState(() {
            showForgotPassword = false;
            showForgotPasswordCode = true;
          }),
        );
      } else if (showTryAnotherWay) {
        return TryAnotherWayScreen(
          onBack: () => setState(() {
            showTryAnotherWay = false;
            showForgotPasswordCode = true;
          }),
          onContinue: (selected) => setState(() {
            showTryAnotherWay = false;
            if (selected == 0) showForgotPasswordSmsCode = true;
            if (selected == 1) showForgotPasswordCode = true;
            if (selected == 2) showEnterPasswordToLogin = true;
          }),
        );
      } else if (showResetPassword) {
        return ResetPasswordScreen(
          onBack: () => setState(() {
            showResetPassword = false;
            showForgotPassword = true;
          }),
          onContinue: () => setState(() {
            showResetPassword = false;
            showLogin = true;
          }),
        );
      } else if (showForgotPasswordSmsCode) {
        return ForgotPasswordSmsCodeScreen(
          onBack: () => setState(() {
            showForgotPasswordSmsCode = false;
            showTryAnotherWay = true;
          }),
          onContinue: () => setState(() {
            showForgotPasswordSmsCode = false;
            showResetPassword = true;
          }),
          onTryAnotherWay: () => setState(() {
            showForgotPasswordSmsCode = false;
            showTryAnotherWay = true;
          }),
        );
      } else if (showEnterPasswordToLogin) {
        return EnterPasswordToLoginScreen(
          onBack: () => setState(() {
            showEnterPasswordToLogin = false;
            showTryAnotherWay = true;
          }),
          onLoginSuccess: () => setState(() {
            showEnterPasswordToLogin = false;
            isLoggedIn = true;
          }),
        );
      } else if (showLogin) {
        return LoginScreen(
          onBack: () => setState(() => showLogin = false),
          onCreateAccountClick: () => setState(() {
            showLogin = false;
            showCreateAccount = true;
          }),
          onForgotPasswordClick: () => setState(() {
            showLogin = false;
            showForgotPassword = true;
          }),
          onLoginSuccess: () => setState(() {
            showLogin = false;
            isLoggedIn = true;
          }),
        );
      } else {
        return AfterLandingScreen(
          onCreateAccountClick: () => setState(() => showCreateAccount = true),
          onLoginClick: () => setState(() => showLogin = true),
        );
      }
    } else {
      // --- Main App Flow ---
      return Scaffold(
        body: Stack(
          children: [
            // --- Base Screens ---
            _buildMainContent(),

            // --- Overlay Screens ---
            if (showConfirmationScreen && bookingDetails != null)
              ConfirmationScreen(
                bookingDetails: bookingDetails!,
                onContinue: () => setState(() => showPaymentScreen = true),
                onCancel: () => setState(() => showConfirmationScreen = false),
                onBack: () => setState(() => showConfirmationScreen = false),
              ),

            if (showPaymentScreen)
              PaymentScreen(
                amount: bookingDetails?.pkg.price ?? "PHP 0",
                onBack: () => setState(() => showPaymentScreen = false),
                onConfirm: () => setState(() {
                  showPaymentScreen = false;
                  showReceiptScreen = true;
                }),
              ),

            if (showReceiptScreen && bookingDetails != null)
              ReceiptScreen(
                onBackToHome: _resetToHome,
                bookingDetails: bookingDetails!,
              ),
          ],
        ),
        bottomNavigationBar: _buildBottomNavBar(),
      );
    }
  }

  Widget? _buildBottomNavBar() {
    bool hideNavBar = showChatbot ||
        showSelfShootDetails ||
        showPartyDetails ||
        showWeddingDetails ||
        showChristeningDetails ||
        bookingPackage != null ||
        showConfirmationScreen ||
        showPaymentScreen ||
        showReceiptScreen;
    if (hideNavBar) return null;

    return CustomBottomNavigationBar(
      selectedIndex: selectedIndex,
      onItemSelected: (index) {
        if (index == 2) {
          setState(() => showChatbot = true);
        } else {
          setState(() => selectedIndex = index);
        }
      },
    );
  }

  Widget _buildMainContent() {
    if (bookingPackage != null && bookingLabel == "Self-Shoot") {
      return BookingScreen(
        pkg: bookingPackage!,
        label: bookingLabel,
        onBack: () => setState(() => bookingPackage = null),
        onBookNow: (details) => setState(() {
          bookingDetails = details;
          showConfirmationScreen = true;
        }),
      );
    }
    if (bookingPackage != null && (bookingLabel == "Party" || bookingLabel == "Wedding" || bookingLabel == "Christening")) {
      return BookingScreenTwo(
        pkg: bookingPackage!,
        label: bookingLabel,
        onBack: () => setState(() => bookingPackage = null),
        onBookNow: (details) => setState(() {
          bookingDetails = details;
          showConfirmationScreen = true;
        }),
      );
    }
    if (showSelfShootDetails) {
      return SelfShootDetailsScreen(
        onBack: () => setState(() => showSelfShootDetails = false),
        onBookNow: (pkg, label) => setState(() {
          bookingPackage = pkg;
          bookingLabel = label;
        }),
      );
    }
    if (showPartyDetails) {
      return PartyDetailsScreen(
        onBack: () => setState(() => showPartyDetails = false),
        onBookNow: (pkg, label) => setState(() {
          bookingPackage = pkg;
          bookingLabel = label;
        }),
      );
    }
    if (showWeddingDetails) {
      return WeddingDetailsScreen(
        onBack: () => setState(() => showWeddingDetails = false),
        onBookNow: (pkg, label) => setState(() {
          bookingPackage = pkg;
          bookingLabel = label;
        }),
      );
    }
    if (showChristeningDetails && christeningPackageToShow != null) {
      return ChristeningDetails(
        pkg: christeningPackageToShow!,
        onBack: () => setState(() => showChristeningDetails = false),
        onBookNow: (pkg, label) => setState(() {
          bookingPackage = pkg;
          bookingLabel = label;
        }),
      );
    }
    if (showChatbot) {
      return ChatbotScreen(onClose: () => setState(() => showChatbot = false));
    }

    switch (selectedIndex) {
      case 0:
        return HomeLandingScreen(
          onShowSelfShootDetails: () => setState(() => showSelfShootDetails = true),
          onShowPartyDetails: () => setState(() => showPartyDetails = true),
          onShowWeddingDetails: () => setState(() => showWeddingDetails = true),
          onShowChristeningDetails: () => setState(() {
            christeningPackageToShow = christeningPackage;
            showChristeningDetails = true;
          }),
          onLogout: () => setState(() {
            isLoggedIn = false;
            // Reset all states to default
            showLanding = false;
            showLogin = false;
          }),
        );
      case 1:
        return const MapScreen();
      case 3:
        return const ProfileScreen(
          fullName: "Kristine Merylle Molina",
          phoneNumber: "09123456789",
          email: "kristine@example.com",
        );
      default:
        return Container(); // Placeholder for chat which is handled as an overlay
    }
  }
}