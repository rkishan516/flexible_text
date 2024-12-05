# FlexibleText

FlexibleText is a Flutter widget that allows you to seamlessly mix and match rich text segments and widgets within a single text block. Customize your text with different styles and gestures, and insert inline widgets using simple placeholders. This powerful and flexible solution makes it easy to create dynamic, interactive, and visually appealing text in your Flutter applications.

<a href="https://pub.dev/packages/flexible_text" target="_blank">
    <img src="https://img.shields.io/pub/v/flexible_text.svg?style=for-the-badge&label=pub&logo=dart"/> 
</a>
<a href="https://github.com/rkishan516/flexible_text/tree/main/LICENSE" target="_blank">
  <img src="https://img.shields.io/github/license/rkishan516/flexible_text.svg?style=for-the-badge&color=purple"/> 
</a>
<a href="https://github.com/rkishan516/flexible_text/stargazers" target="_blank">
  <img src="https://img.shields.io/github/stars/rkishan516/flexible_text.svg?style=for-the-badge&label=GitHub Stars&color=gold"/>
</a>
<br/>
<a href="https://pub.dev/packages/flexible_text/score" target="_blank">
  <img src="https://img.shields.io/pub/likes/flexible_text.svg?style=for-the-badge&color=1e7b34&label=likes&labelColor=black"/>
  <img src="https://img.shields.io/pub/points/flexible_text?style=for-the-badge&color=0056b3&label=Points&labelColor=black"/>
  <img src="https://img.shields.io/pub/popularity/flexible_text.svg?style=for-the-badge&color=c05600&label=Popularity&labelColor=black"/>
</a>

### Features

- Rich Text Segments: Use different styles and gestures for various parts of your text.
- Inline Widgets: Easily insert widgets such as icons, images, or any other widget into your text.
- Customizable Separators: Define your own separators for rich text and widget placeholders.
- Text Alignment: Control how the text is aligned horizontally.
- Overflow Handling: Specify how visual overflow should be managed.

### Getting Started 🚀

#### Installation 🧑‍💻

```yaml
dependencies:
  flexible_text: ^latest_version
```

Import the Package

```dart
import 'package:flexible_text/flexible_text.dart';
```

#### Usage 📝

```dart
FlexibleText(
  text: 'Hello #World#~1~~star~',
  style: TextStyle(color: Colors.black),
  richStyles: [TextStyle(color: Colors.red)],
  textRecognizers: [TapGestureRecognizer()..onTap = () { print('World tapped'); }],
  namedWidgets: {'star': Icon(Icons.star_border)},
  widgets: [Icon(Icons.star)],
);
```

In this example:

- #World# will be styled with TextStyle(color: Colors.red) and will have a tap gesture.
- \~1\~ will be replaced by an Icon(Icons.star).
- \~star\~ will be replaced by an Icon(Icons.star_border).

and result to

$${\color{black}Hello \space \color{red}World \space \color{black}★☆}$$

#### Customization Options 🎨

- text: The text to display, with placeholders for rich text and widgets.
- style: The default text style.
- richStyles: A list of styles for rich text segments.
- textRecognizers: A list of gesture recognizers for rich text segments.
- textAlign: The alignment of the text.
- overflow: How to handle text overflow.
- widgetAlignment: The alignment of inline widgets.
- widgets: A list of widgets to be inserted into the text.
- namedWidgets: A map of named widgets to be inserted into the text.
- richTextSeparator: The character used to separate rich text segments.
- widgetSeparator: The character used to separate widget placeholders.

### Contributing 👨

Contributions are welcome! Please feel free to submit a pull request or open an issue to improve the package.
