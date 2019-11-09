import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../screens/home_screen.dart';
import '../utils/size_config.dart';
import '../utils/strings.dart';
import '../widgets/build_dialog.dart';


class ResetPassword extends StatefulWidget{

  static const String route = '/resetPassword';

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}



class _ResetPasswordState extends State<ResetPassword> {

  int randomNumber;
  bool isLoaded = false;
  bool isLoadedReset = false;
  bool isSend = false;
  String text = '';
  TextEditingController _emailController = TextEditingController();
  TextEditingController _otpController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _repasswordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(SizeConfig.heightMultiplier * 5),
          child: isSend ? forgetWidget() : emailSetWidget()
          ),
      ),
    );
  }



  Widget forgetWidget(){
    return Column(
      children: <Widget>[
        Text(
          'Create new password',
          style: TextStyle(
            fontSize: SizeConfig.heightMultiplier * 4.5,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: SizeConfig.heightMultiplier * 1.5,),
        Text(
          'Please enter OTP number that has\nbeen sent to your email',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.black54,
              fontSize: SizeConfig.heightMultiplier * 2.0
          ),
        ),
        SizedBox(height: SizeConfig.heightMultiplier * 8.0,),
        TextField(
            controller: _otpController,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter OTP'
            ),
        ),
        SizedBox(height: SizeConfig.heightMultiplier * 1.5,),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter new password'
          ),
        ),
        SizedBox(height: SizeConfig.heightMultiplier * 1.5,),
        TextField(
          controller: _repasswordController,
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Re-enter new password'
          ),
        ),
        SizedBox(height: SizeConfig.heightMultiplier * 3.0,),
        isLoadedReset
          ? CircularProgressIndicator()
          : MaterialButton(
              height: SizeConfig.heightMultiplier * 8.0,
              minWidth: MediaQuery.of(context).size.width,
              child: Text('Reset password'),
              onPressed: resetPassword,
              color: Colors.orange,
              textColor: Colors.white,
              highlightColor: Colors.white,
              splashColor: Colors.orangeAccent,
            ),
        SizedBox(height: SizeConfig.heightMultiplier * 3.0,),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Didn\'t get the code?'),
            SizedBox(width: SizeConfig.widthMultiplier * 1.5,),
            InkWell(
              child: Text(
                'Resend code',
                style: TextStyle(
                  color: Colors.orange
                ),
              ),
              onTap: () => forgotPassword(context),
            ),
          ],
        )
      ],
    );
  }



  void resetPassword(){
    print(_otpController.text );
    if(_otpController.text == randomNumber.toString()){
      if(_passwordController.text == _repasswordController.text){
        if(_passwordController.text.trim().isEmpty)
          text = 'Please enter a password.';
        if(_passwordController.text.trim().length < 8)
          text = 'Password must be more than 8 characters';
        if(_passwordController.text.trim().length > 15)
          text = 'Password must be more less than 15 characters';
        if(!_passwordController.text.trim().contains(RegExp(r'[a-z0-9]')))
          text = 'Password must contain characters and numbers';
        else{
          print('xxxxxxxxx');
          updatePassword();
        }
      }else{
        text = text.isNotEmpty ? '$text and the password' : 'Please re-enter the password';
      }
    }else{
      text = 'Please re-enter the OTP code';
    }
  }


  void updatePassword() async{
    setState(() {
      isLoadedReset = true;
    });
    try{
      final url = 'https://oussamaalien.000webhostapp.com/update.php';
      final response = await http.post(
          url,
          body: {
            'email':  _emailController.text,
            'password' : _passwordController.text
          }
      );
      setState(() {
        isLoadedReset = false;
      });
      if(response.body.trim().contains('Succes')){
        Navigator.of(context).pushReplacementNamed(MyHomePage.route);
      }else{
        SimpleDialog(
          title: Text('Something happen please repeate the process.'),
          children: <Widget>[
            SimpleDialogOption(
              child: Text('Ok'),
              onPressed: (){
                Navigator.of(context).pop();
              },
            )
          ],
        );
      }
    }catch(error){
      BuildDialog.ShowDialog(context, Strings.errorText, Strings.desciprionError);
    }
  }


  Widget emailSetWidget(){
    return Column(
      children: <Widget>[
        Text(
          'Forgot Password',
          style: TextStyle(
            fontSize: SizeConfig.heightMultiplier * 5.5,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: SizeConfig.heightMultiplier * 1.5,),
        Text(
          'Please enter your email & we will\nsend an OTP number.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black54,
            fontSize: SizeConfig.heightMultiplier * 2.0
          ),
        ),
        SizedBox(height: SizeConfig.heightMultiplier * 8.0,),
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'email',
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(height: SizeConfig.heightMultiplier * 3.0,),
        isLoaded
            ? CircularProgressIndicator()
            : MaterialButton(
                height: SizeConfig.heightMultiplier * 8.0,
                minWidth: MediaQuery.of(context).size.width,
                child: Text('Send'),
                onPressed: () => testUserExist(context),
                color: Colors.orange,
                textColor: Colors.white,
                highlightColor: Colors.white,
                splashColor: Colors.orangeAccent,
              )
      ],
    );
  }



  void forgotPassword(BuildContext context)async{
    var rnd = Random();
    var next = rnd.nextDouble() * 1000;
    while (next < 1000) {
      next *= 10;
    }
    final url = 'https://oussamaalien.000webhostapp.com/forgotPassword.php';
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            SimpleDialog(
              title: Text('We have send a OTP code to your email to make sure that you are the real user.'),
              children: <Widget>[
                SimpleDialogOption(
                  child: Text('Ok'),
                  onPressed: (){
                    Navigator.of(context).pop();
                    setState(() {
                      isSend = true;
                    });
                  },
                )
              ],
            )
    );
    randomNumber = next.toInt();
    print(randomNumber);
    try{
      final response = await http.post(
          url,
          body: {
            'random': '${next.toInt()}',
            'mailTo' : _emailController.text
          }
      );
    }catch(error){
      BuildDialog.ShowDialog(context, Strings.errorText, Strings.desciprionError);
    }
  }



  void testUserExist(BuildContext context)async{
    setState(() {
      isLoaded = true;
    });
    final url = 'https://oussamaalien.000webhostapp.com/userExistEmail.php';
    try{
      final response = await http.post(
          url,
          body: {
            'email' : _emailController.text,
          }
      );
      if(response.body.trim().contains('failed')) {
        setState(() {
          isLoaded = false;
        });
        showDialog(
            context: context,
            builder: (BuildContext context) =>
                SimpleDialog(
                  title: Text('Please re-enter the email'),
                  children: <Widget>[
                    SimpleDialogOption(
                      child: Text('Cancel'),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  ],
                )
        );
      }else{
        setState(() {
          isSend = true;
        });
        forgotPassword(context);
      }
    }catch(error){
      BuildDialog.ShowDialog(context, Strings.errorText, Strings.desciprionError);
    }
  }
}