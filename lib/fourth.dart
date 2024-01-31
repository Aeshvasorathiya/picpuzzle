import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class fourth extends StatefulWidget {

  // const fourth({super.key});

  @override
  State<fourth> createState() => _fourthState();
}

class _fourthState extends State<fourth> {
  List list = ['A','B','C','D','E','F','G','H','I'];
  List list1=[];
  List temp=List.filled(9, true);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  Widget build(BuildContext context) {
    double tot_width=MediaQuery.of(context).size.width;
    double con_wid=(tot_width-20)/3;
    print("Tot:$tot_width");
    print("Container wid:$con_wid");
    return Scaffold(
      body: GridView.builder(itemCount: list.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,crossAxisSpacing: 10,mainAxisSpacing: 10),
        itemBuilder: (context, index) {
          return (temp[index]) ? Draggable(onDraggableCanceled: (velocity,offset){
            print("test");
            temp=List.filled(9, true);
            setState(() {
            });
          },
            data: index,onDragStarted: (){
              temp=List.filled(9, false);
              setState(() {

              });
            },
            child: Container(
              height: con_wid,
              width: con_wid,
              color:Colors.indigo,
              child: Text("${list[index]}",style: TextStyle(fontSize: 30,color: Colors.white),),
              alignment: Alignment.center,
            ),feedback: Container(
              height: con_wid,
              width: con_wid,
              color:Colors.green,
              child: Text("${list[index]}",style: TextStyle(fontSize: 30,color: Colors.white),),
              alignment: Alignment.center,
            ),
          ):DragTarget(onAccept: (data){
            print(data);
            temp=List.filled(9, true);
            var c=list[data as int];
            list[data as int]=list[index];
            list[index]=c;

            if(listEquals(list, list1)){
              print("You Are Win");
            }
            setState(() {

            });

          },builder: (context,candidateData,rajectedData){
            return Container(
              color: Colors.pinkAccent,
              child: Text("${list[index]}",style: TextStyle(fontSize: 30,color: Colors.white),),
              alignment: Alignment.center,
            );
          },
          );
        },),
    );
  }
}
