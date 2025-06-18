import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/app_constants.dart';

class SelectionInfoBar extends StatelessWidget {
  final DateTime? date;
  final String? time;
  final int? guestCount;
  final int? tableNumber;
  final bool showTableIcon;

  const SelectionInfoBar({
    Key? key,
    this.date,
    this.time,
    this.guestCount,
    this.tableNumber,
    this.showTableIcon = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: AppConstants.infoBarDecoration,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _buildInfoItems(),
      ),
    );
  }

  List<Widget> _buildInfoItems() {
    final List<Widget> items = [];

    void addItem(Widget widget) {
      if (items.isNotEmpty) items.add(AppConstants.buildDot());
      items.add(widget);
    }

    if (date != null) {
      addItem(
        Text(
          DateFormat('EEE dd MMM', 'es').format(date!).toLowerCase(),
          style: AppConstants.whiteText,
        ),
      );
    } else {
      addItem(
        AppConstants.buildInfoItemWithIcon(Icons.calendar_today, 'Fecha'),
      );
    }

    if (time != null) {
      addItem(Text(time!, style: AppConstants.whiteText));
    } else {
      addItem(AppConstants.buildInfoItemWithIcon(Icons.access_time, 'Hora'));
    }

    if (guestCount != null) {
      addItem(
        Text(
          '$guestCount ${guestCount == 1 ? 'persona' : 'personas'}',
          style: AppConstants.whiteText,
        ),
      );
    } else {
      addItem(AppConstants.buildInfoItemWithIcon(Icons.person, 'Personas'));
    }

    if (showTableIcon) {
      if (tableNumber != null) {
        addItem(
          Row(
            children: [
              const Icon(Icons.table_restaurant, color: Colors.teal, size: 20),
              const SizedBox(width: 4),
              Text('$tableNumber', style: AppConstants.whiteText),
            ],
          ),
        );
      } else {
        addItem(
          AppConstants.buildInfoItemWithIcon(Icons.table_restaurant, 'Mesa'),
        );
      }
    }

    return items;
  }
}
