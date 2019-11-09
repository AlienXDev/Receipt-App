import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class BuildDialog{

  static Future ShowDialog(BuildContext context, String title,String content){
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) =>
          AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: <Widget>[
               FlatButton(
                 child: Text('Ok'),
                 onPressed: () => Navigator.of(context).pop(),
               )
            ],
          )
    );
  }


}