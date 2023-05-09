import 'package:flutter/material.dart';
import '../main screens/item_detail_screen.dart';
import '../models/items_model.dart';

class ItemsDesignWidget extends StatefulWidget {
  final Items? model ;
  BuildContext? context;
  ItemsDesignWidget({Key? key ,
    this.model ,
    this.context
  }) : super(key: key);

  @override
  State<ItemsDesignWidget> createState() => _ItemsDesignWidgetState();
}

class _ItemsDesignWidgetState extends State<ItemsDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator
            .push(
            context, MaterialPageRoute(
            builder: (context)=>
                ItemDetailScreen(model: widget.model)));
      },
      splashColor: Colors.amber,
      child: Container(
        height: 300,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            // Divider(
            //   height: 4,
            //   thickness: 3,
            //   color: Colors.grey[300],
            // ),
            // const SizedBox(height: 10,),
            Image.network(widget.model!.thumbnailUrl! ,
              height: 220, width: double.infinity,
              fit: BoxFit.cover,),
            const SizedBox(height: 1,),
            Text(widget.model!.itemTitle! ,
              style: const TextStyle(
                  color: Colors.cyan,
                  fontSize: 20,
                  fontFamily: 'Train'
              ),
            ),
            Text(widget.model!.itemInfo! ,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
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
