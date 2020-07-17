/* Home page of the pick and drop worker */
import 'package:background_location/background_location.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:laundry/Classes/UserAuth.dart';
import 'package:laundry/Classes/UserBasic.dart';
import 'package:laundry/Services/AuthServices.dart';
import 'package:laundry/authentication/AuthScreens/Login.dart';
import 'package:laundry/pick_drop_ui/EmpProfile.dart';
import 'package:laundry/pick_drop_ui/pages/attendance.dart';
import 'package:laundry/pick_drop_ui/pages/works.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';


class HomePage extends StatefulWidget {
  final UserBasic userBasic;
  
  const HomePage({Key key, this.userBasic}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  int i = 0;
  FirebaseUser user;
  UserAuth userAuth = UserAuth();
  
  
  
  Widget buildSideMenu(){
    return Container(
      width: 260,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("images/12.jpg"),
            fit: BoxFit.cover
        ),
      ),
      child: Drawer(
        elevation: 0,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 280,
              width: 200,
              child: DrawerHeader(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 118,
                      height:118,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/profile1.png"),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(100.0),
                        border: Border.all(
                          color: Colors.blueGrey[50],
                          width: 6.0,
                        ),
                      ),
                    ),
                    
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Text(
                        "Person Name\nJob - Id",
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.blueGrey[50],
                            fontFamily: "OpenSans",
                            letterSpacing: 1.0
                        ),
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  color: Colors.blueGrey[700],
                ),
              ),
            ),
            CustomListTile(Icons.person,"Profile",()=>
                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context)=> Empprofile(
                          userBasic: widget.userBasic,
                        )
                    )
                )
            ),
            CustomListTile(Icons.question_answer,"FAQ",()=>{}),
            CustomListTile(Icons.description,"Terms & Conditions",()=>{}),
            CustomListTile(Icons.help,"Support",()=>{}),
            CustomListTile(Icons.lock,"Logout",() async{
              try {
                await AuthServices().logOutUser();
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context)=>Login()
                    )
                );
              }catch(e){
              
              }
            }),
          ],
        ),
      ),
    );
  }
  
  void locationPermission() async{
    PermissionStatus f = await BackgroundLocation.checkPermissions();
    
    if(f.value ==0 ){
      await BackgroundLocation.getPermissions(onDenied:(){
        alertPop();
      },onGranted: (){
      
      });
    }
  }
  
  
  alertPop() {
    return showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("Administrator"),
            content: Text("It is Compulsory to give location permission"),
            actions: <Widget>[
              FlatButton(
                child: Text("Ok"),
                onPressed: (){
                  Navigator.pop(context);
                  locationPermission();
                },
              )
            ],
          );
        }
    );
  }
  
  
  @override
  void initState() {
    super.initState();
    locationPermission();
  }
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[700],
        elevation: 8,
        iconTheme: IconThemeData(
          color:Colors.blue[100],
        ),
        title: Text(
          "HOME",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: "OpenSans",
            letterSpacing: 1.0,
            color:Colors.blue[100],
          ),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.notifications,
              color:Colors.blue[100],
            ),
            onPressed: () {},
          ),
        ],
      ),
      drawer: buildSideMenu(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: GridView.count(
          mainAxisSpacing: 5,
          crossAxisCount: 2,
          childAspectRatio: 0.88,
          children: <Widget>[
            ListGrid(widget.userBasic,Icons.work,"TASK",()=>(){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context)=> Work(
                  userBasic: widget.userBasic,
                )),
              );
            },),
            ListGrid(widget.userBasic,Icons.directions_run,"DISTANCE",()=>(){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context)=> attendance(
                  userAuth: userAuth,
                )),
              );
            },),
            ListGrid(widget.userBasic,Icons.access_time,"TIME",()=>(){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context)=> attendance(
                  userAuth: userAuth,
                )),
              );
            },),
            ListGrid(widget.userBasic,Icons.assignment_turned_in,"ATTENDANCE",()=>(){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context)=> attendance(
                  userAuth: userAuth,
                )),
              );
            },),
            ListGrid(widget.userBasic,Icons.history,"HISTORY",()=>(){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context)=> attendance(
                  userAuth: userAuth,
                )),
              );
            },),
          ],
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/12.jpg"),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}

class ListGrid extends StatelessWidget {//Class for grid display of homepage
  final IconData icon;
  final String text;
  final UserBasic userBasic;
  final Function onTap;
  ListGrid(this.userBasic,this.icon,this.text,this.onTap);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:EdgeInsets.all(15.0),
      child: Container(
        padding:  EdgeInsets.all(8),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/laundry.png"),
            fit: BoxFit.fill,
          ),
        ) ,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                text,
                style: TextStyle(
                  color: Color.fromRGBO(88,89,91,1),
                  fontFamily: "OpenSans",
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom:3.0),
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(88,89,91,1),
                  borderRadius: BorderRadius.circular(18.0),
                ),
                child: IconButton(
                    icon: Icon(
                      icon,
                      color: Colors.white,
                      size: 23.0,
                    ),
                    onPressed: onTap()
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {         //Class for items to be displayed in the drawer
  final IconData icon;
  final String text;
  final Function onTap;
  CustomListTile(this.icon,this.text,this.onTap);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade700,
            ),
          ),
        ),
        child: InkWell(
          splashColor: Colors.blue[50],
          onTap: onTap,
          child: Container(
            height: 55,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(icon,
                      color:Color.fromRGBO(88,89,91,1),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        text,
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Color.fromRGBO(88,89,91,1),
                            fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                  ],
                ),
                Icon(Icons.arrow_right,
                  color: Color.fromRGBO(88,89,91,1),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}