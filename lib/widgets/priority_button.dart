import 'package:flutter/material.dart';

class PriorityButton extends StatelessWidget {
  final String label;
  final String selectedPriority;
  final Function(String) onPrioritySelected;

  const PriorityButton({
    super.key,
    required this.label,
    required this.selectedPriority,
    required this.onPrioritySelected,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = selectedPriority == label;
    
    return Expanded(
      child: GestureDetector(
        onTap: () => onPrioritySelected(label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 7),
          decoration: BoxDecoration(
            color: isSelected ? Colors.deepPurple : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? Colors.deepPurple : Colors.grey,
              width: 1,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}