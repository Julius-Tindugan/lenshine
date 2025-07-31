import 'package:flutter/material.dart';
import 'package:lenshine/models/chat_message.dart';

// --- Hardcoded FAQs ---
const List<Map<String, String>> faqs = [
  {
    "q": "How do I book a session with Lenshine?",
    "a": "To book a session, open the Lenshine app or website. Select your preferred package (Self-Shoot, Party, or Wedding), choose your date and time, fill in your details, and confirm your booking. You will receive a confirmation and payment instructions."
  },
  {
    "q": "What information do I need to provide for booking?",
    "a": "You will need to provide your name, phone number, email address, preferred date and time, and select your desired package. You may also choose add-ons or specify a backdrop color if available."
  },
  {
    "q": "How far in advance can I book?",
    "a": "You can book up to 6 months in advance. Early booking is recommended, especially for weekends and special occasions."
  },
  {
    "q": "Is a deposit required for booking?",
    "a": "Yes, a 50% deposit is required to secure your booking. The remaining balance is payable on the day of your session."
  },
  {
    "q": "What photography packages do you offer?",
    "a": "Lenshine offers Self-Shoot, Party, and Wedding packages. Each package has different inclusions and pricing. For example, Self-Shoot starts at PHP 399, Party Packages at PHP 9000, and Wedding Packages from PHP 5000."
  },
  {
    "q": "What is included in the Self-Shoot package?",
    "a": "The Solo Self-Shoot package (PHP 399) includes 20 minutes of shoot time, unlimited shots, 1 backdrop, 10 minutes for photo selection, all soft copies, and 1 4R size print."
  },
  {
    "q": "What is included in the Party package?",
    "a": "Party packages (Kids or Birthday, PHP 9000) include 2-3 hours photo coverage, pre-event photoshoot, 200-300+ soft copies, all copies enhanced, sent via Google Drive, and an online gallery."
  },
  {
    "q": "What is included in the Wedding package?",
    "a": "Wedding packages (Civil Wedding PHP 5000, Church Wedding PHP 7500) include full event coverage, pre-event photoshoot, 200-300+ soft copies, all copies enhanced, sent via Google Drive, and an online gallery."
  },
  {
    "q": "Can I add extras or customize my package?",
    "a": "Yes, you can select add-ons such as extra prints or special backdrops during the booking process."
  },
  {
    "q": "What payment methods do you accept?",
    "a": "We accept GCash, bank transfer, and major credit/debit cards. Payment instructions will be provided after booking."
  },
  {
    "q": "When is the full payment due?",
    "a": "The remaining balance is due on the day of your session, before your shoot begins."
  },
  {
    "q": "Is my online payment secure?",
    "a": "Yes, all payments are processed securely. Your financial information is protected."
  },
  {
    "q": "What is your cancellation policy?",
    "a": "Full refund if cancelled at least 48 hours before your booking. 25% fee for 24-48 hours notice. Less than 24 hours, the booking is non-refundable."
  },
  {
    "q": "How do I reschedule a booking?",
    "a": "You can reschedule via the app or by contacting customer support at least 24 hours before your session."
  },
  {
    "q": "What equipment is available in the studio?",
    "a": "Studios are equipped with professional lighting, backdrops, and basic props. You may bring your own equipment if you wish."
  },
  {
    "q": "Are there changing rooms and restrooms?",
    "a": "Yes, all Lenshine studios have private changing rooms and restrooms for your convenience."
  },
  {
    "q": "Is Wi-Fi available?",
    "a": "Yes, complimentary Wi-Fi is available in all studios."
  },
  {
    "q": "How can I contact Lenshine?",
    "a": "You can reach us via email at support@lenshine.com or call 0983-123-4567. Our customer support is available Monday to Friday, 9 AM to 6 PM."
  },
  {
    "q": "What are your operating hours?",
    "a": "Studios are open for booking from 8 AM to 10 PM, 7 days a week. Check the app for available slots."
  },
  {
    "q": "Can I bring guests to my session?",
    "a": "Yes, but please observe the maximum capacity for each studio. Check your package details for guest limits."
  },
  {
    "q": "Are pets allowed?",
    "a": "Pets are not allowed, except for certified service animals. Please contact us for special arrangements."
  },
  {
    "q": "Are your studios wheelchair accessible?",
    "a": "Yes, all Lenshine studios are wheelchair accessible, including ramps and accessible restrooms."
  },
];

class ChatbotScreen extends StatefulWidget {
  final VoidCallback onClose;
  const ChatbotScreen({super.key, required this.onClose});

  @override
  ChatbotScreenState createState() => ChatbotScreenState();
}

class ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<ChatMessage> messages = [
    ChatMessage("Hello, my name is LENSHI!!", isBot: true),
    ChatMessage("I'm your FAQ buddy — ready to answer your most common questions and guide you every step of the way!", isBot: true),
    ChatMessage("Ask me anything about booking, packages, payment, or studio amenities!", isBot: true),
  ];

  void _sendMessage() {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.add(ChatMessage(text, isBot: false));
      String reply = _getFaqReply(text);
      messages.add(ChatMessage(reply, isBot: true));
    });

    _inputController.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  String _getFaqReply(String userInput) {
    final input = userInput.toLowerCase();
    // Try to find the best matching FAQ
    for (final faq in faqs) {
      final question = faq["q"]!.toLowerCase();
      // Match if user input contains a significant part of the question
      if (input.contains(question) ||
          question.contains(input) ||
          _isSimilar(input, question)) {
        return faq["a"]!;
      }
    }
    // Try keyword match
    for (final faq in faqs) {
      final question = faq["q"]!.toLowerCase();
      final keywords = question.split(RegExp(r'[\s\?\.,]+'));
      for (final word in keywords) {
        if (word.length > 3 && input.contains(word)) {
          return faq["a"]!;
        }
      }
    }
    return "I'm sorry, I couldn't find an answer for that. Please try asking about booking, packages, payment, cancellation, amenities, or contact info!";
  }

  // Simple similarity check (can be improved)
  bool _isSimilar(String a, String b) {
    int matches = 0;
    final aWords = a.split(' ');
    final bWords = b.split(' ');
    for (final word in aWords) {
      if (bWords.contains(word)) matches++;
    }
    return matches >= 2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 40),
                  const Column(
                    children: [
                      Text("ASK LenShine", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                      Text("Frequently Asked Questions", style: TextStyle(color: Colors.grey, fontSize: 15)),
                    ],
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.black),
                      onPressed: widget.onClose,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Chat Area
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(12.0),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];
                  if (msg.isBot) {
                    return BotMessageBubble(text: msg.text);
                  } else {
                    return UserMessageBubble(text: msg.text);
                  }
                },
              ),
            ),

            // Input Bar
            Container(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
              color: Colors.white,
              child: Row(
                children: [
                   CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    child: IconButton(
                      icon: const Icon(Icons.add, color: Colors.black),
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _inputController,
                      decoration: InputDecoration(
                        hintText: "Press here to talk to LENSHI",
                        fillColor: Colors.grey[200],
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                     backgroundColor: Colors.black,
                     child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BotMessageBubble extends StatelessWidget {
  final String text;
  const BotMessageBubble({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.black,
            child: CircleAvatar(
              radius: 17,
              backgroundColor: Colors.white,
              child: Image.asset('assets/images/chatbot.png', width: 28, color: Colors.black),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }
}

class UserMessageBubble extends StatelessWidget {
  final String text;
  const UserMessageBubble({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: const BorderRadius.all(Radius.circular(20)),
              ),
              child: Text(text, style: const TextStyle(color: Colors.black, fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }
}