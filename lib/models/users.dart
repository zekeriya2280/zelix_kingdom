
import 'package:zelix_kingdom/models/city.dart';
import 'package:zelix_kingdom/models/factory.dart';
import 'package:zelix_kingdom/models/product.dart';

class Users {
  final String nickname;
  final String email;
  int money = 0;
  List<Map<Product, int>>  products = [];
  List<Factory> factories = [];
  List<City> cities = [];
  Users({ required this.nickname, required this.email , required this.money, required this.factories, required this.products, required this.cities});

  Map<String, dynamic> toJson() {
    return {
      'nickname': nickname,
      'email': email,
      'money': money,
      'factories': factories.map((e) => e.toMap()).toList(),
      'products': products.map((productMap) => productMap.map((product, amount) => MapEntry(product.toJson(), amount))).toList(),
      'cities': cities.map((e) => e.toJson()).toList(),
    };
  }

  factory Users.fromMap(Map<String, dynamic> material) {
    if (material['nickname'] == null) {
      throw ArgumentError('material must contain nickname');
    }
    if (material['email'] == null) {
      throw ArgumentError('material must contain email');
    }
    if (material['money'] == null) {
      throw ArgumentError('material must contain money');
    }
    if (material['factories'] == null) {
      throw ArgumentError('material must contain factories');
    }
    if (material['products'] == null) {
      throw ArgumentError('material must contain products');
    }
    if (material['cities'] == null) {
      throw ArgumentError('material must contain cities');
    }

    return Users(
      nickname: material['nickname'],
      email: material['email'],
      money: material['money'],
      factories: List<Factory>.from(material['factories']),
      products: material['products'].map((product, amount) => MapEntry(Product.fromJson(product), amount)),
      cities: List<City>.from(material['cities']),
    );
  }
}