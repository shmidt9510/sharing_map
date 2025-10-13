import 'package:flutter/material.dart';
import 'package:sharing_map/models/address.dart';
import 'package:sharing_map/utils/colors.dart';

class AddressCard extends StatelessWidget {
  final Address address;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const AddressCard({
    required this.address,
    required this.isSelected,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected
                ? MColors.secondaryGreen.withOpacity(0.1)
                : Colors.white,
            border: Border.all(
              color: isSelected
                  ? MColors.secondaryGreen
                  : MColors.grey.withOpacity(0.3),
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              if (address.description != null) ...[
                const SizedBox(height: 4),
                _buildDescription(),
              ],
              const Spacer(),
              _buildLocationCount(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.home,
          color: isSelected ? MColors.primaryGreen : MColors.grey,
          size: 20,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            address.name,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isSelected ? MColors.primaryGreen : Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        GestureDetector(
          onTap: onDelete,
          child: Icon(
            Icons.close,
            size: 18,
            color: MColors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Text(
      address.description!,
      style: TextStyle(
        fontSize: 12,
        color: MColors.grey,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildLocationCount() {
    return Text(
      '${address.locations.length} локаций',
      style: TextStyle(
        fontSize: 12,
        color: isSelected ? MColors.primaryGreen : MColors.grey,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
