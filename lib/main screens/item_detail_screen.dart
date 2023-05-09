import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ifood_seller_app/global/global.dart';
import 'package:ifood_seller_app/main%20screens/home_screen.dart';
import 'package:ifood_seller_app/widgets/simple_appBar.dart';
import '../models/items_model.dart';

class ItemDetailScreen extends StatefulWidget {
  final Items? model;
  const ItemDetailScreen({Key? key , this.model}) : super(key: key);

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  TextEditingController counterTextEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(title: sharedPreferences!.getString('name'),),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(widget.model!.thumbnailUrl.toString() ,
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height / 2.5,
              width: double.infinity,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.model!.itemTitle.toString(),
                textAlign: TextAlign.justify,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.model!.itemDescription.toString(),
                textAlign: TextAlign.justify,
                style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 14, color: Colors.grey),),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 20),
              child: Text(
                '${widget.model!.itemPrice!.toString()} EGP',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    fontFamily: 'Kiwi',
                    color: Colors.cyan
                ),
              ),
            ),
            const SizedBox(height: 30,),
            Center(
              child: InkWell(
                onTap: (){

                  FirebaseFirestore.instance.collection('sellers')
                      .doc(sharedPreferences!.getString('uid'))
                      .collection('menus')
                      .doc(widget.model!.menuID)
                      .collection('items')
                      .doc(widget.model!.itemID)
                      .delete();

                  FirebaseFirestore.instance.collection('items').doc(widget.model!.itemID).delete();

                  Fluttertoast.showToast(msg: 'Item has been deleted successfully');

                  Navigator.pushReplacement(
                      context, MaterialPageRoute(
                      builder: (context)=> const HomeScreen()
                  ));
                },
                child: Container(
                  alignment: Alignment.bottomCenter,
                  decoration:  BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.cyan , Colors.amber ],
                        begin: FractionalOffset(0.0,0.0),
                        end: FractionalOffset(1.0,0.0),
                        stops: [0.0 , 1.0],
                        tileMode: TileMode.clamp,
                      ),
                    borderRadius: BorderRadius.circular(20)
                  ),
                  width: MediaQuery.of(context).size.width-20,
                  height: 50,
                  child: const Center(
                    child: Text('Delete this item',
                    style: TextStyle(color: Colors.white , fontSize: 20),),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
