import 'package:flutter/material.dart';
import 'package:fineas/core/common.dart';

class FineasIconTitle extends StatelessWidget {
  const FineasIconTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.wallet,
          color: context.primary,
          size: 32,
        ),
        const SizedBox(width: 16),
        Text(
          language["appTitle"],
          style: context.titleLarge?.copyWith(
            color: context.onBackground,
            fontWeight: FontWeight.w600,
          ),
        )
      ],
    );
  }
}

// class FineasTitle extends StatelessWidget {
//   const FineasTitle({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<HomeBloc, HomeState>(
//       buildWhen: (previous, current) => current is CurrentIndexState,
//       builder: (context, state) {
//         String title = PageType.home.name(context);
//         if (state is CurrentIndexState) {
//           title = BlocProvider.of<HomeBloc>(context)
//               .getPageFromIndex(state.currentPage)
//               .name(context);
//         }
//         return Text(
//           title,
//           style: context.titleLarge?.copyWith(
//             fontWeight: FontWeight.w600,
//             color: context.onBackground,
//           ),
//         );
//       },
//     );
//   }
// }

class FineasIcon extends StatelessWidget {
  const FineasIcon({
    super.key,
    this.size = 32,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.wallet,
      color: context.primary,
      size: size,
    );
  }
}
