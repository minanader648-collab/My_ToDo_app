import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:project_mobile_application/core/constants.dart';
import 'package:project_mobile_application/core/models/user_model.dart';
import 'package:project_mobile_application/core/widgets/custom_text_field.dart';
import 'package:project_mobile_application/core/widgets/primary_button.dart';
import 'package:project_mobile_application/features/login_view/login_view.dart';
import 'package:project_mobile_application/features/home_view/home_view.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _oldPasswordController;
  late TextEditingController _newPasswordController;
  
  String _originalName = '';
  String _originalEmail = '';
  String _actualPassword = '';
  
  bool _isOldPasswordCorrect = false;
  bool _isObscureOld = true;
  bool _isObscureNew = true;
  
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    var sessionBox = Hive.box('sessionBox');
    var userBox = Hive.box<UserModel>('userBox');
    
    String? userKey = sessionBox.get('userKey') ?? sessionBox.get('userEmail');
    String? sessionName = sessionBox.get('userName');
    String? sessionEmail = sessionBox.get('userEmail');

    UserModel? user;
    if (userKey != null) {
      for (var u in userBox.values) {
        if (u.email.trim().toLowerCase() == userKey.trim().toLowerCase()) {
          user = u;
          break;
        }
      }
    }

    _originalName = user?.fullName ?? sessionName ?? '';
    _originalEmail = user?.email ?? sessionEmail ?? '';
    _actualPassword = user?.password ?? '';
    
    _nameController = TextEditingController(text: _originalName);
    _emailController = TextEditingController(text: _originalEmail);
    _oldPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  void _verifyOldPassword() {
    if (_oldPasswordController.text == _actualPassword) {
      setState(() {
        _isOldPasswordCorrect = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Old password verified! You can now set a new password.')),
      );
    } else {
      setState(() {
        _isOldPasswordCorrect = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Incorrect old password.')),
      );
    }
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      var sessionBox = Hive.box('sessionBox');
      var userBox = Hive.box<UserModel>('userBox');
      String? userKey = sessionBox.get('userKey') ?? sessionBox.get('userEmail');

      if (userKey == null) return;

      try {
        int userIndex = -1;
        UserModel? user;
        
        for(int i = 0; i < userBox.length; i++) {
          if (userBox.getAt(i)?.email.trim().toLowerCase() == userKey.trim().toLowerCase()) {
            userIndex = i;
            user = userBox.getAt(i);
            break;
          }
        }

        if (user != null && userIndex != -1) {
          String newName = _nameController.text.trim();
          String newEmail = _emailController.text.trim();
          String newPassword = _isOldPasswordCorrect && _newPasswordController.text.isNotEmpty 
              ? _newPasswordController.text.trim() 
              : _actualPassword;

          bool sensitiveChanged = newEmail != _originalEmail || newPassword != _actualPassword;
          bool nameChanged = newName != _originalName;

          if (!sensitiveChanged && !nameChanged) {
            Navigator.pop(context);
            return;
          }

          UserModel updatedUser = UserModel(
            fullName: newName,
            email: newEmail,
            password: newPassword,
          );

          await userBox.putAt(userIndex, updatedUser);

          if (!mounted) return;

          if (sensitiveChanged) {
            await sessionBox.clear();
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Sensitive data changed. Please login again.')),
            );
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginView()),
              (route) => false,
            );
          } else {
            // Only name changed
            await sessionBox.put('userName', updatedUser.fullName);
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Name updated successfully!')),
            );
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeView()),
              (route) => false,
            );
          }
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: surface,
      appBar: AppBar(
        backgroundColor: primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: primary.withValues(alpha: 0.1),
                  child: Text(
                    _nameController.text.isNotEmpty ? _nameController.text[0].toUpperCase() : 'U',
                    style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: primary),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              
              const Text('Basic Information', style: TextStyle(color: textGray, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              CustomTextField(
                controller: _nameController,
                labelText: 'Full Name',
                prefixIcon: Icons.person_outline,
                validator: (v) => v!.trim().isEmpty ? 'Please enter your name' : null,
              ),
              const SizedBox(height: 16),
              
              CustomTextField(
                controller: _emailController,
                labelText: 'Email Address',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (v) => v!.trim().isEmpty ? 'Please enter your email' : null,
              ),
              
              const SizedBox(height: 32),
              const Text('Security', style: TextStyle(color: textGray, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _oldPasswordController,
                      labelText: 'Old Password',
                      prefixIcon: Icons.lock_open_outlined,
                      obscureText: _isObscureOld,
                      suffixIcon: IconButton(
                        icon: Icon(_isObscureOld ? Icons.visibility_off : Icons.visibility, color: primary),
                        onPressed: () => setState(() => _isObscureOld = !_isObscureOld),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: _verifyOldPassword,
                    child: const Text('Verify', style: TextStyle(color: primary, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              
              if (_isOldPasswordCorrect) ...[
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _newPasswordController,
                  labelText: 'New Password',
                  prefixIcon: Icons.lock_outline,
                  obscureText: _isObscureNew,
                  suffixIcon: IconButton(
                    icon: Icon(_isObscureNew ? Icons.visibility_off : Icons.visibility, color: primary),
                    onPressed: () => setState(() => _isObscureNew = !_isObscureNew),
                  ),
                  validator: (v) => v!.isNotEmpty && v.length < 6 ? 'Password must be 6+ chars' : null,
                ),
              ],
              
              const SizedBox(height: 40),
              
              PrimaryButton(
                text: 'Save Changes',
                onPressed: _updateProfile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
