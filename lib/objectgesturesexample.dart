import 'package:ar_anime_waifu/model_model.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/models/ar_anchor.dart';
import 'package:flutter/material.dart';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/datatypes/hittest_result_types.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:ar_flutter_plugin/models/ar_hittest_result.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

class ObjectGesturesWidget extends StatefulWidget {
  const ObjectGesturesWidget({Key? key}) : super(key: key);
  @override
  _ObjectGesturesWidgetState createState() => _ObjectGesturesWidgetState();
}

class _ObjectGesturesWidgetState extends State<ObjectGesturesWidget> {


  bool _showFeaturePoints = false;
  bool _showPlanes = true;
  bool _showWorldOrigin = false;
  bool _planeTexturePathUse = false;
  bool _showSettings = false;
  final String _planeTexturePath = "Images/triangle.png";

  List<Model> models = [
    Model(
      "2CylinderEngine",
      "https://github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/2CylinderEngine/glTF-Binary/2CylinderEngine.glb",
      "https://github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/2CylinderEngine/screenshot/screenshot.png"
    ),
    Model(
      "AnimatedMorphCube",
        "https://github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/AnimatedMorphCube/glTF-Binary/AnimatedMorphCube.glb",
        "https://github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/AnimatedMorphCube/screenshot/screenshot.gif"
    ),
    Model(
        "AntiqueCamera",
        "https://github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/AntiqueCamera/glTF-Binary/AntiqueCamera.glb",
        "https://github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/AntiqueCamera/screenshot/screenshot.png"
    ),
    Model(
        "BrainStem",
        "https://github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/BrainStem/glTF-Binary/BrainStem.glb",
        "https://github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/BrainStem/screenshot/screenshot.gif"
    ),
    Model(
        "Fox",
        "https://github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/Fox/glTF-Binary/Fox.glb",
        "https://github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/Fox/screenshot/screenshot.jpg"
    ),
    Model(
        "Duck",
        "https://github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/Duck/glTF-Binary/Duck.glb",
        "https://github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/Duck/screenshot/screenshot.png"
    ),
    Model(
        "Lantern",
        "https://github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/Lantern/glTF-Binary/Lantern.glb",
        "https://github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/Lantern/screenshot/screenshot.jpg"
    ),
    Model(
        "SheenChair",
        "https://github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/SheenChair/glTF-Binary/SheenChair.glb",
        "https://github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/SheenChair/screenshot/screenshot-large.jpg"
    ),
    Model(
        "ToyCar",
        "https://github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/ToyCar/glTF-Binary/ToyCar.glb",
        "https://github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/ToyCar/screenshot/screenshot_large.jpg"
    ),

  ];

  Model currentModel = Model(
      "2CylinderEngine",
      "https://github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/2CylinderEngine/glTF-Binary/2CylinderEngine.glb",
      ""
  );

  late ARSessionManager arSessionManager;
  late ARObjectManager arObjectManager;
  late ARAnchorManager arAnchorManager;

  List<ARNode> nodes = [];
  List<ARAnchor> anchors = [];

  @override
  void dispose() {
    super.dispose();
    arSessionManager.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: Stack(children: [
          ARView(
            onARViewCreated: onARViewCreated,
            planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
          ),
          _showSettings ? SafeArea(
            child: Align(
              alignment: FractionalOffset.topRight,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.5,
                color: const Color(0x0fffffff).withOpacity(0.5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            _showSettings = !_showSettings;
                          });
                        },
                        icon: const Icon(Icons.close)),
                    SwitchListTile(
                      title: const Text('Feature Points'),
                      value: _showFeaturePoints,
                      onChanged: (bool value) {
                        setState(() {
                          _showFeaturePoints = value;
                          updateSessionSettings();
                        });
                      },
                    ),

                    SwitchListTile(
                      title: const Text('Planes'),
                      value: _showPlanes,
                      onChanged: (bool value) {
                        setState(() {
                          _showPlanes = value;
                          updateSessionSettings();
                        });
                      },
                    ),
                    SwitchListTile(
                      title: const Text('World Origin'),
                      value: _showWorldOrigin,
                      onChanged: (bool value) {
                        setState(() {
                          _showWorldOrigin = value;
                          updateSessionSettings();
                        });
                      },
                    ),
                    SwitchListTile(
                      title: Text('Plane Texture'),
                      value: _planeTexturePathUse,
                      onChanged: (bool value) {
                        setState(() {
                          _planeTexturePathUse = value;
                          updateSessionSettings();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ) : SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: IconButton(
                    onPressed: () {
                      setState(() {
                        _showSettings = !_showSettings;
                      });
                    },
                    icon: const Icon(Icons.settings, color: Colors.blue,)),
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: IconButton(
                    onPressed: () {
                      setState(() {
                        Navigator.pop(context);
                      });
                    },
                    icon: const Icon(Icons.chevron_left, color: Colors.blue,)),
              ),
            ),
          ),
          Align(
            alignment: FractionalOffset.bottomCenter,
            child: SizedBox(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [


                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: models.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ChoiceChip(
                            selectedColor: Colors.blue,
                            labelPadding: const EdgeInsets.all(0),
                            label: CircleAvatar(
                              radius: 28,
                              backgroundImage: NetworkImage(
                                models[index].image
                              ),
                            ),
                            selected: currentModel == models[index],
                            onSelected: (bool selected) {
                              setState(() {
                                currentModel = models[index];
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),

                  /// Remove
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.redAccent),
                          ),
                          onPressed: onRemoveEverything,
                          icon: const Icon(Icons.delete_forever),
                          label: const Text("Удалить все")),
                      ]),
                  const SizedBox(height: 15)

                ],

              ),
            ),
          )
        ]));
  }

  void onARViewCreated(
      ARSessionManager arSessionManager,
      ARObjectManager arObjectManager,
      ARAnchorManager arAnchorManager,
      ARLocationManager arLocationManager) {
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;
    this.arAnchorManager = arAnchorManager;

    this.arSessionManager.onInitialize(
      showFeaturePoints: _showFeaturePoints,
      showPlanes: _showPlanes,
      customPlaneTexturePath: _planeTexturePathUse ? _planeTexturePath : null,
      showWorldOrigin: _showWorldOrigin,
      handlePans: true,
      handleRotation: true,
    );
    this.arObjectManager.onInitialize();

    this.arSessionManager.onPlaneOrPointTap = onPlaneOrPointTapped;
    this.arObjectManager.onPanStart = onPanStarted;
    this.arObjectManager.onPanChange = onPanChanged;
    this.arObjectManager.onPanEnd = onPanEnded;
    this.arObjectManager.onRotationStart = onRotationStarted;
    this.arObjectManager.onRotationChange = onRotationChanged;
    this.arObjectManager.onRotationEnd = onRotationEnded;
  }

  Future<void> onRemoveEverything() async {
    /*nodes.forEach((node) {
      this.arObjectManager.removeNode(node);
    });*/
    anchors.forEach((anchor) {
      arAnchorManager.removeAnchor(anchor);
    });
    anchors = [];
  }

  Future<void> onPlaneOrPointTapped(
      List<ARHitTestResult> hitTestResults) async {
    var singleHitTestResult = hitTestResults.firstWhere(
            (hitTestResult) => hitTestResult.type == ARHitTestResultType.plane);
    if (singleHitTestResult != null) {
      var newAnchor =
      ARPlaneAnchor(transformation: singleHitTestResult.worldTransform);
      bool? didAddAnchor = await arAnchorManager.addAnchor(newAnchor);
      if (didAddAnchor!) {
        anchors.add(newAnchor);
        // Add note to anchor
        var newNode = ARNode(
            type: NodeType.webGLB,
            uri: currentModel.modelGLB,
            scale: Vector3(0.2, 0.2, 0.2),
            position: Vector3(0.0, 0.0, 0.0),
            rotation: Vector4(1.0, 0.0, 0.0, 0.0));
        bool? didAddNodeToAnchor =
        await arObjectManager.addNode(newNode, planeAnchor: newAnchor);
        if (didAddNodeToAnchor!) {
          nodes.add(newNode);
        } else {
          arSessionManager.onError("Adding Node to Anchor failed");
        }
      } else {
        arSessionManager.onError("Adding Anchor failed");
      }
    }
  }

  onPanStarted(String nodeName) {
    print("Started panning node " + nodeName);
  }

  onPanChanged(String nodeName) {
    print("Continued panning node " + nodeName);
  }

  onPanEnded(String nodeName, Matrix4 newTransform) {
    print("Ended panning node " + nodeName);
    final pannedNode =
    nodes.firstWhere((element) => element.name == nodeName);

    /*
    * Uncomment the following command if you want to keep the transformations of the Flutter representations of the nodes up to date
    * (e.g. if you intend to share the nodes through the cloud)
    */
    //pannedNode.transform = newTransform;
  }

  onRotationStarted(String nodeName) {
    print("Started rotating node " + nodeName);
  }

  onRotationChanged(String nodeName) {
    print("Continued rotating node " + nodeName);
  }

  onRotationEnded(String nodeName, Matrix4 newTransform) {
    print("Ended rotating node " + nodeName);
    final rotatedNode =
    nodes.firstWhere((element) => element.name == nodeName);

    /*
    * Uncomment the following command if you want to keep the transformations of the Flutter representations of the nodes up to date
    * (e.g. if you intend to share the nodes through the cloud)
    */
    //rotatedNode.transform = newTransform;
  }

  void updateSessionSettings() {
    arSessionManager.onInitialize(
      showFeaturePoints: _showFeaturePoints,
      showPlanes: _showPlanes,
      showWorldOrigin: _showWorldOrigin,
      showAnimatedGuide: false,
      customPlaneTexturePath: _planeTexturePathUse ? _planeTexturePath : null,
      handlePans: true,
      handleRotation: true,
    );
  }

}