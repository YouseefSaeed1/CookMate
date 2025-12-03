import 'package:flutter/material.dart';

class NumberedListInput extends StatefulWidget {
  const NumberedListInput({
    super.key,
    required this.controller,
    required this.label,
  });
  final TextEditingController controller;
  final String label;

  @override
  State<NumberedListInput> createState() => _NumberedListInputState();
}

class _NumberedListInputState extends State<NumberedListInput> {
  String _previousValue = '';

  @override
  void initState() {
    super.initState();
    _previousValue = widget.controller.text;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextFormField(
        controller: widget.controller,
        decoration: InputDecoration(
          labelText: widget.label,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(8),
        ),
        maxLines: null,
        keyboardType: TextInputType.multiline,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter the ${widget.label}.';
          }
          return null;
        },
        onChanged: (value) {
          if (value.length < _previousValue.length) {
            _previousValue = value;
            return;
          }
          if (value.isNotEmpty && !value.startsWith("1. ")) {
            if (_previousValue.isEmpty) {
              final newText = '1. $value';
              widget.controller.value = TextEditingValue(
                text: newText,
                selection: TextSelection.collapsed(offset: newText.length),
              );
            }
          } else if (value.endsWith('\n')) {
            final lines = value.split('\n');
            final nextNum = lines.length;
            final newValue = "$value$nextNum. ";
            widget.controller.value = TextEditingValue(
              text: newValue,
              selection: TextSelection.collapsed(offset: newValue.length),
            );
          }

          _previousValue = widget.controller.text;
        },
      ),
    );
  }
}
