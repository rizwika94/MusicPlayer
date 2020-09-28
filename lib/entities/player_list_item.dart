import 'base_model.dart';

class PlayerListItem extends BaseModel {
  String wrapperType;
  String kind;
  int artistId;
  int collectionId;
  int trackId;
  String artistName;
  String collectionName;
  String trackName;
  String collectionCensoredName;
  String trackCensoredName;
  String artistViewUrl;
  String collectionViewUrl;
  String trackViewUrl;
  String previewUrl;
  String artworkUrl;
  String artworkUrl100;
  double collectionPrice;
  double trackPrice;
  String releaseDate;
  String collectionExplicitness;
  String trackExplicitness;
  int discCount;
  int discNumber;
  int trackCount;
  int trackNumber;
  int trackTimeMillis;
  String country;
  String currency;
  String primaryGenreName;
  bool isStreamable;

  PlayerListItem();

  @override
  void fromMap(Map<String, dynamic> map) {}

  @override
  String getId() {}

  @override
  Map<String, dynamic> toMap() {}
}
