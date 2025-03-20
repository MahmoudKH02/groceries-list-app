import 'package:flutter/material.dart';
import 'package:shopping_list/widgets/new_item.dart';

class AddItemScreen extends StatelessWidget {
  const AddItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Item'),
      ),
      body: const NewItem(),
    );
  }
}