import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../services/endpoint_service.dart';
import '../../services/service_locator.dart';

import '../../config.dart';

class EndpointSelector extends HookWidget {
  const EndpointSelector({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var endpoint = useState(sl.get<EndpointService>().baseUrl);

    return Container(
        child: DropdownButton(
            value: endpoint.value,
            onChanged: (val) {
              sl.get<EndpointService>().baseUrl = val;
              endpoint.value = val;
            },
            items: endpoints
                .map((endpoint) => DropdownMenuItem<String>(
                    value: endpoint, child: Text(endpoint)))
                .toList()));
  }
}
