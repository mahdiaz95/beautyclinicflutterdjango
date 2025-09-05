import 'package:PARLACLINIC/features/home/model/Portfolio.dart';
import 'package:PARLACLINIC/features/home/view/viewmodels/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:animate_do/animate_do.dart';

class PortfolioPage extends ConsumerStatefulWidget {
  const PortfolioPage({super.key});

  @override
  ConsumerState<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends ConsumerState<PortfolioPage> {
  final Map<String, ChewieController> _controllerCache = {};

  @override
  void dispose() {
    for (final controller in _controllerCache.values) {
      controller.videoPlayerController.dispose();
      controller.dispose();
    }
    _controllerCache.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(portfolioViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('نمونه‌کارها',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.white,
            )),
        backgroundColor: const Color.fromARGB(255, 58, 66, 183),
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: state.when(
          data: (items) => RefreshIndicator(
            color: Colors.deepPurple,
            onRefresh: () async {
              for (final controller in _controllerCache.values) {
                controller.videoPlayerController.dispose();
                controller.dispose();
              }
              _controllerCache.clear();
              ref.read(portfolioViewModelProvider.notifier).refreshList();
            },
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: items.length + 1,
              itemBuilder: (context, index) {
                if (index < items.length) {
                  final item = items[index];
                  return FadeInUp(
                    duration: const Duration(milliseconds: 500),
                    child: PortfolioItemWidget(
                      item: item,
                      controllerCache: _controllerCache,
                    ),
                  );
                } else {
                  final vm = ref.read(portfolioViewModelProvider.notifier);
                  if (vm.hasMore) {
                    vm.loadMore();
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(
                          color: Colors.deepPurple,
                          strokeWidth: 3,
                        ),
                      ),
                    );
                  }
                  return const SizedBox();
                }
              },
            ),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(
              color: Colors.deepPurple,
              strokeWidth: 3,
            ),
          ),
          error: (e, _) => Center(
            child: Text(
              'خطا: $e',
              style: const TextStyle(
                color: Colors.redAccent,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PortfolioItemWidget extends StatefulWidget {
  final PortfolioItem item;
  final Map<String, ChewieController> controllerCache;

  const PortfolioItemWidget({
    super.key,
    required this.item,
    required this.controllerCache,
  });

  @override
  State<PortfolioItemWidget> createState() => _PortfolioItemWidgetState();
}

class _PortfolioItemWidgetState extends State<PortfolioItemWidget> {
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  void _initializeController() async {
    if (widget.item.mediaType == 'video') {
      final url = widget.item.media;

      if (widget.controllerCache.containsKey(url)) {
        _chewieController = widget.controllerCache[url];
      } else {
        final videoController = VideoPlayerController.network(url);
        await videoController.initialize();

        final chewieController = ChewieController(
          videoPlayerController: videoController,
          autoPlay: false,
          looping: false,
          allowFullScreen: true,
          allowMuting: true,
          allowPlaybackSpeedChanging: true,
          aspectRatio: videoController.value.aspectRatio,
          materialProgressColors: ChewieProgressColors(
            playedColor: Colors.deepPurple,
            handleColor: Colors.white,
            backgroundColor: Colors.grey.shade300,
            bufferedColor: Colors.deepPurple.shade100,
          ),
        );

        widget.controllerCache[url] = chewieController;

        if (mounted) {
          setState(() {
            _chewieController = chewieController;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 8,
      shadowColor: Colors.deepPurple.withOpacity(0.3),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [Colors.white, Colors.deepPurple.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width,
                  maxHeight: 500,
                ),
                child: item.mediaType == 'image'
                    ? CachedNetworkImage(
                        imageUrl: item.media,
                        fit: BoxFit.contain,
                        placeholder: (context, url) => Container(
                          color: Colors.grey.shade200,
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Colors.deepPurple,
                              strokeWidth: 3,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey.shade200,
                          child: const Icon(
                            Icons.broken_image,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : _chewieController != null
                        ? AspectRatio(
                            aspectRatio: _chewieController!
                                .videoPlayerController.value.aspectRatio,
                            child: Chewie(controller: _chewieController!),
                          )
                        : Container(
                            color: Colors.grey.shade200,
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Colors.deepPurple,
                                strokeWidth: 3,
                              ),
                            ),
                          ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: FadeIn(
                duration: const Duration(milliseconds: 600),
                child: Text(
                  item.description,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
