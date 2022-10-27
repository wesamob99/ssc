import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:ssc/src/viewModel/services/servicesProvider.dart';
import 'package:ssc/utilities/hexColor.dart';
import 'package:ssc/utilities/util.dart';
import 'dart:math' as math;
import '../../../../../infrastructure/userConfig.dart';
import '../../../../viewModel/utilities/theme/themeProvider.dart';

class AboutTheServiceScreen extends StatefulWidget {
  final String serviceTitle;
  final String aboutServiceDescription;
  final List<String> termsOfTheService;
  final List<String> stepsOfTheService;
  const AboutTheServiceScreen({
    Key key,
    @required this.serviceTitle,
    @required this.aboutServiceDescription,
    @required this.termsOfTheService,
    @required this.stepsOfTheService
  }) : super(key: key);

  @override
  State<AboutTheServiceScreen> createState() => _AboutTheServiceScreenState();
}

class _AboutTheServiceScreenState extends State<AboutTheServiceScreen> {
  ServicesProvider servicesProvider;

  @override
  void initState() {
    servicesProvider = Provider.of<ServicesProvider>(context, listen: false);
    servicesProvider.stepNumber = 1;
    servicesProvider.readCountriesJson();
    servicesProvider.selectedInjuredType = 'occupationalDisease';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(translate(widget.serviceTitle, context)),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: (){
              Navigator.of(context).pop();
            },
            child: Transform.rotate(
              angle: UserConfig.instance.checkLanguage()
                  ? -math.pi / 1.0 : 0,
              child: SvgPicture.asset(
                  'assets/icons/backWhite.svg'
              ),
            ),
          ),
        ),
      ),
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          child: Container(
            width: width(1, context),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: height(0.01, context)),
                  child: Text(
                    translate('aboutTheService', context),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Text(
                  widget.aboutServiceDescription,
                  style: const TextStyle(
                    fontWeight: FontWeight.w100,
                    height: 1.3
                  ),
                ),
                SizedBox(
                  height: height(0.02, context),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: height(0.01, context)),
                  child: Text(
                    translate('termsOfTheService', context),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                SizedBox(
                  height: height(0.019, context) * widget.termsOfTheService.length,
                  child: ListView.builder(
                    itemCount: widget.termsOfTheService.length,
                    itemBuilder: (context, index){
                      return Text(widget.termsOfTheService[index]);
                    }
                  ),
                ),
                SizedBox(
                  height: height(0.02, context),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: height(0.01, context)),
                  child: Row(
                    children: [
                      Text(
                        '${translate('stepsOfTheService', context)} ',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(
                        '( ${widget.stepsOfTheService.length} ${translate('steps', context)} )',
                        style: TextStyle(
                          fontWeight: FontWeight.w100,
                          color: HexColor('#666666')
                        ),
                      ),
                    ],
                  )
                ),
                SizedBox(
                  height: height(0.019, context) * widget.stepsOfTheService.length,
                  child: ListView.builder(
                      itemCount: widget.stepsOfTheService.length,
                      itemBuilder: (context, index){
                        return Text(widget.stepsOfTheService[index]);
                      }
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}