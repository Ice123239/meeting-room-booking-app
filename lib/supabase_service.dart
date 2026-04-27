import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final supabase = Supabase.instance.client;

  // ดึงรายชื่อห้องทั้งหมด
  Future<List<dynamic>> getRooms() async {
    final data = await supabase.from('rooms').select('*');
    return data as List<dynamic>;
  }

  // ฟังก์ชันจองห้อง (สำหรับหน้า AddBookingUI)
  Future<void> bookRoom(int roomId, String title) async {
    await supabase.from('bookings').insert({
      'room_id': roomId,
      'title': title,
      'status': 'pending', // สถานะเริ่มต้น
    });
  }
}