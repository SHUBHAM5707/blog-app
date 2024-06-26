// ignore_for_file: file_names
import 'package:blog/Feature/auth/presentation/pages/auth_gradient_button.dart';
import 'package:blog/Feature/auth/presentation/pages/signup_page.dart';
import 'package:blog/Feature/auth/presentation/widgets/auh_field.dart';
import 'package:blog/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context)=>const LoginPage());
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Sign In.',
                style: TextStyle(
                  fontSize: 50, 
                  fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 30),
              AuthField(hintText: 'Email',controller: emailController),
              const SizedBox(height: 12),
              AuthField(hintText: 'Password',controller: passwordController,isObscureText: true,),
              const SizedBox(height: 18),
              AuthGradientButton(buttonText: 'Sign In',onPressed: () {},),
              const SizedBox(height: 18),
              GestureDetector(
                onTap: (){
                  Navigator.push(context,SignUpPage.route());
                },
                child: RichText(
                  text: TextSpan(text: "Don't Have An Account ? ",
                  style: Theme.of(context).textTheme.titleMedium,
                  children: [
                    TextSpan(
                      text: 'Sign Up.',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppPallete.gradient2,
                        fontWeight: FontWeight.bold
                      ),
                    )
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
