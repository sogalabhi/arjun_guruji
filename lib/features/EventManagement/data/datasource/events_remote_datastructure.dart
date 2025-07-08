import 'package:arjun_guruji/features/EventManagement/data/model/events_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class EventRemoteDataSource {
  Future<List<EventModel>> getAllEvents();
  Future<void> updateInterestedCount(
      {required String eventId, required bool increment});
}

class EventRemoteDataSourceImpl implements EventRemoteDataSource {
  final FirebaseFirestore firestore;

  EventRemoteDataSourceImpl(this.firestore);

  @override
  Future<List<EventModel>> getAllEvents() async {
    final snapshot = await firestore.collection('events').get();
    return snapshot.docs.map((doc) => EventModel.fromFirestore(doc.id, doc.data())).toList();
  }

  @override
  Future<void> updateInterestedCount(
      {required String eventId, required bool increment}) async {
    final docRef = firestore.collection('events').doc(eventId);

    await firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) return;

      final currentCount = snapshot.get('interestedCount') ?? 0;
      final updatedCount = increment
          ? currentCount + 1
          : (currentCount - 1).clamp(0, double.infinity);

      transaction.update(docRef, {'interestedCount': updatedCount});
    });
  }
}
