
import 'package:flutter/material.dart';
// import 'package:photo_puzzles1/data.dart';
// import 'package:photo_puzzles1/third.dart';
import 'package:picpuzzle/data.dart';
import 'package:picpuzzle/picplay.dart';

class second extends StatefulWidget {
  const second({super.key});

  @override
  State<second> createState() => _secondState();
}

class _secondState extends State<second> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GridView.builder(
          itemCount: data.img.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,mainAxisSpacing: 5,crossAxisSpacing: 5),
          itemBuilder: (context, index) {
            return InkWell(onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return third(data.img,index);
              },));
            },
              child: Container(
                decoration: BoxDecoration(image: DecorationImage(image: AssetImage("${data.img[index]}"),fit: BoxFit.fill)),
              ),
            );
          },),
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:picpuzzle/data.dart';
// import 'package:picpuzzle/picplay.dart';
//
// class second extends StatefulWidget {
//   const second({super.key});
//
//   @override
//   State<second> createState() => _secondState();
// }
//
// class _secondState extends State<second> {
//   // int index=0;
//
//   // int index=0;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(
//       // ),
//       body: SafeArea(minimum: EdgeInsets.only(top:5),
//         child: InkWell(onTap:() {
//           Navigator.push(context, MaterialPageRoute(builder: (context) {
//             return third(data.img,index);
//           },));
//         },
//           child: GridView.builder(itemCount: data.img.length,gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 3,mainAxisSpacing: 10,crossAxisSpacing: 10),
//             itemBuilder: (context, index) {
//                 return Container(
//                           decoration: BoxDecoration(
//                             image: DecorationImage(image: AssetImage("${data.img[index]}"),fit: BoxFit.fill),
//                           ),
//                 );
//               },),
//         ),
//       ),
//     );
//   }
// }