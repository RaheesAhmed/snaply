import 'dart:async';
import 'dart:io';

/// Event types for the application
enum EventType {
  editImage,
}

/// Basic event class for communication
class AppEvent {
  final EventType type;
  final dynamic data;

  AppEvent(this.type, this.data);
}

/// Simple event bus for app-wide communication
class EventBus {
  // Singleton pattern
  static final EventBus _instance = EventBus._internal();
  factory EventBus() => _instance;
  EventBus._internal();

  final StreamController<AppEvent> _eventController =
      StreamController<AppEvent>.broadcast();

  /// Get the stream of events
  Stream<AppEvent> get events => _eventController.stream;

  /// Send an event to the bus
  void fire(AppEvent event) {
    _eventController.add(event);
  }

  /// Send an image to be edited
  void sendImageToEdit(File imageFile) {
    fire(AppEvent(EventType.editImage, imageFile));
  }

  /// Dispose the event bus
  void dispose() {
    _eventController.close();
  }
}
