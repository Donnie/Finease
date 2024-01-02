import 'package:flutter/material.dart';

import 'package:finease/core/common.dart';
import 'package:finease/parts/export.dart';
import 'package:finease/parts/intro_top.dart';

class IntroSetNameWidget extends StatelessWidget {
  const IntroSetNameWidget({
    super.key,
    required this.formState,
    required this.nameController,
  });

  final GlobalKey<FormState> formState;
  final TextEditingController nameController;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IntroTopWidget(
            titleWidget: RichText(
              text: TextSpan(
                style: context.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.onSurface,
                  letterSpacing: 0.8,
                ),
                text: language["welcome"],
                children: [
                  TextSpan(
                    text: ' ${language["appTitle"]}',
                    style: TextStyle(
                      color: context.primary,
                    ),
                  )
                ],
              ),
            ),
            icon: Icons.wallet,
            description: language["welcomeDesc"],
          ),
          FractionallySizedBox(
            widthFactor: 0.8,
            child: Form(
              key: formState,
              child: AppTextFormField(
                key: const Key('user_name_textfield'),
                controller: nameController,
                hintText: language["enterNameHint"],
                label: language["nameHint"],
                keyboardType: TextInputType.name,
                validator: (val) {
                  if (val!.isNotEmpty) {
                    return null;
                  } else {
                    return language["enterNameHint"];
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
