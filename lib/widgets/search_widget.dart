import 'package:flutter/material.dart';
import 'package:sharing_map/utils/colors.dart';
import 'package:sharing_map/widgets/allWidgets.dart';

class SearchWidget extends StatefulWidget {
  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SearchAnchor(
          builder: (BuildContext context, SearchController controller) {
        return SearchBar(
          controller: controller,
          padding: const WidgetStatePropertyAll<EdgeInsets>(
              EdgeInsets.symmetric(horizontal: 16.0)),
          onSubmitted: (String? str) {
            showErrorScaffold(context, str ?? "nothing");
          },
          // onTap: () {
          //   controller.openView();
          // },
          // onChanged: (_) {
          //   controller.openView();
          // },
          leading: const Icon(
            Icons.search,
            color: MColors.primaryGreen,
          ),
          // trailing: <Widget>[
          //   Tooltip(
          //     message: 'Change brightness mode',
          //     child: IconButton(
          //       isSelected: isDark,
          //       onPressed: () {
          //         setState(() {
          //           isDark = !isDark;
          //         });
          //       },
          //       icon: const Icon(Icons.wb_sunny_outlined),
          //       selectedIcon: const Icon(Icons.brightness_2_outlined),
          //     ),
          //   )
          // ],
        );
      }, suggestionsBuilder:
              (BuildContext context, SearchController controller) {
        return List<ListTile>.generate(5, (int index) {
          final String item = 'item $index';
          return ListTile(
            title: Text(item),
            onTap: () {
              setState(() {
                controller.closeView(item);
              });
            },
          );
        });
      }),
    );
  }
}
