import 'package:pop_app/models/user.dart';
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
  bool _lockSnackbar = false;

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
            if (!_lockSnackbar) {
              _lockSnackbar = true;
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                dismissDirection: DismissDirection.down,
                content: Text("You must select a role."),
                duration: Duration(seconds: 1),
              ));
              Future.delayed(const Duration(seconds: 1), () => _lockSnackbar = false);
            }
          } else {
            if (widget.onSelectedCallback != null) {
              widget.onSelectedCallback!.call(User.roles
                  .firstWhere((element) => element.roleName == roleSelect.selectedOption));
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
