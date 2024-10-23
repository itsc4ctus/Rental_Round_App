import 'package:flutter/material.dart';

class filterItems {
  static Widget filterFeild(
      String feildName, bool value, Function(bool?) function) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
          height: 40,
          width: 200,
          child: Text(
            feildName,
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
        ),
        Container(child: Checkbox(value: value, onChanged: function)),
      ],
    );
  }

  static Widget seatPicker(int seat, VoidCallback onTap,
      [String plus = "", bool selected = false]) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(),
          color: selected == false ? Colors.blue.shade50 : Colors.blue,
          borderRadius: BorderRadius.circular(10),
        ),
        height: 40,
        width: 40,
        child: Center(child: Text("$seat$plus")),
      ),
    );
  }
}
