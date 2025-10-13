import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sharing_map/controllers/common_controller.dart';
import 'package:sharing_map/models/address.dart';
import 'package:sharing_map/models/location.dart';
import 'package:sharing_map/screens/items/add_new_item/address_card.dart';
import 'package:sharing_map/screens/items/add_new_item/create_address_dialog.dart';
import 'package:sharing_map/services/address_service.dart';
import 'package:sharing_map/theme.dart';
import 'package:sharing_map/utils/colors.dart';
import 'package:sharing_map/utils/texts.dart';

class LocationSelectionWidget extends StatefulWidget {
  final int subcategoryId;
  final List<SMLocation> chosenLocations;
  List<Address> addresses;
  final Function(List<SMLocation>, Address?) onLocationsChanged;
  final Function() onAddressCreated;

  LocationSelectionWidget({
    Key? key,
    required this.subcategoryId,
    required this.chosenLocations,
    required this.addresses,
    required this.onLocationsChanged,
    required this.onAddressCreated,
  }) : super(key: key);

  @override
  State<LocationSelectionWidget> createState() =>
      _LocationSelectionWidgetState();
}

class _LocationSelectionWidgetState extends State<LocationSelectionWidget> {
  final GlobalKey<DropdownSearchState> dropDownKeyLocation = GlobalKey();
  bool _isCreatingAddress = false;
  Address? _selectedAddress;

  CommonController get _commonController => Get.find<CommonController>();

  // Get locations from address by converting string IDs to SMLocation objects
  List<SMLocation> _getLocationsFromAddress(Address address) {
    List<SMLocation> addressLocations = [];

    for (String locationIdStr in address.locations) {
      try {
        int locationId = int.parse(locationIdStr);
        SMLocation? location = _commonController.locationsMap[locationId];
        if (location != null) {
          addressLocations.add(location);
        }
      } catch (e) {
        print('Error parsing location ID: $locationIdStr');
      }
    }

    return addressLocations;
  }

  // Check if current selection matches an address
  Address? _getMatchingAddress() {
    if (widget.chosenLocations.isEmpty) return null;

    for (Address address in widget.addresses) {
      List<SMLocation> addressLocations = _getLocationsFromAddress(address);

      if (addressLocations.length == widget.chosenLocations.length) {
        bool allMatch = addressLocations.every((addressLoc) => widget
            .chosenLocations
            .any((chosenLoc) => chosenLoc.id == addressLoc.id));

        if (allMatch) {
          return address;
        }
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    _selectedAddress = _getMatchingAddress();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Center(child: Text(hintForLocation[widget.subcategoryId - 1])),
        const SizedBox(height: 10),
        _buildLocationDropdown(),
        const SizedBox(height: 15),
        _buildActionSection(),
      ],
    );
  }

  Widget _buildLocationDropdown() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: DropdownSearch<SMLocation>.multiSelection(
        key: dropDownKeyLocation,
        autoValidateMode: AutovalidateMode.disabled,
        validator: _validateSelection,
        selectedItems: widget.chosenLocations,
        onChanged: _onSelectionChanged,
        popupProps: PopupPropsMultiSelection.bottomSheet(
          emptyBuilder: (context, searchEntry) => const Center(
            child: Text('Пусто', style: TextStyle(color: Colors.blue)),
          ),
          showSearchBox: true,
          searchFieldProps: const TextFieldProps(
            decoration: InputDecoration(
              hintText: 'Поиск локаций...',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          bottomSheetProps: BottomSheetProps(
            backgroundColor: MColors.white,
            constraints: BoxConstraints(maxWidth: context.width * 0.9),
          ),
          searchDelay: const Duration(milliseconds: 300),
          itemBuilder: _buildDropdownItem,
          listViewProps: ListViewProps(
            padding: const EdgeInsets.all(16),
          ),
        ),
        decoratorProps: DropDownDecoratorProps(
          baseStyle: getMediumTextStyle(),
          decoration: InputDecoration(
            labelText: widget.chosenLocations.isEmpty
                ? "Выберите до трёх локаций"
                : "",
            hintStyle: getMediumTextStyle(),
            labelStyle: getMediumTextStyle(),
            filled: false,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MColors.secondaryGreen),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        compareFn: (item1, item2) => item1.id == item2.id,
        items: (filter, loadProps) => _getFilteredItems(filter),
      ),
    );
  }

  Widget _buildActionSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          if (widget.addresses.isNotEmpty) _buildAddressSelection(),
          if (widget.chosenLocations.isNotEmpty) _buildSelectionInfo(),
          if (widget.chosenLocations.isNotEmpty && _selectedAddress == null)
            _buildSaveToAddressButton(),
        ],
      ),
    );
  }

  Widget _buildAddressSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Мои сохранённые адреса:', style: getMediumTextStyle()),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.addresses.length,
            itemBuilder: (context, index) {
              final address = widget.addresses[index];
              final isSelected = _selectedAddress?.id == address.id;

              return AddressCard(
                address: address,
                isSelected: isSelected,
                onTap: () => _selectAddress(isSelected ? null : address),
                onDelete: () => _deleteAddress(address),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        const Divider(),
        const SizedBox(height: 10),
        Text('Или выберите отдельные локации:', style: getMediumTextStyle()),
        const SizedBox(height: 10),
      ],
    );
  }

  // Future<void> _deleteAddress(Address address) async {
  //   final dialogContext = context;

  //   final confirmed = await showDialog<bool>(
  //     context: dialogContext,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Удалить адрес?'),
  //         content: Text('Вы уверены, что хотите удалить "${address.name}"?'),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.of(context).pop(false),
  //             child: const Text('Отмена'),
  //           ),
  //           TextButton(
  //             onPressed: () => Navigator.of(context).pop(true),
  //             child: const Text(
  //               'Удалить',
  //               style: TextStyle(color: Colors.red),
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );

  //   if (confirmed != true || !mounted) return;

  //   try {
  //     // Show loading indicator
  //     if (!mounted) return;
  //     showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (context) => const Center(
  //         child: CircularProgressIndicator(),
  //       ),
  //     );

  //     await AddressService.deleteAddress(address.id);

  //     // Remove loading indicator
  //     if (mounted) {
  //       Navigator.of(context).pop();

  //       setState(() {
  //         widget.addresses.remove(address);
  //         if (_selectedAddress?.id == address.id) {
  //           _selectedAddress = null;
  //         }
  //       });

  //       _showSnackBar('Адрес успешно удалён', Colors.green);
  //     }
  //   } catch (e) {
  //     // Remove loading indicator
  //     if (mounted) {
  //       Navigator.of(context).pop();
  //       _showSnackBar("Не получилось ☹️", Colors.red);
  //     }
  //   }
  // }
  Future<void> _deleteAddress(Address address) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Удалить адрес?'),
          content: Text('Вы уверены, что хотите удалить "${address.name}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                'Удалить',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    try {
      await AddressService.deleteAddress(address.id);

      if (mounted) {
        setState(() {
          widget.addresses.remove(address);
          if (_selectedAddress?.id == address.id) {
            _selectedAddress = null;
          }
        });

        _showSnackBar('Адрес успешно удалён', Colors.green);
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar("Не получилось ☹️", Colors.red);
      }
    }
  }

  void _showSnackBar(String message, Color backgroundColor) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }

  Widget _buildSelectionInfo() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _selectedAddress != null
            ? MColors.primaryGreen.withOpacity(0.1)
            : Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _selectedAddress != null
              ? MColors.primaryGreen.withOpacity(0.3)
              : Colors.blue.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _selectedAddress != null ? Icons.home : Icons.location_on,
                color: _selectedAddress != null
                    ? MColors.primaryGreen
                    : Colors.blue,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _selectedAddress != null
                      ? 'Выбран адрес: ${_selectedAddress!.name}'
                      : 'Выбрано локаций: ${widget.chosenLocations.length}',
                  style: TextStyle(
                    color: _selectedAddress != null
                        ? MColors.primaryGreen
                        : MColors.secondaryGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...widget.chosenLocations.map(
            (location) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  const SizedBox(width: 28),
                  Icon(Icons.arrow_right, size: 16, color: MColors.grey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      location.name,
                      style: TextStyle(
                        color: MColors.grey,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveToAddressButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _isCreatingAddress ? null : _showCreateAddressDialog,
        icon: _isCreatingAddress
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.bookmark_add),
        label:
            Text(_isCreatingAddress ? 'Сохранение...' : 'Сохранить как адрес'),
        style: OutlinedButton.styleFrom(
          foregroundColor: MColors.primaryGreen,
          side: BorderSide(color: MColors.primaryGreen),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildDropdownItem(
      BuildContext context, SMLocation item, bool isDisabled, bool isSelected) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected ? MColors.secondaryGreen.withOpacity(0.1) : null,
        borderRadius: BorderRadius.circular(8),
        border: isSelected ? Border.all(color: MColors.secondaryGreen) : null,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: MColors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child:
                item.getLocationIcon ?? const Icon(Icons.location_on, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              item.name,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (isSelected)
            Icon(
              Icons.check_circle,
              color: MColors.secondaryGreen,
              size: 20,
            ),
        ],
      ),
    );
  }

  List<SMLocation> _getFilteredItems(String filter) {
    if (filter.isEmpty) return _commonController.locations;

    return _commonController.locations.where((location) {
      return location.name.toLowerCase().contains(filter.toLowerCase());
    }).toList();
  }

  void _selectAddress(Address? address) {
    if (address == null) {
      // Unselect - clear locations
      setState(() {
        _selectedAddress = null;
      });
      widget.onLocationsChanged([], null);
    } else {
      // Select - set locations from address
      setState(() {
        _selectedAddress = address;
      });
      List<SMLocation> addressLocations = _getLocationsFromAddress(address);
      widget.onLocationsChanged(addressLocations, address);
    }
  }

  void _onSelectionChanged(List<SMLocation> selectedLocations) {
    widget.onLocationsChanged(selectedLocations, null);
  }

  String? _validateSelection(List<SMLocation>? value) {
    if (value == null || value.isEmpty) {
      return "Пожалуйста, выберите локации";
    }
    if (value.length > 3) {
      return "Пожалуйста, выберите не больше трёх локаций";
    }
    return null;
  }

  Future<void> _showCreateAddressDialog() async {
    final result = await showDialog<Address?>(
      context: context,
      barrierColor: Colors.black12,
      builder: (context) => CreateAddressDialog(
        selectedLocations: widget.chosenLocations,
      ),
    );

    if (result != null) {
      widget.onAddressCreated();
      setState(() {
        widget.addresses.add(result);
        _selectedAddress = result;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Адрес успешно сохранён!'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
