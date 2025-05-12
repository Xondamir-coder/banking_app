import 'package:banking_app/widgets/components/my_text.dart';
import 'package:flutter/material.dart';

class AsyncWidget<T> extends StatelessWidget {
  /// The future to be executed.
  final Future<T> future;

  /// A function that builds the widget when the future completes successfully.
  final Widget Function(BuildContext context, T data) builder;

  /// Optional widget to display while waiting.
  final Widget loadingWidget;

  /// Optional widget to display when an error occurs.
  final Widget Function(BuildContext context, Object error)? errorBuilder;

  const AsyncWidget({
    super.key,
    required this.future,
    required this.builder,
    this.loadingWidget =
        const Center(child: CircularProgressIndicator.adaptive()),
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loadingWidget;
        } else if (snapshot.hasError) {
          // If a custom error builder is provided, use it.
          if (errorBuilder != null) {
            return errorBuilder!(context, snapshot.error!);
          }
          // Otherwise, show a default error message.
          return Center(
            child: MyText(
              'Error',
              fontSize: 18,
            ),
          );
        } else if (snapshot.hasData) {
          return builder(context, snapshot.data as T);
        }
        // Fallback in case there's no data.
        return const SizedBox.shrink();
      },
    );
  }
}
