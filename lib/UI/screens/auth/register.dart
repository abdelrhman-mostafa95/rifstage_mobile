import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rifstage_mobile/Data/providers/auth_provider.dart';
import 'package:rifstage_mobile/UI/core/constants/app_colors.dart';
import 'package:rifstage_mobile/UI/core/widgets/auth/custom_text_field.dart';

class Register extends StatefulWidget {
  static const String routeName = '/register';
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthUserProvider>(context, listen: false);

    try {
      await authProvider.register(
        emailController.text.trim(),
        passwordController.text.trim(),
        name: nameController.text.trim(),
      );

      final user = authProvider.user;

      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              '✅ Account created successfully! Please check your email to confirm your account before logging in.',
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 5),
          ),
        );

        if (mounted) {
          Future.delayed(const Duration(seconds: 1), () {
            context.go('/login');
          });
        }
        return;
      }
    } catch (e) {
      final errorMessage = e.toString().contains('over_email_send_rate_limit')
          ? 'Please wait a few seconds before requesting another confirmation email.'
          : 'Registration failed: ${e.toString()}';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthUserProvider>(context);

    return Scaffold(
      backgroundColor: AppColorsDark.primaryBackground,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      "Create Account",
                      style: TextStyle(
                        color: AppColorsDark.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Image(
                      image: AssetImage("assets/images/rifstage-logo.png.png"),
                      height: 40,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Join us and start discovering amazing tracks!",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Name
                  CustomTextField(
                    label: "Full Name",
                    controller: nameController,
                    icon: Icons.person,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your name";
                      }
                      if (value.length < 3) {
                        return "Name must be at least 3 characters";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Email
                  CustomTextField(
                    label: "Email",
                    controller: emailController,
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your email";
                      }
                      if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                        return "Invalid email format";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Password
                  CustomTextField(
                    label: "Password",
                    controller: passwordController,
                    icon: Icons.lock,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a password";
                      }
                      if (value.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Confirm Password
                  CustomTextField(
                    label: "Confirm Password",
                    controller: confirmPasswordController,
                    icon: Icons.lock_outline,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please confirm your password";
                      }
                      if (value != passwordController.text) {
                        return "Passwords do not match";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 24),

                  // Register button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: authProvider.isLoading
                        ? const CircularProgressIndicator(
                            color: AppColorsDark.yellow)
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColorsDark.yellow,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: _submit,
                            child: const Text(
                              "Register",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(height: 20),

                  // Login link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account? ",
                        style: TextStyle(color: Colors.white70),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (mounted) {
                            context.go('/login');
                          }
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            color: AppColorsDark.yellow,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
