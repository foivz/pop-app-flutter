// ignore_for_file: curly_braces_in_flow_control_structures, avoid_print
import 'package:pop_app/login_screen/custom_elevatedbutton_widget.dart';
import 'package:pop_app/login_screen/custom_textformfield_widget.dart';
import 'package:pop_app/login_screen/linewithtext_widget.dart';
import 'package:pop_app/login_screen/company_selection.dart';
import 'package:pop_app/screentransitions.dart';
import 'package:pop_app/api_requests.dart';
import 'package:pop_app/myconstants.dart';

import 'package:flutter/material.dart';

class BaseLoginScreen extends StatefulWidget {
  const BaseLoginScreen({super.key});
  @override
  State<BaseLoginScreen> createState() => _BaseLoginScreenState();
}

class _BaseLoginScreenState extends State<BaseLoginScreen> {
  TextEditingController usernameCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool blockLoginRequests = false;

  String message = "";
  void error(bool showError) {
    String errorMessage = "Username or password not valid.";
    showError ? setState(() => message = errorMessage) : message = "";
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey loginButtonKey = GlobalKey();
    return Scaffold(
      appBar: MyConstants.appBarAsTopBorder,
      body: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: OrientationBuilder(
              builder: (context, orientation) => SizedBox(
                height: orientation.name == Orientation.portrait.name ? 200 : 100,
                child: Image.asset(
                  'assets/foi/foi-building.png',
                  color: MyConstants.red,
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Center(), // centers the widgets after it, do not remove
                    Text(message, style: Theme.of(context).textTheme.titleMedium),
                    CustomTextFormField(
                      inputLabel: "Username",
                      textEditingController: usernameCont,
                      autoFocus: true,
                    ),
                    const SizedBox(height: MyConstants.formInputSpacer),
                    CustomTextFormField(
                      inputLabel: "Password",
                      textEditingController: passwordCont,
                      obscureText: true,
                    ),
                    const SizedBox(height: MyConstants.formInputSpacer * 3),
                    FormSubmitButton(
                      key: loginButtonKey,
                      buttonText: 'Login',
                      onPressed: () {
                        if (_formKey.currentState!.validate() && !blockLoginRequests) {
                          blockLoginRequests = true;
                          (loginButtonKey.currentState as FormSubmitButtonState).setEnabled(false);
                          ApiRequestManager.login(usernameCont.text, passwordCont.text).then((val) {
                            if (val["STATUS"])
                              _navigate();
                            else
                              error(val.keys.length > 0);
                            (loginButtonKey.currentState as FormSubmitButtonState).setEnabled(true);
                            blockLoginRequests = false;
                          });
                        }
                      },
                      type: FormSubmitButtonType.RED_FILL,
                    ),
                    const SizedBox(height: MyConstants.formInputSpacer / 2),
                    const LineWithText(lineText: 'or'),
                    const SizedBox(height: MyConstants.formInputSpacer / 2),
                    FormSubmitButton(
                      buttonText: 'Register',
                      onPressed: () {
                        print("Willing to register as user ${usernameCont.text}");
                      },
                      type: FormSubmitButtonType.RED_OUTLINE,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  _navigate() {
    Navigator.of(context).push(PageRouteBuilder(
      pageBuilder: (c, a, s) => const CompanySelectionScreen(),
      transitionsBuilder: ScreenTransitions.slideLeft,
    ));
  }
}