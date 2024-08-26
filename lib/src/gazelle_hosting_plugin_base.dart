import 'dart:io';
import 'package:gazelle_core/gazelle_core.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_static/shelf_static.dart';

typedef ServeFunction = Future<HttpServer> Function(
    Handler handler, Object address, int port);

class StaticHostingPlugin extends GazellePlugin {
  final String address;
  final int port;
  final Directory Function() directoryFactory;
  final ServeFunction serveFunction;

  StaticHostingPlugin({
    this.address = 'localhost',
    this.port = 8080,
    Directory Function()? directoryFactory,
    ServeFunction? serveFunction,
  })  : directoryFactory = directoryFactory ?? (() => Directory('web')),
        serveFunction = serveFunction ?? io.serve;

  @override
  Future<void> initialize(GazelleContext context) async {
    var webDir = directoryFactory();
    var handler = createRootHandler(webDir);

    List<String> links = [];
    bool hasFiles = false;

    void collectLinks(Directory dir, String basePath) {
      for (var entity in dir.listSync()) {
        if (entity is File) {
          var relativePath =
              '/${entity.uri.pathSegments[entity.uri.pathSegments.length - 2]}';
          var link = 'http://$address:$port${relativePath}';
          links.add(link);
          hasFiles = true;
        } else if (entity is Directory) {
          collectLinks(entity,
              entity.uri.pathSegments[entity.uri.pathSegments.length - 2]);
        }
      }
    }

    collectLinks(webDir, '');

    if (!hasFiles) {
      print("Error: No files available to host. Server will not start.");
      return;
    }

    var server = await serveFunction(handler, address, port);
    print(
        'Static file server active at http://${server.address.host}:${server.port}');

    if (links.isNotEmpty) {
      print('Hosted files:');
      links.forEach(print);
    } else {
      print('No files are currently hosted.');
    }
  }

  Handler createRootHandler(Directory webDir) {
    return createStaticHandler(
      webDir.path,
      defaultDocument: 'index.html',
      listDirectories: true,
    );
  }
}
