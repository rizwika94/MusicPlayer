import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:walkman_music/bloc/song_bloc.dart';
import 'package:walkman_music/entities/player_list_item.dart';
import 'package:walkman_music/resources/colors.dart';
import 'package:walkman_music/widgets/play_pause_buttons.dart';
import 'package:walkman_music/widgets/slider_control.dart';

import '../widgets/floating_app_bar.dart';
import '../utils/screen_utils.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen();
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  bool canPlay = false;
  int currentIndex = -1;
  SongBloc songBloc = SongBloc();
  AudioPlayer _player;
  ConcatenatingAudioSource _playlist;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: _buildPage(context),
        bottomSheet: canPlay ? bottomPanel(_player) : null);
  }

  @override
  dispose() {
    _player.dispose();
    songBloc.dispose();
    super.dispose();
  }

  Widget _buildPage(BuildContext context) {
    Widget mainPage = GestureDetector(
      onTap: () {
        ScreenUtils.keyBoardDismiss(context);
      },
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          buildListStream(),
          FloatingAppBar(
            scaffoldKey: scaffoldKey,
            onSearch: (value) {
              songBloc.searchSong(value);
              setState(() {
                canPlay = false;
              });
            },
          ),
          showProgressWidget()
        ],
      ),
    );
    return mainPage;
  }

  Widget showProgressWidget() {
    return StreamBuilder<bool>(
        stream: songBloc.isLoading,
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData && snapshot.data == true) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Container();
          }
        });
  }

  _initAudioPlayer() async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.speech());
    try {
      await _player.load(_playlist);
    } catch (e) {
      // catch load errors: 404, invalid url ...
      print("An error occured $e");
    }
  }

  _buildAudioPlayList(List<PlayerListItem> songList) {
    List<AudioSource> _playListAudioSource = new List<AudioSource>();
    for (PlayerListItem obj in songList) {
      _playListAudioSource.add(AudioSource.uri(Uri.parse(obj.previewUrl)));
    }
    _playlist = ConcatenatingAudioSource(children: _playListAudioSource);
    _initAudioPlayer();
  }

  Widget buildListStream() {
    return StreamBuilder<List<PlayerListItem>>(
        stream: songBloc.songsDataStream,
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            _buildAudioPlayList(snapshot.data);
            return buildListView(snapshot.data);
          } else {
            return buildNotFoundUI();
          }
        });
  }

  Widget buildNotFoundUI() {
    return Center(
        child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/splashImage.jpg",
                  fit: BoxFit.contain,
                ),
                Text(
                  'Tap on the search bar to listen for your favourite artists songs',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ],
            )));
  }

  Widget buildListView(List<PlayerListItem> list) {
    return ListView.separated(
        itemBuilder: (context, index) => Material(
            color:
                currentIndex == index ? MyMusicColors.gray3[800] : Colors.white,
            child: buildTile(list[index], index)),
        separatorBuilder: (context, index) => Divider(
              color: MyMusicColors.gray1[400],
              thickness: 0.5,
            ),
        itemCount: list.length);
  }

  Widget buildTile(PlayerListItem feedListViewItem, int index) {
    return Padding(
        padding: EdgeInsets.all(8.0),
        child: ListTile(
          leading: Image.network(feedListViewItem.artworkUrl100),
          title: Text(feedListViewItem.collectionName ?? '',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          subtitle: Text(feedListViewItem.artistName ?? '',
              style: TextStyle(fontSize: 14)),
          trailing: (currentIndex == index && canPlay)
              ? Icon(Icons.equalizer, color: MyMusicColors.gray1)
              : null,
          onTap: () {
            setState(() {
              canPlay = true;
              currentIndex = index;
              _player.seek(Duration.zero, index: index);
            });
          },
        ));
  }

  Widget bottomPanel(AudioPlayer player) {
    return Container(
        height: 150,
        decoration: BoxDecoration(
            color: MyMusicColors.gray2[300],
            border: Border.all(
              color: MyMusicColors.gray1[400],
            ),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(40.0),
              topLeft: Radius.circular(40.0),
            )),
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            PlayPauseButtons(player),
            StreamBuilder<Duration>(
              stream: player.durationStream,
              builder: (context, snapshot) {
                final duration = snapshot.data ?? Duration.zero;
                return StreamBuilder<Duration>(
                  stream: player.positionStream,
                  builder: (context, snapshot) {
                    var position = snapshot.data ?? Duration.zero;
                    if (position > duration) {
                      position = duration;
                    }
                    return Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: SeekBar(
                          duration: duration,
                          position: position,
                          onChangeEnd: (newPosition) {
                            player.seek(newPosition);
                          },
                        ));
                  },
                );
              },
            ),
          ],
        ));
  }
}
