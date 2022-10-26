// ignore_for_file: file_names

import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssc/src/viewModel/utilities/theme/themeProvider.dart';

import '../../../../utilities/util.dart';

class HomeLoaderWidget extends StatelessWidget {
  const HomeLoaderWidget({Key key}) : super(key: key);

  shimmerLoader(BuildContext context, ThemeNotifier themeNotifier){
    CardLoadingTheme cardLoadingTheme = CardLoadingTheme(
        colorOne: themeNotifier.isLight() ? Colors.grey.shade100 : Colors.black12,
        colorTwo: themeNotifier.isLight() ? Colors.grey.shade200 : Colors.black12
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CardLoading(
          height: height(0.01, context),
          width: width(0.3, context),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          margin: const EdgeInsets.only(bottom: 10),
          cardLoadingTheme: cardLoadingTheme,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CardLoading(
                  height: height(0.08, context),
                  width: width(0.35, context),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  margin: const EdgeInsets.only(bottom: 10),
                  cardLoadingTheme: cardLoadingTheme,
                ),
                CardLoading(
                  height: height(0.08, context),
                  width: width(0.35, context),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  margin: const EdgeInsets.only(bottom: 10),
                  cardLoadingTheme: cardLoadingTheme,
                ),
              ],
            ),
            CardLoading(
              height: height(0.17, context),
              width: width(0.55, context),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              margin: const EdgeInsets.only(bottom: 10),
              cardLoadingTheme: cardLoadingTheme,
            ),
          ],
        ),
        CardLoading(
          height: height(0.05, context),
          width: width(1, context),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          margin: const EdgeInsets.only(bottom: 10),
          cardLoadingTheme: cardLoadingTheme,
        ),
        CardLoading(
          height: height(0.01, context),
          width: width(0.3, context),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          margin: const EdgeInsets.only(bottom: 10),
          cardLoadingTheme: cardLoadingTheme,
        ),
        SizedBox(
          height: height(0.1, context),
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 7,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index){
              return Row(
                children: [
                  InkWell(
                    onTap: (){},
                    highlightColor: const Color.fromRGBO(68, 87, 64, 0.4),
                    child: Column(
                      children: [
                        CardLoading(
                          width: width(0.14, context),
                          height: width(0.14, context),
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          margin: const EdgeInsets.only(bottom: 10),
                          cardLoadingTheme: cardLoadingTheme,
                        ),
                        CardLoading(
                          width: width(0.14, context),
                          height: width(0.01, context),
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          margin: const EdgeInsets.only(bottom: 10),
                          cardLoadingTheme: cardLoadingTheme,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: width(0.015, context))
                ],
              );
            }
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CardLoading(
              height: height(0.16, context),
              width: width(0.75, context),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              margin: const EdgeInsets.only(bottom: 10),
              cardLoadingTheme: cardLoadingTheme,
            ),
            CardLoading(
              height: height(0.16, context),
              width: width(0.12, context),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              margin: const EdgeInsets.only(bottom: 10),
              cardLoadingTheme: cardLoadingTheme,
            ),
          ],
        ),
        CardLoading(
          height: height(0.01, context),
          width: width(0.3, context),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          margin: const EdgeInsets.only(bottom: 10),
          cardLoadingTheme: cardLoadingTheme,
        ),
        CardLoading(
          height: height(0.23, context),
          width: width(1, context),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          margin: const EdgeInsets.only(bottom: 10),
          cardLoadingTheme: cardLoadingTheme,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);

    return shimmerLoader(context, themeNotifier);
  }
}
