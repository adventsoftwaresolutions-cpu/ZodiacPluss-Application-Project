import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'schedule_models.dart';

abstract class QueueRepository {
  Future<List<QueueEntry>> fetchQueue();
}

class MockQueueRepository implements QueueRepository {
  @override
  Future<List<QueueEntry>> fetchQueue() async {
    return const <QueueEntry>[
      QueueEntry(
        id: 'q1',
        position: 1,
        clientName: 'Riya',
        clientAvatarUrl: 'assets/images/riya.jpg',
        sessionType: SessionType.video,
        tier: ClientTier.loyal,
      ),
      QueueEntry(
        id: 'q2',
        position: 2,
        clientName: 'Ikcha',
        clientAvatarUrl: 'assets/images/ikcha.jpg',
        sessionType: SessionType.voice,
        tier: ClientTier.normal,
      ),
    ];
  }
}

final Provider<QueueRepository> queueRepositoryProvider =
    Provider<QueueRepository>((Ref ref) => MockQueueRepository());