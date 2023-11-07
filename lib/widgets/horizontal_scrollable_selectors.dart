import 'package:flutter/material.dart';

class HorizontalScrollableSelectorsItem {
  final String label;
  final String value;

  HorizontalScrollableSelectorsItem({required this.label, required this.value});
}

class HorizontalScrollableSelectors extends StatefulWidget {
  HorizontalScrollableSelectors({
    Key? key,
    required this.items,
    required this.value,
    required this.onChanged,
    required this.activeColor,
    this.itemColor = Colors.white,
    this.labelStyle = const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    this.activeLabelStyle = const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
  }) : super(key: key);

  final List<HorizontalScrollableSelectorsItem> items;
  String value;
  final Function onChanged;
  final Color activeColor;
  final Color itemColor;
  final TextStyle labelStyle;
  final TextStyle activeLabelStyle;

  @override
  State<HorizontalScrollableSelectors> createState() => _HorizontalScrollableSelectorsState();
}

class _HorizontalScrollableSelectorsState extends State<HorizontalScrollableSelectors> {
  @override
  Widget build(BuildContext context) {
    // Iterate through items to build items
    List<Widget> constructItem = widget.items.map((HorizontalScrollableSelectorsItem e) {
      return Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 40, minWidth: 80),
          child: GestureDetector(
            onTap: () {
              setState(() {
                widget.value = e.value;
                widget.onChanged(e.value);
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black54),
                  borderRadius: BorderRadius.circular(30),
                  color: widget.value == e.value? widget.activeColor : widget.itemColor
              ),
              child: Center(child: Text(e.label, style: widget.value == e.value? widget.activeLabelStyle : widget.labelStyle,),),
            ),
          ),
        ),
      );
    }).toList();

    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: constructItem,
        )
    );
  }
}
