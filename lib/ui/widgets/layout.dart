import 'package:flutter/material.dart';

class BasicLayout extends StatelessWidget {
  const BasicLayout({
    super.key,
    required this.title,
    this.description,
    this.loading = false,
    this.action,
    this.secondaryAction,
  });

  final String title;
  final String? description;
  final bool loading;
  final BasicLayoutAction? action;
  final BasicLayoutAction? secondaryAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .stretch,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        if (description case var description?) ...[
          SizedBox(height: 4),
          Text(description, style: Theme.of(context).textTheme.bodyLarge),
        ],
        if (loading) ...[
          SizedBox(height: 16),
          Center(child: CircularProgressIndicator()),
        ] else ...[
          if (action != null || secondaryAction != null) ...[Spacer(), SizedBox(height: 12)],
          if (action case BasicLayoutAction(:var label, :var onPressed)) ...[
            SizedBox(height: 12),
            ElevatedButton(onPressed: onPressed, child: Text(label)),
          ],
          if (secondaryAction case BasicLayoutAction(:var label, :var onPressed)) ...[
            SizedBox(height: 12),
            OutlinedButton(onPressed: onPressed, child: Text(label)),
          ],
        ],
      ],
    );
  }
}

class BasicLayoutAction {
  BasicLayoutAction({required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;
}
