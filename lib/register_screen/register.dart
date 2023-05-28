import 'package:pop_app/register_screen/register_screen_1.dart';
import 'package:pop_app/register_screen/register_screen_2.dart';
import 'package:pop_app/register_screen/register_screen_3.dart';
import 'package:pop_app/register_screen/register_screen_4.dart';
import 'package:pop_app/register_screen/register_screen_5.dart';
import 'package:pop_app/screentransitions.dart';
import 'package:pop_app/models/user.dart';

import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repeatedPasswordController = TextEditingController();
  final TextEditingController storeNameController = TextEditingController();

  final String initialUsername;
  final User user = User.empty();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  static RegisterScreenState? of(BuildContext context) {
    try {
      return context.findAncestorStateOfType<RegisterScreenState>();
    } catch (err) {
      return null;
    }
  }

  RegisterScreen({super.key, required this.initialUsername});

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
    widget.firstNameController.text = widget.initialUsername;
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
              content: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'You are registered. '
                          'However, there are still some steps you need to complete. '
                          'If you quit now, you will have to complete them later.',
                      style: Theme.of(context).dialogTheme.contentTextStyle,
                    ),
                    TextSpan(
                      text: '\n\nQuit registration anyway?',
                      style: Theme.of(context).dialogTheme.contentTextStyle,
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Quit registration'),
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
        appBar: AppBar(title: const Text('Register yourself')),
        body: Center(child: _animatedSwitcher()),
      ),
    );
  }
}
