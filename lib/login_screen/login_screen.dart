import 'dart:io';

import 'package:pop_app/exceptions/login_exception.dart';
import 'package:pop_app/login_screen/custom_elevatedbutton_widget.dart';
import 'package:pop_app/login_screen/custom_textformfield_widget.dart';
import 'package:pop_app/role_selection/role_selection_screen.dart';
import 'package:pop_app/register_screen/store_fetcher_mixin.dart';
import 'package:pop_app/login_screen/linewithtext_widget.dart';
import 'package:pop_app/reusable_components/message.dart';
import 'package:pop_app/main_menu_screen/main_menu.dart';
import 'package:pop_app/register_screen/register.dart';
import 'package:pop_app/screentransitions.dart';
import 'package:pop_app/secure_storage.dart';
import 'package:pop_app/api_requests.dart';
import 'package:pop_app/models/user.dart';
import 'package:pop_app/myconstants.dart';

import 'package:flutter/material.dart';

class BaseLoginScreen extends StatefulWidget {
  const BaseLoginScreen({super.key});
  @override
  State<BaseLoginScreen> createState() => _BaseLoginScreenState();
}

class _BaseLoginScreenState extends StoreFetcher<BaseLoginScreen> with StoreFetcherMixin {
  TextEditingController usernameCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool blockLoginRequests = false;

  @override
  void initState() {
    super.initState();
    SecureStorage.getUsername().then((val) => setState(() => usernameCont.text = val));
    SecureStorage.getPassword().then((val) => setState(() => passwordCont.text = val));
    checkInternetConnection();
  }

  String message = "";
  void checkInternetConnection() async {
    try {
      await InternetAddress.lookup('example.com');
    } on SocketException catch (_) {
      Message.error(context).show("You don't seem to have an internet connection!\n"
          "Make sure you're connected before you use this application!");
    }
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey loginButton = GlobalKey();
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
                      key: loginButton,
                      buttonText: 'Login',
                      onPressed: () async {
                        if (_formKey.currentState!.validate() && !blockLoginRequests) {
                          blockLoginRequests = true;
                          (loginButton.currentState as FormSubmitButtonState).setLoading(true);
                          String username = usernameCont.text;
                          String password = passwordCont.text;

                          try {
                            User.loggedIn = await ApiRequestManager.login(username, password);
                            User.storeUserData(username, password);

                            _navigateToMainScreen();
                          } on LoginException catch (ex) {
                            if (ex.type == LoginExceptionType.storeMissing) {
                              _navigateToRoleSelection();
                            }
                            if (ex.isError) {
                              Message.error(context).show(ex.messageForUser);
                            } else {
                              Message.info(context).show(ex.messageForUser);
                            }
                          }
                          (loginButton.currentState as FormSubmitButtonState).setLoading(false);
                          blockLoginRequests = false;
                        }
                      },
                    ),
                    const SizedBox(height: MyConstants.formInputSpacer / 2),
                    const LineWithText(lineText: 'or'),
                    const SizedBox(height: MyConstants.formInputSpacer / 2),
                    FormSubmitButton(
                      buttonText: 'Register',
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterScreen(initialUsername: usernameCont.text),
                        ),
                      ),
                      type: FormSubmitButtonStyle.OUTLINE,
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

  UserRoleType role = UserRoleType.buyer;
  _navigateToRoleSelection() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (c, a, s) => RoleSelectionScreen(
          onSelectedCallback: (selectedRole) async {
            User.loggedIn.setRole(selectedRole);
            if (await ApiRequestManager.setLoggedUsersRole()) {
              _navigateToStoreSelection();
            } else if (context.mounted) {
              Message.error(context).show("Role couldn't be selected!"
                  "Try to login again later or register using a different username and email.");
            }
          },
        ),
        transitionsBuilder: ScreenTransitions.slideLeft,
      ),
    );
  }

  _navigateToStoreSelection() {
    fetchStores().then(
      (value) => Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (c, a, s) => Scaffold(
            body: Center(
              child: storeSelection(
                GlobalKey(),
                TextEditingController(),
              ),
            ),
          ),
          transitionsBuilder: ScreenTransitions.slideLeft,
        ),
      ),
    );
  }

  _navigateToMainScreen() {
    Navigator.of(context).push(PageRouteBuilder(
      settings: const RouteSettings(name: "main_menu"),
      pageBuilder: (c, a, s) => MainMenuScreen(role: User.loggedIn.role!),
      transitionsBuilder: ScreenTransitions.slideLeft,
    ));
  }

  @override
  void onStoreFetched() {
    setState(() {});
    if (selectedStoreObject != null) {
      User.loggedIn.store = selectedStoreObject!;
      _navigateToMainScreen();
    } else {
      Message.error(context).show("Oh no!\n"
          "Something went wrong and the store could not be assigned to you.\n"
          "Try again later.");
    }
  }
}
