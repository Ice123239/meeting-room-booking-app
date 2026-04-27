import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class BookingHistoryUI extends StatefulWidget {
  const BookingHistoryUI({super.key});

  @override
  State<BookingHistoryUI> createState() => _BookingHistoryUIState();
}

class _BookingHistoryUIState extends State<BookingHistoryUI> {
  String getRoomName(int? roomId) {
    switch (roomId) {
      case 1: return 'ห้องประชุม A (ชั้น 1)';
      case 2: return 'ห้องประชุม B (ชั้น 2)';
      case 3: return 'ห้องสัมมนาใหญ่';
      default: return 'ห้องประชุมทั่วไป (ID: $roomId)';
    }
  }

  // ✅ แก้ไขฟังก์ชันลบใหม่ให้ปลอดภัยขึ้น
  Future<void> _deleteBooking(BuildContext context, int id) async {
    try {
      await Supabase.instance.client.from('bookings').delete().match({'id': id});
      
      // ✅ เช็คก่อนว่า Widget ยังอยู่บนหน้าจอไหม ก่อนจะสั่งแสดง SnackBar หรือ setState
      if (!mounted) return;

      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🗑️ ลบรายการจองเรียบร้อยแล้ว'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      debugPrint('Error deleting: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาด: $e'), backgroundColor: Colors.black),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ประวัติการจอง', 
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        key: UniqueKey(),
        stream: Supabase.instance.client
            .from('bookings')
            .stream(primaryKey: ['id']).order('created_at', ascending: false),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final bookings = snapshot.data ?? [];

          if (bookings.isEmpty) {
            return const Center(child: Text('ไม่มีประวัติการจอง'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              
              String formattedDateTime = "ไม่ระบุเวลา";
              if (booking['created_at'] != null) {
                final DateTime dt = DateTime.parse(booking['created_at']).toLocal();
                formattedDateTime = DateFormat('dd/MM/yyyy HH:mm').format(dt);
              }

              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: ListTile(
                  title: Text(booking['title'] ?? 'หัวข้อการจอง', 
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('ห้อง: ${getRoomName(booking['room_id'])}\nจองเมื่อ: $formattedDateTime น.'),
                  isThreeLine: true,
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () => _confirmDelete(context, booking['id']),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('ยืนยันการลบ?'),
        content: const Text('คุณต้องการลบข้อมูลการจองนี้ใช่หรือไม่?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('ยกเลิก')),
          TextButton(
            onPressed: () { 
              Navigator.pop(ctx); 
              _deleteBooking(context, id); 
            }, 
            child: const Text('ลบ', style: TextStyle(color: Colors.red))
          ),
        ],
      ),
    );
  }
}