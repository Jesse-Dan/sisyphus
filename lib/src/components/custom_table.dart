import 'package:flutter/material.dart';

/// A reusable table widget for displaying data in a tabular format.
///
/// The [CustomTable] widget accepts a list of columns and rows,
/// with optional customization for styling and interactivity.
class CustomTable extends StatelessWidget {
  final List<String> columns;
  final List<List<String>> rows;
  final TextStyle? headerStyle;
  final TextStyle? cellStyle;
  final Color? firstCellColor;

  final BorderRadius? borderRadius;

  const CustomTable({
    Key? key,
    required this.columns,
    required this.rows,
    this.headerStyle,
    this.cellStyle,
    this.borderRadius,
    this.firstCellColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [..._buildColumns()],
      ),
    );
  }

  List<Widget> _buildColumns() {
    return columns
        .map((column) => Text(
              column,
              style: headerStyle ??
                  const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
            ))
        .toList();
  }

  List<DataRow> _buildRows() {
    return rows
        .map((row) => DataRow(
              cells: row
                  .map((cell) => DataCell(
                        Text(
                          cell,
                          style: cellStyle ??
                              TextStyle(
                                  fontSize: 14,
                                  color: row == rows.firstOrNull
                                      ? (firstCellColor ?? Colors.amber)
                                      : Colors.white),
                        ),
                      ))
                  .toList(),
            ))
        .toList();
  }
}
