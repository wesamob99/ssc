// ignore_for_file: file_names

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:dotted_border/dotted_border.dart';
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

  @override
  void initState() {
    servicesProvider = Provider.of<ServicesProvider>(context, listen: false);
    documentsFuture = servicesProvider.getRequiredDocuments();
    servicesProvider.mandatoryDocuments = [];
    servicesProvider.optionalDocuments = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    return SizedBox(
      height: isTablet(context) ? height(0.78, context) : isScreenHasSmallHeight(context) ? height(0.73, context) : height(0.75, context),
      child: SingleChildScrollView(
        child: documentsBody(themeNotifier),
      ),
    );
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
                snapshot.data['R_RESULT'][0].forEach((element){
                  if(element['OPTIONAL'] == 2){
                    if(!servicesProvider.mandatoryDocuments.contains(element)) {
                      servicesProvider.mandatoryDocuments.add(element);
                      servicesProvider.mandatoryDocuments.add(element);
                      servicesProvider.mandatoryDocuments.add(element);
                      servicesProvider.mandatoryDocuments.add(element);
                      servicesProvider.mandatoryDocuments.add(element);
                    }
                  } else{
                    if(!servicesProvider.mandatoryDocuments.contains(element)) {
                      servicesProvider.mandatoryDocuments.add(element);
                    }
                  }
                });
                print(servicesProvider.documentIndex);

                return !servicesProvider.showMandatoryDocumentsScreen
                ? (servicesProvider.mandatoryDocuments.isNotEmpty || servicesProvider.mandatoryDocuments.isNotEmpty)
                ? SizedBox(
                  height: isTablet(context) ? height(0.78, context) : isScreenHasSmallHeight(context) ? height(0.73, context) : height(0.75, context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SingleChildScrollView(
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
                                    ? 'mandatoryDocumentsRequired' : 'mandatoryDocuments', context)
                                    + ' ( ${Provider.of<ServicesProvider>(context).documentIndex + 1} / ${(servicesProvider.mandatoryDocuments.isNotEmpty && !servicesProvider.mandatoryDocumentsFinished)
                                    ? (servicesProvider.mandatoryDocuments.length) : (servicesProvider.mandatoryDocuments.length)} )',
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
                                  DottedBorder(
                                    radius: const Radius.circular(8.0),
                                    padding: EdgeInsets.zero,
                                    color: HexColor('#979797'),
                                    borderType: BorderType.RRect,
                                    dashPattern: const [5],
                                    strokeWidth: 1.2,
                                    child: InkWell(
                                      onTap: () async {
                                        // ignore: unused_result
                                        await showModalActionSheet<String>(
                                          context: context,
                                          title: 'Upload from',
                                          // message: 'message',
                                          actions: [
                                            const SheetAction(
                                              icon: Icons.filter,
                                              label: 'Gallery',
                                              key: 'helloKey',
                                            ),
                                            const SheetAction(
                                              icon: Icons.camera_alt_outlined,
                                              label: 'Camera',
                                              key: 'destructiveKey',
                                            ),
                                          ],
                                          cancelLabel: 'Cancel',
                                        );
                                      },
                                      child: Container(
                                        width: width(1, context),
                                        height: height(0.14, context),
                                        decoration: BoxDecoration(
                                            color: const Color.fromRGBO(117, 161, 119, 0.22),
                                            borderRadius: BorderRadius.circular(8.0)
                                        ),
                                        child: Column(
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
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            // ListView.builder(
                            //   shrinkWrap: true,
                            //   physics: const NeverScrollableScrollPhysics(),
                            //   itemCount: snapshot.data['R_RESULT'][0].length,
                            //   itemBuilder: (context, index){
                            //     return Column(
                            //       crossAxisAlignment: CrossAxisAlignment.start,
                            //       children: [
                            //         const SizedBox(height: 40,),
                            //         Text(
                            //           UserConfig.instance.checkLanguage()
                            //               ? '${snapshot.data['R_RESULT'][0][index]['NAME_EN']}'
                            //               : '${snapshot.data['R_RESULT'][0][index]['NAME_AR']}',
                            //           style: TextStyle(
                            //               color: themeNotifier.isLight() ? HexColor('#363636') : HexColor('#ffffff'),
                            //               fontSize: isTablet(context) ? width(0.025, context) : width(0.032, context)
                            //           ),
                            //         ),
                            //         const SizedBox(height: 20.0,),
                            //         DottedBorder(
                            //           radius: const Radius.circular(8.0),
                            //           padding: EdgeInsets.zero,
                            //           color: HexColor('#979797'),
                            //           borderType: BorderType.RRect,
                            //           dashPattern: const [5],
                            //           strokeWidth: 1.2,
                            //           child: InkWell(
                            //             onTap: () async {
                            //               await showModalActionSheet<String>(
                            //                 context: context,
                            //                 title: 'Upload from',
                            //                 // message: 'message',
                            //                 actions: [
                            //                   const SheetAction(
                            //                     icon: Icons.filter,
                            //                     label: 'Gallery',
                            //                     key: 'helloKey',
                            //                   ),
                            //                   const SheetAction(
                            //                     icon: Icons.camera_alt_outlined,
                            //                     label: 'Camera',
                            //                     key: 'destructiveKey',
                            //                   ),
                            //                 ],
                            //                 cancelLabel: 'Cancel',
                            //               );
                            //             },
                            //             child: Container(
                            //               width: width(1, context),
                            //               height: height(0.14, context),
                            //               decoration: BoxDecoration(
                            //                   color: const Color.fromRGBO(117, 161, 119, 0.22),
                            //                   borderRadius: BorderRadius.circular(8.0)
                            //               ),
                            //               child: Column(
                            //                 mainAxisAlignment: MainAxisAlignment.center,
                            //                 crossAxisAlignment: CrossAxisAlignment.center,
                            //                 children: [
                            //                   SvgPicture.asset('assets/icons/upload.svg'),
                            //                   const SizedBox(height: 4.0),
                            //                   Text(
                            //                     translate('attachFileHere', context),
                            //                     style: TextStyle(
                            //                       fontSize: 12,
                            //                       color: HexColor('#363636'),
                            //                     ),
                            //                   ),
                            //                   const SizedBox(height: 10.0),
                            //                   Text(
                            //                     translate('chooseFile', context),
                            //                     style: TextStyle(
                            //                       color: HexColor('#2D452E'),
                            //                     ),
                            //                   ),
                            //                 ],
                            //               ),
                            //             ),
                            //           ),
                            //         ),
                            //       ],
                            //     );
                            //   },
                            // )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: textButtonWithIcon(
                            context, themeNotifier, 'addNewPhoto', Colors.transparent, HexColor('#2D452E'),
                                (){},
                            borderColor: '#2D452E'
                        ),
                      ),
                    ],
                  ),
                )
                    : const Center(child: Text('TODO empty list of documents'))
                    : Stack(
                  children: [
                    Container(
                      height: isTablet(context) ? height(0.78, context) : isScreenHasSmallHeight(context) ? height(0.73, context) : height(0.75, context),
                      alignment: Alignment.center,
                      child: Image.asset('assets/images/backgrounds/documentsBackground.png'),
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
                                    'الوثائق الإجبارية المطلوبة',
                                    style: TextStyle(
                                      color: HexColor('#363636'),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 25.0,),
                                  SizedBox(
                                    height: 20.0  + (20 * servicesProvider.mandatoryDocuments.length),
                                    child: ListView.builder(
                                      itemCount: servicesProvider.mandatoryDocuments.length,
                                      itemBuilder: (context, index){
                                        return Column(
                                          children: [
                                            Row(
                                              children: [
                                                SvgPicture.asset('assets/icons/check.svg'),
                                                const SizedBox(width: 15.0,),
                                                Text(
                                                  UserConfig.instance.checkLanguage()
                                                      ? '${servicesProvider.mandatoryDocuments[index]['NAME_EN']}'
                                                      : '${servicesProvider.mandatoryDocuments[index]['NAME_AR']}',
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10.0,),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 20.0,),
                                  textButton(context, themeNotifier, 'startNow', HexColor('#445740'), HexColor('#FFFFFF'), (){
                                    setState(() {
                                      servicesProvider.showMandatoryDocumentsScreen = false;
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
}
