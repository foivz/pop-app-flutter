import 'package:flutter/material.dart';
import 'package:pop_app/api_requests.dart';
import 'package:pop_app/register_screen/register.dart';
import 'package:pop_app/reusable_components/message.dart';
import 'package:pop_app/role_selection/role_selection_screen.dart';

class ThirdRegisterScreen extends StatelessWidget {
  final RegisterScreen widget;
  const ThirdRegisterScreen(this.widget, {super.key});

  void setUserRole(selectedRole, context) async {
    widget.user.setRole(selectedRole);
    if (await ApiRequestManager.assignRole(widget.user)) {
      RegisterScreen.of(context)?.showNextRegisterScreen();
    } else {
      Message.error(context).show("The role couldn't be assigned to you.\n"
          "Please try again later.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: RoleSelectionScreen(
        key: RegisterScreen.of(context)?.roleSelectionWidgetKey,
        onSelectedCallback: (selectedRole) {
          setUserRole(selectedRole, context);
        },
        showAppBar: false,
      ),
    );
  }
}
