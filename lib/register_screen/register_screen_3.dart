import 'package:flutter/material.dart';
import 'package:pop_app/register_screen/register.dart';
import 'package:pop_app/role_selection/role_selection_screen.dart';

class ThirdRegisterScreen extends StatelessWidget {
  final RegisterScreen widget;
  const ThirdRegisterScreen(this.widget, {super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: RoleSelectionScreen(
        key: RegisterScreen.of(context)?.roleSelectionWidgetKey,
        onSelectedCallback: (selectedRole) {
          widget.user.role = selectedRole;
          RegisterScreen.of(context)?.showNextRegisterScreen();
        },
        showAppBar: false,
      ),
    );
  }
}
