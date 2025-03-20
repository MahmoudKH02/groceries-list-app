import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:http/http.dart' as http;

import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/category.dart';
import 'package:shopping_list/models/grocery_item.dart';

enum FieldType { title, quantitiy }

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<StatefulWidget> createState() {
    return _NewItemState();
  }
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();

  var _enteredTitle = '';
  var _enteredQuantity = 1;
  var _enteredCategory = categories[Categories.carbs]!;

  var _isSaving = false;

  String? _validateInput(String? value, FieldType type) {
    if (type == FieldType.title) {
      if (value == null || value.isEmpty || value.trim().length <= 1) {
        return 'Title Must be of Lenght Between 1 and 50.';
      }
    } else if (type == FieldType.quantitiy) {
      if (value == null ||
          value.isEmpty ||
          int.tryParse(value) == null ||
          int.tryParse(value)! < 0) {
        return 'A Positive Numeric Value Must be Entered.';
      }
    }
    return null;
  }

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isSaving = true;
      });
      final databaseUri = dotenv.env['FIREBASE_DATABASE_URI']!;

      final uri = Uri.https(databaseUri, 'shopping-list.json');

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
          {
            'name': _enteredTitle,
            'quantity': _enteredQuantity,
            'category': _enteredCategory.title,
          },
        ),
      );

      final Map<String, dynamic> resBody = json.decode(response.body);

      if (context.mounted) {
        Navigator.of(context).pop(
          GroceryItem(
            id: resBody['name'],
            name: _enteredTitle,
            quantity: _enteredQuantity,
            category: _enteredCategory,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              maxLength: 50,
              decoration: const InputDecoration(
                label: Text('Name'),
              ),
              validator: (value) => _validateInput(value, FieldType.title),
              onSaved: (newValue) {
                _enteredTitle = newValue!;
              },
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      label: Text('Quantitiy'),
                    ),
                    initialValue: '1',
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        _validateInput(value, FieldType.quantitiy),
                    onSaved: (newValue) {
                      _enteredQuantity = int.parse(newValue!);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField(
                    value: _enteredCategory,
                    items: [
                      for (final category in categories.entries)
                        DropdownMenuItem(
                          value: category.value,
                          child: Row(
                            children: [
                              SizedBox(
                                height: 24,
                                width: 24,
                                child: ColoredBox(color: category.value.color),
                              ),
                              const SizedBox(width: 8),
                              Text(category.key.name),
                            ],
                          ),
                        )
                    ],
                    onChanged: (value) {
                      setState(() {
                        _enteredCategory = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: _isSaving ? null : _saveItem,
                  child: _isSaving
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(),
                        )
                      : const Text('Submit'),
                ),
                TextButton(
                  onPressed: _isSaving
                      ? null
                      : () {
                          _formKey.currentState!.reset();
                        },
                  child: const Text('Reset'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
