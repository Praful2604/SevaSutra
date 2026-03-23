import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Help & Support — FAQs, tips, and contact placeholders.
/// Replace [kSupportEmail] and [kSupportPhone] with your real details.
class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  static const String kSupportEmail = 'support@sevasutra.example.com';
  static const String kSupportPhone = '+91 8087614598';
  static const String kAppVersion = '1.0.0';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'How can we help?',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Find answers below or reach out to our team.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 20),

            _SectionCard(
              icon: Icons.lightbulb_outline,
              title: 'Quick tips',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _bullet(
                    'Complete all survey steps before tapping Submit so data saves to your device.',
                  ),
                  _bullet(
                    'Use View Data on the Surveys screen to see records saved locally.',
                  ),
                  _bullet(
                    'If data does not appear, wait for the success message after Submit, then open View Data again.',
                  ),
                  _bullet(
                    'Sync when you have a stable internet connection.',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),
            _SectionCard(
              icon: Icons.quiz_outlined,
              title: 'Frequently asked questions',
              child: Column(
                children: [
                  _FaqTile(
                    question: 'Where is my survey data stored?',
                    answer:
                        'Survey entries are stored on this device using the local database (Isar). They stay on your phone until you sync or export as your app supports.',
                  ),
                  const Divider(height: 1),
                  _FaqTile(
                    question: 'Why do I see “No data found”?',
                    answer:
                        'The list loads saved records. Make sure you tapped Submit on the last step and saw “Data Saved Successfully” before opening View Data. If you left the screen very quickly, try opening View Data again.',
                  ),
                  const Divider(height: 1),
                  _FaqTile(
                    question: 'How do I change my profile or theme?',
                    answer:
                        'Open the menu and use Profile or Settings.',
                  ),
                  const Divider(height: 1),
                  _FaqTile(
                    question: 'How do I log out?',
                    answer:
                        'Open the menu and tap Logout at the bottom.',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),
            _SectionCard(
              icon: Icons.contact_support_outlined,
              title: 'Contact us',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Email',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  SelectableText(
                    kSupportEmail,
                    style: TextStyle(color: Colors.green.shade800),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () async {
                        await Clipboard.setData(
                          const ClipboardData(text: kSupportEmail),
                        );
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Email copied to clipboard'),
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.copy, size: 18),
                      label: const Text('Copy email'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Phone',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  SelectableText(kSupportPhone),
                ],
              ),
            ),

            const SizedBox(height: 16),
            Center(
              child: Text(
                'SevaSutra • v$kAppVersion',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  static Widget _bullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 18, height: 1.2)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.icon,
    required this.title,
    required this.child,
  });

  final IconData icon;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.green.shade700),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _FaqTile extends StatefulWidget {
  const _FaqTile({
    required this.question,
    required this.answer,
  });

  final String question;
  final String answer;

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    widget.question,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Icon(
                  _expanded ? Icons.expand_less : Icons.expand_more,
                  color: Colors.grey,
                ),
              ],
            ),
            if (_expanded) ...[
              const SizedBox(height: 8),
              Text(
                widget.answer,
                style: TextStyle(
                  color: Colors.grey[800],
                  height: 1.4,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
