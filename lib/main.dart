import 'package:dosing_assistant/data.dart';
import 'package:dosing_assistant/drug_dosage_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DrugDosagePage(dose: dopamineDose),
    );
  }
}
