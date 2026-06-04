import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'mqtt_service.dart';

class CollisionPage extends StatefulWidget {
  const CollisionPage({super.key});

  @override
  State<CollisionPage> createState() =>
      _CollisionPageState();
}

class _CollisionPageState
    extends State<CollisionPage>{

  bool critical=true;

  String vehicleCount="0";
  String speed="--";
  String threat="HIGH";

  String latestEvent=
      "COLLISION_WARNING_CRITICAL";

  String eventTime=
      "--:--:--";

  // Live FCW alerts feed
  List<Map<String, dynamic>> liveAlerts = [];

  RTCVideoRenderer localRenderer=
  RTCVideoRenderer();

  RTCPeerConnection?
  peerConnection;

  Timer? timer;
  StreamSubscription? _mqttSub;
  VoidCallback? _connListener;
  bool mqttConnected = false;


  Future<void>
  getCollisionData()
  async{

    try{

      final response=
      await http.get(

        Uri.parse(
          "http://3.110.181.83:8000/collision",
        ),
      );

      if(response.statusCode
          ==200){

        final data=
        jsonDecode(
            response.body);

        if(!mounted){
          return;
        }

        setState(() {

          critical=
              data["collision"]
                  ??false;

          vehicleCount=

              data["vehicle_count"]
                  ?.toString()

                  ?? "0";

          speed=
              data["speed"]
                  ?.toString()
                  ??"--";

          threat=
              data["threat"]
                  ??"HIGH";

          latestEvent=
              data["event"]
                  ??"NORMAL";

          eventTime=
              data["time"]
                  ??"--:--:--";
        });
      }

    }catch(e){

      print(
          "Collision Error:$e");
    }
  }

  Future
  initWebRTC()
  async{

    try{

      await localRenderer
          .initialize();

      final config={

        "iceServers":[

          {
            "urls":
            "stun:stun.l.google.com:19302"
          }
        ]
      };

      peerConnection=

      await createPeerConnection(
          config);

      peerConnection!
          .onTrack=(event){

        if(event.streams
            .isNotEmpty){
            
          setState(() {
            localRenderer
                .srcObject=

            event.streams[0];
          });

          print(
              "FCW STREAM RECEIVED");
        }
      };

      await peerConnection!.addTransceiver(
        kind: RTCRtpMediaType.RTCRtpMediaTypeVideo,
        init: RTCRtpTransceiverInit(direction: TransceiverDirection.RecvOnly),
      );

      final offer=

      await peerConnection!
          .createOffer();

      await peerConnection!
          .setLocalDescription(
          offer);

      final response=

      await http.post(

        Uri.parse(
          "http://3.110.181.83:8889/fcw/whep",
        ),

        headers:{

          "Content-Type":
          "application/sdp",
          
          "Accept": 
          "application/sdp"
        },

        body: offer.sdp,
      );

      print(
          "Response code:"
              "${response.statusCode}");

      if(response.statusCode
          == 201 || response.statusCode == 200){

        await peerConnection!
            .setRemoteDescription(

          RTCSessionDescription(
            response.body,
            "answer",
          ),
        );

        print(
            "Connected FCW");
      } else {
        print("WebRTC failed: ${response.body}");
      }

    }catch(e){

      print(
          "FCW WebRTC Error:$e");
    }
  }

  @override
  void initState(){

    super.initState();

    getCollisionData();

    timer=
        Timer.periodic(

          const Duration(
              seconds:2),

              (_){

            getCollisionData();

          },
        );

    initWebRTC();
    _listenToMQTT();
  }

  void _listenToMQTT() {
    _connListener = () {
      if (mounted) setState(() => mqttConnected = MQTTService.isConnected.value);
    };
    MQTTService.isConnected.addListener(_connListener!);
    mqttConnected = MQTTService.isConnected.value;

    // Backend publishes FCW alerts to topic: "collision/alerts"
    _mqttSub = MQTTService.messageStream.listen((event) {
      final topic     = event["topic"] as String;
      final data      = event["data"]  as Map<String, dynamic>;
      final alertType = (data["alert_type"] ?? "") as String;

      // Only process collision/FCW alerts
      final isFcw = topic.contains("collision") ||
                    alertType.contains("COLLISION") ||
                    alertType.contains("FCW");
      if (!isFcw) return;

      print("[FCW page] Got alert on $topic: $alertType");

      if (mounted) {
        setState(() {
          critical     = alertType.contains("CRITICAL") || alertType.contains("WARNING");
          latestEvent  = alertType.isNotEmpty ? alertType : latestEvent;
          eventTime    = data["timestamp"] ?? eventTime;
          if (data["vehicle_count"] != null)
            vehicleCount = data["vehicle_count"].toString();
          if (data["speed"] != null)
            speed = data["speed"].toString();
          if (data["threat"] != null)
            threat = data["threat"].toString();

          // Add to live alerts feed
          liveAlerts.insert(0, {
            "type":     alertType,
            "device":   data["device_id"] ?? "IMAS_001",
            "time":     data["timestamp"] ?? "--",
            "vehicles": data["vehicle_count"]?.toString() ?? "0",
            "threat":   data["threat"]?.toString() ?? threat,
          });
          if (liveAlerts.length > 20) liveAlerts.removeLast();
        });
      }
    });
  }

  @override
  void dispose(){

    timer?.cancel();
    _mqttSub?.cancel();
    if (_connListener != null) MQTTService.isConnected.removeListener(_connListener!);

    peerConnection
        ?.close();

    localRenderer
        .dispose();

    super.dispose();
  }

  Widget metricCard(
      IconData icon,
      String value,
      String title,
      Color color){

    return Expanded(

      child:Container(

        height:150,

        margin:
        const EdgeInsets.only(
            right:10),

        padding:
        const EdgeInsets.all(15),

        decoration:
        BoxDecoration(

          color:
          const Color(
              0xFF081B31),

          borderRadius:
          BorderRadius.circular(
              25),

          border:
          Border.all(

            color:
            color.withOpacity(.2),
          ),
        ),

        child:Column(

          mainAxisAlignment:
          MainAxisAlignment
              .spaceEvenly,

          children:[

            Icon(
              icon,
              color:color,
              size:30,
            ),

            Text(

              value,

              textAlign:
              TextAlign.center,

              style:
              TextStyle(

                color:color,

                fontSize:18,

                fontWeight:
                FontWeight.bold,
              ),
            ),

            Text(

              title,

              style:
              const TextStyle(
                  color:
                  Colors.grey),
            )
          ],
        ),
      ),
    );
  }

  Color _fcwColor(String type) {
    switch (type) {
      case 'COLLISION_WARNING_CRITICAL':
      case 'COLLISION_WARNING':  return Colors.red;
      case 'FCW_CLOSE':          return Colors.orangeAccent;
      default:                   return Colors.amber;
    }
  }

  IconData _fcwIcon(String type) {
    switch (type) {
      case 'COLLISION_WARNING_CRITICAL': return Icons.car_crash;
      case 'COLLISION_WARNING':          return Icons.warning_rounded;
      case 'FCW_CLOSE':                  return Icons.directions_car;
      default:                           return Icons.warning_amber;
    }
  }

  Widget _fcwAlertRow(Map<String, dynamic> alert) {
    final String type = alert['type'] ?? 'COLLISION_WARNING';
    final Color c = _fcwColor(type);
    final IconData icon = _fcwIcon(type);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: c.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.withOpacity(0.5), width: 1.2),
        boxShadow: [
          BoxShadow(color: c.withOpacity(0.1), blurRadius: 8, spreadRadius: 1)
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
                  type.replaceAll('_', ' '),
                  style: TextStyle(
                    color: c,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '📟 ${alert["device"]}   🕐 ${alert["time"]}',
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
                if ((alert['vehicles'] ?? '0') != '0') ...[
                  const SizedBox(height: 2),
                  Text(
                    '🚗 Vehicles: ${alert["vehicles"]}   ⚡ Threat: ${alert["threat"]}',
                    style: TextStyle(color: c.withOpacity(0.8), fontSize: 11),
                  ),
                ],
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: c.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'FCW',
              style: TextStyle(color: c, fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(
      BuildContext context){

    return Scaffold(

      backgroundColor:
      Colors.black,

      appBar: AppBar(

        elevation:0,

        backgroundColor:
        Colors.black,

        leading:
        IconButton(

          onPressed:(){

            Navigator.pop(
                context);

          },

          icon:
          const Icon(

            Icons.arrow_back_ios,

            color:
            Colors.white,
          ),
        ),

        title:
        const Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children:[

            Text(

              "FCW LIVE",

              style:
              TextStyle(

                color:
                Colors.white,

                fontWeight:
                FontWeight.bold,
              ),
            ),

            Text(

              "Forward Collision Warning",

              style:
              TextStyle(

                color:
                Colors.grey,

                fontSize:12,
              ),
            )
          ],
        ),

        actions:[

          Container(

            margin:
            const EdgeInsets.only(
                right:15),

            padding:
            const EdgeInsets.symmetric(

              horizontal:15,
              vertical:8,
            ),

            decoration:
            BoxDecoration(

              color:
              Colors.orange
                  .withOpacity(.15),

              borderRadius:
              BorderRadius.circular(
                  15),
            ),

            child:
            ValueListenableBuilder(

              valueListenable:
              MQTTService.isConnected,

              builder:
                  (context,
                  connected,
                  child){

                return Row(

                  children:[

                    Icon(

                      Icons.circle,

                      color:

                      connected
                          ? Colors.green
                          : Colors.red,

                      size:10,
                    ),

                    const SizedBox(
                        width:8),

                    Text(

                      connected
                          ? "ONLINE"
                          : "OFFLINE",

                      style:
                      TextStyle(

                        color:

                        connected
                            ? Colors.green
                            : Colors.red,
                      ),
                    )
                  ],
                );
              },
            ),
          )
        ],
      ),

      body:
      SingleChildScrollView(

        padding:
        const EdgeInsets.all(20),

        child:
        Column(

          children:[

            Container(

              height:250,

              decoration:
              BoxDecoration(

                color:
                const Color(
                    0xFF071D31),

                borderRadius:
                BorderRadius.circular(
                    25),
              ),

              child:
              ClipRRect(

                borderRadius:
                BorderRadius.circular(
                    25),

                child:
                RTCVideoView(
                    localRenderer),
              ),
            ),

            const SizedBox(
                height:25),

            Row(

              children:[

                metricCard(

                  Icons.local_shipping,

                  vehicleCount,

                  "Vehicles",

                  Colors.cyanAccent,
                ),

                metricCard(
                  Icons.speed,
                  speed,
                  "Speed",
                  Colors.deepPurpleAccent,
                ),

                metricCard(
                  Icons.warning,
                  threat,
                  "Threat",
                  Colors.pinkAccent,
                ),
              ],
            ),

            const SizedBox(
                height:25),

            Container(

              width:
              double.infinity,

              padding:
              const EdgeInsets.all(
                  25),

              decoration:
              BoxDecoration(

                borderRadius:
                BorderRadius.circular(
                    25),

                color:
                critical
                    ? Colors.red
                    : Colors.green,
              ),

              child:
              Center(

                child:
                Text(

                  critical
                      ? "IMMINENT COLLISION"
                      : "SAFE",

                  style:
                  const TextStyle(

                    color:
                    Colors.white,

                    fontSize:28,

                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // ── Live FCW Alerts ───────────────────────────────────────
            Row(
              children: [
                const Icon(Icons.bolt, color: Colors.orangeAccent, size: 18),
                const SizedBox(width: 8),
                const Text(
                  'LIVE ALERTS',
                  style: TextStyle(
                    color: Colors.orangeAccent,
                    letterSpacing: 3,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${liveAlerts.length} events',
                    style: const TextStyle(color: Colors.orangeAccent, fontSize: 12),
                  ),
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
                    border: Border.all(color: Colors.orange.withOpacity(0.1)),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.sensors, color: Colors.orangeAccent, size: 48),
                      const SizedBox(height: 14),
                      mqttConnected
                        ? const Text(
                            '🟢  Connected · Listening for FCW alerts…',
                            style: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          )
                        : const Text(
                            '🔴  MQTT Offline · Reconnecting…',
                            style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                      const SizedBox(height: 6),
                      const Text(
                        'Topic: collision/alerts',
                        style: TextStyle(color: Colors.grey, fontSize: 11, letterSpacing: 1),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: liveAlerts.map(_fcwAlertRow).toList(),
                ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}