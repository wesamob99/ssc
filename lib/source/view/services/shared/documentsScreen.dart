// ignore_for_file: file_names

import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../../../infrastructure/userConfig.dart';
import '../../../../../utilities/hexColor.dart';
import '../../../../../utilities/util.dart';
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
    documentsFuture = servicesProvider.getRequiredDocuments();
    servicesProvider.mandatoryDocuments = [];
    servicesProvider.optionalDocuments = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    return documentsBody(themeNotifier);
  }

  Widget documentsBody(themeNotifier){
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
                for(int i=0 ; i<snapshot.data['R_RESULT'][0].length ; i++){
                  if(snapshot.data['R_RESULT'][0][i]['OPTIONAL'] == 2){
                    if(!servicesProvider.mandatoryDocuments.contains(snapshot.data['R_RESULT'][0][i])) {
                      servicesProvider.uploadedFiles["mandatory"].length ++;
                      servicesProvider.uploadedFiles["mandatory"][0] = [];
                      servicesProvider.mandatoryDocuments.add(snapshot.data['R_RESULT'][0][i]);

                      ///
                      servicesProvider.uploadedFiles["mandatory"].length ++;
                      servicesProvider.uploadedFiles["mandatory"][1] = [];
                      servicesProvider.mandatoryDocuments.add(snapshot.data['R_RESULT'][0][i]);

                      servicesProvider.uploadedFiles["mandatory"].length ++;
                      servicesProvider.uploadedFiles["mandatory"][2] = [];
                      servicesProvider.mandatoryDocuments.add(snapshot.data['R_RESULT'][0][i]);

                      servicesProvider.uploadedFiles["mandatory"].length ++;
                      servicesProvider.uploadedFiles["mandatory"][3] = [];
                      servicesProvider.mandatoryDocuments.add(snapshot.data['R_RESULT'][0][i]);

                      servicesProvider.uploadedFiles["optional"].length ++;
                      servicesProvider.uploadedFiles["optional"][0] = [];
                      servicesProvider.optionalDocuments.add(snapshot.data['R_RESULT'][0][i]);

                      servicesProvider.uploadedFiles["optional"].length ++;
                      servicesProvider.uploadedFiles["optional"][1] = [];
                      servicesProvider.optionalDocuments.add(snapshot.data['R_RESULT'][0][i]);
                      ///
                    }
                  } else{
                    if(!servicesProvider.optionalDocuments.contains(snapshot.data['R_RESULT'][0][i])) {
                      servicesProvider.uploadedFiles["optional"].length ++;
                      servicesProvider.uploadedFiles["optional"][i] = [];
                      servicesProvider.optionalDocuments.add(snapshot.data['R_RESULT'][0][i]);
                    }
                  }
                }

                return !servicesProvider.showMandatoryDocumentsScreen && !servicesProvider.showOptionalDocumentsScreen
                ? (servicesProvider.mandatoryDocuments.isNotEmpty || servicesProvider.mandatoryDocuments.isNotEmpty)
                ? SizedBox(
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
                        SizedBox(height: height(0.02, context),),
                        if(servicesProvider.mandatoryDocuments.isNotEmpty || servicesProvider.mandatoryDocuments.isNotEmpty)
                        Text(
                            translate((servicesProvider.mandatoryDocuments.isNotEmpty && !servicesProvider.mandatoryDocumentsFinished)
                                ? 'mandatoryDocumentsRequired' : 'optionalDocuments', context)
                                + ' ( ${Provider.of<ServicesProvider>(context).documentIndex + 1} / ${(servicesProvider.mandatoryDocuments.isNotEmpty && !servicesProvider.mandatoryDocumentsFinished)
                                ? (servicesProvider.mandatoryDocuments.length) : (servicesProvider.optionalDocuments.length)} )',
                            style: TextStyle(
                              color: HexColor('#84692E'),
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                        ),
                        if(servicesProvider.mandatoryDocuments.isNotEmpty || servicesProvider.mandatoryDocuments.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 40,),
                            Text(
                              UserConfig.instance.checkLanguage()
                                  ? '${(servicesProvider.mandatoryDocuments.isNotEmpty && !servicesProvider.mandatoryDocumentsFinished) ? servicesProvider.mandatoryDocuments[servicesProvider.documentIndex]['NAME_EN'] : servicesProvider.mandatoryDocuments[servicesProvider.documentIndex]['NAME_EN']}'
                                  : '${(servicesProvider.mandatoryDocuments.isNotEmpty && !servicesProvider.mandatoryDocumentsFinished) ? servicesProvider.mandatoryDocuments[servicesProvider.documentIndex]['NAME_AR'] : servicesProvider.mandatoryDocuments[servicesProvider.documentIndex]['NAME_AR']}',
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
                                return buildFileUploader(index);
                              },
                              itemCount: servicesProvider.uploadedFiles["mandatory"][servicesProvider.documentIndex].length + 1
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
                : SizedBox(
                    height: isTablet(context) ? height(0.78, context) : isScreenHasSmallHeight(context) ? height(0.73, context) : height(0.75, context),
                    child: const Center(
                      child: Text('TODO empty list of documents')
                    ),
                )
                : Stack(
                  children: [
                    Container(
                      height: isTablet(context) ? height(0.78, context) : isScreenHasSmallHeight(context) ? height(0.73, context) : height(0.75, context),
                      alignment: Alignment.center,
                      child: Image.asset('assets/images/backgrounds/documentsBackground.png', fit: BoxFit.cover,),
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
                                  Text(
                                    servicesProvider.showMandatoryDocumentsScreen
                                        ? translate('mandatoryDocumentsRequired', context)
                                        : translate('chooseTheDocumentsYouWantToAttach', context),
                                    style: TextStyle(
                                      color: HexColor('#363636'),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 25.0,),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: servicesProvider.showMandatoryDocumentsScreen ? servicesProvider.mandatoryDocuments.length : servicesProvider.optionalDocuments.length,
                                    itemBuilder: (context, index){
                                      return Column(
                                        children: [
                                          Row(
                                            children: [
                                              SvgPicture.asset('assets/icons/check.svg'),
                                              const SizedBox(width: 15.0,),
                                              Text(
                                                UserConfig.instance.checkLanguage()
                                                    ? servicesProvider.showMandatoryDocumentsScreen ? '${servicesProvider.mandatoryDocuments[index]['NAME_EN']}' : '${servicesProvider.optionalDocuments[index]['NAME_EN']}'
                                                    : servicesProvider.showMandatoryDocumentsScreen ? '${servicesProvider.mandatoryDocuments[index]['NAME_AR']}' : '${servicesProvider.optionalDocuments[index]['NAME_AR']}',
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10.0,),
                                        ],
                                      );
                                    },
                                  ),
                                  textButton(context, themeNotifier, 'startNow', HexColor('#445740'), HexColor('#FFFFFF'), (){
                                    setState(() {
                                      servicesProvider.showMandatoryDocumentsScreen ? servicesProvider.showMandatoryDocumentsScreen = false : servicesProvider.showOptionalDocumentsScreen = false;
                                      servicesProvider.notifyMe();
                                    });
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
              break;
          }
          return somethingWrongWidget(context, 'somethingWrongHappened', 'somethingWrongHappenedDesc');
        }
    );
  }

  buildFileUploader(int index){
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
            FilePickerResult result = await FilePicker.platform.pickFiles(
              allowMultiple: true,
              /// TODO: check allowed extensions
              /// allowedExtensions: ['jpg', 'pdf', 'png', 'jpeg'],
            );

            if (result != null) {
              List<File> files = result.paths.map((path) => File(path)).toList();
              for (var element in files) {
                servicesProvider.uploadedFiles["mandatory"][servicesProvider.documentIndex].add(element);
              }
              servicesProvider.notifyMe();
            } else {
              // User canceled the picker
            }
          },
          child: Container(
            width: width(1, context),
            padding: EdgeInsets.all(isTablet(context) ? 30 : 20.0),
            decoration: BoxDecoration(
                color: const Color.fromRGBO(117, 161, 119, 0.22),
                borderRadius: BorderRadius.circular(8.0)
            ),
            child: servicesProvider.uploadedFiles["mandatory"][servicesProvider.documentIndex].isNotEmpty && servicesProvider.uploadedFiles["mandatory"][servicesProvider.documentIndex].length-1 >= index
            ? const Center(child: Text('uploaded!'),)
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

}