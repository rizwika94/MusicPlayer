abstract class BaseModel {
  void fromMap(Map<String, dynamic> map);
  Map<String, dynamic> toMap();
  String getId();
  Type getRuntimeType() {
    return runtimeType;
  }
}
