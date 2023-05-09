import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ifood_seller_app/global/global.dart';
import 'package:ifood_seller_app/main%20screens/home_screen.dart';
import 'package:ifood_seller_app/widgets/progress_bar.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/error_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart' as storageRef;

class MenusUploadScreen extends StatefulWidget {
  const MenusUploadScreen({Key? key}) : super(key: key);

  @override
  State<MenusUploadScreen> createState() => _MenusUploadScreenState();
}

class _MenusUploadScreenState extends State<MenusUploadScreen> {
  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();
  String menuImageUrl = ' ';
  TextEditingController shortInfoController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  bool uploading = false;
  String uniqueIdName = DateTime.now().millisecondsSinceEpoch.toString();



  defaultScreen(){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Menu',
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
                builder: (context)=>const HomeScreen()));
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
                    'Add New Menu' ,
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

  menusUploadFormScreen(){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Uploading New Menu',
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
                  hintText: 'menu info',
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
                  hintText: 'menu title',
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
      imageXFile = null;
    });
  }

  validateUploadForm() async {
    if(imageXFile != null){
      if (shortInfoController.text.isNotEmpty && titleController.text.isNotEmpty){
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
        child('menus');
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
         .collection('menus');

     ref.doc(uniqueIdName).set({
       'menuID' : uniqueIdName,
       'sellerUID' : sharedPreferences!.getString('uid'),
       'menuInfo' : shortInfoController.text.toString(),
       'menuTitle' : titleController.text.toString(),
       'publishedDate' : DateTime.now(),
       'status' : 'available',
       'thumbnailUrl' : downloadUrl,
     });

     clearMenuUploadForm();
     setState(() {
       uniqueIdName = DateTime.now().millisecondsSinceEpoch.toString();
       uploading = false;
     });
  }

  @override
  Widget build(BuildContext context) {
    return imageXFile == null? defaultScreen()
        :menusUploadFormScreen();
  }
}
