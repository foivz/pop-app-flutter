import 'package:flutter/material.dart';
import 'package:pop_app/reusable_components/form_submit_button_widget.dart';
import 'package:pop_app/reusable_components/form_text_input_field.dart';
import 'package:pop_app/utils/myconstants.dart';
import 'package:pop_app/user_info_screen/register_screen/register.dart';

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
          FormTextInputField(
            inputLabel: "First Name",
            textEditingController: widget.firstNameController,
            autoFocus: true,
          ),
          const SizedBox(height: MyConstants.formInputSpacer),
          FormTextInputField(
            inputLabel: "Surname",
            textEditingController: widget.lastName,
          ),
          const SizedBox(height: MyConstants.formInputSpacer * 1.5),
          FormSubmitButton(
            buttonText: 'Next',
            onPressed: () {
              if (widget.formKey.currentState!.validate()) {
                widget.newUser.firstName = widget.firstNameController.text;
                widget.newUser.lastName = widget.lastName.text;
                RegisterScreen.of(context)?.showNextRegisterScreen();
              }
            },
          )
        ],
      ),
    );
  }
}
