import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:ifood_seller_app/Upload%20Screens/menu_upload_screen.dart';
import 'package:ifood_seller_app/global/global.dart';
import 'package:ifood_seller_app/models/menus_model.dart';
import 'package:ifood_seller_app/widgets/my_drawer.dart';
import 'package:ifood_seller_app/widgets/text_widget.dart';

import '../widgets/info_design.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              sharedPreferences!.getString('photoUrl')!,
              height: 25, width: 25 ,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 8,),
            Text(sharedPreferences!.getString('name')!,
            style: const TextStyle(fontSize: 30 , fontFamily: 'Lobster'),),
          ],
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
              onPressed:(){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const MenusUploadScreen()));
              },
              icon: const Icon(Icons.post_add),
          ),
        ],
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
      ),
      body:  CustomScrollView(
        slivers: [
          SliverPersistentHeader(
              pinned: true ,
              delegate: TextWidgetHeader(title: 'My Menus'),),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('sellers')
                  .doc(sharedPreferences!.getString('uid'))
                  .collection('menus').orderBy('publishedDate' , descending: true)
                  .snapshots(),
              builder: (context ,snapshot){
                return !snapshot.hasData ?
                const SliverToBoxAdapter(
                  child: Center(
                    child: CircularProgressIndicator( color: Colors.cyan,),
                  ),
                ): SliverStaggeredGrid.countBuilder(
                  crossAxisCount: 1 ,
                  staggeredTileBuilder: (c)=> const StaggeredTile.fit(1),
                  itemBuilder: (context , index){
                    Menus sModel = Menus.fromJson(
                        snapshot.data!.docs[index].data()! as Map<String , dynamic>
                    );
                    //design for displaying sellers
                    return InfoDesignWidget(
                      model: sModel,
                      context: context,
                    );
                  },
                  itemCount: snapshot.data!.docs.length,
                );
              }
          ),
        ],
      ),
    );
  }
}
