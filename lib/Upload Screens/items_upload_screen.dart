import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ifood_seller_app/global/global.dart';
import 'package:ifood_seller_app/main%20screens/home_screen.dart';
import 'package:ifood_seller_app/main%20screens/items_screen.dart';
import 'package:ifood_seller_app/models/items_model.dart';
import 'package:ifood_seller_app/models/menus_model.dart';
import 'package:ifood_seller_app/widgets/progress_bar.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/error_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart' as storageRef;

class ItemsUploadScreen extends StatefulWidget {
  final Menus? model;
  ItemsUploadScreen({Key? key, this.model}) : super(key: key);

  @override
  State<ItemsUploadScreen> createState() => _ItemsUploadScreenState();
}

class _ItemsUploadScreenState extends State<ItemsUploadScreen> {
  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();
  String menuImageUrl = ' ';
  TextEditingController shortInfoController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  bool uploading = false;
  String uniqueIdName = DateTime.now().millisecondsSinceEpoch.toString();



  defaultScreen(){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Items',
          style: TextStyle(fontSize: 30 , fontFamily: 'Lobster'),),
        centerTitle: true,
        automaticallyImplyLeading: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.cyan , Colors.amber ],
                begin: FractionalOffset(0.0,0.0),
                end: FractionalOffset(1.0,0.0),
                stops: [0.0 , 1.0],
                tileMode: TileMode.clamp,
              )
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back , color: Colors.white,),
          onPressed: (){
            Navigator.pushReplacement(
                context, MaterialPageRoute(
                builder: (context)=> ItemsScreen(model: widget.model,)));
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.cyan , Colors.amber ],
              begin: FractionalOffset(0.0,0.0),
              end: FractionalOffset(1.0,0.0),
              stops: [0.0 , 1.0],
              tileMode: TileMode.clamp,
            )
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:  [
              const Icon(Icons.shop_two , color: Colors.white, size: 200,),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.white),
                  shape:
                  MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  )),
                ),
                onPressed: (){
                  _getImage();
                },
                child: const Text(
                  'Add New Item' ,
                  style: TextStyle(
                      color: Colors.cyan , fontSize: 18
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _getImage() async {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text(
              'Menu Image' ,
              style: TextStyle(
                  color: Colors.cyan ,
                  fontWeight: FontWeight.bold),),
            children:<Widget> [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo',),
                onPressed: () async {
                  Navigator.pop(context);
                  imageXFile  = await _picker.pickImage(source:
                  ImageSource.camera,
                    maxHeight:720 ,
                    maxWidth: 1280,
                  );
                  setState(() {
                    imageXFile;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Select from gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  imageXFile  = await _picker.pickImage(source:
                  ImageSource.gallery,
                    maxHeight:720 ,
                    maxWidth: 1280,
                  );
                  setState(() {
                    imageXFile;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  itemsUploadFormScreen(){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adding new items',
          style: TextStyle(fontSize: 20 , fontFamily: 'Lobster'),),
        centerTitle: true,
        automaticallyImplyLeading: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.cyan , Colors.amber ],
                begin: FractionalOffset(0.0,0.0),
                end: FractionalOffset(1.0,0.0),
                stops: [0.0 , 1.0],
                tileMode: TileMode.clamp,
              )
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back , color: Colors.white,),
          onPressed: (){
            clearMenuUploadForm();
          },
        ),
        actions: [
          TextButton(
              onPressed: (){
                uploading ? null : validateUploadForm();
              },
              child: const Text(
                'Add' ,style: TextStyle(
                color: Colors.cyan ,
                fontSize: 18 ,
                fontWeight: FontWeight.bold,
                fontFamily: 'Varela',
                letterSpacing: 2 ,
              ),
              ))
        ],
      ),
      body: ListView(
        children: [
          uploading  ? linearProgress(): const Text(''),
          Container(
            padding: const EdgeInsets.all(10),
            height: 230,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16/9,
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(
                            File(
                                imageXFile!.path
                            )
                        ),
                        fit: BoxFit.cover,
                      )
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(right: 20 , left: 20),
            child: const Divider(
              color: Colors.grey,
              thickness: 2,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.perm_device_info , color: Colors.cyan,),
            title: Container(
              width: 250,
              child:  TextFormField(
                style: const TextStyle(color: Colors.black),
                controller: shortInfoController,
                decoration: const InputDecoration(
                    hintText: 'Info',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(right: 20 , left: 20),
            child: const Divider(
              color: Colors.grey,
              thickness: 2,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.title , color: Colors.cyan,),
            title: Container(
              width: 250,
              child:  TextFormField(
                style: const TextStyle(color: Colors.black),
                controller: titleController,
                decoration: const InputDecoration(
                    hintText: 'Title',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(right: 20 , left: 20),
            child: const Divider(
              color: Colors.grey,
              thickness: 2,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.description , color: Colors.cyan,),
            title: Container(
              width: 250,
              child:  TextFormField(
                style: const TextStyle(color: Colors.black),
                controller: descriptionController,
                decoration: const InputDecoration(
                    hintText: 'Description',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(right: 20 , left: 20),
            child: const Divider(
              color: Colors.grey,
              thickness: 2,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.money , color: Colors.cyan,),
            title: Container(
              width: 250,
              child:  TextFormField(
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.black),
                controller: priceController,
                decoration: const InputDecoration(
                    hintText: 'Price',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(right: 20 , left: 20),
            child: const Divider(
              color: Colors.grey,
              thickness: 2,
            ),
          ),
        ],
      ),
    );
  }

  clearMenuUploadForm(){
    setState(() {
      shortInfoController.clear();
      titleController.clear();
      descriptionController.clear();
      priceController.clear();
      imageXFile = null;
    });
  }

  validateUploadForm() async {
    if(imageXFile != null){
      if (shortInfoController.text.isNotEmpty
          && titleController.text.isNotEmpty
          && descriptionController.text.isNotEmpty
          &&priceController.text.isNotEmpty
      ){
        setState(() {
          uploading = true;
        });
        //upload data to firebase
        String downloadUrl = await uploadImage(File(imageXFile!.path));
        //save data to firestore
        SaveInfo(downloadUrl);

      }else {
        showDialog(
            context: context,
            builder: (c) {
              return ErrorDialog(
                message: "Please add missing data.",
              );
            });
      }
    }else {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: "Please add a menu image.",
            );
          });
    }
  }

  uploadImage(mImageFile) async {
    storageRef.Reference reference =
    storageRef.
    FirebaseStorage.
    instance.ref().
    child('items');
    storageRef.UploadTask uploadTask =
    reference
        .child('$uniqueIdName.jpg')
        .putFile(mImageFile);
    storageRef.TaskSnapshot taskSnapshot = await uploadTask.whenComplete((){

    });
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl ;
  }

  SaveInfo(String downloadUrl){
    final ref = FirebaseFirestore.instance
        .collection('sellers')
        .doc(sharedPreferences!.getString('uid'))
        .collection('menus').doc(widget.model!.menuID).collection('items');

    final itemsRef = FirebaseFirestore.instance
        .collection('items');

    ref.doc(uniqueIdName).set({
      'itemID' : uniqueIdName,
      'menuID' : widget.model!.menuID,
      'sellerUID': sharedPreferences!.getString('uid'),
      'sellerName': sharedPreferences!.getString('name'),
      'itemInfo' : shortInfoController.text.toString(),
      'itemTitle' : titleController.text.toString(),
      'itemDescription' : descriptionController.text.toString(),
      'itemPrice' : int.parse(priceController.text),
      'publishedDate' : DateTime.now(),
      'status' : 'available',
      'thumbnailUrl' : downloadUrl,
    });

    itemsRef.doc(uniqueIdName).set({
    'itemID' : uniqueIdName,
    'menuID' : widget.model!.menuID,
    'sellerUID': sharedPreferences!.getString('uid'),
    'sellerName': sharedPreferences!.getString('name'),
    'itemInfo' : shortInfoController.text.toString(),
    'itemTitle' : titleController.text.toString(),
    'itemDescription' : descriptionController.text.toString(),
    'itemPrice' : int.parse(priceController.text),
    'publishedDate' : DateTime.now(),
    'status' : 'available',
    'thumbnailUrl' : downloadUrl,});


    clearMenuUploadForm();
    setState(() {
      uniqueIdName = DateTime.now().millisecondsSinceEpoch.toString();
      uploading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return imageXFile == null? defaultScreen()
        :itemsUploadFormScreen();
  }
}
