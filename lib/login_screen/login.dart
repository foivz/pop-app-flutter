// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:pop_app/login_screen/custom_elevatedbutton_widget.dart';
import 'package:pop_app/login_screen/custom_textformfield_widget.dart';
import 'package:pop_app/login_screen/linewithtext_widget.dart';
import 'package:pop_app/myconstants.dart';

import '../register.dart';

class LoginHomepage extends StatefulWidget {
  const LoginHomepage({super.key});
  @override
  State<LoginHomepage> createState() => _LoginHomepageState();
}

class _LoginHomepageState extends State<LoginHomepage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Center(), // centers the widgets after it, do not remove
                CustomTextFormField(
                  inputLabel: "Username",
                  textEditingController: usernameController,
                  autoFocus: true,
                ),
                const SizedBox(height: MyConstants.formInputSpacer),
                CustomTextFormField(
                  inputLabel: "Password",
                  textEditingController: passwordController,
                  obscureText: true,
                ),
                const SizedBox(height: MyConstants.formInputSpacer),
                FormSubmitButton(
                  buttonText: 'Login',
                  onPressed: () {
                    print("Logging in as user ${usernameController.text}");
                  },
                  type: FormSubmitButtonType.RED_FILL,
                ),
                const SizedBox(height: MyConstants.formInputSpacer / 2),
                const LineWithText(lineText: 'or'),
                const SizedBox(height: MyConstants.formInputSpacer / 2),
                FormSubmitButton(
                  buttonText: 'Register',
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegisterScreen())),
                  type: FormSubmitButtonType.RED_OUTLINE,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
