import 'package:gazelle_core/gazelle_core.dart';
import 'package:gazelle_hosting_plugin/gazelle_hosting_plugin.dart';

void main() async {
  final app = GazelleApp(
    // add static hosting plugin
    plugins: [StaticHostingPlugin()],
    port: 3001,
    routes: [],
  );

  await app.start();
  print("Static hosting plugin example started on port 3002");
}
