import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void createExerciseData(DateTime input_date, int input_type, int input_time) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  firestore
      .collection('ExerciseDataCollection')
      .add({'date': input_date, 'type': input_type, 'time': input_time});
}
