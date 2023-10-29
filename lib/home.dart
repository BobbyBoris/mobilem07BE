import 'package:flutter/material.dart';
import 'loginScreen.dart';

class MyHome extends StatelessWidget {
  final String email;
  final String wid;

  MyHome({required this.email, required this.wid});

  void _handleLogout(BuildContext context) {
    // Tambahkan logika untuk logout di sini, misalnya melakukan sign out dari Firebase
    // Setelah logout, navigasikan pengguna kembali ke halaman login
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_sharp),
            tooltip: 'Logout',
            onPressed: () {
              _handleLogout(
                  context); // Panggil fungsi logout saat tombol logout ditekan
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Welcome $email"),
            Text("ID $wid"),
          ],
        ),
      ),
    );
  }
}
