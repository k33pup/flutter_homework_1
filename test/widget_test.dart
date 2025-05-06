import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus_platform_interface/connectivity_plus_platform_interface.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:network_image_mock/network_image_mock.dart';

import 'package:cat_tinder/main.dart';
import 'package:cat_tinder/service_locator.dart';
import 'package:cat_tinder/presentation/cubits/liked_cats_cubit.dart';
import 'package:cat_tinder/data/api_service.dart';
import 'package:cat_tinder/domain/models/cat.dart';

class FakeConnectivityPlatform extends ConnectivityPlatform {
  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      Stream.value([ConnectivityResult.wifi]);
}

void _setUpFakeConnectivity() {
  ConnectivityPlatform.instance = FakeConnectivityPlatform();
}

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  SharedPreferences.setMockInitialValues({});

  await dotenv.load(fileName: 'assets/.env');

  ApiService.client = MockClient((_) async {
    final sampleCat = Cat.sample();
    final fakeJson = jsonEncode([
      {
        'url': sampleCat.imageUrl,
        'breeds': [
          {
            'name': sampleCat.breedName,
            'description': sampleCat.breedDescription,
            'temperament': sampleCat.breedTemperament,
            'origin': sampleCat.breedOrigin,
          },
        ],
      },
    ]);
    return http.Response(fakeJson, 200);
  });

  _setUpFakeConnectivity();

  setupLocator();
  await GetIt.instance<LikedCatsCubit>().init();

  testWidgets('App shows title and initial like count', (tester) async {
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(find.text('Кототиндер'), findsOneWidget);
      expect(find.text('Лайков: 0'), findsOneWidget);
    });
  });
}
