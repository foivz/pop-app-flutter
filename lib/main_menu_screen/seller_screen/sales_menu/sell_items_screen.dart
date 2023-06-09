import 'package:flutter/material.dart';
import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/item_card.dart';
import 'package:pop_app/models/item.dart';
import 'package:pop_app/myconstants.dart';

class SellItemsScreen extends StatefulWidget {
  final List<Item> selectedItems;
  const SellItemsScreen(this.selectedItems, {super.key});

  @override
  State<SellItemsScreen> createState() => _SellItemsScreenState();
}

class _SellItemsScreenState extends State<SellItemsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Invoice generation")),
      bottomNavigationBar: const SellContent(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.sell),
        onPressed: () {},
      ),
      body: ListView.separated(
        itemCount: widget.selectedItems.length,
        shrinkWrap: true,
        clipBehavior: Clip.none,
        separatorBuilder: (context, index) => const Divider(
          indent: 3,
          endIndent: 3,
          thickness: 0, // linked to vertical symmetric padding above
        ),
        padding: const EdgeInsets.all(5),
        itemBuilder: (context, index) {
          Item currentItem = widget.selectedItems[index];
          return ItemCard(
            index: index,
            item: currentItem,
            onAmountChange: (newAmount) {},
          );
        },
      ),
    );
  }
}

class SellContent extends StatefulWidget {
  const SellContent({super.key});

  @override
  State<SellContent> createState() => _SellContentState();
}

class _SellContentState extends State<SellContent> {
  GlobalKey<FormFieldState>? discountInputKey = GlobalKey();
  TextEditingController discountInputCont = TextEditingController(text: "0");
  double contentHeight = 120;

  void returnToNormalSize() {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      contentHeight = 120;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: 100,
      height: contentHeight,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.elliptical(20, 10),
          topRight: Radius.elliptical(20, 10),
        ),
        color: MyConstants.red,
      ),
      duration: const Duration(milliseconds: 200),
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, top: 16.0, right: 120, bottom: 16.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Form(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "DISCOUNT (%):",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  color: MyConstants.textfieldBackground,
                  width: 75,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Stack(children: [
                    TextFormField(
                      key: discountInputKey,
                      controller: discountInputCont,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        floatingLabelStyle: MaterialStateTextStyle.resolveWith(
                          (states) => const TextStyle(
                            color: MyConstants.red,
                            fontSize: 15,
                          ),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: MyConstants.accentColor),
                        ),
                        contentPadding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                      ),
                      textInputAction: TextInputAction.done,
                      onTap: () => setState(() {
                        contentHeight = 500;
                      }),
                      onEditingComplete: () => returnToNormalSize(),
                      onTapOutside: (event) {
                        returnToNormalSize();
                      },
                    ),
                  ]),
                )
              ],
            ),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "TOTAL:",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Text(
                "50",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          )
        ]),
      ),
    );
  }
}
