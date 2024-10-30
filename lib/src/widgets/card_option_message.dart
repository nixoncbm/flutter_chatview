import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatview/src/models/chat_option.dart';
import 'package:flutter/material.dart';

class CardOptionMessage extends StatelessWidget {
  const CardOptionMessage(
      {Key? key,
      required this.listChatOption,
      required this.typeWithChat,
      required this.onPressed,
      this.backgroundColor,
      this.textBackgroundColor})
      : super(key: key);

  final List<ChatOption> listChatOption;
  final int typeWithChat;
  final Function(String) onPressed;
  final Color? backgroundColor;
  final Color? textBackgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final themeBlack = Theme.of(context);
    final isDarkMode = themeBlack.brightness == Brightness.dark;
    final screenSize = MediaQuery.sizeOf(context);

    return Column(
      children: [
        for (ChatOption chatOption in listChatOption) ...[
          if (chatOption.typeWithChat == typeWithChat) ...[
            Container(
              constraints: BoxConstraints(
                  minHeight: 50,
                  maxHeight: screenSize.width * 0.5,
                  maxWidth: double.infinity),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                color: backgroundColor ??
                    (isDarkMode
                        ? theme.secondary.withOpacity(0.3)
                        : theme.surface),
                border: Border.all(
                  width: 1.0,
                  color: backgroundColor ??
                      (isDarkMode
                          ? theme.tertiary.withOpacity(0.3)
                          : theme.surface),
                ),
              ),
              child: ListView.builder(
                padding:  const EdgeInsets.only(top: 20),
                shrinkWrap: true,
                //reverse: true,
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: chatOption.messages!.length,
                itemBuilder: (context, index) {
                  MessageOption message = chatOption.messages![index];
                  return InkWell(
                    onTap: () {
                      onPressed(message.chat!);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (message.icon != null &&
                            message.icon != '' &&
                            (message.icon.startsWith('https:') ||
                                message.icon.startsWith('http:'))) ...[
                          CachedNetworkImage(
                            imageUrl: message.icon,
                            progressIndicatorBuilder: (context, url, downloadProgress) =>
                                CircularProgressIndicator(
                              value: downloadProgress.progress,
                              strokeWidth: 1,
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.image_rounded),
                          ),
                        ],
                        Text(
                          message.chat!,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,

                              color: textBackgroundColor ??
                                  (isDarkMode
                                      ? theme.tertiaryContainer
                                      : theme.tertiary)),
                        ),
                        const Divider(height: 30,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ]
        ],
      ],
    );
  }
}
