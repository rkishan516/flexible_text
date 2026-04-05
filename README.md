# FlexibleText

FlexibleText is a Flutter widget that allows you to seamlessly mix and match rich text segments and widgets within a single text block. Customize your text with different styles and gestures, and insert inline widgets using simple placeholders. This powerful and flexible solution makes it easy to create dynamic, interactive, and visually appealing text in your Flutter applications.

[![codecov](https://codecov.io/github/rkishan516/flexible_text/graph/badge.svg?token=BNO884O5HM)](https://codecov.io/github/rkishan516/flexible_text)

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

![title](https://raw.githubusercontent.com/rkishan516/flexible_text/refs/heads/main/assets/usage.webp)


### Features

- Rich Text Segments: Use different styles and gestures for various parts of your text.
- Inline Widgets: Easily insert widgets such as icons, images, or any other widget into your text.
- Customizable Separators: Define your own separators for rich text and widget placeholders.
- Named Rich Styles: Apply styles by name using `#name:text#` syntax for readable, maintainable templates.
- Style Inheritance: Rich styles automatically merge with the base style, so you only override what changes.
- Tap Callbacks: Simple `onTapCallbacks` list as a convenience alternative to manual `TapGestureRecognizer` creation.
- Full Text.rich Support: All standard `Text` properties including `maxLines`, `textDirection`, `textScaler`, `softWrap`, `locale`, `strutStyle`, `semanticsLabel`, and `selectionColor`.
- Debug Warnings: Helpful debug-mode messages when widget indices are out of bounds or named widgets are missing.

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


#### Customization Options 🎨

| Category       | Option              | Description                                                                   |
|----------------|---------------------|-------------------------------------------------------------------------------|
| **Text**       | `text`              | The base text, including placeholders for rich text and widgets.              |
|                | `style`             | Default styling applied to the text. Rich styles merge on top of this.       |
|                | `textAlign`         | Alignment of the text (e.g., left, center, right).                            |
|                | `overflow`          | Handling of text overflow (e.g., ellipsis, clip, wrap).                       |
|                | `maxLines`          | Maximum number of lines for the text to span.                                 |
|                | `textDirection`     | Directionality of the text (LTR or RTL).                                      |
|                | `textScaler`        | Font scaling strategy for accessibility.                                      |
|                | `strutStyle`        | Strut style for consistent line heights.                                      |
|                | `locale`            | Locale for font selection when characters render differently.                 |
|                | `softWrap`          | Whether the text should break at soft line breaks.                            |
|                | `semanticsLabel`    | Alternative semantics label for accessibility.                                |
|                | `selectionColor`    | Color for painting the selection highlight.                                   |
| **Rich Text**  | `richStyles`        | Styles applied to rich text segments by index. Merged with base `style`.     |
|                | `namedRichStyles`   | Map of named styles; use `#name:text#` syntax in the text.                   |
|                | `textRecognizers`   | Gesture recognizers (e.g., tap, long-press) for rich text segments.           |
|                | `onTapCallbacks`    | Simple tap callbacks; auto-wrapped in `TapGestureRecognizer`.                |
|                | `richTextSeparator` | Character used to delimit rich text sections within the main text.            |
| **Widgets**    | `widgets`           | List of widgets embedded in the text.                                         |
|                | `namedWidgets`      | Map of named widgets for insertion into the text.                             |
|                | `widgetAlignment`   | Alignment of inline widgets within the text flow.                             |
|                | `widgetSeparator`   | Character used to mark widget placeholder positions in the text.              |

#### Named Rich Styles

Use `#name:text#` syntax to apply styles by name instead of index:

```dart
FlexibleText(
  text: 'This is #bold:important# and #link:click here#',
  style: TextStyle(fontSize: 16),
  namedRichStyles: {
    'bold': TextStyle(fontWeight: FontWeight.bold),
    'link': TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
  },
)
```

#### Tap Callbacks

Use `onTapCallbacks` as a simpler alternative to `textRecognizers`:

```dart
FlexibleText(
  text: 'Click #here# or #there#',
  richStyles: [TextStyle(color: Colors.blue), TextStyle(color: Colors.blue)],
  onTapCallbacks: [
    () => print('here tapped'),
    () => print('there tapped'),
  ],
)


### Contributing 👨

Contributions are welcome! Please feel free to submit a pull request or open an issue to improve the package.
