import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cat_tinder/presentation/cubits/liked_cats_cubit.dart';
import 'package:cat_tinder/domain/models/cat.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late LikedCatsCubit cubit;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    cubit = LikedCatsCubit();
    await cubit.init();
  });

  test('initial state is empty', () {
    expect(cubit.state.likedCats, isEmpty);
  });

  test('addCat increases list', () {
    final cat = Cat.sample();
    cubit.addCat(cat);
    expect(cubit.state.likedCats.length, 1);
  });

  test('removeCat removes item', () {
    final cat = Cat.sample();
    cubit.addCat(cat);
    cubit.removeCat(cat);
    expect(cubit.state.likedCats, isEmpty);
  });
}
