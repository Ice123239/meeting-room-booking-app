// lib/splash_screen_ui.dart
import 'package:flutter/material.dart';
import 'room_list_ui.dart';

class SplashScreenUI extends StatefulWidget {
  const SplashScreenUI({super.key});

  @override
  State<SplashScreenUI> createState() => _SplashScreenUIState();
}

class _SplashScreenUIState extends State<SplashScreenUI> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const RoomListUI()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // ✅ เพิ่มการไล่เฉดสีให้ดูมีมิติ ไม่ส้มจืดๆ อย่างเดียว
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.orangeAccent, Colors.deepOrange],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ✅ ใส่ Card ล้อมรอบไอคอนให้ดูเด่น
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(51), // สีขาวจางๆ
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.meeting_room_rounded, size: 100, color: Colors.white),
              ),
              const SizedBox(height: 24),
              const Text(
                "ROOM BOOKING",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                 fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Management System",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 50),
              // ✅ เพิ่ม Loading Indicator แบบวงกลมขาว
              const CircularProgressIndicator(color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}