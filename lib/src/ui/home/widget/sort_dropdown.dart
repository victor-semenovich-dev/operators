import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:operators/src/data/model/table.dart';

class SortDropdown extends StatelessWidget {
  final SortType selectedItem;
  final Function(SortType) onItemSelected;

  const SortDropdown({
    super.key,
    required this.selectedItem,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<SortType>(
        isExpanded: true,
        items: SortType.values
            .map(
              (item) => DropdownMenuItem<SortType>(
                value: item,
                child: Row(
                  children: [
                    if (selectedItem == item)
                      Icon(Icons.check)
                    else
                      SizedBox(width: 24),
                    SizedBox(width: 8),
                    Text(
                      switch (item) {
                        SortType.BY_NAME => 'по имени',
                        SortType.BY_RATING => 'по рейтингу',
                      },
                    ),
                  ],
                ),
              ),
            )
            .toList(),
        value: selectedItem,
        onChanged: (item) {
          if (item != null) {
            onItemSelected(item);
          }
        },
        buttonStyleData: ButtonStyleData(
          height: 48,
          width: 48,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
          ),
          // elevation: 2,
        ),
        iconStyleData: const IconStyleData(
          icon: Icon(Icons.sort, color: Colors.white),
          iconSize: 24,
        ),
        dropdownStyleData: const DropdownStyleData(
          maxHeight: 200,
          width: 200,
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
          padding: EdgeInsets.only(left: 14, right: 14),
        ),
      ),
    );
  }
}