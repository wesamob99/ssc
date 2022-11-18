import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../../../utilities/hexColor.dart';
import '../../../../utilities/theme/themes.dart';
import '../../../../utilities/util.dart';
import 'dart:ui' as ui;

import '../../../viewModel/services/servicesProvider.dart';
import '../../../viewModel/utilities/theme/themeProvider.dart';

class SlidingUpPanelWidget extends StatefulWidget {
  const SlidingUpPanelWidget({Key key}) : super(key: key);

  @override
  State<SlidingUpPanelWidget> createState() => _SlidingUpPanelWidgetState();
}

class _SlidingUpPanelWidgetState extends State<SlidingUpPanelWidget> {

  int selectedRate = 5;

  Widget _panel(BuildContext context, ScrollController sc, themeNotifier) {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: ListView(
            controller: sc,
            children: <Widget>[
              const SizedBox(
                height: 15.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 45,
                    height: 6,
                    decoration: BoxDecoration(
                        color: HexColor('#000000'),
                        borderRadius: const BorderRadius.all(Radius.circular(25.0))),
                  ),
                ],
              ),
              const SizedBox(
                height: 15.0,
              ),
              Text(
                translate('serviceEvaluation', context),
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 20.0,
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Text(
                translate('howEasyToApply', context),
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(
                height: 12.0,
              ),
              Text(
                translate('howEasyToApplyDesc', context),
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 12.0,
                    color: HexColor('#979797')
                ),
              ),
              const SizedBox(
                height: 12.0,
              ),
              Container(
                alignment: Alignment.center,
                 width: width(1, context),
                height: height(0.1, context),
                child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 5,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index){
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: (){
                              setState((){
                                selectedRate = index + 1;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: width(0.13, context),
                              height: width(0.13, context),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: selectedRate == index + 1 ? HexColor('#2D452E') : HexColor('#A6A6A6'),
                                borderRadius: BorderRadius.circular(50.0)
                              ),
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: width(0.02, context))
                        ],
                      );
                    }
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Text(
                translate('shareYourOpinion', context),
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(
                height: 12.0,
              ),
              buildTextFormField(context, themeNotifier, TextEditingController(), '', (value){}, minLines: 5),
              const SizedBox(
                height: 25.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: textButton(context, themeNotifier, 'done', MaterialStateProperty.all<Color>(
                    primaryColor
                ), Colors.white, (){
                  Provider.of<ServicesProvider>(context, listen: false).showPanel = false;
                  Provider.of<ServicesProvider>(context, listen: false).notifyMe();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                }, verticalPadding: 22),
              )
            ],
          ),
        )
    );
  }


  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);

    return SlidingUpPanel(
      maxHeight: height(0.6, context),
      minHeight: height(0.6, context),
      parallaxEnabled: true,
      parallaxOffset: .5,
      color: HexColor('#FFFFFF'),
      defaultPanelState: PanelState.CLOSED,
      body: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: .8, sigmaY: .8),
        child: Container(
          color: const Color.fromRGBO(48, 48, 48, 0.51),
        ),
      ),
      panelBuilder: (sc) => _panel(context, sc, themeNotifier),
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(25.0),
        topRight: Radius.circular(25.0),
      ),
    );
  }
}
