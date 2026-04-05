import 'package:flexible_text/flexible_text.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: ExamplePage()));
}

class ExamplePage extends StatelessWidget {
  const ExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FlexibleText Examples')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Basic rich text with style inheritance
            FlexibleText(
              text: 'Hello #World# ~1~',
              style: const TextStyle(fontSize: 18, color: Colors.black),
              richStyles: const [TextStyle(color: Colors.red)],
              widgets: const [Icon(Icons.star, color: Colors.amber)],
            ),
            const SizedBox(height: 16),

            // Named rich styles
            FlexibleText(
              text: 'This is #bold:important# and #link:click here#',
              style: const TextStyle(fontSize: 16, color: Colors.black87),
              namedRichStyles: const {
                'bold': TextStyle(fontWeight: FontWeight.bold),
                'link': TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              },
            ),
            const SizedBox(height: 16),

            // onTap callbacks
            FlexibleText(
              text: 'Tap #here# or #there#',
              style: const TextStyle(fontSize: 16),
              richStyles: const [
                TextStyle(color: Colors.blue),
                TextStyle(color: Colors.green),
              ],
              onTapCallbacks: [
                () => debugPrint('here tapped'),
                () => debugPrint('there tapped'),
              ],
            ),
            const SizedBox(height: 16),

            // maxLines + overflow
            FlexibleText(
              text: 'This is a very long text that should be truncated '
                  'after two lines because we set maxLines to 2 and '
                  'overflow to ellipsis for demonstration purposes.',
              style: const TextStyle(fontSize: 16),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),

            // Named widgets + named styles
            FlexibleText(
              text: '#bold:Rate us# ~star~~star~~star~~star~~star~',
              style: const TextStyle(fontSize: 16),
              namedRichStyles: const {
                'bold': TextStyle(fontWeight: FontWeight.bold),
              },
              namedWidgets: const {
                'star': Icon(Icons.star, color: Colors.amber, size: 20),
              },
            ),
          ],
        ),
      ),
    );
  }
}
