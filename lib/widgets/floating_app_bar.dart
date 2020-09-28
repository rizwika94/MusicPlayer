import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:walkman_music/resources/colors.dart';
import 'package:walkman_music/utils/network_utils.dart';
import 'package:walkman_music/widgets/alert_snackbar.dart';
import 'package:walkman_music/widgets/search_bar.dart';
import 'package:walkman_music/widgets/text_form_field_property_bundle.dart';

class FloatingAppBar extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Function(String) onSearch;

  FloatingAppBar({this.scaffoldKey, this.onSearch});

  @override
  _FloatingAppBarState createState() => _FloatingAppBarState(scaffoldKey);
}

class _FloatingAppBarState extends State<FloatingAppBar> {
  final GlobalKey<ScaffoldState> _scaffoldKey;

  final _searchBarController = TextEditingController();
  final _searchBarFocusNode = FocusNode();

  _FloatingAppBarState(this._scaffoldKey);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Container(
          height: 55,
          margin: EdgeInsets.only(left: 16, top: 8, right: 16),
          child: Padding(
            padding: EdgeInsets.only(left: 5),
            child: SearchBar(
              bundle: TextFormFieldPropertyBundle(
                  helperText: 'Search for albums, artists ...',
                  focusNode: _searchBarFocusNode,
                  controller: _searchBarController,
                  suffixIcon: IconButton(
                    padding: EdgeInsets.only(bottom: 0),
                    iconSize: 24.0,
                    icon: Icon(
                      Icons.search,
                      color: MyMusicColors.gray1,
                    ),
                    onPressed: () {},
                  ),
                  onSubmitted: (searchFor) {
                    _onSearchProduct(context, searchFor);
                  }),
            ),
          )),
    );
  }

  _onSearchProduct(BuildContext context, String searchFor) async {
    bool isInternet = await NetworkUtils.isInternet();

    if (!isInternet) {
      var alertSnackBar = AlertSnackBar(
        content: Text(
            'Your device is currently offline. Please try again when you are back online.'),
        type: AlertType.ERROR,
        duration: AlertSnackBar.ShortDuration,
      );
      _scaffoldKey.currentState?.showSnackBar(alertSnackBar);
      return;
    }

    if(searchFor.isNotEmpty) {
      searchResults();
    }
  }

  searchResults() {
    if(widget.onSearch != null) widget.onSearch(_searchBarController.text);
  }
}
