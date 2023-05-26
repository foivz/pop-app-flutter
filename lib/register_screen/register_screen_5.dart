import 'package:flutter/material.dart';
import 'package:pop_app/myconstants.dart';

class FifthRegisterScreen extends StatefulWidget {
  const FifthRegisterScreen({super.key});

  @override
  State<FifthRegisterScreen> createState() => _FifthRegisterScreenState();
}

class _FifthRegisterScreenState extends State<FifthRegisterScreen> {
  bool isLoading = true;

  final Widget loaderContent = const CircularProgressIndicator();

  final Widget registrationSuccessfulContent = const Card(
    child: Padding(
      padding: EdgeInsets.all(16.0),
      child: Text(
        "A professor has to confirm your registration.\n\n"
        "After your account is confirmed, you will gain access to the rest of the application.",
        style: TextStyle(
            color: MyConstants.red,
            fontSize: 16,
            fontFamily: "RobotoMono-Regular"),
      ),
    ),
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pop(context),
        child: const Icon(Icons.check),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
            child: isLoading ? loaderContent : registrationSuccessfulContent),
      ),
    );
  }
}
