import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String? value;
  final String label;
  final List<String> items;
  final Function(String?) onChanged;
  final EdgeInsetsGeometry margin; // Add margin parameter
  final Icon openIcon;
  final String hintText; // Add hintText parameter

  const CustomDropdown({
    required this.value,
    required this.label,
    required this.items,
    required this.onChanged,
    this.margin = EdgeInsets.zero, // Default margin is zero
    this.openIcon =
        const Icon(Icons.arrow_drop_down), // Default icon for dropdown
    super.key,
    required this.hintText, // Add hint text to constructor
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Wrap with Padding widget to apply margin
      padding: margin, // Apply the margin
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText, // Use hint text here
        ),
        items: items.map((String location) {
          return DropdownMenuItem<String>(
            value: location,
            child: Text(location),
          );
        }).toList(),
        onChanged: onChanged,
        icon: openIcon, // Add the custom icon for the dropdown
      ),
    );
  }
}
