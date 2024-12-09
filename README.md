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


#### Customization Options 🎨

| Category      | Option              | Description                                                         |
|---------------|---------------------|---------------------------------------------------------------------|
| **Text**      | `text`              | The base text, including placeholders for rich text and widgets.    |
|               | `style`             | Default styling applied to the text.                                |
|               | `textAlign`         | Alignment of the text (e.g., left, center, right).                  |
|               | `overflow`          | Handling of text overflow (e.g., ellipsis, clip, wrap).             |
| **Rich Text** | `richStyles`        | Styles applied to specific segments of rich text.                   |
|               | `textRecognizers`   | Gesture recognizers (e.g., tap, long-press) for rich text segments. |
|               | `richTextSeparator` | Character used to delimit rich text sections within the main text.  |
| **Widgets**   | `widgets`           | List of widgets embedded in the text.                               |
|               | `namedWidgets`      | Map of named widgets for insertion into the text.                   |
|               | `widgetAlignment`   | Alignment of inline widgets within the text flow.                   |
|               | `widgetSeparator`   | Character used to mark widget placeholder positions in the text.    |


### Contributing 👨

Contributions are welcome! Please feel free to submit a pull request or open an issue to improve the package.
