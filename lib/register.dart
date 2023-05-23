import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  bool isNameFocused = false;
  bool isSurnameFocused = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register yourself'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 50),
              AnimatedContainer(
                duration: Duration(milliseconds: 200),
                margin: EdgeInsets.only(
                  top: isNameFocused || nameController.text.isNotEmpty ? 0 : 24,
                ),
                child: const Text(
                  'Name',
                  style: TextStyle(
                    color: Color.fromRGBO(223, 24, 60, 1),
                  ),
                ),
              ),
              TextField(
                controller: nameController,
                onTap: () {
                  setState(() {
                    isNameFocused = true;
                    isSurnameFocused = false;
                  });
                },
              ),
              const SizedBox(height: 20),
              AnimatedContainer(
                duration: Duration(milliseconds: 200),
                margin: EdgeInsets.only(
                  top: isSurnameFocused || surnameController.text.isNotEmpty
                      ? 0
                      : 24,
                ),
                child: const Text(
                  'Surname',
                  style: TextStyle(
                    color: Color.fromRGBO(223, 24, 60, 1),
                  ),
                ),
              ),
              TextField(
                controller: surnameController,
                onTap: () {
                  setState(() {
                    isSurnameFocused = true;
                    isNameFocused = false;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  String name = nameController.text;
                  String surname = surnameController.text;
                  print('Name: $name');
                  print('Surname: $surname');
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.transparent,
                  ),
                  elevation: MaterialStateProperty.all<double>(0),
                  overlayColor: MaterialStateProperty.all<Color>(
                    Color.fromRGBO(223, 24, 60, 0.2),
                  ),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(
                    color: Color.fromRGBO(223, 24, 60, 1),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
