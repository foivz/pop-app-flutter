import 'package:flutter/material.dart';
import 'package:pop_app/login_screen/custom_elevatedbutton_widget.dart';
import 'package:pop_app/login_screen/custom_textformfield_widget.dart';
import 'package:pop_app/myconstants.dart';
import 'package:pop_app/register_screen/register.dart';

class SecondRegisterScreen extends StatelessWidget {
  final RegisterScreen widget;
  SecondRegisterScreen(this.widget, {super.key});
  final emailFieldKey = GlobalKey<FormFieldState>();

  String? validateEmail(value) {
    if (value == null || value.isEmpty || !value.contains('@')) {
      return "Enter valid mail";
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomTextFormField(
            inputLabel: "Username",
            textEditingController: widget.usernameController,
            autoFocus: true,
          ),
          const SizedBox(height: MyConstants.formInputSpacer),
          CustomTextFormField(
            fieldKey: emailFieldKey,
            inputLabel: "Email address",
            textEditingController: widget.emailController,
            validateCallback: validateEmail,
            onUpdateCallback: () => emailFieldKey.currentState?.validate(),
          ),
          const SizedBox(height: MyConstants.formInputSpacer),
          CustomTextFormField(
            inputLabel: "Password",
            textEditingController: widget.passwordController,
            obscureText: true,
          ),
          const SizedBox(height: MyConstants.formInputSpacer),
          CustomTextFormField(
            inputLabel: "Confirm password",
            textEditingController: widget.repeatedPasswordController,
            obscureText: true,
          ),
          const SizedBox(height: MyConstants.formInputSpacer * 1.5),
          FormSubmitButton(
            buttonText: 'Next',
            onPressed: () {
              if (widget.formKey.currentState!.validate()) {
                widget.user.username = widget.usernameController.text;
                widget.user.email = widget.emailController.text;
                widget.user.password = widget.passwordController.text;
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
