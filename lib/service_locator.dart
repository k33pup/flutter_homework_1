import 'package:get_it/get_it.dart';
import 'presentation/cubits/liked_cats_cubit.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerSingleton<LikedCatsCubit>(LikedCatsCubit());
}
