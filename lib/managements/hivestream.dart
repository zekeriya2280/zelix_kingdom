import 'dart:async';

import 'package:hive_flutter/hive_flutter.dart';

class HiveStream<T> {
  // Hive'dan bir Stream türetmek için yardımcı sınıf
  final Box<T> box; // Hive kutusu referansı
  late final StreamController<List<T>> _controller; // Stream kontrolcüsü

  HiveStream(this.box) {
    _controller = StreamController<List<T>>.broadcast(
      onListen: () => _emitInitialData(), // İlk veriyi yay
      onCancel: () => _controller.close(), // Stream kapatılırken
    );

    // Hive kutusu değişimlerini dinle
    box.listenable().addListener(_emitData);
  }

  void _emitData() {
    _controller.add(box.values.toList()); // Hive verilerini Stream'e ekle
  }

  void _emitInitialData() {
    _controller.add(box.values.toList()); // İlk durumu yay
  }

  Stream<List<T>> get stream => _controller.stream; // Stream'i dışa aktar

  void dispose() {
    box.listenable().removeListener(_emitData); // Listener'ı kaldır
    _controller.close(); // Kontrolcüyü kapat
  }
}