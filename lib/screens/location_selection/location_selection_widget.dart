// location_selection_widget.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sharing_map/models/address.dart';
import 'package:sharing_map/models/location.dart';
import 'package:sharing_map/screens/location_selection/dialogs/metro_picker_view.dart';
import 'package:sharing_map/utils/colors.dart';
import 'package:sharing_map/utils/texts.dart';

import 'controllers/location_selection_controller.dart';
import 'dialogs/delete_address_sheet.dart';
import 'widgets/add_location_button.dart';
import 'widgets/empty_locations_view.dart';
import 'widgets/saved_address_tile.dart';

class LocationSelectionWidget extends StatefulWidget {
  const LocationSelectionWidget({
    super.key,
    required this.subcategoryId,
    required this.chosenLocations,
    required this.addresses,
    required this.onLocationsChanged,
    required this.onAddressCreated,
  });

  final int subcategoryId;
  final List<SMLocation> chosenLocations;
  final List<Address> addresses;
  final void Function(List<SMLocation>, Address?) onLocationsChanged;
  final VoidCallback onAddressCreated;

  @override
  State<LocationSelectionWidget> createState() =>
      _LocationSelectionWidgetState();
}

class _LocationSelectionWidgetState extends State<LocationSelectionWidget> {
  late final String _tag = 'location_${widget.subcategoryId}';
  late final LocationSelectionController _c;

  @override
  void initState() {
    super.initState();
    _c = Get.put(
      LocationSelectionController(
        subcategoryId: widget.subcategoryId,
        initialLocations: widget.chosenLocations,
        initialAddresses: widget.addresses,
      ),
      tag: _tag,
    );
  }

  @override
  void dispose() {
    Get.delete<LocationSelectionController>(tag: _tag); // ← no leak
    super.dispose();
  }

  void _emit() => widget.onLocationsChanged(
        _c.chosenLocations.toList(),
        _c.selectedAddress.value,
      );
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          _Header(subcategoryId: widget.subcategoryId),
          const SizedBox(height: 24),
          Expanded(child: _buildBody(context)),
          AddLocationButton(onPressed: () => _openAddFlow(context)),
          const SizedBox(height: 94),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Obx(() {
      if (_c.addresses.isEmpty) return const EmptyLocationsView();
      return ListView.separated(
        itemCount: _c.addresses.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (_, i) {
          final address = _c.addresses[i];
          return SavedAddressTile(
            address: address,
            locations: _c.locationsOf(address),
            isSelected: _c.isSelected(address),
            onToggle: () {
              _c.toggleAddress(address);
              _emit();
            },
            onEdit: () => _openEditFlow(context, address),
            onDelete: () => _confirmDelete(context, address),
          );
        },
      );
    });
  }

  Future<void> _openAddFlow(BuildContext context) async {
    final created = await Navigator.of(context).push<Address?>(
      MaterialPageRoute(
        builder: (_) => MetroPickerView(controller: _c),
      ),
    );
    if (!mounted) return;

    if (created != null) {
      _c.onAddressCreated(created);
      widget.onAddressCreated();
      _emit();
    }
  }

  Future<void> _confirmDelete(BuildContext context, Address address) async {
    final confirmed = await showDeleteAddressSheet(
      context,
      address: address,
      locations: _c.locationsOf(address),
    );
    if (confirmed != true) return;
    try {
      await _c.deleteAddress(address);
      _emit();
      _snack(context, 'Локация удалена', MColors.primaryGreen);
    } catch (_) {
      _snack(context, 'Не получилось ☹️', Colors.red);
    }
  }

  void _snack(BuildContext context, String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: color),
    );
  }

  Future<void> _openEditFlow(BuildContext context, Address address) async {
    final edited = await Navigator.of(context).push<Address?>(
      MaterialPageRoute(
        builder: (_) => MetroPickerView(
          controller: _c,
          initialAddress: address,
        ),
      ),
    );
    if (!mounted) return;
    if (edited == null) return;

    _c.replaceAddress(edited);
    _emit();
    _snack(context, 'Локация обновлена', MColors.primaryGreen);
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.subcategoryId});
  final int subcategoryId;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          hintForLocation[subcategoryId - 1],
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        // Text(
        //   'Можно добавить до трёх локаций',
        //   textAlign: TextAlign.center,
        //   style: TextStyle(color: MColors.grey),
        // ),
      ],
    );
  }
}
