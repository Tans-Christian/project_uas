import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'reset_password_page.dart';
import 'home_page.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLogin = true;
  bool isLoading = false;

  Future<void> authenticate() async {
    setState(() => isLoading = true);

    try {
      if (isLogin) {
        await supabase.auth.signInWithPassword(
          email: emailController.text,
          password: passwordController.text,
        );
      } else {
        await supabase.auth.signUp(
          email: emailController.text,
          password: passwordController.text,
        );
      }
      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
      }
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isLogin ? "Login" : "Register")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : authenticate,
              child: isLoading ? CircularProgressIndicator() : Text(isLogin ? "Login" : "Register"),
            ),
            TextButton(
              onPressed: () => setState(() => isLogin = !isLogin),
              child: Text(isLogin ? "Belum punya akun? Register" : "Sudah punya akun? Login"),
            ),
            if (isLogin)
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => ResetPasswordPage()));
                },
                child: Text("Lupa Password?"),
              ),
          ],
        ),
      ),
    );
  }
}