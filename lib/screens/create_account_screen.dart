import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../screens/verify_screen.dart';
import '../utils/strings.dart';
import '../widgets/build_dialog.dart';
import '../utils/size_config.dart';



class CreateAccountScreen extends StatefulWidget{

  static const String route = '/createAccountScreen';
  static final _formKey = GlobalKey<FormState>();

  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}



class _CreateAccountScreenState extends State<CreateAccountScreen> {

  String username, email, password, re_password;
  int randomNumber = 0;
  bool isLoaded = false;

  var contentPadding = EdgeInsets.symmetric(
      horizontal: SizeConfig.heightMultiplier * 2.5,
      vertical: SizeConfig.heightMultiplier * 2.5
  );

  var hintStyle = TextStyle(
      fontSize: SizeConfig.heightMultiplier * 2.5
  );

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
        physics: BouncingScrollPhysics(),
        child: Container(
          margin: EdgeInsets.all(SizeConfig.heightMultiplier * 5.0),
          child: Form(
            key: CreateAccountScreen._formKey,
            child: Column(
              children: <Widget>[
                Text(
                  'Create an account',
                  style: TextStyle(
                    fontSize: SizeConfig.heightMultiplier * 5.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 7.0,),
                _buildUsernameField(),
                SizedBox(height: SizeConfig.heightMultiplier * 1.5,),
                _buildEmailField(),
                SizedBox(height: SizeConfig.heightMultiplier * 1.5,),
                _buildPasswordField(),
                SizedBox(height: SizeConfig.heightMultiplier * 1.5,),
                //_buildRePassowrdFeild(),
                SizedBox(height: SizeConfig.heightMultiplier * 8.0,),
                isLoaded ? CircularProgressIndicator() : Container(
                  width:  MediaQuery.of(context).size.width,
                  height: SizeConfig.heightMultiplier * 8.0,
                  child: RaisedButton(
                    elevation: 0.5,
                    onPressed: () => submit(context),
                    color: Colors.orange,
                    shape: StadiumBorder(),
                    child: Text(
                      'Sign up',
                      style: TextStyle(
                        fontSize: SizeConfig.heightMultiplier * 2.5,
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  void generateVerification()async{
    var rnd = Random();
    var next = rnd.nextDouble() * 1000;
    while (next < 1000) {
      next *= 10;
    }
    print(next.toInt());
    final url = 'https://oussamaalien.000webhostapp.com/login.php';
    randomNumber = next.toInt();
    try{
      final response = await http.post(
          url,
          body: {
            'random': '${next.toInt()}',
            'name' : username,
            'mailTo' : email
          }
      );
    }catch(error){
      BuildDialog.ShowDialog(context, Strings.errorText, Strings.desciprionError);
    }
  }


  Widget _buildUsernameField(){
    return TextFormField(
      validator: (value) {
        if (value.trim().isEmpty)
          return 'Please enter your name';
        if(value.trim().length < 6)
          return 'Your name must be more than 6.';
        if(value.trim().length > 20)
          return 'Your name is too big.';
        if(!value.trim().contains(RegExp(r'[A-Za-z]')))
          return 'Your name must contain a characters.';
        return null;
      },
      onSaved: (value){
        username = value;
      },
      decoration: InputDecoration(
        hintText: 'Username',
        hintStyle: hintStyle,
        contentPadding: contentPadding,
        fillColor: Colors.grey.withOpacity(0.2),
        filled: true,
        border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(
                SizeConfig.heightMultiplier * 5.0
            ),
            borderSide: BorderSide.none
        ),
      ),
    );
  }


  Widget _buildEmailField(){
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: 'Email',
        hintStyle: hintStyle,
        contentPadding: contentPadding,
        fillColor: Colors.grey.withOpacity(0.2),
        filled: true,
        border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(
                SizeConfig.heightMultiplier * 5.0
            ),
            borderSide: BorderSide.none
        ),
      ),
      validator: (value){
        if(value.trim().isEmpty)
          return 'Please enter your email.';
        if(!_validateEmail(value))
          return 'Email badly formatted.';
        return null;
      },
      onSaved: (value){
        email = value;
      },
    );
  }


  Widget _buildPasswordField(){
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        hintStyle: hintStyle,
        fillColor: Colors.grey.withOpacity(0.2),
        filled: true,
        border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(
                SizeConfig.heightMultiplier * 5.0
            ),
            borderSide: BorderSide.none
        ),
        contentPadding: contentPadding,
      ),
      validator: (value){
        if(value.trim().isEmpty)
          return 'Please enter a password.';
        if(value.trim().length < 8)
          return 'Password must be more than 8 characters';
        if(value.trim().length > 15)
          return 'Password must be more less than 15 characters';
        if(!value.trim().contains(RegExp(r'[a-z0-9]')))
          return 'Password must contain characters and numbers';
        return null;
      },
      onSaved: (value){
        password = value;
      },
    );
  }


  Widget _buildRePassowrdFeild(){
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Re-enter password',
        hintStyle: hintStyle,
        contentPadding: contentPadding,
        fillColor: Colors.grey.withOpacity(0.2),
        filled: true,
        border: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(
            SizeConfig.heightMultiplier * 5.0
          ),
          borderSide: BorderSide.none
        ),
      ),
      onSaved: (value){
        re_password = value;
      },
    );
  }


  void submit(context){
    final form = CreateAccountScreen._formKey.currentState;
    if (form.validate()) {
        form.save();
        generateVerification();
        testUserExist(context);
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
            'email' : email,
          }
      );
      if(!response.body.trim().contains('failed')) {
        setState(() {
          isLoaded = false;
        });
        showDialog(
            context: context,
            builder: (BuildContext context) =>
                SimpleDialog(
                  title: Text('The email adress already exist'),
                  children: <Widget>[
                    SimpleDialogOption(
                      child: Text('Ok'),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  ],
                )
        );
      }else{
        setState(() {
          isLoaded = false;
        });
        Navigator.of(context).pushNamed(
          VerifyScreen.route,
          arguments: {
            'name' : username,
            'email' : email,
            'password' : password,
            'randomNumber' : randomNumber
          },
        );
      }
    }catch(error){
      BuildDialog.ShowDialog(context, Strings.errorText, Strings.desciprionError);
    }
  }

  bool _validateEmail(value){
    bool emailValid = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);
    return emailValid;
  }
}