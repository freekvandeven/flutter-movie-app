import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:floating/floating.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_viewing_app/src/models/models.dart';
import 'package:movie_viewing_app/src/providers.dart';
import 'package:movie_viewing_app/src/ui/screens/base.dart';
import 'package:movie_viewing_app/src/ui/widgets/icon_button.dart';
import 'package:movie_viewing_app/src/ui/widgets/slider_thumb.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

class MovieViewScreen extends ConsumerStatefulWidget {
  const MovieViewScreen({
    Key? key,
  }) : super(key: key);
  @override
  ConsumerState<MovieViewScreen> createState() => _MovieViewScreenState();
}

class _MovieViewScreenState extends ConsumerState<MovieViewScreen> {
  final Floating floating = Floating();
  bool pipMode = false;
  bool hideControls = false;
  late MovieUserSettings _settings;
  late Movie _movie;
  late Timer _updateTimer;
  late Timer _controlHideTimer;
  int secondsPlayed = 0;
  int timerUpdateInterval = 1;
  late VideoPlayerController? _videoController;

  // TODO(freek): add video sound control

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    _settings = ref
        .read(movieSettingsProvider)
        .firstWhere((element) => element.selected);
    _movie = ref
        .read(movieCatalogueProvider)
        .firstWhere((element) => element.title == _settings.title);
    secondsPlayed = _settings.timeWatched;

    _setVideoUpdateTimer();
    _initializeVideo();
    _setAutoHideTimer();
    Wakelock.enable();
  }

  @override
  void dispose() {
    Wakelock.disable();
    _videoController?.pause();
    _videoController?.dispose();
    floating.dispose();
    _updateTimer.cancel();
    _controlHideTimer.cancel();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var iconSize = size.width * 0.02;
    var playTime =
        '${Movie.movieTimeAsString(secondsPlayed)}/${Movie.movieTimeAsString(_movie.duration)}';
    // TODO(freek): refactor this to pipstream to detect pip changes
    _checkPipEnabled();

    return BaseScreen(
      background: Colors.black,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _setAutoHideTimer,
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _onVideoTap,
              child: (_videoController != null &&
                      _videoController!.value.isInitialized)
                  ? AspectRatio(
                      aspectRatio: _videoController!.value.aspectRatio,
                      child: VideoPlayer(_videoController!),
                    )
                  : Container(
                      color: Theme.of(context).colorScheme.background,
                    ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.02,
                right: MediaQuery.of(context).size.width * 0.02,
                top: MediaQuery.of(context).size.height * 0.030,
                bottom: MediaQuery.of(context).size.height * 0.045,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (!hideControls && !pipMode) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomIconButton(
                          size: iconSize,
                          onTap: () => Navigator.of(context).pop(true),
                          icon: Icons.close_rounded,
                        ),
                        CustomIconButton(
                          size: iconSize,
                          onTap: () {
                            var config = ref.read(configServiceProvider);
                            var newConfig = config.copyWidth(
                              autoHideVideoControls:
                                  !config.autoHideVideoControls,
                            );
                            ref
                                .read(configServiceProvider.notifier)
                                .saveApplicationSettings(
                                  newConfig,
                                );
                            // show a message to indicate the settings
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Auto hide video controls: '
                                  '${!config.autoHideVideoControls}',
                                ),
                              ),
                            );
                            if (newConfig.autoHideVideoControls) {
                              setState(() {
                                hideControls = true;
                              });
                            }
                          },
                          icon: Icons.settings_outlined,
                        ),
                      ],
                    ),
                  ],
                  const Spacer(),
                  if (_videoController != null &&
                      ref
                          .read(configServiceProvider)
                          .closedCaptionsEnabled) ...[
                    ClosedCaption(
                      text: _videoController!.value.caption.text,
                      textStyle:
                          Theme.of(context).textTheme.headline4!.copyWith(
                                fontSize: size.width * 0.03,
                                color: Colors.white,
                              ),
                    ),
                  ],
                  if (!hideControls && !pipMode) ...[
                    Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        // white grey transparant background
                        color: const Color.fromARGB(255, 125, 122, 122)
                            .withOpacity(0.15),
                        // add blur effect
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: size.width * 0.008,
                          sigmaY: size.width * 0.008,
                        ),
                        // blendMode: BlendMode.srcOver,
                        child: Padding(
                          padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.01,
                          ),
                          child: Row(
                            children: [
                              CustomIconButton(
                                alpha: ref
                                        .read(configServiceProvider)
                                        .highQualityVideo
                                    ? 100
                                    : null,
                                size: iconSize,
                                onTap: () {
                                  var config = ref.read(configServiceProvider);
                                  ref
                                      .read(configServiceProvider.notifier)
                                      .saveApplicationSettings(
                                        config.copyWidth(
                                          highQualityVideo:
                                              !config.highQualityVideo,
                                        ),
                                      );
                                },
                                icon: Icons.high_quality_outlined,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: size.width * 0.01,
                                  right: size.width * 0.02,
                                ),
                                child: CustomIconButton(
                                  size: iconSize,
                                  alpha: ref
                                          .read(configServiceProvider)
                                          .closedCaptionsEnabled
                                      ? 100
                                      : null,
                                  onTap: () {
                                    var config =
                                        ref.read(configServiceProvider);
                                    ref
                                        .read(configServiceProvider.notifier)
                                        .saveApplicationSettings(
                                          config.copyWidth(
                                            closedCaptionsEnabled:
                                                !config.closedCaptionsEnabled,
                                          ),
                                        );
                                  },
                                  icon: Icons.closed_caption_outlined,
                                ),
                              ),
                              // video progress bar
                              Expanded(
                                // TODO(freek): make a custom progress bar

                                child: Stack(
                                  alignment: AlignmentDirectional.bottomCenter,
                                  children: [
                                    SliderTheme(
                                      data: SliderThemeData(
                                        activeTrackColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        trackHeight: size.height * 0.12,
                                        inactiveTrackColor:
                                            Colors.grey.withAlpha(60),
                                        thumbColor: Colors.white,
                                        overlayColor:
                                            Colors.black.withOpacity(0.1),
                                        trackShape:
                                            const RoundedRectSliderTrackShape(),
                                        thumbShape: PointyCircleThumbShape(
                                          sliderBarSize: size.height * 0.12,
                                          thumbRadius: size.width * 0.007,
                                        ),
                                        overlayShape: RoundSliderOverlayShape(
                                          overlayRadius: size.width * 0.02,
                                        ),
                                      ),
                                      child: Slider(
                                        value: secondsPlayed / _movie.duration,
                                        onChanged: _updateVideoTime,
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.bottomRight,
                                      padding: EdgeInsets.only(
                                        right: size.width * 0.04,
                                        bottom: size.height * 0.005,
                                      ),
                                      child: Text(
                                        playTime,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6!
                                            .copyWith(
                                              fontSize: size.width * 0.018,
                                              color: Colors.white,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              PiPSwitcher(
                                childWhenEnabled: CustomIconButton(
                                  size: iconSize,
                                  onTap: () {},
                                  icon: Icons.expand_outlined,
                                ),
                                childWhenDisabled: CustomIconButton(
                                  size: iconSize,
                                  onTap: _enablePip,
                                  icon: Icons.picture_in_picture,
                                ),
                                floating: floating,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (_videoController != null &&
                !_videoController!.value.isPlaying) ...[
              // Play button
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _onVideoTap,
                child: Center(
                  child: Icon(
                    Icons.pause_circle_filled,
                    size: size.width * 0.1,
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  void _setVideoUpdateTimer() {
    _updateTimer =
        Timer.periodic(Duration(seconds: timerUpdateInterval), (timer) {
      if (_videoController == null) {
        secondsPlayed += 60;
      } else {
        secondsPlayed += timerUpdateInterval;
        _videoController!.position.then((value) {
          var playedSeconds = value?.inSeconds ?? 0;
          secondsPlayed = (playedSeconds != 0) ? playedSeconds : secondsPlayed;
        });
      }
      if (secondsPlayed >= _movie.duration) {
        ref.read(movieSettingsProvider.notifier).updateMovieUserSettings(
              _settings.copyWith(
                timeWatched: 0,
                // TODO(freek): Maybe add property to indicate seen once?
              ),
            );
        _videoController?.pause();
        Navigator.of(context).pop(true);
      } else {
        ref.read(movieSettingsProvider.notifier).updateMovieUserSettings(
              _settings.copyWith(
                timeWatched: secondsPlayed,
              ),
            );
        setState(() {});
      }
    });
  }

  void _onVideoTap() {
    if (!hideControls) {
      if (_videoController != null && _videoController!.value.isPlaying) {
        _videoController!.pause();
      } else {
        _videoController!.play();
      }
    }
    _setAutoHideTimer();
  }

  Future<void> _checkPipEnabled() async {
    var status = await floating.pipStatus;
    if (pipMode && status == PiPStatus.disabled) {
      setState(() {
        pipMode = false;
      });
    }
  }

  Future<ClosedCaptionFile> _getSubtitle(String url) async {
    if (url.isEmpty) {
      return SubRipCaptionFile('');
    }
    var file = NetworkAssetBundle(Uri(path: url));
    var data = await file.load(url);
    return SubRipCaptionFile(
      utf8.decode(
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
      ),
    );
  }

  void _initializeVideo() {
    if (_movie.video.isNotEmpty) {
      // add closed caption file to the video player
      _videoController = VideoPlayerController.network(
        _movie.video,
        closedCaptionFile: _getSubtitle(_movie.subtitleFile),
        videoPlayerOptions: VideoPlayerOptions(),
      )..initialize().then((_) {
          setState(() {});
          _videoController?.seekTo(Duration(seconds: secondsPlayed));
          _videoController?.play();
        });
    } else {
      _videoController = null;
    }
  }

  Future<void> _enablePip() async {
    await floating.enable(const Rational.landscape());
    pipMode = true;
    setState(() {});
  }

  void _updateVideoTime(double value) {
    secondsPlayed = (value * _movie.duration).toInt();
    ref.read(movieSettingsProvider.notifier).updateMovieUserSettings(
          _settings.copyWith(timeWatched: secondsPlayed),
        );
    _videoController?.seekTo(Duration(seconds: secondsPlayed));
    setState(() {});
  }

  void _setAutoHideTimer() {
    setState(() {
      hideControls = false;
    });
    _controlHideTimer = Timer(const Duration(seconds: 10), () {
      if (mounted && ref.read(configServiceProvider).autoHideVideoControls) {
        setState(() {
          hideControls = true;
        });
      }
    });
  }
}
