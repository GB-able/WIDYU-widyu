part of '../select_photo_screen.dart';

class _PhotoGrid extends StatefulWidget {
  const _PhotoGrid();

  @override
  State<_PhotoGrid> createState() => _PhotoGridState();
}

class _PhotoGridState extends State<_PhotoGrid> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
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
    context.read<SelectPhotoViewModel>().loadMore();
  }

  void _scheduleScrollCheck() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _onScroll());
  }

  @override
  Widget build(BuildContext context) {
    return Selector<SelectPhotoViewModel, (List<AssetEntity>, bool)>(
      selector: (context, viewModel) =>
          (viewModel.currAssets, viewModel.isLoading),
      builder: (context, state, _) {
        final (assets, isLoading) = state;
        if (isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        _scheduleScrollCheck();
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
            if (index == 0) return const _CameraTile();
            return _PhotoItem(asset: assets[index - 1], index: index - 1);
          },
        );
      },
    );
  }
}

class _CameraTile extends StatelessWidget {
  const _CameraTile();

  @override
  Widget build(BuildContext context) {
    return Consumer<SelectPhotoViewModel>(
      builder: (context, viewModel, _) => GestureDetector(
        onTap: () {
          final permission = viewModel.cameraPermission;
          if (permission == PermissionStatus.permanentlyDenied ||
              permission == PermissionStatus.restricted) {
            showDialog(
              context: context,
              builder: (_) => const CustomDialog(
                type: CustomDialogType.one,
                title: "카메라 접근이 차단되었습니다.",
                description: "설정에서 위듀의 카메라 접근을 허용해주세요.",
              ),
            );
          } else {
            viewModel.captureFromCamera();
          }
        },
        child: Container(
          color: MyColor.grey200,
          alignment: Alignment.center,
          child: viewModel.isCapturing
              ? const CircularProgressIndicator()
              : const IconWidget(icon: "camera", width: 64),
        ),
      ),
    );
  }
}
