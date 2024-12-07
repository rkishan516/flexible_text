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
}

void main() {
  testWidgets('Basic rendering test', (WidgetTester tester) async {
    const text = 'Hello, world!';
    const widget = FlexibleText(
      text: text,
      style: TextStyle(color: Colors.black),
    );

    // Build the widget tree
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

    // Verify the text is rendered
    expect(find.text(text), findsOneWidget);
  });

  testWidgets('Renders rich text with style', (WidgetTester tester) async {
    const text = 'Hello #World#';
    const richStyles = [TextStyle(color: Colors.red)];

    // Build the widget tree
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: FlexibleText(
          text: text,
          style: TextStyle(color: Colors.black),
          richStyles: richStyles,
        ),
      ),
    ));

    // Find the Text widget that is rendering the rich text
    final textWidgetFinder = find.byType(Text);

    // Ensure that the Text widget is found
    expect(textWidgetFinder, findsOneWidget);

    // Get the actual Text widget rendered by FlexibleText
    final textWidget = tester.widget<Text>(textWidgetFinder);

    // Get the TextSpan from the Text widget (the widget's 'text' property)
    final textSpan = textWidget.textSpan as TextSpan?;

    // Check if the rich style is applied to the "World" portion of the text
    // TextSpan uses the TextStyle to apply the color to the appropriate portion
    final worldTextSpan = textSpan!.textSpanWithText('World');

    // Verify if the style for the "World" portion is red (as defined in richStyles)
    expect(worldTextSpan.style?.color, Colors.red);
  });

  testWidgets('Renders widgets by index', (WidgetTester tester) async {
    const text = 'Hello ~1~';
    const widgets = [Icon(Icons.star)];

    // Build the widget tree
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: FlexibleText(
          text: text,
          widgets: widgets,
        ),
      ),
    ));

    // Verify if the icon widget is rendered
    expect(find.byIcon(Icons.star), findsOneWidget);
  });

  testWidgets('Renders named widgets', (WidgetTester tester) async {
    const text = 'Hello ~star~';
    const widgets = {
      'star': Icon(Icons.star),
    };

    // Build the widget tree
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: FlexibleText(
          text: text,
          namedWidgets: widgets,
        ),
      ),
    ));

    // Verify if the icon widget is rendered
    expect(find.byIcon(Icons.star), findsOneWidget);
  });

  testWidgets('Handles empty text gracefully', (WidgetTester tester) async {
    const text = '';
    const widget = FlexibleText(
      text: text,
      style: TextStyle(color: Colors.black),
    );

    // Build the widget tree
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

    // Verify no text is rendered
    expect(find.text(''), findsOneWidget);
  });

  testWidgets('Handles malformed rich text', (WidgetTester tester) async {
    const text = 'Hello #World';
    const richStyles = [TextStyle(color: Colors.red)];

    // Build the widget tree
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: FlexibleText(
          text: text,
          richStyles: richStyles,
        ),
      ),
    ));

    // Find the Text widget that renders the rich text
    final textWidgetFinder = find.byType(Text);

    // Ensure the Text widget is found
    expect(textWidgetFinder, findsOneWidget);

    // Get the actual Text widget rendered by FlexibleText
    final textWidget = tester.widget<Text>(textWidgetFinder);

    // Get the TextSpan from the Text widget (the widget's 'text' property)
    final textSpan = textWidget.textSpan! as TextSpan?;

    // Check if the entire text (Hello World) is rendered in the default style
    // Since #World is malformed, it should use the default style i.e. same as hello.
    final helloTextSpan = textSpan!.textSpanWithText('Hello ');
    final worldTextSpan = textSpan.textSpanWithText('#World');

    // Verify if the style for the "World" portion is same as "Hello"
    expect(helloTextSpan.style, worldTextSpan.style);
  });

  testWidgets('Handles malformed widget placeholders',
      (WidgetTester tester) async {
    const text = 'Hello ~2~';
    const widgets = [Icon(Icons.star)];

    // Build the widget tree
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: FlexibleText(
          text: text,
          widgets: widgets,
        ),
      ),
    ));

    // Verify no widget is rendered due to malformed index
    expect(find.byIcon(Icons.star), findsNothing);
  });

  testWidgets('Handles gesture recognizers for rich text',
      (WidgetTester tester) async {
    const text = 'Click me #here#';

    // Set up a flag to check if the gesture is recognized
    bool tapped = false;

    // Create a gesture recognizer and set the action
    final recognizer = TapGestureRecognizer()
      ..onTap = () {
        tapped = true; // Set the flag to true when tapped
      };

    final richStyles = [TextStyle(color: Colors.red)];
    final textRecognizers = [recognizer];

    // Build the widget tree
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: FlexibleText(
          text: text,
          richStyles: richStyles,
          textRecognizers: textRecognizers,
        ),
      ),
    ));

    // Find the Text widget that renders the rich text
    final textWidgetFinder = find.byType(Text);

    // Ensure the Text widget is found
    expect(textWidgetFinder, findsOneWidget);

    // Get the actual Text widget rendered by FlexibleText
    final textWidget = tester.widget<Text>(textWidgetFinder);

    // Get the TextSpan from the Text widget (the widget's 'text' property)
    final textSpan = textWidget.textSpan! as TextSpan?;

    // Check if the entire text (Hello World) is rendered in the default style
    // Since #World is malformed, it should use the default style i.e. same as hello.
    final hereTextSpan = textSpan!.textSpanWithText('here');

    // Simulate a tap on the "here" text
    (hereTextSpan.recognizer as TapGestureRecognizer).onTap!();

    // Verify that the onTap handler was triggered
    expect(tapped, true);
  });

  testWidgets('Supports text overflow handling', (WidgetTester tester) async {
    const text = 'This is a very long text that should overflow';
    const widget = FlexibleText(
      text: text,
      overflow: TextOverflow.ellipsis,
    );

    await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

    final textWidget = tester.widget<Text>(find.text(text));
    expect(textWidget.overflow, TextOverflow.ellipsis);
  });

  testWidgets('Supports rich text sperator', (WidgetTester tester) async {
    final seperatorsVariety = ['*', ',', '&'];
    for (var seperator in seperatorsVariety) {
      final text = 'Hello ${seperator}World$seperator #HelloWorld#';
      const richStyles = [TextStyle(color: Colors.red)];

      // Build the widget tree
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: FlexibleText(
            text: text,
            richStyles: richStyles,
            richTextSeparator: seperator,
          ),
        ),
      ));

      // Find the Text widget that renders the rich text
      final textWidgetFinder = find.byType(Text);

      // Ensure the Text widget is found
      expect(textWidgetFinder, findsOneWidget);

      // Get the actual Text widget rendered by FlexibleText
      final textWidget = tester.widget<Text>(textWidgetFinder);

      // Get the TextSpan from the Text widget (the widget's 'text' property)
      final textSpan = textWidget.textSpan! as TextSpan?;

      // Check if the entire text (Hello World) is rendered in the default style
      // Since #World is malformed, it should use the default style i.e. same as hello.
      expect(textSpan!.countTextSpansWithText('Hello '), equals(1));
      expect(textSpan.countTextSpansWithText('World'), equals(1));
      expect(textSpan.countTextSpansWithText(' #HelloWorld#'), equals(1));
    }
  });

  testWidgets('Splits and renders multiple rich text and widget segments',
      (WidgetTester tester) async {
    const text = 'Hello #World# ~1~';
    const widgets = [Icon(Icons.star)];
    const richStyles = [TextStyle(color: Colors.red)];

    // Build the widget tree
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: FlexibleText(
          text: text,
          style: TextStyle(color: Colors.black),
          richStyles: richStyles,
          widgets: widgets,
        ),
      ),
    ));

    // Find the Text widget that renders the rich text
    final textWidgetFinder = find.byType(Text);

    // Ensure the Text widget is found
    expect(textWidgetFinder, findsOneWidget);

    // Get the actual Text widget rendered by FlexibleText
    final textWidget = tester.widget<Text>(textWidgetFinder);

    // Get the TextSpan from the Text widget (the widget's 'text' property)
    final textSpan = textWidget.textSpan! as TextSpan?;

    // Check if the entire text (Hello World) is rendered in the default style
    // Since #World is malformed, it should use the default style i.e. same as hello.
    expect(textSpan!.countTextSpansWithText('Hello '), equals(1));
    expect(textSpan.countTextSpansWithText('World'), equals(1));

    // Verify if the text segments are rendered correctly
    expect(find.byIcon(Icons.star), findsOneWidget);
  });
}
