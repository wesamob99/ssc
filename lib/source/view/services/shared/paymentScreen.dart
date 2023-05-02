// ignore_for_file: file_names

import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:ssc/infrastructure/userConfig.dart';
import 'package:ssc/utilities/theme/themes.dart';

import '../../../../../utilities/hexColor.dart';
import '../../../../../utilities/util.dart';
import '../../../../utilities/countries.dart';
import '../../../viewModel/login/loginProvider.dart';
import '../../../viewModel/services/servicesProvider.dart';
import '../../../viewModel/utilities/theme/themeProvider.dart';

class PaymentScreen extends StatefulWidget {
  final String stepText;
  final String nextStep;
  final int numberOfSteps;
  final int stepNumber;
  const PaymentScreen({Key key, this.stepText, this.stepNumber, this.numberOfSteps, this.nextStep}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Future documentsFuture;
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
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    return buildPaymentBody(themeNotifier);
  }

  Widget buildPaymentBody(themeNotifier){
    return SizedBox(
      height: isTablet(context) ? height(0.78, context) : isScreenHasSmallHeight(context) ? height(0.73, context) : height(0.75, context),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: height(0.02, context),),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getTranslated(widget.stepText, context),
                  style: TextStyle(
                      color: HexColor('#979797'),
                      fontSize: width(0.03, context)
                  ),
                ),
                SizedBox(height: height(0.006, context),),
                Text(
                  getTranslated('receiptOfAllowances', context),
                  style: TextStyle(
                      color: HexColor('#5F5F5F'),
                      fontSize: width(0.035, context)
                  ),
                )
              ],
            ),
            SizedBox(height: height(0.01, context),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox.shrink(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${widget.stepNumber}/${widget.numberOfSteps}',
                      style: TextStyle(
                          color: HexColor('#979797'),
                          fontSize: width(0.025, context)
                      ),
                    ),
                    Text(
                      '${getTranslated('next', context)}: ${getTranslated(widget.nextStep, context)}',
                      style: TextStyle(
                          color: HexColor('#979797'),
                          fontSize: width(0.032, context)
                      ),
                    ),
                  ],
                ),
              ],
            ),
            //activePayment
            SizedBox(height: height(0.02, context),),
            buildFieldTitle(context, 'methodOfReceivingTheAllowance', required: false),
            const SizedBox(height: 10.0,),
            if(servicesProvider.activePayment.contains(servicesProvider.activePayment.where((element) => [1, 3, 4].contains(element['ID'])).first) &&
                servicesProvider.activePayment.contains(servicesProvider.activePayment.where((element) => element['ID']  == 5).first))
            customTwoRadioButtons('insideJordan', 'outsideJordan', setState),
            if(!servicesProvider.activePayment.contains(servicesProvider.activePayment.where((element) => [1, 3, 4].contains(element['ID'])).first) &&
                servicesProvider.activePayment.contains(servicesProvider.activePayment.where((element) => element['ID']  == 5).first))
            buildFieldTitle(context, 'outsideJordan', required: false),
            if(servicesProvider.activePayment.contains(servicesProvider.activePayment.where((element) => [1, 3, 4].contains(element['ID'])).first) &&
                !servicesProvider.activePayment.contains(servicesProvider.activePayment.where((element) => element['ID']  == 5).first))
            buildFieldTitle(context, 'insideJordan', required: false),
            const SizedBox(height: 10.0,),
            if(servicesProvider.selectedInsideOutsideJordan == 'insideJordan')
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: SizedBox(
                height: 110,
                child: ListView.builder(
                  itemCount: servicesProvider.activePayment.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index){
                    return servicesProvider.activePayment[index]['ID'] != 5
                    ? Row(
                      children: [
                        InkWell(
                          onTap: (){
                            setState(() {
                              servicesProvider.selectedActivePayment = servicesProvider.activePayment[index];
                              servicesProvider.notifyMe();
                            });
                          },
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(
                                color: (servicesProvider.selectedActivePayment == servicesProvider.activePayment[index]) ? primaryColor : HexColor('#C9C9C9'),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  servicesProvider.activePayment[index]["ID"] == 3
                                  ? 'assets/icons/bank.svg' : servicesProvider.activePayment[index]["ID"] == 1
                                  ? 'assets/icons/moneycheck.svg' : 'assets/icons/eWallet.svg',
                                  color: (servicesProvider.selectedActivePayment == servicesProvider.activePayment[index]) ? primaryColor : HexColor('#C9C9C9'),
                                ),
                                const SizedBox(height: 5.0,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                  child: Text(
                                    UserConfig.instance.isLanguageEnglish()
                                    ? servicesProvider.activePayment[index]["NAME_EN"]
                                    : servicesProvider.activePayment[index]["NAME_AR"],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: (servicesProvider.selectedActivePayment == servicesProvider.activePayment[index]) ? primaryColor : HexColor('#C9C9C9'),
                                      fontSize: 8.0,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10.0,)
                      ],
                    ) : const SizedBox.shrink();
                  },
                ),
              ),
            ),
            if(servicesProvider.selectedInsideOutsideJordan == 'insideJordan')
            Container(),
            // SizedBox(
            //   height: servicesProvider.activePayment.length * 40.0,
            //   child: customRadioButtonGroup(servicesProvider.activePayment, setState),
            // ),
            if(servicesProvider.selectedActivePayment['ID'] == 3) // inside jordan
              Text(
                servicesProvider.result["p_per_info"][0][0]["IBAN"] != null && servicesProvider.result["p_per_info"][0][0]["IBAN"].length == 30
                    ? '${getTranslated('iban', context)}: ${servicesProvider.result["p_per_info"][0][0]["IBAN"]}'
                    : getTranslated('goToYourBanksApplicationAndSendYourIBANToTheEscrow', context),
              ),
            if(servicesProvider.selectedActivePayment['ID'] == 5) // outside jordan
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildFieldTitle(context, 'country', required: false),
                  const SizedBox(height: 10.0,),
                  // buildTextFormField(context, themeNotifier, countryController, '', (val){
                  //   servicesProvider.notifyMe();
                  // }),
                  buildCountriesDropDown(servicesProvider.selectedPaymentCountry, 1),
                  const SizedBox(height: 16,),
                  buildFieldTitle(context, 'bankName', required: false),
                  const SizedBox(height: 10.0,),
                  buildTextFormField(context, themeNotifier, servicesProvider.bankNameController, '', (val){
                    servicesProvider.notifyMe();
                  }),
                  const SizedBox(height: 16,),
                  buildFieldTitle(context, 'bankBranch', required: false),
                  const SizedBox(height: 10.0,),
                  buildTextFormField(context, themeNotifier, servicesProvider.bankBranchController, '', (val){
                    servicesProvider.notifyMe();
                  }),
                  const SizedBox(height: 16,),
                  buildFieldTitle(context, 'bankAddress', required: false),
                  const SizedBox(height: 10.0,),
                  buildTextFormField(context, themeNotifier, servicesProvider.bankAddressController, '', (val){
                    servicesProvider.notifyMe();
                  }),
                  const SizedBox(height: 16,),
                  buildFieldTitle(context, 'accountNumber', required: false),
                  const SizedBox(height: 10.0,),
                  buildTextFormField(context, themeNotifier, servicesProvider.accountNoController, '', (val){
                    servicesProvider.notifyMe();
                  }, inputType: TextInputType.number),
                  const SizedBox(height: 16,),
                  buildFieldTitle(context, 'swiftCode', required: false),
                  const SizedBox(height: 10.0,),
                  buildTextFormField(context, themeNotifier, servicesProvider.swiftCodeController, '', (val){
                    servicesProvider.notifyMe();
                  }, inputType: TextInputType.text),
                  const SizedBox(height: 16,),
                  buildFieldTitle(context, 'mobileNumber', required: false),
                  const SizedBox(height: 10.0,),
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: buildTextFormField(context, themeNotifier, servicesProvider.paymentMobileNumberController, '', (val){
                          servicesProvider.notifyMe();
                        }, inputType: TextInputType.number),
                      ),
                      const SizedBox(width: 10.0,),
                      Expanded(
                        flex: 2,
                        child: buildCountriesDropDown(servicesProvider.selectedPaymentCountry, 2),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20,),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget customRadioButtonGroup(List choices, setState){
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: choices.length,
        itemBuilder: (context, index){
          return Column(
            children: [
              InkWell(
                onTap: (){
                  setState(() {
                    servicesProvider.selectedActivePayment = choices[index];
                    servicesProvider.notifyMe();
                  });
                },
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(500.0),
                        border: Border.all(
                          color: HexColor('#2D452E'),
                        ),
                      ),
                      padding: const EdgeInsets.all(2.0),
                      child: CircleAvatar(
                        radius: isTablet(context) ? 10 : 5,
                        backgroundColor: servicesProvider.selectedActivePayment == choices[index]
                            ? HexColor('#2D452E') : Colors.transparent,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        UserConfig.instance.isLanguageEnglish()
                        ? choices[index]['NAME_EN'] : choices[index]['NAME_AR'],
                        style: TextStyle(
                          color: HexColor('#666666'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: index == choices.length -1 ? 10.0 : 0.0,)
            ],
          );
        }
    );
  }

  Widget buildCountriesDropDown(SelectedListItem selectedCountry, int flag) {
    List<SelectedListItem> selectedListItem = [];
    for (var element in Provider.of<LoginProvider>(context, listen: false).countries) {
      int inx = countries.indexWhere((value) => value.dialCode == element.callingCode);
      if((flag == 1 && element.natcode != 111) || flag == 2) {
        selectedListItem.add(
          SelectedListItem(
            name: UserConfig.instance.isLanguageEnglish() ? countries[inx == -1
                ? 0
                : inx].name : element.country,
            natCode: element.natcode,
            value: countries[inx == -1 ? 0 : inx].dialCode,
            isSelected: false,
            flag: countries[inx == -1 ? 0 : inx].flag,
          ),
        );
      }
    }
    return InkWell(
      onTap: () {
        DropDownState(
          DropDown(
            isSearchVisible: true,
            data: selectedListItem ?? [],
            selectedItems: (List<dynamic> selectedList) {
              for (var item in selectedList) {
                if (item is SelectedListItem) {
                  setState(() {
                    servicesProvider.selectedPaymentCountry = item;
                    servicesProvider.notifyMe();
                  });
                }
              }
            },
            enableMultipleSelection: false,
          ),
        ).showModal(context);
      },
      child: Container(
          alignment: UserConfig.instance.isLanguageEnglish()
              ? Alignment.centerLeft
              : Alignment.centerRight,
          padding: const EdgeInsets.symmetric(
              horizontal: 16.0, vertical: 9.3),
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                  color: HexColor('#979797')
              )
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    selectedCountry?.flag ?? "",
                    style: const TextStyle(
                      fontSize: 25,
                    ),
                  ),
                  SizedBox(width: width(0.01, context),),
                  Text(
                    flag == 1 ? selectedCountry.name : selectedCountry?.value ?? "",
                    style: TextStyle(
                        color: HexColor('#363636'),
                        fontSize: 15
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.arrow_drop_down_outlined,
                color: HexColor('#363636'),
              )
            ],
          )
      ),
    );
  }

  Widget customTwoRadioButtons(String firstChoice, String secondChoice, setState){
    return Row(
      children: [
        InkWell(
          onTap: (){
            setState(() {
              servicesProvider.selectedInsideOutsideJordan = firstChoice;
              for (var element in servicesProvider.activePayment) {
                if(element['ID'] == 1 || element['ID'] == 4 || element['ID'] == 3){
                  if(servicesProvider.activePayment.contains(servicesProvider.activePayment.where((element) => element['ID']  == 3).first)){
                    servicesProvider.selectedActivePayment = servicesProvider.activePayment.where((element) => element['ID']  == 3).first;
                  } else{
                    servicesProvider.selectedActivePayment = element;
                  }
                }
              }
              servicesProvider.notifyMe();
            });
          },
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(500.0),
                  border: Border.all(
                    color: HexColor('#2D452E'),
                  ),
                ),
                padding: const EdgeInsets.all(2.0),
                child: CircleAvatar(
                  radius: isTablet(context) ? 10 : 5,
                  backgroundColor: (servicesProvider.selectedInsideOutsideJordan == firstChoice)
                      ? HexColor('#2D452E')
                      : Colors.transparent,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  getTranslated(firstChoice, context),
                  style: TextStyle(
                    color: HexColor('#666666'),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10.0,),
        InkWell(
          onTap: (){
            setState(() {
              servicesProvider.selectedInsideOutsideJordan = secondChoice;
              servicesProvider.selectedActivePayment = servicesProvider.activePayment.where((element) => element['ID']  == 5).first;
              servicesProvider.notifyMe();
            });
          },
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(500.0),
                  border: Border.all(
                    color: HexColor('#2D452E'),
                  ),
                ),
                padding: const EdgeInsets.all(2.0),
                child: CircleAvatar(
                  radius: isTablet(context) ? 10 : 5,
                  backgroundColor: (servicesProvider.selectedInsideOutsideJordan == secondChoice)
                      ? HexColor('#2D452E')
                      : Colors.transparent,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  getTranslated(secondChoice, context),
                  style: TextStyle(
                    color: HexColor('#666666'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }


}

// Widget fifthStep(context, themeNotifier){
//   return SizedBox(
//     height: isTablet(context) ? height(0.78, context) : isScreenHasSmallHeight(context) ? height(0.73, context) : height(0.75, context),
//     child: SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(height: height(0.02, context),),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 getTranslated('fifthStep', context),
//                 style: TextStyle(
//                     color: HexColor('#979797'),
//                     fontSize: width(0.03, context)
//                 ),
//               ),
//               SizedBox(height: height(0.006, context),),
//               Text(
//                 getTranslated('receiptOfAllowances', context),
//                 style: TextStyle(
//                     color: HexColor('#5F5F5F'),
//                     fontSize: width(0.035, context)
//                 ),
//               )
//             ],
//           ),
//           SizedBox(height: height(0.01, context),),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const SizedBox.shrink(),
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   Text(
//                     '5/6',
//                     style: TextStyle(
//                         color: HexColor('#979797'),
//                         fontSize: width(0.025, context)
//                     ),
//                   ),
//                   Text(
//                     '${getTranslated('next', context)}: ${getTranslated('confirmRequest', context)}',
//                     style: TextStyle(
//                         color: HexColor('#979797'),
//                         fontSize: width(0.032, context)
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           //activePayment
//           SizedBox(height: height(0.02, context),),
//           buildFieldTitle(context, 'methodOfReceivingTheAllowance', required: false),
//           const SizedBox(height: 10.0,),
//           // customTwoRadioButtons(5, 'insideJordan', 'outsideJordan', setState),
//           SizedBox(
//             height: activePayment.length * 50.0,
//             child: customRadioButtonGroup(3, activePayment, setState),
//           ),
//           if(selectedActivePayment['ID'] == 3) // inside jordan
//           Text(
//             servicesProvider.result["p_per_info"][0][0]["IBAN"] != null && servicesProvider.result["p_per_info"][0][0]["IBAN"].length == 30
//             ? '${getTranslated('iban', context)}: ${servicesProvider.result["p_per_info"][0][0]["IBAN"]}'
//             : getTranslated('goToYourBanksApplicationAndSendYourIBANToTheEscrow', context),
//           ),
//           if(selectedActivePayment['ID'] == 5) // outside jordan
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               buildFieldTitle(context, 'country', required: false),
//               const SizedBox(height: 10.0,),
//               // buildTextFormField(context, themeNotifier, countryController, '', (val){
//               //   servicesProvider.notifyMe();
//               // }),
//               buildCountriesDropDown(selectedPaymentCountry, 1),
//               const SizedBox(height: 16,),
//               buildFieldTitle(context, 'bankName', required: false),
//               const SizedBox(height: 10.0,),
//               buildTextFormField(context, themeNotifier, bankNameController, '', (val){
//                 servicesProvider.notifyMe();
//               }),
//               const SizedBox(height: 16,),
//               buildFieldTitle(context, 'bankBranch', required: false),
//               const SizedBox(height: 10.0,),
//               buildTextFormField(context, themeNotifier, bankBranchController, '', (val){
//                 servicesProvider.notifyMe();
//               }),
//               const SizedBox(height: 16,),
//               buildFieldTitle(context, 'bankAddress', required: false),
//               const SizedBox(height: 10.0,),
//               buildTextFormField(context, themeNotifier, bankAddressController, '', (val){
//                 servicesProvider.notifyMe();
//               }),
//               const SizedBox(height: 16,),
//               buildFieldTitle(context, 'accountNumber', required: false),
//               const SizedBox(height: 10.0,),
//               buildTextFormField(context, themeNotifier, accountNoController, '', (val){
//                 servicesProvider.notifyMe();
//               }, inputType: TextInputType.number),
//               const SizedBox(height: 16,),
//               buildFieldTitle(context, 'swiftCode', required: false),
//               const SizedBox(height: 10.0,),
//               buildTextFormField(context, themeNotifier, swiftCodeController, '', (val){
//                 servicesProvider.notifyMe();
//               }, inputType: TextInputType.text),
//               const SizedBox(height: 16,),
//               buildFieldTitle(context, 'mobileNumber', required: false),
//               const SizedBox(height: 10.0,),
//               Row(
//                 children: [
//                   Expanded(
//                     flex: 4,
//                     child: buildTextFormField(context, themeNotifier, mobileNumberController, '', (val){
//                       servicesProvider.notifyMe();
//                     }, inputType: TextInputType.number),
//                   ),
//                   const SizedBox(width: 10.0,),
//                   Expanded(
//                     flex: 2,
//                     child: buildCountriesDropDown(selectedMobileCountry, 2),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20,),
//             ],
//           ),
//         ],
//       ),
//     ),
//   );
// }
