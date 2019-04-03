import 'dart:async';

import 'package:app_firebase/classes/animal.dart';
import 'package:app_firebase/widgets/cardview_animal.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ListViewAnimal extends StatefulWidget {
  BuildContext context;

  ListViewAnimal(this.context);

  @override
  State<StatefulWidget> createState() => new ListViewAnimalState();
}

class ListViewAnimalState extends State<ListViewAnimal> {
  List<Animal> animals = new List();
  DatabaseReference reference =
      FirebaseDatabase.instance.reference().child("Animal");
  StreamSubscription<Event> onAddedSubs;
  StreamSubscription<Event> onChangeSubs;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: animals.length,
      itemBuilder: (BuildContext context, int index) {
        return Dismissible(
          key: ObjectKey(animals[index]),
          child: CardViewAnimal(animals[index], context),
          onDismissed: (direction) {
            deleteItem(index);
          },
        );
      },
    );
  }

  void deleteItem(index) {
    setState(() {
      reference.child(animals[index].key).remove();
      animals.removeAt(index);
    });
  }

  @override
  void initState() {
    onAddedSubs = reference.onChildAdded.listen(onEntryAdded);
    onChangeSubs = reference.onChildChanged.listen(onEntryChanged);
    super.initState();
  }

  onEntryAdded(Event event) {
    setState(() {
      animals.add(Animal.getAnimal(event.snapshot));
    });
  }

  onEntryChanged(Event event) {
    Animal oldEntry = animals.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    setState(() {
      animals[animals.indexOf(oldEntry)] = Animal.getAnimal(event.snapshot);
    });
  }

  @override
  void dispose() {
    onAddedSubs.cancel();
    onChangeSubs.cancel();
    super.dispose();
  }
}
