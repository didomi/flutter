import 'package:didomi_sdk_example/widgets/hide_widget.dart';
import 'package:didomi_sdk_example/widgets/initialize_widget_notice.dart';
import 'package:didomi_sdk_example/widgets/is_widget_visible.dart';
import 'package:didomi_sdk_example/widgets/show_widget.dart';
import 'package:flutter/material.dart';

void main() => runApp(SampleForWidgetTestsApp());

class SampleForWidgetTestsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: "Widget Tests",
        home: HomePage(),
      );
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Material(
        child: ListView(
          key: Key("components_list"),
          children: [
            InitializeWidgetNotice(),
            ShowWidget(),
            HideWidget(),
            IsWidgetVisible(),
          ],
        ),
      );
}
