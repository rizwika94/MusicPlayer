import 'package:walkman_music/entities/player_list_item.dart';

class SongModelMapper {
  static List<PlayerListItem> listFromJson(Map<String, dynamic> json) {
    if (json == null || json['results'] == null) List<PlayerListItem>();
    List<dynamic> jsonList = json['results'];
    return json == null
        ? List<PlayerListItem>()
        : jsonList.map((value) => SongModelMapper.fromJson(value)).toList();
  }

  static PlayerListItem fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    var song = PlayerListItem();
    song.artistName = json['artistName'];
    song.previewUrl = json['previewUrl'];
    song.collectionName = json['collectionName'];
    song.artworkUrl100 = json['artworkUrl60'];
    return song;
  }
}
