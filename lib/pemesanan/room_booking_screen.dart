import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RoomBookingScreen extends StatefulWidget {
  const RoomBookingScreen({super.key});

  @override
  State<RoomBookingScreen> createState() => _RoomBookingScreenState();
}

class _RoomBookingScreenState extends State<RoomBookingScreen> {
  DateTime _selectedStartDate = DateTime.now();
  DateTime _selectedEndDate = DateTime.now().add(const Duration(days: 4)); // Contoh 4 hari setelahnya
  int _guestCount = 2;
  int _childrenCount = 0;
  DateTime _currentMonth = DateTime.now();

  @override
  void initState() {
    super.initState();
    _selectedStartDate = DateTime(2024, 10, 5); // Mengatur tanggal awal sesuai gambar
    _selectedEndDate = DateTime(2024, 10, 9);   // Mengatur tanggal akhir sesuai gambar
    _currentMonth = DateTime(2024, 10);        // Mengatur bulan ke Oktober 2024
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
    });
  }

  void _selectDate(DateTime date) {
    setState(() {
      if (_selectedStartDate.isAtSameMomentAs(_selectedEndDate) || date.isBefore(_selectedStartDate)) {
        _selectedStartDate = date;
        _selectedEndDate = date;
      } else if (date.isAfter(_selectedStartDate)) {
        _selectedEndDate = date;
      }
    });
  }

  bool _isDateSelected(DateTime date) {
    return (date.isAfter(_selectedStartDate.subtract(const Duration(days: 1))) &&
            date.isBefore(_selectedEndDate.add(const Duration(days: 1)))) ||
        date.isAtSameMomentAs(_selectedStartDate) ||
        date.isAtSameMomentAs(_selectedEndDate);
  }

  bool _isStartDate(DateTime date) {
    return date.isAtSameMomentAs(_selectedStartDate);
  }

  bool _isEndDate(DateTime date) {
    return date.isAtSameMomentAs(_selectedEndDate);
  }

  Widget _buildDayCell(DateTime date) {
    bool isSelected = _isDateSelected(date);
    bool isStartDate = _isStartDate(date);
    bool isEndDate = _isEndDate(date);
    bool isToday = date.day == DateTime.now().day && date.month == DateTime.now().month && date.year == DateTime.now().year;

    Color textColor = Colors.white;
    BoxDecoration? decoration;

    if (isSelected) {
      if (isStartDate && isEndDate) {
        decoration = BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(8),
        );
      } else if (isStartDate) {
        decoration = BoxDecoration(
          color: Colors.blue,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            bottomLeft: Radius.circular(8),
          ),
        );
      } else if (isEndDate) {
        decoration = BoxDecoration(
          color: Colors.blue,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
        );
      } else {
        decoration = BoxDecoration(
          color: Colors.blue.withOpacity(0.5), // Warna untuk tanggal di antara start dan end
        );
      }
    } else if (date.month != _currentMonth.month) {
      textColor = Colors.grey.shade700; // Tanggal bulan lain lebih redup
    } else if (isToday) {
      textColor = Colors.blueAccent; // Contoh untuk tanggal hari ini
    }

    return GestureDetector(
      onTap: date.month == _currentMonth.month ? () => _selectDate(date) : null,
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: decoration,
        child: Center(
          child: Text(
            '${date.day}',
            style: TextStyle(
              color: textColor,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Aksi saat tombol kembali ditekan
          },
        ),
        title: const Text('Pesan Kamar'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pilih Tanggal Menginap',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            _buildCalendarHeader(),
            _buildCalendarGrid(),
            const SizedBox(height: 30),
            _buildGuestSelector(),
            const SizedBox(height: 15),
            _buildChildrenSelector(),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Aksi saat tombol Cari Kamar ditekan
                  print('Mencari kamar dengan:');
                  print('Start Date: $_selectedStartDate');
                  print('End Date: $_selectedEndDate');
                  print('Jumlah Tamu: $_guestCount');
                  print('Jumlah Anak-anak: $_childrenCount');
                },
                child: const Text('Cari Kamar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18),
          onPressed: _previousMonth,
        ),
        Text(
          DateFormat.yMMMM('id_ID').format(_currentMonth), // Menampilkan bulan dan tahun
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios, size: 18),
          onPressed: _nextMonth,
        ),
      ],
    );
  }

  Widget _buildCalendarGrid() {
    final DateTime firstDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final int daysInMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
    final int firstWeekday = firstDayOfMonth.weekday; // 1 = Senin, 7 = Minggu

    List<String> weekdays = ['S', 'M', 'T', 'W', 'T', 'F', 'S']; // Minggu dimulai dari hari Senin

    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1.0,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
          ),
          itemCount: 7,
          itemBuilder: (context, index) {
            return Center(
              child: Text(
                weekdays[index],
                style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              ),
            );
          },
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1.0,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
          ),
          itemCount: 42, // Cukup untuk 6 baris x 7 hari
          itemBuilder: (context, index) {
            final int day = index - firstWeekday + 1; // Menyesuaikan dengan hari pertama di bulan
            final DateTime date = DateTime(_currentMonth.year, _currentMonth.month, day);

            // Jika tanggal di luar bulan ini, tampilkan tanggal bulan sebelumnya/berikutnya
            if (day < 1 || day > daysInMonth) {
              final DateTime displayDate;
              if (day < 1) {
                // Tanggal bulan sebelumnya
                displayDate = DateTime(_currentMonth.year, _currentMonth.month, 0).subtract(Duration(days: -day));
              } else {
                // Tanggal bulan berikutnya
                displayDate = DateTime(_currentMonth.year, _currentMonth.month + 1, day - daysInMonth);
              }
              return _buildDayCell(displayDate);
            }
            return _buildDayCell(date);
          },
        ),
      ],
    );
  }

  Widget _buildGuestSelector() {
    return _buildCounterRow(
      icon: Icons.group,
      label: 'Jumlah Tamu',
      count: _guestCount,
      onDecrement: () {
        setState(() {
          if (_guestCount > 1) _guestCount--;
        });
      },
      onIncrement: () {
        setState(() {
          _guestCount++;
        });
      },
    );
  }

  Widget _buildChildrenSelector() {
    return _buildCounterRow(
      icon: Icons.face,
      label: 'Anak-anak',
      count: _childrenCount,
      onDecrement: () {
        setState(() {
          if (_childrenCount > 0) _childrenCount--;
        });
      },
      onIncrement: () {
        setState(() {
          _childrenCount++;
        });
      },
    );
  }

  Widget _buildCounterRow({
    required IconData icon,
    required String label,
    required int count,
    required VoidCallback onDecrement,
    required VoidCallback onIncrement,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(width: 15),
        Text(
          label,
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF2C2C2C), // Warna latar belakang untuk counter
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              _buildIconButton(Icons.remove, onDecrement),
              const SizedBox(width: 10),
              Text(
                '$count',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(width: 10),
              _buildIconButton(Icons.add, onIncrement),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(5),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Icon(icon, color: Colors.blue, size: 24),
      ),
    );
  }
}