import 'package:bears_video/common/widgets/app_bubble_dialog.dart';
import 'package:bears_video/common/widgets/app_button.dart';
import 'package:bears_video/common/widgets/app_text_field.dart';
import 'package:bears_video/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app(Widget child) => MaterialApp(
  theme: buildAppTheme(),
  home: Scaffold(body: Center(child: child)),
);

void main() {
  testWidgets('AppButton invokes its action without a Material ink control', (
    tester,
  ) async {
    var presses = 0;
    await tester.pumpWidget(
      _app(AppButton(onPressed: () => presses++, child: const Text('播放'))),
    );

    expect(find.byType(InkWell), findsNothing);
    await tester.tap(find.text('播放'));
    await tester.pumpAndSettle();
    expect(presses, 1);
  });

  testWidgets('AppTextField accepts focus and input', (tester) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      _app(AppTextField(controller: controller, hintText: '搜索视频')),
    );
    await tester.tap(find.byType(TextField));
    await tester.enterText(find.byType(TextField), '熊');
    await tester.pump();

    expect(controller.text, '熊');
    expect(find.text('熊'), findsOneWidget);
  });

  testWidgets('confirmation bubble returns the selected result', (
    tester,
  ) async {
    bool? result;
    await tester.pumpWidget(
      _app(
        Builder(
          builder: (context) => AppButton(
            onPressed: () async {
              result = await showAppConfirmationBubble(
                context: context,
                title: '清空记录',
                message: '确定要清空吗？',
                destructive: true,
              );
            },
            child: const Text('打开'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('打开'));
    await tester.pumpAndSettle();
    expect(find.byType(AppBubbleSurface), findsOneWidget);

    await tester.tap(find.text('确定'));
    await tester.pumpAndSettle();
    expect(result, isTrue);
  });
}
