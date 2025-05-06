import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../domain/models/cat.dart';
import '../cubits/liked_cats_cubit.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

class LikedCatsScreen extends StatefulWidget {
  const LikedCatsScreen({super.key});

  @override
  LikedCatsScreenState createState() => LikedCatsScreenState();
}

class LikedCatsScreenState extends State<LikedCatsScreen> {
  final likedCatsCubit = GetIt.instance<LikedCatsCubit>();
  final TextEditingController _filterController = TextEditingController();

  @override
  void initState() {
    super.initState();
    likedCatsCubit.setFilter('');
    _filterController.text = '';
  }

  @override
  void dispose() {
    _filterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Лайкнутые котики')),
      body: BlocBuilder<LikedCatsCubit, LikedCatsState>(
        bloc: likedCatsCubit,
        builder: (context, state) {
          List<Cat> filteredList = state.likedCats;
          if (state.filter.isNotEmpty) {
            filteredList =
                filteredList
                    .where(
                      (cat) => cat.breedName.toLowerCase().contains(
                        state.filter.toLowerCase(),
                      ),
                    )
                    .toList();
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _filterController,
                  decoration: const InputDecoration(
                    labelText: 'Фильтр по породе',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    likedCatsCubit.setFilter(value);
                  },
                ),
              ),
              Expanded(
                child:
                    filteredList.isEmpty
                        ? const Center(child: Text('Нет лайкнутых котиков'))
                        : ListView.builder(
                          itemCount: filteredList.length,
                          itemBuilder: (context, index) {
                            final cat = filteredList[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              child: ListTile(
                                leading: CachedNetworkImage(
                                  imageUrl: cat.imageUrl,
                                  placeholder:
                                      (_, __) => const SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        ),
                                      ),
                                  errorWidget:
                                      (_, __, ___) => const Icon(Icons.error),
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                ),
                                title: Text(cat.breedName),

                                subtitle: Text(
                                  cat.likedDate != null
                                      ? 'Лайк: ${DateFormat('dd.MM.yyyy HH:mm:ss').format(cat.likedDate!.toLocal())}'
                                      : '',
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed:
                                      () => likedCatsCubit.removeCat(cat),
                                ),
                              ),
                            );
                          },
                        ),
              ),
            ],
          );
        },
      ),
    );
  }
}
