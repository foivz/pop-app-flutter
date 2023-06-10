// ignore_for_file: curly_braces_in_flow_control_structures, avoid_print
import 'dart:io';

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
  User? loggedUser;

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
  void error(bool showError, {String errorMessage = "Username or password not valid."}) {
    showError ? setState(() => message = errorMessage) : message = "";
  }

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
                      onPressed: () {
                        if (_formKey.currentState!.validate() && !blockLoginRequests) {
                          blockLoginRequests = true;
                          (loginButton.currentState as FormSubmitButtonState).setLoading(true);
                          String username = usernameCont.text;
                          String password = passwordCont.text;
                          ApiRequestManager.login(username, password).then((val) {
                            loggedUser = User.loginInfo(username: username, password: password);
                            if (val["STATUS"]) {
                              User.storeUserData(val["DATA"], username, password);
                              loggedUser!.firstName = val["DATA"]["Ime"];
                              loggedUser!.lastName = val["DATA"]["Prezime"];
                              if (val["DATA"]["Naziv_Uloge"] == "Prodavac")
                                role = UserRoleType.seller;
                              print(val["DATA"]["Token"]);
                              _navigateToMainScreen();
                            } else if (val["STATUSMESSAGE"] == "USER NEEDS STORE") {
                              _navigateToRoleSelection();
                            } else if (val["STATUSMESSAGE"] ==
                                "This user hasn't been confirmed yet. Please contact your admin.") {
                              Message.info(context).show(
                                  "Account awaiting confirmation.\nPlease be patient and try again later.");
                            } else {
                              error(val.keys.length > 0);
                            }
                            (loginButton.currentState as FormSubmitButtonState).setLoading(false);
                            blockLoginRequests = false;
                          });
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
            loggedUser!.setRole(selectedRole);
            if (selectedRole.roleName == "seller") role = UserRoleType.seller;
            if (await ApiRequestManager.assignRole(loggedUser!)) {
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
    fetchStores(loggedUser!).then(
      (value) => Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (c, a, s) => Scaffold(
            body: Center(
              child: storeSelection(
                loggedUser!,
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
      pageBuilder: (c, a, s) => MainMenuScreen(role: role, user: loggedUser!),
      transitionsBuilder: ScreenTransitions.slideLeft,
    ));
  }

  @override
  void onStoreFetched() {
    setState(() {});
    if (selectedStoreObject != null) {
      loggedUser!.store = selectedStoreObject!;
      _navigateToMainScreen();
    } else {
      Message.error(context).show("Oh no!\n"
          "Something went wrong and the store could not be assigned to you.\n"
          "Try again later.");
    }
  }
}
