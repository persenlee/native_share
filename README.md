# native_share

A Flutter plugin to share content from your Flutter app via the platform's share dialog.

Wraps the ACTION_SEND Intent on Android and UIActivityViewController on iOS.

## Usage

To use this plugin, add `native_share` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

## Example

Import the library via

```dart
import 'package:share/share.dart';
```

Then invoke the static `share` method anywhere in your Dart code

```dart
NativeShare.share({'title':'Plugin example app','url':'https://github.com/flutter'});
```



ios

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
    <key>NSAllowsArbitraryLoadsForMedia</key>
    <true/>
    <key>NSAllowsArbitraryLoadsInWebContent</key>
    <true/>
    <key>NSAllowsLocalNetworking</key>
    <true/>
</dict>
```

