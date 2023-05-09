
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ifood_seller_app/models/menus_model.dart';

import '../global/global.dart';
import '../main screens/items_screen.dart';


class InfoDesignWidget extends StatefulWidget {
  Menus? model ;
  BuildContext? context;
   InfoDesignWidget({Key? key ,
      this.model ,
      this.context
   }) : super(key: key);

  @override
  State<InfoDesignWidget> createState() => _InfoDesignWidgetState();
}

class _InfoDesignWidgetState extends State<InfoDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(
            context, MaterialPageRoute(
            builder: (context)=> ItemsScreen(
              model: widget.model,
            )));
      },
      splashColor: Colors.amber,
      child: Container(
        height: MediaQuery.of(context).size.height /2.5,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Image.network(widget.model!.thumbnailUrl! ,
              height: 220,width: MediaQuery.of(context).size.width ,
            fit: BoxFit.cover,),
            const SizedBox(height: 5,),
            Text(widget.model!.menuTitle! ,
              style: const TextStyle(
                color: Colors.cyan,
                fontSize: 20,
                fontFamily: 'Train'
              ),
            ),
            // Text(widget.model!.menuInfo! ,
            //   style: const TextStyle(
            //     color: Colors.grey,
            //     fontSize: 12,
            //   ),
            // ),
            InkWell(
              splashColor: Colors.white,
              onTap: (){
                FirebaseFirestore.instance.collection('sellers')
                    .doc(sharedPreferences!.getString('uid'))
                    .collection('menus').doc(widget.model!.menuID).delete();
                Fluttertoast.showToast(msg: 'Menu has been deleted successfully');
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.delete_sweep , color: Colors.red,),
                  Text('Delete menu' , style: TextStyle(color: Colors.grey),)
                ],
              ),
            ),
            Divider(
              height: 4,
              thickness: 3,
              color: Colors.grey[300],
            ),
          ],
        ),
      ),
    );
  }
}
