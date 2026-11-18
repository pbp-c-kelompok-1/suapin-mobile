import 'package:flutter/material.dart';

class ScannerScreen extends StatelessWidget {
  const ScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FoodScan AI', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                children: [
                  const Icon(Icons.photo_camera_outlined, size: 54, color: Color(0xFF16A34A)),
                  const SizedBox(height: 12),
                  const Text(
                    'Pindai Makanan Anda',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Ambil foto atau pilih dari galeri untuk mendeteksi makanan dan hitung jejak karbonnya secara otomatis.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF16A34A),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                        ),
                        onPressed: () {},
                        icon: const Icon(Icons.camera_alt, size: 18),
                        label: const Text('Buka Kamera'),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF16A34A),
                          side: const BorderSide(color: Color(0xFF16A34A)),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        ),
                        onPressed: () {},
                        icon: const Icon(Icons.photo_library_outlined, size: 18),
                        label: const Text('Galeri'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Anggaran Karbon Hari Ini', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('580 / 2.000 g CO₂', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: 0.29,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF16A34A)),
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sisa kuota: 1.420 g CO₂ (Sangat baik untuk bumi!)',
                    style: TextStyle(color: Colors.green.shade800, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Riwayat Scan Makanan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildLogItem('Nasi Goreng Telur', 'Makan Siang • Hari ini, 12:30', 680, Icons.rice_bowl),
            _buildLogItem('Gado-Gado Spesial', 'Makan Pagi • Hari ini, 08:15', 340, Icons.eco),
            _buildLogItem('Sate Ayam (5 tusuk)', 'Makan Malam • Kemarin', 720, Icons.kebab_dining),
          ],
        ),
      ),
    );
  }

  Widget _buildLogItem(String title, String subtitle, int co2Grams, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green.shade50,
          child: Icon(icon, color: const Color(0xFF16A34A)),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: co2Grams < 500 ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '$co2Grams g CO₂',
            style: TextStyle(
              color: co2Grams < 500 ? const Color(0xFF166534) : const Color(0xFF92400E),
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
