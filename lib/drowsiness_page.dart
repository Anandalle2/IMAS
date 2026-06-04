import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:http/http.dart' as http;
import 'package:mqtt_client/mqtt_client.dart';
import 'mqtt_service.dart';

class DrowsinessPage extends StatefulWidget {
  const DrowsinessPage({super.key});

  @override
  State<DrowsinessPage> createState() => _DrowsinessPageState();
}

class _DrowsinessPageState extends State<DrowsinessPage> {

  // MQTT state — driven by global MQTTService
  bool mqttConnected = false;
  String currentAlertType = "SAFE";
  String deviceId = "IMAS_001";
  String lastTimestamp = "--";
  int handsDetected = 0;

  // DMS metric state (EAR/MAR from mqtt)
  double eyeRatio = 0.0;
  double mouthRatio = 0.0;
  double headTilt = 0.0;

  // Live alerts list
  List<Map<String, dynamic>> liveAlerts = [];

  // WebRTC
  bool streamConnected = false;
  RTCVideoRenderer localRenderer = RTCVideoRenderer();
  RTCPeerConnection? peerConnection;

  // Subscription handles
  StreamSubscription? _mqttSub;
  VoidCallback? _connListener;

  // Alert color helper
  Color get alertColor {
    switch (currentAlertType) {
      case "DROWSINESS":
      case "EYE_CLOSED":
        return Colors.deepOrange;
      case "YAWNING":
        return Colors.orange;
      case "HANDS_OFF":
        return Colors.red;
      case "DISTRACTED":
        return Colors.amber;
      default:
        return Colors.green;
    }
  }

  IconData get alertIcon {
    switch (currentAlertType) {
      case "DROWSINESS":
      case "EYE_CLOSED":
        return Icons.visibility_off;
      case "YAWNING":
        return Icons.sentiment_very_dissatisfied;
      case "HANDS_OFF":
        return Icons.pan_tool_alt;
      case "DISTRACTED":
        return Icons.warning_amber;
      default:
        return Icons.check_circle;
    }
  }

  @override
  void initState() {
    super.initState();
    _listenToGlobalMQTT();
    initWebRTC();
  }

  void _listenToGlobalMQTT() {
    // Mirror connection status from the global service
    _connListener = () {
      if (mounted) setState(() => mqttConnected = MQTTService.isConnected.value);
    };
    MQTTService.isConnected.addListener(_connListener!);

    // Read current connection state immediately
    mqttConnected = MQTTService.isConnected.value;

    // Listen to the broadcast stream — no single-subscriber conflict
    // Backend publishes DMS alerts to topic: "dms/alerts"
    _mqttSub = MQTTService.messageStream.listen((event) {
      final topic = event["topic"] as String;
      final data  = event["data"]  as Map<String, dynamic>;

      // Accept: dms/alerts, alerts/dms, imas/alerts, or anything with alert_type
      final isDms = topic.contains("dms") || topic == "imas/alerts";
      if (!isDms && data["alert_type"] == null) return;

      // Filter out pure collision/FCW alerts on this page
      final alertType = (data["alert_type"] ?? "") as String;
      if (alertType.contains("COLLISION") || alertType.contains("FCW")) return;

      print("[DMS page] Got alert on $topic: $alertType");

      if (mounted) {
        setState(() {
          currentAlertType = alertType.isNotEmpty ? alertType : "SAFE";
          deviceId      = data["device_id"]    ?? "IMAS_001";
          lastTimestamp = data["timestamp"]    ?? "--";
          handsDetected = (data["hands_detected"] ?? 0) as int;
          if (data["ear"]       != null) eyeRatio   = (data["ear"]       as num).toDouble();
          if (data["mar"]       != null) mouthRatio = (data["mar"]       as num).toDouble();
          if (data["head_tilt"] != null) headTilt   = (data["head_tilt"] as num).toDouble();

          liveAlerts.insert(0, {
            "type":   currentAlertType,
            "device": deviceId,
            "time":   lastTimestamp,
            "hands":  handsDetected,
          });
          if (liveAlerts.length > 20) liveAlerts.removeLast();
        });
      }
    });
  }

  Future<void> initWebRTC() async {
    try {
      await localRenderer.initialize();

      final config = {
        "iceServers": [
          {"urls": "stun:stun.l.google.com:19302"}
        ]
      };

      peerConnection = await createPeerConnection(config);

      peerConnection!.onTrack = (event) {
        if (event.streams.isNotEmpty) {
          setState(() {
            streamConnected = true;
            localRenderer.srcObject = event.streams[0];
          });
          print("[DMS] Stream received");
        }
      };

      // Add transceivers to receive video
      await peerConnection!.addTransceiver(
        kind: RTCRtpMediaType.RTCRtpMediaTypeVideo,
        init: RTCRtpTransceiverInit(direction: TransceiverDirection.RecvOnly),
      );

      final offer = await peerConnection!.createOffer();
      await peerConnection!.setLocalDescription(offer);

      final response = await http.post(
        Uri.parse("http://3.110.181.83:8889/dms/whep"),
        headers: {
          "Content-Type": "application/sdp",
          "Accept": "application/sdp",
        },
        body: offer.sdp,
      );

      print("[DMS] WebRTC response: ${response.statusCode}");

      if (response.statusCode == 201 || response.statusCode == 200) {
        await peerConnection!.setRemoteDescription(
          RTCSessionDescription(response.body, "answer"),
        );
        print("[DMS] WebRTC connected successfully");
      } else {
        print("[DMS] WebRTC failed: ${response.body}");
      }
    } catch (e) {
      print("[DMS] WebRTC error: $e");
    }
  }

  @override
  void dispose() {
    if (_connListener != null) MQTTService.isConnected.removeListener(_connListener!);
    _mqttSub?.cancel();
    peerConnection?.close();
    localRenderer.dispose();
    super.dispose();
  }

  Widget _metricCard(IconData icon, String value, String label, Color color) {
    return Expanded(
      child: Container(
        height: 110,
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF081B31),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(icon, color: color, size: 26),
            Text(value,
                style: TextStyle(
                    color: color,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            Text(label,
                style: const TextStyle(color: Colors.grey, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Color _alertColor(String type) {
    switch (type) {
      case "SLEEPY":
      case "DROWSINESS":
      case "EYE_CLOSED":   return Colors.deepOrange;
      case "YAWN":
      case "YAWNING":      return Colors.orange;
      case "HANDS_OFF":    return Colors.red;
      case "FACE_LOST":    return Colors.redAccent;
      case "PHONE":
      case "DISTRACTION":
      case "DISTRACTED":   return Colors.amber;
      case "BOTTLE":       return Colors.yellow;
      default:             return Colors.green;
    }
  }

  IconData _alertIcon(String type) {
    switch (type) {
      case "SLEEPY":
      case "DROWSINESS":
      case "EYE_CLOSED":   return Icons.visibility_off;
      case "YAWN":
      case "YAWNING":      return Icons.sentiment_very_dissatisfied;
      case "HANDS_OFF":    return Icons.pan_tool_alt;
      case "FACE_LOST":    return Icons.no_photography;
      case "PHONE":        return Icons.phone_android;
      case "DISTRACTION":
      case "DISTRACTED":   return Icons.warning_amber;
      case "BOTTLE":       return Icons.local_drink;
      default:             return Icons.check_circle;
    }
  }

  Widget _alertRow(Map<String, dynamic> alert) {
    final String type = alert["type"] ?? "SAFE";
    final Color c = _alertColor(type);
    final IconData icon = _alertIcon(type);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: c.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.withOpacity(0.5), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: c.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 1,
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: c.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: c, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type,
                  style: TextStyle(
                    color: c,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  "📟 ${alert["device"]}   🕐 ${alert["time"]}",
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: c.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "ALERT",
                  style: TextStyle(color: c, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
              if ((alert["hands"] ?? 0) > 0) ...[
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "Hands: ${alert["hands"]}",
                    style: const TextStyle(color: Colors.red, fontSize: 10),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020E1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF020E1A),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("DMS LIVE",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            Text("Driver Monitoring System",
                style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 15),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: (mqttConnected ? Colors.green : Colors.red).withOpacity(0.15),
            ),
            child: Row(
              children: [
                Icon(Icons.circle,
                    color: mqttConnected ? Colors.green : Colors.red,
                    size: 10),
                const SizedBox(width: 7),
                Text(
                  mqttConnected ? "MQTT LIVE" : "OFFLINE",
                  style: TextStyle(
                      color: mqttConnected ? Colors.green : Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Video feed ────────────────────────────────────────────
            Container(
              height: 240,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF071D31),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                    color: (streamConnected ? Colors.cyan : Colors.grey)
                        .withOpacity(0.3)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: streamConnected
                    ? RTCVideoView(localRenderer,
                        objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover)
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.videocam_off,
                              color: Colors.grey.withOpacity(0.5), size: 48),
                          const SizedBox(height: 10),
                          const Text("Connecting to DMS Camera…",
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 16),

            // ── Live alert banner ─────────────────────────────────────
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: alertColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: alertColor.withOpacity(0.5)),
              ),
              child: Row(
                children: [
                  Icon(alertIcon, color: alertColor, size: 36),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentAlertType == "SAFE" ? "✅  DRIVER SAFE" : "⚠  $currentAlertType",
                          style: TextStyle(
                              color: alertColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Device: $deviceId   |   $lastTimestamp",
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Metrics row ───────────────────────────────────────────
            Row(
              children: [
                _metricCard(Icons.remove_red_eye,
                    eyeRatio.toStringAsFixed(2), "EAR (Eye)", Colors.cyanAccent),
                _metricCard(Icons.sentiment_dissatisfied,
                    mouthRatio.toStringAsFixed(2), "MAR (Mouth)", Colors.orangeAccent),
                _metricCard(Icons.screen_rotation,
                    "${headTilt.toStringAsFixed(1)}°", "Head Tilt", Colors.purpleAccent),
              ],
            ),
            const SizedBox(height: 20),

            // ── Live alerts feed ──────────────────────────────────────
            Row(
              children: [
                const Icon(Icons.bolt, color: Colors.cyanAccent, size: 18),
                const SizedBox(width: 8),
                const Text("LIVE ALERTS",
                    style: TextStyle(
                        color: Colors.cyanAccent,
                        letterSpacing: 3,
                        fontWeight: FontWeight.bold)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.cyan.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text("${liveAlerts.length} events",
                      style: const TextStyle(color: Colors.cyan, fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 12),

            liveAlerts.isEmpty
                ? Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF071D31),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.cyan.withOpacity(0.1)),
                    ),
                    child: Column(
                      children: [
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.6, end: 1.0),
                          duration: const Duration(milliseconds: 900),
                          curve: Curves.easeInOut,
                          builder: (ctx, val, child) => Opacity(
                            opacity: val,
                            child: child,
                          ),
                          child: const Icon(Icons.sensors, color: Colors.cyanAccent, size: 48),
                        ),
                        const SizedBox(height: 14),
                        mqttConnected
                            ? const Text(
                                "🟢  Connected · Listening for alerts…",
                                style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              )
                            : const Text(
                                "🔴  MQTT Offline · Reconnecting…",
                                style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                        const SizedBox(height: 6),
                        const Text(
                          "Topic: dms/alerts",
                          style: TextStyle(color: Colors.grey, fontSize: 11, letterSpacing: 1),
                        ),
                      ],
                    ),
                  )
                : Column(
                    children: liveAlerts.map(_alertRow).toList(),
                  ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}