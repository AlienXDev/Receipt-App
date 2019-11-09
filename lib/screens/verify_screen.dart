import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:http/http.dart' as http;

import '../utils/strings.dart';
import '../widgets/build_dialog.dart';
import '../screens/home_screen.dart';
import '../utils/size_config.dart';



class VerifyScreen extends StatefulWidget{

  static const String route = '/verifyScreen';

  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}


class _VerifyScreenState extends State<VerifyScreen> {

  String name,email,password;
  int randomNum;

  @override
  Widget build(BuildContext context) {

    Map arguments = ModalRoute.of(context).settings.arguments;
    name = arguments['name'];
    email = arguments['email'];
    password = arguments['password'];
    randomNum = arguments['randomNumber'];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(SizeConfig.heightMultiplier * 5.0),
          child: Column(
            children: <Widget>[
              Text(
                'Email Verification',
                style: TextStyle(
                  fontSize: SizeConfig.heightMultiplier * 5.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: SizeConfig.heightMultiplier * 8.0,),
              Text(
                'Enter the 4 digit code we sent you\nvia email to continue',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black87,
                  shadows: <Shadow>[
                    Shadow(
                      blurRadius: 3.0,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                    Shadow(
                      blurRadius: 8.0,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                  ],
                ),
              ),
              SizedBox(height: SizeConfig.heightMultiplier * 12.0,),
              PinPut(
                clearInput: true,
                fieldsCount: 4,
                onSubmit: (String pin){
                  if(pin == '$randomNum'){
                    Navigator.of(context).pushReplacementNamed(MyHomePage.route);
                    insertUserData();
                  }
                  else
                    print(false);
                },
                onClear: (value){},
              ),
            ],
          ),
        ),
      ),
    );
  }


  void insertUserData()async{
    try{
      final url = 'https://oussamaalien.000webhostapp.com/insert.php';
      final response = await http.post(
          url,
          body: {'name' : name.toString(),'password': password.toString(),'email': email.toString()}
      );
    }catch(error){
      BuildDialog.ShowDialog(context, Strings.errorText, Strings.desciprionError);
    }

  }

}