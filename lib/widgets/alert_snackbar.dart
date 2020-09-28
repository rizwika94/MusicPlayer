import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:walkman_music/resources/colors.dart';

const Duration _snackBarTransitionDuration = Duration(milliseconds: 250);
const Duration _snackBarDisplayDuration = Duration(milliseconds: 4000);
const Curve _snackBarHeightCurve = Curves.fastOutSlowIn;
const Curve _snackFadeInCurve =
    Interval(0.45, 1.0, curve: Curves.fastOutSlowIn);
const Curve _snackFadeOutCurve =
    Interval(0.72, 1.0, curve: Curves.fastOutSlowIn);

enum AlertType { ERROR, WARNING, SUCCESS }

class AlertAction extends SnackBarAction {
  final String label;
  final VoidCallback onPressed;

  AlertAction({Key key, @required this.label, @required this.onPressed})
      : super(
            key: key,
            textColor: Colors.white,
            disabledTextColor: MyMusicColors.gray2[200],
            label: label,
            onPressed: onPressed);
}

class AlertSnackBar extends SnackBar {
  const AlertSnackBar(
      {Key key,
      @required this.content,
      this.action,
      this.duration = _snackBarDisplayDuration,
      this.animation,
      this.onVisible,
      this.type,
      this.additionalBottomMargin = 0.0})
      : assert(content != null),
        assert(duration != null),
        assert(additionalBottomMargin != null),
        super(key: key, content: content);

  static const Duration ShortDuration = _snackBarDisplayDuration;
  static const Duration MediumDuration = Duration(seconds: 7);
  static const Duration LongDuration = Duration(seconds: 10);

  final AlertType type;

  final double additionalBottomMargin;

  final Widget content;

  final AlertAction action;

  final Duration duration;

  final Animation<double> animation;

  final VoidCallback onVisible;

  static AnimationController createAnimationController(
      {@required TickerProvider vsync}) {
    return AnimationController(
        duration: _snackBarTransitionDuration,
        debugLabel: 'SnackBar',
        vsync: vsync);
  }

  AlertSnackBar withAnimation(Animation<double> newAnimation,
      {Key fallbackKey}) {
    return AlertSnackBar(
      key: key ?? fallbackKey,
      content: content,
      action: action,
      duration: duration,
      additionalBottomMargin: additionalBottomMargin,
      animation: newAnimation,
      onVisible: onVisible,
      type: type,
    );
  }

  @override
  State<AlertSnackBar> createState() => _SnackBarState();
}

class _SnackBarState extends State<AlertSnackBar> {
  Widget _buildSnackBar() {
    return Container(
      constraints: BoxConstraints(maxWidth: 375),
      margin: EdgeInsets.only(bottom: 8.0),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 16),
            decoration: BoxDecoration(
                color: Colors.grey[850],
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(3.0),
                boxShadow: [
                  BoxShadow(
                      color: MyMusicColors.gray2[900],
                      offset: Offset(0, 5),
                      blurRadius: 5.0)
                ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    child: Container(
                  child: DefaultTextStyle(
                    child: widget.content,
                    style: TextStyle(
                        fontSize: 15,
                        letterSpacing: 0.25,
                        height: 1.27,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                )),
                (widget.action != null)
                    ? FlatButton(
                        child: widget.action,
                        onPressed: () => {},
                        padding: EdgeInsets.only(left: 16),
                      )
                    : SizedBox(
                        width: 16,
                      )
              ],
            ),
          ),
          Visibility(
            visible: (widget.type == null) ? false : true,
            child: Positioned(
              left: 15,
              top: -20,
              child: CircleAvatar(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.grey[850],
                  child: _showAlertIcon()),
            ),
          )
        ],
        overflow: Overflow.visible,
      ),
    );
  }

  Widget _showAlertIcon() {
    final double iconSize = 24.0;
    switch (widget.type) {
      case AlertType.ERROR:
        return Icon(
          Icons.error,
          color: Colors.red,
          size: iconSize,
        );
      case AlertType.WARNING:
        return Icon(
          Icons.warning,
          color: Colors.yellow,
          size: iconSize,
        );
      case AlertType.SUCCESS:
      default:
        return Icon(
          Icons.check_box,
          color: Colors.green,
          size: iconSize,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final SnackBarBehavior snackBarBehavior = SnackBarBehavior.floating;
    final bool isFloatingSnackBar =
        snackBarBehavior == SnackBarBehavior.floating;
    final CurvedAnimation heightAnimation =
        CurvedAnimation(parent: widget.animation, curve: _snackBarHeightCurve);
    final CurvedAnimation fadeInAnimation = (widget.animation != null)
        ? CurvedAnimation(parent: widget.animation, curve: _snackFadeInCurve)
        : null;
    final CurvedAnimation fadeOutAnimation = (widget.animation != null)
        ? CurvedAnimation(
            parent: widget.animation,
            curve: _snackFadeOutCurve,
            reverseCurve: const Threshold(0.0))
        : null;

    Widget snackBar = SafeArea(
      top: false,
      bottom: !isFloatingSnackBar,
      child: _buildSnackBar(),
    );

    snackBar = Material(
      color: Colors.transparent,
      child: FadeTransition(
        opacity: fadeOutAnimation,
        child: snackBar,
      ),
    );

    if (isFloatingSnackBar) {
      snackBar = Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 10.0),
        child: snackBar,
      );
    }
    Widget snackBarTransition;

    if (isFloatingSnackBar) {
      snackBarTransition =
          FadeTransition(opacity: fadeInAnimation, child: snackBar);
    } else {
      snackBarTransition = AnimatedBuilder(
        animation: heightAnimation,
        builder: (context, child) {
          return Align(
            alignment: AlignmentDirectional.topStart,
            heightFactor: heightAnimation.value,
            child: child,
          );
        },
        child: snackBar,
      );
    }
    return Container(
      margin: EdgeInsets.only(bottom: this.widget.additionalBottomMargin),
      child: ClipRect(
        child: snackBarTransition,
      ),
    );
  }
}
