import 'package:flutter/material.dart';

class DropdownMenuExample extends StatelessWidget {
  final String label;
  final dynamic value;
  final List<dynamic> list;
  final ValueChanged<dynamic>? onChanged;
  final bool percent;

  DropdownMenuExample({
    required this.label,
    required this.value,
    required this.list,
    required this.onChanged,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(width: 120, child: Text(label)),
        Expanded(
          child: DropdownButton<dynamic>(
            value: value,
            hint: Text("Hepsi"),
            items: list.map<DropdownMenuItem<dynamic>>((dynamic item) {
              return DropdownMenuItem<dynamic>(
                value: item,
                child: Text("$item${percent ? '%' : ''}"),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
        const SizedBox(width: 16.0),
      ],
    );
  }
}

class SuccessDialogWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Success"),
      content: Text("Post request successful!"),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("OK"),
        ),
      ],
    );
  }
}
