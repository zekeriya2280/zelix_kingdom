
import 'package:zelix_kingdom/models/city.dart';
import 'package:zelix_kingdom/models/factory.dart';
import 'package:zelix_kingdom/models/product.dart';

class Users {
  final String id;
  final String nickname;
  final String email;
  int money = 0;
  List<Map<String, Product>>  products = [];
  List<Factory> factories = [];
  List<City> cities = [];
  Users({ required this.id ,required this.nickname, required this.email , required this.money, required this.factories, required this.products, required this.cities});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nickname': nickname,
      'email': email,
      'money': money,
      'factories': factories.map((e) => e.toMap()).toList(),
      'products.': products.map((e) => e).toList(),
      'cities': cities.map((e) => e.toJson()).toList(),
    };
  }

  factory Users.fromMap(Map<String, dynamic> material) {
    if (material['id'] == null) {
      throw ArgumentError('material must contain id');
    }
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
      id: material['id'],
      nickname: material['nickname'],
      email: material['email'],
      money: material['money'],
      factories: List<Factory>.from(material['factories']),
      products: material['products'].map((id, product) => MapEntry(Product.fromJson(product), id)).toList(),
      cities: List<City>.from(material['cities']),
    );
  }
}