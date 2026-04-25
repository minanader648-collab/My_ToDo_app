import 'package:flutter/material.dart';
import 'package:project_mobile_application/core/constants.dart';
import 'package:project_mobile_application/core/utils/responsive_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_mobile_application/features/register_view/cubit/register_cubit.dart';
import 'package:project_mobile_application/features/register_view/cubit/register_state.dart';
import 'package:project_mobile_application/features/login_view/login_view.dart';
import 'package:project_mobile_application/core/widgets/auth_header.dart';
import 'package:project_mobile_application/core/widgets/custom_text_field.dart';
import 'package:project_mobile_application/core/widgets/primary_button.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;
  bool _isConfirmObscure = true;

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Registration Successful!')),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LoginView(
                  initialEmail: _emailController.text,
                  initialPassword: _passwordController.text,
                ),
              ),
            );
          } else if (state is RegisterFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errMessage)),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Scaffold(
              backgroundColor: primary,
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    // ===== Header =====
                    SizedBox(
                      height: context.height(25),
                      child: const AuthHeader(title: "My ToDo"),
                    ),

                    // ===== Register Form =====
                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Create Account",
                              style: TextStyle(
                                fontSize: context.width(8),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: context.height(1)),
                            Text(
                              "Register to start managing tasks",
                              style: TextStyle(color: Colors.grey, fontSize: context.width(4)),
                            ),
                            SizedBox(height: context.height(3)),

                            CustomTextField(
                              controller: _fullNameController,
                              labelText: 'Full Name',
                              prefixIcon: Icons.person,
                              validator: (value) => value!.isEmpty ? 'Enter your name' : null,
                            ),
                            const SizedBox(height: 16),

                            CustomTextField(
                              controller: _emailController,
                              labelText: 'Email',
                              prefixIcon: Icons.email,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) => value!.isEmpty ? 'Enter your email' : null,
                            ),
                            const SizedBox(height: 16),

                            CustomTextField(
                              controller: _passwordController,
                              labelText: 'Password',
                              prefixIcon: Icons.lock,
                              obscureText: _isObscure,
                              suffixIcon: IconButton(
                                icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
                                onPressed: () => setState(() => _isObscure = !_isObscure),
                              ),
                              validator: (value) => value!.length < 6 ? 'Min 6 chars' : null,
                            ),
                            const SizedBox(height: 16),

                            CustomTextField(
                              controller: _confirmPasswordController,
                              labelText: 'Confirm Password',
                              prefixIcon: Icons.lock_outline,
                              obscureText: _isConfirmObscure,
                              suffixIcon: IconButton(
                                icon: Icon(_isConfirmObscure ? Icons.visibility_off : Icons.visibility),
                                onPressed: () => setState(() => _isConfirmObscure = !_isConfirmObscure),
                              ),
                              validator: (value) {
                                if (value != _passwordController.text) return 'Passwords do not match';
                                return null;
                              },
                            ),
                            const SizedBox(height: 32),

                            PrimaryButton(
                              text: 'Register',
                              isLoading: state is RegisterLoading,
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<RegisterCubit>().registerUser(
                                        fullName: _fullNameController.text,
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                      );
                                }
                              },
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Already have an account? ", style: TextStyle(color: Colors.grey)),
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Login', style: TextStyle(color: primary, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
