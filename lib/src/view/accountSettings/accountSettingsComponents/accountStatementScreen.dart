// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:ssc/infrastructure/userConfig.dart';
import 'package:ssc/src/viewModel/accountSettings/accountSettingsProvider.dart';
import 'package:ssc/utilities/hexColor.dart';

import '../../../../utilities/util.dart';

class AccountStatementScreen extends StatefulWidget {
  const AccountStatementScreen({Key key}) : super(key: key);

  @override
  State<AccountStatementScreen> createState() => _AccountStatementScreenState();
}

class _AccountStatementScreenState extends State<AccountStatementScreen> {

  Future inquireInsuredInfo;
  AccountSettingsProvider accountSettingsProvider;
  bool isEnglish;
  int selectedIndex;

  @override
  void initState() {
    accountSettingsProvider = Provider.of<AccountSettingsProvider>(context, listen: false);
    inquireInsuredInfo = accountSettingsProvider.getInquireInsuredInfo();
    isEnglish = UserConfig.instance.checkLanguage();
    selectedIndex = 1;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(translate('accountStatement', context), style: const TextStyle(fontSize: 14),),
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
                                      color: selectedIndex == 1 ? HexColor('#445740') : HexColor('#EAEAEA'),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(isEnglish ? 12.0 : 0),
                                        bottomLeft: Radius.circular(isEnglish ? 12.0 : 0),
                                        topRight: Radius.circular(isEnglish ? 0 : 12.0),
                                        bottomRight: Radius.circular(isEnglish ? 0 : 12.0),
                                      )
                                  ),
                                  child: Text(
                                    translate('subscriptionPeriods', context),
                                    style: TextStyle(
                                      color: selectedIndex == 1 ? HexColor('#FFFFFF') : HexColor('#716F6F'),
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
                                      color: selectedIndex == 2 ? HexColor('#445740') : HexColor('#EAEAEA'),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(isEnglish ? 0 : 12.0),
                                        bottomLeft: Radius.circular(isEnglish ? 0 : 12.0),
                                        topRight: Radius.circular(isEnglish ? 12.0 : 0),
                                        bottomRight: Radius.circular(isEnglish ? 12.0 : 0),
                                      )
                                  ),
                                  child: Text(
                                    translate('financialSalaries', context),
                                    style: TextStyle(
                                      color: selectedIndex == 2 ? HexColor('#FFFFFF') : HexColor('#716F6F'),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          margin: const EdgeInsets.symmetric(vertical: 22.0, horizontal: 8.0),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: HexColor('#747474'),
                              ),
                              borderRadius: BorderRadius.circular(6.0)
                          ),
                          child: SvgPicture.asset('assets/icons/pdf.svg'),
                        ),
                        subscriptionPeriodsBody(snapshot.data['cur_getdata2'][0])
                      ],
                    );
                  }
                  break;
              }
              return somethingWrongWidget(context, 'somethingWrongHappened', 'somethingWrongHappenedDesc');
            }
        ),
      ),
    );
  }

  subscriptionPeriodsBody(data){
    return Expanded(
      child: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index){
          return Card(
              elevation: 6.0,
              shadowColor: Colors.black45,
              color: Colors.white,
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
                        color: data[index]['descr'] == null
                            ? const Color.fromRGBO(0, 121, 5, 0.38) : const Color.fromRGBO(221, 201, 129, 0.49),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      child: Text(
                        '${data[index]['descr'] ?? 'على رأس عمله'}',
                        //translate('onTopOfHisWork', context)
                        style: TextStyle(
                          color: data[index]['descr'] == null ? HexColor('#2D452E') : HexColor('#987803')
                        ),
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    Text(
                      '${data[index]['ename']}',
                      style: TextStyle(
                        height: 1.4,
                        color: HexColor('#363636'),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15.0,),
                    Text(
                      '${data[index]['ESTNO']}',
                      style: TextStyle(
                        color: HexColor('#716F6F'),
                      ),
                    ),
                    const SizedBox(height: 15.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/icons/calender.svg', width: 15,),
                        const SizedBox(width: 10.0,),
                        Text(
                          '${data[index]['STADATE']}',
                          style: TextStyle(
                            color: HexColor('#979797'),
                          ),
                        ),
                        const SizedBox(width: 7.5,),
                        Text(
                          data[index]['STODATE'] != null ? '-' : '',
                          style: TextStyle(
                            color: HexColor('#716F6F'),
                          ),
                        ),
                        const SizedBox(width: 7.5,),
                        Text(
                          '${data[index]['STODATE'] ?? ''}',
                          style: TextStyle(
                            color: HexColor('#979797'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/icons/hashtag.svg', width: 15,),
                        const SizedBox(width: 10.0,),
                        Text(
                          '${data[index]['MONTH_COUNT']}',
                          style: TextStyle(
                            color: HexColor('#979797'),
                          ),
                        ),
                        const SizedBox(width: 7.5,),
                        Text(
                          UserConfig.instance.checkLanguage()
                              ? 'Subscriptions' : 'إشتراكات',
                          style: TextStyle(
                            color: HexColor('#979797'),
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
                          translate('salary', context),
                          style: TextStyle(
                            color: HexColor('#716F6F'),
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              '${data[index]['SALARY']}',
                              style: TextStyle(
                                color: HexColor('#363636'),
                                fontWeight: FontWeight.bold,
                                fontSize: 19,
                              ),
                            ),
                            Text(
                              ' ${translate('jd', context)}',
                              style: TextStyle(
                                color: HexColor('#363636'),
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
      ),
    );
  }

}
