part of '../my_page_screen.dart';

class _MyPageHeader extends StatelessWidget {
  const _MyPageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final uiState = context.select<MyPageViewModel, MyPageUiState>(
        (viewModel) => viewModel.uiState);

    if (uiState.isError) {
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => showToast("사용자 정보를 불러오지 못했어요.\n잠시 후 다시 시도해주세요."));
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 0, 24),
      decoration: const BoxDecoration(
        color: MyColor.orange400,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      width: double.infinity,
      child: _HeaderContent(
        profileImage: uiState.profileImage,
        name: uiState.name,
        points: uiState.points,
        isLoading: uiState.isLoading,
        isError: uiState.isError,
      ),
    );
  }
}
