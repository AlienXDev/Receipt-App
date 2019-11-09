import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/receipt.dart';
import '../utils/size_config.dart';
import '../utils/strings.dart';
import '../widgets/build_dialog.dart';
import './detail_screen.dart';



class SearchScreen extends StatefulWidget{

  static const String route = '/searchScreen';

  @override
  _SearchScreenState createState() => _SearchScreenState();
}


class _SearchScreenState extends State<SearchScreen> {

  List<Receipt> searchList = [];
  List listTemp = [];
  bool isLoaded = false;
  String textFailed = '';
  TextEditingController controller = TextEditingController();


  getSearchResult()async{
    setState(() {
      searchList = [];
      listTemp = [];
      textFailed = '';
      isLoaded = true;
    });
    try{
      final url = 'https://oussamaalien.000webhostapp.com/search.php';
      final response = await http.post(
          url,
          body: {
            'value' : controller.text,
          }
      );
      if(response.body.contains('failed'))
        textFailed = 'No result';
      else{
        listTemp = json.decode(response.body);
        listTemp.forEach((doc){
          String ingredients = doc['ingredients'];
          List listIngredient = ingredients.split('/');
          String methods = doc['method'];
          List listMethod = methods.split('/');
          searchList.add(
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
            ),
          );
        });
      }
    }catch(error){
      BuildDialog.ShowDialog(context, Strings.errorText, Strings.desciprionError);
    }
    setState(() {
      isLoaded = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.only(
            top: SizeConfig.heightMultiplier * 4,
            left: SizeConfig.heightMultiplier * 2.5,
            right: SizeConfig.heightMultiplier * 2.5
          ),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    height: SizeConfig.heightMultiplier * 8,
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
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.heightMultiplier * 2.5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                          child: Icon(Icons.search,color: Colors.black54,),
                          onTap: () => getSearchResult(),
                        ),
                        SizedBox(width: SizeConfig.heightMultiplier * 1.5,),
                        Expanded(
                          child: TextField(
                            controller: controller,
                            onSubmitted: (value)=> getSearchResult(),
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
              ),
              isLoaded
                ? Column(
                    children: <Widget>[
                      SizedBox(height: SizeConfig.heightMultiplier * 15.0,),
                      CircularProgressIndicator()
                    ],
                  )
                : textFailed == 'No result'
                  ? Column(
                      children: <Widget>[
                        SizedBox(height: SizeConfig.heightMultiplier * 10.0,),
                        Container(
                          child: Text(
                            textFailed,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: SizeConfig.heightMultiplier * 5.0
                            ),
                          ),
                        )
                      ]
                    )
                  : Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics()  ,
                        itemCount: searchList.length,
                        itemBuilder: (context,index) => _popularItem(context,searchList[index]),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }


  Widget _popularItem(BuildContext context,Receipt receipt){
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(DetailScreen.route,arguments: receipt),
      child: Container(
        padding: EdgeInsets.all(SizeConfig.heightMultiplier * 1.0),
        margin: EdgeInsets.all(SizeConfig.heightMultiplier * 1.5),
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
              height: SizeConfig.heightMultiplier * 15,
              width: SizeConfig.heightMultiplier * 15,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage('https://oussamaalien.000webhostapp.com/images/${receipt.img_name}.jpg'),
                    fit: BoxFit.cover
                ),
                borderRadius: BorderRadius.circular(SizeConfig.heightMultiplier * 1),
              ),
            ),
            SizedBox(width: SizeConfig.widthMultiplier * 4.0,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: SizeConfig.widthMultiplier * 50.0,
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
                    Icon(Icons.access_time,size: 15.0,),
                    SizedBox(width: SizeConfig.heightMultiplier * 1.0,),
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
                    SizedBox(width: SizeConfig.heightMultiplier * 1.0,),
                    Text(
                      '${receipt.rating.toStringAsFixed(1)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.heightMultiplier * 2.2
                      ),
                    ),
                    SizedBox(width: SizeConfig.heightMultiplier * 1,),
                    Text(
                      '(${receipt.nbRating} ratings)',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: SizeConfig.heightMultiplier * 1.9
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

}