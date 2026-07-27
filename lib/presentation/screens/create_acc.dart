import 'package:eshop_app/core/theme/app_colors.dart';
import 'package:eshop_app/presentation/cubit/auth/auth_cubit.dart';
import 'package:eshop_app/presentation/cubit/auth/auth_state.dart';
import 'package:eshop_app/presentation/widgets/custom_buttonwidget.dart';
import 'package:eshop_app/presentation/widgets/custom_textformfiled.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../app/routes/app_pages.dart';

class CreateAcc extends StatelessWidget {
  CreateAcc({super.key});

  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final ValueNotifier<bool> _isPasswordVisible = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.green),
          );
          // الانتقال مع تمرير الإيميل ليكون متاحاً في شاشة الـ OTP
          context.go(AppRoutes.otp, extra: _emailController.text.trim());
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary, size: 20),
              onPressed: () => context.pop(),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    const Text(
                      "Create Account",
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Fill in your details to get started",
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 40),
                    CustomTextFormField(
                      controller: _firstNameController,
                      hintText: "First Name",
                      prefixIcon: const Icon(Icons.person_outline, color: AppColors.textSecondary),
                      validator: (value) => value == null || value.isEmpty ? "Required" : null,
                    ),
                    const SizedBox(height: 20),
                    CustomTextFormField(
                      controller: _lastNameController,
                      hintText: "Last Name",
                      prefixIcon: const Icon(Icons.person_outline, color: AppColors.textSecondary),
                      validator: (value) => value == null || value.isEmpty ? "Required" : null,
                    ),
                    const SizedBox(height: 20),
                    CustomTextFormField(
                      controller: _emailController,
                      hintText: "Email Address",
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(Icons.email_outlined, color: AppColors.textSecondary),
                      validator: (value) {
                        if (value == null || value.isEmpty) return "Required";
                        if (!value.contains('@')) return "Invalid email";
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ValueListenableBuilder(
                      valueListenable: _isPasswordVisible,
                      builder: (context, isVisible, child) {
                        return CustomTextFormField(
                          controller: _passwordController,
                          hintText: "Password",
                          obscureText: !isVisible,
                          prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textSecondary),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isVisible ? Icons.visibility : Icons.visibility_off,
                              color: AppColors.textSecondary,
                            ),
                            onPressed: () => _isPasswordVisible.value = !isVisible,
                          ),
                          validator: (value) => (value?.length ?? 0) < 6 ? "Too short" : null,
                        );
                      },
                    ),
                    const SizedBox(height: 40),
                    CustomButton(
                      text: "Sign Up",
                      isLoading: state is AuthLoading,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<AuthCubit>().signUp(
                                firstName: _firstNameController.text.trim(),
                                lastName: _lastNameController.text.trim(),
                                email: _emailController.text.trim(),
                                password: _passwordController.text,
                              );
                        }
                      },
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account? ",
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                        GestureDetector(
                          onTap: () => context.push(AppRoutes.login),
                          child: const Text(
                            "Log In",
                            style: TextStyle(
                              color: AppColors.primaryOrange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
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
