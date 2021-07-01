import 'package:flutter/material.dart';
import 'mca_scaffold.dart';

/// This was used so that "Views" don't depend on a concrete scaffold class
/// Useful for unit tests and/or storyboard (storybook)
class ScaffoldBuilder {
  Widget build(
      {Widget child,
      String title = '',
      bool showDrawer = true,
      bool showBottomNav = false,
      Widget floatingActionButton,
      FloatingActionButtonLocation floatingActionButtonLocation}) {
    return McaScaffold(
      title: title,
      showDrawer: showDrawer,
      showBottomNav: showBottomNav,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      child: child
    );
  }
}