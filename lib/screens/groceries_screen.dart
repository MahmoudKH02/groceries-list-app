import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:http/http.dart' as http;
import 'package:shopping_list/data/categories.dart';

import 'package:shopping_list/screens/add_item_screen.dart';
import 'package:shopping_list/widgets/groceries_list.dart';
import 'package:shopping_list/models/grocery_item.dart';

class GroceriesScreen extends StatefulWidget {
  const GroceriesScreen({super.key});

  @override
  State<GroceriesScreen> createState() => _GroceriesScreenState();
}

class _GroceriesScreenState extends State<GroceriesScreen> {
  List<GroceryItem> _groceriesList = [];
  var _isLoading = true;
  String? _error;

  final databaseUri = dotenv.env['FIREBASE_DATABASE_URI']!;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    final uri = Uri.https(databaseUri, 'shopping-list.json');

    final response = await http.get(uri);

    if (response.statusCode >= 400) {
      setState(() {
        _error = 'Something went wrong, Please try again later';
      });
    }

    if (response.body == 'null') {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final Map<String, dynamic> data = json.decode(response.body);
    final List<GroceryItem> newList = [];

    for (final dataEntry in data.entries) {
      final category = categories.entries
          .firstWhere(
            (element) =>
                element.value.title.toLowerCase() ==
                dataEntry.value['category'].toString().toLowerCase(),
          )
          .value;
      newList.add(
        GroceryItem(
          id: dataEntry.key,
          name: dataEntry.value['name'],
          quantity: dataEntry.value['quantity'],
          category: category,
        ),
      );
    }
    setState(() {
      _groceriesList = newList;
      _isLoading = false;
    });
  }

  void _addNewItem(BuildContext context) async {
    final addedItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (context) => const AddItemScreen(),
      ),
    );
    if (addedItem != null) {
      setState(() {
        _groceriesList.add(addedItem);
      });
    }
  }

  void _removeItem(int index) {
    final itemToDelete = _groceriesList[index];

    final uri = Uri.https(databaseUri, 'shopping-list/${itemToDelete.id}.json');

    setState(() {
      _groceriesList.removeAt(index);
    });

    http.delete(uri).then(
      (value) {
        if (value.statusCode >= 400) {
          setState(() {
            _groceriesList.insert(index, itemToDelete);
          });
        }
      },
    );
  }

  void _undoRemove(int index, GroceryItem item) {
    // setState(() {
    //   _groceriesList.insert(index, item);
    // });
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (_isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    } else if (_groceriesList.isEmpty) {
      content = Center(
        child: Text(
          'No Items to Display',
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
      );
    } else {
      content = GroceriesList(
        _groceriesList,
        onRemoveItem: _removeItem,
        onUndoRemove: _undoRemove,
      );
    }

    if (_error != null) {
      content = Center(
        child: Text(
          _error!,
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addNewItem(context);
        },
        child: const Icon(Icons.add),
      ),
      // body: content,
      body: content,
    );
  }
}
