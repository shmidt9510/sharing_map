// import 'package:flutter/material.dart';
// import 'dart:developer' as developer;

// import 'package:sharing_map/services/address_dto.dart';
// import 'package:sharing_map/services/address_service.dart';

// class AddressTestPage extends StatefulWidget {
//   const AddressTestPage({Key? key}) : super(key: key);

//   @override
//   State<AddressTestPage> createState() => _AddressTestPageState();
// }

// class _AddressTestPageState extends State<AddressTestPage> {
//   List<AddressResponseDto> addresses = [];
//   bool isLoading = false;
//   String? errorMessage;

//   // Controllers for form inputs
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController descriptionController = TextEditingController();
//   final TextEditingController cityIdController = TextEditingController();
//   final TextEditingController locationIdsController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _logAction('Page initialized');
//     _loadAddresses();
//   }

//   @override
//   void dispose() {
//     nameController.dispose();
//     descriptionController.dispose();
//     cityIdController.dispose();
//     locationIdsController.dispose();
//     _logAction('Page disposed');
//     super.dispose();
//   }

//   void _logAction(String action, [Object? details]) {
//     final timestamp = DateTime.now().toIso8601String();
//     developer.log(
//       '[$timestamp] $action${details != null ? ': $details' : ''}',
//       name: 'AddressTestPage',
//     );
//     print('🏠 AddressTestPage - $action${details != null ? ': $details' : ''}');
//   }

//   void _showSnackBar(String message, {Color? backgroundColor}) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: backgroundColor ?? Colors.blue,
//         duration: const Duration(seconds: 3),
//       ),
//     );
//   }

//   Future<void> _loadAddresses() async {
//     _logAction('Loading addresses started');
//     setState(() {
//       isLoading = true;
//       errorMessage = null;
//     });

//     try {
//       List<AddressResponseDto> loadedAddresses =
//           await AddressService.getAllAddresses();

//       setState(() {
//         addresses = loadedAddresses;
//         isLoading = false;
//       });

//       _logAction('Addresses loaded successfully', 'Count: ${addresses.length}');
//       _showSnackBar('✅ Loaded ${addresses.length} addresses',
//           backgroundColor: Colors.green);

//       // Log each address
//       for (int i = 0; i < addresses.length; i++) {
//         _logAction('Address $i', {
//           'id': addresses[i].id,
//           'name': addresses[i].name,
//           // 'city': addresses[i].city.name,
//           'locations_count': addresses[i].locations.length,
//         });
//       }
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//         errorMessage = e.toString();
//       });

//       _logAction('Failed to load addresses', 'Error: $e');
//       _showSnackBar('❌ Failed to load addresses: $e',
//           backgroundColor: Colors.red);
//     }
//   }

//   Future<void> _createAddress() async {
//     if (nameController.text.trim().isEmpty ||
//         cityIdController.text.trim().isEmpty) {
//       _logAction('Create address validation failed', 'Missing required fields');
//       _showSnackBar('❌ Name and City ID are required',
//           backgroundColor: Colors.orange);
//       return;
//     }

//     _logAction('Creating address started', {
//       'name': nameController.text,
//       'description': descriptionController.text,
//       'cityId': cityIdController.text,
//       'locationIds': locationIdsController.text,
//     });

//     try {
//       List<String> locationIds = locationIdsController.text
//           .split(',')
//           .map((e) => e.trim())
//           .where((e) => e.isNotEmpty)
//           .toList();

//       CreateAddressDto createDto = CreateAddressDto(
//         name: nameController.text.trim(),
//         description: descriptionController.text.trim().isEmpty
//             ? null
//             : descriptionController.text.trim(),
//         cityId: cityIdController.text.trim(),
//         locationIds: locationIds,
//       );

//       _logAction('Sending create request', createDto.toJson());

//       AddressResponseDto createdAddress =
//           await AddressService.addAddress(createDto);

//       _logAction('Address created successfully', {
//         'id': createdAddress.id,
//         'name': createdAddress.name,
//       });

//       _showSnackBar('✅ Address "${createdAddress.name}" created successfully!',
//           backgroundColor: Colors.green);

//       // Clear form
//       nameController.clear();
//       descriptionController.clear();
//       cityIdController.clear();
//       locationIdsController.clear();

//       // Reload addresses
//       await _loadAddresses();
//     } catch (e) {
//       _logAction('Failed to create address', 'Error: $e');
//       _showSnackBar('❌ Failed to create address: $e',
//           backgroundColor: Colors.red);
//     }
//   }

//   Future<void> _deleteAddress(String addressId, String addressName) async {
//     _logAction('Deleting address started', {
//       'id': addressId,
//       'name': addressName,
//     });

//     try {
//       await AddressService.deleteAddress(addressId);

//       _logAction('Address deleted successfully', {
//         'id': addressId,
//         'name': addressName,
//       });

//       _showSnackBar('✅ Address "$addressName" deleted successfully!',
//           backgroundColor: Colors.green);

//       // Reload addresses
//       await _loadAddresses();
//     } catch (e) {
//       _logAction('Failed to delete address', {
//         'id': addressId,
//         'error': e.toString(),
//       });
//       _showSnackBar('❌ Failed to delete address: $e',
//           backgroundColor: Colors.red);
//     }
//   }

//   Future<void> _updateAddress(String addressId, String currentName) async {
//     _logAction('Update address dialog opened', {'id': addressId});

//     String? newName = await showDialog<String>(
//       context: context,
//       builder: (context) => _UpdateAddressDialog(currentName: currentName),
//     );

//     if (newName == null || newName.trim().isEmpty) {
//       _logAction('Update address cancelled or empty name');
//       return;
//     }

//     _logAction('Updating address started', {
//       'id': addressId,
//       'oldName': currentName,
//       'newName': newName,
//     });

//     try {
//       UpdateAddressDto updateDto = UpdateAddressDto(name: newName.trim());

//       _logAction('Sending update request', updateDto.toJson());

//       AddressResponseDto updatedAddress =
//           await AddressService.updateAddress(addressId, updateDto);

//       _logAction('Address updated successfully', {
//         'id': updatedAddress.id,
//         'name': updatedAddress.name,
//       });

//       _showSnackBar('✅ Address updated to "${updatedAddress.name}"!',
//           backgroundColor: Colors.green);

//       // Reload addresses
//       await _loadAddresses();
//     } catch (e) {
//       _logAction('Failed to update address', {
//         'id': addressId,
//         'error': e.toString(),
//       });
//       _showSnackBar('❌ Failed to update address: $e',
//           backgroundColor: Colors.red);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     _logAction('Building UI',
//         'Addresses count: ${addresses.length}, Loading: $isLoading');

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Address Test Page'),
//         backgroundColor: Colors.blue,
//         foregroundColor: Colors.white,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: () {
//               _logAction('Refresh button pressed');
//               _loadAddresses();
//             },
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Create Address Form
//             _buildCreateAddressForm(),

//             const SizedBox(height: 20),
//             const Divider(),
//             const SizedBox(height: 20),

//             // Addresses List
//             Text(
//               'Addresses (${addresses.length})',
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),

//             // Loading/Error/Content
//             Expanded(
//               child: _buildAddressList(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildCreateAddressForm() {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Create New Address',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: nameController,
//               decoration: const InputDecoration(
//                 labelText: 'Name *',
//                 hintText: 'Enter address name',
//                 border: OutlineInputBorder(),
//               ),
//               onChanged: (value) => _logAction('Name field changed', value),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: descriptionController,
//               decoration: const InputDecoration(
//                 labelText: 'Description',
//                 hintText: 'Enter description (optional)',
//                 border: OutlineInputBorder(),
//               ),
//               onChanged: (value) =>
//                   _logAction('Description field changed', value),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: cityIdController,
//               decoration: const InputDecoration(
//                 labelText: 'City ID *',
//                 hintText: 'Enter city UUID',
//                 border: OutlineInputBorder(),
//               ),
//               onChanged: (value) => _logAction('City ID field changed', value),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: locationIdsController,
//               decoration: const InputDecoration(
//                 labelText: 'Location IDs',
//                 hintText: 'Enter location UUIDs (comma separated)',
//                 border: OutlineInputBorder(),
//               ),
//               onChanged: (value) =>
//                   _logAction('Location IDs field changed', value),
//             ),
//             const SizedBox(height: 15),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: _createAddress,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green,
//                   foregroundColor: Colors.white,
//                 ),
//                 child: const Text('Create Address'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildAddressList() {
//     if (isLoading) {
//       _logAction('Showing loading indicator');
//       return const Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CircularProgressIndicator(),
//             SizedBox(height: 16),
//             Text('Loading addresses...'),
//           ],
//         ),
//       );
//     }

//     if (errorMessage != null) {
//       _logAction('Showing error message', errorMessage);
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.error, color: Colors.red, size: 64),
//             const SizedBox(height: 16),
//             Text(
//               'Error: $errorMessage',
//               style: const TextStyle(color: Colors.red),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {
//                 _logAction('Retry button pressed');
//                 _loadAddresses();
//               },
//               child: const Text('Retry'),
//             ),
//           ],
//         ),
//       );
//     }

//     if (addresses.isEmpty) {
//       _logAction('Showing empty state');
//       return const Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.home_outlined, size: 64, color: Colors.grey),
//             SizedBox(height: 16),
//             Text(
//               'No addresses found',
//               style: TextStyle(fontSize: 18, color: Colors.grey),
//             ),
//             SizedBox(height: 8),
//             Text(
//               'Create your first address above',
//               style: TextStyle(color: Colors.grey),
//             ),
//           ],
//         ),
//       );
//     }

//     _logAction('Showing addresses list', 'Count: ${addresses.length}');
//     return ListView.builder(
//       itemCount: addresses.length,
//       itemBuilder: (context, index) {
//         final address = addresses[index];
//         return Card(
//           margin: const EdgeInsets.only(bottom: 8),
//           child: ListTile(
//             leading: const CircleAvatar(
//               child: Icon(Icons.home),
//             ),
//             title: Text(
//               address.name,
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//             subtitle: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 if (address.description != null) Text(address.description!),
//                 // Text('City: ${address.city.name}'),
//                 Text('Locations: ${address.locations.length}'),
//                 Text('ID: ${address.id}'),
//               ],
//             ),
//             trailing: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 IconButton(
//                   icon: const Icon(Icons.edit, color: Colors.blue),
//                   onPressed: () {
//                     _logAction('Edit button pressed',
//                         {'id': address.id, 'name': address.name});
//                     _updateAddress(address.id, address.name);
//                   },
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.delete, color: Colors.red),
//                   onPressed: () {
//                     _logAction('Delete button pressed',
//                         {'id': address.id, 'name': address.name});
//                     _showDeleteConfirmDialog(address.id, address.name);
//                   },
//                 ),
//               ],
//             ),
//             onTap: () {
//               _logAction('Address tapped', {
//                 'id': address.id,
//                 'name': address.name,
//                 'details': address.toJson(),
//               });
//             },
//           ),
//         );
//       },
//     );
//   }

//   void _showDeleteConfirmDialog(String addressId, String addressName) {
//     _logAction('Delete confirmation dialog opened',
//         {'id': addressId, 'name': addressName});

//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Delete Address'),
//         content: Text('Are you sure you want to delete "$addressName"?'),
//         actions: [
//           TextButton(
//             onPressed: () {
//               _logAction('Delete cancelled');
//               Navigator.of(context).pop();
//             },
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               _logAction('Delete confirmed');
//               Navigator.of(context).pop();
//               _deleteAddress(addressId, addressName);
//             },
//             style: TextButton.styleFrom(foregroundColor: Colors.red),
//             child: const Text('Delete'),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _UpdateAddressDialog extends StatefulWidget {
//   final String currentName;

//   const _UpdateAddressDialog({required this.currentName});

//   @override
//   State<_UpdateAddressDialog> createState() => _UpdateAddressDialogState();
// }

// class _UpdateAddressDialogState extends State<_UpdateAddressDialog> {
//   late TextEditingController controller;

//   @override
//   void initState() {
//     super.initState();
//     controller = TextEditingController(text: widget.currentName);
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text('Update Address Name'),
//       content: TextField(
//         controller: controller,
//         decoration: const InputDecoration(
//           labelText: 'Address Name',
//           border: OutlineInputBorder(),
//         ),
//         autofocus: true,
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.of(context).pop(),
//           child: const Text('Cancel'),
//         ),
//         TextButton(
//           onPressed: () => Navigator.of(context).pop(controller.text),
//           child: const Text('Update'),
//         ),
//       ],
//     );
//   }
// }
