import 'package:flutter/material.dart';
import 'package:pop_app/login_screen/company_selection.dart';
import 'package:pop_app/login_screen/custom_elevatedbutton_widget.dart';
import 'package:pop_app/login_screen/custom_textformfield_widget.dart';
import 'package:pop_app/myconstants.dart';
import 'package:pop_app/register_screen/register.dart';

class FourthRegisterScreen extends StatelessWidget {
  final RegisterScreen widget;
  const FourthRegisterScreen(this.widget, {super.key});

  @override
  Widget build(BuildContext context) {
    return widget.user.role == "seller"
        ? Form(
            key: widget.formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomTextFormField(
                  inputLabel: "Store name",
                  textEditingController: widget.storeNameController,
                  autoFocus: true,
                ),
                const SizedBox(height: MyConstants.formInputSpacer * 1.5),
                FormSubmitButton(
                  buttonText: 'Next',
                  onPressed: () {
                    if (widget.formKey.currentState!.validate()) {
                      widget.user.storeName = widget.storeNameController.text;
                      RegisterScreen.of(context)?.showNextRegisterScreen();
                    }
                  },
                  type: FormSubmitButtonType.RED_FILL,
                )
              ],
            ),
          )
        : CompanySelectionScreen((company) {
            widget.user.storeName = widget.storeNameController.text;
            RegisterScreen.of(context)?.showNextRegisterScreen();
          }, showAppBar: false);
  }
}
