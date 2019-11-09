import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../screens/search_screen.dart';
import '../utils/strings.dart';
import '../widgets/build_dialog.dart';
import '../models/receipt.dart';
import '../screens/detail_screen.dart';
import '../screens/grid_collection_country.dart';
import '../utils/size_config.dart';


class MyHomePage extends StatefulWidget {

  static const String route = '/homePge';

  @override
  _MyHomePageState createState() => _MyHomePageState();

}



class _MyHomePageState extends State<MyHomePage> {

  bool isLoaded = false;
  List listOfRecipes = [];
  List<Receipt> threeReceipts = [];
  List<Receipt> receipts = [];
  List<Receipt> receiptsSend = [];

  @override
  void initState() {
    super.initState();
    getData();
  }


  getData()async{
    setState(() {
      isLoaded = true;
    });
    try{
      final url = 'https://oussamaalien.000webhostapp.com/getReceipt.php';
      final response = await http.get(url);
      setState(() {
        listOfRecipes = json.decode(response.body);
        isLoaded = false;
      });
      listOfRecipes.forEach((doc){
        String ingredients = doc['ingredients'];
        List listIngredient = ingredients.split('/');
        String methods = doc['method'];
        List listMethod = methods.split('/');
        Receipt receipt = Receipt(
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
        );
        receiptsSend.add(receipt);
        if(threeReceipts.length < 3 )
          threeReceipts.add(receipt);
        else
          receipts.add(receipt);
        receipt = null;
      });
    }catch(error){
      BuildDialog.ShowDialog(context, Strings.errorText, Strings.desciprionError);
    }
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: isLoaded ? Center(child: CircularProgressIndicator(),) : Padding(
            padding: EdgeInsets.only(
              top: SizeConfig.heightMultiplier * 2.5,
              left: SizeConfig.heightMultiplier * 2.0,
              right: SizeConfig.heightMultiplier * 2.0
            ),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    onTap: () => Navigator.of(context).pushNamed(SearchScreen.route),
                    child: Container(
                      height: SizeConfig.heightMultiplier * 7.0,
                      width: MediaQuery.of(context).size.width * 0.9,
                      padding: EdgeInsets.all(SizeConfig.heightMultiplier * 1.0),
                      decoration: BoxDecoration(
                        color: Colors.white ,
                        borderRadius: BorderRadius.circular(SizeConfig.heightMultiplier * 1.0),
                        border: Border.all(color: Colors.grey.withOpacity(0.2),width: 1.0)
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.search,
                            color: Colors.grey,
                            size: SizeConfig.heightMultiplier * 3.0,
                          ),
                          SizedBox(width: SizeConfig.heightMultiplier * 1.0,),
                          Text('Search..',style: TextStyle(color: Colors.grey),),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: SizeConfig.heightMultiplier * 5.0,),
                  Text(
                    'Discover popular recipe',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: SizeConfig.heightMultiplier * 3.5,
                    ),
                  ),
                  SizedBox(height: SizeConfig.heightMultiplier * 2.5),
                  _popularItem(threeReceipts[0]),
                  SizedBox(height: SizeConfig.heightMultiplier * 1.0),
                  Divider(),
                  SizedBox(height: SizeConfig.heightMultiplier * 1.0),
                  _popularItem(threeReceipts[1]),
                  SizedBox(height: SizeConfig.heightMultiplier * 1.0),
                  Divider(),
                  SizedBox(height: SizeConfig.heightMultiplier * 1.0),
                  _popularItem(threeReceipts[2]),
                  SizedBox(height: SizeConfig.heightMultiplier * 6.0),
                  _collectionHeader(),
                  SizedBox(height: SizeConfig.heightMultiplier * 2.5),
                  _horizontalList(),
                  SizedBox(height: SizeConfig.heightMultiplier * 2.5),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }



  Widget _collectionHeader() {
    return Padding(
      padding: EdgeInsets.only(right: SizeConfig.heightMultiplier * 1.0),
      child: Row(
        children: <Widget>[
          Text(
            'Collection by country',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: SizeConfig.heightMultiplier * 3.5,
            ),
          ),
          Spacer(),
          InkWell(
            child: Text(
              'See all',
              style: TextStyle(
                  fontSize: SizeConfig.heightMultiplier * 1.7,
                  fontWeight: FontWeight.w500,
                  color: Colors.orange
              ),
            ),
            onTap: () => Navigator.of(context).pushNamed(
                GridCollectionCountry.route,
                arguments: receiptsSend
            ),
          ),
          Icon(
            Icons.play_arrow,
            size: SizeConfig.heightMultiplier * 2.3,
            color: Colors.orange,
          )
        ],
      ),
    );
  }


  Widget _horizontalList(){
    return Container(
      height: SizeConfig.heightMultiplier * 30,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 3,
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context,index) {
            print('image name : ${receipts[index].img_name}');
            return  Container(
              height: SizeConfig.heightMultiplier * 7.0,
              width: SizeConfig.heightMultiplier * 35.0,
              margin: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    SizeConfig.heightMultiplier * 1.5
                  ),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(Colors.black26, BlendMode.darken),
                      image: NetworkImage(
                        'https://oussamaalien.000webhostapp.com/images/${receipts[index].img_name}.jpg',
                      )
                  )
              ),
            );
          }

      ),
    );
  }


  Widget _popularItem(Receipt receipt){
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(DetailScreen.route,arguments: receipt),
      child: Row(
        children: <Widget>[
          Container(
            height: SizeConfig.heightMultiplier * 15.0,
            width: SizeConfig.heightMultiplier * 15.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://oussamaalien.000webhostapp.com/images/${receipt.img_name}.jpg'),
                fit: BoxFit.cover
              ),
              borderRadius: BorderRadius.circular(SizeConfig.heightMultiplier * 1.0),
            ),
          ),
          SizedBox(width: SizeConfig.widthMultiplier * 4.0,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: SizeConfig.widthMultiplier * 60.0,
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
                  Icon(
                    Icons.access_time,
                    size: SizeConfig.heightMultiplier * 2.0,
                  ),
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
                    size: SizeConfig.heightMultiplier * 2.7,
                  ),
                  SizedBox(width: SizeConfig.heightMultiplier * 1.0,),
                  Text(
                    '${receipt.rating.toStringAsFixed(1)}',
                    style: TextStyle(
                      fontSize: SizeConfig.heightMultiplier * 2.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(width: SizeConfig.heightMultiplier * 1.0,),
                  Text(
                    '(${receipt.nbRating} ratings)',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: SizeConfig.heightMultiplier * 1.8
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
