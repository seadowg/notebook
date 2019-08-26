// Imports the Flutter Driver API.
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Notebook', () {
    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('can open app', () async {
      await driver.waitFor(find.text('Notebook'));
    });

    test('can add notes', () async {
      await driver.tap(find.byTooltip('Add Note'));
      await driver.waitFor(find.text('New Note'));
      await driver.enterText('76');
      await driver.tap(find.pageBack());

      await driver.waitFor(find.byTooltip('Add Note'));
      await driver.waitFor(find.text('76'));

      await driver.tap(find.byTooltip('Add Note'));
      await driver.waitFor(find.text('New Note'));
      await driver.enterText('Frank Bowling');
      await driver.tap(find.pageBack());

      await driver.waitFor(find.byTooltip('Add Note'));
      await driver.waitFor(find.text('76'));
      await driver.waitFor(find.text('Frank Bowling'));
    });

    test('can edit note', () async {
      await driver.tap(find.byTooltip('Add Note'));
      await driver.waitFor(find.text('New Note'));
      await driver.enterText('I AM NOTE');
      await driver.tap(find.pageBack());

      await driver.waitFor(find.byTooltip('Add Note'));
      await driver.tap(find.text("I AM NOTE"));

      await driver.waitFor(find.text('Edit Note'));
      await driver.enterText('EDITED');
      await driver.tap(find.pageBack());

      await driver.waitFor(find.byTooltip('Add Note'));
      await driver.waitFor(find.text('EDITED'));
      await driver.waitForAbsent(find.text('I AM NOTE'));
    });
  });
}
