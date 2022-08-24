// SPDX-FileCopyrightText: 2022 Freek van de Ven freek@freekvandeven.nl
//
// SPDX-License-Identifier: GPL-3.0-or-later

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
        image: 'assets/images/actors/eddie_redmayne.jpg',
      ),
      const Actor(
        name: 'Jude Law',
        image: 'assets/images/actors/jude_law.jpg',
      ),
      const Actor(
        name: 'Dan Fogler',
        image: 'assets/images/actors/dan_folger.jpg',
      ),
      const Actor(
        name: 'Mads Mikkelsen',
        image: 'assets/images/actors/mads_mikkelsen.jpg',
      ),
    ];
  }
}
