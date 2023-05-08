// ignore_for_file: file_names

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
  final Map data;
  final int index;
  const FinanceScreen({Key key, this.card, this.data, this.index}) : super(key: key);

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
                      // SvgPicture.asset('assets/icons/profileIcons/filter.svg'),
                      // const SizedBox(width: 5.0,),
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
    );
  }

  Widget installmentDetailsBody(){
    return Expanded(
      child: ListView.builder(
        itemCount: widget.data['cur_getdata2'][widget.index].length,
        itemBuilder: (context, index){
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0, top: 20.0),
                child: Text(
                  widget.data['cur_getdata2'][widget.index][index]['DATE_'],
                  style: TextStyle(
                    color: HexColor('#363636'),
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              paymentCard(
                UserConfig.instance.isLanguageEnglish()
                  ? widget.data['cur_getdata'][0][widget.index]['L_TYP_EN']
                  : widget.data['cur_getdata'][0][widget.index]['L_TYP_AR'],
                UserConfig.instance.isLanguageEnglish()
                  ? widget.data['cur_getdata2'][widget.index][index]['PMT_STAT_ENs']
                  : widget.data['cur_getdata2'][widget.index][index]['PMT_STAT_AR'],
                widget.data['cur_getdata2'][widget.index][index]['SCH_PAY'],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget summaryBody(){
    return Expanded(
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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  summaryRow(
                    'فئة التمويل', UserConfig.instance.isLanguageEnglish()
                    ? widget.data['cur_getdata'][0][widget.index]['L_TYP_EN']
                    : widget.data['cur_getdata'][0][widget.index]['L_TYP_AR'],
                  ),
                  summaryRow('مبلغ القرض', widget.data['cur_getdata'][0][widget.index]['LOAN_AMT']),
                  summaryRow('مجموع الفوائد', widget.data['cur_getdata'][0][widget.index]['LOAN_INT_AMT']),
                  summaryRow('مجموع الأقساط المدفوعة', widget.data['cur_getdata'][0][widget.index]['PAID_SCH']),
                  summaryRow('مجموع الأقساط المتبقية', widget.data['cur_getdata'][0][widget.index]['UNPAID_SCH']),
                  summaryRow('تاريخ انتهاء التمويل', widget.data['cur_getdata'][0][widget.index]['LAST_PAYDATE']),
                  summaryRow('تاريخ بداية التمويل', widget.data['cur_getdata'][0][widget.index]['FIRST_PAYDATE']),
                  summaryRow('تاريخ القسط التالي', widget.data['cur_getdata'][0][widget.index]['NEXT_PAYDATE']),
                  summaryRow('مبلغ القسط التالي', widget.data['cur_getdata'][0][widget.index]['NEXT_SCH']),
                ],
              ),
            )
          )
      ),
    );
  }

  summaryRow(String title, String value){
    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 5,
            child: Text(title),
          ),
          Expanded(
            flex: 2,
            child: Text(value),
          ),
        ],
      ),
    );
  }

  paymentCard(String title, String status, String amount){
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
                      title,
                      style: TextStyle(
                        color: HexColor('#363636'),
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    const SizedBox(height: 20.0,),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      decoration: BoxDecoration(
                          color: const Color.fromRGBO(129, 221, 199, 0.49),
                          borderRadius: BorderRadius.circular(50.0)
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          color: HexColor('#248389'),
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
                            color: HexColor('#363636'),
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                          ),
                        ),
                        Text(
                          ' ${getTranslated('jd', context)}',
                          style: TextStyle(
                            color: HexColor('#363636'),
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 25.0,),
                    SvgPicture.asset('assets/icons/arrow.svg', height: 18, color: HexColor('#363636'),)
                  ],
                )
              ],
            ),
          )
      ),
    );
  }
}
