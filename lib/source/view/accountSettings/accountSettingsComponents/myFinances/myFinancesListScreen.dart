import 'package:ai_progress/ai_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:ssc/source/viewModel/utilities/theme/themeProvider.dart';

import '../../../../../utilities/hexColor.dart';
import '../../../../../utilities/theme/themes.dart';
import '../../../../../utilities/util.dart';
import '../../../../viewModel/services/servicesProvider.dart';
import 'financeScreen.dart';
import 'dart:ui' as ui;

class MyFinancesListScreen extends StatefulWidget {
  const MyFinancesListScreen({Key key}) : super(key: key);

  @override
  State<MyFinancesListScreen> createState() => _MyFinancesListScreenState();
}

class _MyFinancesListScreenState extends State<MyFinancesListScreen> {

  ServicesProvider servicesProvider;
  ThemeNotifier themeNotifier;

  @override
  void initState() {
    servicesProvider = Provider.of<ServicesProvider>(context, listen: false);
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
              const SizedBox(height: 15.0,),
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
                    const SizedBox(height: 15.0,),
                    Text(
                      '4300',
                      style: TextStyle(
                        color: HexColor('#B3913E'),
                        fontWeight: FontWeight.w700,
                        fontSize: 28,
                      ),
                    ),
                    const SizedBox(height: 10.0,),
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
                    const SizedBox(height: 10.0,),
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
                  child: SingleChildScrollView(
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
                        const SizedBox(height: 30.0,),
                        buildFieldTitle(context, 'loanValue', required: false),
                        const SizedBox(height: 20.0,),
                        buildInputFieldsField(1),
                        const SizedBox(height: 30.0,),
                        buildFieldTitle(context, 'numberOfInstallments', required: false),
                        const SizedBox(height: 20.0,),
                        buildInputFieldsField(2),
                        const SizedBox(height: 30.0,),
                        buildFieldTitle(context, 'financialCommitment', required: false),
                        const SizedBox(height: 20.0,),
                        buildInputFieldsField(3, withSlider: false),
                        const SizedBox(height: 20.0,),
                        Container(
                          alignment: Alignment.center,
                          child: textButton(context, themeNotifier, 'calculate', primaryColor, Colors.white, (){
                            showCalculationResultBottomSheet(
                              102.435,
                              102.435,
                              102.435,
                            );
                          }),
                        ),
                        const SizedBox(height: 30.0,),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
    );
  }


  showCalculationResultBottomSheet(loanPaidAmount, monthlyInstallment, startDate){
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
                      const SizedBox(height: 15.0,),
                      buildFieldTitle(context, 'theValueOfTheAdvanceAfterDeductingRiskInsurance', required: false),
                      const SizedBox(height: 15.0,),
                      Text(
                        loanPaidAmount.toStringAsFixed(3),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30.0,),
                      buildFieldTitle(context, 'monthlyInstallment', required: false),
                      const SizedBox(height: 15.0,),
                      Row(
                        children: [
                          Text(
                            monthlyInstallment.toStringAsFixed(3),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            getTranslated('jd', context),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      // const SizedBox(height: 30.0,),
                      // buildFieldTitle(context, 'interestRate', required: false),
                      // const SizedBox(height: 15.0,),
                      // Row(
                      //   children: [
                      //     const Text(
                      //       '- ',
                      //       style: TextStyle(
                      //         fontWeight: FontWeight.bold,
                      //       ),
                      //     ),
                      //     Text(
                      //       getTranslated('approximately', context),
                      //       style: const TextStyle(
                      //         fontWeight: FontWeight.bold,
                      //       ),
                      //     ),
                      //     const Text(
                      //       ' -',
                      //       style: TextStyle(
                      //         fontWeight: FontWeight.bold,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      const SizedBox(height: 30.0,),
                      buildFieldTitle(context, 'theStartDateOfTheDeductionForPayment', required: false),
                      const SizedBox(height: 15.0,),
                      Text(
                        '$startDate',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(child: Container()),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(bottom: 30.0),
                        child: textButton(context, themeNotifier, 'submitApplication', primaryColor, Colors.white, (){
                          Navigator.of(context).pop();
                          servicesProvider.stepNumber = 4;
                          servicesProvider.notifyMe();
                        }),
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

  Widget buildInputFieldsField(int flag , {bool withSlider = true}){
    double minValue = 1;
    double maxValue = 1;

    if(flag == 1){
      minValue = 1.0;
      maxValue = 5000;
    } else if(flag == 2){
      minValue = 1;
      maxValue = 60;
    } else if(flag == 3){
      minValue = 0;
      maxValue = 10000;
    }
    return Card(
      color: Colors.white,
      elevation: 0.8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100,
                  child: TextFormField(
                    controller: TextEditingController(text: (flag == 1 ? servicesProvider.currentLoanValue : flag == 2 ? servicesProvider.currentNumberOfInstallments : servicesProvider.currentFinancialCommitment).toStringAsFixed(0)),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
                    style: TextStyle(
                        fontSize: isTablet(context) ? 20 : 15,
                        color: themeNotifier.isLight() ? HexColor('#363636') : Colors.white,
                        fontWeight: FontWeight.bold
                    ),
                    cursorColor: themeNotifier.isLight() ? getPrimaryColor(context, themeNotifier) : Colors.white,
                    cursorWidth: 1,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: isTablet(context) ? 20 : 0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: themeNotifier.isLight()
                                ? getPrimaryColor(context, themeNotifier)
                                : Colors.white,
                            width: 0.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: themeNotifier.isLight()
                                ? getPrimaryColor(context, themeNotifier)
                                : Colors.white,
                            width: 0.8,
                          ),
                        )
                    ),
                    onChanged: (val){
                      if(double.tryParse(val) <= maxValue && double.tryParse(val) >= minValue) {
                        if(flag == 1){
                          servicesProvider.currentLoanValue = double.tryParse(val);
                        } else if(flag == 2){
                          servicesProvider.currentNumberOfInstallments = double.tryParse(val);
                        } else if(flag == 3){
                          servicesProvider.currentFinancialCommitment = double.tryParse(val);
                        }
                      } else if(double.tryParse(val) > maxValue){
                        if(flag == 1){
                          servicesProvider.currentLoanValue = maxValue;
                        } else if(flag == 2){
                          servicesProvider.currentNumberOfInstallments = maxValue;
                        } else if(flag == 3){
                          servicesProvider.currentFinancialCommitment = maxValue;
                        }
                      } else{
                        if(flag == 1){
                          servicesProvider.currentLoanValue = minValue;
                        } else if(flag == 2){
                          servicesProvider.currentNumberOfInstallments = minValue;
                        } else if(flag == 3){
                          servicesProvider.currentFinancialCommitment = minValue;
                        }
                      }
                    },
                    onEditingComplete: (){
                      servicesProvider.notifyMe();
                    },
                  ),
                ),
                const SizedBox(width: 10.0,),
                Text(getTranslated(flag == 2 ? 'month' : 'jd', context))
              ],
            ),
            SizedBox(height: withSlider ? 10.0 : 0.0,),
            if(withSlider)
              Column(
                children: [
                  Slider(
                    activeColor: HexColor('#2D452E'),
                    inactiveColor: HexColor('#E0E0E0'),
                    value: flag == 1 ? servicesProvider.currentLoanValue : servicesProvider.currentNumberOfInstallments,
                    min: minValue,
                    max: maxValue,
                    divisions: minValue != maxValue ? (maxValue - minValue).floor() : 1,
                    label: '${(flag == 1 ? servicesProvider.currentLoanValue : servicesProvider.currentNumberOfInstallments).round()} ${getTranslated(flag == 2 ? 'month' : 'jd', context)}',
                    onChanged: (double value) {
                      servicesProvider.notifyMe();
                      setState(() {
                        if(flag == 1){
                          servicesProvider.currentLoanValue = value;
                        } else if(flag == 2){
                          servicesProvider.currentNumberOfInstallments = value;
                        }
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${minValue.toStringAsFixed(flag == 2 ? 0 : 1)} ${getTranslated(flag == 2 ? 'month' : 'jd', context)}',
                          style: const TextStyle(
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          '${maxValue.toStringAsFixed(flag == 2 ? 0 : 1)} ${getTranslated(flag == 2 ? 'month' : 'jd', context)}',
                          style: const TextStyle(
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
          ],
        ),
      ),
    );
  }


}
