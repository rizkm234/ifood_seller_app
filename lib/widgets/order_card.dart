import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../main screens/order_details_screen.dart';
import '../models/items_model.dart';


class OrderCard extends StatelessWidget {
  final int? itemCount;
  final List<DocumentSnapshot>? data;
  final String? orderID;
  final List<String>? seperateQuatitesList;

  const OrderCard({
    Key? key,
    this.itemCount,
    this.data,
    this.orderID,
    this.seperateQuatitesList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(
            builder: (context)=>OrderDetailsScreen(
                orderID: orderID
            )
        )
        );
      },
      child: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          colors: [Colors.black54, Colors.white54],
          begin: FractionalOffset(0.0, 0.0),
          end: FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        )),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        height: itemCount! * 125,
        child: ListView.builder(
            itemCount: itemCount,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              Items model =
                  Items.fromJson(data![index].data()! as Map<String, dynamic>);
              return placedOrderDesignWidget(
                  model, context, seperateQuatitesList![index]);
            }),
      ),
    );
  }
}

Widget placedOrderDesignWidget(
    Items model, BuildContext context, seperateQuatitesList) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 120,
    color: Colors.grey[200],
    padding: const EdgeInsets.only(top: 5, left: 0),
    child: Row(
      children: [
        Image.network(model.thumbnailUrl! , width: 150, fit: BoxFit.cover,),
        const SizedBox(width: 20,),
        Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                        child: Text(
                          model.itemTitle!,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'Acme'
                          ),
                        ),
                    ),
                    const SizedBox(width: 10,),

                    const SizedBox(width: 5,)
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'x ',
                      style: TextStyle(fontSize: 14 , color: Colors.black54),
                    ),
                    Expanded(
                        child: Text(
                          seperateQuatitesList,
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 30,
                            fontFamily: 'Acme',
                          ),
                        )
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'EGP',
                      style: TextStyle(fontSize: 16 , color: Colors.blue),
                    ),
                    Text(
                      model.itemPrice!.toString(),
                      style: const TextStyle(fontSize: 18 , color: Colors.blue),
                    ),
                  ],
                )
              ],
            )
        ),
      ],
    ),
  );
}
