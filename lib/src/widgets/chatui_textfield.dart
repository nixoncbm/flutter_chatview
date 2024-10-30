/*
 * Copyright (c) 2022 Simform Solutions
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
import 'dart:async';
import 'dart:io' show Platform;

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:chatview/src/models/chat_option.dart';
import 'package:chatview/src/utils/constants/constants.dart';
import 'package:chatview/src/utils/state/inheritedview_l10n.dart';
import 'package:chatview/src/widgets/card_option_message.dart';
import 'package:chatview/src/widgets/list_option_message.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../chatview.dart';
import '../utils/debounce.dart';


class ChatUITextField extends StatefulWidget {
  const ChatUITextField(
      {Key? key,
      this.sendMessageConfig,
      required this.focusNode,
      required this.textEditingController,
      required this.onPressed,
      required this.onRecordingComplete,
      required this.onImageSelected,
      this.chatOptions,
      this.typeWithChat,
      required this.onChatOption})
      : super(key: key);


  /// Provides configuration of default text field in chat.
  final SendMessageConfiguration? sendMessageConfig;

  /// Provides focusNode for focusing text field.
  final FocusNode focusNode;

  /// Provides functions which handles text field.
  final TextEditingController textEditingController;

  /// Provides callback when user tap on text field.
  final VoidCallBack onPressed;

  /// Provides callback once voice is recorded.
  final Function(String?) onRecordingComplete;

  /// Provides callback when user select images from camera/gallery.
  final StringsCallBack onImageSelected;

  /// Option message direct
  final List<ChatOption>? chatOptions;

  /// TypeWithChat  store clipper
  final int? typeWithChat;

  /// Provides callback when user tap on text field.
  final Function(String?) onChatOption;

  @override
  State<ChatUITextField> createState() => _ChatUITextFieldState();
}

class _ChatUITextFieldState extends State<ChatUITextField> {
  final ValueNotifier<String> _inputText = ValueNotifier('');

  final ImagePicker _imagePicker = ImagePicker();

  RecorderController? controller;

  ValueNotifier<bool> isRecording = ValueNotifier(false);

  SendMessageConfiguration? get sendMessageConfig => widget.sendMessageConfig;

  VoiceRecordingConfiguration? get voiceRecordingConfig =>
      widget.sendMessageConfig?.voiceRecordingConfiguration;

  ImagePickerIconsConfiguration? get imagePickerIconsConfig =>
      sendMessageConfig?.imagePickerIconsConfig;

  TextFieldConfiguration? get textFieldConfig => sendMessageConfig?.textFieldConfig;

  ChatOptionConfiguration? get chatOptionConfig =>
      sendMessageConfig?.chatOptionConfiguration;

  OutlineInputBorder get _outLineBorder => OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.transparent),
        borderRadius:
            textFieldConfig?.borderRadius ?? BorderRadius.circular(textFieldBorderRadius),
      );

  ValueNotifier<TypeWriterStatus> composingStatus = ValueNotifier(TypeWriterStatus.typed);

  late Debouncer debouncer;

  Timer? timer;

  @override
  void initState() {
    attachListeners();
    debouncer = Debouncer(sendMessageConfig?.textFieldConfig?.compositionThresholdTime ??
        const Duration(seconds: 1));
    super.initState();

    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android) {
      controller = RecorderController();
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    debouncer.dispose();
    composingStatus.dispose();
    isRecording.dispose();
    _inputText.dispose();
    super.dispose();
  }

  void attachListeners() {
    composingStatus.addListener(() {
      widget.sendMessageConfig?.textFieldConfig?.onMessageTyping
          ?.call(composingStatus.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeBlack = Theme.of(context);
    final theme = Theme.of(context).colorScheme;
    final isDarkMode = themeBlack.brightness == Brightness.dark;

    return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      return Container(
        margin: textFieldConfig?.margin,
        decoration: BoxDecoration(
          borderRadius: textFieldConfig?.borderRadius ??
              BorderRadius.circular(textFieldBorderRadius),
          color: sendMessageConfig?.textFieldBackgroundColor ?? Colors.white,
        ),
        child: ValueListenableBuilder<bool>(
          valueListenable: isRecording,
          builder: (_, isRecordingValue, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                    color: isDarkMode
                        ? theme.secondary.withOpacity(0.3)
                        : Colors.white,
                    border: Border.all(
                      width: 1.0,
                      color: isDarkMode
                          ? theme.tertiary.withOpacity(0.3)
                          : Colors.white,
                    ),
                  ),
                  padding: const EdgeInsets.only(left: 5.0, top: 5, bottom: 5),
                  child: Row(
                    children: [
                      if (isRecordingValue && controller != null && !kIsWeb)
                        SafeArea(
                          top: false,
                          child: AudioWaveforms(
                            size: Size(MediaQuery.of(context).size.width * 0.75, 50),
                            recorderController: controller!,
                            margin: voiceRecordingConfig?.margin,
                            padding: voiceRecordingConfig?.padding ??
                                const EdgeInsets.symmetric(horizontal: 8),
                            decoration: voiceRecordingConfig?.decoration ??
                                BoxDecoration(
                                  color: voiceRecordingConfig?.backgroundColor,
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                            waveStyle: voiceRecordingConfig?.waveStyle ??
                                WaveStyle(
                                  showDurationLabel: true,
                                  extendWaveform: true,
                                  showMiddleLine: false,
                                  waveColor: voiceRecordingConfig?.waveStyle?.waveColor ??
                                      Colors.black,
                                ),
                          ),
                        )
                      else
                        Expanded(
                          child: TextField(
                            focusNode: widget.focusNode,
                            controller: widget.textEditingController,
                            style: textFieldConfig?.textStyle ??
                                 TextStyle(color: theme.tertiary),
                            maxLines: textFieldConfig?.maxLines ?? 5,
                            minLines: textFieldConfig?.minLines ?? 1,
                            keyboardType: textFieldConfig?.textInputType,
                            inputFormatters: textFieldConfig?.inputFormatters,
                            onChanged: _onChanged,
                            textCapitalization: textFieldConfig?.textCapitalization ??
                                TextCapitalization.sentences,
                            decoration: InputDecoration(
                              hintText: textFieldConfig?.hintText ??
                                  InheritedViewL10n.of(context).l10n.message,
                              fillColor: sendMessageConfig?.textFieldBackgroundColor ??
                                  Colors.white,
                              filled: true,
                              hintStyle: textFieldConfig?.hintStyle ??
                                  TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color:theme.tertiary,
                                    letterSpacing: 0.25,
                                  ),
                              contentPadding: textFieldConfig?.contentPadding ??
                                  const EdgeInsets.symmetric(horizontal: 6),
                              border: _outLineBorder,
                              focusedBorder: _outLineBorder,
                              enabledBorder: OutlineInputBorder(
                                borderSide:  BorderSide(color: theme.primary),
                                borderRadius: textFieldConfig?.borderRadius ??
                                    BorderRadius.circular(textFieldBorderRadius),
                              ),
                            ),
                          ),
                        ),
                      ValueListenableBuilder<String>(
                        valueListenable: _inputText,
                        builder: (_, inputTextValue, child) {
                          if (inputTextValue.isNotEmpty) {
                            return IconButton(
                              color: sendMessageConfig?.defaultSendButtonColor ??
                                  theme.primary,
                              onPressed: () {
                                widget.onPressed();
                                _inputText.value = '';
                              },
                              icon: sendMessageConfig?.sendButtonIcon ??
                                  Icon(Icons.send, color: theme.tertiary,),
                            );
                          } else {
                            return Row(
                              children: [
                                if (!isRecordingValue) ...[
                                  if (sendMessageConfig?.enableCameraImagePicker ?? true)
                                    IconButton(
                                      constraints: const BoxConstraints(),
                                      onPressed: () => _onIconPressed(
                                        ImageSource.camera,
                                        config:
                                            sendMessageConfig?.imagePickerConfiguration,
                                      ),
                                      icon:
                                          imagePickerIconsConfig?.cameraImagePickerIcon ??
                                              Icon(
                                                Icons.camera_alt_outlined,
                                                color: theme.tertiary,
                                              ),
                                    ),
                                  if (sendMessageConfig?.enableGalleryImagePicker ?? true)
                                    IconButton(
                                      constraints: const BoxConstraints(),
                                      onPressed: () => _onIconPressed(
                                        ImageSource.gallery,
                                        config:
                                            sendMessageConfig?.imagePickerConfiguration,
                                      ),
                                      icon: imagePickerIconsConfig?.galleryImagePickerIcon ??
                                          Icon(
                                            Icons.image,
                                            color:
                                            theme.tertiary,
                                          ),
                                    ),
                                ],
                                if (sendMessageConfig?.allowRecordingVoice ??
                                    true &&
                                        Platform.isIOS &&
                                        Platform.isAndroid &&
                                        !kIsWeb)
                                  IconButton(
                                    onPressed: _recordOrStop,
                                    icon: (isRecordingValue
                                            ? voiceRecordingConfig?.micIcon
                                            : voiceRecordingConfig?.stopIcon) ??
                                        Icon(isRecordingValue ? Icons.stop : Icons.mic),
                                    color: theme.tertiary,
                                  )
                              ],
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                if (!isRecordingValue && !kIsWeb) ...[
                  if (widget.chatOptions != null &&
                      widget.chatOptions!.isNotEmpty &&
                      widget.typeWithChat != null&&isKeyboardVisible) ...[
                    ListOptionMessage(
                      listChatOption: widget.chatOptions!,
                      typeWithChat: widget.typeWithChat!,
                      onPressed: (message) {
                        if (widget.chatOptions != null) {
                          widget.onChatOption(message);
                        }
                      },
                    )
                  ]
                ],
                if (!isRecordingValue && !kIsWeb) ...[
                  if (widget.chatOptions != null &&
                      widget.chatOptions!.isNotEmpty &&
                      widget.typeWithChat != null &&
                      !isKeyboardVisible) ...[
                    CardOptionMessage(
                      listChatOption: widget.chatOptions!,
                      typeWithChat: widget.typeWithChat!,
                      onPressed: (message) {
                        if (widget.chatOptions != null) {
                          widget.onChatOption(message);
                        }
                      },
                    )
                  ]
                ],
              ],
            );
          },
        ),
      );
    });
  }

  Future<void> _recordOrStop() async {
    assert(
      defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.android,
      "Voice messages are only supported with android and ios platform",
    );
    if (!isRecording.value) {
      var date = DateTime.now().microsecondsSinceEpoch;
      final directory = await getTemporaryDirectory();
      final path = directory.path;
      await controller?.record(
          path: '$path/${"$date.m4a"}',
          sampleRate: Platform.isIOS
              ? sendMessageConfig?.voiceRecordingConfiguration?.sampleRate
              : null);
      isRecording.value = true;
      if (sendMessageConfig?.voiceRecordingConfiguration?.maxDuration != null) {
        timer =
            Timer(sendMessageConfig!.voiceRecordingConfiguration!.maxDuration!, () async {
          final path = await controller?.stop();
          isRecording.value = false;
          widget.onRecordingComplete(path);
        });
      }
    } else {
      timer?.cancel();
      final path = await controller?.stop();
      isRecording.value = false;
      widget.onRecordingComplete(path);
    }
  }

  void _onIconPressed(
    ImageSource imageSource, {
    ImagePickerConfiguration? config,
  }) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: imageSource,
        maxHeight: config?.maxHeight,
        maxWidth: config?.maxWidth,
        imageQuality: config?.imageQuality,
        preferredCameraDevice: config?.preferredCameraDevice ?? CameraDevice.rear,
      );
      String? imagePath = image?.path;
      if (config?.onImagePicked != null) {
        String? updatedImagePath = await config?.onImagePicked!(imagePath);
        if (updatedImagePath != null) imagePath = updatedImagePath;
      }
      widget.onImageSelected(imagePath ?? '', '');
    } catch (e) {
      widget.onImageSelected('', e.toString());
    }
  }

  void _onChanged(String inputText) {
    debouncer.run(() {
      composingStatus.value = TypeWriterStatus.typed;
    }, () {
      composingStatus.value = TypeWriterStatus.typing;
    });
    _inputText.value = inputText;
  }
}
