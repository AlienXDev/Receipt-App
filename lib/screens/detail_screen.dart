import 'package:flutter/material.dart';

import '../models/receipt.dart';
import '../utils/size_config.dart';


class DetailScreen extends StatelessWidget{

  static const String route = '/DetailScreen';

  @override
  Widget build(BuildContext context) {

    final Receipt receipt = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: Stack(
            //fit: StackFit.expand,
            children: <Widget>[
              Positioned(
                top: 0.0,
                left: 0.0,
                right: 0.0,
                child: Container(
                  child: Image.network(
                    'https://oussamaalien.000webhostapp.com/images/${receipt.img_name}.jpg',
                    height: SizeConfig.heightMultiplier * 45,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                left: 0.0,
                right: 0.0,
                bottom: 0.0,
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(top:SizeConfig.heightMultiplier * 1.5),
                    height: SizeConfig.heightMultiplier * 65,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(SizeConfig.heightMultiplier * 4.0),
                          topLeft: Radius.circular(SizeConfig.heightMultiplier * 4.0)
                      ),
                      color: Colors.white,
                    ),
                    child: ListView(
                    //  crossAxisAlignment: CrossAxisAlignment.start,
                      physics: BouncingScrollPhysics(),
                      children: <Widget>[
                        _buildHeaderName(receipt),
                        SizedBox(height: SizeConfig.heightMultiplier * 5.0,),
                        _buildStatistiques(context,receipt),
                        SizedBox(height: SizeConfig.heightMultiplier * 5.0,),
                        Padding(
                          padding: EdgeInsets.only(left: SizeConfig.heightMultiplier * 3.0),
                          child: Text(
                            'Ingredients',
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.7),
                              fontSize: SizeConfig.heightMultiplier * 3.5,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        SizedBox(height: SizeConfig.heightMultiplier * 1.0,),
                        Container(
                          child: ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.only(left: SizeConfig.heightMultiplier * 3.0),
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: receipt.ingredients.length,
                            itemBuilder: (context,index) => Container(
                              padding: EdgeInsets.all(SizeConfig.heightMultiplier * 2.0),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    height: SizeConfig.heightMultiplier * 1.1,
                                    width: SizeConfig.heightMultiplier * 1.2,
                                    decoration: BoxDecoration(
                                      color: Colors.orange,
                                      shape: BoxShape.circle
                                    ),
                                  ),
                                  SizedBox(width: SizeConfig.heightMultiplier * 1.2,),
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.75,
                                    child: Text(
                                      receipt.ingredients[index],
                                      style: TextStyle(
                                          fontSize: SizeConfig.heightMultiplier * 2.3
                                      ),
                                    )
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: SizeConfig.heightMultiplier * 5.0,),
                        /*Padding(
                          padding: EdgeInsets.only(left: SizeConfig.heightMultiplier * 3.0),
                          child: Text(
                            'Method',
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.7),
                                fontSize: SizeConfig.heightMultiplier * 3.5,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),*/
                        SizedBox(height: SizeConfig.heightMultiplier * 1.0,),
                        Container(
                          child: ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.only(left: SizeConfig.heightMultiplier * 3.0),
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: receipt.method.length,
                            itemBuilder: (context,index) => Container(
                              padding: EdgeInsets.all(SizeConfig.heightMultiplier * 2.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      '${index+1} step',
                                      style: TextStyle(
                                        fontSize: SizeConfig.heightMultiplier * 3.0,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: SizeConfig.heightMultiplier * 1.0,),
                                  Container(
                                    padding: EdgeInsets.all(SizeConfig.heightMultiplier * 1.2),
                                    width: MediaQuery.of(context).size.width * 0.7,
                                    child: Text(
                                      receipt.method[index],
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: SizeConfig.heightMultiplier * 2.2
                                      ),
                                      overflow: TextOverflow.fade,
                                      softWrap: true,
                                    ),
                                  ),
                                  SizedBox(height: SizeConfig.heightMultiplier * 2.2,),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
    );
  }


  Widget _buildSpacer(){
    return Container(
      height: SizeConfig.heightMultiplier * 3.0,
      width: SizeConfig.widthMultiplier * 0.5,
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.5),
          borderRadius: BorderRadius.circular(5.0)
      ),
    );
  }


  Widget _buildStatistiques(BuildContext context,Receipt receipt){
    return Container(
      padding: EdgeInsets.only(
          left: SizeConfig.heightMultiplier * 1.2,
          right: SizeConfig.heightMultiplier * 1.2
      ),
      height: SizeConfig.heightMultiplier * 14.0,
      width: MediaQuery.of(context).size.width,
      color: Colors.grey.withOpacity(0.08),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildMenus(
             Colors.yellow,
             receipt.difficult_ratio.toLowerCase(),
             'Difficulty',
             Icons.cake
          ),
          _buildSpacer(),
          _buildMenus(
             Colors.pink,
             receipt.prepareTime.toLowerCase(),
             'Prep',
             Icons.restaurant
          ),
          _buildSpacer(),
          _buildMenus(
             Colors.deepPurpleAccent,
             receipt.cookTime.toLowerCase(),
             'Cook',
             Icons.timer
          ),
        ],
      ),
    );
  }


  Widget _buildHeaderName(Receipt receipt){
    return Padding(
      padding: EdgeInsets.only(
        //top: SizeConfig.heightMultiplier * 2.0,
        left: SizeConfig.heightMultiplier * 3.0,
        right: SizeConfig.heightMultiplier * 3.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            receipt.name,
            style: TextStyle(
                fontSize: SizeConfig.heightMultiplier * 5.0,
                fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(height: SizeConfig.heightMultiplier * 2.0,),
          Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.heightMultiplier * 1.0,
                  vertical: SizeConfig.heightMultiplier * 0.8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: SizeConfig.heightMultiplier * 2.0,
                    ),
                    SizedBox(width: SizeConfig.widthMultiplier * 0.5,),
                    Text(
                      receipt.country,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: SizeConfig.heightMultiplier * 2.0
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(SizeConfig.heightMultiplier * 1.5),
                ),
              ),
              SizedBox(width: SizeConfig.widthMultiplier * 5.0,),
              Icon(
                Icons.star,
                color: Colors.yellow.shade700,
                size: SizeConfig.heightMultiplier * 2.8,
              ),
              SizedBox(width: SizeConfig.widthMultiplier * 1.0,),
              Text(
                '${receipt.rating}',
                style: TextStyle(
                  fontSize: SizeConfig.heightMultiplier * 2.1,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(width: SizeConfig.widthMultiplier * 2.5,),
              Text(
                '(${receipt.nbRating}) Ratings',
                style: TextStyle(
                  fontSize: SizeConfig.heightMultiplier * 2.1,
                  color: Colors.grey.shade400,
                ),
              )
            ],
          )
        ],
      ),
    );
  }


  Widget _buildMenus(Color color , String value, String category, IconData icon){
    return Row(
      children: <Widget>[
        Container(
          height: SizeConfig.heightMultiplier * 6.2,
          width: SizeConfig.heightMultiplier * 6.2,
          alignment: Alignment.center,
          child: Icon(
            icon,
            color: Colors.white,
            size: SizeConfig.heightMultiplier * 3.0,
          ),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color
          ),
        ),
        SizedBox(width: SizeConfig.widthMultiplier * 1.2,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              value,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: SizeConfig.heightMultiplier * 2.0
              ),
            ),
            SizedBox(height: SizeConfig.heightMultiplier * 0.3,),
            Text(
              category,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: SizeConfig.heightMultiplier * 1.8,
                color: Colors.grey.withOpacity(0.5)
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildImgContainer(BuildContext context){
    return Container(
      height: SizeConfig.heightMultiplier * 40.0,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/carousel1.jpg')
        ),
        borderRadius: BorderRadius.circular(SizeConfig.heightMultiplier * 1.5),
      ),
    );
  }

}