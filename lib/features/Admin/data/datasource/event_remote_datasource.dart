import 'package:arjun_guruji/features/Admin/data/model/event_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';


abstract class EventRemoteDataSource {
  Future<List<EventModel>> getAllEvents();
  Future<EventModel> createEvent(EventModel event, {File? image});
  Future<void> updateEvent(EventModel event, {File? image});
  Future<void> deleteEvent(String eventId);
  Future<String> uploadImage(File imageFile);
  Future<String> uploadImageToEventFolder(File imageFile, String eventName);
}

class EventRemoteDataSourceImpl implements EventRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  EventRemoteDataSourceImpl(this.firestore, this.storage);

  @override
  Future<List<EventModel>> getAllEvents() async {
    final snapshot = await firestore.collection('events').get();
    return snapshot.docs.map((doc) => EventModel.fromMap(doc.data())).toList();
  }

  @override
  Future<EventModel> createEvent(EventModel event, {File? image}) async {
    List<String> galleryLinks = List.from(event.galleryLinks);
    if (image != null) {
      final url = await uploadImage(image);
      galleryLinks.add(url);
    }
    final docRef = firestore.collection('events').doc(event.title);
    await docRef.set({
      ...event.toMap(),
      'galleryLinks': galleryLinks,
    });
    final doc = await docRef.get();
    return EventModel.fromMap(doc.data()!..['id'] = docRef.id);
  }

  @override
  Future<void> updateEvent(EventModel event, {File? image}) async {
    List<String> galleryLinks = List.from(event.galleryLinks);
    if (image != null) {
      final url = await uploadImage(image);
      galleryLinks.add(url);
    }
    await firestore.collection('events').doc(event.title).update({
      ...event.toMap(),
      'galleryLinks': galleryLinks,
    });
  }

  @override
  Future<void> deleteEvent(String eventId) async {
    await firestore.collection('events').doc(eventId).delete();
  }

  @override
  Future<String> uploadImage(File imageFile) async {
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final ref = storage.ref().child('events/$fileName');
    final uploadTask = await ref.putFile(imageFile);
    return await uploadTask.ref.getDownloadURL();
  }

  @override
  Future<String> uploadImageToEventFolder(File imageFile, String eventName) async {
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final ref = storage.ref().child('events/$eventName/$fileName');
    final uploadTask = await ref.putFile(imageFile);
    return await uploadTask.ref.getDownloadURL();
  }
} 