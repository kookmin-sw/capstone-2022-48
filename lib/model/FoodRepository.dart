import 'package:capstone_2022_48/Model/Food.dart';
import 'package:dio/dio.dart';

class FoodRepository {
  static Future<List<FoodModel>> fetchData(String food) async {
    // var name = food;
    final response = await Dio().get(
        'http://openapi.foodsafetykorea.go.kr/api/de8e03e4d4884e019688/I2790/json/1/10/' +
            'DESC_KOR=' +
            food);

    // print(response);

    // List<FoodModel> list = <FoodModel>[];
    List<FoodModel> list = response.data['I2790']['row']
        .map<FoodModel>((item) => FoodModel.fromJson(json: item))
        .toList();
    // if (response.data != null) {
    //   list = response.data['I2790']['row']
    //       .map(
    //         (item) => FoodModel.fromJson(json: item),
    //       )
    //       .toList();
    // }
    return list;
    // return response.data['I2790']['row']
    //     .map(
    //       (item) => FoodModel.fromJson(json: item),
    //     )
    //     .toList(),cast<List<FoodModel>>();
  }
}
