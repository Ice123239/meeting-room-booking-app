import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'add_booking_ui.dart';
import 'booking_history_ui.dart';

class RoomListUI extends StatelessWidget {
  const RoomListUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50, // พื้นหลังเทาอ่อนๆ ให้ Card ดูเด่น
      body: CustomScrollView(
        slivers: [
          // 1. ส่วนหัวแอป (SliverAppBar) - เลื่อนแล้วยุบได้ สวยมาก!
          SliverAppBar(
            expandedHeight: 150.0,
            floating: false,
            pinned: true,
            backgroundColor: Colors.orange,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: const Text('จองห้องประชุม',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  )),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orange, Colors.deepOrange],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.history, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BookingHistoryUI()));
                },
              ),
            ],
          ),

          // 2. ส่วนรายการห้องประชุม
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("รายการห้องประชุมทั้งหมด",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text("กรุณาเลือกห้องที่คุณต้องการใช้งาน",
                      style: TextStyle(color: Colors.grey.shade600)),
                ],
              ),
            ),
          ),

          StreamBuilder<List<Map<String, dynamic>>>(
            stream: Supabase.instance.client
                .from('rooms')
                .stream(primaryKey: ['id']),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator(color: Colors.orange)));
              }
              
              final rooms = snapshot.data ?? [];
              
              if (rooms.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(child: Text("❌ ยังไม่มีข้อมูลห้องประชุมในระบบ")),
                );
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final room = rooms[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(15),
                            leading: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade50,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.meeting_room_rounded, color: Colors.orange, size: 30),
                            ),
                            title: Text(
                              room['room_name'] ?? 'ห้องประชุมทั่วไป', // ✅ ชื่อห้อง
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.people_outline, size: 16, color: Colors.grey),
                                  const SizedBox(width: 5),
                                  Text('รองรับ: ${room['capacity'] ?? 10} ท่าน', 
                                    style: const TextStyle(color: Colors.grey)),
                                ],
                              ),
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.orange, size: 20),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddBookingUI(
                                    roomId: room['id'],
                                    roomName: room['room_name'] ?? 'ห้องประชุม',
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: rooms.length,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}