import 'package:flutter/material.dart';

class CustomDynamicAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const CustomDynamicAppBar({
    Key? key,
    required this.title,
    required this.actions,
    this.backgroundColor,
    this.elevation = 4.0,
    this.iconSize = 24.0,
    this.iconColor,
    this.leadingIcon,
    this.onLeadingPressed,
    this.shadowColor,
    this.titleStyle,
  }) : super(key: key);

  final String title;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final double elevation;
  final double iconSize;
  final Color? iconColor;
  final Widget? leadingIcon;
  final VoidCallback? onLeadingPressed;
  final Color? shadowColor;
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
        ),
      ),
      centerTitle: true,
      backgroundColor:
          backgroundColor ?? Theme.of(context).appBarTheme.backgroundColor,
      elevation: elevation,
      shadowColor: shadowColor ?? Colors.black12,
      actions: actions,
      leading: leadingIcon != null
          ? IconButton(
              icon: leadingIcon!,
              onPressed: onLeadingPressed ?? () => Navigator.of(context).pop(),
            )
          : null,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 20.0);

  Widget customActionButton({
    required IconData icon,
    required VoidCallback onPressed,
    double? size,
    Color? color,
  }) {
    return IconButton(
      icon: Icon(icon, size: size ?? iconSize, color: color ?? iconColor),
      onPressed: onPressed,
    );
  }

  PreferredSizeWidget gradientAppBar(BuildContext context, List<Color> colors) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: AppBar(
          title: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: elevation,
          actions: actions,
        ),
      ),
    );
  }

  Widget roundedLeadingIcon() {
    return CircleAvatar(
      radius: 20,
      backgroundColor: iconColor ?? Colors.blueAccent,
      child:
          leadingIcon ?? Icon(Icons.menu, size: iconSize, color: Colors.white),
    );
  }

  Widget dynamicIconButton(IconData icon) {
    return IconButton(
      icon: Icon(icon, size: iconSize),
      onPressed: () {},
    );
  }

  Widget actionWithBadge(Widget icon, String badgeText) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        icon,
        Positioned(
          right: -4,
          top: -4,
          child: Container(
            padding: EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: Text(
              badgeText,
              style: TextStyle(color: Colors.white, fontSize: 10.0),
            ),
          ),
        ),
      ],
    );
  }

  Widget searchIcon() {
    return IconButton(
      icon:
          Icon(Icons.search, size: iconSize, color: iconColor ?? Colors.white),
      onPressed: () {},
    );
  }

  Widget customAppBarWidget(Widget widget) {
    return widget;
  }

  List<Widget> getConditionalActions(bool condition) {
    if (condition) {
      return [
        customActionButton(icon: Icons.settings, onPressed: () {}),
        searchIcon(),
      ];
    } else {
      return [
        customActionButton(icon: Icons.notifications, onPressed: () {}),
      ];
    }
  }

  TextStyle getDynamicTitleStyle(BuildContext context) {
    return titleStyle ??
        TextStyle(
          fontSize: 22.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
          letterSpacing: 1.2,
        );
  }
}
