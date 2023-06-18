import 'package:pop_app/models/user.dart';
import 'package:pop_app/reusable_components/message.dart';
import 'package:pop_app/role_selection/role_selection_widget.dart';

import 'package:flutter/material.dart';

class RoleSelectionScreen extends StatefulWidget {
  final bool showAppBar;
  final void Function(UserRole selectedRole)? onSelectedCallback;
  const RoleSelectionScreen({super.key, this.onSelectedCallback, this.showAppBar = true});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  bool shouldShowAppBar() {
    return widget.showAppBar;
  }

  @override
  Widget build(BuildContext context) {
    bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    GlobalKey roleSelectWidgetKey = GlobalKey();
    return Scaffold(
      appBar: shouldShowAppBar() ? AppBar(title: const Text("Role selection")) : null,
      body: Container(
        margin: EdgeInsets.only(bottom: isPortrait ? 60 : 0),
        child: RoleSelectWidget(key: roleSelectWidgetKey),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          var roleSelect = roleSelectWidgetKey.currentState as RoleSelectWidgetState;
          String selectedOption = roleSelect.selectedOption;
          if (selectedOption == '') {
            Message.info(context).show("You must select a role.");
          } else {
            if (widget.onSelectedCallback != null) {
              UserRole? role = UserRole.getRoleByName(roleSelect.selectedOption);
              if (role != null) {
                widget.onSelectedCallback?.call(role);
              } else {
                Message.error(context).show("Role not supported!");
              }
            } else {
              showAboutDialog(context: context);
            }
          }
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
