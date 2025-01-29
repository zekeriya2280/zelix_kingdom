import 'package:zelix_kingdom/models/product.dart';

class ProductConstants{ 
  Map<String, dynamic> createProductMapChangingIsProducingStartTimeAmountRemainingTime(Product product) {
  return {
    'name': product.name,
    'productionTime': product.productionTime,
    'productLevel': product.productLevel,
    'isProducing': false,
    'startTime': null,
    'id': product.id,
    'purchasePrice': product.purchasePrice,
    'amount': product.amount + 1,
    'remainingTime': 0,
    'unlocked': product.unlocked,
  };
}
Map<String, dynamic> createProductMapOnlyUpdateAll(Product product) {
  return {
            'remainingTime': product.remainingTime,
            'isProducing': product.isProducing,
            'startTime': product.startTime,
            'productLevel': product.productLevel,
            'id': product.id,
            'purchasePrice': product.purchasePrice,
            'name': product.name,
            'productionTime': product.productionTime,
            'amount': product.amount,
            'unlocked': product.unlocked,
          };
}

  
}