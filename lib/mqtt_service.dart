import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_browser_client.dart';

import 'alert_service.dart';

ValueNotifier<int> liveSpeed = ValueNotifier(0);
ValueNotifier<double> liveLatitude = ValueNotifier(17.3850);
ValueNotifier<double> liveLongitude = ValueNotifier(78.4867);

class MQTTService {

  static ValueNotifier<bool> isConnected = ValueNotifier(false);

  // Broadcast stream — multiple pages subscribe without conflicts
  static final StreamController<Map<String, dynamic>> _messageController =
      StreamController<Map<String, dynamic>>.broadcast();

  static Stream<Map<String, dynamic>> get messageStream =>
      _messageController.stream;

  // Client is late-initialized inside connect() so port is set BEFORE connect
  static MqttBrowserClient? _client;
  static MqttBrowserClient get client => _client!;

  static Future connect() async {
    try {
      // Instantiate here so port is baked in before connect() is called
      // ws://host:port/path  — Mosquitto WebSocket needs the /mqtt path
      _client = MqttBrowserClient.withPort(
        'ws://3.110.181.83/mqtt',
        'flutter_${DateTime.now().millisecondsSinceEpoch}',
        9001,
      );

      _client!.keepAlivePeriod = 60;
      _client!.autoReconnect = true;
      _client!.resubscribeOnAutoReconnect = true;
      _client!.logging(on: true);
      _client!.websocketProtocols = MqttClientConstants.protocolsSingleDefault;

      _client!.onConnected = () {
        print('[MQTT] ✅ CONNECTED to broker');
        isConnected.value = true;
      };

      _client!.onDisconnected = () {
        print('[MQTT] ❌ DISCONNECTED');
        isConnected.value = false;
      };

      _client!.onSubscribed = (topic) {
        print('[MQTT] Subscribed: $topic');
      };

      _client!.onAutoReconnect = () {
        print('[MQTT] Auto-reconnecting...');
      };

      final connMsg = MqttConnectMessage()
          .withClientIdentifier('flutter_${DateTime.now().millisecondsSinceEpoch}')
          .startClean()
          .withWillQos(MqttQos.atLeastOnce);

      _client!.connectionMessage = connMsg;

      print('[MQTT] Connecting to ws://3.110.181.83:9001/mqtt ...');
      await _client!.connect();

      // Subscribe to all topics
      _client!.subscribe('#', MqttQos.atLeastOnce);

      // Single listener — re-broadcasts to all page-level subscribers
      _client!.updates?.listen((events) {
        for (final event in events) {
          final topic = event.topic;
          final recMsg = event.payload as MqttPublishMessage;
          final message = MqttPublishPayload.bytesToStringAsString(
              recMsg.payload.message);

          print('[MQTT] Received on $topic: $message');

          try {
            final data = jsonDecode(message) as Map<String, dynamic>;

            if (data['speed_kmh'] != null) {
              liveSpeed.value = (data['speed_kmh'] as num).toInt();
            } else if (data['speed'] != null) {
              liveSpeed.value = (data['speed'] as num).toInt();
            }

            if (data['lat'] != null) liveLatitude.value = (data['lat'] as num).toDouble();
            if (data['latitude'] != null) liveLatitude.value = (data['latitude'] as num).toDouble();
            
            if (data['lon'] != null) liveLongitude.value = (data['lon'] as num).toDouble();
            if (data['longitude'] != null) liveLongitude.value = (data['longitude'] as num).toDouble();

            if (data['alert_type'] != null) {
              AlertService.addAlert(
                vehicle: data['device_id'] ?? 'Unknown',
                status: data['alert_type'] ?? 'SAFE',
              );
            }

            // Broadcast to all page listeners
            _messageController.add({'topic': topic, 'data': data});

          } catch (e) {
            print('[MQTT] JSON parse error on $topic: $e');
          }
        }
      });

    } catch (e) {
      print('[MQTT] Connection error: $e');
    }
  }
}