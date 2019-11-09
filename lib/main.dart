import 'package:flutter/material.dart';
import 'package:recipe/screens/search_screen.dart';

import './screens/category_screen.dart';
import './screens/create_account_screen.dart';
import './screens/detail_screen.dart';
import './screens/discover_screen.dart';
import './screens/grid_collection_country.dart';
import './screens/reset_password.dart';
import './screens/sign_up_screen.dart';
import './screens/verify_screen.dart';
import './utils/size_config.dart';
import './screens/home_screen.dart';


void main() => runApp(MyApp());


class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context,constraints){
        return OrientationBuilder(
          builder: (context,orientation){
            SizeConfig().init(constraints, orientation);
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: ThemeData(
                primaryColor: Colors.orange,
                accentColor: Colors.orange
              ),
              home: DiscoverSccreen(),
              routes: {
                SignUpScreen.routes : (ctx) => SignUpScreen(),
                CreateAccountScreen.route : (ctx) => CreateAccountScreen(),
                VerifyScreen.route : (ctx) => VerifyScreen(),
                MyHomePage.route : (ctx) => MyHomePage(),
                ResetPassword.route : (ctx) => ResetPassword(),
                GridCollectionCountry.route : (ctx) => GridCollectionCountry(),
                DetailScreen.route : (ctx) => DetailScreen(),
                CategoryScreen.route : (ctx) => CategoryScreen(),
                SearchScreen.route : (ctx) => SearchScreen()
              },
            );
          },
        );
      },
    );
  }
}


