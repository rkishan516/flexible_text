import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

/// A widget that allows mixing rich text and widgets within a single text block.
///
/// The `FlexibleText` widget allows you to use placeholders in a text string
/// to insert rich text segments or widgets. The text is split based on the
/// `richTextSeparator` and `widgetSeparator` characters, which default to `#`
/// and `~` respectively.
///
/// Example:
///
/// ```dart
/// FlexibleText(
///   text: 'Hello #World#~1~',
///   style: TextStyle(color: Colors.black),
///   richStyles: [TextStyle(color: Colors.red)],
///   widgets: [Icon(Icons.star)],
/// );
/// ```
///
/// In this example, `#World#` will be styled with `TextStyle(color: Colors.red)`,
/// and `~1~` will be replaced by an `Icon(Icons.star)`.
class FlexibleText extends StatelessWidget {
  /// Creates a [FlexibleText] widget.
  const FlexibleText({
    super.key,
    required this.text,
    required this.style,
    this.richStyles,
    this.textRecognizers,
    this.textAlign,
    this.overflow,
    this.widgets = const [],
    this.namedWidgets = const {},
    this.widgetAlignment = PlaceholderAlignment.middle,
    this.richTextSeparator = '#',
    this.widgetSeparator = '~',
  }) : assert(richTextSeparator.length == 1 && widgetSeparator.length == 1);

  /// The text to be displayed, containing placeholders for rich text and widgets.
  final String text;

  /// The default text style to be applied to the text.
  final TextStyle style;

  /// A list of styles to be applied to rich text segments.
  final List<TextStyle?>? richStyles;

  /// A list of gesture recognizers for rich text segments.
  final List<GestureRecognizer?>? textRecognizers;

  /// How the text should be aligned horizontally.
  final TextAlign? textAlign;

  /// How visual overflow should be handled.
  final TextOverflow? overflow;

  /// The alignment of the inline widgets.
  final PlaceholderAlignment widgetAlignment;

  /// The list of widgets to be inserted into the text.
  final List<Widget> widgets;

  /// The map of named widgets to be inserted into the text.
  final Map<String, Widget> namedWidgets;

  /// The character used to separate rich text segments.
  final String richTextSeparator;

  /// The character used to separate widget placeholders.
  final String widgetSeparator;

  @override
  Widget build(BuildContext context) {
    final blocks = _splitTextAndWidgetBlocks(text);

    return Text.rich(
      TextSpan(
        style: style,
        children: blocks.map((block) => _getTextSpan(block)).toList(),
      ),
      textAlign: textAlign,
      overflow: overflow,
    );
  }

  InlineSpan _getTextSpan(_Block block) {
    if (block is _WidgetBlock) {
      return WidgetSpan(
        alignment: widgetAlignment,
        child: block.child,
      );
    } else if (block is _TextBlock) {
      return TextSpan(
        text: block.text,
        style: block.style,
        recognizer: block.recognizer,
      );
    } else {
      return const TextSpan();
    }
  }

  List<_Block> _splitTextAndWidgetBlocks(String text) {
    List<_Block> blocks = [];
    String currentChunk = '';
    for (int i = 0; i < text.length; i++) {
      String currentCheckingCharacter = text[i];

      if (currentCheckingCharacter == richTextSeparator) {
        if (currentChunk.isNotEmpty) {
          blocks.add(_TextBlock(text: currentChunk));
          currentChunk = '';
        }
        var endIndex = text.indexOf(richTextSeparator, i + 1);
        if (endIndex == -1) {
          currentChunk = currentCheckingCharacter;
        } else {
          final tmpText = text.substring(i + 1, endIndex);
          blocks.add(
            _TextBlock(
              text: tmpText,
              style: richStyles?.tryGet(blocks
                  .where((element) =>
                      (element is _TextBlock && element.style != null))
                  .length),
              recognizer: textRecognizers?.tryGet(
                blocks
                    .where((element) =>
                        (element is _TextBlock && element.recognizer != null))
                    .length,
              ),
            ),
          );
          i = endIndex;
        }
      } else if (currentCheckingCharacter == widgetSeparator) {
        if (currentChunk.isNotEmpty) {
          blocks.add(_TextBlock(text: currentChunk));
          currentChunk = '';
        }
        var end = text.indexOf(widgetSeparator, i + 1);
        if (end == -1) {
          currentChunk = currentCheckingCharacter;
        } else {
          var widgetIndex = int.tryParse(text.substring(i + 1, end));
          if (widgetIndex != null) {
            var tmpText = text.substring(i + 1, end);
            blocks.add(
                _WidgetBlock(text: tmpText, child: widgets[widgetIndex - 1]));
          } else if (namedWidgets.containsKey(text.substring(i + 1, end))) {
            var tmpText = text.substring(i + 1, end);
            blocks.add(
              _WidgetBlock(
                text: tmpText,
                child: namedWidgets[tmpText]!,
              ),
            );
          } else {
            blocks.add(_TextBlock(text: text.substring(i, end + 1)));
          }
          i = end;
        }
      } else {
        currentChunk += currentCheckingCharacter;
      }
    }
    if (currentChunk.isNotEmpty) {
      blocks.add(_TextBlock(text: currentChunk));
    }

    return blocks;
  }
}

extension _ListGetExtension<T> on List<T> {
  T? tryGet(int index) => (index < 0 || index >= length) ? null : this[index];
}

class _Block {
  const _Block({required this.text});
  final String text;
}

class _TextBlock extends _Block {
  const _TextBlock({required super.text, this.style, this.recognizer});
  final TextStyle? style;
  final GestureRecognizer? recognizer;
}

class _WidgetBlock extends _Block {
  const _WidgetBlock({required super.text, required this.child});
  final Widget child;
}
