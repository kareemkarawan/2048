class TileModel {
  final int id;
  int value;

  TileModel({required this.id, required this.value});

  @override
  String toString() {
    return '$id,$value';
  }

  static TileModel parse(String value) {
    final parts = value.split(',');

    return TileModel(id: int.parse(parts[0]), value: int.parse(parts[1]));
  }
}
