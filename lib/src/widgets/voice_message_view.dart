import 'dart:async';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:chatview/chatview.dart';
import 'package:chatview/src/extensions/extensions.dart';
import 'package:chatview/src/models/voice_message_configuration.dart';
import 'package:chatview/src/utils/constants/constants.dart';
import 'package:chatview/src/widgets/reaction_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_linkify/flutter_linkify.dart';

class VoiceMessageView extends StatefulWidget {
  const VoiceMessageView({
    Key? key,
    required this.screenWidth,
    required this.message,
    required this.isMessageBySender,
    this.inComingChatBubbleConfig,
    this.outgoingChatBubbleConfig,
    this.onMaxDuration,
    this.messageReactionConfig,
    this.config,
  }) : super(key: key);

  /// Provides configuration related to voice message.
  final VoiceMessageConfiguration? config;

  /// Allow user to set width of chat bubble.
  final double screenWidth;

  /// Provides message instance of chat.
  final Message message;
  final Function(int)? onMaxDuration;

  /// Represents current message is sent by current user.
  final bool isMessageBySender;

  /// Provides configuration of reaction appearance in chat bubble.
  final MessageReactionConfiguration? messageReactionConfig;

  /// Provides configuration of chat bubble appearance from other user of chat.
  final ChatBubble? inComingChatBubbleConfig;

  /// Provides configuration of chat bubble appearance from current user of chat.
  final ChatBubble? outgoingChatBubbleConfig;

  @override
  State<VoiceMessageView> createState() => _VoiceMessageViewState();
}

class _VoiceMessageViewState extends State<VoiceMessageView> {
  late PlayerController controller;
  late StreamSubscription<PlayerState> playerStateSubscription;

  final ValueNotifier<PlayerState> _playerState =
      ValueNotifier(PlayerState.stopped);

  PlayerState get playerState => _playerState.value;

  PlayerWaveStyle playerWaveStyle = const PlayerWaveStyle(scaleFactor: 70);

  @override
  void initState() {
    super.initState();

    if(!widget.message.message.isUrl){
      controller = PlayerController()
        ..preparePlayer(
          path: widget.message.message,
          noOfSamples: widget.config?.playerWaveStyle
              ?.getSamplesForWidth(widget.screenWidth * 0.5) ??
              playerWaveStyle.getSamplesForWidth(widget.screenWidth * 0.5),
        ).whenComplete(() => widget.onMaxDuration?.call(controller.maxDuration));
      playerStateSubscription = controller.onPlayerStateChanged
          .listen((state) => _playerState.value = state);
    } else {
      controller = PlayerController();
      downloadAudioFromUrl(widget.message.message, widget.message.id).then((audioDownloaded) {
        controller.preparePlayer(
          path: audioDownloaded,
          noOfSamples: widget.config?.playerWaveStyle
              ?.getSamplesForWidth(widget.screenWidth * 0.5) ??
              playerWaveStyle.getSamplesForWidth(widget.screenWidth * 0.5),
        ).whenComplete(() => widget.onMaxDuration?.call(controller.maxDuration));
        playerStateSubscription = controller.onPlayerStateChanged
            .listen((state) => _playerState.value = state);
      });
    }
  }

  Future<String> downloadAudioFromUrl(String url, String id) async {
    var file = await DefaultCacheManager().getSingleFile(url);
    return file.path;
  }

  @override
  void dispose() {
    playerStateSubscription.cancel();
    controller.dispose();
    _playerState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: widget.config?.decoration ??
              BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: widget.isMessageBySender
                    ? widget.outgoingChatBubbleConfig?.color
                    : widget.inComingChatBubbleConfig?.color,
              ),
          padding: widget.config?.padding ??
              const EdgeInsets.only(left: 8,right: 8, bottom: 8),
          margin: widget.config?.margin ??
              EdgeInsets.symmetric(
                horizontal: 8,
                vertical: widget.message.reaction.reactions.isNotEmpty ? 15 : 0,
              ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ValueListenableBuilder<PlayerState>(
                    builder: (context, state, child) {
                      return IconButton(
                        onPressed: _playOrPause,
                        icon:
                            state.isStopped || state.isPaused || state.isInitialised
                                ? widget.config?.playIcon ??
                                    const Icon(
                                      Icons.play_arrow,
                                      color: Colors.white,
                                    )
                                : widget.config?.pauseIcon ??
                                    const Icon(
                                      Icons.stop,
                                      color: Colors.white,
                                    ),
                      );
                    },
                    valueListenable: _playerState,
                  ),
                  AudioFileWaveforms(
                    size: Size(widget.screenWidth * 0.50, 60),
                    playerController: controller,
                    waveformType: WaveformType.fitWidth,
                    playerWaveStyle:
                        widget.config?.playerWaveStyle ?? playerWaveStyle,
                    padding: widget.config?.waveformPadding ??
                        const EdgeInsets.only(right: 10),
                    margin: widget.config?.waveformMargin,
                    animationCurve: widget.config?.animationCurve ?? Curves.easeIn,
                    animationDuration: widget.config?.animationDuration ??
                        const Duration(milliseconds: 500),
                    enableSeekGesture: widget.config?.enableSeekGesture ?? true,
                  ),
                ],
              ),
              Linkify(
                text: dateFormatterMessage(widget.message.createdAt).toString(),
                style: textTheme.bodyMedium!.copyWith(
                  color: Colors.white,
                  fontSize: 12,
                ),
              )
            ],
          ),
        ),
        if (widget.message.reaction.reactions.isNotEmpty)
          ReactionWidget(
            isMessageBySender: widget.isMessageBySender,
            reaction: widget.message.reaction,
            messageReactionConfig: widget.messageReactionConfig,
          ),
      ],
    );
  }

  void _playOrPause() {
    assert(
      defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.android,
      "Voice messages are only supported with android and ios platform",
    );
    if (playerState.isInitialised ||
        playerState.isPaused ||
        playerState.isStopped) {
      controller.startPlayer(finishMode: FinishMode.pause);
    } else {
      controller.pausePlayer();
    }
  }
}
