import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart'; // Import for kDebugMode

class ApiService {
  // --- IMPORTANT: DYNAMIC BASE URL SETUP FOR PHYSICAL DEVICE TESTING ---
  // 
  // FOR PHYSICAL DEVICE TESTING:
  // 1. Make sure your computer and phone are on the same WiFi network
  // 2. Find your computer's IP address:
  //    - Windows: Run 'ipconfig' in cmd and look for "IPv4 Address"
  //    - macOS/Linux: Run 'ifconfig' in terminal and look for "inet"
  // 3. Replace 'YOUR_COMPUTER_IP' below with your actual IP address
  // 4. Make sure your firewall allows connections on port 3000
  // 5. Start your server with: node server.js
  //
  // FOR EMULATOR TESTING:
  // - Uses '10.0.2.2' which automatically points to your computer's localhost
  
  // *** REPLACE THIS WITH YOUR COMPUTER's ACTUAL IP ADDRESS ***
  static const String _productionBaseUrl = 'https://lens-server-8rvv.onrender.com'; // <-- UPDATE THIS IP ADDRESS
  
  // Dynamic base URL selection
  static String get baseUrl {
    // This now correctly returns 'https://lens-server-8rvv.onrender.com'
    return _productionBaseUrl;
  }
  
  // Alternative base URL for emulator testing
  static String get emulatorBaseUrl => 'http://10.0.2.2:3000';
  
  // Debug method to print the current base URL and connection info
 

  // Helper method to test API connectivity
  static Future<bool> testConnection() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/test-db'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 5));
      
      print('Connection test result: ${response.statusCode} - ${response.body}');
      return response.statusCode == 200;
    } catch (e) {
      print('Connection test failed: $e');
      return false;
    }
  }

  // Validation methods
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return emailRegex.hasMatch(email);
  }

  static bool isValidPhone(String phone) {
    final phoneRegex = RegExp(r'^[\d\s\-\+\(\)]+$');
    return phoneRegex.hasMatch(phone) && phone.replaceAll(RegExp(r'[\s\-\+\(\)]'), '').length >= 10;
  }

  static bool isValidPassword(String password) {
    return password.length >= 6;
  }

  static bool isValidName(String name) {
    return name.trim().length >= 2 && RegExp(r'^[a-zA-Z\s]+$').hasMatch(name.trim());
  }

  static bool isValidDate(String date) {
    // Check MM/DD/YYYY format
    if (RegExp(r'^\d{1,2}/\d{1,2}/\d{4}$').hasMatch(date)) {
      final parts = date.split('/');
      final month = int.tryParse(parts[0]);
      final day = int.tryParse(parts[1]);
      final year = int.tryParse(parts[2]);
      return month != null && month >= 1 && month <= 12 &&
             day != null && day >= 1 && day <= 31 &&
             year != null && year >= 2024;
    }
    // Check YYYY-MM-DD format
    if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(date)) {
      final parts = date.split('-');
      final year = int.tryParse(parts[0]);
      final month = int.tryParse(parts[1]);
      final day = int.tryParse(parts[2]);
      return year != null && year >= 2024 &&
             month != null && month >= 1 && month <= 12 &&
             day != null && day >= 1 && day <= 31;
    }
    return false;
  }

  static bool isValidTime(String time) {
    final timeRegex = RegExp(r'^(1[0-2]|0?[1-9]):[0-5][0-9]\s?(am|pm)$', caseSensitive: false);
    return timeRegex.hasMatch(time);
  }

  static bool isValidAmount(dynamic amount) {
    if (amount is num) {
      return amount > 0;
    }
    if (amount is String) {
      final parsed = double.tryParse(amount);
      return parsed != null && parsed > 0;
    }
    return false;
  }

  static bool isValidId(dynamic id) {
    if (id is int) {
      return id > 0;
    }
    if (id is String) {
      final parsed = int.tryParse(id);
      return parsed != null && parsed > 0;
    }
    return false;
  }

  // --- Firebase Auth Registration (ENHANCED VALIDATION) ---
  static Future<Map<String, dynamic>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
  }) async {
    // Client-side validation
    final errors = <String>[];
    
    if (!isValidName(firstName)) {
      errors.add('First name must be at least 2 characters and contain only letters');
    }
    
    if (!isValidName(lastName)) {
      errors.add('Last name must be at least 2 characters and contain only letters');
    }
    
    if (!isValidEmail(email)) {
      errors.add('Please provide a valid email address');
    }
    
    if (!isValidPhone(phone)) {
      errors.add('Please provide a valid phone number (minimum 10 digits)');
    }
    
    if (!isValidPassword(password)) {
      errors.add('Password must be at least 6 characters long');
    }

    if (errors.isNotEmpty) {
      return {
        'success': false,
        'error': 'Validation failed',
        'details': errors
      };
    }

    try {
      // Step 1: Create user in Firebase
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await userCredential.user?.updateDisplayName('$firstName $lastName');

      // Step 2: Save user details to your backend
      final requestBody = {
        'first_name': firstName.trim(),
        'last_name': lastName.trim(),
        'email': email.toLowerCase(),
        'phone': phone,
        'password': password,
      };

      print('Registration request body: $requestBody');

      final res = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      print('Registration response status: ${res.statusCode}');
      print('Registration response body: ${res.body}');

      final data = jsonDecode(res.body);
      if (data['success'] == true) {
        return {
          'success': true,
          'user': userCredential.user,
          'message': data['message'] ?? 'Registration successful'
        };
      } else {
        // If backend registration fails, delete the Firebase user to avoid inconsistency
        await userCredential.user?.delete();
        return {
          'success': false,
          'error': data['error'] ?? 'Backend registration failed',
          'details': data['details'] ?? []
        };
      }
    } catch (e) {
      // Handle Firebase or network errors
      return {
        'success': false,
        'error': 'Registration failed',
        'details': [e.toString()]
      };
    }
  }

  // --- Firebase Auth Login (ENHANCED VALIDATION) ---
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    // Client-side validation
    final errors = <String>[];
    
    if (!isValidEmail(email)) {
      errors.add('Please provide a valid email address');
    }
    
    if (password.isEmpty) {
      errors.add('Password is required');
    }

    if (errors.isNotEmpty) {
      return {
        'success': false,
        'error': 'Validation failed',
        'details': errors
      };
    }

    try {
      // Step 1: Authenticate with Firebase first.
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Step 2: Log in to your backend to get user profile data.
      final requestBody = {
        'email': email.toLowerCase(),
        'password': password,
      };

      print('Login request body: $requestBody');

      final res = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );
      
      print('Login response status: ${res.statusCode}');
      print('Login response body: ${res.body}');
      
      final data = jsonDecode(res.body);

      if (data['success'] == true && data['user'] != null) {
        return {
          'success': true,
          'user': data['user'], // Your backend user data
          'firebaseUser': userCredential.user, // Firebase user object
          'message': data['message'] ?? 'Login successful'
        };
      } else {
        return {
          'success': false,
          'error': data['error'] ?? 'Invalid credentials',
          'details': data['details'] ?? []
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Login failed',
        'details': [e.toString()]
      };
    }
  }

  // --- Firebase Auth Password Reset (ENHANCED VALIDATION) ---
  static Future<Map<String, dynamic>> requestPasswordReset({required String email}) async {
    if (!isValidEmail(email)) {
      return {
        'success': false,
        'error': 'Invalid email address',
        'details': ['Please provide a valid email address']
      };
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return {'success': true, 'message': 'Password reset email sent'};
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to send password reset email',
        'details': [e.toString()]
      };
    }
  }

  // --- Get Packages (ENHANCED VALIDATION) ---
  static Future<Map<String, dynamic>> getPackages() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/packages'));
      
      print('Get packages response status: ${res.statusCode}');
      print('Get packages response body: ${res.body}');
      
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return {
          'success': true,
          'packages': data['packages'] ?? [],
          'message': data['message'] ?? 'Packages fetched successfully'
        };
      } else {
        return {
          'success': false,
          'error': 'Server error: ${res.statusCode}',
          'details': [res.body]
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch packages',
        'details': [e.toString()]
      };
    }
  }

  // --- Get Add-ons (ENHANCED VALIDATION) ---
  static Future<List<dynamic>> getAddOns() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/addons'));
      
      print('Get add-ons response status: ${res.statusCode}');
      print('Get add-ons response body: ${res.body}');
      
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return data['addons'] ?? [];
      } else {
        print('Failed to fetch addons: ${res.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching addons: $e');
      return [];
    }
  }

  // --- Get Backgrounds (ENHANCED VALIDATION) ---
  static Future<List<dynamic>> getBackgrounds() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/backgrounds'));
      
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return data['backgrounds'] ?? [];
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  // --- Book (ENHANCED VALIDATION) ---
  static Future<Map<String, dynamic>> book({
    required int userId,
    required int packageId,
    required String bookingLabel,
    required String bookingDate,
    required String bookingTime,
    String? backdrop,
    List<int>? addOnIds,
    String? userName,
  }) async {
    // Client-side validation
    final errors = <String>[];
    
    if (!isValidId(userId)) {
      errors.add('Valid user_id is required');
    }
    
    if (!isValidId(packageId)) {
      errors.add('Valid package_id is required');
    }
    
    if (bookingLabel.trim().length < 2) {
      errors.add('Booking label must be at least 2 characters');
    }
    
    if (!isValidDate(bookingDate)) {
      errors.add('Valid booking date is required (MM/DD/YYYY or YYYY-MM-DD format)');
    }
    
    if (!isValidTime(bookingTime)) {
      errors.add('Valid booking time is required (e.g., 10:00 am, 2:00 pm)');
    }
    
    if (backdrop != null && backdrop.trim().length < 2) {
      errors.add('Backdrop must be at least 2 characters if provided');
    }
    
    if (addOnIds != null && addOnIds.any((id) => !isValidId(id))) {
      errors.add('All add-on IDs must be valid positive integers');
    }

    if (errors.isNotEmpty) {
      return {
        'success': false,
        'error': 'Validation failed',
        'details': errors
      };
    }

    final requestBody = {
      'user_id': userId,
      'package_id': packageId,
      'booking_label': bookingLabel.trim(),
      'booking_date': bookingDate,
      'booking_time': bookingTime,
      'backdrop': backdrop?.trim(),
      'addon_ids': addOnIds ?? [],
      'user_name': userName?.trim(),
    };
    
    print('Booking request body: $requestBody');
    
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/book'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );
      
      print('Booking response status: ${res.statusCode}');
      print('Booking response body: ${res.body}');
      
      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = jsonDecode(res.body);
        return {
          'success': true,
          'booking_id': data['booking_id'],
          'total_amount': data['total_amount'],
          'message': data['message'] ?? 'Booking created successfully'
        };
      } else {
        final data = jsonDecode(res.body);
        return {
          'success': false,
          'error': data['error'] ?? 'Server error: ${res.statusCode}',
          'details': data['details'] ?? [res.body]
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to create booking',
        'details': [e.toString()]
      };
    }
  }

  // --- Payment (ENHANCED VALIDATION) ---
  static Future<Map<String, dynamic>> payment({
    required int bookingId,
    required double amount,
    required String paymentMethod,
    String? proofImageUrl,
  }) async {
    // Client-side validation
    final errors = <String>[];
    
    if (!isValidId(bookingId)) {
      errors.add('Valid booking_id is required');
    }
    
    if (!isValidAmount(amount)) {
      errors.add('Valid amount is required (must be greater than 0)');
    }
    
    if (!['GCash', 'Cash', 'Card'].contains(paymentMethod)) {
      errors.add('Valid payment method is required (GCash, Cash, or Card)');
    }
    
    if (proofImageUrl != null && proofImageUrl.trim().isEmpty) {
      errors.add('Proof image URL must not be empty if provided');
    }

    if (errors.isNotEmpty) {
      return {
        'success': false,
        'error': 'Validation failed',
        'details': errors
      };
    }

    final requestBody = {
      'booking_id': bookingId,
      'amount': amount,
      'payment_method': paymentMethod,
      'proof_image_url': proofImageUrl?.trim(),
    };
    
    print('Payment request body: $requestBody');
    
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/payment'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );
      
      print('Payment response status: ${res.statusCode}');
      print('Payment response body: ${res.body}');
      
      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = jsonDecode(res.body);
        return {
          'success': true,
          'payment_id': data['payment_id'],
          'booking_id': data['booking_id'],
          'message': data['message'] ?? 'Payment processed successfully'
        };
      } else {
        final data = jsonDecode(res.body);
        return {
          'success': false,
          'error': data['error'] ?? 'Server error: ${res.statusCode}',
          'details': data['details'] ?? [res.body]
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to process payment',
        'details': [e.toString()]
      };
    }
  }
  
  // --- Get Profile (ENHANCED VALIDATION) ---
  static Future<Map<String, dynamic>> getProfile(int userId) async {
    if (!isValidId(userId)) {
      return {
        'success': false,
        'error': 'Invalid user ID',
        'details': ['User ID must be a valid positive integer']
      };
    }

    try {
      final res = await http.get(Uri.parse('$baseUrl/profile/$userId'));
      
      print('Get profile response status: ${res.statusCode}');
      print('Get profile response body: ${res.body}');
      
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return {
          'success': true,
          'profile': data['profile'],
          'message': data['message'] ?? 'Profile fetched successfully'
        };
      } else {
        final data = jsonDecode(res.body);
        return {
          'success': false,
          'error': data['error'] ?? 'Server error: ${res.statusCode}',
          'details': data['details'] ?? [res.body]
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch profile',
        'details': [e.toString()]
      };
    }
  }

  // --- Get Booking Details (ENHANCED VALIDATION) ---
  static Future<Map<String, dynamic>> getBookingDetails(int bookingId) async {
    if (!isValidId(bookingId)) {
      return {
        'success': false,
        'error': 'Invalid booking ID',
        'details': ['Booking ID must be a valid positive integer']
      };
    }

    try {
      final res = await http.get(Uri.parse('$baseUrl/booking/$bookingId'));
      
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return {
          'success': true,
          'booking': data['booking'],
          'message': data['message'] ?? 'Booking details fetched successfully'
        };
      } else {
        final data = jsonDecode(res.body);
        return {
          'success': false,
          'error': data['error'] ?? 'Server error: ${res.statusCode}',
          'details': data['details'] ?? [res.body]
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch booking details',
        'details': [e.toString()]
      };
    }
  }

  // --- Get User Bookings (ENHANCED VALIDATION) ---
  static Future<Map<String, dynamic>> getUserBookings(int userId) async {
    if (!isValidId(userId)) {
      return {
        'success': false,
        'error': 'Invalid user ID',
        'details': ['User ID must be a valid positive integer']
      };
    }

    try {
      final res = await http.get(Uri.parse('$baseUrl/bookings/$userId'));
      
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return {
          'success': true,
          'bookings': data['bookings'] ?? [],
          'message': data['message'] ?? 'Bookings fetched successfully'
        };
      } else {
        final data = jsonDecode(res.body);
        return {
          'success': false,
          'error': data['error'] ?? 'Server error: ${res.statusCode}',
          'details': data['details'] ?? [res.body]
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch user bookings',
        'details': [e.toString()]
      };
    }
  }

  // --- Cancel Booking (ENHANCED VALIDATION) ---
  static Future<Map<String, dynamic>> cancelBooking(int bookingId) async {
    if (!isValidId(bookingId)) {
      return {
        'success': false,
        'error': 'Invalid booking ID',
        'details': ['Booking ID must be a valid positive integer']
      };
    }

    try {
      final res = await http.put(
        Uri.parse('$baseUrl/booking/$bookingId/cancel'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return {
          'success': true,
          'message': data['message'] ?? 'Booking cancelled successfully'
        };
      } else {
        final data = jsonDecode(res.body);
        return {
          'success': false,
          'error': data['error'] ?? 'Server error: ${res.statusCode}',
          'details': data['details'] ?? [res.body]
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to cancel booking',
        'details': [e.toString()]
      };
    }
  }

  // --- Password Reset Flow (ENHANCED VALIDATION) ---
  static Future<Map<String, dynamic>> requestPasswordResetCode({required String email}) async {
    if (!isValidEmail(email)) {
      return {
        'success': false,
        'error': 'Invalid email address',
        'details': ['Please provide a valid email address']
      };
    }

    try {
      final res = await http.post(
        Uri.parse('$baseUrl/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email.toLowerCase()}),
      );
      
      final data = jsonDecode(res.body);
      return {
        'success': data['success'] ?? false,
        'message': data['message'] ?? 'Password reset request processed',
        'code': data['code'], // Remove in production
        'error': data['error'],
        'details': data['details'] ?? []
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to request password reset',
        'details': [e.toString()]
      };
    }
  }

  static Future<Map<String, dynamic>> verifyResetCode({
    required String email,
    required String code,
  }) async {
    final errors = <String>[];
    
    if (!isValidEmail(email)) {
      errors.add('Valid email address is required');
    }
    
    if (!RegExp(r'^\d{6}$').hasMatch(code)) {
      errors.add('Valid 6-digit code is required');
    }

    if (errors.isNotEmpty) {
      return {
        'success': false,
        'error': 'Validation failed',
        'details': errors
      };
    }

    try {
      final res = await http.post(
        Uri.parse('$baseUrl/verify-reset-code'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email.toLowerCase(),
          'code': code,
        }),
      );
      
      final data = jsonDecode(res.body);
      return {
        'success': data['success'] ?? false,
        'message': data['message'] ?? 'Code verification completed',
        'error': data['error'],
        'details': data['details'] ?? []
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to verify reset code',
        'details': [e.toString()]
      };
    }
  }

  static Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    final errors = <String>[];
    
    if (!isValidEmail(email)) {
      errors.add('Valid email address is required');
    }
    
    if (!RegExp(r'^\d{6}$').hasMatch(code)) {
      errors.add('Valid 6-digit code is required');
    }
    
    if (!isValidPassword(newPassword)) {
      errors.add('New password must be at least 6 characters long');
    }

    if (errors.isNotEmpty) {
      return {
        'success': false,
        'error': 'Validation failed',
        'details': errors
      };
    }

    try {
      final res = await http.post(
        Uri.parse('$baseUrl/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email.toLowerCase(),
          'code': code,
          'new_password': newPassword,
        }),
      );
      
      final data = jsonDecode(res.body);
      return {
        'success': data['success'] ?? false,
        'message': data['message'] ?? 'Password reset completed',
        'error': data['error'],
        'details': data['details'] ?? []
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to reset password',
        'details': [e.toString()]
      };
    }
  }

  // --- Update Password (ENHANCED VALIDATION) ---
  static Future<Map<String, dynamic>> updatePassword({
    required String email,
    required String newPassword,
  }) async {
    final errors = <String>[];
    
    if (!isValidEmail(email)) {
      errors.add('Valid email address is required');
    }
    
    if (!isValidPassword(newPassword)) {
      errors.add('New password must be at least 6 characters long');
    }

    if (errors.isNotEmpty) {
      return {
        'success': false,
        'error': 'Validation failed',
        'details': errors
      };
    }

    try {
      final res = await http.post(
        Uri.parse('$baseUrl/update-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email.toLowerCase(),
          'new_password': newPassword,
        }),
      );
      
      final data = jsonDecode(res.body);
      return {
        'success': data['success'] ?? false,
        'message': data['message'] ?? 'Password updated successfully',
        'error': data['error'],
        'details': data['details'] ?? []
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to update password',
        'details': [e.toString()]
      };
    }
  }

  // --- DELETE Methods ---

  // Delete user
  static Future<Map<String, dynamic>> deleteUser(int userId) async {
    if (!isValidId(userId)) {
      return {
        'success': false,
        'error': 'Invalid user ID',
        'details': ['User ID must be a valid positive integer']
      };
    }

    try {
      final res = await http.delete(
        Uri.parse('$baseUrl/user/$userId'),
        headers: {'Content-Type': 'application/json'},
      );
      
      print('Delete user response status: ${res.statusCode}');
      print('Delete user response body: ${res.body}');
      
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return {
          'success': true,
          'message': data['message'] ?? 'User deleted successfully'
        };
      } else {
        final data = jsonDecode(res.body);
        return {
          'success': false,
          'error': data['error'] ?? 'Server error: ${res.statusCode}',
          'details': data['details'] ?? [res.body]
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to delete user',
        'details': [e.toString()]
      };
    }
  }

  // Delete booking
  static Future<Map<String, dynamic>> deleteBooking(int bookingId) async {
    if (!isValidId(bookingId)) {
      return {
        'success': false,
        'error': 'Invalid booking ID',
        'details': ['Booking ID must be a valid positive integer']
      };
    }

    try {
      final res = await http.delete(
        Uri.parse('$baseUrl/booking/$bookingId'),
        headers: {'Content-Type': 'application/json'},
      );
      
      print('Delete booking response status: ${res.statusCode}');
      print('Delete booking response body: ${res.body}');
      
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return {
          'success': true,
          'message': data['message'] ?? 'Booking deleted successfully'
        };
      } else {
        final data = jsonDecode(res.body);
        return {
          'success': false,
          'error': data['error'] ?? 'Server error: ${res.statusCode}',
          'details': data['details'] ?? [res.body]
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to delete booking',
        'details': [e.toString()]
      };
    }
  }

  // Delete payment
  static Future<Map<String, dynamic>> deletePayment(int paymentId) async {
    if (!isValidId(paymentId)) {
      return {
        'success': false,
        'error': 'Invalid payment ID',
        'details': ['Payment ID must be a valid positive integer']
      };
    }

    try {
      final res = await http.delete(
        Uri.parse('$baseUrl/payment/$paymentId'),
        headers: {'Content-Type': 'application/json'},
      );
      
      print('Delete payment response status: ${res.statusCode}');
      print('Delete payment response body: ${res.body}');
      
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return {
          'success': true,
          'message': data['message'] ?? 'Payment deleted successfully'
        };
      } else {
        final data = jsonDecode(res.body);
        return {
          'success': false,
          'error': data['error'] ?? 'Server error: ${res.statusCode}',
          'details': data['details'] ?? [res.body]
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to delete payment',
        'details': [e.toString()]
      };
    }
  }

  // Delete add-on from booking
  static Future<Map<String, dynamic>> deleteAddonFromBooking(int bookingId, int addonId) async {
    if (!isValidId(bookingId)) {
      return {
        'success': false,
        'error': 'Invalid booking ID',
        'details': ['Booking ID must be a valid positive integer']
      };
    }

    if (!isValidId(addonId)) {
      return {
        'success': false,
        'error': 'Invalid add-on ID',
        'details': ['Add-on ID must be a valid positive integer']
      };
    }

    try {
      final res = await http.delete(
        Uri.parse('$baseUrl/booking/$bookingId/addon/$addonId'),
        headers: {'Content-Type': 'application/json'},
      );
      
      print('Delete add-on response status: ${res.statusCode}');
      print('Delete add-on response body: ${res.body}');
      
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return {
          'success': true,
          'message': data['message'] ?? 'Add-on removed from booking successfully',
          'new_total': data['new_total']
        };
      } else {
        final data = jsonDecode(res.body);
        return {
          'success': false,
          'error': data['error'] ?? 'Server error: ${res.statusCode}',
          'details': data['details'] ?? [res.body]
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to remove add-on from booking',
        'details': [e.toString()]
      };
    }
  }

  // --- Get all users ---
  static Future<Map<String, dynamic>> getAllUsers() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/users'));
      print('Get all users response status: ${res.statusCode}');
      print('Get all users response body: ${res.body}');
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return {
          'success': true,
          'users': data['users'] ?? [],
          'message': data['message'] ?? 'Users fetched successfully'
        };
      } else {
        final data = jsonDecode(res.body);
        return {
          'success': false,
          'error': data['error'] ?? 'Server error: ${res.statusCode}',
          'details': data['details'] ?? [res.body]
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch users',
        'details': [e.toString()]
      };
    }
  }
}
