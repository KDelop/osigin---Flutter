import 'package:flutter/material.dart';
import '../../labels.dart';
import '../../models/pickup_point_vm.dart';

typedef ValueChanged = void Function(String id, bool value);

class PickupPoints extends StatelessWidget {
  final List<PickupPointVm> pickupPoints;
  final ValueChanged onChange;

  PickupPoints({this.pickupPoints, this.onChange, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration:
            BoxDecoration(border: Border.all(width: 5, color: Colors.amber)),
        child: Column(
            children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      UiLabels.pickupPointsHeader,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ] +
                (pickupPoints ?? [])
                    .map((pp) => Card(
                          child: ListTile(
                            title: Text(pp.description),
                            leading: Checkbox(
                              value: pp.isConfirmed,
                              onChanged: (val) => onChange(pp.id, val),
                            ),
                          ),
                        ))
                    .toList()),
      ),
    );
  }
}
