import 'package:flutter/material.dart';

// Add imports
import 'package:lenshine/models/package_item.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:lenshine/widgets/common_dialogs.dart';

const Map<String, String> serviceImages = {
  "Self-Shoot": "assets/images/selfshoot.png",
  "Party": "assets/images/party.png",
  "Wedding": "assets/images/wedding.png",
  "Christening": "assets/images/christening_placeholder.png",
};


class HomeLandingScreen extends StatefulWidget {
  final VoidCallback onShowSelfShootDetails;
  final VoidCallback onShowPartyDetails;
  final VoidCallback onShowWeddingDetails;
  final VoidCallback onShowChristeningDetails;
  final VoidCallback onLogout;
  final String userName;
  final List<PackageItem> packages;

  const HomeLandingScreen({
    super.key,
    required this.onShowSelfShootDetails,
    required this.onShowPartyDetails,
    required this.onShowWeddingDetails,
    required this.onShowChristeningDetails,
    required this.onLogout,
    required this.userName,
    required this.packages,
  });

  @override
  State<HomeLandingScreen> createState() => _HomeLandingScreenState();
}

class _HomeLandingScreenState extends State<HomeLandingScreen> {
   String selectedService = "All";


  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final width = media.size.width;
    final height = media.size.height;
    // Filtered list: if "All" is selected, show all, else show selected first
    List<String> filteredPopularServices = (selectedService == "All")
        ? serviceImages.keys.toList()
        : [selectedService, ...serviceImages.keys.where((s) => s != selectedService)];

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: EdgeInsets.fromLTRB(width * 0.05, height * 0.025, width * 0.05, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: TextStyle(fontSize: width * 0.075, color: Colors.black, fontWeight: FontWeight.w700, letterSpacing: 0.2),
                            children: [
                              const TextSpan(text: "Hey, "),
                              TextSpan(
                                text: widget.userName.isNotEmpty ? "${widget.userName.split(' ')[0]}!" : "Guest!",
                                style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: height * 0.006),
                        Container(height: 3, width: width * 0.18, color: Colors.grey[300]),
                        SizedBox(height: height * 0.01),
                        AutoSizeText(
                          "What moments \nare we capturing today?",
                          style: TextStyle(fontSize: width * 0.05, color: Colors.black54, fontWeight: FontWeight.w500),
                          maxLines: 2,
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => LogoutDialog(
                            onConfirm: () {
                              Navigator.of(context).pop();
                              widget.onLogout();
                            },
                            onCancel: () => Navigator.of(context).pop(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.logout_rounded),
                      tooltip: 'Logout',
                      iconSize: 28,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.025),
              // Hero Banner
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: height * 0.14, maxHeight: height * 0.22),
                  child: Container(
                    height: height * 0.16,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      gradient: LinearGradient(
                        colors: [Colors.black, Colors.black.withOpacity(0.8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(width * 0.045),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(child: AutoSizeText("Capture your best moments!", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22), maxLines: 2, overflow: TextOverflow.ellipsis)),
                                SizedBox(height: 8),
                                Flexible(child: AutoSizeText("Book a session now and enjoy exclusive promos.", style: TextStyle(color: Colors.white70, fontSize: 15), maxLines: 2, overflow: TextOverflow.ellipsis)),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: width * 0.03),
                          child: Image.asset('assets/images/selfshoot.png', height: height * 0.11, fit: BoxFit.contain),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: height * 0.03),
              // Explore our Services
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.025),
                child: Card(
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: EdgeInsets.all(width * 0.035),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText("Explore our Services", style: TextStyle(fontWeight: FontWeight.bold, fontSize: width * 0.048)),
                        SizedBox(height: height * 0.01),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 350),
                          child: ExploreServicesSection(
                            key: ValueKey(selectedService),
                            selectedService: selectedService,
                            onServiceSelected: (service) {
                              setState(() => selectedService = service);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: height * 0.03),
              // Popular
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                child: AutoSizeText("Popular", style: TextStyle(fontWeight: FontWeight.bold, fontSize: width * 0.048)),
              ),
              SizedBox(height: height * 0.01),
              SizedBox(
                height: height * 0.36,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                      itemCount: filteredPopularServices.length,
                      itemBuilder: (context, index) {
                        final service = filteredPopularServices[index];
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeInOut,
                          margin: EdgeInsets.only(right: width * 0.03),
                          child: GestureDetector(
                            onTap: () {
                              switch (service) {
                                case "Self-Shoot":
                                  widget.onShowSelfShootDetails();
                                  break;
                                case "Party":
                                  widget.onShowPartyDetails();
                                  break;
                                case "Wedding":
                                  widget.onShowWeddingDetails();
                                  break;
                                case "Christening":
                                  widget.onShowChristeningDetails();
                                  break;
                              }
                            },
                            child: SizedBox(
                              width: constraints.maxWidth * 0.8,
                              child: Card(
                                clipBehavior: Clip.antiAlias,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                elevation: 6,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Flexible(
                                      flex: 6,
                                      child: Hero(
                                        tag: service,
                                        child: Image.asset(
                                          serviceImages[service]!,
                                          height: height * 0.18,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 4,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: width * 0.03, vertical: height * 0.01),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            AutoSizeText(service, style: TextStyle(fontWeight: FontWeight.w800, fontSize: width * 0.052), maxLines: 1, overflow: TextOverflow.ellipsis),
                                            SizedBox(height: height * 0.002),
                                            AutoSizeText("Package", style: TextStyle(fontSize: width * 0.045, color: Colors.grey)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: height * 0.03),
              // Special Promo
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                child: AutoSizeText("Special Promo", style: TextStyle(fontWeight: FontWeight.bold, fontSize: width * 0.048)),
              ),
              SizedBox(height: height * 0.01),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      colors: [Colors.black, Colors.black.withOpacity(0.8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.10),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.asset(
                      'assets/images/offer.png',
                      height: height * 0.22,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      color: Colors.white.withOpacity(0.85),
                      colorBlendMode: BlendMode.modulate,
                    ),
                  ),
                ),
              ),
              SizedBox(height: height * 0.025),
            ],
          ),
        ),
      ),
    );
  }
}

class ExploreServicesSection extends StatelessWidget {
  final String selectedService;
  final Function(String) onServiceSelected;

  const ExploreServicesSection({
    super.key,
    required this.selectedService,
    required this.onServiceSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildServiceButton("All")),
            const SizedBox(width: 8),
            Expanded(child: _buildServiceButton("Self-Shoot")),
            const SizedBox(width: 8),
            Expanded(child: _buildServiceButton("Party")),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _buildServiceButton("Wedding")),
            const SizedBox(width: 8),
            Expanded(child: _buildServiceButton("Christening")),
          ],
        )
      ],
    );
  }

  Widget _buildServiceButton(String service) {
    final isSelected = selectedService == service;
    return SizedBox(
      height: 38,
      child: OutlinedButton(
        onPressed: () => onServiceSelected(service),
        style: OutlinedButton.styleFrom(
          backgroundColor: isSelected ? Colors.black : Colors.white,
          foregroundColor: isSelected ? Colors.white : Colors.black,
          shape: const StadiumBorder(),
          side: BorderSide(
            color: Colors.black,
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Text(service, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
    );
  }
}