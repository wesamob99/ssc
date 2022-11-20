// ignore_for_file: file_names

import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../infrastructure/userConfig.dart';
import '../../../../../models/profile/userProfileData.dart';
import '../../../../../utilities/countries.dart';
import '../../../../../utilities/hexColor.dart';
import '../../../../../utilities/util.dart';
import '../../../viewModel/services/servicesProvider.dart';
import '../../../viewModel/utilities/theme/themeProvider.dart';

class FirstStepScreen extends StatefulWidget {
  final String nextStep;
  final int numberOfSteps;
  const FirstStepScreen({Key key, this.nextStep, this.numberOfSteps}) : super(key: key);

  @override
  State<FirstStepScreen> createState() => _FirstStepScreenState();
}

class _FirstStepScreenState extends State<FirstStepScreen> {
  Future accountDataFuture;
  ServicesProvider servicesProvider;
  SelectedListItem selectedCountry;
  bool isFirstTime;

  @override
  void initState() {
    servicesProvider = Provider.of<ServicesProvider>(context, listen: false);
    accountDataFuture = servicesProvider.getAccountData();
    isFirstTime = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    return SingleChildScrollView(
      child: SizedBox(
        height: isTablet(context) ? height(0.8, context) : isScreenHasSmallHeight(context) ? height(0.75, context) : height(0.77, context),
        child: FutureBuilder(
            future: accountDataFuture,
            builder: (context, snapshot){
              switch(snapshot.connectionState){
                case ConnectionState.none:
                  return somethingWrongWidget(context, 'somethingWrongHappened', 'somethingWrongHappenedDesc'); break;
                case ConnectionState.waiting:
                case ConnectionState.active:
                  return Container(
                      height: height(0.7, context),
                      alignment: Alignment.center,
                      child: animatedLoader(context)
                  ); break;
                case ConnectionState.done:
                  if(snapshot.hasData && !snapshot.hasError){
                    UserProfileData userProfileData = snapshot.data;
                    CurGetdatum data = userProfileData.curGetdata[0][0];

                    String name = '${data.firstname??''} ${data.fathername??''} ${data.grandfathername??''} ${data.familyname??''}';
                    String natId = data.userName.toString();
                    String insuranceNo = data.insuranceno.toString();
                    String mobileNo = data.mobilenumber.toString();

                    if(isFirstTime){
                      String internationalCode = data.internationalcode.toString();
                      int selectedInx = servicesProvider.countries.indexWhere((value) => value.callingCode == internationalCode);
                      int selectedInxF = countries.indexWhere((value) => value.dialCode == internationalCode);
                      selectedCountry = SelectedListItem(
                        name: UserConfig.instance.checkLanguage() ? servicesProvider.countries[selectedInx].countryEn : servicesProvider.countries[selectedInx].country,
                        value: servicesProvider.countries[selectedInx].callingCode, natCode: servicesProvider.countries[selectedInx].natcode,
                        flag: countries[selectedInxF].flag,
                      );
                      isFirstTime = false;
                    }

                    List<SelectedListItem> selectedListItem = [];
                    for (var element in servicesProvider.countries) {
                      int inx = countries.indexWhere((value) => value.dialCode == element.callingCode);
                      selectedListItem.add(
                        SelectedListItem(
                          name: UserConfig.instance.checkLanguage() ? countries[inx == -1 ? 0 : inx].name : element.country,
                          natCode: element.natcode,
                          value: countries[inx == -1 ? 0 : inx].dialCode,
                          isSelected: false,
                          flag: countries[inx == -1 ? 0 : inx].flag,
                        ),
                      );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: height(0.02, context),),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              translate('firstStep', context),
                              style: TextStyle(
                                  color: HexColor('#979797'),
                                  fontSize: width(0.03, context)
                              ),
                            ),
                            SizedBox(height: height(0.006, context),),
                            Text(
                              translate('confirmPersonalInformation', context),
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
                                  '1/${widget.numberOfSteps}',
                                  style: TextStyle(
                                      color: HexColor('#979797'),
                                      fontSize: width(0.025, context)
                                  ),
                                ),
                                Text(
                                  '${translate('next', context)}: ${translate(widget.nextStep, context)}',
                                  style: TextStyle(
                                      color: HexColor('#979797'),
                                      fontSize: width(0.032, context)
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: height(0.02, context),),
                        Text(
                          translate('quatrainNoun', context),
                          style: TextStyle(
                              color: HexColor('#363636'),
                              fontSize: width(0.032, context)
                          ),
                        ),
                        SizedBox(height: height(0.015, context),),
                        buildTextFormField(context, themeNotifier, TextEditingController(text: name), '', (val){}, enabled: false),
                        SizedBox(height: height(0.015, context),),
                        Text(
                          translate('nationalId', context),
                          style: TextStyle(
                              color: HexColor('#363636'),
                              fontSize: width(0.032, context)
                          ),
                        ),
                        SizedBox(height: height(0.015, context),),
                        buildTextFormField(context, themeNotifier, TextEditingController(text: natId), '', (val){}, enabled: false),
                        SizedBox(height: height(0.015, context),),
                        Text(
                          translate('securityNumber', context),
                          style: TextStyle(
                              color: HexColor('#363636'),
                              fontSize: width(0.032, context)
                          ),
                        ),
                        SizedBox(height: height(0.015, context),),
                        buildTextFormField(context, themeNotifier, TextEditingController(text: insuranceNo), '', (val){}, enabled: false),
                        SizedBox(height: height(0.015, context),),
                        Text(
                          translate('mobileNumber', context),
                          style: TextStyle(
                              color: HexColor('#363636'),
                              fontSize: width(0.032, context)
                          ),
                        ),
                        SizedBox(height: height(0.015, context),),
                        Row(
                          children: [
                            Expanded(
                                child: buildTextFormField(context, themeNotifier, TextEditingController(text: mobileNo), '', (val){})
                            ),
                            SizedBox(width: width(0.015, context)),
                            InkWell(
                              onTap: (){
                                DropDownState(
                                  DropDown(
                                    isSearchVisible: true,
                                    data: selectedListItem ?? [],
                                    selectedItems: (List<dynamic> selectedList) {
                                      for(var item in selectedList) {
                                        if(item is SelectedListItem) {
                                          setState(() {
                                            selectedCountry = item;
                                          });
                                        }
                                      }
                                    },
                                    enableMultipleSelection: false,
                                  ),
                                ).showModal(context);
                              },
                              child: Container(
                                width: width(isTablet(context) ? 0.14 : 0.23, context),
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: isTablet(context) ? 15 : 9),
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
                                    Text(
                                      '+${selectedCountry.value}',
                                      textDirection: TextDirection.ltr,
                                      style: TextStyle(
                                          color: HexColor('#363636'),
                                          fontSize: isTablet(context) ? 18 : 15
                                      ),
                                    ),
                                    Text(
                                      selectedCountry.flag,
                                      style: TextStyle(
                                          color: HexColor('#363636'),
                                          fontSize: isTablet(context) ? 28 : 25
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                        // IntlPhoneField(
                        //   controller: servicesProvider.mobileNumberController,
                        //   disableLengthCheck: true,
                        //   cursorColor: getPrimaryColor(context, themeNotifier),
                        //   cursorWidth: 1,
                        //   decoration: InputDecoration(
                        //     prefixIconColor: Colors.red,
                        //     contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                        //       errorText: null,
                        //       errorBorder: OutlineInputBorder(
                        //         borderRadius: BorderRadius.circular(8),
                        //         borderSide: BorderSide(
                        //           color: getPrimaryColor(context, themeNotifier),
                        //           width: 0.5,
                        //         ),
                        //       ),
                        //       border: OutlineInputBorder(
                        //         borderRadius: BorderRadius.circular(8),
                        //         borderSide: BorderSide(
                        //           color: getPrimaryColor(context, themeNotifier),
                        //           width: 0.5,
                        //         ),
                        //       ),
                        //       focusedBorder: OutlineInputBorder(
                        //         borderRadius: BorderRadius.circular(8),
                        //         borderSide: BorderSide(
                        //           color: getPrimaryColor(context, themeNotifier),
                        //           width: 0.8,
                        //         ),
                        //       )
                        //   ),
                        //   initialCountryCode: 'JO',
                        //   onChanged: (phone) {
                        //     print(phone.completeNumber);
                        //   },
                        // )
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
}
