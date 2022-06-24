import 'dart:io';
import 'dart:ui';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:lilac_machine_test/Helper/Constants.dart';
import 'package:lilac_machine_test/Helper/sharedPref.dart';
import 'package:lilac_machine_test/Helper/snackbar_toast_helper.dart';
import 'package:lilac_machine_test/Screens/ProfilePage.dart';
import 'package:lilac_machine_test/Widgets/DrawerWidget.dart';
import 'package:video_player/video_player.dart';

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  late VideoPlayerController _videoPlayerController1;
  ChewieController? _chewieController;
  var isDwnloading = false;
  var offLine = false;
  var imgg;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  Future<void> initializePlayer() async {
    var imageGet = await getSharedPrefrence(IMG);
    imgg = imageGet;
    var getPath = await getSharedPrefrence(VIDEOPATH);
    if (getPath == null) {
      _videoPlayerController1 = VideoPlayerController.network(videoLink);
    } else {
      showToastSuccess("Video found offline, Playing in offline.");
      _videoPlayerController1 = VideoPlayerController.file(File(getPath));
    }

    await Future.wait([
      _videoPlayerController1.initialize(),
    ]);
    _createChewieController();
    setState(() {});
  }

  Future<void> ree() async {
    var imageGet = await getSharedPrefrence(IMG);
    setState(() {
      imgg = imageGet;
    });
  }

  Future<void> addToCache() async {
    setState(() {
      isDwnloading = true;
    });
    var file = await DefaultCacheManager().getSingleFile(videoLink);
    var set = setSharedPrefrence(VIDEOPATH, file.path);
    setState(() {
      isDwnloading = false;
      offLine = true;
    });
    showToastSuccess("Download Complete!");
  }

  void _createChewieController() {
    _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController1,
        autoPlay: true,
        looping: true);
  }

  @override
  void dispose() {
    _videoPlayerController1.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(0.1),
          child: AppBar(elevation: 0, backgroundColor: Colors.white),
        ),
        drawer: const DrawerWidget(),
        body: Builder(
          builder: (context) => Column(
            children: [
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12)),
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: Center(
                      child: _chewieController != null &&
                              _chewieController!
                                  .videoPlayerController.value.isInitialized
                          ? Chewie(
                              controller: _chewieController!,
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                CircularProgressIndicator(),
                                SizedBox(height: 20),
                                Text('Loading'),
                              ],
                            ),
                    ),
                  ),
                  Positioned(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ProfilePage(refresh: ree)),
                          );
                        },
                        child: Container(
                            child: imgg != null
                                ? Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: FileImage(File(imgg)),
                                            fit: BoxFit.cover)))
                                : Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: Image.asset(
                                          "assets/profile.png",
                                          fit: BoxFit.cover,
                                        ).image)))),
                      ),
                      top: 10,
                      right: 10),
                  Positioned(
                      child: CircleAvatar(
                        backgroundColor: Colors.white54,
                        child: IconButton(
                          icon: const Icon(Icons.menu),
                          onPressed: () => Scaffold.of(context).openDrawer(),
                        ),
                      ),
                      top: 10,
                      left: 10),
                ],
              ),
              h(10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white,
                      ),
                      child: const Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Icon(Icons.arrow_back_ios,
                              size: 20, color: Colors.black)),
                    ),
                    GestureDetector(
                      onTap: () async {
                        var get = await addToCache();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12),
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Row(
                            children: [
                              const Icon(Icons.download_rounded,
                                  color: Colors.green),
                              w(5),
                              offLine == true
                                  ? Text("Downloaded",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16,
                                          color: Colors.black))
                                  : Text(
                                      isDwnloading == true
                                          ? "Downloading..."
                                          : "Download",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16,
                                          color: Colors.black)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white,
                      ),
                      child: const Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Icon(Icons.arrow_forward_ios,
                              size: 20, color: Colors.black)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    bool goBack = false;
    HapticFeedback.mediumImpact();

    _showDialog();

    return goBack;
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 10,
        title: const Text('Confirm Exit!'),
        titleTextStyle: const TextStyle(
            fontSize: 16, letterSpacing: 0.6, fontWeight: FontWeight.bold),
        content: const Text('Sure to exit?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              SystemNavigator.pop();
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }
}
