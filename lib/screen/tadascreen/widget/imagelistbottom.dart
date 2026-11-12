import 'package:cnattendance/model/attachment.dart';
import 'package:flutter/material.dart';
import 'package:gallery_image_viewer/gallery_image_viewer.dart';

class ItemListBottom extends StatelessWidget{
  List<Attachment> attachments;

  ItemListBottom(this.attachments);
  @override
  Widget build(BuildContext context) {
    final attachList = <Attachment>[];
    for(var attach in attachments){
      if(attach.type == "image"){
        attachList.add(attach);
      }
    }
    return Container(
      padding: EdgeInsets.all(5),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 5.0,
        mainAxisSpacing: 5.0,
        children: List.generate(attachList.length, (index) {
          Attachment item = attachList[index];
          return GestureDetector(
              onTap: () {
                final imageProvider = Image.network(
                    item.url)
                    .image;
                showImageViewer(context, imageProvider,
                    swipeDismissible: true,
                    onViewerDismissed: () {
                      print("dismissed");
                    });
              },
              child: Stack(children: [
                Image.network(
                  item.url,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                    bottom: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: () {

                      },
                      child: Card(
                        elevation: 0,
                        color: Colors.black,
                        shape: CircleBorder(),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.download,color: Colors.white,),
                        ),
                      ),
                    ))
              ]));
        }),
      ),
    );
  }

}