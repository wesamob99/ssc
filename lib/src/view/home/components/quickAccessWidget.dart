// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:ssc/src/view/services/shared/aboutTheServiceScreen.dart';
import 'package:ssc/src/view/services/shared/servicesListConstants.dart';
import 'package:ssc/src/viewModel/home/homeProvider.dart';

import '../../../../infrastructure/userConfig.dart';
import '../../../../utilities/hexColor.dart';
import '../../../../utilities/util.dart';

class QuickAccessWidget extends StatefulWidget {
  const QuickAccessWidget({Key key}) : super(key: key);

  @override
  State<QuickAccessWidget> createState() => _QuickAccessWidgetState();
}

class _QuickAccessWidgetState extends State<QuickAccessWidget> {
  @override
  Widget build(BuildContext context) {
    HomeProvider homeProviderListener = Provider.of<HomeProvider>(context);
    List<Service> quickAccessServices = ServicesList.quickAccessServices;

    return SizedBox(
      height: homeProviderListener.isQuickAccessListEmpty && !homeProviderListener.isEditQuickAccessActive
         ? height(isScreenHasSmallHeight(context) ? 0.08 : 0.06, context)
         : height(isScreenHasSmallHeight(context) ? 0.14 : 0.12, context),
      child: homeProviderListener.isQuickAccessListEmpty && !homeProviderListener.isEditQuickAccessActive
        ? Container(
          width: width(1, context),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                translate('emptyList', context),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14
                ),
              ),
              const SizedBox(height: 3.0),
              Text(
                translate('emptyListDesc', context),
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ],
          )
        )
        : ListView.builder(
          itemCount: quickAccessServices.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index){
            return quickAccessServices[index].isSelected || (!quickAccessServices[index].isSelected && homeProviderListener.isEditQuickAccessActive)
              ? Row(
              children: [
                InkWell(
                  onTap: (){
                    if(!homeProviderListener.isEditQuickAccessActive) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AboutTheServiceScreen(
                            serviceScreen: quickAccessServices[index].screen,
                            serviceTitle: quickAccessServices[index].title,
                            aboutServiceDescription: quickAccessServices[index].description,
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
                          ),
                        ),
                      );
                    } else{
                      setState((){
                        quickAccessServices[index].isSelected = !quickAccessServices[index].isSelected;
                      });

                      List<String> items = UserConfig.instance.getQuickAccessItems();

                      for (var element in quickAccessServices) {
                        if(element.isSelected && !items.contains(element.title)){
                          items.add(element.title);
                        }else if(!element.isSelected && items.contains(element.title)){
                          items.remove(element.title);
                        }
                      }
                      UserConfig.instance.setQuickAccessItems(items);
                      homeProviderListener.isQuickAccessListEmpty = items.isEmpty;
                      homeProviderListener.notifyMe();
                    }
                  },
                  highlightColor: const Color.fromRGBO(68, 87, 64, 0.4),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Card(
                              elevation: 5.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              margin: EdgeInsets.symmetric(vertical: 3.0, horizontal: isTablet(context) ? 5.0 : 0),
                              shadowColor: const Color.fromRGBO(45, 69, 46, 0.28),
                              color: HexColor('#FFFFFF'),
                              child: Padding(
                                padding: EdgeInsets.all(isTablet(context) ? 17.0 : 14.0),
                                child: SvgPicture.asset(
                                  quickAccessServices[index].icon,
                                  color: !quickAccessServices[index].isSelected ? Colors.black26 : HexColor('#946800'),
                                  width: isTablet(context) ? 48 : 32,
                                  height: isTablet(context) ? 48 : 32,
                                ),
                              )
                          ),
                          if(homeProviderListener.isEditQuickAccessActive)
                            Container(
                              margin: const EdgeInsets.all(5.0).copyWith(top: 7.0),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(25.0),
                                  border: Border.all(
                                    color: quickAccessServices[index].isSelected ? HexColor('#BC0D0D') : HexColor('#003C97'),
                                  )
                              ),
                              child: Icon(
                                quickAccessServices[index].isSelected ? Icons.remove : Icons.add,
                                color: quickAccessServices[index].isSelected ? HexColor('#BC0D0D') : HexColor('#003C97'),
                                size: isTablet(context) ? 36 : 20,
                              ),
                            ),
                        ],
                      ),
                      SizedBox(
                        width: isTablet(context) ? 90.0 : 65.0,
                        child: Text(
                          translate(quickAccessServices[index].title, context),
                          textAlign: TextAlign.center,
                          maxLines: isScreenHasSmallHeight(context) ? 2 : 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: height(0.012, context),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: width(index != quickAccessServices.length-1 ? 0.006 : 0, context))
              ],
            )
                : const SizedBox.shrink();
          }
      ),
    );
  }
}
