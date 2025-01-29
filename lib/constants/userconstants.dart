import 'package:zelix_kingdom/models/city.dart';
import 'package:zelix_kingdom/models/factory.dart';
import 'package:zelix_kingdom/models/product.dart';

class Userconstants{
  Map<String, dynamic> createUserFirstInfos(
      String id,
      String nickname,
      String email,
      Map<Factory, int> factories,
      Map< String , Product > products,
      Map<City, int> cities
  ) {
  return {
        'id': id,
        'nickname': nickname,
        'email': email,
        'money': 1000,
        'factories': factories,
        'products': products,
        'cities': cities
      };
}
}