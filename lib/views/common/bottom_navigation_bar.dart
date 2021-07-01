import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../services/notification/notification_service.dart';
import 'badge_icon.dart';
import '../../models/bottom_nav_entry.dart';
import '../../services/navigation_service.dart';
import '../../services/service_locator.dart';

class McaBottomNav extends HookWidget {
  @override
  Widget build(BuildContext context) {
    var notificationSvc = sl.get<NotificationService>();
    var notificationCount =
        (useStream(notificationSvc.getNotifications()).data ?? []).length;

    var navSvc = sl.get<NavigationService>();

    var currentNav =
        useStream(navSvc.currentNav).data ?? BottomNavEntry.todaysStops;

    // Todo, not robust for multi tab
    var idx = currentNav == BottomNavEntry.todaysStops ? 0 : 1;

    return BottomNavigationBar(
        currentIndex: idx, // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: "Today",
          ),
          BottomNavigationBarItem(
            icon: BadgeIcon(
                icon: Icon(Icons.notifications), badgeCount: notificationCount),
            label: 'Notifications',
          ),
        ],
        onTap: (idx) {
          switch (idx) {
            case 0:
              navSvc.handleTabChange(BottomNavEntry.todaysStops);
              return;
            case 1:
              navSvc.handleTabChange(BottomNavEntry.notifications);
              return;
            default:
              return;
          }
        });
  }
}
