import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loginflutter/AdminPage.dart';
import 'package:loginflutter/MemberPage.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

void main() => runApp(new MyApp());

String username = '';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login PHP My Admin',
      home: new MyHomePage(),
      routes: <String, WidgetBuilder>{
        '/AdminPage': (BuildContext context) => new AdminPage(
              username: username,
            ),
        '/MemberPage': (BuildContext context) => new MemberPage(
              username: username,
            ),
        '/MyHomePage': (BuildContext context) => new MyHomePage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController user = new TextEditingController();
  TextEditingController pass = new TextEditingController();

  String msg = '';
  String account_error = '';

  bool _isInAsyncCall = false;

  bool _isInvalidAsyncUser = false;
  bool _isInvalidAsyncPass = false;

  void _alert_user(){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: new Text('Account Error'),
          content: new Text(account_error),
          actions: <Widget>[
            new FlatButton(
              child: new Text('close'),
              onPressed: (){
                Navigator.of(context).pop();
              }
            )
          ],
        );
      }
    );
  }



// Future<List> _login() async {
//   //old link
//   //http://10.0.2.2/my_store/login.php
//   final response = await http.post("http://test.adslive.com/government.co.za/api/signin/", body: {
//     "username": user.text,
//     "password": pass.text,
//   });

//   var datauser = json.decode(response.body);

//   if(datauser.length==0){
//     setState(() {
//           msg="Login Fail";
//         });
//   }else{
//     if(datauser[0]['level']=='admin'){
//        Navigator.pushReplacementNamed(context, '/AdminPage');
//     }else if(datauser[0]['level']=='member'){
//       Navigator.pushReplacementNamed(context, '/MemberPage');
//     }

//     setState(() {
//           username= datauser[0]['username'];
//         });

//   }

//   return datauser;
// }

  Future _login() async {

    setState((){
      _isInAsyncCall = true;
    });

    var data = jsonEncode({"action":"signin", "username": user.text, "password": pass.text});
    final response = await http.post("https://government.co.za/api/account/", body: data);

    //print(response.body);

    setState((){
      _isInAsyncCall = false;
    });
    var result = response.body;
    var user_data = json.decode(response.body);

    //print(result);
    //print(user_data);

    
    if(user_data['id'] == 'error'){
      //provided details are wrong
      print(user_data['account']);
      setState((){
        account_error = user_data['account'];
      });
      _alert_user();
    }else{
      //details are correct
      print(user_data);
      Navigator.pushReplacementNamed(context, '/AdminPage');
    }


  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: ModalProgressHUD(
        child: SingleChildScrollView(
          child: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                "Username",
                style: TextStyle(fontSize: 18.0),
              ),
              TextField(
                controller: user,
                decoration: InputDecoration(hintText: 'Username'),
              ),
              Text(
                "Password",
                style: TextStyle(fontSize: 18.0),
              ),
              TextField(
                controller: pass,
                obscureText: true,
                decoration: InputDecoration(hintText: 'Password'),
              ),
              RaisedButton(
                child: Text("sign in"),
                onPressed: () {
                  _login();
                  
                },
              ),
              Text(
                msg,
                style: TextStyle(fontSize: 20.0, color: Colors.red),
              )
            ],
          ),
        ),
      ),
        ),
        inAsyncCall: _isInAsyncCall,
        opacity: 0.5,
        progressIndicator: CircularProgressIndicator(),
      ),
    );
  }
}
