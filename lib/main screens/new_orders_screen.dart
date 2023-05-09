import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ifood_seller_app/global/global.dart';
import '../assistant methods/assistant_methods.dart';
import '../widgets/order_card.dart';
import '../widgets/progress_bar.dart';
import '../widgets/simple_appBar.dart';
class NewOrdersScreen extends StatefulWidget {
  const NewOrdersScreen({Key? key}) : super(key: key);

  @override
  State<NewOrdersScreen> createState() => _NewOrdersScreenState();
}

class _NewOrdersScreenState extends State<NewOrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(title: 'New Orders',),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('sellerUID' ,isEqualTo: sharedPreferences!.getString('uid'))
            .where('status' , isEqualTo: 'normal' )
            .snapshots(),
        builder: (context , snapshot){
          return snapshot.hasData
              ? ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context , index){
                return FutureBuilder<QuerySnapshot>(
                    future:FirebaseFirestore.instance
                        .collection('items')
                        .where('itemID', whereIn: separateOrderItemIDs((snapshot.data!.docs[index].data()! as Map <String , dynamic>)['productIDS'] ))
                        .where('sellerUID' , whereIn: (snapshot.data!.docs[index].data()! as Map <String , dynamic>)['uid'])
                        .orderBy('publishedDate', descending: true).get(),
                  builder: (context , snap){
                      return snap.hasData
                          ? OrderCard(
                        itemCount: snap.data!.docs.length,
                        data: snap.data!.docs,
                        orderID: snapshot.data!.docs[index].id,
                        seperateQuatitesList: separateOrderItemQuantities((snapshot.data!
                            .docs[index].data()! as Map <String , dynamic>)['productIDS']))
                          : Center(child: circularProgress(),);
                  },
                );
              }
          )
              : Center(child: circularProgress(),);
        },
      ),
    );
  }
}
