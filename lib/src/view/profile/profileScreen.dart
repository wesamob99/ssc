import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../infrastructure/userConfig.dart';
import '../../../infrastructure/userSecuredStorage.dart';
import '../../../utilities/util.dart';
import '../../viewModel/profile/profileProvider.dart';
import '../home/components/homeLoaderWidget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserSecuredStorage userSecuredStorage = UserSecuredStorage.instance;
  Future accountDataFuture;

  @override
  void initState(){
    ProfileProvider profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    accountDataFuture = profileProvider.getAccountData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children:[
            Text(translate('hello', context), style: const TextStyle(fontSize: 14),),
            Text(userSecuredStorage.userName, style: const TextStyle(fontSize: 14),),
          ],
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(UserConfig.instance.checkLanguage() ?  0 : 50),
                bottomRight: Radius.circular(UserConfig.instance.checkLanguage() ?  50 : 0)
            )
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder(
              future: accountDataFuture,
              builder: (context, snapshot){
                if(snapshot.hasData && !snapshot.hasError){
                  dynamic data = snapshot.data['CUR_getdata'][0][0];
                  List<Widget> children = [];
                  data.keys.forEach((key){
                    children.add(
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("$key"),
                          Text(data[key].toString())
                        ],
                      )
                    );
                  });
                  print(data);
                  return SizedBox(
                    height: height(1, context),
                    width: width(1, context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: children,
                    ),
                  );
                } else{
                  return const HomeLoaderWidget();
                }
              }
          ),
        ),
      ),
    );
  }
}
