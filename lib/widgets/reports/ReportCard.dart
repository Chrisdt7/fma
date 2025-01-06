import 'package:flutter/material.dart';

class ReportCard extends StatelessWidget {
  final String title;
  final String value;
  final Color valueColor;

  const ReportCard(
      {Key? key,
      required this.title,
      required this.value,
      this.valueColor = Colors.black})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: valueColor),
            ),
          ],
        ),
      ),
    );
  }
}
