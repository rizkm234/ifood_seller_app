import 'package:cloud_firestore/cloud_firestore.dart';

class Items {
  String? itemID ;
  String? sellerUID;
  String? sellerName;
  String? itemTitle;
  String? itemInfo;
  String? itemDescription;
  String? menuID;
  int? itemPrice;
  Timestamp? publishedDate;
  String? thumbnailUrl;
  String? status;

  Items({
    this.itemID,
    this.sellerUID,
    this.sellerName,
    this.itemTitle,
    this.itemInfo,
    this.itemDescription,
    this.menuID,
    this.itemPrice,
    this.publishedDate,
    this.thumbnailUrl,
    this.status,
  });

  Items.fromJson(Map<String , dynamic> json){
    itemID = json['itemID'];
    sellerUID = json['sellerUID'];
    sellerName = json['sellerName'];
    itemTitle = json['itemTitle'];
    itemInfo = json['itemInfo'];
    itemDescription = json['itemDescription'];
    menuID = json['menuID'];
    itemPrice = json['itemPrice'];
    publishedDate = json['publishedDate'];
    thumbnailUrl = json['thumbnailUrl'];
    status = json['status'];
  }

  Map<String , dynamic> toJson(){
    final Map<String , dynamic> data = Map<String , dynamic>();

    data['itemID'] = itemID;
    data['sellerUID'] = sellerUID;
    data['sellerName'] = sellerName;
    data['itemTitle'] = itemTitle;
    data['itemInfo'] = itemInfo;
    data['sellerUID'] = sellerUID;
    data['itemDescription'] = itemDescription;
    data['itemPrice'] = itemPrice;
    data['publishedDate'] = publishedDate;
    data['thumbnailUrl'] = thumbnailUrl;
    data['status'] = status;

    return data;
  }
}