import 'package:flutter/material.dart';
import 'package:pop_app/login_screen/custom_elevatedbutton_widget.dart';
import 'package:pop_app/login_screen/custom_textformfield_widget.dart';
import 'package:pop_app/myconstants.dart';

class RegisterScreen extends StatefulWidget {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  int _currentStep = 0;
  List<Widget> registerScreens = [];

  void showNextRegisterScreen() {
    setState(() {
      _currentStep++;
    });
  }

  @override
  void initState() {
    super.initState();
    registerScreens.add(FirstRegisterScreen(widget, showNextRegisterScreen));
    registerScreens.add(const Placeholder());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          setState(() {
            _currentStep--;
          });
          return false;
        },
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Register yourself'),
            ),
            body: Center(child: registerScreens[_currentStep])));
  }
}

class FirstRegisterScreen extends StatelessWidget {
  final RegisterScreen widget;
  final Function proceedToNextPage;
  const FirstRegisterScreen(this.widget, this.proceedToNextPage, {super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget._formKey,
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
            textEditingController: widget.surnameController,
            obscureText: true,
          ),
          const SizedBox(height: MyConstants.formInputSpacer * 1.5),
          FormSubmitButton(
            buttonText: 'Next',
            onPressed: () => proceedToNextPage(),
            type: FormSubmitButtonType.RED_FILL,
          )
        ],
      ),
    );
  }
}
