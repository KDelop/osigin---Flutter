import 'package:flutter/material.dart';

// TODO, consider refactoring away in favor of DataStatusContainer
// search for circularprogressindicator usages too.
class LoadingContainer extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const LoadingContainer({@required this.isLoading, this.child});

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: Container(child: CircularProgressIndicator()));
    } else {
      return child;
    }
  }
}