import 'package:flutter/material.dart';
import 'package:mpeischedule/feature/data/models/lesson_model.dart';
import 'package:mpeischedule/ui/item_row.dart';

class CardLesson extends StatelessWidget {
  CardLesson(this.lesson);
  LessonModel lesson;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 30,
      margin: EdgeInsets.symmetric(vertical: 7),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    lesson.name,
                    textAlign: TextAlign.start,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Text(lesson.type, textAlign: TextAlign.start),
                  ItemRow(
                      icon: Icon(Icons.location_on),
                      labelText: lesson.auditorium),
                  ItemRow(
                      icon: Icon(Icons.directions_walk),
                      labelText: lesson.group),
                  lesson.lecturer.isEmpty
                      ? Text('')
                      : ItemRow(
                          icon: Icon(Icons.person), labelText: lesson.lecturer),
                ],
              ),
            ),
            Text(lesson.time, textAlign: TextAlign.end)
          ],
        ),
      ),
    );
  }
}
