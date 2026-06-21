import 'package:flutter/material.dart';
import 'package:sharing_map/utils/colors.dart';

class AddLocationButton extends StatelessWidget {
  const AddLocationButton({super.key, required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Align(
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.add, size: 22),
        label: const Text('Добавить локацию'),
        style: ElevatedButton.styleFrom(
          backgroundColor: MColors.primaryGreen,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}
