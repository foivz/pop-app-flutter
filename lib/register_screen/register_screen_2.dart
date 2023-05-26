import 'package:flutter/material.dart';
import 'package:pop_app/login_screen/custom_elevatedbutton_widget.dart';
import 'package:pop_app/login_screen/custom_textformfield_widget.dart';
import 'package:pop_app/myconstants.dart';
import 'package:pop_app/register_screen/register.dart';

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

  String? validateEmail(value) {
    if (value == null || value.isEmpty || !value.contains('@')) {
      return "Enter valid mail";
    } else {
      return null;
    }
  }

  String? validatePasswords(value) {
    if (widget.widget.passwordController.text !=
        widget.widget.repeatedPasswordController.text) {
      return "Double-check the entered passwords!";
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
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
            onPressed: () {
              if (widget.widget.formKey.currentState!.validate()) {
                widget.widget.user.username =
                    widget.widget.usernameController.text;
                widget.widget.user.email = widget.widget.emailController.text;
                widget.widget.user.password =
                    widget.widget.passwordController.text;
                RegisterScreen.of(context)?.showNextRegisterScreen();
              }
            },
            type: FormSubmitButtonType.RED_FILL,
          )
        ],
      ),
    );
  }
}
