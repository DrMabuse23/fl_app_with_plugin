import 'package:flutter/material.dart';
import 'dart:convert';
import '../model_user.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

var httpClient = createHttpClient();

class LoginScreen extends StatefulWidget {
  @override
  State createState() => new LoginState();
}

class LoginState extends State<LoginScreen> {
  UserModel userModel = new UserModel('', '');
  final TextEditingController _userNameController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();

  LoginState() {
    _userNameController.text = userModel.userName;
    _passwordController.text = userModel.password;
  }

  void _handleSubmitted(UserModel model) {
    print(model.userName);
    print(model.password);
    postData();
  }

  String get url {return 'https://iot2.relution.io/gofer/security/rest/auth';}
//https://iot2.relution.io/relution/api/v1/gofer/security/rest/auth/
  postData() async {
    try {
      var response = await httpClient.post(
        url + '/login', 
        body: JSON.encode({'userName': userModel.userName, 'password': userModel.password}), 
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'}
      );
      print('Response status: ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('loggedIn: ');
        UserModel.userInfo = JSON.decode(response.body);
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } catch(e){
      print('Error on Login');
      print(e.toString());
    }
  }

  void _userNameChanged(String text) {
    userModel.userName = _userNameController.text;
  }

  void _passwordChanged(String text) {
    userModel.password = _passwordController.text;
  }

  Widget _buildTextComposer() {
    return new Center(
        child:new Container(
        //   decoration: new BoxDecoration(
        //   image: new DecorationImage(
        //     image: new AssetImage("assets/images/bg-blue.png"),
        //     fit: BoxFit.cover,
        //   ),
        // ),
      alignment: FractionalOffset.center,
      width: 400.0,
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
          new Flexible(
              child: new Container(
                  child: new Image.asset('assets/images/icon-black.png',
                      width: 368.0 * 0.5, height: 253.0 * 0.5))),
          new Flexible(
              child: new Container(
            decoration: const BoxDecoration(
              border: const Border(
                bottom: const BorderSide(
                    width: 1.0, color: const Color(0xFFFF000000)),
              ),
            ),
            height: 160.0,
            padding:
                const EdgeInsets.only(bottom: 12.0, left: 25.0, right: 25.0),
            margin: const EdgeInsets.only(bottom: 25.0, top: 50.0),
            child: new TextField(
              autofocus: true,
              textAlign: TextAlign.center,
              controller: _userNameController,
              decoration: new InputDecoration.collapsed(hintText: "Username"),
              onChanged: _userNameChanged,
            ),
          )),
          new Flexible(
            child: new Container(
            padding: const EdgeInsets.only(bottom: 12.0, left: 25.0, right: 25.0),
            margin: const EdgeInsets.only(bottom: 55.0),
            height: 160.0,
            child: new TextField(
              textAlign: TextAlign.center,
              obscureText: true,
              controller: _passwordController,
              decoration: new InputDecoration.collapsed(hintText: 'Password'),
              onChanged: _passwordChanged,
            ),
          )),
          new Flexible(
              child: new FloatingActionButton(
                
            onPressed: () => _handleSubmitted(userModel),
            tooltip: 'Login',
            backgroundColor: Colors.black,
            child: new Icon(FontAwesomeIcons.signIn)
          ))
        ])));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: _buildTextComposer());
  }
}
