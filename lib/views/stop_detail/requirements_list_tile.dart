import 'package:flutter/material.dart';

import 'letter_circle_icon.dart';

class RequirementsListTile extends StatelessWidget {
  const RequirementsListTile(
      {@required this.requirements, Widget icon, Key key})
      : super(key: key);

  final List<String> requirements;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: LetterCircleIcon("R"),
      title: Wrap(alignment: WrapAlignment.start, children: _getReqs()),
    );
  }

  _getReqs() {
    if (requirements.length == 0) {
      return [Text('No special requirements')];
    }
    return requirements
        .map((r) => Chip(
              label: Text(r),
            ))
        .toList();
  }
}
