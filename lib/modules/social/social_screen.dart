import 'package:flutter/material.dart';

import 'screens/campus_war_tab.dart';
import 'screens/friends_tab.dart';
import 'screens/leaderboard_tab.dart';

/// Halaman utama modul Social (menu "Peringkat" di bottom navigation).
///
/// Berisi 3 tab yang masing-masing mengambil data dari API Django REST Framework:
///   Peringkat  -> GET  /social/api/leaderboard/
///   Campus War -> GET  /social/api/campus-war/   (+ POST /social/api/campus/)
///   Teman      -> GET  /social/api/friends/      (+ POST kirim/terima/tolak/hapus)
class SocialScreen extends StatelessWidget {
  const SocialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // DefaultTabController menghubungkan TabBar (judul tab) dengan TabBarView (isi tab).
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Peringkat & Teman', style: TextStyle(fontWeight: FontWeight.bold)),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.leaderboard_outlined), text: 'Peringkat'),
              Tab(icon: Icon(Icons.school_outlined), text: 'Campus War'),
              Tab(icon: Icon(Icons.group_outlined), text: 'Teman'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            LeaderboardTab(),
            CampusWarTab(),
            FriendsTab(),
          ],
        ),
      ),
    );
  }
}
