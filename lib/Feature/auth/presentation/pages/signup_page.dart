// ignore_for_file: file_names
import 'package:blog/Feature/auth/presentation/bloc/auth_bloc_bloc.dart';
import 'package:blog/Feature/auth/presentation/pages/auth_gradient_button.dart';
import 'package:blog/Feature/auth/presentation/pages/login_page.dart';
import 'package:blog/Feature/auth/presentation/widgets/auh_field.dart';
import 'package:blog/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatefulWidget {

  static route() => MaterialPageRoute(builder: (context)=>const SignUpPage());
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
              AuthField(hintText: 'Name',controller: nameController),
              const SizedBox(height: 12),
              AuthField(hintText: 'Email',controller: emailController),
              const SizedBox(height: 12),
              AuthField(hintText: 'Password',controller: passwordController,isObscureText: true,),
              const SizedBox(height: 18),
              AuthGradientButton(
                buttonText: 'Sign Up',
                onPressed: () {
                  if(formKey.currentState!.validate()){
                    context.read<AuthBloc>().add(AuthSignUp(
                      email: emailController.text.trim(), 
                      password: passwordController.text.trim(), 
                      name: nameController.text.trim()
                    ));
                  }
                },
              ),
              const SizedBox(height: 18),
              GestureDetector(
                onTap: (){
                  Navigator.push(context,LoginPage.route());
                },
                child: RichText(
                  text: TextSpan(text: "Already Have An Account ? ",
                  style: Theme.of(context).textTheme.titleMedium,
                  children: [
                    TextSpan(
                      text: 'Sign In.',
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
