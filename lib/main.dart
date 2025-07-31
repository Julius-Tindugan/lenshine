import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recaptcha_enterprise_flutter/recaptcha.dart';
import 'package:recaptcha_enterprise_flutter/recaptcha_client.dart';
import 'dart:io' show File, Platform;

// Import Data Models
import 'package:lenshine/models/package_item.dart' as pkg_model;
import 'package:lenshine/models/booking_details.dart';

// Import Widgets
import 'package:lenshine/widgets/custom_bottom_navigation_bar.dart';

// Import Authentication Screens
import 'package:lenshine/screens/auth/landing_screen.dart';
import 'package:lenshine/screens/auth/after_landing_screen.dart';
import 'package:lenshine/screens/auth/create_account_screen.dart';
import 'package:lenshine/screens/auth/login_screen.dart';
import 'package:lenshine/screens/auth/forgot_password_screen.dart';
import 'package:lenshine/screens/auth/forgot_password_code_screen.dart';
import 'package:lenshine/screens/auth/forgot_password_sms_code_screen.dart';
import 'package:lenshine/screens/auth/enter_password_to_login_screen.dart';
import 'package:lenshine/screens/auth/reset_password_screen.dart';

// Import Main App Screens
import 'package:lenshine/screens/home/home_landing_screen.dart' as home_screen;
import 'package:lenshine/screens/map/map_screen.dart';
import 'package:lenshine/screens/profile/profile_screen.dart' as profile;
import 'package:lenshine/screens/booking/booking_screen.dart';
import 'package:lenshine/screens/booking/booking_screen_two.dart';
import 'package:lenshine/screens/booking/self_shoot_details_screen.dart';
import 'package:lenshine/screens/booking/party_details_screen.dart';
import 'package:lenshine/screens/booking/wedding_details_screen.dart';
import 'package:lenshine/screens/booking/christening_details_screen.dart';
import 'package:lenshine/screens/chatbot/chatbot_screen.dart';
import 'package:lenshine/screens/booking/confirmation_screen.dart';
import 'package:lenshine/screens/booking/payment_screen.dart';
import 'package:lenshine/screens/booking/receipt_screen.dart';
import 'package:lenshine/screens/auth/try_another_way_screen.dart';

// Import ApiService
import 'package:lenshine/services/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // TODO: Replace with your actual site keys
  final siteKey = Platform.isAndroid ? "6LdLAoorAAAAAHozKrIMz0X3-cvQ9-aThmJ_tezD" : "6LdLAoorAAAAAHozKrIMz0X3-cvQ9-aThmJ_tezD";
  final recaptchaClient = await Recaptcha.fetchClient(siteKey);
  runApp(MyApp(recaptchaClient: recaptchaClient));
}

class MyApp extends StatelessWidget {
  final RecaptchaClient recaptchaClient;
  const MyApp({super.key, required this.recaptchaClient});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lenshine',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 0, 0, 0),
          brightness: Brightness.light,
          primary: const Color.fromARGB(255, 0, 0, 0),
          secondary: const Color(0xFF4EC3B5),
          background: Colors.white,
          surface: Colors.white,
          error: Colors.redAccent,
        ),
        fontFamily: 'Montserrat', // Use a modern font, ensure it's in pubspec.yaml
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 0.5,
          ),
          iconTheme: IconThemeData(color: Colors.black),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF5F6FA),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          labelStyle: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 0, 0, 0),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            elevation: 2,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color.fromARGB(255, 0, 0, 0),
            side: const BorderSide(color: Color.fromARGB(255, 0, 0, 0), width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
        ),
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: Color.fromARGB(255, 0, 0, 0),
          contentTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          behavior: SnackBarBehavior.floating,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: ResponsiveScaffold(recaptchaClient: recaptchaClient),
    );
  }
}

/// ResponsiveScaffold wraps the main content in SafeArea and provides MediaQuery for scaling.
class ResponsiveScaffold extends StatelessWidget {
  final RecaptchaClient recaptchaClient;
  const ResponsiveScaffold({super.key, required this.recaptchaClient});

  @override
  Widget build(BuildContext context) {
    // Use LayoutBuilder to get constraints for responsive scaling
    return LayoutBuilder(
      builder: (context, constraints) {
        // Optionally, you can use constraints.maxWidth/maxHeight for custom scaling
        return SafeArea(
          child: Scaffold(
            body: MainScreen(recaptchaClient: recaptchaClient),
          ),
        );
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  final RecaptchaClient recaptchaClient;
  const MainScreen({super.key, required this.recaptchaClient});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<pkg_model.PackageItem> selfShootPackages = [];
  List<pkg_model.PackageItem> partyPackages = [];
  List<pkg_model.PackageItem> weddingPackages = [];
  List<pkg_model.PackageItem> christeningPackages = [];
  User? firebaseUser;
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
  pkg_model.PackageItem? bookingPackage;
  String bookingLabel = "";
  bool showConfirmationScreen = false;
  BookingDetails? bookingDetails;
  bool showPaymentScreen = false;
  bool showReceiptScreen = false;

  // Bottom Nav State
  int selectedIndex = 0;

  // User State
  int? userId;
  Map<String, dynamic>? userProfile;

  // For password reset flow
  String forgotEmail = '';
  String resetCode = '';

  // Placeholder for christeningPackage
  List<pkg_model.PackageItem> packages = [];
  bool isLoadingPackages = true;
  bool isSessionChecked = false;

  @override
  void initState() {
    super.initState();
    _checkSession();
    _fetchPackages();
    firebaseUser = FirebaseAuth.instance.currentUser; // Add this
    
    // Debug: Print API base URL and test connection
  
    _testApiConnection();
    
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          showLanding = false;
        });
      }
    });
  }

  // Test API connection on startup
  Future<void> _testApiConnection() async {
    try {
      final isConnected = await ApiService.testConnection();
      if (isConnected) {
        print('✅ API connection successful');
      } else {
        print('❌ API connection failed - check your network setup');
        // Show a snackbar to inform the user
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('⚠️ Cannot connect to server. Check network settings.'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      print('❌ API connection test error: $e');
    }
  }

 Future<void> _checkSession() async {
  final prefs = await SharedPreferences.getInstance();
  final loggedIn = prefs.getBool('isLoggedIn') ?? false;
  final userIdPref = prefs.getString('userId');
  if (loggedIn && userIdPref != null) {
    userId = int.tryParse(userIdPref);
    if (userId != null) { // <-- Add this check
      final profileData = await ApiService.getProfile(userId!);
      setState(() {
        userProfile = profileData['profile'];
        isLoggedIn = true;
        isSessionChecked = true;
      });
    } else {
      setState(() {
        isSessionChecked = true;
        isLoggedIn = false;
        userProfile = null;
        userId = null;
      });
    }
  } else {
    setState(() {
      isSessionChecked = true;
    });
  }
}

  // *** FIXED DATA FETCHING LOGIC ***
  Future<void> _fetchPackages() async {
    try {
      // 1. Fetch the entire response object from the API
      final apiResponse = await ApiService.getPackages();

      // 2. Check if the fetch was successful and extract the 'packages' list
    if (apiResponse['success'] == true && apiResponse['packages'] is List) {
  final List<dynamic> packageList = apiResponse['packages'];
  final loadedPackages = packageList
      .map<pkg_model.PackageItem>((json) => pkg_model.PackageItem.fromJson(json))
      .toList();
  setState(() {
    packages = loadedPackages;
    isLoadingPackages = false;
  });
} else {
  setState(() {
    isLoadingPackages = false;
  });
  // print("Failed to load or parse packages from API.");
}
    } catch (e) {
      setState(() {
        isLoadingPackages = false;
      });
      // print("An error occurred while fetching packages: $e");
    }
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
    });
  }

   void _onLoginSuccess(int id) async {
    userId = id;
    firebaseUser = FirebaseAuth.instance.currentUser; // Update after login
    final profileData = await ApiService.getProfile(userId!);
    setState(() {
      userProfile = profileData['profile'];
      isLoggedIn = true;
    });
  }


  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    setState(() {
      isLoggedIn = false;
      userProfile = null;
      userId = null;
      showLanding = false;
      showLogin = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isSessionChecked) {
      return const Center(child: CircularProgressIndicator());
    }
    if (!isLoggedIn) {
      // --- Authentication Flow ---
      if (showLanding) {
        return LandingScreen(userName: userProfile?['first_name']);
      } else if (showCreateAccount) {
        return CreateAccountScreen(
          onBack: () => setState(() => showCreateAccount = false),
          onLoginClick: () => setState(() {
            showCreateAccount = false;
            showLogin = true;
          }),
          recaptchaClient: widget.recaptchaClient,
        );
      } else if (showForgotPasswordCode) {
  return ForgotPasswordCodeScreen(
    onBack: () => setState(() {
      showForgotPasswordCode = false;
      showForgotPassword = true;
    }),
    onTryAnotherWay: () => setState(() {
      showForgotPasswordCode = false;
      showTryAnotherWay = true;
    }),
    email: forgotEmail,
  );
}else if (showForgotPassword) {
  return ForgotPasswordScreen(
    onBack: () => setState(() {
      showForgotPassword = false;
      showLogin = true;
    }),
    onContinue: (email) async {
      forgotEmail = email;
      // Request code from backend
      final res = await ApiService.requestPasswordReset(email: email);
      if (!mounted) return; // <-- Add this line
      if (res['success'] == true) {
        setState(() {
          showForgotPassword = false;
          showForgotPasswordCode = true;
        });
      } else {
        if (!mounted) return; // <-- Add this line
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res['error'] ?? 'Email not found'))
        );
      }
    },
  );
} else if (showTryAnotherWay) {
  final maskedPhone = userProfile?['phone'] != null
      ? maskPhone(userProfile!['phone'])
      : "Not available";
  final maskedEmail = forgotEmail.isNotEmpty
      ? maskEmail(forgotEmail)
      : "Not available";
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
    maskedPhone: maskedPhone,
    maskedEmail: maskedEmail,
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
    email: forgotEmail,
  );
} else if (showForgotPasswordSmsCode) {
  final maskedPhone = userProfile?['phone'] != null
      ? maskPhone(userProfile!['phone'])
      : "Not available";
  final phone = userProfile?['phone'] ?? "";
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
    maskedPhone: maskedPhone,
    phone: phone,
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
          onLoginSuccess: (id) => _onLoginSuccess(id),
          recaptchaClient: widget.recaptchaClient,
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
            _buildMainContent(),
            if (showConfirmationScreen && bookingDetails != null)
              ConfirmationScreen(
                bookingDetails: bookingDetails!,
                onContinue: () => setState(() => showPaymentScreen = true),
                onCancel: () => setState(() => showConfirmationScreen = false),
                onBack: () => setState(() => showConfirmationScreen = false),
              ),
            if (showPaymentScreen)
              PaymentScreen(
                // The price here is a formatted string for display.
                amount: bookingDetails!.price.toString(),
                gcashName: userProfile?['first_name'] ?? "Shine Spot Studio",
                onBack: () => setState(() => showPaymentScreen = false),
                onConfirm: (File? proofImageFile) async {
  // Show loading dialog
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(child: CircularProgressIndicator()),
  );
  try {
    // REMOVED: The logic to fetch add-ons and map names to IDs is no longer needed here.
final selectedAddOnIds = bookingDetails!.addOns.map((addon) => addon.id).toList();
    // 1. Call book API with the addOnIds directly from bookingDetails
    final bookRes = await ApiService.book(
      userId: userId!,
      packageId: bookingDetails!.pkg.packageId,
      bookingLabel: bookingDetails!.label,
      bookingDate: bookingDetails!.date ?? '',
      bookingTime: bookingDetails!.time,
      backdrop: bookingDetails!.backdrop,
      // PASS THE IDs DIRECTLY
      addOnIds: selectedAddOnIds,
      userName: (userProfile != null && userProfile!['first_name'] != null && userProfile!['last_name'] != null)
        ? "${userProfile!['first_name']} ${userProfile!['last_name']}"
        : (userProfile?['first_name'] ?? firebaseUser?.displayName ?? 'Unknown'),
    );
                    
                    if (bookRes['success'] == true && bookRes['booking_id'] != null) {
      int bookingId = bookRes['booking_id'];
      
      // 2. Call payment API with the actual price from bookingDetails
      final paymentRes = await ApiService.payment(
        bookingId: bookingId,
        amount: bookingDetails!.price, // This amount now matches the server's calculation
        paymentMethod: 'GCash',
        proofImageUrl: proofImageFile?.path,
      );
                      
                      if (paymentRes['success'] == true) {
        // 3. Update bookingDetails with bookingId and show receipt
        setState(() {
          bookingDetails = BookingDetails(
            pkg: bookingDetails!.pkg,
            label: bookingDetails!.label,
            time: bookingDetails!.time,
            backdrop: bookingDetails!.backdrop,
            addOns: bookingDetails!.addOns,
            price: bookingDetails!.price,
            userProfile: bookingDetails!.userProfile,
            date: bookingDetails!.date,
            bookingId: bookingId,
          );
          showPaymentScreen = false;
          showReceiptScreen = true;
        });
                      } else {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(paymentRes['error'] ?? 'Payment failed.')),
                        );
                      }
                    } else {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(bookRes['error'] ?? 'Booking failed.')),
                      );
                    }
                  } catch (e) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('An error occurred: $e')),
                    );
                  } finally {
                    // Remove loading dialog if still present
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }
                  }
                },
              ),
            if (showReceiptScreen && bookingDetails != null)
              ReceiptScreen(
                onBackToHome: _resetToHome,
                bookingDetails: bookingDetails!,
              ),
          ],
        ),
        bottomNavigationBar: Semantics(
          label: 'Main navigation',
          child: _buildBottomNavBar(),
        ),
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
  if (isLoadingPackages) {
    return const Center(child: CircularProgressIndicator());
  }

  // Filter the master 'packages' list into category-specific lists
  selfShootPackages = packages.where((pkg) => pkg.packageType == "Self-Shoot").toList();
  partyPackages = packages.where((pkg) => pkg.packageType == "Party").toList();
  weddingPackages = packages.where((pkg) => pkg.packageType == "Wedding").toList();
  christeningPackages = packages.where((pkg) => pkg.packageType == "Christening").toList();

  final christeningPackage = christeningPackages.isNotEmpty
      ? christeningPackages.first
      : pkg_model.PackageItem(
          packageId: -1,
          title: "Christening Package",
          // *** FIXED: Ensure price is a string to match the model constructor ***
          price: 0.0,
          imageAsset: pkg_model.serviceImages["Christening"] ?? "assets/images/shinelogo.png",
          inclusions: [],
          freeItems: [],
          description: "No Christening package available.",
          name: "No Christening Package",
          packageType: "Christening",
        );

  if (bookingPackage != null && bookingLabel == "Self-Shoot") {
    return BookingScreen(
      pkg: bookingPackage!,
      label: bookingLabel,
      userId: userId ?? 0,
      userProfile: userProfile,
      onBack: () => setState(() => bookingPackage = null),
      onBookNow: (details) => setState(() {
        bookingDetails = details;
        showConfirmationScreen = true;
      }),
    );
  }
  if (bookingPackage != null &&
      (bookingLabel == "Party" ||
       bookingLabel == "Wedding" ||
       bookingLabel == "Christening")) {
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
      packages: selfShootPackages,
      onBack: () => setState(() => showSelfShootDetails = false),
      onBookNow: (pkg, label) => setState(() {
        bookingPackage = pkg;
        bookingLabel = label;
      }),
    );
  }
  if (showPartyDetails) {
    return PartyDetailsScreen(
      packages: partyPackages,
      onBack: () => setState(() => showPartyDetails = false),
      onBookNow: (pkg, label) => setState(() {
        bookingPackage = pkg;
        bookingLabel = label;
      }),
    );
  }
  if (showWeddingDetails) {
    return WeddingDetailsScreen(
      packages: weddingPackages,
      onBack: () => setState(() => showWeddingDetails = false),
      onBookNow: (pkg, label) => setState(() {
        bookingPackage = pkg;
        bookingLabel = label;
      }),
    );
  }
  if (showChristeningDetails && christeningPackage.packageId != -1) {
    return ChristeningDetails(
      pkg: christeningPackage,
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
        return home_screen.HomeLandingScreen(
          onShowSelfShootDetails: () => setState(() => showSelfShootDetails = true),
          onShowPartyDetails: () => setState(() => showPartyDetails = true),
          onShowWeddingDetails: () => setState(() => showWeddingDetails = true),
          onShowChristeningDetails: () => setState(() => showChristeningDetails = true),
          onLogout: _logout,
          userName: firebaseUser?.displayName ?? userProfile?['first_name'] ?? '', // <-- FIXED
          packages: packages,
        );
    case 1:
      return const MapScreen();
    case 3:
      return profile.ProfileScreen(
      );
    default:
      return Container();
  }
}
}

String maskPhone(String phone) {
  if (phone.length < 4) return phone;
  return phone.replaceRange(2, phone.length - 2, '*' * (phone.length - 4));
}

String maskEmail(String email) {
  final parts = email.split('@');
  if (parts.length != 2) return email;
  final name = parts[0];
  final domain = parts[1];
  final maskedName = name.length > 2
      ? '${name[0]}${'*' * (name.length - 2)}${name[name.length - 1]}'
      : name;
  return '$maskedName@$domain';
}