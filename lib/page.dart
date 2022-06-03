import 'package:flutter/material.dart';

// import 'package:myapp/auth/auth_state.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
// import 'package:intl/intl.dart';
// import 'package:collection/collection.dart';
// import 'package:myapp/src/pages/index.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:map/map.dart';
// import 'package:latlng/latlng.dart';
// import 'package:paged_vertical_calendar/paged_vertical_calendar.dart';

class PageEntryPoint extends StatefulWidget {
  const PageEntryPoint({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _StateEntryPoint createState() => _StateEntryPoint();
}

class _StateEntryPoint extends State<PageEntryPoint> {
  final datasets = <String, dynamic>{};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: Container(
          margin: EdgeInsets.zero,
          padding: EdgeInsets.zero,
          width: double.maxFinite,
          decoration: const BoxDecoration(
            color: Color(0xFF055617),
            border: Border(
              left: BorderSide(
                  width: 0, style: BorderStyle.none, color: Color(0xFF000000)),
              top: BorderSide(
                  width: 0, style: BorderStyle.none, color: Color(0xFF000000)),
              right: BorderSide(
                  width: 0, style: BorderStyle.none, color: Color(0xFF000000)),
              bottom: BorderSide(
                  width: 0, style: BorderStyle.none, color: Color(0xFF000000)),
            ),
          ),
        ),
      ),
      backgroundColor: const Color(0xFF000000),
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            width: double.maxFinite,
            decoration: const BoxDecoration(
              color: Color(0xFFF0F4F1),
              border: Border(
                left: BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                    color: Color(0xFF000000)),
                top: BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                    color: Color(0xFF000000)),
                right: BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                    color: Color(0xFF000000)),
                bottom: BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                    color: Color(0xFF000000)),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 400,
                  height: 330,
                  child: Card(
                    elevation: 1,
                    color: Color(0xFF000000),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                      ),
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 55,
                      ),
                      child: Icon(
                        MdiIcons.fromString('account'),
                        size: 80,
                        color: const Color(0xFF000000),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 65,
                        top: 55,
                      ),
                      child: Icon(
                        MdiIcons.fromString('account'),
                        size: 80,
                        color: const Color(0xFF000000),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 70,
                        top: 55,
                      ),
                      child: Icon(
                        MdiIcons.fromString('account'),
                        size: 80,
                        color: const Color(0xFF000000),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 55,
                      ),
                      child: Icon(
                        MdiIcons.fromString('account'),
                        size: 80,
                        color: const Color(0xFF000000),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 65,
                        top: 5,
                      ),
                      child: Icon(
                        MdiIcons.fromString('account'),
                        size: 80,
                        color: const Color(0xFF000000),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 70,
                        top: 55,
                      ),
                      child: Icon(
                        MdiIcons.fromString('account'),
                        size: 80,
                        color: const Color(0xFF000000),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // BottomBar
          Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                width: double.maxFinite,
                decoration: const BoxDecoration(
                  color: Color(0xFF055617),
                  border: Border(
                    left: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                        color: Color(0xFF000000)),
                    top: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                        color: Color(0xFF000000)),
                    right: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                        color: Color(0xFF000000)),
                    bottom: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                        color: Color(0xFF000000)),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
