import 'package:flutter/material.dart';

import 'fit_viewport_scroll_view.dart';

class BasicLayout extends StatelessWidget {
  const BasicLayout({
    super.key,
    this.title,
    this.description,
    this.body,
    this.loading = false,
    this.action,
    this.secondaryAction,
  }) : assert(
         title != null || description == null,
         'Description must not be provided unless the title is set.',
       );

  final String? title;
  final String? description;
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
        if (title case var title?)
          BasicLayoutSection(title: title, titleFontSize: .large, description: description),
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

enum BasicLayoutSectionFontSize { medium, large }

class BasicLayoutSection extends StatelessWidget {
  const BasicLayoutSection({
    super.key,
    this.label,
    required this.title,
    this.titleFontSize = .medium,
    this.description,
  });

  final String? label;
  final String title;
  final BasicLayoutSectionFontSize titleFontSize;
  final String? description;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: .start,
      children: [
        if (label case var label?)
          Text(label, style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: .w300)),
        Text(
          title,
          style: switch (titleFontSize) {
            .medium => textTheme.titleMedium,
            .large => textTheme.headlineMedium,
          },
        ),
        if (description case var description?) ...[
          SizedBox(height: 2),
          Text(description, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ],
    );
  }
}
