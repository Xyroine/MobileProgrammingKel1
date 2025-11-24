import 'package:flutter/material.dart';
// Import file yang baru dibuat
import 'detail_pemesanan_kamar.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hotel Booking App',
      theme: ThemeData(
        // Setting tema global ke dark
        scaffoldBackgroundColor: const Color(0xFF121820),
        brightness: Brightness.dark,
        fontFamily: 'Roboto', 
      ),
      // Panggil class BookingConfirmationScreen dari file detail_pemesanan_kamar.dart
      home: const BookingConfirmationScreen(),
    );
  }
}