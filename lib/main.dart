import 'package:flutter/material.dart';

void main() {
  runApp(const SuapinApp());
}

class SuapinApp extends StatelessWidget {
  const SuapinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Suap.in',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF16A34A),
          brightness: Brightness.light,
        ),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = [
    DashboardView(),
    ScannerPlaceholderView(),
    LeaderboardPlaceholderView(),
    ChallengePlaceholderView(),
    ProfilePlaceholderView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.qr_code_scanner),
            selectedIcon: Icon(Icons.qr_code_scanner),
            label: 'Scan',
          ),
          NavigationDestination(
            icon: Icon(Icons.leaderboard_outlined),
            selectedIcon: Icon(Icons.leaderboard),
            label: 'Peringkat',
          ),
          NavigationDestination(
            icon: Icon(Icons.emoji_events_outlined),
            selectedIcon: Icon(Icons.emoji_events),
            label: 'Tantangan',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Suap.in',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF16A34A), Color(0xFF15803D)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Halo, Pejuang Hijau! 👋',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Foto makananmu hari ini dan lacak emisi karbon porsi harianmu.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.local_fire_department, color: Colors.orangeAccent, size: 18),
                            SizedBox(width: 4),
                            Text('Streak: 3 Hari', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.eco, color: Colors.lightGreenAccent, size: 18),
                            SizedBox(width: 4),
                            Text('Tunas', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Modul Suap.in Mobile',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildModuleCard(
              context,
              icon: Icons.camera_alt_outlined,
              title: 'FoodScan AI & Karbon',
              subtitle: 'Lacak jejak karbon dari makanan Indonesia',
              color: const Color(0xFF16A34A),
            ),
            _buildModuleCard(
              context,
              icon: Icons.military_tech_outlined,
              title: 'Gamifikasi & Level',
              subtitle: 'Kumpulkan XP, naikkan level, dan raih lencana',
              color: Colors.amber.shade800,
            ),
            _buildModuleCard(
              context,
              icon: Icons.leaderboard_outlined,
              title: 'Leaderboard & Campus War',
              subtitle: 'Peringkat teman dan kompetisi kampus',
              color: Colors.blue.shade700,
            ),
            _buildModuleCard(
              context,
              icon: Icons.track_changes_outlined,
              title: 'Tantangan Harian & Laporan',
              subtitle: 'Selesaikan misi ramah lingkungan tiap hari',
              color: Colors.purple.shade700,
            ),
            _buildModuleCard(
              context,
              icon: Icons.auto_stories_outlined,
              title: 'Story Progression & Duel 1v1',
              subtitle: 'Buka bab komik digital dan tantang teman',
              color: Colors.teal.shade700,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModuleCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.12),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
        onTap: () {},
      ),
    );
  }
}

class ScannerPlaceholderView extends StatelessWidget {
  const ScannerPlaceholderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FoodScan AI')),
      body: const Center(
        child: Text('Modul FoodScan AI (Scanner)'),
      ),
    );
  }
}

class LeaderboardPlaceholderView extends StatelessWidget {
  const LeaderboardPlaceholderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Leaderboard')),
      body: const Center(
        child: Text('Modul Leaderboard & Campus War'),
      ),
    );
  }
}

class ChallengePlaceholderView extends StatelessWidget {
  const ChallengePlaceholderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tantangan')),
      body: const Center(
        child: Text('Modul Tantangan & Laporan Mingguan'),
      ),
    );
  }
}

class ProfilePlaceholderView extends StatelessWidget {
  const ProfilePlaceholderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: const Center(
        child: Text('Modul Autentikasi & Profil Pengguna'),
      ),
    );
  }
}
