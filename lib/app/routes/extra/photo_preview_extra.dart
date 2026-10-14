import 'package:widyu/feature/album/select_photo/select_photo_view_model.dart';

class PhotoPreviewExtra {
  const PhotoPreviewExtra({
    required this.viewModel,
    required this.initialIndex,
  });

  final SelectPhotoViewModel viewModel;
  final int initialIndex;
}
