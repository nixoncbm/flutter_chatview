import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatview/src/models/chat_option.dart';
import 'package:flutter/material.dart';

class ListOptionMessage extends StatelessWidget {
  const ListOptionMessage({
    Key? key,
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


    return Column(
      children: [
        for (ChatOption chatOption in listChatOption) ...[
          if (chatOption.typeWithChat == typeWithChat) ...[
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 10),
              height: 40,
              child: ListView.builder(
                shrinkWrap: true,
                //reverse: true,
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: chatOption.messages!.length,
                itemBuilder: (context, index) {
                  MessageOption message = chatOption.messages![index];
                  return SizedBox(
                      child: InkWell(
                    onTap: () {
                      onPressed(message.chat!);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10.0)),
                        color: backgroundColor ??
                            (isDarkMode
                                ? theme.surface.withOpacity(0.3)
                                : theme.surface),
                        border: Border.all(
                          width: 1.0,
                          color: backgroundColor ??
                              (isDarkMode
                                  ? theme.tertiary.withOpacity(0.3)
                                  : theme.surface),
                        ),
                      ),
                      margin: const EdgeInsets.only(
                        right: 5.0,
                        left: 5,
                      ),
                      padding: const EdgeInsets.only(
                          left: 5, right: 5, bottom: 5, top: 7),
                      child: Row(
                        children: [
                          if (message.icon != null && message.icon != '' && (message.icon.startsWith('https:') || message.icon.startsWith('http:'))) ...[
                            CachedNetworkImage(
                              imageUrl: message.icon,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) =>
                                      CircularProgressIndicator(
                                value: downloadProgress.progress,
                                strokeWidth: 1,
                              ),
                              errorWidget: (context, url, error) => const Icon(
                                  Icons.image_rounded),
                            ),
                          ],
                          Text(
                            message.chat!,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: textBackgroundColor ??
                                    (isDarkMode
                                        ? Colors.white
                                        : theme.tertiary)),
                          ),
                        ],
                      ),
                    ),
                  ));
                },
              ),
            ),
          ]
        ],
      ],
    );
  }
}
