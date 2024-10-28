import 'package:flutter/material.dart';

class SpecificWorkTile extends StatefulWidget {
  SpecificWorkTile({required this.workName,required this.workValue,required this.onChanged,super.key});
  final String workName;
  final bool workValue;
  final ValueChanged<bool?> onChanged;
  @override
  State<SpecificWorkTile> createState() => _SpecificWorkTileState();
}

class _SpecificWorkTileState extends State<SpecificWorkTile> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(widget.workName),
        Checkbox(value: widget.workValue, onChanged: widget.onChanged)
      ],
    );
  }
}
