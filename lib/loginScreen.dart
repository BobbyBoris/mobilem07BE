import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:minggu7/auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late AuthFirebase auth;

  @override
  void initState() {
    super.initState();
    auth = AuthFirebase();
    auth.getUser().then((value) {
      if (value != null) {
        navigateToHome(value.uid);
      }
    }).catchError((err) => print(err));
  }

  void navigateToHome(String uid) {
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => MyHome(email: "example@example.com", wid: uid),
    );
    Navigator.pushReplacement(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      onLogin: _loginUser,
      onRecoverPassword: _recoverPassword,
      onSignup: _onSignup,
      passwordValidator: (value) {
        if (value != null) {
          if (value.length < 6) {
            return "Password Must be 6 Characters";
          }
        }
      },
      loginProviders: <LoginProvider>[
        LoginProvider(
            icon: FontAwesomeIcons.google,
            label: 'Google',
            callback: _onLoginGoogle),
      ],
      onSubmitAnimationCompleted: () {
        auth.getUser().then((value) {
          if (value != null) {
            navigateToHome(value.uid);
          } else {
            MaterialPageRoute route =
                MaterialPageRoute(builder: (context) => LoginScreen());
            Navigator.pushReplacement(context, route);
          }
        }).catchError((err) => print(err));
      },
    );
  }

  Future<String?> _loginUser(LoginData data) {
    return auth.login(data.name, data.password).then((value) {
      if (value != null) {
        MyHome myHome = MyHome(wid: value, email: data.name);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => myHome));
      } else {
        final snackbar = SnackBar(
          content: const Text('Login Failed, user not found'),
          action: SnackBarAction(
            label: 'OK',
            onPressed: () {
              // Tindakan jika login gagal
            },
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      }
    });
  }

  Future<String>? _recoverPassword(String name) {
    // Tambahkan logika pemulihan kata sandi di sini jika diperlukan
    return null;
  }

  Future<String?> _onSignup(SignupData data) {
    return auth.signUp(data.name!, data.password!).then((value) {
      if (value != null) {
        final snackbar = SnackBar(
          content: const Text('Sign up Successfull'),
          action: SnackBarAction(
            label: 'OK',
            onPressed: () {},
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      }
    });
  }

  Future<String?> _onLoginGoogle() async {
    // Tambahkan logika login menggunakan Google di sini jika diperlukan
    return null;
  }
}

class MyHome extends StatelessWidget {
  final String email;
  final String wid;

  MyHome({required this.email, required this.wid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_sharp),
            tooltip: 'Logout',
            onPressed: () {
              // Tambahkan kode untuk logout di sini
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
