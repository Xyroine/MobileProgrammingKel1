import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Kita ganti 'home' dari MyHomePage ke LoginPage
      home: const LoginPage(title: 'Halaman Login'),
    );
  }
}

// Ini adalah widget halaman login yang baru
class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controller untuk mengambil teks dari input fields
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Fungsi yang dipanggil saat tombol login ditekan
  void _login() {
    String username = _usernameController.text;
    String password = _passwordController.text;

    // Di sini Anda bisa menambahkan logika validasi
    // Untuk saat ini, kita hanya cetak ke konsol dan tampilkan Snackbar
    print('Username: $username');
    print('Password: $password');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Mencoba login dengan $username...')),
    );
  }

  @override
  void dispose() {
    // Selalu bersihkan controller saat widget di-dispose
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        // Memberi padding di sekeliling form
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // Menengahkan konten secara vertikal
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Silakan Login',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24), // Memberi jarak
            // Input field untuk Username
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Username',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16), // Memberi jarak
            // Input field untuk Password
            TextField(
              controller: _passwordController,
              obscureText: true, // Menyembunyikan teks password
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 24), // Memberi jarak
            // Tombol Login
            ElevatedButton(
              // Membuat tombol selebar mungkin
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50), 
              ),
              onPressed: _login, // Memanggil fungsi _login saat ditekan
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}