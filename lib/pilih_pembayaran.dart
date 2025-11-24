import 'package:flutter/material.dart';
import 'qris_payment_screen.dart';

class PaymentSelectionScreen extends StatefulWidget {
  const PaymentSelectionScreen({super.key});

  @override
  State<PaymentSelectionScreen> createState() => _PaymentSelectionScreenState();
}

class _PaymentSelectionScreenState extends State<PaymentSelectionScreen> {
  // Variable untuk menyimpan index metode pembayaran yang dipilih
  // -1 artinya belum ada yang dipilih
  int _selectedIndex = -1;

  // Data Dummy Metode Pembayaran
  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'id': 0,
      'title': 'QRIS',
      'icon': Icons.qr_code_scanner,
      'balance': null,
      'type': 'Scan'
    },
    {
      'id': 1,
      'title': 'Gopay',
      'icon': Icons.account_balance_wallet,
      'type': 'E-Wallet'
    },
    {
      'id': 2,
      'title': 'OVO',
      'icon': Icons.monetization_on_outlined,
      'balance': null,
      'type': 'E-Wallet'
    },
    {
      'id': 3,
      'title': 'Kartu Kredit / Debit',
      'icon': Icons.credit_card,
      'balance': null,
      'type': 'Kartu'
    },
    {
      'id': 4,
      'title': 'Bank BCA (Virtual Account)',
      'icon': Icons.account_balance,
      'balance': null,
      'type': 'Transfer'
    },
    {
      'id': 5,
      'title': 'Bank Mandiri',
      'icon': Icons.account_balance,
      'balance': null,
      'type': 'Transfer'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121820),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Metode Pembayaran",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Section Total Tagihan
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Total Pembayaran",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                SizedBox(height: 8),
                Text(
                  "Rp 5.115.000",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Section Judul List
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Pilih Metode",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // List Metode Pembayaran
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _paymentMethods.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final method = _paymentMethods[index];
                final isSelected = _selectedIndex == index;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A222D),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? const Color(0xFF2196F3) : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        // Icon Metode
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF233040),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            method['icon'],
                            color: isSelected ? const Color(0xFF2196F3) : Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 16),
                        
                        // Nama & Balance
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                method['title'],
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.grey[300],
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              if (method['balance'] != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    "Saldo: ${method['balance']}",
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),

                        // Radio Indicator
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? const Color(0xFF2196F3) : Colors.grey,
                              width: 2,
                            ),
                          ),
                          child: isSelected
                              ? Center(
                                  child: Container(
                                    width: 12,
                                    height: 12,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF2196F3),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                )
                              : null,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      
      // Tombol Bayar di Bawah
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Color(0xFF1A222D),
          border: Border(top: BorderSide(color: Colors.black12)),
        ),
        child: SizedBox(
          height: 55,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _selectedIndex != -1 ? const Color(0xFF2196F3) : Colors.grey[700],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: _selectedIndex != -1 
             ? () {
                  // Cek apakah user memilih QRIS (Tadi kita kasih ID = 6 atau 0 tergantung kamu)
                  // Asumsi ID QRIS adalah 6 sesuai kode sebelumnya
                  if (_paymentMethods[_selectedIndex]['title'] == 'QRIS') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const QrisPaymentScreen()),
                    );
                  } else {
                    // Logika pembayaran lainnya
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Memproses pembayaran via ${_paymentMethods[_selectedIndex]['title']}"))
                    );
                  }
                } 
              : null, // Tombol disable jika belum pilih
            child: const Text(
              "Bayar Sekarang",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}