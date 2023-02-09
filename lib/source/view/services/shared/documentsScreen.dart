// ignore_for_file: file_names

import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

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
    documentsFuture = servicesProvider.getRequiredDocuments();
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
                for(int i=0 ; i<snapshot.data['R_RESULT'][0].length ; i++){
                  if(snapshot.data['R_RESULT'][0][i]['OPTIONAL'] == 2){
                    if(!servicesProvider.mandatoryDocuments.contains(snapshot.data['R_RESULT'][0][i])) {
                      servicesProvider.uploadedFiles["mandatory"].length ++;
                      servicesProvider.uploadedFiles["mandatory"][0] = servicesProvider.uploadedFiles["mandatory"][0] ?? [];
                      servicesProvider.mandatoryDocuments.add(snapshot.data['R_RESULT'][0][i]);

                      servicesProvider.uploadedFiles["mandatory"].length ++;
                      servicesProvider.uploadedFiles["mandatory"][1] = servicesProvider.uploadedFiles["mandatory"][1] ?? [];
                      servicesProvider.mandatoryDocuments.add(snapshot.data['R_RESULT'][0][i]);
                      servicesProvider.uploadedFiles["mandatory"].length ++;
                      servicesProvider.uploadedFiles["mandatory"][2] = servicesProvider.uploadedFiles["mandatory"][2] ?? [];
                      servicesProvider.mandatoryDocuments.add(snapshot.data['R_RESULT'][0][i]);
                      servicesProvider.uploadedFiles["mandatory"].length ++;
                      servicesProvider.uploadedFiles["mandatory"][3] = servicesProvider.uploadedFiles["mandatory"][3] ?? [];
                      servicesProvider.mandatoryDocuments.add(snapshot.data['R_RESULT'][0][i]);
                      servicesProvider.uploadedFiles["mandatory"].length ++;
                      servicesProvider.uploadedFiles["mandatory"][4] = servicesProvider.uploadedFiles["mandatory"][4] ?? [];
                      servicesProvider.mandatoryDocuments.add(snapshot.data['R_RESULT'][0][i]);

                      servicesProvider.uploadedFiles["optional"].length ++;
                      servicesProvider.uploadedFiles["optional"][0] = servicesProvider.uploadedFiles["optional"][0] ?? [];
                      servicesProvider.optionalDocuments.add(snapshot.data['R_RESULT'][0][i]);
                      servicesProvider.uploadedFiles["optional"].length ++;
                      servicesProvider.uploadedFiles["optional"][1] = servicesProvider.uploadedFiles["optional"][1] ?? [];
                      servicesProvider.optionalDocuments.add(snapshot.data['R_RESULT'][0][i]);
                      servicesProvider.uploadedFiles["optional"].length ++;
                      servicesProvider.uploadedFiles["optional"][2] = servicesProvider.uploadedFiles["optional"][2] ?? [];
                      servicesProvider.optionalDocuments.add(snapshot.data['R_RESULT'][0][i]);
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
                                        ? '${servicesProvider.mandatoryDocuments[servicesProvider.documentIndex]['NAME_EN']}'
                                        : '${servicesProvider.mandatoryDocuments[servicesProvider.documentIndex]['NAME_AR']}',
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
                                          ? '${servicesProvider.selectedOptionalDocuments[servicesProvider.documentIndex]['NAME_EN']}'
                                          : '${servicesProvider.selectedOptionalDocuments[servicesProvider.documentIndex]['NAME_AR']}',
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
                                          child: Text(UserConfig.instance.checkLanguage()
                                              ? '${servicesProvider.mandatoryDocuments[servicesProvider.documentIndex]['NAME_EN']}'
                                              : '${servicesProvider.mandatoryDocuments[servicesProvider.documentIndex]['NAME_AR']}',),
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
                                            child: Text(UserConfig.instance.checkLanguage()
                                                ? '${servicesProvider.selectedOptionalDocuments[servicesProvider.documentIndex]['NAME_EN']}'
                                                : '${servicesProvider.selectedOptionalDocuments[servicesProvider.documentIndex]['NAME_AR']}',),
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
                      getPrimaryColor(context, themeNotifier),
                      HexColor('#ffffff'),
                      () async {
                        if(servicesProvider.documentsScreensStepNumber == 5){
                          servicesProvider.stepNumber = 5;
                        } else{
                          if(servicesProvider.documentsScreensStepNumber == 2){
                            if(servicesProvider.documentIndex < servicesProvider.mandatoryDocuments.length-1){
                              servicesProvider.documentIndex++;
                            } else if(servicesProvider.documentIndex == servicesProvider.mandatoryDocuments.length-1){
                              servicesProvider.documentIndex = 0;
                              servicesProvider.documentsScreensStepNumber ++;
                            }
                          } else if(servicesProvider.documentsScreensStepNumber == 4){
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
                      (type == 1
                      ? servicesProvider.mandatoryDocuments.isNotEmpty : servicesProvider.optionalDocuments.isNotEmpty)
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
            if(!(type == 1
                ? (servicesProvider.uploadedFiles["mandatory"][servicesProvider.documentIndex].isNotEmpty && servicesProvider.uploadedFiles["mandatory"][servicesProvider.documentIndex].length-1 >= index)
                : (servicesProvider.uploadedFiles["optional"][servicesProvider.documentIndex].isNotEmpty && servicesProvider.uploadedFiles["optional"][servicesProvider.documentIndex].length-1 >= index))){
              FilePickerResult result = await FilePicker.platform.pickFiles(
                allowMultiple: true,
                /// TODO: check allowed extensions
                /// allowedExtensions: ['jpg', 'pdf', 'png', 'jpeg'],
              );

              if (result != null) {
                List<File> files = result.paths.map((path) => File(path)).toList();
                for (var element in files) {
                  if(type == 1) {
                    servicesProvider.uploadedFiles["mandatory"][servicesProvider.documentIndex].add(element);
                  } else {
                    servicesProvider.uploadedFiles["optional"][servicesProvider.documentIndex].add(element);
                  }
                }
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
                  color: const Color.fromRGBO(117, 161, 119, 0.22),
                  borderRadius: BorderRadius.circular(8.0)
              ),
              child: (type == 1
              ? (servicesProvider.uploadedFiles["mandatory"][servicesProvider.documentIndex].isNotEmpty && servicesProvider.uploadedFiles["mandatory"][servicesProvider.documentIndex].length-1 >= index)
              : (servicesProvider.uploadedFiles["optional"][servicesProvider.documentIndex].isNotEmpty && servicesProvider.uploadedFiles["optional"][servicesProvider.documentIndex].length-1 >= index))
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
                        ? '${chunk[index]['NAME_EN']}'
                        : '${chunk[index]['NAME_AR']}',
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