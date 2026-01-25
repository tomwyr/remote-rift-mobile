import 'package:flutter/material.dart';

import 'fit_viewport_scroll_view.dart';

class BasicLayout extends StatelessWidget {
  const BasicLayout({
    super.key,
    this.title,
    this.description,
    this.header,
    this.body,
    this.loading = false,
    this.action,
    this.secondaryAction,
  });

  final String? title;
  final String? description;
  final Widget? header;
  final Widget? body;
  final bool loading;
  final BasicLayoutAction? action;
  final BasicLayoutAction? secondaryAction;

  @override
  Widget build(BuildContext context) {
    return FitViewportScrollView(
      child: Column(
        crossAxisAlignment: .stretch,
        mainAxisAlignment: .spaceBetween,
        children: [_topContent(context), ?_bottomContent(context)],
      ),
    );
  }

  Widget _topContent(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        if (header case var header?) ...[header, SizedBox(height: 12)],
        if (title case var title?) Text(title, style: Theme.of(context).textTheme.headlineLarge),
        if (title != null || description != null) SizedBox(height: 4),
        if (description case var description?)
          Text(description, style: Theme.of(context).textTheme.bodyLarge),
        if (body case var body?) ...[SizedBox(height: 12), body],
      ],
    );
  }

  Widget? _bottomContent(BuildContext context) {
    final hasAction = action != null || secondaryAction != null;

    if (!loading && !hasAction) return null;

    return Column(
      crossAxisAlignment: .start,
      children: [
        SizedBox(height: 12),
        if (loading)
          Center(child: CircularProgressIndicator())
        else if (hasAction) ...[
          if (action case BasicLayoutAction(:var label, :var onPressed)) ...[
            SizedBox(height: 12),
            ElevatedButton(onPressed: onPressed, child: Text(label)),
          ],
          if (secondaryAction case BasicLayoutAction(:var label, :var onPressed)) ...[
            SizedBox(height: 12),
            OutlinedButton(onPressed: onPressed, child: Text(label)),
          ],
        ],
        SizedBox(height: 12),
      ],
    );
  }
}

class BasicLayoutAction {
  BasicLayoutAction({required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;
}
