import 'package:quirknthreads/main.dart';
import 'package:quirknthreads/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../models/form_status.dart';
import '../state/cart/cart_bloc.dart';
import '../state/register/register_cubit.dart';
import '../main.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          RegisterCubit(
            // authRepository: authRepository,
            authRepository: context.read<AuthRepository>(),
          ),
      child: const RegisterView(),
    );
    return const RegisterView();
  }
}

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    // Implement UI and widgets
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state.formStatus == FormStatus.submissionSuccess){
          ScaffoldMessenger.of(context).hideCurrentSnackBar();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration Success. Please verify your email.'),
            ),
          );

          // context.read<CartBloc>().add(
          //     LoadCartEvent(userId: context.read<AuthRepository>().currentUser?.uid)
          // );

          context.go('/');
        }
        if (state.formStatus == FormStatus.submissionFailure) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();

          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Registration Failure'),
              ),
          );
        }
        if (state.formStatus == FormStatus.invalid) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please use a stronger password.'),
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              title: const Text('Register'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(label: Text('Email')),
                    onChanged: (value) {
                      // keep track of email (cubit)
                      context.read<RegisterCubit>().emailChanged(value);
                    },
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(label: Text('Password')),
                    onChanged: (value) {
                      context.read<RegisterCubit>().passwordChanged(value);
                    },
                  ),
                  const SizedBox(height: 8.0),
                  FilledButton(onPressed: (state.formStatus == FormStatus.submissionInProgress)
                      ? null : () {
                    context.read<RegisterCubit>().register();
                  }, child: const Text('Register')),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account?'),
                      TextButton(onPressed: () {
                        context.pop('login');
                      }, child: const Text('Login')),
                    ],
                  )
                ],
              ),
            )
        );
      },
    );
  }
}