import 'package:ai_progress/ai_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:ssc/source/viewModel/utilities/theme/themeProvider.dart';

import '../../../../../utilities/hexColor.dart';
import '../../../../../utilities/theme/themes.dart';
import '../../../../../utilities/util.dart';
import 'financeScreen.dart';
import 'dart:ui' as ui;

class MyFinancesListScreen extends StatefulWidget {
  const MyFinancesListScreen({Key key}) : super(key: key);

  @override
  State<MyFinancesListScreen> createState() => _MyFinancesListScreenState();
}

class _MyFinancesListScreenState extends State<MyFinancesListScreen> {

  ThemeNotifier themeNotifier;

  @override
  void initState() {
    themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
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
        child: ListView.builder(
          itemCount: 1,
          itemBuilder: (context, index){
            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: InkWell(
                onTap: (){
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => FinanceScreen(
                        card: buildFinanceCard(),
                      ))
                  );
                },
                child: buildFinanceCard(),
              ),
            );
          },
        )
      ),
    );
  }

  Widget buildFinanceCard(){
    return Card(
        elevation: 5.0,
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(153, 216, 140, 0.4),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  getTranslated('personal', context),
                  style: TextStyle(
                    color: HexColor('#363636'),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 20.0,),
              SizedBox(
                width: width(1, context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      getTranslated('totalRemainingToPay', context),
                      style: TextStyle(
                        color: HexColor('#363636'),
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 20.0,),
                    Text(
                      '4300',
                      style: TextStyle(
                        color: HexColor('#B3913E'),
                        fontWeight: FontWeight.w700,
                        fontSize: 28,
                      ),
                    ),
                    const SizedBox(height: 15.0,),
                    SizedBox(
                      width: width(1, context),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '40/60',
                            style: TextStyle(
                                fontSize: isTablet(context) ? 19 : 13),
                          ),
                          Container(
                            width: width(1, context),
                            height: 10,
                            padding: const EdgeInsets.all(5),
                            child: AirLinearStateProgressIndicator(
                              size: const Size(0, 0),
                              value: 40,
                              valueColor: HexColor('#2D452E'),
                              pathColor: HexColor('#EAEAEA'),
                              pathStrokeWidth: isTablet(context) ? 12 : 7,
                              valueStrokeWidth: isTablet(context) ? 12 : 7,
                              roundCap: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15.0,),
                    Row(
                      children: [
                        Expanded(
                          child: textButtonWithIcon(context, themeNotifier, 'reschedule', Colors.transparent, HexColor('#363636'), (){
                            showRescheduleBottomSheet();
                          }, icon: 'assets/icons/profileIcons/calender.svg'),
                        ),
                        Expanded(
                          child: textButtonWithIcon(context, themeNotifier, 'earlyRepayment', Colors.transparent, HexColor('#363636'), (){
                            showEarlyPaymentBottomSheet();
                          }, icon: 'assets/icons/profileIcons/repayment.svg'),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        )
    );
  }

  showEarlyPaymentBottomSheet(){
    return showModalBottomSheet(
        isScrollControlled: false,
        isDismissible: true,
        enableDrag: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0))
        ),
        context: context,
        barrierColor: Colors.black26,
        builder: (context) {
          return GestureDetector(
            onTap: (){
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(
                sigmaX: 2.0,
                sigmaY: 2.0,
              ),
              child: Material(
                elevation: 100,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                ),
                color: Colors.white,
                shadowColor: Colors.black,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0).copyWith(top: 15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(),
                          Container(
                            width: 45,
                            height: 6,
                            decoration: BoxDecoration(
                                color: HexColor('#000000'),
                                borderRadius: const BorderRadius.all(Radius.circular(25.0))),
                          ),
                          InkWell(
                            onTap: (){
                              Navigator.of(context).pop();
                            },
                            child: SvgPicture.asset('assets/icons/close.svg'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0,),
                      Text(
                        getTranslated('earlyRepayment', context),
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 20.0,),
                      Card(
                        elevation: 5.0,
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
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(153, 216, 140, 0.4),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Text(
                                  getTranslated('personal', context),
                                  style: TextStyle(
                                    color: HexColor('#363636'),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20.0,),
                              SizedBox(
                                width: width(1, context),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      getTranslated('theAmountTobePaidAfterDeductingInterest', context),
                                      style: TextStyle(
                                        color: HexColor('#363636'),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 15.0,),
                                    Text(
                                      '3000',
                                      style: TextStyle(
                                        color: HexColor('#B3913E'),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 28,
                                      ),
                                    ),
                                    const SizedBox(height: 10.0,),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ),
                      const SizedBox(height: 20.0,),
                      Text(
                        getTranslated('earlyPaymentDesc', context),
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          height: 1.8,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
    );
  }

  showRescheduleBottomSheet(){
    return showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0))
        ),
        constraints: BoxConstraints(
          maxHeight: height(0.9, context)
        ),
        context: context,
        barrierColor: Colors.black26,
        builder: (context) {
          return GestureDetector(
            onTap: (){
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(
                sigmaX: 2.0,
                sigmaY: 2.0,
              ),
              child: Material(
                elevation: 100,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                ),
                color: Colors.white,
                shadowColor: Colors.black,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0).copyWith(top: 15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(),
                          Container(
                            width: 45,
                            height: 6,
                            decoration: BoxDecoration(
                                color: HexColor('#000000'),
                                borderRadius: const BorderRadius.all(Radius.circular(25.0))),
                          ),
                          InkWell(
                            onTap: (){
                              Navigator.of(context).pop();
                            },
                            child: SvgPicture.asset('assets/icons/close.svg'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0,),
                      Text(
                        getTranslated('reschedule', context),
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 20.0,),
                      Card(
                        elevation: 5.0,
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
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(153, 216, 140, 0.4),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Text(
                                  getTranslated('personal', context),
                                  style: TextStyle(
                                    color: HexColor('#363636'),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20.0,),
                              SizedBox(
                                width: width(1, context),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      getTranslated('activeLoanBalance', context),
                                      style: TextStyle(
                                        color: HexColor('#363636'),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 15.0,),
                                    Text(
                                      '3000',
                                      style: TextStyle(
                                        color: HexColor('#B3913E'),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 28,
                                      ),
                                    ),
                                    const SizedBox(height: 10.0,),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10.0,),
                              Row(
                                children: [
                                  Text(
                                    getTranslated('lastPaymentDate', context),
                                    style: TextStyle(
                                      color: HexColor('#979797'),
                                      fontSize: 13,
                                    ),
                                  ),
                                  const Text(
                                    ' 30/10/2023',
                                    style: TextStyle(
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ),
                      const SizedBox(height: 20.0,),
                      /// TODO: complete reschedule modal bottom sheet
                    ],
                  ),
                ),
              ),
            ),
          );
        }
    );
  }

}
