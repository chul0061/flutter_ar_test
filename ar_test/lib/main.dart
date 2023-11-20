import 'package:flutter/material.dart';
import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

void main() => runApp(MaterialApp(home: CustomObjectPage()));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ARKitController arkitController;

  @override
  void dispose() {
    arkitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      Scaffold(appBar: AppBar(title: const Text('ARKit in Flutter')), body: ARKitSceneView(onARKitViewCreated: onARKitViewCreated));

  void onARKitViewCreated(ARKitController arkitController) {
    this.arkitController = arkitController;
    // final node = ARKitNode(geometry: ARKitSphere(radius: 0.1), position: Vector3(0, 0, -0.5));
    // ARKitMd
    final node = ARKitReferenceNode(url: "assets/pancakes.usdz", scale: vector.Vector3.all(50));
    this.arkitController.add(node);
  }
}

class CustomObjectPage extends StatefulWidget {
  @override
  _CustomObjectPageState createState() => _CustomObjectPageState();
}
aaaaa
class _CustomObjectPageState extends State<CustomObjectPage> {
  late ARKitController arkitController;
  ARKitReferenceNode? node;

  @override
  void dispose() {
    arkitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('AR Test')),
        body: Container(
          child: ARKitSceneView(
            enablePinchRecognizer: true,
            enablePanRecognizer: true,
            showFeaturePoints: false,
            planeDetection: ARPlaneDetection.horizontal,
            onARKitViewCreated: onARKitViewCreated,
          ),
        ),
      );

  void onARKitViewCreated(ARKitController arkitController) {
    this.arkitController = arkitController;
    arkitController.addCoachingOverlay(CoachingOverlayGoal.horizontalPlane);
    arkitController.onAddNodeForAnchor = _handleAddAnchor;
  }

  void _handleAddAnchor(ARKitAnchor anchor) {
    if (anchor is ARKitPlaneAnchor) {
      _addPlane(arkitController, anchor);
    }
  }

  void _addPlane(ARKitController controller, ARKitPlaneAnchor anchor) {
    print("노드 추가");
    if (node != null) {
      controller.remove(node!.name);
    }
    print("노드 추가 중");
    node = ARKitReferenceNode(
      url: 'models.scnassets/Chest.usdz',
      scale: vector.Vector3.all(0.0001),
    );
    controller.add(node!, parentNodeName: anchor.nodeName);
  }
}
