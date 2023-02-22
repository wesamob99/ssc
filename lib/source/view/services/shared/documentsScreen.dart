// ignore_for_file: file_names

import 'dart:convert';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_svg/svg.dart';
import 'package:open_filex/open_filex.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;

import '../../../../../infrastructure/userConfig.dart';
import '../../../../../utilities/hexColor.dart';
import '../../../../../utilities/util.dart';
import '../../../../utilities/theme/themes.dart';
import '../../../viewModel/services/servicesProvider.dart';
import '../../../viewModel/utilities/theme/themeProvider.dart';

class DocumentsScreen extends StatefulWidget {
  final String nextStep;
  final int numberOfSteps;
  const DocumentsScreen({Key key, this.nextStep, this.numberOfSteps}) : super(key: key);

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  Future documentsFuture;
  ServicesProvider servicesProvider;
  ThemeNotifier themeNotifier;

  @override
  void initState() {
    servicesProvider = Provider.of<ServicesProvider>(context, listen: false);
    themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    final result = servicesProvider.result;
    documentsFuture = servicesProvider.getRequiredDocuments(
        jsonEncode({
          "PAYMENT_METHOD": result['P_Result'][0][0]['PAYMENT_METHOD'],
          "BANK_LOCATION": result['P_Result'][0][0]['BANK_LOCATION'], /// update
          "BRANCH_ID": result['P_Result'][0][0]['BRANCH_ID'],
          "BRANCH_NAME": result['P_Result'][0][0]['BRANCH_NAME'],
          "BANK_ID": result['P_Result'][0][0]['BANK_ID'],
          "BANK_NAME": result['P_Result'][0][0]['BANK_NAME'],
          "ACCOUNT_NAME": result['P_Result'][0][0]['ACCOUNT_NAME'],
          "PAYMENT_COUNTRY": result['P_Result'][0][0]['PAYMENT_COUNTRY'],
          "PAYMENT_COUNTRY_CODE": result['P_Result'][0][0]['PAYMENT_COUNTRY_CODE'],
          "PAYMENT_PHONE": result['P_Result'][0][0]['PAYMENT_PHONE'],
          "IFSC": result['P_Result'][0][0]['IFSC'],
          "SWIFT_CODE": result['P_Result'][0][0]['SWIFT_CODE'], /// update
          "BANK_DETAILS": result['P_Result'][0][0]['BANK_DETAILS'], /// update
          "IBAN": result['P_Result'][0][0]['IBAN'],
          "CASH_BANK_ID": result['P_Result'][0][0]['CASH_BANK_ID'],
          "REP_NATIONALITY": result['P_Result'][0][0]['REP_NATIONALITY'], /// update
          "REP_NATIONAL_NO": result['P_Result'][0][0]['REP_NATIONAL_NO'], /// update
          "REP_NAME": result['P_Result'][0][0]['REP_NAME'], /// update
          "WALLET_TYPE": result['P_Result'][0][0]['WALLET_TYPE'],
          "WALLET_OTP_VERIVIED": null,
          "WALLET_OTP": null,
          "WALLET_PHONE": result['P_Result'][0][0]['WALLET_PHONE'],
          "WALLET_PHONE_VERIVIED": result['P_Result'][0][0]['WALLET_PHONE_VERIVIED'],
          "WALLET_PASSPORT_NUMBER": result['P_Result'][0][0]['WALLET_PASSPORT_NUMBER'],
          "PEN_IBAN": result['P_Result'][0][0]['PEN_IBAN'],
          "SECNO": result['p_per_info'][0][0]['SECNO'],
          "NAT_DESC": result['p_per_info'][0][0]['NAT_DESC'],
          "NAT": result['P_Result'][0][0]['NAT'],
          "NAT_NO": result['P_Result'][0][0]['NAT_NO'],
          "PERS_NO": result['P_Result'][0][0]['PERS_NO'],
          "LAST_EST_NAME": result['P_Result'][0][0]['LAST_EST_NAME'],
          "NAME1": result['p_per_info'][0][0]['NAME1'],
          "NAME2": result['p_per_info'][0][0]['NAME2'],
          "NAME3": result['p_per_info'][0][0]['NAME3'],
          "NAME4": result['p_per_info'][0][0]['NAME4'],
          "FULL_NAME_EN": result['p_per_info'][0][0]['FULL_NAME_EN'],
          "EMAIL": result['p_per_info'][0][0]['EMAIL'],
          "MOBILE": result['p_per_info'][0][0]['MOBILE'],
          "INTERNATIONAL_CODE": result['p_per_info'][0][0]['INTERNATIONAL_CODE'],
          "INSURED_ADDRESS": result['P_Result'][0][0]['INSURED_ADDRESS'],
          "MARITAL_STATUS": result['P_Result'][0][0]['MARITAL_STATUS'],
          "REGDATE": null,
          "REGRATE": null,
          "LAST_SALARY": null,
          "LAST_STODATE": result['P_Result'][0][0]['LAST_STODATE'],
          "ACTUAL_STODATE": result['P_Result'][0][0]['ACTUAL_STODATE'],
          "GENDER": result['p_per_info'][0][0]['GENDER'],
          "CIVIL_WORK_DOC": result['P_Result'][0][0]['CIVIL_WORK_DOC'],
          "MILITARY_WORK_DOC": result['P_Result'][0][0]['MILITARY_WORK_DOC'],
          "CIV_MIL_RETIRED_DOC": result['P_Result'][0][0]['CIV_MIL_RETIRED_DOC'],
          "PEN_START_DATE": result['P_Result'][0][0]['PEN_START_DATE'],
          "GOVERNORATE": result['P_Result'][0][0]['GOVERNORATE'],
          "DETAILED_ADDRESS": null,
          "PASS_NO": null,
          "RESIDENCY_NO": null,
          "DOB": result['p_per_info'][0][0]['DOB'],
          "JOB_NO": null,
          "JOB_DESC": result['P_Result'][0][0]['JOB_DESC'],
          "ENAME1": null,
          "ENAME2": null,
          "ENAME3": null,
          "ENAME4": null,
          "LAST_EST_NO": result['P_Result'][0][0]['LAST_EST_NO'], /// update
          "FAM_NO": null,
          "nextVaild": null,
          "wantAddFamily": null,
          "GENDER_DESC": result['p_per_info'][0][0]['GENDER_DESC'],
          "PI_EPAY": null,
          "INSURED": null,
          "ID": result['P_Result'][0][0]['ID'], /// update
          "DEP_FLAG": 0
        }),
        result['P_Result'][0][0]['SERVICE_TYPE']
    );
    servicesProvider.mandatoryDocuments = [];
    servicesProvider.optionalDocuments = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    return buildDocumentsBody(themeNotifier);
  }

  Widget buildDocumentsBody(themeNotifier){
    return FutureBuilder(
        future: documentsFuture,
        builder: (context, snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.none:
              return somethingWrongWidget(context, 'somethingWrongHappened', 'somethingWrongHappenedDesc'); break;
            case ConnectionState.waiting:
            case ConnectionState.active:
              return SizedBox(
                height: isTablet(context) ? height(0.78, context) : isScreenHasSmallHeight(context) ? height(0.73, context) : height(0.75, context),
                child: Center(
                  child: animatedLoader(context),
                ),
              ); break;
            case ConnectionState.done:
              if(!snapshot.hasError && snapshot.hasData){
                if(servicesProvider.dependentsDocuments.isNotEmpty && !snapshot.data['R_RESULT'][0].contains(servicesProvider.dependentsDocuments)){
                  snapshot.data['R_RESULT'][0].addAll(servicesProvider.dependentsDocuments);
                }
                for(int i=0 ; i<snapshot.data['R_RESULT'][0].length ; i++){
                  if(snapshot.data['R_RESULT'][0][i]['OPTIONAL'] == 2){
                    if(!servicesProvider.mandatoryDocuments.contains(snapshot.data['R_RESULT'][0][i])) {
                      servicesProvider.uploadedFiles["mandatory"].length ++;
                      servicesProvider.uploadedFiles["mandatory"][i] = servicesProvider.uploadedFiles["mandatory"][i] ?? [];
                      servicesProvider.mandatoryDocuments.add(snapshot.data['R_RESULT'][0][i]);
                    }
                  } else{
                    if(!servicesProvider.optionalDocuments.contains(snapshot.data['R_RESULT'][0][i])) {
                      servicesProvider.uploadedFiles["optional"].length ++;
                      servicesProvider.uploadedFiles["optional"][i] = servicesProvider.uploadedFiles["optional"][i] ?? [];
                      servicesProvider.optionalDocuments.add(snapshot.data['R_RESULT'][0][i]);
                    }
                  }
                }

                return Column(
                  children: [
                    if(Provider.of<ServicesProvider>(context).documentsScreensStepNumber == 1)
                    buildShowDocumentsBody(1),
                    if(Provider.of<ServicesProvider>(context).documentsScreensStepNumber == 2)
                    SizedBox(
                      height: isTablet(context) ? height(0.78, context) : isScreenHasSmallHeight(context) ? height(0.73, context) : height(0.75, context),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 18,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  translate('forthStep', context),
                                  style: TextStyle(
                                      color: HexColor('#979797'),
                                      fontSize: width(0.03, context)
                                  ),
                                ),
                                SizedBox(height: height(0.006, context),),
                                Text(
                                  translate('documents', context),
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
                                      '4/${widget.numberOfSteps}',
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
                            const SizedBox(height: 18,),
                            if(servicesProvider.mandatoryDocuments.isNotEmpty)
                              Text(
                                translate('mandatoryDocumentsRequired', context)
                                    + ' ( ${Provider.of<ServicesProvider>(context).documentIndex + 1} / ${(servicesProvider.mandatoryDocuments.length)} )',
                                style: TextStyle(
                                  color: HexColor('#84692E'),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            if(servicesProvider.mandatoryDocuments.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 40,),
                                  Text(
                                    UserConfig.instance.checkLanguage()
                                        ? '${servicesProvider.mandatoryDocuments[servicesProvider.documentIndex]['NAME_EN']} (${servicesProvider.mandatoryDocuments[servicesProvider.documentIndex]['NAME'] ?? ""})'
                                        : '${servicesProvider.mandatoryDocuments[servicesProvider.documentIndex]['NAME_AR']} (${servicesProvider.mandatoryDocuments[servicesProvider.documentIndex]['NAME'] ?? ""})',
                                    style: TextStyle(
                                        color: themeNotifier.isLight() ? HexColor('#363636') : HexColor('#ffffff'),
                                        fontSize: isTablet(context) ? width(0.025, context) : width(0.032, context)
                                    ),
                                  ),
                                  const SizedBox(height: 20.0,),
                                  ListView.builder(
                                      physics: const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder: (context, index){
                                        return buildFileUploader(index, 1);
                                      },
                                      itemCount: servicesProvider.uploadedFiles["mandatory"][servicesProvider.documentIndex].length + 1
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                    if(Provider.of<ServicesProvider>(context).documentsScreensStepNumber == 3)
                    buildShowDocumentsBody(2),
                    if(Provider.of<ServicesProvider>(context).documentsScreensStepNumber == 4)
                    SizedBox(
                        height: isTablet(context) ? height(0.78, context) : isScreenHasSmallHeight(context) ? height(0.73, context) : height(0.75, context),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 18,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    translate('forthStep', context),
                                    style: TextStyle(
                                        color: HexColor('#979797'),
                                        fontSize: width(0.03, context)
                                    ),
                                  ),
                                  SizedBox(height: height(0.006, context),),
                                  Text(
                                    translate('documents', context),
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
                                        '4/${widget.numberOfSteps}',
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
                              const SizedBox(height: 18,),
                              if(servicesProvider.selectedOptionalDocuments.isNotEmpty)
                                Text(
                                  translate('optionalDocuments', context)
                                      + ' ( ${Provider.of<ServicesProvider>(context).documentIndex + 1} / ${(servicesProvider.selectedOptionalDocuments.length)} )',
                                  style: TextStyle(
                                    color: HexColor('#84692E'),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                              if(servicesProvider.selectedOptionalDocuments.isNotEmpty)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 40,),
                                    Text(
                                      UserConfig.instance.checkLanguage()
                                          ? '${servicesProvider.selectedOptionalDocuments[servicesProvider.documentIndex]['NAME_EN']} (${servicesProvider.mandatoryDocuments[servicesProvider.documentIndex]['NAME'] ?? ""})'
                                          : '${servicesProvider.selectedOptionalDocuments[servicesProvider.documentIndex]['NAME_AR']} (${servicesProvider.mandatoryDocuments[servicesProvider.documentIndex]['NAME'] ?? ""})',
                                      style: TextStyle(
                                          color: themeNotifier.isLight() ? HexColor('#363636') : HexColor('#ffffff'),
                                          fontSize: isTablet(context) ? width(0.025, context) : width(0.032, context)
                                      ),
                                    ),
                                    const SizedBox(height: 20.0,),
                                    ListView.builder(
                                        physics: const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemBuilder: (context, index){
                                          return buildFileUploader(index, 2);
                                        },
                                        itemCount: servicesProvider.uploadedFiles["optional"][servicesProvider.documentIndex].length + 1
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    if(Provider.of<ServicesProvider>(context).documentsScreensStepNumber == 5)
                    SizedBox(
                        height: isTablet(context) ? height(0.78, context) : isScreenHasSmallHeight(context) ? height(0.73, context) : height(0.75, context),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 18,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    translate('forthStep', context),
                                    style: TextStyle(
                                        color: HexColor('#979797'),
                                        fontSize: width(0.03, context)
                                    ),
                                  ),
                                  SizedBox(height: height(0.006, context),),
                                  Text(
                                    translate('documents', context),
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
                                        '4/${widget.numberOfSteps}',
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
                              const SizedBox(height: 18,),
                              if(servicesProvider.mandatoryDocuments.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    translate('mandatoryDocuments', context) + ' ( ${(servicesProvider.mandatoryDocuments.length)} )',
                                    style: TextStyle(
                                      color: HexColor('#84692E'),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 13,),
                                  ListView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: servicesProvider.mandatoryDocuments.length,
                                      itemBuilder: (context, index){
                                        return Padding(
                                          padding: const EdgeInsets.only(bottom: 10.0),
                                          child:  buildExpandableWidget(
                                            context,
                                            UserConfig.instance.checkLanguage()
                                            ? '${servicesProvider.mandatoryDocuments[index]['NAME_EN']} (${servicesProvider.mandatoryDocuments[index]['NAME'] ?? ""})'
                                            : '${servicesProvider.mandatoryDocuments[index]['NAME_AR']} (${servicesProvider.mandatoryDocuments[index]['NAME'] ?? ""})',
                                            ListView.builder(
                                              physics: const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemBuilder: (context, index2){
                                                return Padding(
                                                  padding: const EdgeInsets.only(bottom: 10.0),
                                                  child: InkWell(
                                                    /// TODO: complete opening files
                                                    onTap: () async {
                                                      File file = File(servicesProvider.uploadedFiles["mandatory"][index][index2]['file'].toString().split("'")[1]);
                                                      if (await file.exists()) {
                                                      // file exists, open it
                                                        try{
                                                          OpenFilex.open(file.path);
                                                        }catch(e){
                                                          if (kDebugMode) {
                                                            print(e.toString());
                                                          }
                                                        }
                                                      } else{
                                                        if (kDebugMode) {
                                                          print("file doe's not exists");
                                                        }
                                                      }
                                                    },
                                                    child: DottedBorder(
                                                      radius: const Radius.circular(8.0),
                                                      padding: EdgeInsets.zero,
                                                      color: HexColor('#979797'),
                                                      borderType: BorderType.RRect,
                                                      dashPattern: const [5],
                                                      strokeWidth: 1.2,
                                                      child: Container(
                                                        width: width(1, context),
                                                        padding: EdgeInsets.all(isTablet(context) ? 30 : 20.0),
                                                        decoration: BoxDecoration(
                                                          color: Colors.transparent,
                                                          borderRadius: BorderRadius.circular(8.0),
                                                        ),
                                                        child: Container(
                                                          alignment: Alignment.center,
                                                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              SizedBox(
                                                                width: width(0.6, context),
                                                                child: Text(
                                                                  path.basename(servicesProvider.uploadedFiles["mandatory"][index][index2]['file'].toString().split("'")[1]),
                                                                ),
                                                              ),
                                                              const SizedBox(height: 20.0,),
                                                              Container(
                                                                width: double.infinity,
                                                                height: 11,
                                                                decoration: BoxDecoration(
                                                                    color: HexColor('#008455'),
                                                                    borderRadius: BorderRadius.circular(500.0)
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                              itemCount: servicesProvider.uploadedFiles["mandatory"][index].length
                                            ),
                                            needTranslate: false,
                                            isChildTypeText: false
                                          ),
                                        );
                                      }
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18,),
                              if(servicesProvider.selectedOptionalDocuments.isNotEmpty)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      translate('optionalDocuments', context) + ' ( ${(servicesProvider.selectedOptionalDocuments.length)} )',
                                      style: TextStyle(
                                        color: HexColor('#84692E'),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 13,),
                                    ListView.builder(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: servicesProvider.selectedOptionalDocuments.length,
                                        itemBuilder: (context, index){
                                          return Padding(
                                            padding: const EdgeInsets.only(bottom: 10.0),
                                            child: buildExpandableWidget(
                                                context,
                                                UserConfig.instance.checkLanguage()
                                                ? '${servicesProvider.optionalDocuments[index]['NAME_EN']} (${servicesProvider.mandatoryDocuments[index]['NAME'] ?? ""})'
                                                : '${servicesProvider.optionalDocuments[index]['NAME_AR']} (${servicesProvider.mandatoryDocuments[index]['NAME'] ?? ""})',
                                                ListView.builder(
                                                  physics: const NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemBuilder: (context, index2){
                                                    return Padding(
                                                      padding: const EdgeInsets.only(bottom: 10.0),
                                                      child: InkWell(
                                                        /// TODO: complete opening files
                                                        onTap: () async {
                                                          File file = File(servicesProvider.uploadedFiles["optional"][index][index2]['file'].toString().split("'")[1]);
                                                          if (await file.exists()) {
                                                            // file exists, open it
                                                            try{
                                                              OpenFilex.open(file.path);
                                                            }catch(e){
                                                              if (kDebugMode) {
                                                                print(e.toString());
                                                              }
                                                            }
                                                          } else{
                                                            if (kDebugMode) {
                                                              print("file doe's not exists");
                                                            }
                                                          }
                                                        },
                                                        child: DottedBorder(
                                                          radius: const Radius.circular(8.0),
                                                          padding: EdgeInsets.zero,
                                                          color: HexColor('#979797'),
                                                          borderType: BorderType.RRect,
                                                          dashPattern: const [5],
                                                          strokeWidth: 1.2,
                                                          child: Container(
                                                            width: width(1, context),
                                                            padding: EdgeInsets.all(isTablet(context) ? 30 : 20.0),
                                                            decoration: BoxDecoration(
                                                              color: Colors.transparent,
                                                              borderRadius: BorderRadius.circular(8.0),
                                                            ),
                                                            child: Container(
                                                              alignment: Alignment.center,
                                                              padding: const EdgeInsets.symmetric(vertical: 15.0),
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  SizedBox(
                                                                    width: width(0.6, context),
                                                                    child: Text(path.basename(servicesProvider.uploadedFiles["optional"][index][index2]['file'].toString().split("'")[1])),
                                                                  ),
                                                                  const SizedBox(height: 20.0,),
                                                                  Container(
                                                                    width: double.infinity,
                                                                    height: 11,
                                                                    decoration: BoxDecoration(
                                                                        color: HexColor('#008455'),
                                                                        borderRadius: BorderRadius.circular(500.0)
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            )
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  itemCount: servicesProvider.uploadedFiles["optional"][index].length
                                                ),
                                                needTranslate: false,
                                                isChildTypeText: false
                                            ),
                                          );
                                        }
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    if(Provider.of<ServicesProvider>(context).documentsScreensStepNumber != 1 && Provider.of<ServicesProvider>(context).documentsScreensStepNumber != 3)
                    textButton(context,
                      themeNotifier, 'continue',
                      (servicesProvider.documentsScreensStepNumber == 2 && servicesProvider.uploadedFiles['mandatory'].isNotEmpty && servicesProvider.uploadedFiles['mandatory'][servicesProvider.documentIndex].isNotEmpty) ||
                      (servicesProvider.documentsScreensStepNumber == 4 && servicesProvider.uploadedFiles['optional'].isNotEmpty && servicesProvider.uploadedFiles['optional'][servicesProvider.documentIndex].isNotEmpty) ||
                      servicesProvider.documentsScreensStepNumber == 5
                      ? getPrimaryColor(context, themeNotifier) : HexColor('#DADADA'),
                      (servicesProvider.documentsScreensStepNumber == 2 && servicesProvider.uploadedFiles['mandatory'].isNotEmpty && servicesProvider.uploadedFiles['mandatory'][servicesProvider.documentIndex].isNotEmpty) ||
                      (servicesProvider.documentsScreensStepNumber == 4 && servicesProvider.uploadedFiles['optional'].isNotEmpty && servicesProvider.uploadedFiles['optional'][servicesProvider.documentIndex].isNotEmpty) ||
                      servicesProvider.documentsScreensStepNumber == 5
                      ? HexColor('#ffffff') : HexColor('#363636'),
                      () async {
                        if(servicesProvider.documentsScreensStepNumber == 5){
                          servicesProvider.stepNumber = 5;
                        } else{
                          if(servicesProvider.documentsScreensStepNumber == 2 && servicesProvider.uploadedFiles['mandatory'].isNotEmpty && servicesProvider.uploadedFiles['mandatory'][servicesProvider.documentIndex].isNotEmpty){
                            if(servicesProvider.documentIndex < servicesProvider.mandatoryDocuments.length-1){
                              servicesProvider.documentIndex++;
                            } else if(servicesProvider.documentIndex == servicesProvider.mandatoryDocuments.length-1){
                              servicesProvider.documentIndex = 0;
                              servicesProvider.documentsScreensStepNumber ++;
                            }
                          } else if(servicesProvider.documentsScreensStepNumber == 4 && servicesProvider.uploadedFiles['optional'].isNotEmpty && servicesProvider.uploadedFiles['optional'][servicesProvider.documentIndex].isNotEmpty){
                            if(servicesProvider.documentIndex < servicesProvider.selectedOptionalDocuments.length-1){
                              servicesProvider.documentIndex++;
                            } else if(servicesProvider.documentIndex == servicesProvider.selectedOptionalDocuments.length-1){
                              servicesProvider.documentIndex = 0;
                              servicesProvider.documentsScreensStepNumber ++;
                            }
                          }
                        }
                        servicesProvider.notifyMe();
                      },
                    ),
                  ],
                );
              }
              break;
          }
          return somethingWrongWidget(context, 'somethingWrongHappened', 'somethingWrongHappenedDesc');
        }
    );
  }

  Widget buildShowDocumentsBody(int type){ /// type == 1 for mandatory and 2 for optional
    return Stack(
      children: [
        Container(
          alignment: Alignment.topCenter,
          child: Image.asset('assets/images/backgrounds/documentsBackground.png', width: width(1, context), height: height(0.5, context),),
        ),
        SizedBox(
          height: isTablet(context) ? height(0.78, context) : isScreenHasSmallHeight(context) ? height(0.73, context) : height(0.75, context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Card(
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: const BorderSide(
                        color: Colors.transparent
                    )
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 20.0),
                  child: Column(
                    children: [
                      (type == 1 ? servicesProvider.mandatoryDocuments.isNotEmpty : servicesProvider.optionalDocuments.isNotEmpty)
                      ? Column(
                        children: [
                          Text(
                            translate(type == 1 ? 'mandatoryDocumentsRequired' : 'optionalDocuments', context),
                            style: TextStyle(
                              color: HexColor('#363636'),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 25.0,),
                          buildDocumentsCard(type)
                        ],
                      )
                      : Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          translate(type == 1 ? 'NoMandatoryDocumentsToAdd' : 'NoOptionalDocumentsToAdd', context),
                        ),
                      ),
                      textButton(context, themeNotifier, (type == 1 ? servicesProvider.mandatoryDocuments.isEmpty : servicesProvider.selectedOptionalDocuments.isEmpty) ? 'continue' : 'startNow', HexColor('#445740'), HexColor('#FFFFFF'), (){
                        if((type == 1 && servicesProvider.mandatoryDocuments.isNotEmpty) || (type == 2 && servicesProvider.selectedOptionalDocuments.isNotEmpty)){
                          servicesProvider.documentsScreensStepNumber++;
                        } else{
                          if(type == 1){
                            servicesProvider.documentsScreensStepNumber = 3;
                          } else{
                            servicesProvider.documentsScreensStepNumber = 5;
                          }
                        }
                        servicesProvider.notifyMe();
                      })
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildFileUploader(int index, int type){ /// type = 1 for mandatory and 2 for optional
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: DottedBorder(
        radius: const Radius.circular(8.0),
        padding: EdgeInsets.zero,
        color: HexColor('#979797'),
        borderType: BorderType.RRect,
        dashPattern: const [5],
        strokeWidth: 1.2,
        child: InkWell(
          onTap: () async {
            if(!(servicesProvider.uploadedFiles[type == 1 ? "mandatory" : "optional"][servicesProvider.documentIndex].isNotEmpty && servicesProvider.uploadedFiles[type == 1 ? "mandatory" : "optional"][servicesProvider.documentIndex].length-1 >= index)){
              FilePickerResult result = await FilePicker.platform.pickFiles(
                allowMultiple: true,
              );
              if (result != null) {
                List<File> files = result.paths.map((path) => File(path)).toList();
                for (var element in files) {
                  if(type == 1) {
                    servicesProvider.uploadedFiles["mandatory"][servicesProvider.documentIndex].add({
                      "file": element,
                      "document": servicesProvider.mandatoryDocuments[servicesProvider.documentIndex],
                    });
                  } else {
                    servicesProvider.uploadedFiles["optional"][servicesProvider.documentIndex].add({
                      "file": element,
                      "document": servicesProvider.optionalDocuments[servicesProvider.documentIndex],
                    });
                  }
                }
                setState(() {});
                servicesProvider.notifyMe();
              } else {
                // User canceled the picker
              }
            }
          },
          child: Container(
              width: width(1, context),
              padding: EdgeInsets.all(isTablet(context) ? 30 : 20.0),
              decoration: BoxDecoration(
                  color: (servicesProvider.uploadedFiles[type == 1 ? "mandatory" : "optional"][servicesProvider.documentIndex].isNotEmpty && servicesProvider.uploadedFiles[type == 1 ? "mandatory" : "optional"][servicesProvider.documentIndex].length-1 >= index)
                  ? Colors.transparent : const Color.fromRGBO(117, 161, 119, 0.22),
                  borderRadius: BorderRadius.circular(8.0)
              ),
              child: (servicesProvider.uploadedFiles[type == 1 ? "mandatory" : "optional"][servicesProvider.documentIndex].isNotEmpty && servicesProvider.uploadedFiles[type == 1 ? "mandatory" : "optional"][servicesProvider.documentIndex].length-1 >= index)
              ? Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: width(0.6, context),
                          child: Text(
                            path.basename(servicesProvider.uploadedFiles["mandatory"][servicesProvider.documentIndex][index]['file'].toString().split("'")[1]),
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            if(type == 1) {
                              servicesProvider.uploadedFiles["mandatory"][servicesProvider.documentIndex].removeAt(index);
                            } else {
                              servicesProvider.uploadedFiles["optional"][servicesProvider.documentIndex].removeAt(index);
                            }
                            servicesProvider.notifyMe();
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              children: [
                                SvgPicture.asset('assets/icons/delete.svg'),
                                const SizedBox(width: 5.0,),
                                Text(translate('delete', context))
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0,),
                    Container(
                      width: double.infinity,
                      height: 11,
                      decoration: BoxDecoration(
                        color: HexColor('#008455'),
                        borderRadius: BorderRadius.circular(500.0)
                      ),
                    )
                  ],
                ),
              )
              : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/icons/upload.svg'),
                  const SizedBox(height: 4.0),
                  Text(
                    translate('attachFileHere', context),
                    style: TextStyle(
                      fontSize: 12,
                      color: HexColor('#363636'),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    translate('chooseFile', context),
                    style: TextStyle(
                      color: HexColor('#2D452E'),
                    ),
                  ),
                ],
              )
          ),
        ),
      ),
    );
  }

  buildDocumentsCard(int type){ /// type = 1 for mandatory and 2 for optional
    List documents = type == 1 ? servicesProvider.mandatoryDocuments : servicesProvider.optionalDocuments;
    List<Widget> docs = [];
    while (documents.isNotEmpty) {
      if(type == 2) {
        servicesProvider.optionalDocumentsCheckBox.length = documents.length;
      }
      List chunk = documents.take(4).toList();
      documents = documents.skip(4).toList();
      docs.add(
        ListView.builder(
          itemCount: chunk.length,
          itemBuilder: (BuildContext context, int index) {
            if(type == 2){
              servicesProvider.optionalDocumentsCheckBox[index] = servicesProvider.optionalDocumentsCheckBox[index] ?? false;
            }
            return Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Row(
                children: [
                  type == 1
                  ? SvgPicture.asset('assets/icons/check.svg')
                  : InkWell(
                    onTap: (){
                      setState(() {
                        servicesProvider.optionalDocumentsCheckBox[index] = !servicesProvider.optionalDocumentsCheckBox[index];
                        if(servicesProvider.optionalDocumentsCheckBox[index] && !servicesProvider.selectedOptionalDocuments.contains(servicesProvider.optionalDocuments[index])){
                          servicesProvider.selectedOptionalDocuments.add(servicesProvider.optionalDocuments[index]);
                        } else if(servicesProvider.selectedOptionalDocuments.contains(servicesProvider.optionalDocuments[index])){
                          servicesProvider.selectedOptionalDocuments.remove(servicesProvider.optionalDocuments[index]);
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(3.0),
                      decoration: BoxDecoration(
                          color: HexColor('#DADADA'),
                          borderRadius: BorderRadius.circular(3.0)
                      ),
                      child: Container(
                        width: width(0.04, context),
                        height: width(0.04, context),
                        decoration: BoxDecoration(
                            color: servicesProvider.optionalDocumentsCheckBox[index] ? HexColor('#2D452E') : HexColor('#DADADA'),
                            borderRadius: BorderRadius.circular(4.0)
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15.0,),
                  Text(
                    UserConfig.instance.checkLanguage()
                        ? '${chunk[index]['NAME_EN']} (${chunk[index]['NAME'] ?? ""})'
                        : '${chunk[index]['NAME_AR']} (${chunk[index]['NAME'] ?? ""})',
                  ),
                ],
              ),
            );
          },
        ),
      );
    }

    return ImageSlideshow(
      width: double.infinity,
      initialPage: 0,
      indicatorColor: primaryColor,
      indicatorBackgroundColor: HexColor('#D9D9D9'),
      onPageChanged: (value) {},
      autoPlayInterval: 0,
      isLoop: documents.length > 4,
      children: docs,
    );
  }

}