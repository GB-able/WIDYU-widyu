part of '../select_photo_screen.dart';

class _PhotoGrid extends StatefulWidget {
  const _PhotoGrid({
    required this.assets,
    required this.isLoading,
    required this.isCapturing,
    required this.cameraPermission,
    required this.selectOrder,
    required this.onLoadMore,
    required this.onCapture,
    required this.onToggle,
  });

  final List<AssetEntity> assets;
  final bool isLoading;
  final bool isCapturing;
  final PermissionStatus? cameraPermission;
  final int? Function(AssetEntity asset) selectOrder;
  final VoidCallback onLoadMore;
  final VoidCallback onCapture;
  final void Function(AssetEntity asset) onToggle;

  @override
  State<_PhotoGrid> createState() => _PhotoGridState();
}

class _PhotoGridState extends State<_PhotoGrid> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
    _scheduleScrollCheck();
  }

  @override
  void didUpdateWidget(_PhotoGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 선택이 바뀔 때마다가 아니라, 목록이나 로딩 상태가 바뀔 때만 끝까지 찼는지 다시 확인한다.
    if (!identical(oldWidget.assets, widget.assets) ||
        oldWidget.isLoading != widget.isLoading) {
      _scheduleScrollCheck();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!mounted || !_controller.hasClients) return;
    final position = _controller.position;
    if (position.pixels < position.maxScrollExtent - 600) return;
    widget.onLoadMore();
  }

  void _scheduleScrollCheck() {
    if (widget.isLoading) return;
    WidgetsBinding.instance.addPostFrameCallback((_) => _onScroll());
  }

  @override
  Widget build(BuildContext context) {
    final assets = widget.assets;
    if (widget.isLoading) {
      return const CustomLoadingWidget();
    }
    return GridView.builder(
      controller: _controller,
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
      ),
      itemCount: assets.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _CameraTile(
            isCapturing: widget.isCapturing,
            cameraPermission: widget.cameraPermission,
            onCapture: widget.onCapture,
          );
        }
        final asset = assets[index - 1];
        return _PhotoItem(
          asset: asset,
          index: index - 1,
          order: widget.selectOrder(asset),
          onToggle: () => widget.onToggle(asset),
        );
      },
    );
  }
}

class _CameraTile extends StatelessWidget {
  const _CameraTile({
    required this.isCapturing,
    required this.cameraPermission,
    required this.onCapture,
  });

  final bool isCapturing;
  final PermissionStatus? cameraPermission;
  final VoidCallback onCapture;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final permission = cameraPermission;
        if (permission == PermissionStatus.permanentlyDenied ||
            permission == PermissionStatus.restricted) {
          showDialog<void>(
            context: context,
            builder: (_) => const CustomDialog(
              title: '카메라 접근이 차단되었습니다.',
              description: '설정에서 위듀의 카메라 접근을 허용해주세요.',
            ),
          );
        } else {
          onCapture();
        }
      },
      child: Container(
        color: MyColor.grey200,
        alignment: Alignment.center,
        child: isCapturing
            ? const CircularProgressIndicator()
            : WiduIcon(icon: Assets.icons.ic64Camera, width: 64),
      ),
    );
  }
}
