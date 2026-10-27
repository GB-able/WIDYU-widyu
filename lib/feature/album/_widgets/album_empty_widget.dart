import 'package:flutter/material.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';

class AlbumEmptyWidget extends StatelessWidget {
  const AlbumEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(flex: 2),
        Image.asset('assets/images/img_102_album.png', width: 100, height: 84),
        const SizedBox(height: 16),
        Text(
          '게시물을 만들어보세요',
          style: MyTypo.title2.copyWith(color: MyColor.grey700),
        ),
        const SizedBox(height: 8),
        Text(
          '사랑스러운 순간들로 앨범위듀를 채워보세요',
          style: MyTypo.body2.copyWith(color: MyColor.grey500),
        ),
        const Spacer(flex: 3),
      ],
    );
  }
}
