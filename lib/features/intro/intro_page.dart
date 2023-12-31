import 'package:flutter/material.dart';
import 'package:fineas/core/widgets/lava/lava_clock.dart';
import 'package:fineas/core/common.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:fineas/core/widgets/fineas_widget.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      desktop: (p0) => const IntroBigScreenWidget(),
      tablet: (p0) => const IntroTabletWidget(),
      mobile: (p0) => const IntroMobileWidget(),
    );
  }
}

class IntroTabletWidget extends StatelessWidget {
  const IntroTabletWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FineasAnnotatedRegionWidget(
      color: Colors.transparent,
      child: ColoredBox(
        color: context.surface,
        child: LavaAnimation(
          color: context.primaryContainer,
          child: Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              toolbarHeight: 0,
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        const FineasIcon(size: 52),
                        Text(
                          language["appTitle"],
                          textAlign: TextAlign.center,
                          style: context.displayMedium?.copyWith(
                            color: context.onSurface.withOpacity(0.75),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      language["intoTitle"],
                      textAlign: TextAlign.center,
                      style: context.headlineMedium?.copyWith(
                        color: context.secondary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Column(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(
                            Icons.check_circle,
                            color: context.primary,
                          ),
                          dense: true,
                          title: Text(
                            language["intoSummary1"],
                            style: context.titleMedium,
                          ),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(
                            Icons.check_circle,
                            color: context.primary,
                          ),
                          dense: true,
                          title: Text(
                            language["intoSummary2"],
                            style: context.titleMedium,
                          ),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(
                            Icons.check_circle,
                            color: context.primary,
                          ),
                          dense: true,
                          title: Text(
                            language["intoSummary3"],
                            style: context.titleMedium,
                          ),
                        )
                      ],
                    ),
                    const Spacer(),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      title: Text(
                        language["usageWarning"],
                        style: context.titleSmall?.copyWith(
                          color: context.bodySmall?.color,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            bottomNavigationBar: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 28.0, vertical: 24),
                child: FineasBigButton(
                  onPressed: () {},
                  title: language["introCTA"],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class IntroBigScreenWidget extends StatelessWidget {
  const IntroBigScreenWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FineasAnnotatedRegionWidget(
      color: context.background,
      child: Material(
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(52.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 24),
                          child: Icon(
                            Icons.wallet,
                            size: 52,
                            color: context.primary,
                          ),
                        ),
                        Text(
                          language["appTitle"],
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(
                                color: context.primary,
                              ),
                        ),
                      ],
                    ),
                    Text(
                      language["intoTitle"],
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(color: context.onSurface),
                    ),
                    const SizedBox(height: 24),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(
                            Icons.check_circle,
                            color: context.primary,
                          ),
                          dense: true,
                          title: Text(
                            language["intoSummary1"],
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                          ),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(
                            Icons.check_circle,
                            color: context.primary,
                          ),
                          dense: true,
                          title: Text(
                            language["intoSummary2"],
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                          ),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(
                            Icons.check_circle,
                            color: context.primary,
                          ),
                          dense: true,
                          title: Text(
                            language["intoSummary3"],
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                          ),
                        ),
                        const SizedBox(height: 24),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          title: Text(
                            language["usageWarning"],
                            style: context.titleSmall?.copyWith(
                              color: context.bodySmall?.color,
                            ),
                          ),
                        ),
                        FineasBigButton(
                          title: language["introCTA"],
                          onPressed: () => {}
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: LavaAnimation(
                    color: context.primaryContainer,
                    child: const SizedBox.shrink(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IntroMobileWidget extends StatelessWidget {
  const IntroMobileWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FineasAnnotatedRegionWidget(
      color: context.background,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          toolbarHeight: 0,
        ),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: LavaAnimation(
            color: context.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    language["appTitle"],
                    style: context.displayMedium?.copyWith(
                      color: context.primary,
                    ),
                  ),
                  Text(
                    language["intoTitle"],
                    style: context.headlineSmall?.copyWith(
                      color: context.secondary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Column(
                    children: [
                      IntroTextWidget(title: language["intoSummary1"]),
                      IntroTextWidget(title: language["intoSummary2"]),
                      IntroTextWidget(title: language["intoSummary3"]),
                    ],
                  ),
                  const Spacer(),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    title: Text(
                      language["usageWarning"],
                      style: context.titleSmall?.copyWith(
                        color: context.bodySmall?.color,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 24),
            child: FineasBigButton(
              onPressed: () {},
              title: language["introCTA"],
            ),
          ),
        ),
      ),
    );
  }
}

class IntroTextWidget extends StatelessWidget {
  const IntroTextWidget({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        Icons.check_circle,
        color: context.primary,
      ),
      dense: true,
      title: Text(
        title,
        style: context.titleMedium,
      ),
    );
  }
}
