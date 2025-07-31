class TermsFormatter {
  static String formatContent(String content) {
    final sections = content.split('\n\n');
    final buffer = StringBuffer();
    
    for (var section in sections) {
      if (section.startsWith('#')) {
        // Main headers
        buffer.writeln('\n${section.trim()}\n${'-' * 40}\n');
      } else if (section.startsWith('###')) {
        // Subheaders
        buffer.writeln('\n${section.trim()}\n');
      } else {
        // Regular content with proper indentation
        final lines = section.split('\n');
        for (var line in lines) {
          if (line.trim().startsWith('•')) {
            buffer.writeln('  ${line.trim()}');
          } else if (line.trim().startsWith('-')) {
            buffer.writeln('    ${line.trim()}');
          } else {
            buffer.writeln(line.trim());
          }
        }
        buffer.writeln();
      }
    }
    
    return buffer.toString();
  }

  static String getFormattedPrivacyPolicy() {
    return '''
PRIVACY POLICY
================================
LenShine Mobile Application
Version 1.0
Last Updated: July 25, 2025

I. INFORMATION COLLECTION AND USE
--------------------------------
A. Personal Information
  • Basic Information
    - Full name
    - Email address
    - Contact number
  • Transaction Data
    - Payment details
    - Booking history
    - Session preferences

B. Technical Data
  • Device information
  • IP address
  • Session analytics
  • Cookies and usage data

II. DATA PROCESSING AND USAGE
----------------------------
A. Primary Purposes
  • Service Delivery
    - Booking management
    - Payment processing
    - Session coordination
  • Communication
    - Appointment reminders
    - Booking confirmations
  • Business Operations
    - Analytics and reporting
    - Service improvement

III. DATA SECURITY
-----------------
• Data Protection Measures
  - TLS 1.2+ encryption
  - AES-256 for stored data
  - Regular security audits

IV. USER RIGHTS
--------------
• Access and Control
  - View personal data
  - Update information
  - Request deletion
• Communication Preferences
  - Opt-out options
  - Notification settings

V. DATA RETENTION
----------------
• Active Accounts: Continuous maintenance
• Inactive Accounts: 2-year threshold
• Data Removal: Secure deletion process

VI. CONTACT INFORMATION
----------------------
Shine Spot Studio Support:
• Email: shinespotstudio@gmail.com
• Phone: 0991 690 5443
• Response: 24-48 hours''';
  }

  static String getFormattedTerms() {
    return '''
TERMS AND CONDITIONS
===================
LenShine Mobile Application
Version 1.0
Last Updated: July 25, 2025

I. ACCEPTANCE OF TERMS
---------------------
By using the LenShine app, you agree to:
• Follow booking procedures
• Provide accurate information
• Comply with payment terms
• Respect intellectual property

II. USER ACCOUNTS
----------------
A. Registration
  • Accurate personal details
  • Valid contact information
  • Password security

B. Account Security
  • Confidential credentials
  • Immediate breach reporting
  • Regular security updates

III. BOOKING & PAYMENTS
----------------------
A. Booking Process
  • Digital scheduling system
  • Package customization
  • Real-time availability

B. Payment Terms
  • GCash (Primary)
  • Cash (On-site)
  • Secure transactions

C. Cancellation Policy
  • 24+ hours: Full refund
  • Under 24 hours: No refund

IV. INTELLECTUAL PROPERTY
------------------------
• User Content Ownership
• Studio License Rights
• App Copyright Protection

V. LIABILITY LIMITS
------------------
• Technical Issues
• Service Disputes
• Data Responsibility

VI. LEGAL COMPLIANCE
-------------------
• Philippine Law
• Data Privacy Act 2012
• Dispute Resolution

Contact Support:
• Email: shinespotstudio@gmail.com
• Phone: 0991 690 5443''';
  }
}
