import 'package:flexible_text/flexible_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

extension on TextSpan {
  int countTextSpansWithText(String text) {
    return children!
        .where((span) => span is TextSpan && span.text == text)
        .length;
  }

  TextSpan textSpanWithText(String text) {
    return children!.firstWhere(
      (span) => span is TextSpan && span.text == text,
    ) as TextSpan;
  }

  List<WidgetSpan> get widgetSpanChildren {
    return children!.whereType<WidgetSpan>().toList();
  }
}

TextSpan _getTextSpan(WidgetTester tester) {
  final textWidget = tester.widget<Text>(find.byType(Text));
  return textWidget.textSpan! as TextSpan;
}

void main() {
  // ─── Basic Rendering ───────────────────────────────────────────

  group('Basic rendering', () {
    testWidgets('renders plain text', (WidgetTester tester) async {
      const text = 'Hello, world!';
      const widget = FlexibleText(
        text: text,
        style: TextStyle(color: Colors.black),
      );

      await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

      expect(find.text(text), findsOneWidget);
    });

    testWidgets('renders empty text gracefully', (WidgetTester tester) async {
      const widget = FlexibleText(
        text: '',
        style: TextStyle(color: Colors.black),
      );

      await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

      expect(find.text(''), findsOneWidget);
    });
  });

  // ─── Rich Text Styling ─────────────────────────────────────────

  group('Rich text styling', () {
    testWidgets('applies rich style to segment', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: FlexibleText(
            text: 'Hello #World#',
            style: TextStyle(color: Colors.black),
            richStyles: [TextStyle(color: Colors.red)],
          ),
        ),
      ));

      final textSpan = _getTextSpan(tester);
      final worldSpan = textSpan.textSpanWithText('World');

      expect(worldSpan.style?.color, Colors.red);
    });

    testWidgets('applies multiple rich styles by index',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: FlexibleText(
            text: '#Hello# #World#',
            richStyles: [
              TextStyle(color: Colors.red),
              TextStyle(color: Colors.blue),
            ],
          ),
        ),
      ));

      final textSpan = _getTextSpan(tester);
      final helloSpan = textSpan.textSpanWithText('Hello');
      final worldSpan = textSpan.textSpanWithText('World');

      expect(helloSpan.style?.color, Colors.red);
      expect(worldSpan.style?.color, Colors.blue);
    });

    testWidgets('handles malformed rich text (no closing separator)',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: FlexibleText(
            text: 'Hello #World',
            richStyles: [TextStyle(color: Colors.red)],
          ),
        ),
      ));

      final textSpan = _getTextSpan(tester);
      final helloSpan = textSpan.textSpanWithText('Hello ');
      final worldSpan = textSpan.textSpanWithText('#World');

      // Malformed separator means no style applied
      expect(helloSpan.style, worldSpan.style);
    });
  });

  // ─── Style Inheritance / Merge ─────────────────────────────────

  group('Style inheritance', () {
    testWidgets('rich style merges with base style',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: FlexibleText(
            text: 'Hello #World#',
            style: TextStyle(fontSize: 20),
            richStyles: [TextStyle(color: Colors.red)],
          ),
        ),
      ));

      final textSpan = _getTextSpan(tester);
      final worldSpan = textSpan.textSpanWithText('World');

      // Should have both: fontSize from base + color from rich
      expect(worldSpan.style?.color, Colors.red);
      expect(worldSpan.style?.fontSize, 20);
    });

    testWidgets('rich style overrides conflicting base properties',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: FlexibleText(
            text: 'Hello #World#',
            style: TextStyle(color: Colors.black, fontSize: 16),
            richStyles: [TextStyle(color: Colors.red)],
          ),
        ),
      ));

      final textSpan = _getTextSpan(tester);
      final worldSpan = textSpan.textSpanWithText('World');

      // Rich color wins over base color
      expect(worldSpan.style?.color, Colors.red);
      // Base fontSize preserved
      expect(worldSpan.style?.fontSize, 16);
    });

    testWidgets('plain segments inherit base style from parent',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: FlexibleText(
            text: 'Hello #World#',
            style: TextStyle(fontSize: 20),
            richStyles: [TextStyle(color: Colors.red)],
          ),
        ),
      ));

      final textSpan = _getTextSpan(tester);
      final helloSpan = textSpan.textSpanWithText('Hello ');

      // Plain text blocks have null style, inheriting from parent
      expect(helloSpan.style, isNull);
      // Parent TextSpan carries the base style
      expect(textSpan.style?.fontSize, 20);
    });

    testWidgets('rich style works without base style',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: FlexibleText(
            text: 'Hello #World#',
            richStyles: [TextStyle(color: Colors.red)],
          ),
        ),
      ));

      final textSpan = _getTextSpan(tester);
      final worldSpan = textSpan.textSpanWithText('World');

      expect(worldSpan.style?.color, Colors.red);
    });
  });

  // ─── Named Rich Styles ─────────────────────────────────────────

  group('Named rich styles', () {
    testWidgets('applies named style to segment', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: FlexibleText(
            text: 'Hello #bold:World#',
            namedRichStyles: {'bold': TextStyle(fontWeight: FontWeight.bold)},
          ),
        ),
      ));

      final textSpan = _getTextSpan(tester);
      final worldSpan = textSpan.textSpanWithText('World');

      expect(worldSpan.style?.fontWeight, FontWeight.bold);
    });

    testWidgets('named style merges with base style',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: FlexibleText(
            text: '#bold:World#',
            style: TextStyle(fontSize: 20),
            namedRichStyles: {'bold': TextStyle(fontWeight: FontWeight.bold)},
          ),
        ),
      ));

      final textSpan = _getTextSpan(tester);
      final worldSpan = textSpan.textSpanWithText('World');

      expect(worldSpan.style?.fontWeight, FontWeight.bold);
      expect(worldSpan.style?.fontSize, 20);
    });

    testWidgets('multiple named styles in one text',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: FlexibleText(
            text: '#bold:Hello# #italic:World#',
            namedRichStyles: {
              'bold': TextStyle(fontWeight: FontWeight.bold),
              'italic': TextStyle(fontStyle: FontStyle.italic),
            },
          ),
        ),
      ));

      final textSpan = _getTextSpan(tester);
      final helloSpan = textSpan.textSpanWithText('Hello');
      final worldSpan = textSpan.textSpanWithText('World');

      expect(helloSpan.style?.fontWeight, FontWeight.bold);
      expect(worldSpan.style?.fontStyle, FontStyle.italic);
    });

    testWidgets('unknown name falls through to index-based style',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: FlexibleText(
            text: '#unknown:Hello#',
            richStyles: [TextStyle(color: Colors.green)],
            namedRichStyles: {'bold': TextStyle(fontWeight: FontWeight.bold)},
          ),
        ),
      ));

      final textSpan = _getTextSpan(tester);
      // When name not found, the full text "unknown:Hello" is the display text
      // and index-based style is applied
      final span = textSpan.textSpanWithText('unknown:Hello');
      expect(span.style?.color, Colors.green);
    });

    testWidgets('named style does not consume index-based style slot',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: FlexibleText(
            text: '#bold:Hello# #World#',
            richStyles: [TextStyle(color: Colors.blue)],
            namedRichStyles: {'bold': TextStyle(fontWeight: FontWeight.bold)},
          ),
        ),
      ));

      final textSpan = _getTextSpan(tester);
      final helloSpan = textSpan.textSpanWithText('Hello');
      final worldSpan = textSpan.textSpanWithText('World');

      expect(helloSpan.style?.fontWeight, FontWeight.bold);
      // Index-based style should still be available for "World"
      expect(worldSpan.style?.color, Colors.blue);
    });

    testWidgets('colon in text without namedRichStyles renders literally',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: FlexibleText(
            text: '#time:12:30#',
            richStyles: [TextStyle(color: Colors.red)],
          ),
        ),
      ));

      final textSpan = _getTextSpan(tester);
      // No named style matched, so full text is displayed
      final span = textSpan.textSpanWithText('time:12:30');
      expect(span.style?.color, Colors.red);
    });

    testWidgets('mix of named and index-based styles',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: FlexibleText(
            text: '#bold:Hello# normal #World#',
            richStyles: [TextStyle(color: Colors.green)],
            namedRichStyles: {'bold': TextStyle(fontWeight: FontWeight.bold)},
          ),
        ),
      ));

      final textSpan = _getTextSpan(tester);
      final helloSpan = textSpan.textSpanWithText('Hello');
      final worldSpan = textSpan.textSpanWithText('World');

      expect(helloSpan.style?.fontWeight, FontWeight.bold);
      expect(worldSpan.style?.color, Colors.green);
    });
  });

  // ─── Widget Rendering ──────────────────────────────────────────

  group('Widget rendering', () {
    testWidgets('renders widget by index', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: FlexibleText(
            text: 'Hello ~1~',
            widgets: [Icon(Icons.star)],
          ),
        ),
      ));

      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('renders named widget', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: FlexibleText(
            text: 'Hello ~star~',
            namedWidgets: {'star': Icon(Icons.star)},
          ),
        ),
      ));

      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('handles out-of-bounds widget index gracefully',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: FlexibleText(
            text: 'Hello ~2~',
            widgets: [Icon(Icons.star)],
          ),
        ),
      ));

      expect(find.byIcon(Icons.star), findsNothing);
    });

    testWidgets('widget index 0 does not match any widget',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: FlexibleText(
            text: 'Hello ~0~',
            widgets: [Icon(Icons.star)],
          ),
        ),
      ));

      // Index 0 is invalid (1-based), renders as plain text
      expect(find.byIcon(Icons.star), findsNothing);
    });

    testWidgets('multiple widgets by index', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: FlexibleText(
            text: '~1~ and ~2~',
            widgets: [Icon(Icons.star), Icon(Icons.favorite)],
          ),
        ),
      ));

      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });
  });

  // ─── Widget Alignment ──────────────────────────────────────────

  group('Widget alignment', () {
    testWidgets('forwards widgetAlignment to WidgetSpan',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: FlexibleText(
            text: 'Hello ~1~',
            widgets: [Icon(Icons.star)],
            widgetAlignment: PlaceholderAlignment.top,
          ),
        ),
      ));

      final textWidget = tester.widget<Text>(find.byType(Text));
      final textSpan = textWidget.textSpan! as TextSpan;
      final widgetSpan = textSpan.widgetSpanChildren.first;

      expect(widgetSpan.alignment, PlaceholderAlignment.top);
    });

    testWidgets('defaults to middle alignment', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: FlexibleText(
            text: 'Hello ~1~',
            widgets: [Icon(Icons.star)],
          ),
        ),
      ));

      final textWidget = tester.widget<Text>(find.byType(Text));
      final textSpan = textWidget.textSpan! as TextSpan;
      final widgetSpan = textSpan.widgetSpanChildren.first;

      expect(widgetSpan.alignment, PlaceholderAlignment.middle);
    });
  });

  // ─── Gesture Recognizers ───────────────────────────────────────

  group('Gesture recognizers', () {
    testWidgets('tap recognizer fires on rich text',
        (WidgetTester tester) async {
      bool tapped = false;
      final recognizer = TapGestureRecognizer()..onTap = () => tapped = true;

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: FlexibleText(
            text: 'Click #here#',
            richStyles: [TextStyle(color: Colors.red)],
            textRecognizers: [recognizer],
          ),
        ),
      ));

      final textSpan = _getTextSpan(tester);
      final hereSpan = textSpan.textSpanWithText('here');
      (hereSpan.recognizer as TapGestureRecognizer).onTap!();

      expect(tapped, true);
    });

    testWidgets('multiple recognizers for multiple segments',
        (WidgetTester tester) async {
      int tapCount = 0;
      final recognizer1 = TapGestureRecognizer()..onTap = () => tapCount += 1;
      final recognizer2 = TapGestureRecognizer()..onTap = () => tapCount += 10;

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: FlexibleText(
            text: '#First# and #Second#',
            richStyles: [
              TextStyle(color: Colors.red),
              TextStyle(color: Colors.blue),
            ],
            textRecognizers: [recognizer1, recognizer2],
          ),
        ),
      ));

      final textSpan = _getTextSpan(tester);
      (textSpan.textSpanWithText('First').recognizer as TapGestureRecognizer)
          .onTap!();
      (textSpan.textSpanWithText('Second').recognizer as TapGestureRecognizer)
          .onTap!();

      expect(tapCount, 11);
    });
  });

  // ─── onTapCallbacks ────────────────────────────────────────────

  group('onTapCallbacks', () {
    testWidgets('creates TapGestureRecognizer from callback',
        (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: FlexibleText(
            text: 'Click #here#',
            richStyles: [TextStyle(color: Colors.blue)],
            onTapCallbacks: [() => tapped = true],
          ),
        ),
      ));

      final textSpan = _getTextSpan(tester);
      final hereSpan = textSpan.textSpanWithText('here');

      expect(hereSpan.recognizer, isA<TapGestureRecognizer>());
      (hereSpan.recognizer as TapGestureRecognizer).onTap!();
      expect(tapped, true);
    });

    testWidgets('null callback at index attaches no recognizer',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: FlexibleText(
            text: '#First# #Second#',
            richStyles: [
              TextStyle(color: Colors.red),
              TextStyle(color: Colors.blue),
            ],
            onTapCallbacks: [null, () {}],
          ),
        ),
      ));

      final textSpan = _getTextSpan(tester);
      final firstSpan = textSpan.textSpanWithText('First');
      final secondSpan = textSpan.textSpanWithText('Second');

      expect(firstSpan.recognizer, isNull);
      expect(secondSpan.recognizer, isA<TapGestureRecognizer>());
    });

    testWidgets('textRecognizers takes precedence over onTapCallbacks',
        (WidgetTester tester) async {
      int result = 0;
      final explicitRecognizer = TapGestureRecognizer()
        ..onTap = () => result = 1;

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: FlexibleText(
            text: 'Click #here#',
            richStyles: [TextStyle(color: Colors.red)],
            textRecognizers: [explicitRecognizer],
            onTapCallbacks: [() => result = 2],
          ),
        ),
      ));

      final textSpan = _getTextSpan(tester);
      final hereSpan = textSpan.textSpanWithText('here');
      (hereSpan.recognizer as TapGestureRecognizer).onTap!();

      // textRecognizers wins, so result should be 1
      expect(result, 1);
    });

    testWidgets('multiple onTapCallbacks for multiple segments',
        (WidgetTester tester) async {
      List<String> taps = [];

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: FlexibleText(
            text: '#A# #B# #C#',
            richStyles: [
              TextStyle(color: Colors.red),
              TextStyle(color: Colors.green),
              TextStyle(color: Colors.blue),
            ],
            onTapCallbacks: [
              () => taps.add('A'),
              () => taps.add('B'),
              () => taps.add('C'),
            ],
          ),
        ),
      ));

      final textSpan = _getTextSpan(tester);
      (textSpan.textSpanWithText('A').recognizer as TapGestureRecognizer)
          .onTap!();
      (textSpan.textSpanWithText('C').recognizer as TapGestureRecognizer)
          .onTap!();

      expect(taps, ['A', 'C']);
    });
  });

  // ─── Pass-through Properties ───────────────────────────────────

  group('Pass-through properties', () {
    testWidgets('forwards maxLines to Text.rich', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: FlexibleText(text: 'Hello world', maxLines: 2),
        ),
      ));

      final textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.maxLines, 2);
    });

    testWidgets('forwards textDirection to Text.rich',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: FlexibleText(
            text: 'Hello world',
            textDirection: TextDirection.rtl,
          ),
        ),
      ));

      final textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.textDirection, TextDirection.rtl);
    });

    testWidgets('forwards textScaler to Text.rich',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: FlexibleText(
            text: 'Hello world',
            textScaler: TextScaler.linear(1.5),
          ),
        ),
      ));

      final textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.textScaler, TextScaler.linear(1.5));
    });

    testWidgets('forwards strutStyle to Text.rich',
        (WidgetTester tester) async {
      const strut = StrutStyle(fontSize: 20, height: 1.5);
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: FlexibleText(text: 'Hello world', strutStyle: strut),
        ),
      ));

      final textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.strutStyle, strut);
    });

    testWidgets('forwards locale to Text.rich', (WidgetTester tester) async {
      const loc = Locale('ja', 'JP');
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: FlexibleText(text: 'Hello world', locale: loc),
        ),
      ));

      final textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.locale, loc);
    });

    testWidgets('forwards softWrap to Text.rich', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: FlexibleText(text: 'Hello world', softWrap: false),
        ),
      ));

      final textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.softWrap, false);
    });

    testWidgets('forwards semanticsLabel to Text.rich',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: FlexibleText(
            text: 'Hello world',
            semanticsLabel: 'Greeting text',
          ),
        ),
      ));

      final textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.semanticsLabel, 'Greeting text');
    });

    testWidgets('forwards selectionColor to Text.rich',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: FlexibleText(
            text: 'Hello world',
            selectionColor: Colors.yellow,
          ),
        ),
      ));

      final textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.selectionColor, Colors.yellow);
    });

    testWidgets('forwards textAlign to Text.rich', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: FlexibleText(
            text: 'Hello world',
            textAlign: TextAlign.center,
          ),
        ),
      ));

      final textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.textAlign, TextAlign.center);
    });

    testWidgets('forwards overflow to Text.rich', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: FlexibleText(
            text: 'This is a very long text that should overflow',
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ));

      final textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.overflow, TextOverflow.ellipsis);
    });
  });

  // ─── Custom Separators ─────────────────────────────────────────

  group('Custom separators', () {
    testWidgets('supports custom rich text separator',
        (WidgetTester tester) async {
      for (var separator in ['*', ',', '&']) {
        final text = 'Hello ${separator}World$separator #HelloWorld#';

        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: FlexibleText(
              text: text,
              richStyles: [TextStyle(color: Colors.red)],
              richTextSeparator: separator,
            ),
          ),
        ));

        final textSpan = _getTextSpan(tester);
        expect(textSpan.countTextSpansWithText('Hello '), equals(1));
        expect(textSpan.countTextSpansWithText('World'), equals(1));
        expect(textSpan.countTextSpansWithText(' #HelloWorld#'), equals(1));
      }
    });

    testWidgets('separator collision throws assertion',
        (WidgetTester tester) async {
      expect(
        () => FlexibleText(
            text: 'Hello', richTextSeparator: '#', widgetSeparator: '#'),
        throwsAssertionError,
      );
    });

    testWidgets('separator must be single character',
        (WidgetTester tester) async {
      expect(
        () => FlexibleText(text: 'Hello', richTextSeparator: '##'),
        throwsAssertionError,
      );
      expect(
        () => FlexibleText(text: 'Hello', widgetSeparator: '~~'),
        throwsAssertionError,
      );
    });
  });

  // ─── Mixed Segments ────────────────────────────────────────────

  group('Mixed segments', () {
    testWidgets('renders mix of rich text and widgets',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: FlexibleText(
            text: 'Hello #World# ~1~',
            style: TextStyle(color: Colors.black),
            richStyles: [TextStyle(color: Colors.red)],
            widgets: [Icon(Icons.star)],
          ),
        ),
      ));

      final textSpan = _getTextSpan(tester);
      expect(textSpan.countTextSpansWithText('Hello '), equals(1));
      expect(textSpan.countTextSpansWithText('World'), equals(1));
      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('renders named widgets and rich text together',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: FlexibleText(
            text: '#bold:Click# ~star~ for #italic:more#',
            namedRichStyles: {
              'bold': TextStyle(fontWeight: FontWeight.bold),
              'italic': TextStyle(fontStyle: FontStyle.italic),
            },
            namedWidgets: {'star': Icon(Icons.star)},
          ),
        ),
      ));

      final textSpan = _getTextSpan(tester);
      expect(textSpan.textSpanWithText('Click').style?.fontWeight,
          FontWeight.bold);
      expect(
          textSpan.textSpanWithText('more').style?.fontStyle, FontStyle.italic);
      expect(find.byIcon(Icons.star), findsOneWidget);
    });
  });

  // ─── Edge Cases ────────────────────────────────────────────────

  group('Edge cases', () {
    testWidgets('consecutive rich segments', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: FlexibleText(
            text: '#Hello##World#',
            richStyles: [
              TextStyle(color: Colors.red),
              TextStyle(color: Colors.blue),
            ],
          ),
        ),
      ));

      final textSpan = _getTextSpan(tester);
      final helloSpan = textSpan.textSpanWithText('Hello');
      final worldSpan = textSpan.textSpanWithText('World');

      expect(helloSpan.style?.color, Colors.red);
      expect(worldSpan.style?.color, Colors.blue);
    });

    testWidgets('adjacent empty separators handled gracefully',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: FlexibleText(text: '##'),
        ),
      ));

      // Should not throw; renders empty rich text block
      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('whitespace-only rich text', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: FlexibleText(
            text: '# #',
            richStyles: [TextStyle(color: Colors.red)],
          ),
        ),
      ));

      final textSpan = _getTextSpan(tester);
      final spaceSpan = textSpan.textSpanWithText(' ');
      expect(spaceSpan.style?.color, Colors.red);
    });

    testWidgets('unicode and emoji in text', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: FlexibleText(
            text: 'Hello #World# 🌍',
            richStyles: [TextStyle(color: Colors.blue)],
          ),
        ),
      ));

      final textSpan = _getTextSpan(tester);
      expect(textSpan.countTextSpansWithText('World'), equals(1));
    });

    testWidgets('very long text renders without error',
        (WidgetTester tester) async {
      final longText = 'Hello ' * 1000 + '#World#';

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: FlexibleText(
              text: longText,
              richStyles: [TextStyle(color: Colors.red)],
            ),
          ),
        ),
      ));

      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('negative-looking widget index renders as text',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: FlexibleText(
            text: 'Hello ~-1~',
            widgets: [Icon(Icons.star)],
          ),
        ),
      ));

      // -1 is parsed as int but is <= 0, so not a valid index
      expect(find.byIcon(Icons.star), findsNothing);
    });

    testWidgets('malformed widget separator (no closing)',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: FlexibleText(text: 'Hello ~1'),
        ),
      ));

      // Should render without error, ~ treated as text
      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('only separators renders gracefully',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: FlexibleText(text: '####'),
        ),
      ));

      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('text with only widget separators',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: FlexibleText(text: '~~~~'),
        ),
      ));

      expect(find.byType(Text), findsOneWidget);
    });
  });
}
