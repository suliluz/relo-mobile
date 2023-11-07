import 'package:flutter/material.dart';

class InnerLabelTextField extends StatefulWidget {
  const InnerLabelTextField({Key? key, required this.label, this.onFocusChanged, this.textEditingController, this.onSubmitted, this.editable = true}) : super(key: key);

  final String label;
  final Function? onFocusChanged;
  final TextEditingController? textEditingController;
  final Function? onSubmitted;
  final bool editable;

  @override
  State<InnerLabelTextField> createState() => _InnerLabelTextFieldState();
}

class _InnerLabelTextFieldState extends State<InnerLabelTextField> {

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _focusNode.addListener(_listener);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _focusNode.requestFocus();
        });
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
        decoration: BoxDecoration(
          border: Border.all(color: _focusNode.hasFocus? Theme.of(context).primaryColor : Colors.black54),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.label, style: TextStyle(fontSize: 12, color: _focusNode.hasFocus? Theme.of(context).primaryColor : Colors.black54),),
            TextField(
              readOnly: !widget.editable,
              keyboardType: TextInputType.text,
              controller: widget.textEditingController,
              focusNode: _focusNode,
              decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                  border: InputBorder.none
              ),
              onSubmitted: widget.onSubmitted != null? (value) => widget.onSubmitted!(value) : null,
            )
          ],
        ),
      ),
    );
  }

  void _listener() {
    setState(() {
      if(widget.onFocusChanged != null) {
        _focusNode.hasFocus ? widget.onFocusChanged!(true) : widget.onFocusChanged!(false);
      }
    });
  }
}
