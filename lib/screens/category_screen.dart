import 'dart:convert';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/strings.dart';
import '../widgets/build_dialog.dart';
import '../models/receipt.dart';
import '../utils/size_config.dart';
import './detail_screen.dart';


class CategoryScreen extends StatefulWidget{

  final Receipt receipt;
  CategoryScreen({this.receipt});

  static const String route = '/CategoryScreen';

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}


class _CategoryScreenState extends State<CategoryScreen> {

  List list_receipt;
  List<Receipt> receipt = [];
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    getItems();
  }

  void getItems()async{
    setState(() {
      isLoaded = true;
    });
     try{
       final url = 'https://oussamaalien.000webhostapp.com/getByCountry.php';
       final response = await http.post(
           url,
           body: {'country' : widget.receipt.country}
       );
       list_receipt = json.decode(response.body);
       list_receipt.forEach((doc){
         String ingredients = doc['ingredients'];
         List listIngredient = ingredients.split('/');
         String methods = doc['method'];
         List listMethod = methods.split('/');
         receipt.add(
             Receipt(
                 id: doc['id'],
                 name: doc['name'],
                 rating: double.parse(doc['rating'].toString()),
                 nbRating: doc['nbRating'],
                 prepareTime: doc['prepTime'],
                 cookTime: doc['cookTime'],
                 country: doc['coutry'],
                 method: listMethod,
                 difficult_ratio: doc['diff_Ratio'],
                 ingredients: listIngredient,
                 img_name: doc['img_name']
             )
         );
       });
     }catch(error){
       BuildDialog.ShowDialog(context, Strings.errorText, Strings.desciprionError);
       setState(() {
         isLoaded = false;
       });
     }
    print(receipt);
    setState(() {
      isLoaded = false;
    });
  }


  showDialogTest(){
    return BuildDialog.ShowDialog(context, Strings.errorText, Strings.desciprionError);
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        children: <Widget>[
          Material(
            elevation: 4.0,
            child: Container(
              height: SizeConfig.heightMultiplier * 37,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: <Widget>[
                  _buildCarousel(),
                  Container(
                    color: Colors.black12,
                    child: Center(
                      child: Text(
                        '${widget.receipt.country} cuisine',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: SizeConfig.heightMultiplier * 5.0
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: SizeConfig.heightMultiplier * 3.0,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios,color: Colors.white,),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  )
                ],
              ),
            ),
          ),
          isLoaded
            ? LinearProgressIndicator(backgroundColor: Colors.white,)
            : Expanded(
                child: ListView(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    Container(
                      child: ListView.builder(
                        itemCount: receipt.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context,index) => Container(
                          child: Padding(
                            padding: EdgeInsets.all(SizeConfig.heightMultiplier * 1.5),
                            child: _popularItem(context,receipt[index]),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
          )
        ],
      ),
    );
  }



  Widget _popularItem(BuildContext context,Receipt receipt){
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(DetailScreen.route,arguments: receipt),
      child: Container(
        padding: EdgeInsets.all(SizeConfig.heightMultiplier * 1.5),
        height: SizeConfig.heightMultiplier * 18.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(SizeConfig.heightMultiplier * 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 4,
              blurRadius: 3
            )
          ]
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: SizeConfig.heightMultiplier * 15.0,
              width: SizeConfig.heightMultiplier * 15.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage('https://oussamaalien.000webhostapp.com/images/${receipt.img_name}.jpg'),
                    fit: BoxFit.cover
                ),
                borderRadius: BorderRadius.circular(SizeConfig.widthMultiplier * 1.1),
              ),
            ),
            SizedBox(width: SizeConfig.widthMultiplier * 4.0,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: SizeConfig.widthMultiplier * 55.0,
                  child: Text(
                    receipt.name,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: SizeConfig.heightMultiplier * 2.8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 1.3,),
                Row(
                  children: <Widget>[
                    Icon(Icons.access_time,size: SizeConfig.heightMultiplier * 2.2,),
                    SizedBox(width: SizeConfig.widthMultiplier * 1.1,),
                    Text(
                      'PREP: ${receipt.prepareTime.toLowerCase()}, COOK : ${receipt.cookTime.toLowerCase()}',
                      style: TextStyle(
                          fontSize: SizeConfig.heightMultiplier * 1.8,
                          color: Colors.grey
                      ),
                    ),
                  ],
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 1.3,),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.star,
                      color: Colors.yellow.shade600,
                      size: SizeConfig.heightMultiplier * 3.0,
                    ),
                    SizedBox(width: SizeConfig.widthMultiplier * 1.1,),
                    Text(
                      '${receipt.rating.toStringAsFixed(1)}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: SizeConfig.widthMultiplier * 1.1,),
                    Text(
                      '(${receipt.nbRating} ratings)',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: SizeConfig.heightMultiplier * 2.0
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
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
         // dotVerticalPadding: SizeConfig.heightMultiplier * 3.5,
          autoplayDuration: Duration(seconds: 3),
        ),
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
}