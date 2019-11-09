import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/strings.dart';
import '../widgets/build_dialog.dart';
import '../screens/home_screen.dart';
import '../screens/reset_password.dart';
import '../screens/create_account_screen.dart';
import '../utils/size_config.dart';



class SignUpScreen extends StatefulWidget{

  static const String routes = '/signUpScreen';
  static final _formKey = GlobalKey<FormState>();

  @override
  _SignUpScreenState createState() => _SignUpScreenState();

}


class _SignUpScreenState extends State<SignUpScreen> {

  var contentPadding = EdgeInsets.symmetric(
      horizontal: SizeConfig.heightMultiplier * 2.5,
      vertical: SizeConfig.heightMultiplier * 2.5
  );

  var hintStyle = TextStyle(
      fontSize: SizeConfig.heightMultiplier * 2.5
  );

  String email, password;
  bool isLoaded = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _buildCarousel(),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: Container(
              height: SizeConfig.heightMultiplier * 65,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(SizeConfig.heightMultiplier * 3.0),
                  topLeft: Radius.circular(SizeConfig.heightMultiplier * 3.0)
                ),
                color: Colors.white,
              ),
              child: Container(
                margin: EdgeInsets.only(
                  top : SizeConfig.heightMultiplier * 5,
                  right: SizeConfig.heightMultiplier * 5,
                  left: SizeConfig.heightMultiplier * 5
                ),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Welcome back',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: SizeConfig.heightMultiplier * 5,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(height: SizeConfig.heightMultiplier * 1.0,),
                    Text(
                      'Login to your account',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: SizeConfig.heightMultiplier * 2
                      ),
                    ),
                    SizedBox(height: SizeConfig.heightMultiplier * 4.5,),
                    _buildForm(),
                    SizedBox(height: SizeConfig.heightMultiplier * 3.0,),
                    isLoaded
                      ? CircularProgressIndicator()
                      : _buildLoginButton(),
                    _buildForgotButton(),
                    SizedBox(height: SizeConfig.heightMultiplier * 3.0,),
                    _buildSignUpButton()
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildImageCarousel(String  imgPath){
    return Image.asset(
      imgPath,
      fit: BoxFit.cover,
      colorBlendMode: BlendMode.darken,
      color: Colors.black12,
    );
  }

  Widget _buildCarousel(){
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        height: SizeConfig.heightMultiplier * 40,
        child: Carousel(
          boxFit: BoxFit.cover,
          images: [
            _buildImageCarousel('assets/images/carousel1.jpg'),
            _buildImageCarousel('assets/images/carousel2.jpg'),
            _buildImageCarousel('assets/images/carousel3.jpg'),
          ],
          dotBgColor: Colors.transparent,
          dotSize: SizeConfig.heightMultiplier * 1.0,
          dotColor: Colors.white,
          dotVerticalPadding: SizeConfig.heightMultiplier * 3.5,
          autoplayDuration: Duration(seconds: 3),
        ),
      ),
    );
  }


  Widget _buildForm(){
    return Form(
      key: SignUpScreen._formKey,
      child: Column(
        children: <Widget>[
          _buildEmailField(),
          SizedBox(height: SizeConfig.heightMultiplier * 1,),
          _buildPasswordField()
        ],
      ),
    );
  }


  Widget _buildLoginButton(){
    return Container(
      width:  MediaQuery.of(context).size.width,
      height: SizeConfig.heightMultiplier * 8.0,
      child: RaisedButton(
        elevation: 0.5,
        onPressed: (){
          submit(context);
        },
        color: Colors.orange,
        shape: StadiumBorder(),
        child: Text(
          'Log in',
          style: TextStyle(
              fontSize: SizeConfig.heightMultiplier * 2.5,
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }


  Widget _buildForgotButton(){
    return                     FlatButton(
      onPressed: () => Navigator.of(context).pushNamed(ResetPassword.route),
      child: Text(
        'Forgot your password?',
        style: TextStyle(
          fontSize: SizeConfig.heightMultiplier * 2.0,
        ),
      ),
    );
  }


  Widget _buildSignUpButton(){
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Don\'t have an account?',
            style: TextStyle(
                color: Colors.black54,
                fontSize: SizeConfig.heightMultiplier * 2.0
            ),
          ),
          SizedBox(width: SizeConfig.widthMultiplier,),
          InkWell(
            onTap: (){
              Navigator.of(context).pushNamed(CreateAccountScreen.route);
            },
            child: Text(
              'Sign up',
              style: TextStyle(
                  color: Colors.orange,
                  fontSize: SizeConfig.heightMultiplier * 2.5
              ),
            ),
          ),
        ],
      ),
    );
  }


  void testUserExist(BuildContext context)async{
    setState(() {
      isLoaded = true;
    });
    try{
      final url = 'https://oussamaalien.000webhostapp.com/userExist.php';
      final response = await http.post(
          url,
          body: {
            'email' : email,
            'password' : password
          }
      );
      if(response.body.trim().contains('failed')) {
        setState(() {
          isLoaded = false;
        });
        BuildDialog.ShowDialog(context, Strings.errorText, Strings.accountNotExist);
      }else{
        Navigator.of(context).pushReplacementNamed(MyHomePage.route);
      }
    }catch(error){
      BuildDialog.ShowDialog(context, Strings.errorText, Strings.desciprionError);
    }
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
        return null;
      },
      onSaved: (value){
        email = value.trim();
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
        password = value.trim();
      },
    );
  }


  void submit(context){
    final form = SignUpScreen._formKey.currentState;
    if (form.validate()) {
      form.save();
      testUserExist(context);
      print('True');
    }else{
      print('False');
    }
  }


  bool _validateEmail(value){
    bool emailValid = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);
    print('Email value : $emailValid');
    print('value : $value');
    return emailValid;
  }
}