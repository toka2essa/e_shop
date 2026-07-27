import 'package:eshop_app/app/routes/app_pages.dart';
import 'package:eshop_app/core/theme/app_colors.dart';
import 'package:eshop_app/presentation/cubit/app/app_cubit.dart';
import 'package:eshop_app/presentation/cubit/app/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {
        if (state.status == AppStatus.success &&
            state.action == AppAction.login) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message ?? 'Success'),
              backgroundColor: Colors.green,
            ),
          );
          context.go(AppRoutes.home);
        } else if (state.status == AppStatus.failure &&
            state.action == AppAction.login) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message ?? 'Something went wrong'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.status == AppStatus.loading;
        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.textPrimary,
              ),
              onPressed: () => context.pop(),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 24),
                    const Text(
                      'Welcome back',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Log in to continue shopping.',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 40),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: const InputDecoration(
                        labelText: 'Email address',
                        labelStyle: TextStyle(color: AppColors.textSecondary),
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Enter your email address.';
                        }
                        if (!value.contains('@'))
                          return 'Enter a valid email address.';
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: AppColors.textSecondary),
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Enter your password.';
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryOrange,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: isLoading
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<AppCubit>().login(
                                    email: _emailController.text.trim(),
                                    password: _passwordController.text,
                                  );
                                }
                              },
                        child: isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Log in'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () => context.push(AppRoutes.signup),
                      child: const Text(
                        'Create a new account',
                        style: TextStyle(color: AppColors.primaryOrange),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
