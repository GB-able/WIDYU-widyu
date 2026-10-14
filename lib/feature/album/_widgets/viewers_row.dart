import 'package:flutter/material.dart';
import 'package:widyu/core/model/album/member.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/ui/widgets/profile_widget.dart';

class ViewersRow extends StatelessWidget {
  const ViewersRow({super.key, required this.viewers});

  final List<Member> viewers;

  @override
  Widget build(BuildContext context) {
    if (viewers.isEmpty) {
      return Text("아직 아무도 게시글을 읽지 않았어요!", style: MyTypo.helper2);
    }

    final displayViewers = viewers.take(3).toList().reversed.toList();

    return Row(
      children: [
        Wrap(
          spacing: -4,
          textDirection: TextDirection.rtl,
          children: displayViewers
              .map(
                (viewer) => Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: MyColor.white, width: 1),
                    shape: BoxShape.circle,
                  ),
                  child: ProfileWidget(
                    profileImage: viewer.profileImage,
                    size: 20,
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(width: 4),
        Flexible(
          child: RichText(
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              children: [
                TextSpan(
                  text: viewers.length == 1
                      ? viewers.first.name
                      : viewers.take(2).map((v) => v.name).join(', '),
                  style: MyTypo.subTitle3,
                ),
                TextSpan(
                  text: viewers.length <= 2
                      ? '님이 게시물을 읽었어요'
                      : '님 외에 여러 명이 게시물을 읽었어요',
                  style: MyTypo.helper2,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
