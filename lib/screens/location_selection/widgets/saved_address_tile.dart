import 'package:flutter/material.dart';
import 'package:sharing_map/models/address.dart';
import 'package:sharing_map/models/location.dart';
import 'package:sharing_map/utils/colors.dart';

class SavedAddressTile extends StatelessWidget {
  const SavedAddressTile({
    super.key,
    required this.address,
    required this.locations,
    required this.isSelected,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  final Address address;
  final List<SMLocation> locations;
  final bool isSelected;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    // The mockup shows the address NAME as the section title, the
    // description / location as a chip.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          address.name,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            _Checkbox(value: isSelected, onTap: onToggle),
            const SizedBox(width: 8),
            Expanded(
                child: _LocationChip(address: address, locations: locations)),
            IconButton(
              icon: Icon(Icons.edit_outlined, color: MColors.grey),
              onPressed: onEdit,
            ),
            IconButton(
              icon: Icon(Icons.delete_outline, color: MColors.grey),
              onPressed: onDelete,
            ),
          ],
        ),
      ],
    );
  }
}

class _Checkbox extends StatelessWidget {
  const _Checkbox({required this.value, required this.onTap});
  final bool value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          color: value ? MColors.primaryGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: value ? MColors.primaryGreen : MColors.grey,
            width: 2,
          ),
        ),
        child: value
            ? const Icon(Icons.check, size: 18, color: Colors.white)
            : null,
      ),
    );
  }
}

class _LocationChip extends StatelessWidget {
  const _LocationChip({required this.address, required this.locations});
  final Address address;
  final List<SMLocation> locations;

  @override
  Widget build(BuildContext context) {
    // Prefer the user-facing description if present, else first location.
    final label = address.description?.isNotEmpty == true
        ? address.description!
        : (locations.isNotEmpty ? locations.first.name : '');

    final icon = locations.isNotEmpty
        ? locations.first.getLocationIcon
        : const Icon(Icons.location_on, size: 16);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: MColors.secondaryGreen.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // SizedBox(width: 18, height: 18, child: Center(child: icon)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(label, overflow: TextOverflow.ellipsis, maxLines: 3),
          ),
        ],
      ),
    );
  }
}
