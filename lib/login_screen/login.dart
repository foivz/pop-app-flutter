// ignore_for_file: curly_braces_in_flow_control_structures, avoid_print

import 'package:flutter/material.dart';
import 'package:pop_app/login_screen/company_selection.dart';
import 'package:pop_app/login_screen/custom_elevatedbutton_widget.dart';
import 'package:pop_app/login_screen/custom_textformfield_widget.dart';
import 'package:pop_app/login_screen/linewithtext_widget.dart';
import 'package:pop_app/myconstants.dart';
import 'package:pop_app/screentransitions.dart';

class BaseLoginScreen extends StatefulWidget {
  const BaseLoginScreen({super.key});
  @override
  State<BaseLoginScreen> createState() => _BaseLoginScreenState();
}

class _BaseLoginScreenState extends State<BaseLoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {}, child: const Icon(Icons.check)),
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
                    Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (c, a, s) => const CompanySelectionScreen(),
                      transitionsBuilder: ScreenTransitions.slideLeft,
                    ));
                  },
                  type: FormSubmitButtonType.RED_FILL,
                ),
                const SizedBox(height: MyConstants.formInputSpacer / 2),
                const LineWithText(lineText: 'or'),
                const SizedBox(height: MyConstants.formInputSpacer / 2),
                FormSubmitButton(
                  buttonText: 'Register',
                  onPressed: () {
                    print("Willing to register as user ${usernameController.text}");
                  },
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
