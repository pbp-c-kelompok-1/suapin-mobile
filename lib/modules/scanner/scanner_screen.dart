import 'package:flutter/material.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  double _usedGrams = 580;
  final double _maxBudget = 2000;

  final List<Map<String, dynamic>> _logs = [
    {
      'title': 'Nasi Goreng Telur',
      'subtitle': 'Makan Siang • Hari ini, 12:30',
      'co2': 680,
      'analogy': '3.4 km motor',
      'icon': Icons.rice_bowl,
    },
    {
      'title': 'Gado-Gado Spesial',
      'subtitle': 'Makan Pagi • Hari ini, 08:15',
      'co2': 340,
      'analogy': '1.7 km motor',
      'icon': Icons.eco,
    },
    {
      'title': 'Sate Ayam (5 tusuk)',
      'subtitle': 'Makan Malam • Kemarin',
      'co2': 720,
      'analogy': '3.6 km motor',
      'icon': Icons.kebab_dining,
    },
  ];

  void _showScanModal(BuildContext context, String sourceTitle) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return _ScanSimulationSheet(
          sourceTitle: sourceTitle,
          onFoodLogged: (name, co2, analogy, icon) {
            setState(() {
              _usedGrams += co2;
              _logs.insert(0, {
                'title': name,
                'subtitle': 'Baru saja',
                'co2': co2,
                'analogy': analogy,
                'icon': icon,
              });
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$name berhasil dicatat! (+${co2.toInt()}g CO₂)'),
                backgroundColor: const Color(0xFF16A34A),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        );
      },
    );
  }

  void _deleteLog(int index) {
    final removed = _logs[index];
    setState(() {
      _usedGrams = (_usedGrams - removed['co2']).clamp(0, _maxBudget * 2);
      _logs.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Log ${removed['title']} dihapus'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_usedGrams / _maxBudget).clamp(0.0, 1.0);
    final remaining = (_maxBudget - _usedGrams).clamp(0.0, _maxBudget);

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
                        onPressed: () => _showScanModal(context, 'Kamera'),
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
                        onPressed: () => _showScanModal(context, 'Galeri'),
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
                      Text(
                        '${_usedGrams.toInt()} / ${_maxBudget.toInt()} g CO₂',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      progress > 0.85 ? Colors.red : const Color(0xFF16A34A),
                    ),
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    remaining > 0
                        ? 'Sisa kuota: ${remaining.toInt()} g CO₂ (Sangat baik untuk bumi!)'
                        : 'Peringatan: Kamu telah melebihi batas anggaran karbon harian!',
                    style: TextStyle(
                      color: remaining > 0 ? Colors.green.shade800 : Colors.red.shade800,
                      fontSize: 12,
                      fontWeight: remaining > 0 ? FontWeight.normal : FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Riwayat Scan Makanan',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${_logs.length} catatan',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_logs.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'Belum ada riwayat scan makanan hari ini.',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _logs.length,
                itemBuilder: (context, index) {
                  final log = _logs[index];
                  final int co2 = log['co2'];
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
                        child: Icon(log['icon'] as IconData, color: const Color(0xFF16A34A)),
                      ),
                      title: Text(log['title'], style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text(
                        '${log['subtitle']} • ≈ ${log['analogy']}',
                        style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: co2 < 500 ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '$co2 g CO₂',
                              style: TextStyle(
                                color: co2 < 500 ? const Color(0xFF166534) : const Color(0xFF92400E),
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete_outline, size: 18, color: Colors.grey.shade400),
                            onPressed: () => _deleteLog(index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _ScanSimulationSheet extends StatefulWidget {
  final String sourceTitle;
  final Function(String name, double co2, String analogy, IconData icon) onFoodLogged;

  const _ScanSimulationSheet({
    required this.sourceTitle,
    required this.onFoodLogged,
  });

  @override
  State<_ScanSimulationSheet> createState() => _ScanSimulationSheetState();
}

class _ScanSimulationSheetState extends State<_ScanSimulationSheet> {
  bool _isAnalyzing = false;
  Map<String, dynamic>? _detectedFood;

  final List<Map<String, dynamic>> _samples = [
    {
      'name': 'Nasi Padang Rendang',
      'co2': 850.0,
      'analogy': '4.2 km motor',
      'icon': Icons.lunch_dining,
      'desc': 'Tinggi emisi karena olahan daging sapi.',
    },
    {
      'name': 'Soto Ayam Lamongan',
      'co2': 420.0,
      'analogy': '2.1 km motor',
      'icon': Icons.soup_kitchen,
      'desc': 'Emisi sedang berbasis daging unggas.',
    },
    {
      'name': 'Karedok Sayur Segar',
      'co2': 210.0,
      'analogy': '1.0 km motor',
      'icon': Icons.eco,
      'desc': 'Pilihan ramah lingkungan tinggi serat.',
    },
    {
      'name': 'Mie Goreng Spesial',
      'co2': 510.0,
      'analogy': '2.5 km motor',
      'icon': Icons.ramen_dining,
      'desc': 'Karbohidrat olahan dengan telur dan sayur.',
    },
  ];

  void _startAnalysis(Map<String, dynamic> sample) {
    setState(() {
      _isAnalyzing = true;
    });

    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
          _detectedFood = sample;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Simulasi FoodScan AI (${widget.sourceTitle})',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (_isAnalyzing) ...[
            const SizedBox(height: 30),
            const Center(
              child: Column(
                children: [
                  CircularProgressIndicator(color: Color(0xFF16A34A)),
                  SizedBox(height: 16),
                  Text('Model AI sedang memindai objek makanan...', style: TextStyle(fontWeight: FontWeight.w600)),
                  SizedBox(height: 4),
                  Text('Menghitung estimasi gram CO₂ per porsi', style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ] else if (_detectedFood != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFDCFCE7),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF86EFAC)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(_detectedFood!['icon'] as IconData, color: const Color(0xFF166534), size: 28),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _detectedFood!['name'],
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF166534)),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF166534),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${_detectedFood!['co2'].toInt()} g CO₂',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _detectedFood!['desc'],
                    style: const TextStyle(fontSize: 12, color: Color(0xFF14532D)),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.two_wheeler, size: 16, color: Color(0xFF166534)),
                      const SizedBox(width: 6),
                      Text(
                        'Setara emisi motor: ${_detectedFood!['analogy']}',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF166534)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF16A34A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () {
                  widget.onFoodLogged(
                    _detectedFood!['name'],
                    _detectedFood!['co2'],
                    _detectedFood!['analogy'],
                    _detectedFood!['icon'] as IconData,
                  );
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.check),
                label: const Text('Simpan ke Log Harian'),
              ),
            ),
          ] else ...[
            Text(
              'Pilih salah satu menu di bawah ini untuk menguji deteksi AI:',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
            const SizedBox(height: 12),
            ..._samples.map((sample) {
              return Card(
                elevation: 0,
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green.shade50,
                    child: Icon(sample['icon'] as IconData, color: const Color(0xFF16A34A)),
                  ),
                  title: Text(sample['name'], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  subtitle: Text('Estimasi: ${sample['co2'].toInt()}g CO₂', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                  onTap: () => _startAnalysis(sample),
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}
