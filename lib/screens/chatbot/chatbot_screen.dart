import 'package:flutter/material.dart';
import 'package:lenshine/models/chat_message.dart';


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
    ChatMessage("Ask me anything, I'm here to help!", isBot: true),
  ];

  void _sendMessage() {
    final text = _inputController.text;
    if (text.isEmpty) return;

    setState(() {
      messages.add(ChatMessage(text, isBot: false));
      // Simple bot logic
      String reply = "I'm sorry, I don't understand that. You can ask me about 'walk-ins'.";
      if (text.toLowerCase().contains("walk-in") || text.toLowerCase().contains("walk in")) {
        reply = "Yes, we accept walk-ins! You can visit our studio anytime during our opening hours.";
      }
      messages.add(ChatMessage(reply, isBot: true));
    });

    _inputController.clear();
    // Scroll to bottom after sending message
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
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
                  const SizedBox(width: 40), // Spacer for balance
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
              child: Image.asset('assets/images/chatbot.png', width: 28, color: Colors.black), // Placeholder
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