import 'package:flutter/material.dart';
import 'package:sharing_map/utils/colors.dart';

class SaveAddressForm extends StatelessWidget {
  const SaveAddressForm({
    super.key,
    required this.nameController,
    required this.descriptionController,
    required this.saveForFuture,
    required this.onSaveForFutureChanged,
  });

  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final bool saveForFuture;
  final ValueChanged<bool> onSaveForFutureChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // "Сохранить для будущих объявлений" checkbox (mockups 4 & 5)
        Row(
          children: [
            GestureDetector(
              onTap: () => onSaveForFutureChanged(!saveForFuture),
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: saveForFuture
                      ? MColors.secondaryGreen
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color:
                        saveForFuture ? MColors.secondaryGreen : MColors.grey,
                    width: 2,
                  ),
                ),
                child: saveForFuture
                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                    : null,
              ),
            ),
            const SizedBox(width: 10),
            const Text('Сохранить для будущих объявлений'),
          ],
        ),
        if (saveForFuture) ...[
          const SizedBox(height: 16),
          const Text('Название адреса',
              style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          _Field(controller: nameController, hint: 'Дом'),
        ],
        const SizedBox(height: 16),

        // 👇 DESCRIPTION instead of "квартира".
        // Visible to everyone on the listing.
        const Text('Описание (видно всем на объявлении)',
            style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        _Field(
          controller: descriptionController,
          hint: 'Не указывайте точный адрес',
          maxLines: 2,
        ),
      ],
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.hint,
    this.maxLines = 1,
  });
  final TextEditingController controller;
  final String hint;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: MColors.grey.withValues(alpha: 0.5)),
        ),
      ),
    );
  }
}
