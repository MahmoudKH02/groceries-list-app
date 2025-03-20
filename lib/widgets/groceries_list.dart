import 'package:flutter/material.dart';
import 'package:shopping_list/models/grocery_item.dart';

class GroceriesList extends StatelessWidget {
  const GroceriesList(
    this.groceries, {
    super.key,
    required this.onRemoveItem,
    required this.onUndoRemove,
  });

  final List<GroceryItem> groceries;
  final void Function(int) onRemoveItem; // lifting state up.
  final void Function(int, GroceryItem) onUndoRemove;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: groceries.length,
      itemBuilder: (context, index) => Dismissible(
        key: ValueKey(groceries[index].id),
        onDismissed: (direction) {
          final itemToBeRemoved = groceries[index];
      
          onRemoveItem(index);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Item Removed From List'),
              duration: const Duration(seconds: 3),
              action: SnackBarAction(
                label: 'Undo',
                onPressed: () {
                  onUndoRemove(index, itemToBeRemoved);
                },
              ),
            ),
          );
        },
        background: ColoredBox(color: Theme.of(context).colorScheme.error),
        child: ListTile(
          title: Text(
              '${groceries[index].name[0].toUpperCase()}${groceries[index].name.substring(1)}'),
          leading: SizedBox(
            height: 24,
            width: 24,
            child: ColoredBox(color: groceries[index].category.color),
          ),
          trailing: Text(groceries[index].quantity.toString()),
        ),
      ),
    );
  }
}
