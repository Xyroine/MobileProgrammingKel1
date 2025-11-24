import 'dart:async';
import 'package:flutter/material.dart';
import 'payment_success_screen.dart';

class QrisPaymentScreen extends StatefulWidget {
  const QrisPaymentScreen({super.key});

  @override
  State<QrisPaymentScreen> createState() => _QrisPaymentScreenState();
}

class _QrisPaymentScreenState extends State<QrisPaymentScreen> {
  Timer? _timer;
  int _start = 300; // 5 Menit

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get timerText {
    int minutes = _start ~/ 60;
    int seconds = _start % 60;
    return '${minutes.toString().padLeft(2, '0')} : ${seconds.toString().padLeft(2, '0')}';
  }
void _simulateCheckStatus() {
  // 1. Tampilkan Loading Dialog
  showDialog(
    context: context,
    barrierDismissible: false, // User gabisa tutup loading
    builder: (context) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF2196F3),
        ),
      );
    },
  );

  // 2. Simulasi delay 2 detik (pura-pura ngecek server)
  Future.delayed(const Duration(seconds: 2), () {
    // Tutup Loading
    Navigator.of(context).pop(); 

    // 3. Pindah ke Halaman Sukses
    // Gunakan pushReplacement agar user tidak bisa back ke halaman QR lagi
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const PaymentSuccessScreen()),
    );
  });
}
 // --- Pop Up Dialog Batalkan Pembayaran ---
  Future<void> _showCancelDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: const Color(0xFF1A222D), // Background Gelap
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 1. Icon Ilustrasi
                SizedBox(
                  height: 80,
                  width: 80,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A1C1C), // Merah gelap transparan
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.redAccent.withOpacity(0.2)),
                        ),
                        width: 80,
                        height: 80,
                      ),
                      const Icon(Icons.payment_outlined, color: Colors.redAccent, size: 40),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Color(0xFF1A222D), // Border luar ikon kecil
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.warning_rounded, color: Colors.amber, size: 24),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // 2. Judul (Warna Putih)
                const Text(
                  "Batalkan Pembayaran?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white, 
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                // 3. Deskripsi (Warna Abu-abu terang)
                const Text(
                  "Waktu pembayaranmu masih tersisa. Jika dibatalkan, kamu harus mengulang pesanan dari awal.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey, // Text grey agar enak dibaca di dark mode
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 25),

                // 4. Tombol Batalkan (Tetap Kuning agar mencolok sebagai Peringatan)
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4E157), // Kuning Lime
                      foregroundColor: Colors.black87, // Text tombol hitam
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // Tutup Dialog
                      Navigator.of(context).pop(); // Keluar Halaman
                    },
                    child: const Text(
                      "YA, BATALKAN",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                
                const SizedBox(height: 12),

                // 5. Tombol Kembali (Warna Biru Tema atau Putih)
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); 
                  },
                  child: const Text(
                    "LANJUTKAN BAYAR",
                    style: TextStyle(
                      color: Color(0xFF2196F3), // Biru sesuai tema App
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // PopScope digunakan untuk menangkap tombol Back hardware/gesture
    return PopScope(
      canPop: false, // Mencegah langsung keluar
      onPopInvoked: (didPop) {
        if (didPop) return;
        _showCancelDialog(); // Panggil dialog kita saat back ditekan
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF121820),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () {
              // Panggil dialog saat tombol X di AppBar ditekan
              _showCancelDialog();
            },
          ),
          title: const Text(
            "Pembayaran QRIS",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 10),
              
              // QR Container
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white, 
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Image.network(
                      'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d0/QR_code_for_mobile_English_Wikipedia.svg/1200px-QR_code_for_mobile_English_Wikipedia.svg.png',
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "NMID: ID102003004005",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                "Selesaikan Pembayaran",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Scan QRIS di atas untuk menyelesaikan pembayaran dalam waktu",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              
              const SizedBox(height: 15),

              // Timer
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A1C1C),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.redAccent.withOpacity(0.5)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.timer_outlined, color: Colors.redAccent, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      timerText,
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Detail Pembayaran Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A222D),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "DETAIL PEMBAYARAN",
                      style: TextStyle(color: Colors.grey, fontSize: 12, letterSpacing: 1.0),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.qr_code_scanner, color: Colors.white, size: 20),
                        const SizedBox(width: 8),
                        const Text(
                          "QRIS",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(color: Colors.white10),
                    ),
                    const Text(
                      "TOTAL TRANSAKSI",
                      style: TextStyle(color: Colors.grey, fontSize: 12, letterSpacing: 1.0),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "Rp 5.115.000",
                      style: TextStyle(
                        color: Color(0xFF2196F3),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 25),

              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Cara Pembayaran:",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "1. Buka aplikasi e-wallet atau m-banking kamu.\n2. Scan kode QR di atas.\n3. Periksa detail nama merchant dan nominal.\n4. Masukkan PIN dan selesaikan transaksi.",
                      style: TextStyle(color: Colors.grey, height: 1.5, fontSize: 13),
                    ),
                  ],
                ),
              ),
               const SizedBox(height: 80),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Color(0xFF1A222D),
            border: Border(top: BorderSide(color: Colors.black12)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF2196F3)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: () {},
                  icon: const Icon(Icons.download, color: Color(0xFF2196F3)),
                  label: const Text("UNDUH QRIS", style: TextStyle(color: Color(0xFF2196F3), fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2196F3),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: () {
                    _simulateCheckStatus();},
                  child: const Text("CEK STATUS PEMBAYARAN", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}