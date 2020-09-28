import 'package:walkman_music/entities/player_list_item.dart';
import 'package:walkman_music/network/constants/endpoints.dart';
import 'package:walkman_music/network/mapper/song_model_mapper.dart';
import 'package:walkman_music/network/repositoryImpl/remote_client/base_remote_client.dart';
import 'package:walkman_music/network/rest_client.dart';

class SongRemoteClientImpl extends BaseRemoteClientImpl {
  RestClient _restClient = RestClient();

  Future<List<PlayerListItem>> searchSong(String title) {
    String url = Endpoints.searchSong + title;
    return _restClient
        .get(url)
        .then((dynamic res) => SongModelMapper.listFromJson(res))
        .catchError((error) => handleError(error));
  }
}
