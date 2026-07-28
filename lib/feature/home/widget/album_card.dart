part of '../home_screen.dart';

// 슬라이드쇼 사진 전환 주기
const _albumSlideInterval = Duration(seconds: 2);
// 슬라이드쇼 페이드 전환 시간
const _albumSlideTransitionDuration = Duration(milliseconds: 500);

class _AlbumCard extends StatelessWidget {
  final List<String> thumbnails;

  const _AlbumCard({required this.thumbnails});

  @override
  Widget build(BuildContext context) {
    return _CarouselCardShell(
      title: '앨범',
      background: Stack(
        fit: StackFit.expand,
        children: [
          _AlbumSlideshow(thumbnails: thumbnails),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  MyColor.black.withValues(alpha: 0.8),
                  MyColor.black.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ],
      ),
      content: Align(
        alignment: Alignment.bottomCenter,
        child: Material(
          type: MaterialType.transparency,
          child: TextBtn(
            onTap: () => context.go(AppRoute.album.path),
            text: '앨범 보러 가기',
            enable: true,
          ),
        ),
      ),
    );
  }
}

class _AlbumSlideshow extends StatefulWidget {
  final List<String> thumbnails;

  const _AlbumSlideshow({required this.thumbnails});

  @override
  State<_AlbumSlideshow> createState() => _AlbumSlideshowState();
}

class _AlbumSlideshowState extends State<_AlbumSlideshow> {
  Timer? _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _restartTimer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _precacheNext();
  }

  @override
  void didUpdateWidget(_AlbumSlideshow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(oldWidget.thumbnails, widget.thumbnails)) {
      _currentIndex = 0;
      _restartTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _restartTimer() {
    _timer?.cancel();
    _timer = null;
    if (widget.thumbnails.length < 2) return;

    _timer = Timer.periodic(_albumSlideInterval, (_) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % widget.thumbnails.length;
      });
      _precacheNext();
    });
  }

  void _precacheNext() {
    if (widget.thumbnails.length < 2) return;
    final nextIndex = (_currentIndex + 1) % widget.thumbnails.length;
    precacheImage(NetworkImage(widget.thumbnails[nextIndex]), context);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.thumbnails.isEmpty) {
      return Container(color: MyColor.red400);
    }

    return AnimatedSwitcher(
      duration: _albumSlideTransitionDuration,
      child: Image.network(
        widget.thumbnails[_currentIndex],
        key: ValueKey(_currentIndex),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(child: CircularProgressIndicator());
        },
        errorBuilder: (context, error, stackTrace) =>
            Container(color: MyColor.red400),
      ),
    );
  }
}
