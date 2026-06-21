// dialogs/save_address_flow.dart
import 'package:flutter/material.dart';
import 'package:sharing_map/models/address.dart';
import 'package:sharing_map/models/location.dart';
import 'package:sharing_map/services/address_service.dart';
import 'package:sharing_map/utils/colors.dart';

import 'save_address_form.dart';

class SaveAddressFlow extends StatefulWidget {
  const SaveAddressFlow({
    super.key,
    required this.selectedLocations,
    this.initialAddress, // ← null = create, non-null = edit
  });

  final List<SMLocation> selectedLocations;
  final Address? initialAddress;

  @override
  State<SaveAddressFlow> createState() => _SaveAddressFlowState();
}

class _SaveAddressFlowState extends State<SaveAddressFlow> {
  final _addressService = AddressService();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _saveForFuture = true;
  bool _isLoading = false;

  bool get _isEdit => widget.initialAddress != null;

  @override
  void initState() {
    super.initState();
    // Pre-fill the form when editing.
    final initial = widget.initialAddress;
    if (initial != null) {
      _nameController.text = initial.name;
      _descriptionController.text = initial.description ?? '';
      _saveForFuture = true; // an existing saved address is "saved for future"
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saveForFuture && !_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final Address result;
      if (_isEdit) {
        result = await _addressService.updateAddress(
          widget.initialAddress!.id,
          _buildAddress(),
        );
      } else {
        result = await _addressService.addAddress(_buildAddress());
      }
      if (mounted) Navigator.of(context).pop(result);
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Address _buildAddress() {
    final desc = _descriptionController.text.trim();
    final initial = widget.initialAddress;
    return Address(
      // Preserve id/userId on edit; use placeholders on create (backend ignores them).
      id: initial?.id ?? 'create',
      userId: initial?.userId ?? 'create',
      name: _saveForFuture
          ? _nameController.text.trim()
          : (desc.isEmpty ? 'Локация' : desc),
      description: desc.isEmpty ? null : desc,
      cityId: widget.selectedLocations.first.cityId.toString(),
      locations: widget.selectedLocations.map((l) => l.id.toString()).toList(),
      createdAt: initial?.createdAt,
      updatedAt: initial?.updatedAt,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MColors.secondaryGreen,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text(_isEdit ? 'Изменить локацию' : 'Создать объявление'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SelectedChips(locations: widget.selectedLocations),
                const SizedBox(height: 20),
                SaveAddressForm(
                  nameController: _nameController,
                  descriptionController: _descriptionController,
                  saveForFuture: _saveForFuture,
                  onSaveForFutureChanged: (v) =>
                      setState(() => _saveForFuture = v),
                ),
                const SizedBox(height: 32),
                Center(
                  child: SizedBox(
                    width: 200,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MColors.secondaryGreen,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white),
                              ),
                            )
                          : Text(_isEdit ? 'Сохранить' : 'Сохранить',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SelectedChips extends StatelessWidget {
  const _SelectedChips({required this.locations});
  final List<SMLocation> locations;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: locations
          .map((l) => Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border:
                      Border.all(color: MColors.grey.withValues(alpha: 0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                        width: 18,
                        height: 18,
                        child: Center(child: l.getLocationIcon)),
                    const SizedBox(width: 8),
                    Text(l.name),
                  ],
                ),
              ))
          .toList(),
    );
  }
}
