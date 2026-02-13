class PlantModel {
  final int plantId;
  final String plantName;

  PlantModel({
    required this.plantId,
    required this.plantName,
  });

  factory PlantModel.fromJson(Map<String, dynamic> json) {
    return PlantModel(
      plantId: json['plantId'],
      plantName: json['plantName'],
    );
  }
}
