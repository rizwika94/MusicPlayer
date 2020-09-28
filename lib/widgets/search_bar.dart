import 'package:flutter/material.dart';
import 'package:walkman_music/resources/colors.dart';
import 'package:walkman_music/widgets/text_form_field_property_bundle.dart';

class SearchBar extends StatefulWidget {
  final TextFormFieldPropertyBundle bundle;
  final Function onTap;

  SearchBar({Key key, this.bundle, this.onTap}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState(bundle: bundle);
}

class _SearchBarState extends State<SearchBar> {
  _SearchBarState({TextFormFieldPropertyBundle bundle})
      : this.bundle = (bundle != null) ? bundle : TextFormFieldPropertyBundle();

  TextFormFieldPropertyBundle bundle;
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = bundle.controller ?? new TextEditingController();
    bundle.focusNode.addListener(_handleFocusOrTextChange);
    _controller.addListener(_handleFocusOrTextChange);
  }

  @override
  void dispose() {
    bundle.focusNode.removeListener(_handleFocusOrTextChange);
    _controller.removeListener(_handleFocusOrTextChange);
    super.dispose();
  }

  void _handleFocusOrTextChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0.0, 10.0, 3.0, 8.0),
      height: 65,
      child: TextFormField(
        onTap: widget.onTap,
        textAlign: TextAlign.start,
        maxLines: 1,
        enabled: bundle.enabled,
        focusNode: bundle.focusNode,
        controller: _controller,
        onFieldSubmitted: bundle.onSubmitted,
        cursorColor: MyMusicColors.red,
        keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(width: 0, style: BorderStyle.none),
              borderRadius: BorderRadius.all(Radius.circular(3.0)),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            filled: true,
            fillColor: MyMusicColors.gray3[700],
            hintText: bundle.helperText,
            suffixIcon: bundle.focusNode.hasFocus && _controller.text.isNotEmpty
                ? IconButton(
                    padding: EdgeInsets.only(bottom: 0),
                    color: MyMusicColors.gray1[500],
                    splashColor: MyMusicColors.clear,
                    highlightColor: MyMusicColors.clear,
                    icon: Icon(
                      Icons.highlight_off,
                      key: Key("clear icon"),
                    ),
                    onPressed: () {
                      Future.delayed(Duration(milliseconds: 50)).then((_) {
                        _controller.clear();
                        if (bundle.onSubmitted != null) {
                          bundle.onSubmitted(_controller.text);
                        }
                      });
                    },
                  )
                : bundle.suffixIcon == null
                    ? Container(
                        height: 10,
                        width: 10,
                      )
                    : bundle.suffixIcon),
      ),
    );
  }
}
