import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../domain/models/cat.dart';
import '../../data/api_service.dart';
import '../widgets/like_button.dart';
import '../widgets/dislike_button.dart';
import 'detail_screen.dart';
import '../cubits/liked_cats_cubit.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

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
    Stream<ConnectivityResult> connectivityStream;
    try {
      connectivityStream = Connectivity().onConnectivityChanged
          .map((list) => list.first)
          .handleError((_) {});
    } catch (e) {
      connectivityStream = Stream.value(ConnectivityResult.none);
    }
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
      body: StreamBuilder<ConnectivityResult>(
        stream: connectivityStream,
        initialData: ConnectivityResult.wifi,
        builder: (context, snapshot) {
          final status = snapshot.data ?? ConnectivityResult.wifi;
          if (status == ConnectivityResult.none) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Вы в офлайн‑режиме')),
              );
            });
          }

          return _isLoading || _currentCat == null
              ? const Center(child: CircularProgressIndicator())
              : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Лайков: $_likeCount",
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 20),
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
                          child: CachedNetworkImage(
                            imageUrl: _currentCat!.imageUrl,
                            fit: BoxFit.cover,
                            height: 300,
                            width: double.infinity,
                            placeholder:
                                (context, url) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                            errorWidget:
                                (context, url, error) =>
                                    const Center(child: Icon(Icons.error)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DislikeButton(onPressed: _handleDislike),
                      const SizedBox(width: 20),
                      LikeButton(onPressed: _handleLike),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _currentCat!.breedName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              );
        },
      ),
    );
  }
}
