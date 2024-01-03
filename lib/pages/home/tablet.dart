
import 'package:flutter/material.dart';

class HomePageTablet extends StatelessWidget {
  const HomePageTablet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: IndexedStack(
        children: [
          Center(
            child: Container(),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(),
      ),
    );
  }
}
