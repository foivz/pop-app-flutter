import 'package:flutter/material.dart';
import 'package:pop_app/myconstants.dart';

class LoginHomepage extends StatefulWidget {
  const LoginHomepage({super.key});
  @override
  State<LoginHomepage> createState() => _LoginHomepageState();
}

class _LoginHomepageState extends State<LoginHomepage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isUserFocused = false;
  bool isPasswordFocused = false;

  void setFocused(bool usernameFocusedState, passwordFocusedState) {
    setState(() {
      isUserFocused = usernameFocusedState;
      isPasswordFocused = passwordFocusedState;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Center(), // centers the widgets after it, do not remove
                Container(
                  alignment: Alignment.topLeft,
                  color: MyConstants.textfieldBackground,
                  width: MyConstants.textFieldWidth,
                  padding: const EdgeInsets.fromLTRB(15, 10, 10, 10),
                  child: Stack(children: [
                    Align(
                      alignment: Alignment.bottomLeft,
                      heightFactor: _evaluate(isUserFocused, usernameController) ? 1.25 : 0.75,
                      child: Text(
                        'Username',
                        style: TextStyle(
                          color: _color(isUserFocused),
                          fontSize: _evaluate(isUserFocused, usernameController) ? 20 : 10,
                        ),
                        textAlign: !isUserFocused ? TextAlign.center : TextAlign.left,
                      ),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.fromLTRB(0, 15, 5, 5),
                        suffixIcon: usernameController.text.isNotEmpty || isUserFocused
                            ? IconButton(
                                icon: const Icon(Icons.cancel),
                                onPressed: () => setState(() {
                                  usernameController.clear();
                                }),
                              )
                            : null,
                      ),
                      controller: usernameController,
                      validator: (value) {
                        return value == null || value.isEmpty
                            ? 'Please enter a valid username'
                            : null;
                      },
                      onTap: () {
                        setState(() {
                          isUserFocused = true;
                          isPasswordFocused = false;
                        });
                      },
                    ),
                  ]),
                ),
                const SizedBox(height: MyConstants.formInputSpacer),
                Container(
                  alignment: Alignment.topLeft,
                  color: MyConstants.textfieldBackground,
                  width: 300,
                  padding: const EdgeInsets.fromLTRB(15, 10, 10, 10),
                  child: Stack(children: [
                    Align(
                      alignment: Alignment.bottomLeft,
                      heightFactor: _evaluate(isPasswordFocused, passwordController) ? 1.25 : 0.75,
                      child: Text(
                        'Password',
                        style: TextStyle(
                          color: _color(isPasswordFocused),
                          fontSize: _evaluate(isPasswordFocused, passwordController) ? 20 : 10,
                        ),
                        textAlign: !isPasswordFocused ? TextAlign.center : TextAlign.left,
                      ),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.fromLTRB(0, 15, 5, 5),
                        suffixIcon: passwordController.text.isNotEmpty || isPasswordFocused
                            ? IconButton(
                                icon: const Icon(Icons.cancel),
                                onPressed: () => setState(() {
                                  passwordController.clear();
                                }),
                              )
                            : null,
                      ),
                      controller: passwordController,
                      validator: (value) {
                        return value == null || value.isEmpty
                            ? 'Please enter a valid password'
                            : null;
                      },
                      onTap: () {
                        setState(() {
                          isPasswordFocused = true;
                          isUserFocused = false;
                        });
                      },
                    ),
                  ]),
                ),
                const SizedBox(height: MyConstants.formInputSpacer),
                ElevatedButton(
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all<Size>(
                      const Size(MyConstants.textFieldWidth, MyConstants.submitButtonHeight),
                    ),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(
                      MyConstants.red,
                    ),
                    overlayColor: MaterialStateProperty.all<Color>(MyConstants.accentColor),
                  ),
                  onPressed: () {},
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
                    ),
                  ),
                ),
                const SizedBox(height: MyConstants.formInputSpacer / 2),
                const Center(child: Text("- or -", style: TextStyle(fontSize: 20))),
                const SizedBox(height: MyConstants.formInputSpacer / 2),
                ElevatedButton(
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all<Size>(
                      const Size(MyConstants.textFieldWidth, MyConstants.submitButtonHeight),
                    ),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: const BorderSide(color: MyConstants.red, width: 3),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    overlayColor: MaterialStateProperty.all<Color>(MyConstants.accentColor),
                  ),
                  onPressed: () {},
                  child: Text(
                    'Register',
                    style: TextStyle(
                      color: MyConstants.red,
                      fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _color(bool condition) => condition ? MyConstants.accentColor : MyConstants.red;
  bool _evaluate(bool focus, controller) => !focus && controller.text.isEmpty;
}
