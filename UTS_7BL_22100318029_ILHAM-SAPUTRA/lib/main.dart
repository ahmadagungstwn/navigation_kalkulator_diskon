import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const BelanjaDiskonApp());
}

// ----------------------------------------------------
// 1. Setup Aplikasi (BelanjaDiskonApp)
// ----------------------------------------------------

class BelanjaDiskonApp extends StatelessWidget {
  const BelanjaDiskonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kalkulator Belanja & Diskon',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.light,
        ),
        fontFamily: 'SF Pro Display',
        // Mengatur tema input field agar konsisten
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(
            color: Colors.grey.shade400,
            fontWeight: FontWeight.w400,
          ),
          filled: true,
          fillColor: const Color(0xFFF9FAFB),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 16,
          ),
        ),

        // Mengatur tema ElevatedButton
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6366F1),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
      home: const BelanjaDiskonInputScreen(),
    );
  }
}

// Data Model untuk Hasil Perhitungan (dilewatkan antar halaman)
class CalculationResult {
  final double subtotal;
  final double diskonAmount;
  final double totalBayar;
  final String hargaInput;
  final String jumlahInput;
  final String diskonInput;

  CalculationResult({
    required this.subtotal,
    required this.diskonAmount,
    required this.totalBayar,
    required this.hargaInput,
    required this.jumlahInput,
    required this.diskonInput,
  });
}

// ----------------------------------------------------
// 2. Halaman Input (BelanjaDiskonInputScreen)
// ----------------------------------------------------

class BelanjaDiskonInputScreen extends StatefulWidget {
  const BelanjaDiskonInputScreen({super.key});

  @override
  State<BelanjaDiskonInputScreen> createState() =>
      _BelanjaDiskonInputScreenState();
}

class _BelanjaDiskonInputScreenState extends State<BelanjaDiskonInputScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _hargaController = TextEditingController();
  final TextEditingController _jumlahController = TextEditingController();
  final TextEditingController _diskonController = TextEditingController();

  String _formatRupiah(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  void _hitungDanNavigasi() {
    // Menghilangkan fokus keyboard
    FocusScope.of(context).unfocus();

    // Ambil nilai input asli (sebelum diubah menjadi double)
    final String hargaText = _hargaController.text;
    final String jumlahText = _jumlahController.text;
    final String diskonText = _diskonController.text;

    // Konversi nilai untuk perhitungan
    final double harga =
        double.tryParse(hargaText.replaceAll('.', '').replaceAll(',', '')) ??
        0.0;
    final int jumlah = int.tryParse(jumlahText) ?? 0;
    final double diskonPersen = double.tryParse(diskonText) ?? 0.0;

    if (harga > 0 && jumlah > 0) {
      final double subtotal = harga * jumlah;
      final double diskonAmount = (diskonPersen / 100) * subtotal;
      final double totalBayar = subtotal - diskonAmount;

      // Buat objek hasil perhitungan
      final result = CalculationResult(
        subtotal: subtotal,
        diskonAmount: diskonAmount,
        totalBayar: totalBayar,
        hargaInput: hargaText,
        jumlahInput: jumlahText,
        diskonInput: diskonText,
      );

      // NAVIGASI ke ResultScreen dan kirim data
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ResultScreen(result: result)),
      );
    } else {
      // Tampilkan SnackBar jika input tidak valid
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Masukkan harga dan jumlah yang valid'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.red.shade400,
        ),
      );
    }
  }

  void _resetForm() {
    setState(() {
      _hargaController.clear();
      _jumlahController.clear();
      _diskonController.clear();
    });
  }

  @override
  void dispose() {
    _hargaController.dispose();
    _jumlahController.dispose();
    _diskonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 20),

              // Header
              const Text(
                'Kalkulator',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w300,
                  color: Color(0xFF1F2937),
                  letterSpacing: -0.5,
                ),
              ),
              const Text(
                'Belanja & Diskon',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6366F1),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 40),

              // Card Input
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildModernInputField(
                      controller: _hargaController,
                      labelText: 'Harga Barang (Rp)',
                      hintText: '150000',
                      icon: Icons.shopping_cart_outlined,
                    ),
                    const SizedBox(height: 20),

                    _buildModernInputField(
                      controller: _jumlahController,
                      labelText: 'Jumlah',
                      hintText: '2',
                      icon: Icons.inventory_2_outlined,
                    ),
                    const SizedBox(height: 20),

                    _buildModernInputField(
                      controller: _diskonController,
                      labelText: 'Diskon (%)',
                      hintText: '10',
                      icon: Icons.local_offer_outlined,
                    ),
                    const SizedBox(height: 28),

                    // Tombol Aksi
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _resetForm,
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              side: const BorderSide(color: Color(0xFFE5E7EB)),
                            ),
                            child: const Text(
                              'Reset',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed:
                                _hitungDanNavigasi, // Pindah halaman saat ditekan
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.send, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'Proses & Lihat Hasil',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernInputField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF111827),
          ),
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(icon, color: const Color(0xFF6366F1), size: 22),
          ),
        ),
      ],
    );
  }
}

// ----------------------------------------------------
// 3. Halaman Hasil (ResultScreen)
// ----------------------------------------------------

class ResultScreen extends StatelessWidget {
  final CalculationResult result;

  const ResultScreen({super.key, required this.result});

  String _formatRupiah(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Detail Hasil Perhitungan'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF111827),
        elevation: 1,
        shadowColor: Colors.black12,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Bagian Input Yang Dibawa ---
            const Text(
              'Detail Input:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6366F1),
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailCard(
              children: [
                _buildInputRow(
                  'Harga Barang',
                  result.hargaInput,
                  Icons.attach_money,
                ),
                _buildInputRow('Jumlah', result.jumlahInput, Icons.inventory),
                _buildInputRow(
                  'Diskon',
                  '${result.diskonInput} %',
                  Icons.local_offer,
                ),
              ],
            ),

            const SizedBox(height: 40),

            // --- Bagian Hasil Perhitungan ---
            const Text(
              'Rincian Perhitungan:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 16),

            _buildResultCard(result: result, formatRupiah: _formatRupiah),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildInputRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF6366F1), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, color: Color(0xFF374151)),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard({
    required CalculationResult result,
    required String Function(double) formatRupiah,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildResultRow(
            'Subtotal Harga',
            result.subtotal,
            formatRupiah,
            false,
          ),
          _buildResultRow(
            'Potongan Diskon',
            result.diskonAmount,
            formatRupiah,
            true,
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Divider(color: Colors.white54, thickness: 1),
          ),

          const Text(
            'TOTAL YANG HARUS DIBAYAR',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            formatRupiah(result.totalBayar),
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: -1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultRow(
    String label,
    double amount,
    String Function(double) formatRupiah,
    bool isDiscount,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          '${isDiscount ? '- ' : ''}${formatRupiah(amount)}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDiscount ? Colors.yellow.shade300 : Colors.white,
          ),
        ),
      ],
    );
  }
}
