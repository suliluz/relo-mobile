import 'package:flutter/material.dart';

class MultiItemField extends StatefulWidget {
  const MultiItemField({
    super.key,
    required this.label,
    this.hintText,
    required this.onAdded,
    required this.onDeleted,
    required this.items,
    });

  final String label;
  final String? hintText;
  final Function(String) onAdded;
  final Function(String) onDeleted;
  final List<String> items;

  @override
  State<MultiItemField> createState() => _MultiItemFieldState();
}

class _MultiItemFieldState extends State<MultiItemField> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.label),
          const SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    widget.onAdded(_controller.text);
                    _controller.clear();
                  });
                },
                child: const Text('Add'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: widget.items.map((item) {
              return Chip(
                label: Text(item),
                onDeleted: () {
                  setState(() {
                    widget.onDeleted(item);
                  });
                },
              );
            }).toList()
          ),
        ],
      ),
    );
  }
}