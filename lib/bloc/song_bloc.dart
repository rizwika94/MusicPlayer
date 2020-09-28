import 'package:walkman_music/entities/player_list_item.dart';
import 'package:walkman_music/network/repositoryImpl/remote_client/song_remote_client_impl.dart';
import 'package:rxdart/rxdart.dart';

class SongBloc {
  final PublishSubject<List<PlayerListItem>> _songList =
      PublishSubject<List<PlayerListItem>>();

  final PublishSubject<bool> _isLoading = PublishSubject<bool>();

  SongBloc() {
    _songRemoteClientImpl = SongRemoteClientImpl();
  }

  SongRemoteClientImpl _songRemoteClientImpl;

  Stream<List<PlayerListItem>> get songsDataStream => _songList.stream;

  Stream<bool> get isLoading => _isLoading.stream;

  searchSong(String title) async {
    _songList.sink.add(List<PlayerListItem>());
    _isLoading.sink.add(true);
    _songRemoteClientImpl.searchSong(title).then((value) {
      _songList.sink.add(value);
      _isLoading.sink.add(false);
    });
  }

  void drainStream() {}

  dispose() {
    _songList.close();
    _isLoading.close();
  }
}
