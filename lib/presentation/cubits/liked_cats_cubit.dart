import 'dart:convert';
import 'package:bloc/bloc.dart';
import '../../domain/models/cat.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> init() async {
    await loadFromStorage();
  }

  Future<void> loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('likedCats') ?? [];
    final cats = list.map((s) => Cat.fromJson(json.decode(s))).toList();
    emit(state.copyWith(likedCats: cats));
  }

  Future<void> _saveToStorage(List<Cat> list) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = list.map((c) => json.encode(c.toJson())).toList();
    await prefs.setStringList('likedCats', jsonList);
  }

  void addCat(Cat cat) {
    final updated = List<Cat>.from(state.likedCats)
      ..add(cat.copyWith(likedDate: DateTime.now()));
    emit(state.copyWith(likedCats: updated));
    _saveToStorage(updated);
  }

  void removeCat(Cat cat) {
    final updated =
        state.likedCats
            .where(
              (c) => c.imageUrl != cat.imageUrl || c.breedName != cat.breedName,
            )
            .toList();
    emit(state.copyWith(likedCats: updated));
    _saveToStorage(updated);
  }

  void setFilter(String filter) => emit(state.copyWith(filter: filter));
}
