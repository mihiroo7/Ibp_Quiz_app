import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app1/screens/student.dart';
import 'google_login.dart';
import '../services/firebase_services.dart';
import '../services/database.dart';
import 'prof.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {

  @override
  didChangeAppLifecycleState(AppLifecycleState state) async {
    if(AppLifecycleState.paused == state) {
      print('fuck');
      FirebaseFirestore.instance.collection('user').doc(FirebaseAuth.instance.currentUser!.uid.toString()).delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData =  MediaQuery.of(context);
    var size = queryData.size;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Text("Home"),
        ),
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            children: [
              Container(
                height:  size.height*0.3,
                color: Colors.transparent,
              ),
              Container(
                height: size.height*0.1,
                width: size.width*0.9,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(1),
                  borderRadius: BorderRadius.all(Radius.circular(20)) ,
                  boxShadow: [BoxShadow(offset: Offset(0,10),
                              blurRadius: 10,
                              color: Colors.blue.withOpacity(0.4)
                  
                  )],
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent.withOpacity(0),
                    padding: EdgeInsets.only(right: 150.0, bottom: 20.0)
                  ),
                
                  onPressed: () async{
                    bool check = await DatabaseUser(uid: FirebaseAuth.instance.currentUser!.uid.toString()).checkExist();
                    String code;
                    if(check){
                      code = await DatabaseUser(uid : FirebaseAuth.instance.currentUser!.uid.toString()).getdata();
                    }
                    else{
                      code = await DatabaseUser(uid: FirebaseAuth.instance.currentUser!.uid.toString()).Updateuserdata();
                    }
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Profscreen(code: code)));
                  }, 
                  child:Text("Make a Quiz",style: TextStyle(fontSize: 22),),
                  ),
              ),
              Container(
                height: size.height*0.05,
              ),
              Container(
                height: size.height*0.1,
                width: size.width*0.9,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(Radius.circular(20)) ,
                  boxShadow: [BoxShadow(offset: Offset(0,10),
                              blurRadius: 10,
                              color: Colors.blue.withOpacity(0.4)
                  
                  )],
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent.withOpacity(0),
                    padding: EdgeInsets.only(right: 150.0, bottom: 20.0)
                  ),
                  onPressed: (){
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => StudentScreen()));
    
                  }, 
                  child:Text("Attempt a Quiz",style: TextStyle(fontSize: 22),) 
                  ),
              )
            ],
          ),
        ),
      ),
    );
  }
}