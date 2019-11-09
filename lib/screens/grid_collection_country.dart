import 'package:flutter/material.dart';

import '../utils/size_config.dart';
import '../models/receipt.dart';
import '../screens/category_screen.dart';


class GridCollectionCountry extends StatefulWidget{

  static const String route = '/gridCollection';

  @override
  _GridCollectionCountryState createState() => _GridCollectionCountryState();
}

class _GridCollectionCountryState extends State<GridCollectionCountry> {

  @override
  Widget build(BuildContext context) {

    List<Receipt> receipts = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text('Collection by country',),
      ),
      body: Padding(
        padding: EdgeInsets.all(SizeConfig.heightMultiplier * 1.5),
        child: GridView.builder(
          itemCount: receipts.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
            childAspectRatio: SizeConfig.heightMultiplier * 0.12,
            crossAxisSpacing: SizeConfig.heightMultiplier * 2.2,
            mainAxisSpacing: SizeConfig.heightMultiplier * 2.2
          ),
          itemBuilder: (context,index) => GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CategoryScreen(receipt: receipts[index],)
              )
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(SizeConfig.heightMultiplier * 2.2),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(Colors.black38, BlendMode.darken),
                  image: NetworkImage('https://oussamaalien.000webhostapp.com/images/${receipts[index].img_name}.jpg'),
                ),
              ),
              child: Center(
                child: Text(
                  '${receipts[index].country}',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: SizeConfig.heightMultiplier * 3.0
                  ),
                ),
              ),
            ),
          )
        ),
      ),
    );
  }

}