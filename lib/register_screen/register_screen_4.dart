import 'package:flutter/material.dart';
import 'package:pop_app/models/user.dart';
import 'package:pop_app/register_screen/register.dart';
import 'package:pop_app/register_screen/store_fetcher_mixin.dart';
import 'package:pop_app/reusable_components/message.dart';

/// This screen has a lot of work to do.
/// First, for buyers, it fetches all stores.
/// Then, selected store needs to get assigned to both types of users.
class FourthRegisterScreen extends StatefulWidget {
  final RegisterScreen widget;
  const FourthRegisterScreen(this.widget, {super.key});

  @override
  State<FourthRegisterScreen> createState() => _FourthRegisterScreenState();
}

class _FourthRegisterScreenState extends StoreFetcher<FourthRegisterScreen> with StoreFetcherMixin {
  @override
  void onStoreFetched() {
    if (selectedStoreObject != null) {
      widget.widget.newUser.store = selectedStoreObject!;
      RegisterScreen.of(context)?.showNextRegisterScreen();
    } else {
      Message.error(context).show("Oh no!\n"
          "Something went wrong and the store could not be assigned to you.\n"
          "Try again later.");
    }
  }

  @override
  void initState() {
    if (widget.widget.newUser.role?.type == UserRoleType.buyer) {
      fetchStores();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return storeSelection(
      widget.widget.formKey,
      widget.widget.storeNameController,
    );
  }
}
