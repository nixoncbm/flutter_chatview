import 'package:flutter/material.dart';

/// Base chat l10n containing all required properties to provide localized copy.
/// Extend this class if you want to create a custom l10n.
@immutable
abstract class ChatViewL10n {
  /// Creates a new chat l10n based on provided copy.
  const ChatViewL10n({
    required this.today,
    required this.yesterday,
    required this.repliedToYou,
    required this.repliedBy,
    required this.more,
    required this.unsend,
    required this.reply,
    required this.replyTo,
    required this.message,
    required this.reactionPopupTitle,
    required this.photo,
    required this.send,
    required this.you,
    required this.noMessages,
    required this.somethingWentWrong,
    required this.reload,
  });

  final String today;
  final String yesterday;
  final String repliedToYou;
  final String repliedBy;
  final String more;
  final String unsend;
  final String reply;
  final String replyTo;
  final String message;
  final String reactionPopupTitle;
  final String photo;
  final String send;
  final String you;
  final String noMessages;
  final String somethingWentWrong;
  final String reload;
}

/// English l10n which extends [ChatViewL10n].
@immutable
class ChatViewL10nEn extends ChatViewL10n {
  /// Creates English l10n. Use this constructor if you want to
  /// override only a couple of properties, otherwise create a new class
  /// which extends [ChatViewL10n].
  const ChatViewL10nEn({
    super.today = "Today",
    super.yesterday = "Yesterday",
    super.repliedToYou = "Replied to you",
    super.repliedBy = "Replied by",
    super.more = "More",
    super.unsend = "Unsend",
    super.reply = "Reply",
    super.replyTo = "Replying to",
    super.message = "Message",
    super.reactionPopupTitle = "Tap and hold to multiply your reaction",
    super.photo = "Photo",
    super.send = "Send",
    super.you = "You",
    super.noMessages = "No Messages",
    super.somethingWentWrong = "Something went wrong !!",
    super.reload = "Reload",
  });
}

/// Spanish l10n which extends [ChatViewL10n].
@immutable
class ChatViewL10nEs extends ChatViewL10n {
  /// Creates Spanish l10n. Use this constructor if you want to
  /// override only a couple of properties, otherwise create a new class
  /// which extends [ChatViewL10n].
  const ChatViewL10nEs({
    super.today = "Hoy",
    super.yesterday = "Ayer",
    super.repliedToYou = "Respondido a ti",
    super.repliedBy = "Respondido por",
    super.more = "Más",
    super.unsend = "Deshacer",
    super.reply = "Responder",
    super.replyTo = "Respondiendo a",
    super.message = "Mensaje",
    super.reactionPopupTitle = "Toca y mantén para multiplicar tu reacción",
    super.photo = "Foto",
    super.send = "Enviar",
    super.you = "Tú",
    super.noMessages = "Ningún mensaje",
    super.somethingWentWrong = "Algo salió mal !!",
    super.reload = "Recargar",
  });
}