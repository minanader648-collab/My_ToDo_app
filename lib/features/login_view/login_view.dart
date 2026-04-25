import 'package:flutter/material.dart';
import 'package:project_mobile_application/core/constants.dart';
import 'package:project_mobile_application/core/utils/responsive_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_mobile_application/features/login_view/cubit/login_cubit.dart';
import 'package:project_mobile_application/features/login_view/cubit/login_state.dart';
import 'package:project_mobile_application/features/register_view/register_view.dart';
import 'package:project_mobile_application/features/home_view/home_view.dart';
import 'package:project_mobile_application/core/widgets/auth_header.dart';
import 'package:project_mobile_application/core/widgets/custom_text_field.dart';
import 'package:project_mobile_application/core/widgets/primary_button.dart';

class LoginView extends StatefulWidget {
  final String? initialEmail;
  final String? initialPassword;

  const LoginView({super.key, this.initialEmail, this.initialPassword});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;

  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.initialEmail ?? "");
    _passwordController = TextEditingController(text: widget.initialPassword ?? "");
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Login Successful!')),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeView()),
            );
          } else if (state is LoginFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errMessage)),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Scaffold(
              backgroundColor: primary,
              body: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          children: [
                            // ===== Header =====
                            Container(
                              constraints: BoxConstraints(
                                minHeight: context.height(35), // Increased to give more space for header
                              ),
                              child: const AuthHeader(title: "TaskFlow"),
                            ),

                            // ===== Login Container =====
                            Expanded(
                              child: Container(
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
                                        "Welcome Back!",
                                        style: TextStyle(
                                          fontSize: context.width(8),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: context.height(1)),
                                      Text(
                                        "Login to continue",
                                        style: TextStyle(color: Colors.grey, fontSize: context.width(4)),
                                      ),
                                      SizedBox(height: context.height(3)),

                                      // ===== Email =====
                                      CustomTextField(
                                        controller: _emailController,
                                        labelText: 'Email',
                                        prefixIcon: Icons.email,
                                        keyboardType: TextInputType.emailAddress,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'من فضلك ادخل الإيميل';
                                          }
                                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                            return 'ادخل إيميل صحيح';
                                          }
                                          return null;
                                        },
                                      ),

                                      const SizedBox(height: 16),

                                      // ===== Password =====
                                      CustomTextField(
                                        controller: _passwordController,
                                        labelText: 'Password',
                                        prefixIcon: Icons.lock,
                                        obscureText: _isObscure,
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _isObscure ? Icons.visibility_off : Icons.visibility,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _isObscure = !_isObscure;
                                            });
                                          },
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'من فضلك ادخل الباسورد';
                                          }
                                          if (value.length < 6) {
                                            return 'الباسورد لازم يكون 6 حروف على الأقل';
                                          }
                                          return null;
                                        },
                                      ),

                                      // ===== Forgot Password =====
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: TextButton(
                                          onPressed: () {
                                            // هنا روح لصفحة Forgot Password
                                          },
                                          child: const Text(
                                            'Forgot Password?',
                                            style: TextStyle(color: primary),
                                          ),
                                        ),
                                      ),

                                      const SizedBox(height: 8),

                                      // ===== Login Button =====
                                      PrimaryButton(
                                        text: 'Login',
                                        isLoading: state is LoginLoading,
                                        onPressed: () {
                                          if (_formKey.currentState!.validate()) {
                                            context.read<LoginCubit>().loginUser(
                                                  email: _emailController.text,
                                                  password: _passwordController.text,
                                                );
                                          }
                                        },
                                      ),

                                      // ===== Register Link =====
                                      const Spacer(),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            "Don't have an account?",
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 17.0,
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              // هنا روح لصفحة Register
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (BuildContext context) => const RegisterView(),
                                                ),
                                              );
                                            },
                                            child: const Text(
                                              'Register',
                                              style: TextStyle(
                                                color: primary,
                                                fontSize: 17.0,
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
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
