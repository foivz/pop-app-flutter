import 'package:pop_app/login_screen/custom_elevatedbutton_widget.dart';
import 'package:pop_app/login_screen/custom_textformfield_widget.dart';
import 'package:pop_app/models/user.dart';
import 'package:pop_app/reusable_components/message.dart';
import 'package:pop_app/register_screen/register.dart';
import 'package:pop_app/api_requests.dart';
import 'package:pop_app/myconstants.dart';

import 'package:flutter/material.dart';

class SecondRegisterScreen extends StatefulWidget {
  final RegisterScreen widget;
  const SecondRegisterScreen(this.widget, {super.key});

  @override
  State<SecondRegisterScreen> createState() => _SecondRegisterScreenState();
}

class _SecondRegisterScreenState extends State<SecondRegisterScreen> {
  final emailFieldKey = GlobalKey<FormFieldState>();
  final passwordFieldKey = GlobalKey<FormFieldState>();
  final repeatedPasswordFieldKey = GlobalKey<FormFieldState>();

  String? failedLoginMessage;

  String? validateEmail(value) {
    if (value == null || value.isEmpty || !value.contains('@')) {
      return "Enter valid mail";
    } else {
      return null;
    }
  }

  String? validatePasswords(value) {
    if (widget.widget.passwordController.text != widget.widget.repeatedPasswordController.text) {
      return "Double-check the entered passwords!";
    } else {
      return null;
    }
  }

  void _setUserData() {
    widget.widget.newUser.username = widget.widget.usernameController.text;
    widget.widget.newUser.email = widget.widget.emailController.text;
    widget.widget.newUser.password = widget.widget.passwordController.text;
  }

  Future registerUser(NewUser newUser) async {
    var responseData = await ApiRequestManager.register(widget.widget.newUser);

    failedLoginMessage = null;

    newUser.registered = responseData["STATUSMESSAGE"] == "Registration successful";

    if (newUser.registered == false) {
      String responseMessage = responseData["STATUSMESSAGE"].toString();

      responseMessage = responseMessage.replaceAll("KorisnickoIme", "Username");
      responseMessage = responseMessage.replaceAll("Prezime", "Surname");
      responseMessage = responseMessage.replaceAll("Ime", "Name");
      responseMessage = responseMessage.replaceAll("Lozinka", "Password");
      responseMessage = responseMessage.replaceAll("KorisnickoIme", "Username");

      failedLoginMessage = "$responseMessage.\n"
          "Please double-check the entered data and try again.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(15),
      clipBehavior: Clip.none,
      child: Form(
        key: widget.widget.formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextFormField(
              inputLabel: "Username",
              textEditingController: widget.widget.usernameController,
              autoFocus: true,
            ),
            const SizedBox(height: MyConstants.formInputSpacer),
            CustomTextFormField(
              fieldKey: emailFieldKey,
              inputLabel: "Email address",
              textEditingController: widget.widget.emailController,
              keyboardType: TextInputType.emailAddress,
              validateCallback: validateEmail,
              onUpdateCallback: () => emailFieldKey.currentState?.validate(),
            ),
            const SizedBox(height: MyConstants.formInputSpacer),
            CustomTextFormField(
              fieldKey: passwordFieldKey,
              inputLabel: "Password",
              textEditingController: widget.widget.passwordController,
              obscureText: true,
            ),
            const SizedBox(height: MyConstants.formInputSpacer),
            CustomTextFormField(
              fieldKey: repeatedPasswordFieldKey,
              inputLabel: "Confirm password",
              textEditingController: widget.widget.repeatedPasswordController,
              obscureText: true,
              validateCallback: validatePasswords,
            ),
            const SizedBox(height: MyConstants.formInputSpacer * 1.5),
            FormSubmitButton(
              buttonText: 'Next',
              onPressed: () async {
                if (widget.widget.formKey.currentState!.validate()) {
                  _setUserData();
                  await registerUser(widget.widget.newUser);

                  // 'mounted' flag checked to make sure context didn't change during registration.
                  if (context.mounted) {
                    if (failedLoginMessage == null) {
                      RegisterScreen.of(context)?.showNextRegisterScreen();
                      Message.info(context).show("Welcome, ${widget.widget.newUser.firstName}!");
                    } else {
                      Message.error(context).show(failedLoginMessage!);
                    }
                  }
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
