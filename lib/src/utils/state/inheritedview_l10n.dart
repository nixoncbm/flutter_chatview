import 'package:flutter/widgets.dart';

import '../../chatview_l10n.dart';

/// Used to make provided [ChatViewL10n] class available through the whole package.
class InheritedViewL10n extends InheritedWidget {
  /// Creates [InheritedWidget] from a provided [ChatViewL10n] class.
  const InheritedViewL10n({
    super.key,
    required this.l10n,
    required super.child,
  });

  static InheritedViewL10n of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<InheritedViewL10n>()!;

  /// Represents localized copy.
  final ChatViewL10n l10n;

  @override
  bool updateShouldNotify(InheritedViewL10n oldWidget) =>
      l10n.hashCode != oldWidget.l10n.hashCode;
}
