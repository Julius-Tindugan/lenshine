import 'package:flutter/material.dart';

class HomeLandingScreen extends StatefulWidget {
  final VoidCallback onShowSelfShootDetails;
  final VoidCallback onShowPartyDetails;
  final VoidCallback onShowWeddingDetails;
  final VoidCallback onShowChristeningDetails;
  final VoidCallback onLogout;

  const HomeLandingScreen({
    super.key,
    required this.onShowSelfShootDetails,
    required this.onShowPartyDetails,
    required this.onShowWeddingDetails,
    required this.onShowChristeningDetails,
    required this.onLogout,
  });

  @override
  State<HomeLandingScreen> createState() => _HomeLandingScreenState();
}

class _HomeLandingScreenState extends State<HomeLandingScreen> {
  String selectedService = "All";

  final Map<String, String> serviceImages = {
    "Self-Shoot": 'assets/images/selftwo.png',
    "Party": 'assets/images/partytwo.png',
    "Wedding": 'assets/images/weddingtwo.png',
    "Christening": 'assets/images/christeningtwo.png',
  };

  final List<String> services = [
    "All", "Self-Shoot", "Party", "Wedding", "Christening"
  ];

  @override
  Widget build(BuildContext context) {
    // Filtered list: if "All" is selected, show all, else show selected first
    List<String> filteredPopularServices = (selectedService == "All")
        ? serviceImages.keys.toList()
        : [selectedService, ...serviceImages.keys.where((s) => s != selectedService)];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: const TextSpan(
                            style: TextStyle(fontSize: 28, color: Colors.black),
                            children: [
                              TextSpan(text: "Hey, "),
                              TextSpan(
                                text: "Kristine!",
                                style: TextStyle(fontWeight: FontWeight.w800),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(height: 3, width: 62, color: Colors.grey[300]),
                        const SizedBox(height: 8),
                        const Text(
                          "What moments \nare we capturing today?",
                          style: TextStyle(fontSize: 20, color: Colors.black54),
                        ),
                      ],
                    ),
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'Logout') widget.onLogout();
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem<String>(
                          value: 'Logout',
                          child: Text('Logout'),
                        ),
                      ],
                      icon: const Icon(Icons.more_vert),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Explore our Services
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Card(
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Explore our Services", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19)),
                        const SizedBox(height: 8),
                        ExploreServicesSection(
                          selectedService: selectedService,
                          onServiceSelected: (service) {
                            setState(() => selectedService = service);
                           
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 23),
              // Popular
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text("Popular", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19)),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 280,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredPopularServices.length,
                  itemBuilder: (context, index) {
                    final service = filteredPopularServices[index];
                    return GestureDetector(
                      onTap: () {
                        switch (service) {
                          case "Self-Shoot": widget.onShowSelfShootDetails(); break;
                          case "Party": widget.onShowPartyDetails(); break;
                          case "Wedding": widget.onShowWeddingDetails(); break;
                          case "Christening": widget.onShowChristeningDetails(); break;
                        }
                      },
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        margin: const EdgeInsets.only(right: 8),
                        child: SizedBox(
                          width: 340,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                serviceImages[service]!,
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(height: 18),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                child: Text(service, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12.0),
                                child: Text("Package", style: TextStyle(fontSize: 17, color: Colors.grey)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 23),
              // Special Promo
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text("Special Promo", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19)),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Image.asset(
                    'assets/images/offer.png',
                    height: 175,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20), // Space before bottom nav bar
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