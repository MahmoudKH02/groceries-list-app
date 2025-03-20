# Grocery List App

The GroceryList app is a simple Flutter application designed to help users manage their shopping lists. Users can add, view, and remove grocery items, which are categorized for better organization. The app uses Firebase Realtime Database to store and retrieve the grocery list data.

## Features

- **Add New Items:** Users can add new grocery items with a name, quantity, and category.
- **View Grocery List:** Displays a list of all added grocery items with their respective categories and quantities.
- **Remove Items:** Users can swipe to delete items from the list.
- **Undo Remove:** Provides an option to undo the removal of an item.
- **Categories:** Items are categorized into different groups such as Vegetables, Fruit, Meat, Dairy, etc.
- **Dark Theme:** The app uses a dark theme for a modern and sleek look.

## Screens
- **Groceries Screen:** The main screen that displays the list of grocery items. It includes a floating action button to add new items.
- **Add Item Screen:** A form to add new grocery items with fields for name, quantity, and category.

## Widgets
- **GroceriesList:** Displays the list of grocery items using a ListView.builder. Each item can be dismissed to remove it from the list.
- **NewItem:** A form widget for adding new grocery items. It includes validation for the input fields.

## Models
- **GroceryItem:** Represents a grocery item with properties like id, name, quantity, and category.
- **Category:** Represents a category with properties like title and color.

## Data
- **categories.dart:** Contains a map of predefined categories with their respective colors.

## Firebase Integration
The app uses Firebase Realtime Database to store and retrieve grocery items. The database URL and endpoints are configured in the GroceriesScreen and NewItem widgets.

## Getting Started
### Prerequisites
- Flutter SDK installed.
- Firebase project with Realtime Database enabled.

### Installation
1. Clone the repository:
```bash
git clone https://github.com/MahmoudKH02/groceries-list-app.git
```

2. Navigate to the project directory:
```bash
cd groceries-list-app
```

3. Install dependencies:
```bash
flutter pub get
```

4. Configure Firebase:
    1. Enable Realtime Database in your Firebase project and update the database rules if necessary.
    2. Add your Firebase uri without the `https://` prefix (this would result in errors) to a `/.env` file in the root directory of this project.

5. Run the app:
```bash
flutter run
```

## Usage
1. Adding a New Item:
    - Tap the floating action button on the Groceries Screen.
    - Fill in the form with the item's name, quantity, and category.
    - Tap "Submit" to add the item to the list.

2. Removing an Item:
    - Swipe left or right on the item you want to remove.
    - A snackbar will appear with an option to undo the removal.