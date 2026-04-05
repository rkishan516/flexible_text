## 2.0.0

* feat: Add `namedRichStyles` with `#name:text#` syntax for named style support
* feat: Add `onTapCallbacks` convenience API for simple tap handling
* feat: Rich styles now merge with base `style` via `TextStyle.merge()`
* feat: Add pass-through properties: `maxLines`, `textDirection`, `textScaler`, `strutStyle`, `locale`, `softWrap`, `semanticsLabel`, `selectionColor`
* feat: Add debug-mode warnings for out-of-bounds widget indices and missing named widgets
* feat: Assert `richTextSeparator != widgetSeparator` to prevent separator collision
* fix: Recognizer and style indexing now uses sequential segment position
* test: Expand test suite from 13 to 53 tests

## 1.1.0+3

* docs: Update design to table for customization options

## 1.1.0+2

* chore: Update homepage link of pub to goflutter

## 1.1.0+1

* docs: Update usage image link for pub

## 1.1.0

* test: Add test cases
* feat: Mark default text style optional
* docs: Update usage with image

## 1.0.0

* feat: Update default richTextSperator to #
* fix: Update flutter lints to v5

## 0.1.0

* feat: Add namedWidgets

## 0.0.0+1

* docs: Update README

## 0.0.0

* chore: Create package