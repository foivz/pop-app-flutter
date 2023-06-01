import 'package:flutter/material.dart';
import 'package:pop_app/login_screen/custom_elevatedbutton_widget.dart';
import 'package:pop_app/login_screen/custom_textformfield_widget.dart';
import 'package:pop_app/myconstants.dart';
import 'package:pop_app/register_screen/register.dart';

class FirstRegisterScreen extends StatelessWidget {
  final RegisterScreen widget;
  const FirstRegisterScreen(this.widget, {super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomTextFormField(
            inputLabel: "First Name",
            textEditingController: widget.firstNameController,
            autoFocus: true,
          ),
          const SizedBox(height: MyConstants.formInputSpacer),
          CustomTextFormField(
            inputLabel: "Surname",
            textEditingController: widget.lastName,
          ),
          const SizedBox(height: MyConstants.formInputSpacer * 1.5),
          FormSubmitButton(
            buttonText: 'Next',
            onPressed: () {
              if (widget.formKey.currentState!.validate()) {
                widget.user.firstName = widget.firstNameController.text;
                widget.user.lastName = widget.lastName.text;
                RegisterScreen.of(context)?.showNextRegisterScreen();
              }
            },
          )
        ],
      ),
    );
  }
}
