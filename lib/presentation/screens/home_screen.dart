import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../domain/models/cat.dart';
import '../../data/api_service.dart';
import '../widgets/like_button.dart';
import '../widgets/dislike_button.dart';
import 'detail_screen.dart';
import '../cubits/liked_cats_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  Cat? _currentCat;
  int _likeCount = 0;
  bool _isLoading = false;

  final _likedCatsCubit = GetIt.instance<LikedCatsCubit>();

  Future<void> _fetchCat() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final cat = await ApiService.fetchCat();
      if (!mounted) return;
      if (cat != null) {
        setState(() {
          _currentCat = cat;
        });
      }
    } catch (e) {
      if (!mounted) return;
      _showErrorDialog(context, 'Ошибка сети при получении котика');
    }
    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('Ошибка'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('ОК'),
              ),
            ],
          ),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchCat();
  }

  void _handleLike() {
    setState(() {
      _likeCount++;
    });
    if (_currentCat != null) {
      _likedCatsCubit.addCat(_currentCat!);
    }
    _fetchCat();
  }

  void _handleDislike() {
    _fetchCat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Кототиндер"),
        leading: Icon(Icons.pets),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () => Navigator.pushNamed(context, '/liked'),
          ),
        ],
      ),
      body:
          _isLoading || _currentCat == null
              ? Center(child: CircularProgressIndicator())
              : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Лайков: $_likeCount", style: TextStyle(fontSize: 20)),
                  SizedBox(height: 20),
                  Expanded(
                    child: Center(
                      child: Dismissible(
                        key: UniqueKey(),
                        direction: DismissDirection.horizontal,
                        onDismissed: (direction) {
                          if (direction == DismissDirection.startToEnd) {
                            _handleLike();
                          } else if (direction == DismissDirection.endToStart) {
                            _handleDislike();
                          }
                        },
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        DetailScreen(cat: _currentCat!),
                              ),
                            );
                          },
                          child: Image.network(
                            _currentCat!.imageUrl,
                            fit: BoxFit.cover,
                            height: 300,
                            width: double.infinity,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DislikeButton(onPressed: _handleDislike),
                      SizedBox(width: 20),
                      LikeButton(onPressed: _handleLike),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    _currentCat!.breedName,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                ],
              ),
    );
  }
}
