import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:bluerange_sdk/bluerange_sdk.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../security/security.dart';

class HomeScreen extends StatefulWidget {
  @override
  State createState() => new HomeState();
}

class HomeState extends State<HomeScreen> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Map user;
  String _platformVersion = 'Unknown';
  HomeState() {
    print('Home');
    this.user = UserModel.userInfo['user'];
  }
  static const List<String> _drawerContents = const <String>[
    'A',
    'B',
    'C',
    'D',
    'E',
  ];

  AnimationController _controller;
  Animation<double> _drawerContentsOpacity;
  Animation<FractionalOffset> _drawerDetailsPosition;
  bool _showDrawerContents = true;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _drawerContentsOpacity = new CurvedAnimation(
      parent: new ReverseAnimation(_controller),
      curve: Curves.fastOutSlowIn,
    );
    _drawerDetailsPosition = new FractionalOffsetTween(
      begin: const FractionalOffset(0.0, -1.0),
      end: const FractionalOffset(0.0, 0.0),
    )
        .animate(new CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    ));
  }
  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      print('platformVersion');
      platformVersion = await BluerangeSdk.platformVersion;
      print('platformVersion');
      print(platformVersion);
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
      print('platformVersion');
      print(platformVersion);
    } catch(e) {
      print(e);
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  IconData _backIcon() {
    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        return Icons.arrow_back;
      case TargetPlatform.iOS:
        return Icons.arrow_back_ios;
    }
    assert(false);
    return null;
  }

  void _showNotImplementedMessage() {
    Navigator.of(context).pop(); // Dismiss the drawer.
    _scaffoldKey.currentState.showSnackBar(const SnackBar(
        content: const Text("The drawer's items don't do anything")));
  }

  Widget _buildTextComposer() {
    return new Card(
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Text('Running on: $_platformVersion\n'),
          const ListTile(
            leading: const Icon(Icons.album),
            title: const Text('The Enchanted Nightingale'),
            subtitle:
                const Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
          ),
          new ButtonTheme.bar(
            // make buttons use the appropriate styles for cards
            child: new ButtonBar(
              children: <Widget>[
                new FlatButton(
                  child: const Text('BUY TICKETS'),
                  onPressed: () {/* ... */},
                ),
                new FlatButton(
                  child: const Text('LISTEN'),
                  onPressed: () {/* ... */},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        drawer: new Drawer(
          child: new ListView(
            children: <Widget>[
              new UserAccountsDrawerHeader(
                accountName:
                    new Text(user["givenName"] + ' ' + user["surname"]),
                accountEmail: new Text(user['email']),
                // currentAccountPicture: const CircleAvatar(backgroundImage: const AssetImage(_kAsset0)),
                // otherAccountsPictures: const <Widget>[
                //   const CircleAvatar(backgroundImage: const AssetImage(_kAsset1)),
                //   const CircleAvatar(backgroundImage: const AssetImage(_kAsset2)),
                // ],
                // onDetailsPressed: () {
                //   _showDrawerContents = !_showDrawerContents;
                //   if (_showDrawerContents)
                //     _controller.reverse();
                //   else
                //     _controller.forward();
                // },
              ),
              new ClipRect(
                child: new Stack(
                  children: <Widget>[
                    // The initial contents of the drawer.
                    new FadeTransition(
                      opacity: _drawerContentsOpacity,
                      child: new Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: _drawerContents.map((String id) {
                          return new ListTile(
                            leading: new CircleAvatar(child: new Text(id)),
                            title: new Text('Drawer item $id'),
                            onTap: _showNotImplementedMessage,
                          );
                        }).toList(),
                      ),
                    ),
                    // The drawer's "details" view.
                    new SlideTransition(
                      position: _drawerDetailsPosition,
                      child: new FadeTransition(
                        opacity: new ReverseAnimation(_drawerContentsOpacity),
                        child: new Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            new ListTile(
                              leading: const Icon(Icons.add),
                              title: const Text('Add account'),
                              onTap: _showNotImplementedMessage,
                            ),
                            new ListTile(
                              leading: const Icon(Icons.settings),
                              title: const Text('Manage accounts'),
                              onTap: _showNotImplementedMessage,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        appBar: new AppBar(
          leading: new IconButton(
              icon: new Icon(FontAwesomeIcons.bars),
              tooltip: 'Home',
              onPressed: () => _scaffoldKey.currentState.openDrawer()),
          title: new Text('Home'),
        ),
        body: _buildTextComposer());
  }
}
