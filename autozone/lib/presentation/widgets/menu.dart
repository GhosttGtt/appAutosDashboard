import 'package:autozone/presentation/theme/colors.dart';
import 'package:autozone/routes/routes.dart';
import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  const Menu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 8,
        bottom: 8,
      ),
      child: SafeArea(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image(
              image: const AssetImage('assets/images/logoIcon.png'),
              height: 20,
            ),
            IconButton(
              icon: const Icon(Icons.shopping_cart_outlined),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.sales,
                );
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.messenger_outline_sharp,
                color: autoPrimaryColor,
              ),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.newMessages,
                );
              },
            ),
            /*  */
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openEndDrawer(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
