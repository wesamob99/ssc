// ignore_for_file: file_names

import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssc/infrastructure/userConfig.dart';

import '../../../../../utilities/hexColor.dart';
import '../../../../../utilities/util.dart';
import '../../../../utilities/countries.dart';
import '../../../viewModel/login/loginProvider.dart';
import '../../../viewModel/services/servicesProvider.dart';
import '../../../viewModel/utilities/theme/themeProvider.dart';

class PaymentScreen extends StatefulWidget {
  final String nextStep;
  final int numberOfSteps;
  const PaymentScreen({Key key, this.numberOfSteps, this.nextStep}) : super(key: key);

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
                  getTranslated('fifthStep', context),
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
                      '5/${widget.numberOfSteps}',
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
            // customTwoRadioButtons(5, 'insideJordan', 'outsideJordan', setState),
            SizedBox(
              height: servicesProvider.activePayment.length * 40.0,
              child: customRadioButtonGroup(servicesProvider.activePayment, setState),
            ),
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
                        child: buildCountriesDropDown(servicesProvider.selectedMobileCountry, 2),
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
                    if(flag == 1){
                      servicesProvider.selectedPaymentCountry = item;
                    }else if(flag == 2){
                      servicesProvider.selectedMobileCountry = item;
                    }
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
