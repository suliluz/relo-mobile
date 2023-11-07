import 'package:flutter/material.dart';

class ListTileEditable extends StatefulWidget {
  const ListTileEditable({
    super.key,
    required this.leadingIcon,
    required this.title,
    required this.value,
    required this.description,
    required this.onChanged,
  });

  final IconData leadingIcon;
  final String title;
  final String value;
  final String description;
  final Function(String) onChanged;

  @override
  State<ListTileEditable> createState() => _ListTileEditableState();
}

class _ListTileEditableState extends State<ListTileEditable> {
  final TextEditingController _controller = TextEditingController();

  late bool _editMode = false;
  late bool _disableSave = true;

  @override
  initState() {
    super.initState();
    _controller.text = widget.value;

    _controller.addListener(_handleOnTextChange);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      isThreeLine: true,
      leading: Icon(widget.leadingIcon, color: Colors.black54, size: 24),
      title: Text(widget.title, style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _subtitleBody(),
          !_editMode? Text(widget.description) : TextButton(onPressed: _disableSave? null : () {
            setState(() {
              widget.onChanged(_controller.text);
              _editMode = !_editMode;
            });
          }, child: const Text("Save"),),
        ],
      ),
      trailing: Icon(!_editMode? Icons.edit : Icons.close, color: Theme.of(context).primaryColor),
      onTap: () {
        setState(() {
          _editMode = !_editMode;
        });
      },
    );
  }

  void _handleOnTextChange() {
    setState(() {
      _disableSave = _controller.text.isEmpty;
    });
  }

  Widget _subtitleBody() {
    return !_editMode? Text(widget.value, style: const TextStyle(color: Colors.black54, fontSize: 16, fontWeight: FontWeight.bold)) : TextField(
      controller: _controller,
      maxLines: null,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: widget.title
      ),
    );
  }
}
