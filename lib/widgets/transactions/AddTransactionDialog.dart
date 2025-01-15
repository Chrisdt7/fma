import 'package:flutter/material.dart';
import 'dart:async';

import 'package:fma/templates/AppLocalization.dart';

class AddTransactionDialog extends StatefulWidget {
  @override
  _AddTransactionDialogState createState() => _AddTransactionDialogState();
}

class _AddTransactionDialogState extends State<AddTransactionDialog> {
  final _formKey = GlobalKey<FormState>();
  double? _amount;
  String? _category;
  String? _type;
  DateTime _currentDateTime = DateTime.now();
  Timer? _timer;

  final List<String> categories = [
    'food',
    'transport',
    'entertainment',
    'utilities',
    'other',
  ];

  final List<String> types = ['income', 'expense'];

  @override
  void initState() {
    super.initState();
    _startClock();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startClock() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentDateTime = DateTime.now();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final localizations = AppLocalizations.of(context);

    return AlertDialog(
      surfaceTintColor: colorScheme.surface,
      title: Text(
        localizations.translate("AddTransaction-label-title"),
        textAlign: TextAlign.center,
        style: textTheme.titleLarge
            ?.copyWith(color: colorScheme.tertiary.withAlpha(255)),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(
                    labelText:
                        localizations.translate("Transactions-label-amount"),
                    icon: Icon(Icons.attach_money),
                    iconColor: colorScheme.tertiary.withAlpha(200),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: colorScheme.tertiary.withAlpha(200))),
                    labelStyle: textTheme.titleMedium
                        ?.copyWith(color: colorScheme.tertiary.withAlpha(200))),
                keyboardType: TextInputType.number,
                autofocus: true,
                maxLength: 8,
                onSaved: (value) => _amount = double.tryParse(value!),
                style: textTheme.titleSmall
                    ?.copyWith(color: colorScheme.tertiary.withAlpha(200)),
                validator: (value) => value == null || value.isEmpty
                    ? localizations.translate("snackbarRequiredAmount")
                    : null,
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  icon: Icon(Icons.category_outlined),
                  iconColor: colorScheme.tertiary.withAlpha(200),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: colorScheme.tertiary.withAlpha(200))),
                  labelText:
                      localizations.translate("Transactions-label-category"),
                  labelStyle: textTheme.titleMedium?.copyWith(
                    color: colorScheme.tertiary.withAlpha(200),
                  ),
                ),
                borderRadius: BorderRadius.circular(20),
                dropdownColor: colorScheme.surface.withAlpha(175),
                items: [
                  for (var i = 0; i < categories.length; i++)
                    DropdownMenuItem(
                      value: categories[i],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            categories[i],
                            style: textTheme.titleSmall?.copyWith(
                              color: colorScheme.tertiary.withAlpha(200),
                            ),
                          ),
                          if (i != categories.length - 0)
                            Divider(
                              color: colorScheme.tertiary.withAlpha(50),
                              thickness: 1,
                              height: 3,
                            ),
                        ],
                      ),
                    ),
                ],
                onChanged: (value) => _category = value,
                validator: (value) => value == null
                    ? localizations.translate("snackbarRequiredCategory")
                    : null,
              ),
              SizedBox(
                height: 10,
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  icon: Icon(Icons.label),
                  iconColor: colorScheme.tertiary.withAlpha(200),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: colorScheme.tertiary.withAlpha(200))),
                  labelText: localizations.translate("Transactions-label-type"),
                  labelStyle: textTheme.titleMedium?.copyWith(
                    color: colorScheme.tertiary.withAlpha(200),
                  ),
                ),
                borderRadius: BorderRadius.circular(20),
                dropdownColor: colorScheme.surface.withAlpha(175),
                items: [
                  for (var i = 0; i < types.length; i++)
                    DropdownMenuItem(
                      value: types[i],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            types[i],
                            style: textTheme.titleSmall?.copyWith(
                              color: types[i] ==
                                      localizations.translate(
                                          "Transactions-label-type-a")
                                  ? colorScheme.onSecondary
                                  : types[i] ==
                                          localizations.translate(
                                              "Transactions-label-type-b")
                                      ? colorScheme.onTertiary
                                      : colorScheme.tertiary.withAlpha(200),
                            ),
                          ),
                          if (i != types.length - 0)
                            Divider(
                              color: colorScheme.tertiary.withAlpha(50),
                              thickness: 1,
                              height: 3,
                            ),
                        ],
                      ),
                    ),
                ],
                onChanged: (value) => _type = value,
                validator: (value) => value == null
                    ? localizations.translate("snackbarRequiredType")
                    : null,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  'Date: ${_formatDateTime(_currentDateTime)}',
                  style: textTheme.titleMedium
                      ?.copyWith(color: colorScheme.tertiary.withAlpha(200)),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(localizations.translate("text-cancel"),
              style: textTheme.titleMedium
                  ?.copyWith(color: colorScheme.onTertiary)),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              Navigator.pop(context, {
                "amount": _amount,
                "category": _category,
                "type": _type,
                "date": _currentDateTime.toIso8601String(),
              });
            }
          },
          child: Text(
            localizations.translate("text-add"),
            style:
                textTheme.titleMedium?.copyWith(color: colorScheme.onPrimary),
          ),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.toLocal()}'.split('.')[0];
  }
}
