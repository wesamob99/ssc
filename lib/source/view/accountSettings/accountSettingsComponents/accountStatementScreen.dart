// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:ssc/infrastructure/userConfig.dart';
import 'package:ssc/source/viewModel/accountSettings/accountSettingsProvider.dart';
import 'package:ssc/source/viewModel/services/servicesProvider.dart';
import 'package:ssc/source/viewModel/utilities/theme/themeProvider.dart';
import 'package:ssc/utilities/hexColor.dart';
import 'package:ssc/utilities/theme/themes.dart';

import '../../../../utilities/util.dart';

class AccountStatementScreen extends StatefulWidget {
  const AccountStatementScreen({Key key}) : super(key: key);

  @override
  State<AccountStatementScreen> createState() => _AccountStatementScreenState();
}

class _AccountStatementScreenState extends State<AccountStatementScreen> {

  Future inquireInsuredInfo;
  AccountSettingsProvider accountSettingsProvider;
  ThemeNotifier themeNotifier;
  bool isEnglish;
  int selectedIndex;

  @override
  void initState() {
    accountSettingsProvider = Provider.of<AccountSettingsProvider>(context, listen: false);
    themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    inquireInsuredInfo = accountSettingsProvider.getInquireInsuredInfo();
    isEnglish = UserConfig.instance.isLanguageEnglish();
    accountSettingsProvider.isLoading = false;
    selectedIndex = 1;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            centerTitle: false,
            title: Text(getTranslated('accountStatement', context), style: const TextStyle(fontSize: 14),),
            leading: leadingBackIcon(context),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0).copyWith(top: 25.0),
            child: FutureBuilder(
                future: inquireInsuredInfo,
                builder: (context, snapshot){
                  switch(snapshot.connectionState){
                    case ConnectionState.none:
                      return somethingWrongWidget(context, 'somethingWrongHappened', 'somethingWrongHappenedDesc'); break;
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      return Container(
                          height: height(1, context),
                          alignment: Alignment.center,
                          child: animatedLoader(context)
                      ); break;
                    case ConnectionState.done:
                      if(snapshot.hasData && !snapshot.hasError){
                        int totalSubscriptions = 0;
                        List companiesYouHaveWorkedFor = [];
                        snapshot.data['cur_getdata2'][0].forEach((element){
                          totalSubscriptions += element['MONTH_COUNT'];
                          if(!companiesYouHaveWorkedFor.contains(element['ESTNO'])){
                            companiesYouHaveWorkedFor.add(element['ESTNO']);
                          }
                        });
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: (){
                                      setState(() {
                                        selectedIndex = 1;
                                      });
                                    },
                                    highlightColor: Colors.transparent,
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 300),
                                      padding: const EdgeInsets.all(16.0),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: selectedIndex == 1 ? getPrimaryColor(context, themeNotifier) : getContainerColor(context),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(isEnglish ? 12.0 : 0),
                                            bottomLeft: Radius.circular(isEnglish ? 12.0 : 0),
                                            topRight: Radius.circular(isEnglish ? 0 : 12.0),
                                            bottomRight: Radius.circular(isEnglish ? 0 : 12.0),
                                          )
                                      ),
                                      child: Text(
                                        getTranslated('subscriptionPeriods', context),
                                        style: TextStyle(
                                          color: selectedIndex == 1 ? HexColor('#FFFFFF')
                                              : themeNotifier.isLight() ? HexColor('#716F6F') : Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: (){
                                      setState(() {
                                        selectedIndex = 2;
                                      });
                                    },
                                    highlightColor: Colors.transparent,
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 300),
                                      padding: const EdgeInsets.all(16.0),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: selectedIndex == 2 ? getPrimaryColor(context, themeNotifier) : getContainerColor(context),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(isEnglish ? 0 : 12.0),
                                            bottomLeft: Radius.circular(isEnglish ? 0 : 12.0),
                                            topRight: Radius.circular(isEnglish ? 12.0 : 0),
                                            bottomRight: Radius.circular(isEnglish ? 12.0 : 0),
                                          )
                                      ),
                                      child: Text(
                                        getTranslated('financialSalaries', context),
                                        style: TextStyle(
                                          color: selectedIndex == 2 ? HexColor('#FFFFFF')
                                              : themeNotifier.isLight() ? HexColor('#716F6F') : Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0, top: 15.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  // SvgPicture.asset('assets/icons/profileIcons/filter.svg', width: 40,),
                                  // const SizedBox(width: 5.0,),
                                  InkWell(
                                    onTap: () async {
                                      accountSettingsProvider.isLoading = true;
                                      accountSettingsProvider.notifyMe();
                                      try{
                                        await Provider.of<ServicesProvider>(context, listen: false).getInsuredInformationReport(snapshot.data);
                                        accountSettingsProvider.isLoading = false;
                                        accountSettingsProvider.notifyMe();
                                      }catch(e){
                                        accountSettingsProvider.isLoading = false;
                                        accountSettingsProvider.notifyMe();
                                        if (kDebugMode) {
                                          print(e.toString());
                                        }
                                      }
                                    },
                                    child: SvgPicture.asset('assets/icons/profileIcons/pdf.svg', width: 40,),
                                  ),
                                ],
                              ),
                            ),
                            if(selectedIndex == 1)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Card(
                                      elevation: 3.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15.0),
                                      ),
                                      child: Container(
                                        height: 75,
                                        padding: const EdgeInsets.all(15.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              getTranslated('totalSubscriptions', context),
                                              style: const TextStyle(
                                                  fontSize: 11
                                              ),
                                            ),
                                            // const SizedBox(height: 10.0,),
                                            Text(
                                              '$totalSubscriptions',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10.0,),
                                  Expanded(
                                    child: Card(
                                      elevation: 3.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15.0),
                                      ),
                                      child: Container(
                                        height: 75,
                                        padding: const EdgeInsets.all(15.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              getTranslated('theNumberOfCompaniesYouHaveWorkedFor', context),
                                              style: const TextStyle(
                                                  fontSize: 11
                                              ),
                                            ),
                                            // const SizedBox(height: 10.0,),
                                            Text(
                                              '${companiesYouHaveWorkedFor.length}',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if(selectedIndex == 1)
                            subscriptionPeriodsBody(snapshot.data['cur_getdata2']),
                            if(selectedIndex == 2)
                            financialSalariesBody(snapshot.data['cur_getdata3']),
                          ],
                        );
                      }
                      break;
                  }
                  return somethingWrongWidget(context, 'somethingWrongHappened', 'somethingWrongHappenedDesc');
                }
            ),
          ),
        ),
        if(Provider.of<AccountSettingsProvider>(context).isLoading)
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: width(1, context),
          height: height(1, context),
          color: themeNotifier.isLight() ? Colors.white70 : Colors.black45,
          child: Center(
            child: animatedLoader(context),
          ),
        ),
      ],
    );
  }

  subscriptionPeriodsBody(data){
    return Expanded(
      child: data.isNotEmpty && data[0][0] != 1
      ? ListView.builder(
        itemCount: data[0].length,
        itemBuilder: (context, index){
          return Card(
              elevation: 6.0,
              shadowColor: Colors.black45,
              color: getContainerColor(context),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Container(
                width: width(1, context),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                      decoration: BoxDecoration(
                        color: data[0][index]['descr'] == null
                            ? themeNotifier.isLight() ? const Color.fromRGBO(0, 121, 5, 0.38) : HexColor('#006600')
                            : themeNotifier.isLight() ? const Color.fromRGBO(221, 201, 129, 0.49): HexColor('#bcbe40'),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      child: Text(
                        '${(UserConfig.instance.isLanguageEnglish() ? data[0][index]['descr_en'] : data[0][index]['descr']) ?? getTranslated('onTopOfHisWork', context)}',
                        style: TextStyle(
                          color: themeNotifier.isLight()
                          ? data[0][index]['descr'] == null ? HexColor('#2D452E') : HexColor('#987803')
                          : Colors.white
                        ),
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    Text(
                      '${data[0][index]['ename']}',
                      style: TextStyle(
                        height: 1.4,
                        color: themeNotifier.isLight() ? HexColor('#363636') : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15.0,),
                    Text(
                      '${data[0][index]['ESTNO']}',
                      style: TextStyle(
                        color: !themeNotifier.isLight() ? Colors.white70 : HexColor('#716F6F'),
                      ),
                    ),
                    const SizedBox(height: 15.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/icons/calender.svg', width: 15, color: !themeNotifier.isLight() ? Colors.white : Colors.black,),
                        const SizedBox(width: 10.0,),
                        Text(
                          '${data[0][index]['STADATE']}',
                          style: TextStyle(
                            color: !themeNotifier.isLight() ? Colors.white70 : HexColor('#979797'),
                          ),
                        ),
                        const SizedBox(width: 7.5,),
                        Text(
                          data[0][index]['STODATE'] != null ? '-' : '',
                          style: TextStyle(
                            color: !themeNotifier.isLight() ? Colors.white70 : HexColor('#716F6F'),
                          ),
                        ),
                        const SizedBox(width: 7.5,),
                        Text(
                          '${data[0][index]['STODATE'] ?? ''}',
                          style: TextStyle(
                            color: !themeNotifier.isLight() ? Colors.white70 : HexColor('#979797'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/icons/hashtag.svg', width: 15, color: !themeNotifier.isLight() ? Colors.white : Colors.black,),
                        const SizedBox(width: 10.0,),
                        Text(
                          '${data[0][index]['MONTH_COUNT']}',
                          style: TextStyle(
                            color: !themeNotifier.isLight() ? Colors.white70 : HexColor('#979797'),
                          ),
                        ),
                        const SizedBox(width: 7.5,),
                        Text(
                          UserConfig.instance.isLanguageEnglish()
                              ? 'Subscriptions' : 'إشتراكات',
                          style: TextStyle(
                            color: !themeNotifier.isLight() ? Colors.white70 : HexColor('#979797'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15.0,),
                    Divider(
                      color: HexColor('#A6A6A6'),
                      thickness: 1,
                    ),
                    const SizedBox(height: 10.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          getTranslated('salary', context),
                          style: TextStyle(
                            color: !themeNotifier.isLight() ? Colors.white : HexColor('#716F6F'),
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              '${data[0][index]['SALARY']}',
                              style: TextStyle(
                                color: !themeNotifier.isLight() ? Colors.white : HexColor('#363636'),
                                fontWeight: FontWeight.bold,
                                fontSize: 19,
                              ),
                            ),
                            Text(
                              ' ${getTranslated('jd', context)}',
                              style: TextStyle(
                                color: !themeNotifier.isLight() ? Colors.white : HexColor('#363636'),
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              )
          );
        },
      )
      : Center(child: Text(getTranslated('youHaveNoSubscriptions', context)),),
    );
  }

  financialSalariesBody(data){
    List<int> years = [];
    if(data.isNotEmpty && data[0][0] != 1){
      data[0].forEach((element){
        if(!years.contains(element['YEAR'])){
          years.add(element['YEAR']);
        }
      });
    }

    return Expanded(
      child: data.isNotEmpty && data[0][0] != 1
      ? ListView.builder(
        itemCount: years.length,
        itemBuilder: (context, indexOfYear){
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: getPrimaryColor(context, themeNotifier),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  '${years[indexOfYear]}',
                  //translate('onTopOfHisWork', context)
                  style: TextStyle(
                      color: HexColor('#ffffff')
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: data[0].length,
                itemBuilder: (context, index){
                  return data[0][index]['YEAR'] == years[indexOfYear]
                  ? Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: Card(
                        elevation: 6.0,
                        shadowColor: Colors.black45,
                        color: getContainerColor(context),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Container(
                          width: width(1, context),
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${data[0][index]['ename']}',
                                style: TextStyle(
                                  height: 1.4,
                                  color: themeNotifier.isLight() ? HexColor('#363636') : Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 15.0,),
                              Text(
                                '${data[0][index]['EST']}',
                                style: TextStyle(
                                  color: themeNotifier.isLight() ? HexColor('#716F6F') : Colors.white70,
                                ),
                              ),
                              const SizedBox(height: 15.0,),
                              Divider(
                                color: HexColor('#A6A6A6'),
                                thickness: 1,
                              ),
                              const SizedBox(height: 10.0,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    getTranslated('salary', context),
                                    style: TextStyle(
                                      color: themeNotifier.isLight() ? HexColor('#716F6F') : Colors.white,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '${data[0][index]['SAL']}',
                                        style: TextStyle(
                                          color: themeNotifier.isLight() ? HexColor('#716F6F') : Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 19,
                                        ),
                                      ),
                                      Text(
                                        ' ${getTranslated('jd', context)}',
                                        style: TextStyle(
                                          color: themeNotifier.isLight() ? HexColor('#716F6F') : Colors.white,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                    ),
                  )
                  : const SizedBox.shrink();
                },
              ),
            ],
          );
        },
      )
      : Center(child: Text(getTranslated('youDoNotHaveFinancialSalaries', context)),),
    );
  }

}
