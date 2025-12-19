import 'package:flutter/material.dart';

class BasicLayout extends StatelessWidget {
  const BasicLayout({
    super.key,
    this.title,
    this.description,
    this.loading = false,
    this.action,
    this.secondaryAction,
  });

  final String? title;
  final String? description;
  final bool loading;
  final BasicLayoutAction? action;
  final BasicLayoutAction? secondaryAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .stretch,
      children: [
        if (title case var title?) Text(title, style: Theme.of(context).textTheme.titleLarge),
        if (title != null || description != null) SizedBox(height: 8),
        if (description case var description?)
          Text(description, style: Theme.of(context).textTheme.bodyLarge),
        if (loading) ...[
          Spacer(),
          SizedBox(height: 12),
          Center(child: CircularProgressIndicator()),
          SizedBox(height: 12),
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
          if (action != null || secondaryAction != null) SizedBox(height: 12),
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
