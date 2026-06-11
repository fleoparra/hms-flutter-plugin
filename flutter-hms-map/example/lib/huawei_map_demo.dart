/*
    Copyright 2020-2025. Huawei Technologies Co., Ltd. All rights reserved.

    Licensed under the Apache License, Version 2.0 (the "License")
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        https://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
*/

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:huawei_map/huawei_map.dart';

import 'package:huawei_map_example/custom_widgets/custom_action_bar.dart';
import 'package:huawei_map_example/custom_widgets/custom_dynamic_app_bar.dart';
import 'package:huawei_map_example/custom_widgets/custom_icon_button.dart';

class HuaweiMapDemo extends StatefulWidget {
  const HuaweiMapDemo({Key? key}) : super(key: key);

  @override
  State<HuaweiMapDemo> createState() => _HuaweiMapDemoState();
}

class _HuaweiMapDemoState extends State<HuaweiMapDemo> {
  static const LatLng _center = LatLng(41.012959, 28.997438);
  static const double _zoom = 12;

  late HuaweiMapController mapController;

  bool _cameraPosChanged = false;
  MapType _currentMapType = MapType.normal;
  bool _trafficEnabled = false;
  bool _isLocSourceActive = false;

  void _onMapCreated(HuaweiMapController controller) {
    mapController = controller;
  }

  void _moveCameraButtonPressed() {
    if (!_cameraPosChanged) {
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          const CameraPosition(
            bearing: 270.0,
            target: LatLng(51.5160895, -0.1294527),
            tilt: 45.0,
            zoom: 17.0,
          ),
        ),
      );
      _cameraPosChanged = !_cameraPosChanged;
    } else {
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          const CameraPosition(
            bearing: 0.0,
            target: _center,
            tilt: 0.0,
            zoom: 12.0,
          ),
        ),
      );
      _cameraPosChanged = !_cameraPosChanged;
    }
  }

  void _mapTypeButtonPressed() {
    setState(() {
      _currentMapType =
          _currentMapType == MapType.normal ? MapType.terrain : MapType.normal;
    });
  }

  void _trafficButtonPressed() {
    setState(() {
      if (_trafficEnabled) {
        _trafficEnabled = false;
      } else {
        _trafficEnabled = true;
      }
    });
  }

  void _stopAnimationButtonPressed() {
    mapController.stopAnimation();
  }

  void _toggleLocationSource() {
    setState(() {
      if (_isLocSourceActive) {
        mapController.deactivateLocationSource();

        _isLocSourceActive = false;
      } else {
        mapController.setLocationSource();

        _isLocSourceActive = true;
      }
    });
  }

  final List<String> logs = [];

  void addLog(String log) {
    setState(() {
      logs.add(log);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomDynamicAppBar(
        title: 'Huawei Map Options',
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Scaffold(
                      appBar: AppBar(),
                      body: SizedBox(
                        child: GestureDetector(
                          onDoubleTap: () {
                            setState(() {
                              logs.clear();
                            });
                          },
                          child: ListView.builder(
                            itemCount: logs.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 5),
                                child: SelectableText(
                                  '> ${logs[index]}',
                                  style: const TextStyle(color: Colors.black54),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  });
            },
            icon: Icon(Icons.logo_dev),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          HuaweiMap(
            initialCameraPosition: const CameraPosition(
              target: _center,
              zoom: _zoom,
            ),
            onMapCreated: _onMapCreated,
            mapType: _currentMapType,
            tiltGesturesEnabled: true,
            buildingsEnabled: true,
            compassEnabled: true,
            zoomControlsEnabled: true,
            rotateGesturesEnabled: true,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            padding: const EdgeInsets.only(bottom: 30.0),
            trafficEnabled: _trafficEnabled,
            logoPosition: HuaweiMap.LOWER_LEFT,
            logoPadding: const EdgeInsets.only(
              left: 15,
              bottom: 75,
              top: 5,
            ),
            myLocationStyle: MyLocationStyle(
                anchor: Offset(0.5, 0.5), radiusFillColor: Colors.red),
            onClick: (LatLng latLng) async {
              log('Map Clicked at ${latLng.lat} : ${latLng.lng}');
              addLog('Map Clicked at ${latLng.lat} : ${latLng.lng}');
              if (_isLocSourceActive) mapController.setLocation(latLng);
              double? res = await mapController.getScalePerPixel();
              log(res.toString(), name: "getScalePerPixel");
            },
            onLongPress: (LatLng latLng) {
              log('Map LongClicked at ${latLng.lat} : ${latLng.lng}');
              addLog('Map LongClicked at ${latLng.lat} : ${latLng.lng}');
            },
            onCameraMove: (CameraPosition pos) {
              log('onCameraMove: ${pos.target.lat} : ${pos.target.lng}');
              addLog('onCameraMove: ${pos.target.lat} : ${pos.target.lng}');
            },
            onCameraIdle: () {
              log('onCameraIdle');
              addLog('onCameraIdle');
            },
            onCameraMoveStarted: (int reason) {
              if (reason == HuaweiMap.REASON_API_ANIMATON) {
                log('onCameraMoveStarted - Reason: API Animation');
                addLog('onCameraMoveStarted - Reason: API Animation');
              } else if (reason == HuaweiMap.REASON_DEVELOPER_ANIMATION) {
                log('onCameraMoveStarted - Reason: Developer Animation');
                addLog('onCameraMoveStarted - Reason: Developer Animation');
              } else if (reason == HuaweiMap.REASON_GESTURE) {
                log('onCameraMoveStarted - Reason: Gesture');
                addLog('onCameraMoveStarted - Reason: Gesture');
              } else {
                log('onCameraMoveStarted - Reason: unknown');
                addLog('onCameraMoveStarted - Reason: unknown');
              }
            },
            onCameraMoveCanceled: () {
              log('onCameraMoveCanceled');
              addLog('onCameraMoveCanceled');
            },
            onPoiClick: (PointOfInterest pointOfInterest) {
              addLog(
                  'POI Clicked at  ${pointOfInterest.latLng!.lat} : ${pointOfInterest.latLng!.lng}, ${pointOfInterest.name}. Place ID: ${pointOfInterest.placeId}');
              log('POI Clicked at  ${pointOfInterest.latLng!.lat} : ${pointOfInterest.latLng!.lng}, ${pointOfInterest.name}. Place ID: ${pointOfInterest.placeId}');
            },
            onMyLocationClick: (Location location) {
              log(location.toMap().toString());
              addLog(location.toMap().toString());
            },
            onMyLocationButtonClick: (bool onMyLocationButtonClicked) {
              log(onMyLocationButtonClicked.toString());
              addLog(onMyLocationButtonClicked.toString());
            },
          ),
          CustomActionBar(
            children: <Widget>[
              CustomIconButton(
                icon: Icons.map,
                tooltip: 'Map Type',
                onPressed: _mapTypeButtonPressed,
              ),
              CustomIconButton(
                icon: Icons.traffic,
                tooltip: 'Traffic',
                onPressed: _trafficButtonPressed,
              ),
              CustomIconButton(
                icon: Icons.adjust,
                tooltip: 'Move Camera',
                onPressed: _moveCameraButtonPressed,
              ),
              CustomIconButton(
                icon: Icons.cancel_outlined,
                tooltip: 'Stop Animation',
                onPressed: _stopAnimationButtonPressed,
              ),
              CustomIconButton(
                icon: Icons.my_location,
                tooltip: 'Toggle Location Source',
                onPressed: _toggleLocationSource,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
