
import 'dart:io';


import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as imgpic;
import 'package:path_provider/path_provider.dart';
// import 'package:photo_puzzles1/first.dart';

import 'main.dart';

class third extends StatefulWidget {
  List img;
  int index;

  third(this.img, this.index);

  //const third({super.key});

  @override
  State<third> createState() => _thirdState();
}

class _thirdState extends State<third> {
  Uint8List? bytes;
  bool t = false;
  List<imgpic.Image> myList = [];
  List temp = List.filled(9, true);
  List list1 = [];
  List list2 = [];

  List<imgpic.Image> splitImage(imgpic.Image inputImage,
      int horizontalPieceCount, int verticalPieceCount) {
    imgpic.Image image = inputImage;

    final pieceWidth = (image.width / horizontalPieceCount).round();
    final pieceHeight = (image.height / verticalPieceCount).round();
    final pieceList = List<imgpic.Image>.empty(growable: true);

    var x = 0, y = 0;
    for (int i = 0; i < horizontalPieceCount; i++) {
      for (int j = 0; j < verticalPieceCount; j++) {
        pieceList.add(imgpic.copyCrop(image,
            x: x, y: y, width: pieceWidth, height: pieceHeight));
        x = x + pieceWidth;
      }
      x = 0;
      y = y + pieceWidth;
    }

    return pieceList;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.green,
            title: Container(
              height: 120,
              width: 120,
              color: Colors.green,
              alignment: Alignment.center,
              child: Text(
                "Time Limit : 30 Sec",
                style: TextStyle(
                    color: Colors.white, fontFamily: "one", fontSize: 20),
              ),
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    t = true;
                    get();
                    Navigator.pop(context);
                  },
                  child: Text("Play"))
            ],
          );
        },
      );
    });
  }

  get() {
    getImageFileFromAssets("${widget.img[widget.index]}").then((value) {
      // final image = imglib.decodeJpg(value.readAsBytesSync());
      final image = imgpic.decodeJpg(value.readAsBytesSync());
      myList = splitImage(image!, 3, 3);
      for (int i = 0; i < myList.length; i++) {
        list2.add(Image.memory(imgpic.encodeJpg(myList[i])));
      }
      list1.addAll(list2);
      list2.shuffle();
      //myList.shuffle();
      setState(() {});
    });
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.create(recursive: true);
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  @override
  Widget build(BuildContext context) {
    double tot_width = MediaQuery.of(context).size.width;
    double con_wid = (tot_width - 20) / 3;
    return Scaffold(
      body: WillPopScope(onWillPop: () async {
        showDialog(barrierColor: Colors.transparent,barrierDismissible: true,context: context, builder: (context) {
          return AlertDialog(
            alignment: Alignment.center,
            title: Text("Game Exit",style: TextStyle(color: Colors.indigo,fontWeight: FontWeight.bold,fontSize: 15),),
            content: Text("Are you Sure For Exit Game??",style: TextStyle(color: Colors.indigo,fontWeight: FontWeight.bold,fontSize: 15),),
            actions: [
              TextButton(onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return first();
                },));
              }, child: Text("Yes",style: TextStyle(color: Colors.red),)),
              TextButton(onPressed: () {
                Navigator.pop(context);
              }, child: Text("No",style: TextStyle(color: Colors.red),)),
            ],
            scrollable: true,
          );
        },);
        return true;
      },child:(t == false)
          ? Container(
        width: 500,
        height: 500,
        alignment: Alignment.center,
        margin: EdgeInsets.fromLTRB(20, 130, 20, 50),
        decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage("${widget.img[widget.index]}")),
        ),
      )
          : GridView.builder(
        itemCount: list2.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, mainAxisSpacing: 1, crossAxisSpacing: 1),
        itemBuilder: (context, index) {
          // Uint8List testImg = imgpic.encodeJpg(myList[index]);
          return (temp[index])
              ? Draggable(
              onDraggableCanceled: (velocity, offset) {
                print("test");
                temp = List.filled(9, true);
                setState(() {});
              },
              data: index,
              onDragStarted: () {
                temp = List.filled(9, false);
                setState(() {});
              },
              child: Container(
                height: con_wid,
                width: con_wid,
                // decoration: BoxDecoration(
                //     image: DecorationImage(
                //         image: MemoryImage(testImg),
                //         fit: BoxFit.fill)),
                child: list2[index],
              ),
              feedback: Container(
                height: con_wid,
                width: con_wid,
                // decoration: BoxDecoration(
                //     image: DecorationImage(
                //         image: MemoryImage(testImg),
                //         fit: BoxFit.fill)),
                child: list2[index],
              ))
              : DragTarget(
            onAccept: (data) {
              print("data");
              temp = List.filled(9, true);
              var c = list2[data as int];
              list2[data as int] = list2[index];
              list2[index] = c;

              if (listEquals(list2, list1)) {
                print("You Are Win");
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("YOU ARE WIN"),
                      actions: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("OK"))
                      ],
                    );
                  },
                );
              }
              setState(() {});
            },
            builder: (context, candidateData, rajectedData) {
              return Container(
                //color: Colors.pinkAccent,
                // child: Text("${myList[index]}",style: TextStyle(fontSize: 30,color: Colors.white),),
                child: Container(
                  height: con_wid,
                  width: con_wid,
                  // decoration: BoxDecoration(
                  //     image: DecorationImage(
                  //         image: MemoryImage(testImg),
                  //         fit: BoxFit.fill)),
                  child: list2[index],
                ),
                alignment: Alignment.center,
              );
            },
          );
        },
      )
      ),
    );
  }
}

// // import 'dart:io';
// //
// // import 'package:flutter/foundation.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:image/image.dart' as imgpic;
// // import 'package:path_provider/path_provider.dart';
// //
// //
// // class third extends StatefulWidget {
// //   // third(List img, index);
// //   List img;
// //   int index;
// //   third(this.img,this.index);
// //
// //
// //
// //   // const third({super.key});
// //
// //   @override
// //   State<third> createState() => _thirdState();
// // }
// //
// // class _thirdState extends State<third> {
// //   Uint8List ?bytes;
// //   bool t=false;
// //   List<imgpic.Image> myList=[];
// //   List temp=List.filled(9, true);
// //   List list1=[];
// //   List list2=[];
// //
// //
// //   List<imgpic.Image> splitImage(imgpic.Image inputImage, int horizontalPieceCount, int verticalPieceCount) {
// //     imgpic.Image image = inputImage;
// //
// //     final pieceWidth = (image.width / horizontalPieceCount).round();
// //     final pieceHeight = (image.height / verticalPieceCount).round();
// //     final pieceList = List<imgpic.Image>.empty(growable: true);
// //   var x,y;
// //     for (int i=0;i<horizontalPieceCount;i++) {
// //       for (i=0;i<verticalPieceCount;i++)
// //        {
// //         pieceList.add(imgpic.copyCrop(image, x: x, y: y, width: pieceWidth, height: pieceHeight));
// //         x=x+pieceWidth;
// //       }
// //       x=0;
// //       y=y+pieceHeight;
// //     }
// //
// //     return pieceList;
// //   }
// //   @override
// //   void initState() {
// //     // TODO: implement initState
// //     super.initState();
// //
// //     WidgetsBinding.instance.addPostFrameCallback((_) async {
// //       await showDialog(context: context, builder:(context){
// //         return AlertDialog(
// //           backgroundColor: Colors.green.shade900,
// //           title: Container(
// //             height: 120,
// //             width: 120,
// //             color: Colors.green.shade900,
// //             alignment: Alignment.center,
// //             child: Text("Time Limit :30 sec",style: TextStyle(color: Colors.white,fontSize:20,fontFamily: "one" ),),
// //           ),
// //           actions: [
// //             ElevatedButton(onPressed: () {
// //               t=true;
// //               get();
// //               Navigator.pop(context);
// //             }, child: Text("play"))
// //           ],
// //         );
// //       } );
// //     });
// //
// //   }
// //   get(){
// //     getImageFileFromAssets("myassets/${widget.img[widget.index]}").then((value) {
// //       // final image = imgpic.decodeJpg(value.readAsBytesSync());
// //       final image = imgpic.decodeJpg(value.readAsBytesSync());
// //       myList = splitImage(image!,3,3);
// //       for (int i=0;i<myList.length;i++)
// //         {
// //           list2.add(Image.memory(imgpic.encodeJpg(myList[i])));
// //           setState(() {
// //
// //           });
// //         }
// //       list2.addAll(list2);
// //       list2.shuffle();
// //
// //
// //
// //     });
// //
// //
// //   }
// //
// //   Future<File> getImageFileFromAssets(String path) async {
// //     final byteData = await rootBundle.load('$path');
// //
// //     final file = File('${(await getTemporaryDirectory()).path}/$path');
// //     await file.create(recursive: true);
// //     await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
// //
// //     return file;
// //   }
// //   Widget build(BuildContext context) {
// //     double tot_width=MediaQuery.of(context).size.width;
// //     double con_wid=(tot_width-20)/3;
// //     print("Tot:$tot_width");
// //     print("Container wid:$con_wid");
// //     return Scaffold(
// //       body:
// //       (t==false)?
// //
// //       Container(width: 500,
// //         height: 500,
// //         alignment: Alignment.center,
// //         margin: EdgeInsets.fromLTRB(20,130, 20,50),
// //         decoration: BoxDecoration(image: DecorationImage(
// //           fit: BoxFit.fill,image: AssetImage("${widget.img[widget.index]}")),
// //         ),
// //         ):GridView.builder(
// //           itemCount: myList.length,
// //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
// //               crossAxisCount: 3,mainAxisSpacing: 1,crossAxisSpacing: 1),
// //           itemBuilder: (context, index) {
// //             // Uint8List testImg = imgpic.encodeJpg(myList[index]);
// //             return (temp[index]) ?Draggable(onDraggableCanceled: (velocity,offset){
// //               print("test");
// //               temp=List.filled(9, true);
// //               setState(() {
// //               });
// //             },
// //                 data: index,onDragStarted: (){
// //                   temp=List.filled(9, false);
// //                   setState(() {
// //
// //                   });
// //                 },
// //
// //                 child:  Container(
// //                   height: con_wid,
// //                   width: con_wid,
// //                   child: list2[index],
// //
// //                   // decoration: BoxDecoration(image: DecorationImage(image: MemoryImage(testImg),fit: BoxFit.fill)),
// //                 ), feedback:  Container(
// //                   height: con_wid,
// //                   width: con_wid,
// //                   // decoration: BoxDecoration(image: DecorationImage(image: MemoryImage(testImg),fit: BoxFit.fill)),
// //                   child: list2[index],
// //
// //                 )):DragTarget(onAccept: (data){
// //
// //               print("data");
// //               temp=List.filled(9, true);
// //               var c=list2[data as int];
// //               list2[data as int]=list2[index];
// //               list2[index]=c;
// //
// //               if(listEquals(list2, list1)){
// //                 print("You Are Win");
// //                 showDialog(context: context, builder: (context) {
// //                   return AlertDialog(
// //                     title: Text("you are win"),
// //                     actions: [
// //                       ElevatedButton(onPressed: () {
// //                         Navigator.pop(context);
// //                       }, child: Text("OK")),
// //                       // child :Text("OK"),
// //                     ],
// //                   );
// //                 },);
// //               }
// //               setState(() {
// //
// //               });
// //             },builder: (context,candidateData,rajectedData){
// //               return Container(
// //                 //color: Colors.pinkAccent,
// //                 // child: Text("${myList[index]}",style: TextStyle(fontSize: 30,color: Colors.white),),
// //                 child:  Container(
// //                   height: con_wid,
// //                   width: con_wid,
// //                 child: list2[index],
// //                 //   decoration: BoxDecoration(image: DecorationImage(image: MemoryImage(testImg),fit: BoxFit.fill)),
// //                 ),
// //                 // alignment: Alignment.center,
// //               );
// //             },
// //
// //
// //             );
// //
// //           },),
// //       );
// //
// //       // body: SafeArea(minimum: EdgeInsets.only(top:5),
// //         // child:Container(),
// //         //   ),
// //
// //   }
// //
// // }
// //
// //
// //
// //
// //
// //
// import 'dart:io';
//
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:image/image.dart' as imgpic;
// import 'package:path_provider/path_provider.dart';
// // import 'package:photo_puzzles1/first.dart';
//
// import 'main.dart';
//
// class third extends StatefulWidget {
//   List img;
//   int index;
//
//   third(this.img, this.index);
//
//   //const third({super.key});
//
//   @override
//   State<third> createState() => _thirdState();
// }
//
// class _thirdState extends State<third> {
//   Uint8List? bytes;
//   bool t = false;
//   List<imgpic.Image> myList = [];
//   List temp = List.filled(9, true);
//   List list1 = [];
//   List list2 = [];
//
//   List<imgpic.Image> splitImage(imgpic.Image inputImage,
//       int horizontalPieceCount, int verticalPieceCount) {
//     imgpic.Image image = inputImage;
//
//     final pieceWidth = (image.width / horizontalPieceCount).round();
//     final pieceHeight = (image.height / verticalPieceCount).round();
//     final pieceList = List<imgpic.Image>.empty(growable: true);
//
//     var x = 0, y = 0;
//     for (int i = 0; i < horizontalPieceCount; i++) {
//       for (int j = 0; j < verticalPieceCount; j++) {
//         pieceList.add(imgpic.copyCrop(image,
//             x: x, y: y, width: pieceWidth, height: pieceHeight));
//         x = x + pieceWidth;
//       }
//       x = 0;
//       y = y + pieceWidth;
//     }
//
//     return pieceList;
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             backgroundColor: Colors.green,
//             title: Container(
//               height: 120,
//               width: 120,
//               color: Colors.green,
//               alignment: Alignment.center,
//               child: Text(
//                 "Time Limit : 30 Sec",
//                 style: TextStyle(
//                     color: Colors.white, fontFamily: "one", fontSize: 20),
//               ),
//             ),
//             actions: [
//               ElevatedButton(
//                   onPressed: () {
//                     t = true;
//                     get();
//                     Navigator.pop(context);
//                   },
//                   child: Text("Play"))
//             ],
//           );
//         },
//       );
//     });
//   }
//
//   get() {
//     getImageFileFromAssets("${widget.img[widget.index]}").then((value) {
//       // final image = imglib.decodeJpg(value.readAsBytesSync());
//       final image = imgpic.decodeJpg(value.readAsBytesSync());
//       myList = splitImage(image!, 3, 3);
//       for (int i = 0; i < myList.length; i++) {
//         list2.add(Image.memory(imgpic.encodeJpg(myList[i])));
//       }
//       list1.addAll(list2);
//       list2.shuffle();
//       //myList.shuffle();
//       setState(() {});
//     });
//   }
//
//   Future<File> getImageFileFromAssets(String path) async {
//     final byteData = await rootBundle.load('$path');
//
//     final file = File('${(await getTemporaryDirectory()).path}/$path');
//     await file.create(recursive: true);
//     await file.writeAsBytes(byteData.buffer
//         .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
//
//     return file;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double tot_width = MediaQuery.of(context).size.width;
//     double con_wid = (tot_width - 20) / 3;
//     return Scaffold(
//       body: WillPopScope(onWillPop: () async {
//         showDialog(barrierColor: Colors.transparent,barrierDismissible: true,context: context, builder: (context) {
//           return AlertDialog(
//             alignment: Alignment.center,
//             title: Text("Game Exit",style: TextStyle(color: Colors.indigo,fontWeight: FontWeight.bold,fontSize: 15),),
//             content: Text("Are you Sure For Exit Game??",style: TextStyle(color: Colors.indigo,fontWeight: FontWeight.bold,fontSize: 15),),
//             actions: [
//               TextButton(onPressed: () {
//                 Navigator.push(context, MaterialPageRoute(builder: (context) {
//                   return first();
//                 },));
//               }, child: Text("Yes",style: TextStyle(color: Colors.red),)),
//               TextButton(onPressed: () {
//                 Navigator.pop(context);
//               }, child: Text("No",style: TextStyle(color: Colors.red),)),
//             ],
//             scrollable: true,
//           );
//         },);
//         return true;
//       },child:(t == false)
//           ? Container(
//         width: 500,
//         height: 500,
//         alignment: Alignment.center,
//         margin: EdgeInsets.fromLTRB(20, 130, 20, 50),
//         decoration: BoxDecoration(
//           image: DecorationImage(
//               fit: BoxFit.fill,
//               image: AssetImage("${widget.img[widget.index]}")),
//         ),
//       )
//           : GridView.builder(
//         itemCount: list2.length,
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 3, mainAxisSpacing: 1, crossAxisSpacing: 1),
//         itemBuilder: (context, index) {
//           // Uint8List testImg = imgpic.encodeJpg(myList[index]);
//           return (temp[index])
//               ? Draggable(
//               onDraggableCanceled: (velocity, offset) {
//                 print("test");
//                 temp = List.filled(9, true);
//                 setState(() {});
//               },
//               data: index,
//               onDragStarted: () {
//                 temp = List.filled(9, false);
//                 setState(() {});
//               },
//               child: Container(
//                 height: con_wid,
//                 width: con_wid,
//                 // decoration: BoxDecoration(
//                 //     image: DecorationImage(
//                 //         image: MemoryImage(testImg),
//                 //         fit: BoxFit.fill)),
//                 child: list2[index],
//               ),
//               feedback: Container(
//                 height: con_wid,
//                 width: con_wid,
//                 // decoration: BoxDecoration(
//                 //     image: DecorationImage(
//                 //         image: MemoryImage(testImg),
//                 //         fit: BoxFit.fill)),
//                 child: list2[index],
//               ))
//               : DragTarget(
//             onAccept: (data) {
//               print("data");
//               temp = List.filled(9, true);
//               var c = list2[data as int];
//               list2[data as int] = list2[index];
//               list2[index] = c;
//
//               if (listEquals(list2, list1)) {
//                 print("You Are Win");
//                 showDialog(
//                   context: context,
//                   builder: (context) {
//                     return AlertDialog(
//                       title: Text("YOU ARE WIN"),
//                       actions: [
//                         ElevatedButton(
//                             onPressed: () {
//                               Navigator.pop(context);
//                             },
//                             child: Text("OK"))
//                       ],
//                     );
//                   },
//                 );
//               }
//               setState(() {});
//             },
//             builder: (context, candidateData, rajectedData) {
//               return Container(
//                 //color: Colors.pinkAccent,
//                 // child: Text("${myList[index]}",style: TextStyle(fontSize: 30,color: Colors.white),),
//                 child: Container(
//                   height: con_wid,
//                   width: con_wid,
//                   // decoration: BoxDecoration(
//                   //     image: DecorationImage(
//                   //         image: MemoryImage(testImg),
//                   //         fit: BoxFit.fill)),
//                   child: list2[index],
//                 ),
//                 alignment: Alignment.center,
//               );
//             },
//           );
//         },
//       )
//       ),
//     );
//   }
// }
// import 'dart:io';
//
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:image/image.dart' as imgpic;
// import 'package:path_provider/path_provider.dart';
// import 'package:photo_puzzles1/first.dart';
//
// class third extends StatefulWidget {
//   List img;
//   int index;
//
//   third(this.img, this.index);
//
//   //const third({super.key});
//
//   @override
//   State<third> createState() => _thirdState();
// }
//
// class _thirdState extends State<third> {
//   Uint8List? bytes;
//   bool t = false;
//   List<imgpic.Image> myList = [];
//   List temp = List.filled(9, true);
//   List list1 = [];
//   List list2 = [];
//
//   List<imgpic.Image> splitImage(imgpic.Image inputImage,
//       int horizontalPieceCount, int verticalPieceCount) {
//     imgpic.Image image = inputImage;
//
//     final pieceWidth = (image.width / horizontalPieceCount).round();
//     final pieceHeight = (image.height / verticalPieceCount).round();
//     final pieceList = List<imgpic.Image>.empty(growable: true);
//
//     var x = 0, y = 0;
//     for (int i = 0; i < horizontalPieceCount; i++) {
//       for (int j = 0; j < verticalPieceCount; j++) {
//         pieceList.add(imgpic.copyCrop(image,
//             x: x, y: y, width: pieceWidth, height: pieceHeight));
//         x = x + pieceWidth;
//       }
//       x = 0;
//       y = y + pieceWidth;
//     }
//
//     return pieceList;
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             backgroundColor: Colors.green,
//             title: Container(
//               height: 120,
//               width: 120,
//               color: Colors.green,
//               alignment: Alignment.center,
//               child: Text(
//                 "Time Limit : 30 Sec",
//                 style: TextStyle(
//                     color: Colors.white, fontFamily: "one", fontSize: 20),
//               ),
//             ),
//             actions: [
//               ElevatedButton(
//                   onPressed: () {
//                     t = true;
//                     get();
//                     Navigator.pop(context);
//                   },
//                   child: Text("Play"))
//             ],
//           );
//         },
//       );
//     });
//   }
//
//   get() {
//     getImageFileFromAssets("myassets/${widget.img}/${widget.index}").then((value) {
//       // final image = imglib.decodeJpg(value.readAsBytesSync());
//       final image = imgpic.decodeJpg(value.readAsBytesSync());
//       myList = splitImage(image!, 3, 3);
//       for (int i = 0; i < myList.length; i++) {
//         list2.add(Image.memory(imgpic.encodeJpg(myList[i])));
//       }
//       list2.addAll(list1);
//       list2.shuffle();
//       //myList.shuffle();
//       setState(() {});
//     });
//   }
//
//   Future<File> getImageFileFromAssets(String path) async {
//     final byteData = await rootBundle.load('$path');
//
//     final file = File('${(await getTemporaryDirectory()).path}/$path');
//     await file.create(recursive: true);
//     await file.writeAsBytes(byteData.buffer
//         .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
//
//     return file;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double tot_width = MediaQuery.of(context).size.width;
//     double con_wid = (tot_width - 20) / 3;
//     return Scaffold(
//       body: WillPopScope(onWillPop: () async {
//       showDialog(barrierColor: Colors.transparent,barrierDismissible: true,context: context, builder: (context) {
//         return AlertDialog(
//           alignment: Alignment.center,
//           title: Text("Game Exit",style: TextStyle(color: Colors.indigo,fontWeight: FontWeight.bold,fontSize: 15),),
//           content: Text("Are you Sure For Exit Game??",style: TextStyle(color: Colors.indigo,fontWeight: FontWeight.bold,fontSize: 15),),
//           actions: [
//             TextButton(onPressed: () {
//               Navigator.push(context, MaterialPageRoute(builder: (context) {
//                 return first();
//               },));
//             }, child: Text("Yes",style: TextStyle(color: Colors.red),)),
//             TextButton(onPressed: () {
//               Navigator.pop(context);
//             }, child: Text("No",style: TextStyle(color: Colors.red),)),
//           ],
//           scrollable: true,
//         );
//       },);
//       return true;
//     },child:(t == false)
//           ? Container(
//               width: 500,
//               height: 500,
//               alignment: Alignment.center,
//               margin: EdgeInsets.fromLTRB(20, 130, 20, 50),
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                     fit: BoxFit.fill,
//                     image: AssetImage("${widget.img[widget.index]}")),
//               ),
//             )
//           : GridView.builder(
//               itemCount: list2.length,
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 3, mainAxisSpacing: 1, crossAxisSpacing: 1),
//               itemBuilder: (context, index) {
//                 // Uint8List testImg = imgpic.encodeJpg(myList[index]);
//                 return (temp[index])
//                     ? Draggable(
//                         onDraggableCanceled: (velocity, offset) {
//                           print("test");
//                           temp = List.filled(9, true);
//                           setState(() {});
//                         },
//                         data: index,
//                         onDragStarted: () {
//                           temp = List.filled(9, false);
//                           setState(() {});
//                         },
//                         child: Container(
//                           height: con_wid,
//                           width: con_wid,
//                           // decoration: BoxDecoration(
//                           //     image: DecorationImage(
//                           //         image: MemoryImage(testImg),
//                           //         fit: BoxFit.fill)),
//                           child: list2[index],
//                         ),
//                         feedback: Container(
//                           height: con_wid,
//                           width: con_wid,
//                           // decoration: BoxDecoration(
//                           //     image: DecorationImage(
//                           //         image: MemoryImage(testImg),
//                           //         fit: BoxFit.fill)),
//                           child: list2[index],
//                         ))
//                     : DragTarget(
//                         onAccept: (data) {
//                           print("data");
//                           temp = List.filled(9, true);
//                           var c = list2[data as int];
//                           list2[data as int] = list2[index];
//                           list2[index] = c;
//
//                           if (listEquals(list2, list1)) {
//                             print("You Are Win");
//                             showDialog(
//                               context: context,
//                               builder: (context) {
//                                 return AlertDialog(
//                                   title: Text("YOU ARE WIN"),
//                                   actions: [
//                                     ElevatedButton(
//                                         onPressed: () {
//                                           Navigator.pop(context);
//                                         },
//                                         child: Text("OK"))
//                                   ],
//                                 );
//                               },
//                             );
//                           }
//                           setState(() {});
//                         },
//                         builder: (context, candidateData, rajectedData) {
//                           return Container(
//                             //color: Colors.pinkAccent,
//                             // child: Text("${myList[index]}",style: TextStyle(fontSize: 30,color: Colors.white),),
//                             child: Container(
//                               height: con_wid,
//                               width: con_wid,
//                               // decoration: BoxDecoration(
//                               //     image: DecorationImage(
//                               //         image: MemoryImage(testImg),
//                               //         fit: BoxFit.fill)),
//                               child: list2[index],
//                             ),
//                             alignment: Alignment.center,
//                           );
//                         },
//                       );
//               },
//       )
//             ),
//     );
//   }
// }