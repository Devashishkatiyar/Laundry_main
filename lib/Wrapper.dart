import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:laundry/Classes/UserBasic.dart';
import 'package:laundry/Classes/UserDetails.dart';
import 'package:laundry/Services/SharedPrefs.dart';
import 'package:laundry/authentication/AuthScreens/Login.dart';
import 'package:laundry/authentication/FirebaseStore.dart';
import 'package:laundry/pick_drop_ui/home_page.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
	
	final FireStoreService fireStoreService = FireStoreService();
	String firebaseID;
	
	
	@override
  void initState() {
    super.initState();
    getUserFirebaseId();
  }
  
  Future<String> getUserFirebaseId() async{
		String _firebaseUserID = await SharedPrefs.getStringPreference('uid');
		print(_firebaseUserID);
		this.setState((){
		firebaseID =_firebaseUserID;
		});
		return _firebaseUserID;
  }
	
  @override
  Widget build(BuildContext context) {
    return firebaseID==null
		    ?Login()
		    :StreamBuilder<UserBasic>(
	        stream: fireStoreService.getUserDetails(firebaseID).asStream(),
	        builder: (BuildContext context, snapshot){
	    	    if(snapshot.hasData){
	    	    	print(snapshot.data.phoneNumber);
		        }
		        return HomePage(userBasic: snapshot.data,);
	        },
    );
  }
}
