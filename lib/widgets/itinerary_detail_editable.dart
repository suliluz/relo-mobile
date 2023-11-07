import 'package:flutter/material.dart';

class ItineraryDetailEditable extends StatefulWidget {
  ItineraryDetailEditable({
    super.key,
    required this.day,
    required this.title,
    required this.description,
    required this.onDelete,
    required this.onEdit,
    this.isOpen = false,
  });

  final int day;
  final String title;
  final String description;
  final Function onDelete;
  late bool isOpen;
  final Function(String, String) onEdit;

  @override
  State<ItineraryDetailEditable> createState() => _ItineraryDetailEditableState();
}

class _ItineraryDetailEditableState extends State<ItineraryDetailEditable> {

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _titleController.text = widget.title;
    _descriptionController.text = widget.description;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                      children: [
                        Icon(Icons.circle_rounded, color: Theme.of(context).primaryColor, size: 16),
                        const SizedBox(width: 8),
                        Text('Day ${widget.day.toString()}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ]
                  ),
                  // arrow up/down icon to expand/collapse the card
                  IconButton(
                    icon: Icon(widget.isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
                    onPressed: () {
                      setState(() {
                        widget.isOpen = !widget.isOpen;
                      });
                    },
                  ),
                ],
              ),
              if(widget.isOpen) Column(
                children: [
                  const SizedBox(height: 8),
                  // TextField for title
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                    ),
                    onChanged: (value) => _handleOnChanged(),
                  ),
                  const SizedBox(height: 8),
                  // TextField for description
                  TextField(
                    controller: _descriptionController,
                    minLines: 1,
                    maxLines: null,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                    ),
                    onChanged: (value) => _handleOnChanged(),
                  ),
                  const SizedBox(height: 8),
                  // Delete button only available if it is not the first itinerary
                  if (widget.day > 1)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => widget.onDelete(),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                ],
              )
            ]
        ),
      ),
    );
  }

  _handleOnChanged() {
    widget.onEdit(_titleController.text, _descriptionController.text);
  }
}
