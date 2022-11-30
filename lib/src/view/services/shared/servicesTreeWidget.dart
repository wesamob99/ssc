// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../utilities/hexColor.dart';
import '../../../../../utilities/util.dart';
import '../../../viewModel/services/servicesProvider.dart';
import '../../../viewModel/utilities/theme/themeProvider.dart';
import '../shared/aboutTheServiceScreen.dart';
import '../shared/servicesListConstants.dart';

class ServicesTreeWidget extends StatefulWidget {
  final List<Service> servicesList;
  const ServicesTreeWidget({Key key, @required this.servicesList}) : super(key: key);

  @override
  State<ServicesTreeWidget> createState() => _ServicesTreeWidgetState();
}

class _ServicesTreeWidgetState extends State<ServicesTreeWidget> {

  List supTitles = [];
  @override
  void initState() {
    for (var element in widget.servicesList) {
      if(!supTitles.contains(element.supTitle)){
        supTitles.add(element.supTitle);
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    return Expanded(
      child: ListView.builder(
          itemCount: supTitles.length,
          itemBuilder: (context, index1){
            int last = -1;
            last = widget.servicesList.lastIndexWhere((element) => element.supTitle == supTitles[index1]);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 15),
                  margin: const EdgeInsets.only(bottom: 10.0),
                  decoration: BoxDecoration(
                      color: themeNotifier.isLight()
                          ? HexColor('#F0F2F0') : HexColor('#454545'),
                      borderRadius: BorderRadius.circular(50)
                  ),
                  child: Text(
                    translate(supTitles[index1], context),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: HexColor('#2D452E'),
                        fontSize: width((isTablet(context) || supTitles[index1].length > 20) ? 0.03 : 0.035, context)
                    ),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.servicesList.length,
                  itemBuilder: (context, index2){
                    return widget.servicesList[index2].supTitle == supTitles[index1]
                    ? Column(
                      children: [
                        InkWell(
                          onTap: (){
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => AboutTheServiceScreen(
                                    serviceScreen: widget.servicesList[index2].screen,
                                    serviceTitle: widget.servicesList[index2].title,
                                    aboutServiceDescription: widget.servicesList[index2].description,
                                    termsOfTheService: const [
                                      'موظفي القطاع الخاص',
                                      'موظف موقوف عن العمل',
                                      'لديك 36 اشتراك او رصيد اكثر من 300 د.ا',
                                      'ان تكون قد استفدت من بدل التعطل ثلاث مرات او اقل خلال فتره الشمول',
                                    ],
                                    stepsOfTheService: const [
                                      'التأكد من المعلومات الشخصية لمقدم الخدمة',
                                      'تعبئة طلب الخدمة',
                                      'تقديم الطلب'
                                    ],
                                    /// TODO: send serviceApiCall for each service
                                    serviceApiCall: Provider.of<ServicesProvider>(context).optionalSubGetDetail()
                                  )
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0, bottom: (last != -1 && last != index2) ? 15.0 : 25.0),
                            width: width(1, context),
                            child: Text(
                              translate(widget.servicesList[index2].title, context),
                              style: TextStyle(
                                  fontSize: width(isTablet(context) ? 0.025 : 0.03, context)
                              ),
                            ),
                          ),
                        ),
                        if(last != -1 && last != index2)
                          Divider(
                            color: HexColor('#DEDEDE'),
                            thickness: 1,
                          ),
                      ],
                    ) : const SizedBox.shrink();
                  },
                ),
              ],
            );
          }
      ),
    );
  }
}
