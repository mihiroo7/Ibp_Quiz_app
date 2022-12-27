import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app1/screens/createque.dart';
import 'package:quiz_app1/screens/home_screen.dart';
import 'package:quiz_app1/services/database.dart';
import 'package:d_chart/d_chart.dart';

showAlertDialog2(BuildContext context, String code) async{

  Widget okButton = TextButton(
    child: Text("Agree"),
    onPressed: () async {
                  await DatabaseQue(code: code).Updateque(['no question']);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomeScreen())); 
     },
  );

  AlertDialog alert = AlertDialog(
    title: Text("Note"),
    content: Text("Going back will discard this quiz"),
    actions: [
      okButton,
    ],
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}



class Profscreen extends StatefulWidget{
  String code;
  Profscreen({Key ? key, required this.code}) :super(key: key);
  @override
  _ProfscreenState createState() => _ProfscreenState(code: code);
}

class _ProfscreenState extends State<Profscreen>{
  String code;
  _ProfscreenState({required this.code});
  @override
  Widget build(BuildContext context){
    MediaQueryData queryData =  MediaQuery.of(context);
    var size = queryData.size;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text("Code : "+code),
            leading: BackButton(
              onPressed: () async {
                showAlertDialog2(context, code);
  
              }),
          ),
          body: ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: [
              StreamBuilder<DocumentSnapshot<Object?>>(
                stream: DatabaseQue(code: code).queresult,
                builder: (context, snapshot) {
                  if(!snapshot.hasData){
                    return CircularProgressIndicator();
                  }
                  var snapi = snapshot.data!.data() as Map<String, Object?>;
                  final x = snapi.keys.toList();
                  var y = [];
                  for(var i=0; i<x.length ; i++){
                    if(x[i]=='que' || x[i][0]=='~' || x[i]=='code'){
                      y.add(x[i]);
                    }
                  }
                  for(var i in y){
                    x.remove(i);
                  }
                  x.sort();
                  return Container(
                    width: size.width*0.9,
                    child: ListView(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      children: <Widget>[
                        Container(
                          height: size.height*0.06,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top : 8.0),
                          child: Container(
                            width: size.width*0.9,
                            // height: size.height*0.1,
                            padding: EdgeInsets.only(left: 15, bottom: 10, top: 10, right: 15),
                            decoration: BoxDecoration(
                              color: Colors.yellow,
                                              borderRadius: BorderRadius.all(Radius.circular(20)) ,
                  boxShadow: [BoxShadow(offset: Offset(0,10),
                                blurRadius: 10,
                                color: Colors.yellow.withOpacity(0.4)
                  
                  )],
                            ),
                            child: Text(snapi['que'].toString(),style: TextStyle(fontSize: 18),)
                            ),
                        ),
                        for(var i in x)
                         Padding(
                           padding: const EdgeInsets.only(top :8.0),
                           child: Container(
                            width: size.width*0.9,
                            padding: EdgeInsets.only(left: 15, bottom: 10, top: 10, right: 15),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                                              borderRadius: BorderRadius.all(Radius.circular(20)) ,
                  boxShadow: [BoxShadow(offset: Offset(0,10),
                                blurRadius: 10,
                                color: Colors.blue.withOpacity(0.4)
                  
                  )],
                            ),
                            child: Text(snapi[i].toString(),style: TextStyle(fontSize: 18),)
                              ),
                         )
                      ],
                    ),
                  );
                }
              ),
              StreamBuilder<DocumentSnapshot<Object?>>(
                stream: DatabaseQue(code: code).result,
                builder: ((context, snapshot){
                  if(!snapshot.hasData){
                    return CircularProgressIndicator();
                  }
                  var data = snapshot.data!.data() as Map<String, Object?>;
                  var find = snapshot.data!.data() as Map<String, Object?>;
                  var y=[];
                  for(var i in data.keys){
                    if(i[0]!='~'){
                      y.add(i);
                    }
                  }
                  var d  = data.keys.toList();
                  for(var i in y){
                    d.remove(i);
                  }
                  d.sort();
                  List<Map<String,Object?>> xdata=[];
                  for(var i in d){
                    var y = {'domain': 'dummy','measure' : 0};
                    y['domain']=i;
                    y['measure']= find[i] as int;
                    xdata.add(y);
                  }
                  return Container(
                    height : size.height*0.5,
                    child: DChartBar(
                        data: [
                            {
                                'id': 'Bar',
                                'data': xdata,
                            },
                        ],
                        domainLabelPaddingToAxisLine: 16,
                        axisLineTick: 2,
                        axisLinePointTick: 2,
                        axisLinePointWidth: 10,
                        axisLineColor: Colors.yellow,
                        measureLabelPaddingToAxisLine: 16,
                        barColor: (barData, index, id) => Colors.blue,
                        showBarValue: true,
                    ),
                    
                  );
                } ),
                ),
              ElevatedButton(
                onPressed: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CreateQue(code: code)));                                
                }, 
                child: Text("Set Question")
                ),
            ],
    
          ),
    
      ),
    );
  }
}