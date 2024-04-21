import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget{
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // initialize a bloc/cubit
    return const LoginView();
  }
}

class LoginView extends StatelessWidget{
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    // Implement UI and widgets
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(label: Text('Email')),
              onChanged: (value) {
                // keep track of email (cubit)

              },
            ),
            const SizedBox(height: 8.0),
            TextFormField(
              obscureText: true,
              decoration: InputDecoration(label: Text('Password')),
              onChanged: (value) {
                // keep track of email (cubit)
              },
            ),
            const SizedBox(height: 8.0),
            FilledButton(onPressed: (){}, child: const Text('Login')),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text ('Don\'t have an account?'),
                TextButton(onPressed: (){}, child: const Text('Register')),
              ],
            )
          ],
        ),
      )
      );
  }
}