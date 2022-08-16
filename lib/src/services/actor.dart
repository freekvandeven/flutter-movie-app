import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_viewing_app/src/models/actor.dart';

abstract class ActorService extends StateNotifier<List<Actor>> {
  ActorService._() : super([]);
  Future<void> fetchActors();
}

class MockedActorService extends StateNotifier<List<Actor>>
    implements ActorService {
  MockedActorService() : super([]);

  @override
  Future<void> fetchActors() async {
    state = [
      const Actor(
        name: 'Eddie Redmayne',
        image: 'assets/images/actors',
      ),
      const Actor(
        name: 'Jude Law',
        image: 'assets/images/actors',
      ),
    ];
  }
}
