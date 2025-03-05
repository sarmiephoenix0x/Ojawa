import 'package:flutter/material.dart';

import '../../data/model/faq_item_model.dart';

class FaqPageController extends ChangeNotifier {
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

  //public getters
  List<FaqItem> get faqItems => _faqItems;
}
