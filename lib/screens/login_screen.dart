import 'package:quirknthreads/repositories/auth_repository.dart';
import 'package:quirknthreads/state/cart/cart_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../main.dart';
import '../models/form_status.dart';
import '../state/login/login_cubit.dart';
import '../state/order/order_bloc.dart';

class LoginScreen extends StatelessWidget{
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          LoginCubit(
            authRepository: context.read<AuthRepository>(),
          ),
      child: const LoginView(),
    );
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
      body: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state.formStatus == FormStatus.submissionSuccess){
            print("login form successful");

            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Login Success'),
              ),
            );

            context.read<CartBloc>().add(
                LoadCartEvent(userId: context.read<AuthRepository>().currentUser?.uid)
            );

            context.go('/categories');
          }
          if (state.formStatus == FormStatus.submissionFailure) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Login Failure'),
              ),
            );
          }
          if (state.formStatus == FormStatus.emailVerificationPending) {

            context.read<CartBloc>().add(
                LoadCartEvent(userId: context.read<AuthRepository>().currentUser?.uid)
            );

            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Email Verification Pending'),
              ),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(label: Text('Email')),
                  onChanged: (value) {
                    // keep track of email (cubit)
                    context.read<LoginCubit>().emailChanged(value);
                  },
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(label: Text('Password')),
                  onChanged: (value) {
                    context.read<LoginCubit>().passwordChanged(value);
                  },
                ),
                const SizedBox(height: 8.0),
                FilledButton(onPressed: (state.formStatus == FormStatus.submissionInProgress)
                    ? null : () {
                  context.read<LoginCubit>().login();
                }, child: const Text('Login')),
                const SizedBox(height: 8.0),
                FilledButton(onPressed: (state.formStatus == FormStatus.submissionInProgress)
                    ? null : () {
                  //context.read<LoginCubit>().loginWithGoogle();
                  getSmsCodeFromUser(context);
                }, child: const Text('Sign in With Google')),
                const SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Don\'t have an account?'),
                    TextButton(onPressed: () {
                      context.pushNamed('register');
                    }, child: const Text('Register')),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Future<String?> getSmsCodeFromUser(BuildContext context) async {
    String? smsCode;

    // Update the UI - wait for the user to enter the SMS code
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('SMS code:'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Sign in'),
            ),
            OutlinedButton(
              onPressed: () {
                smsCode = null;
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
          content: Container(
            padding: const EdgeInsets.all(20),
            child: TextField(
              onChanged: (value) {
                smsCode = value;
              },
              textAlign: TextAlign.center,
              autofocus: true,
            ),
          ),
        );
      },
    );

    return smsCode;
  }



}

