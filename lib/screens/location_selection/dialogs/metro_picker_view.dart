import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sharing_map/controllers/common_controller.dart';
import 'package:sharing_map/models/address.dart';
import 'package:sharing_map/models/location.dart';
import 'package:sharing_map/utils/colors.dart';

import '../controllers/location_selection_controller.dart';
import 'save_address_flow.dart';

class MetroPickerView extends StatefulWidget {
  const MetroPickerView({
    super.key,
    required this.controller,
    this.initialAddress, // ← null = create, non-null = edit
  });

  final LocationSelectionController controller;
  final Address? initialAddress;

  @override
  State<MetroPickerView> createState() => _MetroPickerViewState();
}

class _MetroPickerViewState extends State<MetroPickerView> {
  final _searchController = TextEditingController();
  final _selected = <SMLocation>[];
  String _query = '';

  CommonController get _common => Get.find<CommonController>();

  bool get _isEdit => widget.initialAddress != null;

  @override
  void initState() {
    super.initState();
    // Pre-select locations when editing.
    final initial = widget.initialAddress;
    if (initial != null) {
      _selected.addAll(widget.controller.locationsOf(initial));
    }
  }

  List<SMLocation> get _filtered {
    if (_query.isEmpty) return _common.locations;
    final q = _query.toLowerCase();
    return _common.locations
        .where((l) => l.name.toLowerCase().contains(q))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggle(SMLocation location) {
    setState(() {
      final existing = _selected.indexWhere((l) => l.id == location.id);
      if (existing >= 0) {
        _selected.removeAt(existing);
      } else {
        if (_selected.length >= 3) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Можно выбрать не больше трёх')),
          );
          return;
        }
        _selected.add(location);
      }
    });
  }

  bool _isChecked(SMLocation l) => _selected.any((s) => s.id == l.id);

  Future<void> _continue() async {
    if (_selected.isEmpty) return;

    final result = await Navigator.of(context).push<Address?>(
      MaterialPageRoute(
        builder: (_) => SaveAddressFlow(
          selectedLocations: List.of(_selected),
          initialAddress: widget.initialAddress, // ← pass through for edit
        ),
      ),
    );

    // Bubble the result up to whoever opened the metro picker.
    if (result != null && mounted) {
      Navigator.of(context).pop(result);
    }
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const SizedBox(height: 16),
            _Dropdown(
              text: _selected.isEmpty
                  ? 'Выберите локацию'
                  : _selected.map((e) => e.name).join(', '),
            ),
            const SizedBox(height: 12),
            _SearchField(
              controller: _searchController,
              onChanged: (v) => setState(() => _query = v),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                itemCount: _filtered.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, i) {
                  final location = _filtered[i];
                  return _StationTile(
                    location: location,
                    checked: _isChecked(location),
                    onTap: () => _toggle(location),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _selected.isEmpty
          ? null
          : FloatingActionButton.extended(
              backgroundColor: MColors.secondaryGreen,
              foregroundColor: Colors.white,
              onPressed: _continue,
              label: Text('Продолжить (${_selected.length})'),
            ),
    );
  }
}

// ── Small private pieces ──────────────────────────────────────────────

class _KindChip extends StatelessWidget {
  const _KindChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: MColors.secondaryGreen.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(label,
              style: TextStyle(color: MColors.primaryGreen, fontSize: 13)),
        ),
      ),
    );
  }
}

class _Dropdown extends StatelessWidget {
  const _Dropdown({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: MColors.grey.withValues(alpha: 0.4)),
        ),
        child:
            // children: [
            Expanded(
          child: Text(text, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
        // const Icon(Icons.keyboard_arrow_down),
        // ],
        // ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller, required this.onChanged});
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}

class _StationTile extends StatelessWidget {
  const _StationTile({
    required this.location,
    required this.checked,
    required this.onTap,
  });
  final SMLocation location;
  final bool checked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: Text(location.name,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600)),
            ),
            SizedBox(
                width: 20,
                height: 20,
                child: Center(child: location.getLocationIcon)),
            const SizedBox(width: 16),
            _Box(checked: checked),
          ],
        ),
      ),
    );
  }
}

class _Box extends StatelessWidget {
  const _Box({required this.checked});
  final bool checked;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: checked ? MColors.primaryGreen : Colors.transparent,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: checked ? MColors.primaryGreen : MColors.grey,
          width: 2,
        ),
      ),
      child: checked
          ? const Icon(Icons.check, size: 16, color: Colors.white)
          : null,
    );
  }
}
