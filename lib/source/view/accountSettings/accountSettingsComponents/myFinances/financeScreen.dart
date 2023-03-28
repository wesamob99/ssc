import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:ssc/infrastructure/userConfig.dart';
import 'package:ssc/source/viewModel/utilities/theme/themeProvider.dart';

import '../../../../../utilities/hexColor.dart';
import '../../../../../utilities/theme/themes.dart';
import '../../../../../utilities/util.dart';

class FinanceScreen extends StatefulWidget {
  final Widget card;
  const FinanceScreen({Key key, this.card}) : super(key: key);

  @override
  State<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> {

  ThemeNotifier themeNotifier;
  bool isEnglish;
  int selectedIndex = 1;

  @override
  void initState() {
    themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    isEnglish = UserConfig.instance.isLanguageEnglish();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(getTranslated('myFinances', context), style: const TextStyle(fontSize: 14),),
        leading: leadingBackIcon(context),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              widget.card,
              const SizedBox(height: 20.0,),
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
                            color: selectedIndex == 1 ? getPrimaryColor(context, themeNotifier) : HexColor('#EAEAEA'),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(isEnglish ? 12.0 : 0),
                              bottomLeft: Radius.circular(isEnglish ? 12.0 : 0),
                              topRight: Radius.circular(isEnglish ? 0 : 12.0),
                              bottomRight: Radius.circular(isEnglish ? 0 : 12.0),
                            )
                        ),
                        child: Text(
                          getTranslated('installmentDetails', context),
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
                            color: selectedIndex == 2 ? getPrimaryColor(context, themeNotifier) : HexColor('#EAEAEA'),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(isEnglish ? 0 : 12.0),
                              bottomLeft: Radius.circular(isEnglish ? 0 : 12.0),
                              topRight: Radius.circular(isEnglish ? 12.0 : 0),
                              bottomRight: Radius.circular(isEnglish ? 12.0 : 0),
                            )
                        ),
                        child: Text(
                          getTranslated('summary', context),
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
                padding: const EdgeInsets.only(bottom: 20.0, top: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      getTranslated(selectedIndex == 1 ? 'payments' : 'summary', context),
                      style: TextStyle(
                        color: HexColor('#363636'),
                        fontWeight: FontWeight.w700
                      ),
                    ),
                    if(selectedIndex == 1)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SvgPicture.asset('assets/icons/profileIcons/filter.svg'),
                        const SizedBox(width: 5.0,),
                        SvgPicture.asset('assets/icons/profileIcons/pdf.svg'),
                      ],
                    ),
                  ],
                )
              ),
              if(selectedIndex == 1)
                installmentDetailsBody(),
              if(selectedIndex == 2)
                summaryBody(),
            ],
          ),
        ),
      ),
    );
  }

  Widget installmentDetailsBody(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Text(
            '25/2/2023',
            style: TextStyle(
              color: HexColor('#363636'),
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
        paymentCard('TODO add title', '250', 1),
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0, top: 20.0),
          child: Text(
            '25/2/2023',
            style: TextStyle(
              color: HexColor('#363636'),
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
        paymentCard('TODO add title', '250', 2),
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0, top: 20.0),
          child: Text(
            '25/1/2023',
            style: TextStyle(
              color: HexColor('#363636'),
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
        paymentCard('TODO add title', '250', 3),
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0, top: 20.0),
          child: Text(
            '25/12/2022',
            style: TextStyle(
              color: HexColor('#363636'),
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
        paymentCard('TODO add title', '250', 2),
      ],
    );
  }

  Widget summaryBody(){
    return Card(
        elevation: 2.0,
        shadowColor: Colors.black45,
        color: getContainerColor(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
          width: width(1, context),
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              summaryRow('فئة التمويل', 'فئة التمويل'),
              summaryRow('مبلغ القرض', '5000 د.أ'),
              summaryRow('مجموع الفوائد', '1000 د.أ'),
              summaryRow('مجموع الأقساط المدفوعة', '700 د.أ'),
              summaryRow('مجموع الأقساط المتبقية', '4300 د.أ'),
              summaryRow('تاريخ انتهاء التمويل', '27/02/2026'),
              summaryRow('تاريخ بداية التمويل', '27/02/2023'),
              summaryRow('تاريخ القسط التالي', '27/03/2023'),
              summaryRow('مبلغ القسط التالي', '256.00 د.أ'),
            ],
          )
        )
    );
  }

  summaryRow(String title, String value){
    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 3,
            child: Text(title),
          ),
          Expanded(
            flex: 1,
            child: Text(value),
          ),
        ],
      ),
    );
  }

  paymentCard(String title, String amount, int status){
    String statusText = 'nextBatch';
    Color backgroundColor = const Color.fromRGBO(237, 49, 36, 0.3);
    String textColor = '#EE1506';
    switch(status){
      case 1: {
        statusText = 'nextBatch';
        backgroundColor = const Color.fromRGBO(237, 49, 36, 0.3);
        textColor = '#EE1506';
      } break;
      case 2: {
        statusText = 'paymentCompleted';
        backgroundColor = const Color.fromRGBO(129, 221, 199, 0.49);
        textColor = '#248389';
      } break;
      case 3: {
        statusText = 'postponed';
        backgroundColor = const Color.fromRGBO(101, 101, 101, 0.4);
        textColor = '#FFFFFF';
      } break;
    }

    return InkWell(
      onTap: (){},
      child: Card(
          elevation: 2.0,
          shadowColor: Colors.black45,
          color: getContainerColor(context),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Container(
            width: width(1, context),
            padding: const EdgeInsets.all(15.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      UserConfig.instance.isLanguageEnglish()
                          ? 'Personal disk batch' : 'دفعة قرص شخصي',
                      style: TextStyle(
                        color: status == 2 ? HexColor('#363636') : HexColor('#363636').withOpacity(0.4),
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    const SizedBox(height: 20.0,),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(50.0)
                      ),
                      child: Text(
                        getTranslated(statusText, context),
                        style: TextStyle(
                          color: HexColor(textColor),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(
                          amount,
                          style: TextStyle(
                            color: status == 2 ? HexColor('#363636') : HexColor('#363636').withOpacity(0.4),
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                          ),
                        ),
                        Text(
                          ' ${getTranslated('jd', context)}',
                          style: TextStyle(
                            color: status == 2 ? HexColor('#363636') : HexColor('#363636').withOpacity(0.4),
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 25.0,),
                    SvgPicture.asset('assets/icons/arrow.svg', height: 18, color: status == 2 ? HexColor('#363636') : HexColor('#363636').withOpacity(0.4),)
                  ],
                )
              ],
            ),
          )
      ),
    );
  }
}
