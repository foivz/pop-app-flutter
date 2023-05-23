import 'package:flutter/material.dart';
import 'package:pop_app/login_screen/custom_elevatedbutton_widget.dart';
import 'package:pop_app/login_screen/custom_textformfield_widget.dart';
import 'package:pop_app/myconstants.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register yourself'),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomTextFormField(
                inputLabel: "First Name",
                textEditingController: firstNameController,
                autoFocus: true,
              ),
              const SizedBox(height: MyConstants.formInputSpacer),
              CustomTextFormField(
                inputLabel: "Surname",
                textEditingController: surnameController,
                obscureText: true,
              ),
              const SizedBox(height: MyConstants.formInputSpacer * 1.5),
              FormSubmitButton(
                buttonText: 'Next',
                onPressed: () => {},
                type: FormSubmitButtonType.RED_FILL,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
