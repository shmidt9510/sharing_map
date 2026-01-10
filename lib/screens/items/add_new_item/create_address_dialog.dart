import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sharing_map/controllers/common_controller.dart';
import 'package:sharing_map/models/location.dart';
import 'package:sharing_map/services/address_dto.dart';
import 'package:sharing_map/services/address_service.dart';
import 'package:sharing_map/theme.dart';
import 'package:sharing_map/utils/colors.dart';
import 'package:sharing_map/widgets/allWidgets.dart';

class CreateAddressDialog extends StatefulWidget {
  final List<SMLocation> selectedLocations;
  const CreateAddressDialog({Key? key, required this.selectedLocations})
      : super(key: key);

  @override
  State<CreateAddressDialog> createState() => _CreateAddressDialogState();
}

class _CreateAddressDialogState extends State<CreateAddressDialog> {
  final _addressService = AddressService();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;

  CommonController get _commonController => Get.find<CommonController>();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Сохранить адрес'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildNameField(),
            const SizedBox(height: 16),
            _buildDescriptionField(),
            const SizedBox(height: 16),
            _buildLocationsInfo(),
          ],
        ),
      ),
      actions: [
        Row(
          children: [
            Expanded(child: _buildCancelButton()),
            const SizedBox(width: 12),
            Expanded(child: _buildSaveButton()),
          ],
        ),
      ],
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: 'Название: видно вам',
        hintText: 'Например: Дом, Офис, Дача',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Введите название';
        }
        return null;
      },
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      decoration: const InputDecoration(
        labelText: 'Описание: видно всем на объявлении',
        hintText: 'Не пишите свой точный адрес',
        border: OutlineInputBorder(),
      ),
      maxLines: 2,
    );
  }

  Widget _buildLocationsInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Локации (${widget.selectedLocations.length}):',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          ...widget.selectedLocations.map(_buildLocationItem),
        ],
      ),
    );
  }

  Widget _buildLocationItem(SMLocation location) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          const Icon(Icons.location_on, size: 16),
          const SizedBox(width: 8),
          Expanded(child: Text(location.name)),
        ],
      ),
    );
  }

  Widget _buildCancelButton() {
    return getButton(
      context,
      'Отмена',
      _isLoading ? () {} : () => Navigator.of(context).pop(null),
      color: MColors.grey1,
      height: 45,
      textStyle: getSmallTextStyle().copyWith(
        color: Colors.black87,
      ),
    );
  }

  Widget _buildSaveButton() {
    return _isLoading
        ? _buildLoadingButton()
        : getButton(context, 'Сохранить', _saveAddress,
            color: MColors.secondaryGreen,
            height: 45,
            textStyle: getSmallTextStyle());
  }

  Widget _buildLoadingButton() {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: MColors.primaryGreen.withOpacity(0.6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      ),
    );
  }

  Future<void> _saveAddress() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final createDto = _buildCreateDto();
      var address = await _addressService.addAddress(createDto);

      if (mounted) {
        Navigator.of(context).pop(address);
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar(e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  CreateAddressDto _buildCreateDto() {
    return CreateAddressDto(
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      cityId: widget.selectedLocations.first.cityId.toString(),
      locationIds:
          widget.selectedLocations.map((loc) => loc.id.toString()).toList(),
    );
  }

  void _showErrorSnackBar(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Ошибка: $error'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
