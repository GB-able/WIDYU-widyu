import 'package:flutter/cupertino.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/gen/fonts.gen.dart';

class MyTypo {
  static const typoBase = TextStyle(
    fontFamily: FontFamily.pretendard,
    overflow: TextOverflow.ellipsis,
    leadingDistribution: TextLeadingDistribution.even,
    color: MyColor.black,
  );

  static const kccGanpanBase = TextStyle(
    fontFamily: FontFamily.kCCGanpan,
    overflow: TextOverflow.ellipsis,
    leadingDistribution: TextLeadingDistribution.even,
    color: MyColor.black,
  );

  static final mediumBase = typoBase.copyWith(fontWeight: FontWeight.w500);
  static final semiboldBase = typoBase.copyWith(fontWeight: FontWeight.w600);
  static final boldBase = typoBase.copyWith(fontWeight: FontWeight.w700);
  static final blackBase = typoBase.copyWith(fontWeight: FontWeight.w900);
  static final kccBase = kccGanpanBase.copyWith(fontWeight: FontWeight.w400);

  static final largeTitle = blackBase.copyWith(height: 1.6, fontSize: 40);
  static final percentage = blackBase.copyWith(height: 1.5, fontSize: 20);

  static final title1 = boldBase.copyWith(height: 1.5, fontSize: 24);
  static final title2 = boldBase.copyWith(height: 1.5, fontSize: 20);
  static final title3 = semiboldBase.copyWith(height: 1.5, fontSize: 18);
  static final title4 = boldBase.copyWith(height: 1.5, fontSize: 18);
  static final kccTitle = kccGanpanBase.copyWith(height: 1.5, fontSize: 24);

  static final subTitle1 = boldBase.copyWith(height: 1.5, fontSize: 16);
  static final subTitle2 = semiboldBase.copyWith(height: 1.5, fontSize: 14);
  static final subTitle3 = boldBase.copyWith(height: 1.5, fontSize: 14);
  static final subTitle4 = boldBase.copyWith(height: 1.5, fontSize: 12);
  static final subTitle5 = semiboldBase.copyWith(height: 1.5, fontSize: 16);
  static final subTitle6 = semiboldBase.copyWith(height: 1.5, fontSize: 20);
  static final subTitle7 = semiboldBase.copyWith(height: 1.5, fontSize: 12);

  static final body1 = mediumBase.copyWith(height: 1.5, fontSize: 16);
  static final body2 = mediumBase.copyWith(height: 1.5, fontSize: 14);

  static final hint = mediumBase.copyWith(height: 1.5, fontSize: 14);
  static final chip = semiboldBase.copyWith(height: 1.5, fontSize: 16);
  static final button = semiboldBase.copyWith(height: 1.5, fontSize: 16);
  static final tab = boldBase.copyWith(height: 1.5, fontSize: 18);

  static final helper = mediumBase.copyWith(height: 1.5, fontSize: 12);
  static final helper2 = mediumBase.copyWith(height: 1.5, fontSize: 14);
  static final helper3 = mediumBase.copyWith(height: 1.5, fontSize: 10);
}
