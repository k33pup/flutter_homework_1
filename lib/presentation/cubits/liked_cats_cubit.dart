import 'package:bloc/bloc.dart';
import '../../domain/models/cat.dart';

class LikedCatsState {
  final List<Cat> likedCats;
  final String filter;

  LikedCatsState({required this.likedCats, required this.filter});

  LikedCatsState copyWith({List<Cat>? likedCats, String? filter}) {
    return LikedCatsState(
      likedCats: likedCats ?? this.likedCats,
      filter: filter ?? this.filter,
    );
  }
}

class LikedCatsCubit extends Cubit<LikedCatsState> {
  LikedCatsCubit() : super(LikedCatsState(likedCats: [], filter: ''));

  void addCat(Cat cat) {
    final updatedList = List<Cat>.from(state.likedCats);
    updatedList.add(cat.copyWith(likedDate: DateTime.now()));
    emit(state.copyWith(likedCats: updatedList));
  }

  void removeCat(Cat cat) {
    final updatedList = List<Cat>.from(state.likedCats)..remove(cat);
    final newFilter = updatedList.isEmpty ? '' : state.filter;
    emit(state.copyWith(likedCats: updatedList, filter: newFilter));
  }

  void setFilter(String filter) {
    emit(state.copyWith(filter: filter));
  }
}
