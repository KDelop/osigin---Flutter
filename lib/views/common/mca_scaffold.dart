import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'bottom_navigation_bar.dart';
import '../../services/navigation_service.dart';
import '../../services/service_locator.dart';

import 'mca_drawer.dart';

/// This serves as the frame for all views in the app.
class McaScaffold extends HookWidget {
  final Widget _child;
  final String _title;
  final bool _showDrawer;
  final bool _showBottomNav;
  final Widget _floatingActionButton;
  final FloatingActionButtonLocation floatingActionButtonLocation;

  McaScaffold(
      {Widget child,
      title = '',
      showDrawer = true,
      showBottomNav = false,
      floatingActionButton,
      this.floatingActionButtonLocation})
      : _child = child,
        _title = title,
        _showDrawer = showDrawer,
        _showBottomNav = showBottomNav,
        _floatingActionButton = floatingActionButton;

  Widget build(BuildContext context) {
    var navSvc = sl.get<NavigationService>();

    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        // Todo, consider removing and allowing material scaffold to take over
        leading: (!_showDrawer && navSvc.canPop())
            ? IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  sl.get<NavigationService>().pop();
                },
              )
            : null,
      ),
      drawer: _showDrawer ? McaDrawer() : null,
      floatingActionButton: _floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      // bottomNavigationBar: _showBottomNav ? McaBottomNav(): null,
      body: _child,
    );
  }
}
