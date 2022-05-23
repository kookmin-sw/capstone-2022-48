// const serviceKey = 'de8e03e4d4884e019688';

class FoodModel {
  final String DESC_KOR; // 식품이름
  final double NUTR_CONT1; // 열량
  final double NUTR_CONT2; // 탄수화물
  final double NUTR_CONT3; // 단백질
  final double NUTR_CONT4; // 지방
  final double NUTR_CONT5; // 당도

  double get nutr1 => NUTR_CONT1;
  double get nutr2 => NUTR_CONT2;
  double get nutr3 => NUTR_CONT3;
  double get nutr4 => NUTR_CONT4;
  double get nutr5 => NUTR_CONT5;

  FoodModel(
      {required this.DESC_KOR,
      required this.NUTR_CONT1,
      required this.NUTR_CONT2,
      required this.NUTR_CONT3,
      required this.NUTR_CONT4,
      required this.NUTR_CONT5});

  FoodModel.fromJson({required Map<String, dynamic> json})
      : DESC_KOR = json['DESC_KOR'], // 식품이름
        // NUTR_CONT1 = double.parse(json['NUTR_CONT1'] ?? '0'), // 열량
        // NUTR_CONT2 = double.parse(json['NUTR_CONT2'] ?? '0'), // 탄수화물
        // NUTR_CONT3 = double.parse(json['NUTR_CONT3'] ?? '0'), // 단백질
        // NUTR_CONT4 = double.parse(json['NUTR_CONT4'] ?? '0'), // 지방
        // NUTR_CONT5 = double.parse(json['NUTR_CONT5'] ?? '0'); // 당도;
        NUTR_CONT1 = double.tryParse(json['NUTR_CONT1']) ?? 0, // 열량
        NUTR_CONT2 = double.tryParse(json['NUTR_CONT2']) ?? 0, // 탄수화물
        NUTR_CONT3 = double.tryParse(json['NUTR_CONT3']) ?? 0, // 단백질
        NUTR_CONT4 = double.tryParse(json['NUTR_CONT4']) ?? 0, // 지방
        NUTR_CONT5 = double.tryParse(json['NUTR_CONT5']) ?? 0; // 당도;
}
