import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddBookingUI extends StatefulWidget {
  final dynamic roomId;
  final String roomName;

  const AddBookingUI({super.key, required this.roomId, required this.roomName});

  @override
  State<AddBookingUI> createState() => _AddBookingUIState();
}

class _AddBookingUIState extends State<AddBookingUI> {
  final TextEditingController _titleController = TextEditingController();
  bool _isLoading = false; // ตัวแปรเช็คสถานะการโหลด

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ปรับ AppBar ให้ดูพรีเมียมขึ้น
      appBar: AppBar(
        title: Text('จอง ${widget.roomName}', 
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.orange,
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView( // ป้องกันหน้าจอทับซ้อนเวลาคีย์บอร์ดเด้ง
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // 1. เพิ่ม Icon ประจำหน้าจอ ให้ดูไม่เหงา
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.edit_calendar_rounded, size: 80, color: Colors.orange),
              ),
              const SizedBox(height: 30),
              
              Text(
                'กรอกรายละเอียดการจอง',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey.shade800),
              ),
              const SizedBox(height: 20),

              // 2. ปรับช่องกรอกให้ดูทันสมัย (Modern Input)
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'ชื่อผู้จอง / หัวข้อการจอง',
                  hintText: 'เช่น ประชุมทีมการตลาด',
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Colors.orange, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // 3. ปรับปุ่มให้ดูแพงและกว้างเต็มจอ
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                  ),
                  onPressed: _isLoading ? null : _submitBooking, // ถ้าโหลดอยู่กดไม่ได้
                  icon: _isLoading 
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Icon(Icons.check_circle_outline),
                  label: Text(_isLoading ? 'กำลังบันทึก...' : 'ยืนยันการจองตอนนี้', 
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('ยกเลิก', style: TextStyle(color: Colors.grey.shade600)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // แยกฟังก์ชันการบันทึกออกมาให้ดูสะอาด
  Future<void> _submitBooking() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ กรุณากรอกชื่อผู้จองก่อนครับ'), backgroundColor: Colors.redAccent),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await Supabase.instance.client.from('bookings').insert({
        'room_id': widget.roomId,
        'title': _titleController.text.trim(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ จองห้องสำเร็จเรียบร้อย!'), 
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ เกิดข้อผิดพลาด: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}