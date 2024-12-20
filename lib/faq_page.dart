import 'package:flutter/material.dart';

class FaqPage extends StatefulWidget {
  const FaqPage({super.key});

  @override
  _FaqPageState createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  final List<FaqItem> _faqItems = [
    FaqItem(
      question: "What is Flutter?",
      answer:
          "Flutter is an open-source UI software development toolkit created by Google.",
    ),
    FaqItem(
      question: "How does Flutter work?",
      answer:
          "Flutter works by compiling to native code for both iOS and Android.",
    ),
    FaqItem(
      question: "What is Dart?",
      answer: "Dart is the programming language used to build Flutter apps.",
    ),
    // Add more FAQ items as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Header
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    height: 60,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4.0,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          const Text('FAQs', style: TextStyle(fontSize: 20)),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: _faqItems
                          .map((item) => FaqItemWidget(item: item))
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FaqItem {
  final String question;
  final String answer;

  FaqItem({required this.question, required this.answer});
}

class FaqItemWidget extends StatefulWidget {
  final FaqItem item;

  const FaqItemWidget({Key? key, required this.item}) : super(key: key);

  @override
  _FaqItemWidgetState createState() => _FaqItemWidgetState();
}

class _FaqItemWidgetState extends State<FaqItemWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.zero,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.item.question,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Icon(
                    _isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded) ...[
            const Divider(), // Optional divider
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                widget.item.answer,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
