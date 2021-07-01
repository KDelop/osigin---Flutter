import 'dart:io';

import 'util.dart';
import '../services/logger.dart';

import '../util/mca_http_client.dart';

class ImageUploadRepo {
  final McaHttpClient _client;

  ImageUploadRepo(this._client);

  /// Takes a path to a image to upload (taken by camera.)
  Future<String> uploadStopProof(String path) async {
    var imageFuture = File(path).readAsBytes();
    var uploadRequest = await _client.postJson('/drivers/imageUploadUrl', {});
    var url = uploadRequest['url'];

    if (url == null) {
      throw Exception('Did not receive image upload URL from server');
    }

    return withClient((client) async {
      var response = await client.put(url, body: await imageFuture, headers: {
        'Content-Type': 'image/jpeg',
      });

      if (response.statusCode >= 300) {
        logger.e("S3 Upload Error: ${response.body}");
        throw Exception('S3 Upload Error: ${response.body}');
      }

      // Strip the aws upload param stuff.
      var uri = Uri.parse(url);
      return "${uri.scheme}://${uri.host}${uri.path}";
    });
  }
}
