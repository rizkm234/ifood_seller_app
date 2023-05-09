import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:ifood_seller_app/Upload%20Screens/items_upload_screen.dart';
import 'package:ifood_seller_app/models/items_model.dart';
import 'package:ifood_seller_app/models/menus_model.dart';
import 'package:ifood_seller_app/widgets/my_drawer.dart';
import '../global/global.dart';
import '../widgets/items_design.dart';
import '../widgets/text_widget.dart';

class ItemsScreen extends StatefulWidget {
  final Menus? model;
  const ItemsScreen({Key? key ,  this.model}) : super(key: key);

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(sharedPreferences!.getString('name')!,
              style: const TextStyle(fontSize: 30 , fontFamily: 'Lobster'),),
          ],
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
            onPressed:(){
              Navigator.push(
                  context, MaterialPageRoute(
                  builder: (context)=> ItemsUploadScreen(model: widget.model)
              )
              );
            },
            icon: const Icon(Icons.library_add),
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
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
              pinned:true,
              delegate: TextWidgetHeader(
                  title: 'My ${widget.model!.menuTitle!.toString()}\'s items',
              ),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('sellers')
                  .doc(sharedPreferences!.getString('uid'))
                  .collection('menus').doc(widget.model!.menuID)
                  .collection('items')
                  .orderBy('publishedDate' , descending: true)
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
                    Items model = Items.fromJson(
                        snapshot.data!.docs[index].data()! as Map<String , dynamic>
                    );
                    //design for displaying sellers
                    return ItemsDesignWidget(
                      model: model,
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
