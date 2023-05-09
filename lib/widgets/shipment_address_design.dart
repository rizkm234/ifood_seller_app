import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../global/global.dart';
import '../main screens/home_screen.dart';
import '../models/address.dart';


class ShipmentAddressDesign extends StatelessWidget {
  final Address? model ;
  final String? orderStatus;
  final String? orderId;
  final String? sellerId;
  final String? orderByUser;
  const ShipmentAddressDesign({Key? key,
    this.model ,
    this.orderStatus ,
    this.orderId,
    this.sellerId,
    this.orderByUser,
  }) : super(key: key);


  confirmParcelShipment(
      BuildContext context,
      String getOrderID,
      String sellerId,
      String purchaserId)
  {
    // FirebaseFirestore.instance
    //     .collection('orders')
    //     .doc(getOrderID).update({
    //   'riderUID' : sharedPreferences!.getString('uid'),
    //   'riderName' : sharedPreferences!.getString('name'),
    //   'status' : 'picking',
    //   'lat' : position!.latitude.toString(),
    //   'lang' : position!.longitude.toString(),
    //   'address' : completeAddress,
    // });
    //
    // //send rider to shipment screen
    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> ParcelPickingScreen(
    //     purchaserId : purchaserId,
    //     purchaserAddress : model!.fullAddress,
    //     purchaserLat : model!.lat,
    //     purchaserLng : model!.lang,
    //     sellerId : sellerId,
    //     getOrderID : getOrderID,
    // )));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
              'Shipment Details: ' , style: TextStyle(
            color: Colors.black , fontWeight: FontWeight.bold
          ) ,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal:90 , vertical: 5),
          width: MediaQuery.of(context).size.width,
          child: Table(
            children: [
              TableRow(
                children: [
                  const Text(
                    'Name:' ,
                    style: TextStyle(color: Colors.black),
                  ),
                  Text(
                    model!.name! ,
                    style: const TextStyle(color: Colors.black),
                  ),
                ]
              ),
              TableRow(
                  children: [
                    const Text(
                      'Phone Number:' ,
                      style: TextStyle(color: Colors.black),
                    ),
                    Text(
                      model!.phoneNumber! ,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ]
              ),
            ],
          ),
        ),
        const SizedBox(height: 6,),
         const Padding(
           padding: EdgeInsets.all(10.0),
           child: Text(
            'Full address:' ,
            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
        ),
         ),
         Padding(
           padding: const EdgeInsets.only(left: 10.0 , right: 10),
           child: Text(
            model!.fullAddress! ,
            style: const TextStyle(color: Colors.black),
        ),
         ),
        const SizedBox(height: 15,),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Center(
            child: InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const HomeScreen()));
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  decoration:  BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    gradient: const LinearGradient(
                      colors: [Colors.cyan , Colors.amber ],
                      begin: FractionalOffset(0.0,0.0),
                      end: FractionalOffset(1.0,0.0),
                      stops: [0.0 , 1.0],
                      tileMode: TileMode.clamp,
                    ),
                  ),
                  width: MediaQuery.of(context).size.width - 40,
                  height: 50,
                  child:  Center(
                    child: Text(
                      orderStatus == 'ended' ?'Go Back' : 'Order Packing - Done',
                      style: const TextStyle(color: Colors.white , fontSize: 20),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20,)
      ],
    );
  }
}
