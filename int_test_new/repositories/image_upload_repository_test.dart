import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mca_driver_app/repo/image_upload_repository.dart';
import 'package:mca_driver_app/repo/util.dart';

import '../int_test_util.dart';

void main() async {
  const testBytes = [200, 100, 50, 25];

  group('Image Upload Repository', () {
    var testJpgPath = '';
    ImageUploadRepo imageUploadRepo;

    setUpAll(() async {
      // Get the system temp directory.
      testJpgPath = '${Directory.systemTemp.path}/imageUploadRepo.jpg';
      var f = File(testJpgPath);
      await f.writeAsBytes(testBytes);

      var mcaClient = await establishAuthenticatedIntTestClient();

      imageUploadRepo = ImageUploadRepo(mcaClient);
    });

    test('uploadStopProof', () async {
      // Act
      var imageUrl = await imageUploadRepo.uploadStopProof(testJpgPath);

      // Verify that the bytes were stored on S3.. retrieve.
      await withClient((client) async {
        var response = await client.get(imageUrl);
        expect(response.bodyBytes, equals(testBytes));
      });
    });
  });
}
