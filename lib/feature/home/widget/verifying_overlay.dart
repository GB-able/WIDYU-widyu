part of '../home_screen.dart';

/// 약 복용 인증 사진을 업로드하는 동안 하단 탭까지 포함한 화면 전체를 어둡게 덮고 로딩을 보여준다.
/// [OverlayPortalController] 는 렌더링 계층에 결합되어 있으므로 이 위젯이 소유한다.
class _VerifyingOverlay extends StatefulWidget {
  final bool isVisible;
  final Widget child;

  const _VerifyingOverlay({required this.isVisible, required this.child});

  @override
  State<_VerifyingOverlay> createState() => _VerifyingOverlayState();
}

class _VerifyingOverlayState extends State<_VerifyingOverlay> {
  // show/hide 는 빌드 중에 부를 수 없으므로 오버레이는 항상 띄워 두고,
  // 보일지는 isVisible 로 그린다.
  final _controller = OverlayPortalController()..show();

  @override
  Widget build(BuildContext context) {
    return OverlayPortal.targetsRootOverlay(
      controller: _controller,
      overlayChildBuilder: (_) => AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        // 숨겨지면 로딩 위젯이 트리에서 빠져 애니메이션도 멈춘다.
        child: widget.isVisible
            ? const ColoredBox(
                color: Color(0x80000000),
                child: Center(child: CircularProgressIndicator()),
              )
            : const SizedBox.shrink(),
      ),
      child: widget.child,
    );
  }
}
