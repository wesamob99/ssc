import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';

import '../../../../utilities/util.dart';

class HomeLoaderWidget extends StatelessWidget {
  const HomeLoaderWidget({Key? key}) : super(key: key);

  shimmerLoader(context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CardLoading(
          height: height(0.01, context),
          width: width(0.3, context),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          margin: const EdgeInsets.only(bottom: 10),
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
                ),
                CardLoading(
                  height: height(0.08, context),
                  width: width(0.35, context),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  margin: const EdgeInsets.only(bottom: 10),
                ),
              ],
            ),
            CardLoading(
              height: height(0.17, context),
              width: width(0.55, context),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              margin: const EdgeInsets.only(bottom: 10),
            ),
          ],
        ),
        CardLoading(
          height: height(0.05, context),
          width: width(1, context),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          margin: const EdgeInsets.only(bottom: 10),
        ),
        CardLoading(
          height: height(0.01, context),
          width: width(0.3, context),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          margin: const EdgeInsets.only(bottom: 10),
        ),
        CardLoading(
          height: height(0.23, context),
          width: width(1, context),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          margin: const EdgeInsets.only(bottom: 10),
        ),
        CardLoading(
          height: height(0.01, context),
          width: width(0.3, context),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          margin: const EdgeInsets.only(bottom: 10),
        ),
        CardLoading(
          height: height(0.23, context),
          width: width(1, context),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          margin: const EdgeInsets.only(bottom: 10),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return shimmerLoader(context);
  }
}
