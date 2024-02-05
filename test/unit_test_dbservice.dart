// ignore: dangling_library_doc_comments
/**
 * import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:fccapp/services/Level_0/database_service.dart';

class MockFirestore extends Mock implements FirebaseFirestore {}

class MockDocumentReference extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

class MockDocumentSnapshot extends Mock
    implements DocumentSnapshot<Map<String, dynamic>> {}

class MockCollectionReference extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

void main() {
  group('DBService', () {
    final firestore = MockFirestore();
    final documentReference = MockDocumentReference();
    final documentSnapshot = MockDocumentSnapshot();
    final collectionReference = MockCollectionReference();
    final dbService = DBService();

    dbService.db = firestore;

    test('isDataInDB returns true when document exists', () async {
      when(firestore.doc(anyNamed('path'))).thenReturn(documentReference);
      when(documentReference.get()).thenAnswer((_) async => documentSnapshot);
      when(documentSnapshot.exists).thenReturn(true);

      bool result = await dbService.isDataInDB(
          data: 'documentName', path: 'path/to/document');

      expect(result, true);
    });

    test('getFromDB returns data when document exists', () async {
      when(firestore.doc(any)).thenReturn(documentReference);
      when(documentReference.get()).thenAnswer((_) async => documentSnapshot);
      when(documentSnapshot.data()).thenReturn({'key': 'value'});

      var result = await dbService.getFromDB(
          data: 'documentName', path: 'path/to/document');

      expect(result, {'key': 'value'});
    });

    test('addEntryToDB returns true when entry is added', () async {
      when(firestore.collection(any)).thenReturn(collectionReference);
      when(collectionReference.add(any))
          .thenAnswer((_) async => documentReference);

      bool result = await dbService
          .addEntryToDB(path: 'path/to/document', entry: {'key': 'value'});

      expect(result, true);
    });

    test('addEntryToDBWithName returns true when entry is added', () async {
      when(firestore.collection(any)).thenReturn(collectionReference);
      when(collectionReference.doc(any)).thenReturn(documentReference);
      when(documentReference.set(any)).thenAnswer((_) async => null);

      bool result = await dbService.addEntryToDBWithName(
          path: 'path/to/document',
          entry: {'key': 'value'},
          name: 'documentName');

      expect(result, true);
    });

    test('deleteInDB returns true when document is deleted', () async {
      when(firestore.collection(any)).thenReturn(collectionReference);
      when(collectionReference.doc(any)).thenReturn(documentReference);
      when(documentReference.delete()).thenAnswer((_) async => null);

      bool result = await dbService.deleteInDB(
          data: 'documentName', path: 'path/to/document');

      expect(result, true);
    });
  });
}

*/