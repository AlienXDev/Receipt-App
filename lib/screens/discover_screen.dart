import 'package:flutter/material.dart';

import '../screens/sign_up_screen.dart';
import '../utils/size_config.dart';


class DiscoverSccreen extends StatelessWidget{

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/mini_fish.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.9),
                Colors.black87.withOpacity(0.7),
                Colors.black.withOpacity(0.4)
              ],
              end: Alignment.topCenter,
              begin: Alignment.bottomCenter
            )
          ),
          child: Container(
            margin: EdgeInsets.all(SizeConfig.heightMultiplier * 3.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  'Discover New\nRecipes Today.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: SizeConfig.heightMultiplier * 7.0,
                    fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 3.5,),
                Text(
                  'What do you wait to enjoy with us\njump in now.',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: SizeConfig.heightMultiplier * 2.2
                  ),
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 14.0,),
                Container(
                  width:  MediaQuery.of(context).size.width,
                  height: SizeConfig.heightMultiplier * 8.0,
                  child: RaisedButton(
                    onPressed: (){
                      Navigator.of(context).pushNamed(SignUpScreen.routes);
                    },
                    color: Colors.orange,
                    shape: StadiumBorder(),
                    child: Text(
                      'Log in',
                      style: TextStyle(
                        fontSize: SizeConfig.heightMultiplier * 2.2,
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 3.0,)
              ],
            ),
          ),
        ),
      ),
    );
  }

}