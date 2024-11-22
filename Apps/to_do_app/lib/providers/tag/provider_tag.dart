import 'package:flutter/material.dart';

class TagProvider with ChangeNotifier {
  List<Map<String, dynamic>> _tags = [];

  List<Map<String, dynamic>> get tags => _tags;

  // Método para agregar una nueva etiqueta
  void addTag(Map<String, dynamic> tag) {
    _tags.add(tag);
    notifyListeners(); // Notificar a los widgets escuchando el cambio
  }
}
