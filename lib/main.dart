import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'splash_screen_ui.dart'; // ดึงหน้าโหลดมาใช้

void main() async {
  // 1. ตรวจสอบระบบ
  WidgetsFlutterBinding.ensureInitialized();

  // 2. เชื่อมต่อ Supabase (ใช้ Key เดิมของคุณ)
  await Supabase.initialize(
    url: 'https://qqxduljawzmxycwudegf.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFxeGR1bGphd3pteHljd3VkZWdmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzY2ODA5NDYsImV4cCI6MjA5MjI1Njk0Nn0.BVSRlGg8c65nhQ96cbiRd1UugbIWKYV7dgQJntttUgc',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Meeting Room App',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.orange,
      ),
      // เริ่มต้นที่หน้า Splash Screen ที่เราทำกันไว้
      home: const SplashScreenUI(), 
    );
  }
}