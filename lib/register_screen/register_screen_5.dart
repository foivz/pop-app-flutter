import 'package:flutter/material.dart';
import 'package:pop_app/myconstants.dart';

/// On this screen the user is already registered with their store assigned to them.
class FifthRegisterScreen extends StatelessWidget {
  const FifthRegisterScreen({super.key});

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
          child: Card(
            color: Colors.greenAccent.shade100,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "A professor has to confirm your registration.\n\n"
                "After your account is confirmed, you will gain access to the rest of the application.",
                style: TextStyle(
                    color: Colors.green.shade900, fontSize: 20, fontFamily: "RobotoMono-Regular"),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
