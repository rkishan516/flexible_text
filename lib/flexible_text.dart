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
    this.style,
    this.richStyles,
    this.namedRichStyles = const {},
    this.textRecognizers,
    this.onTapCallbacks,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.textDirection,
    this.textScaler,
    this.strutStyle,
    this.locale,
    this.softWrap,
    this.semanticsLabel,
    this.selectionColor,
    this.widgets = const [],
    this.namedWidgets = const {},
    this.widgetAlignment = PlaceholderAlignment.middle,
    this.richTextSeparator = '#',
    this.widgetSeparator = '~',
  })  : assert(richTextSeparator.length == 1 && widgetSeparator.length == 1),
        assert(richTextSeparator != widgetSeparator,
            'richTextSeparator and widgetSeparator must be different characters');

  /// The text to be displayed, containing placeholders for rich text and widgets.
  final String text;

  /// The default text style to be applied to the text.
  final TextStyle? style;

  /// A list of styles to be applied to rich text segments.
  ///
  /// Styles are applied by index: the first `#...#` segment gets `richStyles[0]`,
  /// the second gets `richStyles[1]`, and so on.
  /// Styles are merged with the base [style] using [TextStyle.merge],
  /// so rich styles only need to specify the properties they want to override.
  final List<TextStyle?>? richStyles;

  /// A map of named styles for rich text segments.
  ///
  /// Use the syntax `#name:text#` in the text to apply a named style.
  /// For example, `#bold:Hello#` applies the style mapped to `"bold"`.
  /// Named styles are merged with the base [style] using [TextStyle.merge].
  /// If the name is not found, the segment falls through to index-based styling.
  final Map<String, TextStyle> namedRichStyles;

  /// A list of gesture recognizers for rich text segments.
  final List<GestureRecognizer?>? textRecognizers;

  /// A list of tap callbacks for rich text segments.
  ///
  /// This is a convenience alternative to [textRecognizers] for simple tap handling.
  /// Each callback is automatically wrapped in a [TapGestureRecognizer].
  /// If both [textRecognizers] and [onTapCallbacks] provide a recognizer at the
  /// same index, [textRecognizers] takes precedence.
  final List<VoidCallback?>? onTapCallbacks;

  /// How the text should be aligned horizontally.
  final TextAlign? textAlign;

  /// How visual overflow should be handled.
  final TextOverflow? overflow;

  /// An optional maximum number of lines for the text to span.
  final int? maxLines;

  /// The directionality of the text (e.g., [TextDirection.ltr] or [TextDirection.rtl]).
  final TextDirection? textDirection;

  /// The font scaling strategy to use when laying out and rendering the text.
  final TextScaler? textScaler;

  /// The strut style to use, which defines minimum line heights.
  final StrutStyle? strutStyle;

  /// Used to select a font when the same Unicode character can be rendered differently.
  final Locale? locale;

  /// Whether the text should break at soft line breaks.
  final bool? softWrap;

  /// An alternative semantics label for accessibility.
  final String? semanticsLabel;

  /// The color to use when painting the selection highlight.
  final Color? selectionColor;

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
      maxLines: maxLines,
      textDirection: textDirection,
      textScaler: textScaler,
      strutStyle: strutStyle,
      locale: locale,
      softWrap: softWrap ?? true,
      semanticsLabel: semanticsLabel,
      selectionColor: selectionColor,
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
        style: block.style != null
            ? style?.merge(block.style) ?? block.style
            : null,
        recognizer: block.recognizer,
      );
    } else {
      return const TextSpan();
    }
  }

  List<_Block> _splitTextAndWidgetBlocks(String text) {
    List<_Block> blocks = [];
    String currentChunk = '';
    int indexBasedStyleCount = 0;
    int richSegmentCount = 0;
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

          // Check for named style syntax: #name:text#
          final colonIndex = tmpText.indexOf(':');
          TextStyle? resolvedStyle;
          String displayText = tmpText;
          bool usedNamedStyle = false;

          if (colonIndex > 0 &&
              namedRichStyles.containsKey(tmpText.substring(0, colonIndex))) {
            final styleName = tmpText.substring(0, colonIndex);
            displayText = tmpText.substring(colonIndex + 1);
            resolvedStyle = namedRichStyles[styleName];
            usedNamedStyle = true;
          }

          // Fall through to index-based style if no named style was matched
          if (!usedNamedStyle) {
            resolvedStyle = richStyles?.tryGet(indexBasedStyleCount);
            indexBasedStyleCount++;
          }

          // Resolve recognizer: textRecognizers takes precedence over onTapCallbacks
          GestureRecognizer? resolvedRecognizer =
              textRecognizers?.tryGet(richSegmentCount);
          if (resolvedRecognizer == null) {
            final callback = onTapCallbacks?.tryGet(richSegmentCount);
            if (callback != null) {
              resolvedRecognizer = TapGestureRecognizer()..onTap = callback;
            }
          }
          richSegmentCount++;

          blocks.add(
            _TextBlock(
              text: displayText,
              style: resolvedStyle,
              recognizer: resolvedRecognizer,
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
          final placeholder = text.substring(i + 1, end);
          var widgetIndex = int.tryParse(placeholder);
          if (widgetIndex != null &&
              widgetIndex > 0 &&
              widgetIndex - 1 < widgets.length) {
            blocks.add(_WidgetBlock(
                text: placeholder, child: widgets[widgetIndex - 1]));
          } else if (namedWidgets.containsKey(placeholder)) {
            blocks.add(
              _WidgetBlock(
                text: placeholder,
                child: namedWidgets[placeholder]!,
              ),
            );
          } else {
            assert(() {
              if (widgetIndex != null) {
                debugPrint(
                    'FlexibleText: Widget index $widgetIndex is out of bounds. '
                    'widgets list has ${widgets.length} element(s).');
              } else {
                debugPrint(
                    'FlexibleText: Widget placeholder "$placeholder" not found in namedWidgets. '
                    'Available keys: ${namedWidgets.keys.toList()}.');
              }
              return true;
            }());
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
