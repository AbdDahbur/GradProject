import 'package:appointmentapp/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar(
      {Key? key, this.appTitile, this.route, this.icon, this.actions})
      : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(60);

  final String? appTitile;

  final String? route;

  final FaIcon? icon;

  final List<Widget>? actions;

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          widget.appTitile!,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        // if icon is not set , return null
        leading: widget.icon != null ? Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Config.primaryColor,
          ),
          child: IconButton(
            onPressed: () {
              //if route is given , then this icon will navigate to that route
              if (widget.route != null) {
                Navigator.of(context).pushNamed(widget.route!);
              } else {
                //else , just simply pop back to previos page
                Navigator.of(context).pop();
              }
            },
            icon: widget.icon!,
            iconSize: 16,
            color: Colors.white,
          ),
        )
            : null ,
    // if action is not set , return null
    actions: widget.actions ?? null,
    );
  }
}
