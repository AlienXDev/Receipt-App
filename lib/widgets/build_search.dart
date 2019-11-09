import 'package:flutter/material.dart';
import '../utils/size_config.dart';


class BuildSearchWidget extends StatelessWidget{

  TextEditingController controller;
  BuildSearchWidget({this.controller});


  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          height: SizeConfig.heightMultiplier * 8.0,
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              SizeConfig.heightMultiplier * 1.5
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 3,
                spreadRadius: 1
              ),
            ]
          ),
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.heightMultiplier * 2.2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                child: Icon(
                  Icons.search,
                  color: Colors.black54,
                  size: SizeConfig.heightMultiplier * 3.0,
                ),
                onTap: (){
                  print('text : ${controller.text}');
                },
              ),
              SizedBox(width: SizeConfig.heightMultiplier * 1.5,),
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'search...',
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }



}