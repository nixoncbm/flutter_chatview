import 'package:chatview/src/models/chat_option.dart';
import 'package:flutter/material.dart';

class ListOptionMessage extends StatelessWidget {
  const ListOptionMessage({
    Key? key,
    required this.listChatOption,
    required this.typeWithChat,
    required this.onPressed,
  }) : super(key: key);

  final List<ChatOption> listChatOption;
  final int typeWithChat;
  final Function(String) onPressed;

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
                reverse: true,
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: chatOption.messages!.length,
                itemBuilder: (context, index) {
                  return itemOption(
                      context, chatOption.messages![index], theme, isDarkMode);
                },
              ),
            ),
          ]
        ],
      ],
    );
  }

  Widget itemOption(BuildContext context, MessageOption message,
      ColorScheme theme, bool isDarkMod) {
    return SizedBox(
      child: InkWell(
        onTap: () {
          onPressed(message.chat!);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            color: theme.primary,
            border: Border.all(
              width: 1.0,
              color: theme.primary,
            ),
          ),
          margin: const EdgeInsets.only(
            right: 5.0,
            left: 5,
          ),
          padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5, top: 7),
          child: Row(
            children: [
              if (message.icon != null && message.icon != '') ...[
                Image.network(
                  '${message.icon}',
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox.shrink();
                  },
                )
              ],
              Text(
                message.chat!,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color:
                        isDarkMod ? theme.tertiary : theme.tertiaryContainer),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
