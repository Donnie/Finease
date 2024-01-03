
import 'package:flutter/material.dart';

class HomePageMobile extends StatelessWidget {
  const HomePageMobile({
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
