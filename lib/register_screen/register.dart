import 'package:flutter/material.dart';
import 'package:pop_app/models/user.dart';
import 'package:pop_app/register_screen/register_screen_1.dart';
import 'package:pop_app/register_screen/register_screen_2.dart';
import 'package:pop_app/register_screen/register_screen_3.dart';
import 'package:pop_app/register_screen/register_screen_4.dart';
import 'package:pop_app/register_screen/register_screen_5.dart';
import 'package:pop_app/screentransitions.dart';

class RegisterScreen extends StatefulWidget {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repeatedPasswordController = TextEditingController();
  final TextEditingController storeNameController = TextEditingController();
  final User user = User.empty();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  static RegisterScreenState? of(BuildContext context) {
    try {
      return context.findAncestorStateOfType<RegisterScreenState>();
    } catch (err) {
      return null;
    }
  }

  RegisterScreen(String initialUsername, {super.key}) {
    firstNameController.text = initialUsername;
  }

  @override
  State<RegisterScreen> createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  int _previousCurrentStep = 0;
  int _currentStep = 0;
  final roleSelectionWidgetKey = GlobalKey();
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
    _registerScreens.add(FourthRegisterScreen(widget));
    _registerScreens.add(const FifthRegisterScreen());
  }

  _animatedSwitcher() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      transitionBuilder: ScreenTransitions.navAnimH(_currentStep > _previousCurrentStep),
      reverseDuration: const Duration(milliseconds: 0),
      child: _registerScreens[_currentStep],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.user.registered) {
          bool quitEarly = false;

          await showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Quit registration?'),
              content: const Text('You are registered. However, the process is not done yet. '
                  'You might have to complete additional steps later. Exit registration anyway?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    quitEarly = false;
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    quitEarly = true;
                    Navigator.pop(context);
                  },
                  child: const Text('Exit registration'),
                ),
              ],
            ),
          );

          return quitEarly;
        }

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
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text('Register yourself'),
        ),
        body: Center(child: _animatedSwitcher()),
      ),
    );
  }
}
