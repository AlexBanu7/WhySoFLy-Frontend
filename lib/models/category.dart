import 'package:frontend/models/product.dart';

class Category {
  int id;
  late String name;
  List<Product> products;
  late String icon;

  Category({required this.id, required this.name, required this.products}){
    switch (name) {
      case "Fruits":
        icon = "🍎";
        break;
      case "Vegetables":
        icon = "🥦";
        break;
      case "Meat and Seafood":
        icon = "🍖";
        break;
      case "Dairy":
        icon = "🧀";
        break;
      case "Bakery":
        icon = "🍞";
        break;
      case "Frozen Foods":
        icon = "🍦";
        break;
      case "Pantry Staples":
        icon = "🍚";
        break;
      case "Beverages":
        icon = "🥤";
        break;
      case "Snacks and Confectionery":
        icon = "🍫";
        break;
      case "Cleaning Supplies":
        icon = "🧼";
        break;
      case "Paper Products":
        icon = "🧻";
        break;
      case "Personal Care":
        icon = "🧴";
        break;
      case "Kitchen Supplies":
        icon = "🍽";
        break;
      case "Health and Wellness":
        icon = "💊";
        break;
      case "Beauty":
        icon = "💄";
        break;
      case "Baby Food and Care":
        icon = "🍼";
        break;
      case "Pet Supplies":
        icon = "🐶";
        break;
      case "Home and Garden":
        icon = "🏡";
        break;
      case "Electronics":
        icon = "📱";
        break;
      case "Toys and Games":
        icon = "🎮";
        break;
      case "Car Care":
        icon = "🚗";
        break;
      default:
        icon = "🛒";
    }
  }

}