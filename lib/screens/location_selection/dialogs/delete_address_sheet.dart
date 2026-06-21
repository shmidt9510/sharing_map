import 'package:flutter/material.dart';
import 'package:sharing_map/models/address.dart';
import 'package:sharing_map/models/location.dart';
import 'package:sharing_map/utils/colors.dart';

Future<bool?> showDeleteAddressSheet(
  BuildContext context, {
  required Address address,
  required List<SMLocation> locations,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.red.withValues(alpha: 0.12),
              child: const Icon(Icons.delete_outline, color: Colors.red),
            ),
            const SizedBox(height: 16),
            const Text('Удалить локацию?',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(
              'Эта локация будет удалена из вашего профиля.',
              textAlign: TextAlign.center,
              style: TextStyle(color: MColors.grey),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 220,
              child: ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.withValues(alpha: 0.15),
                  foregroundColor: Colors.red,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Удалить',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Отмена',
                  style: TextStyle(
                      color: Colors.black87, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    ),
  );
}
