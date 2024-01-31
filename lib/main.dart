 777import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:picpuzzle/add.dart';
import 'package:picpuzzle/openphoto.dart';

void main()
{
  runApp(MaterialApp(
    home: first(),
    debugShowCheckedModeBanner: false,
  ));
}
class first extends StatefulWidget {
  const first({super.key});

  @override
  State<first> createState() => _firstState();

}

class _firstState extends State<first> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.only(top: 5),
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,

              child: GridView.builder(itemCount: 98,gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:
              7,
              mainAxisSpacing: 0,
              crossAxisSpacing: 0),
                  itemBuilder: (context,index){
                return Container(decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("myassets/wood_block.jpg"),
                    fit: BoxFit.fill,
                  ),
                ),);
                  }),
            ),
            Container(
              // margin: EdgeInsets.all(50),
              child: Column(
                children: [

                  Expanded(flex: 4,child: Text(""),),
                  Expanded(flex: 2,child: Center(

                    child: Text("PHOTO",style: TextStyle(color: Colors.white,
                    fontSize: 70,fontFamily: "three"),),
                  )),
                  Expanded(flex: 1,child:Container(
                    // margin: EdgeInsets.only(bottom: 20),
                    height: 5,
                    width: double.infinity,
                    color: Colors.brown,
                    alignment: Alignment.center,
                    child: Text("play with photos",style: TextStyle(color: Colors.amberAccent,fontSize: 30,fontFamily: "one"),),
                  ) ),
                  Expanded(flex: 1,child:Container(
                    margin: EdgeInsets.only(top: 2,bottom: 0),
                    height: 5,
                    width: double.infinity,
                    // color: Colors.brown,
                    alignment: Alignment.center,
                    child: Text("PUZZLES",style: TextStyle(color: Colors.lightGreenAccent,fontSize: 70,fontFamily: "three"),),
                  ) ),
                  Expanded(child: Text("")),
                  Expanded(child: Text("")),

                  Expanded(child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          child: InkWell(onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return open();
                            },));
                          },
                            child: Container(
                              height: 200,
                              width: 200,
                              // margin: EdgeInsets.all(2),
                              // height: double.infinity,
                              // width: double.infinity,
                              decoration: BoxDecoration(
                                image: DecorationImage(image: AssetImage("myassets/wood_but.png"),),

                              ),
                              child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(height: 8,),

                                  Text("Open Photos",style: TextStyle(color: Colors.white,fontFamily: "three",fontSize: 15),),
                                  Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(bottom: 5),

                                        height: 25,
                                        width: 25,
                                        decoration: BoxDecoration(image: DecorationImage(
                                          image: AssetImage("myassets/gallery_icon.png")
                                        )),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return second();
                          },));
                        },
                          child: Container(
                            // // margin: EdgeInsets.all(5),
                            height: 200,
                            width: 200,
                            // height: double.infinity,
                            // width: double.infinity,
                            decoration: BoxDecoration(
                                image: DecorationImage(image: AssetImage("myassets/wood_but.png"))
                            ),
                            child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(height: 8,),
                                Text("App Photos",style: TextStyle(color: Colors.white,fontFamily: "three",fontSize: 15),),
                                Column(
                                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(bottom: 5),
                                      height: 25,
                                      width: 25,
                                      decoration: BoxDecoration(image: DecorationImage(
                                          image: AssetImage("myassets/app_images.png")
                                      )),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
                  Expanded(child: Text("")),

                  Expanded(child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        margin: EdgeInsets.all(5),
                        height: 100,
                        width: 50,
                        decoration: BoxDecoration(
                            image: DecorationImage(image: AssetImage("myassets/wood_but.png"),fit: BoxFit.fill)
                        ),
                      child:  Container(
                        margin: EdgeInsets.all(5),
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(image: DecorationImage(
                              image: AssetImage("myassets/sound_on.png")
                          )),
                        ),
                      ),
                      // Expanded(
                      //   child: Container(
                      //     height: 40,
                      //     width: 40,
                      //     decoration: BoxDecoration(
                      //         image: DecorationImage(image: AssetImage(""))
                      //     ),
                      //   ),
                      // ),
                      Container(
                        margin: EdgeInsets.all(5),

                        height: 100,
                        width: 50,
                        decoration: BoxDecoration(
                            image: DecorationImage(image: AssetImage("myassets/wood_but.png"),fit: BoxFit.fill)
                        ),
                        child:  Container(
                          margin: EdgeInsets.all(5),
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(image: DecorationImage(
                              image: AssetImage("myassets/star_p_new.png"),
                          )),
                        ),

                      ),
                      // Expanded(
                      //   child: Container(
                      //     height: 40,
                      //     width: 40,
                      //     decoration: BoxDecoration(
                      //         image: DecorationImage(image: AssetImage(""))
                      //     ),
                      //   ),
                      // ),
                      Container(
                        margin: EdgeInsets.all(5),

                        height: 100,
                        width: 50,
                        decoration: BoxDecoration(
                            image: DecorationImage(image: AssetImage("myassets/wood_but.png"),fit: BoxFit.fill)
                        ),
                        child:  Container(
                          margin: EdgeInsets.all(5),
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(image: DecorationImage(
                              image: AssetImage("myassets/share.png")
                          )),
                        ),

                      ),
                    ],
                  )),
                  // Expanded(child: Text("")),


                ],
              ),
            ),

          ],
        ),
      ),

    );
  }
}
