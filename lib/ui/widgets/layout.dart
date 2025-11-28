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
      crossAxisAlignment: .center,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        if (description case var description?) ...[SizedBox(height: 4), Text(description)],
        if (loading) ...[
          SizedBox(height: 16),
          CircularProgressIndicator(),
        ] else ...[
          if (action != null || secondaryAction != null) SizedBox(height: 4),
          if (action case BasicLayoutAction(:var label, :var onPressed)) ...[
            SizedBox(height: 4),
            ElevatedButton(onPressed: onPressed, child: Text(label)),
          ],
          if (secondaryAction case BasicLayoutAction(:var label, :var onPressed)) ...[
            SizedBox(height: 4),
            TextButton(onPressed: onPressed, child: Text(label)),
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
