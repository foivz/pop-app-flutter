import 'package:flutter/material.dart';
import 'package:pop_app/login_screen/custom_elevatedbutton_widget.dart';
import 'package:pop_app/login_screen/custom_textformfield_widget.dart';
import 'package:pop_app/models/user.dart';
import 'package:pop_app/myconstants.dart';
import 'package:pop_app/role_selection/role_selection_screen.dart';
import 'package:pop_app/screentransitions.dart';

class RegisterScreen extends StatefulWidget {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repeatedPasswordController =
      TextEditingController();
  final User user = User.empty();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  static RegisterScreenState? of(BuildContext context) {
    try {
      return context.findAncestorStateOfType<RegisterScreenState>();
    } catch (err) {
      return null;
    }
  }

  RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  int _previousCurrentStep = 0;
  int _currentStep = 0;
  final _roleSelectionWidgetKey = GlobalKey();
  final List<Widget> _registerScreens = [];

  void showNextRegisterScreen() {
    setState(() {
      if (_currentStep < _registerScreens.length - 1) {
        _previousCurrentStep = _currentStep;
        _currentStep++;
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _registerScreens.add(FirstRegisterScreen(widget));
    _registerScreens.add(SecondRegisterScreen(widget));
    _registerScreens.add(ThirdRegisterScreen(widget));
  }

  _animatedSwitcher() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      transitionBuilder:
          ScreenTransitions.navAnimH(_currentStep > _previousCurrentStep),
      reverseDuration: const Duration(milliseconds: 0),
      child: _registerScreens[_currentStep],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          bool tryingToExitRegister = _currentStep == 0;
          setState(() {
            if (_currentStep > 0) {
              _previousCurrentStep = _currentStep;
              _currentStep--;
            }
          });
          return tryingToExitRegister;
        },
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Register yourself'),
            ),
            body: Center(child: _animatedSwitcher())));
  }
}

class FirstRegisterScreen extends StatelessWidget {
  final RegisterScreen widget;
  const FirstRegisterScreen(this.widget, {super.key});

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
            textEditingController: widget.lastName,
          ),
          const SizedBox(height: MyConstants.formInputSpacer * 1.5),
          FormSubmitButton(
            buttonText: 'Next',
            onPressed: () {
              if (widget._formKey.currentState!.validate()) {
                widget.user.firstName = widget.firstNameController.text;
                widget.user.lastName = widget.lastName.text;
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
      key: widget._formKey,
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
              if (widget._formKey.currentState!.validate()) {
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

class ThirdRegisterScreen extends StatelessWidget {
  final RegisterScreen widget;
  const ThirdRegisterScreen(this.widget, {super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget._formKey,
      child: RoleSelectionScreen(
        key: RegisterScreen.of(context)?._roleSelectionWidgetKey,
        onSelectedCallback: (selectedRole) {
          widget.user.role = selectedRole;
          RegisterScreen.of(context)?.showNextRegisterScreen();
        },
        showAppBar: false,
      ),
    );
  }
}
