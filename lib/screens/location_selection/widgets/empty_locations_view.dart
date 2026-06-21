import 'package:flutter/material.dart';
import 'package:sharing_map/utils/colors.dart';

class EmptyLocationsView extends StatelessWidget {
  const EmptyLocationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Пока нет добавленных локаций',
        style: TextStyle(color: MColors.grey, fontSize: 15),
      ),
    );
  }
}
