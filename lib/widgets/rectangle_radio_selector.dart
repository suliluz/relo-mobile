import 'package:flutter/material.dart';

class RectangleRadioSelectorItem {
  final Icon? icon;
  final String label;
  final String value;

  RectangleRadioSelectorItem({this.icon, required this.label, required this.value});
}

class RectangleRadioSelector extends StatefulWidget {
  RectangleRadioSelector({Key? key, required this.items, required this.onSelected, required this.value, required this.selectedColor, this.unselectedColor = Colors.black54}) : super(key: key);

  final List<RectangleRadioSelectorItem> items;
  final Function onSelected;
  String value;
  final Color selectedColor;
  final Color unselectedColor;

  @override
  State<RectangleRadioSelector> createState() => _RectangleRadioSelectorState();
}

class _RectangleRadioSelectorState extends State<RectangleRadioSelector> {
  @override
  Widget build(BuildContext context) {
    List<Widget> constructItem = widget.items.map((RectangleRadioSelectorItem e) {
      return ConstrainedBox(
        constraints: BoxConstraints(minHeight: 50, maxHeight: 100, minWidth: MediaQuery.of(context).size.width * .40),
        child: GestureDetector(
          onTap: () {
            setState(() {
              widget.value = e.value;
              widget.onSelected(e.value);
            });
          },
          child: Container(
              decoration: BoxDecoration(
                color: widget.value == e.value? Colors.black12 : Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: widget.value == e.value? widget.selectedColor : widget.unselectedColor),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: e.icon != null? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [e.icon!, const SizedBox(height: 10,) , Text(e.label)],
                ) : Center(child: Text(e.label),),
              )
          ),
        ),
      );
    }).toList();

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: constructItem,
    );
  }
}
