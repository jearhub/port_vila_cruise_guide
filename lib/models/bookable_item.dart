import 'package.dart';

abstract class BookableItem {
  String get name;
  String get imageUrl;
  String get entryFee;
  List<Package>? get packages;
}
