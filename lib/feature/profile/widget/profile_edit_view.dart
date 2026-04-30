part of '../profile_screen.dart';

class _ProfileEditView extends StatelessWidget {
  const _ProfileEditView();

  @override
  Widget build(BuildContext context) {
    final uiState =
        context.select<ProfileViewModel, ProfileUiState>((vm) => vm.uiState);
    final viewModel = context.read<ProfileViewModel>();

    return Column(
      children: [
        _ProfileImageView(
          profileImage: uiState.profileImage,
          onImagePicked: viewModel.updateProfileImage,
        ),
        const SizedBox(height: 12),
        _ProfileNameView(
          name: uiState.name,
          onNameChanged: viewModel.updateName,
        ),
        const SizedBox(height: 48),
      ],
    );
  }
}
