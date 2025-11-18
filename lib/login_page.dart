import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final FirebaseAuth auth = FirebaseAuth.instance;

  bool loadingCircle = false;

  void login() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        loadingCircle = true;
      });

      try {
        await auth.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Login successful!')));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${e.toString()}')),
        );
      }

      setState(() {
        loadingCircle = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              SizedBox(height: 40),
              Icon(Icons.message, size: 100, color: Colors.blue),
              SizedBox(height: 20),
              Text(
                'Welcome to Message Board',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 40),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 25),
              loadingCircle
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: login,
                      child: Text('Login'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
