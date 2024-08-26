import 'dart:io';
import 'package:gazelle_hosting_plugin/gazelle_hosting_plugin.dart';
import 'package:mockito/annotations.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:gazelle_core/gazelle_core.dart';
import 'package:shelf/shelf.dart';
import 'gazelle_hosting_plugin_test.mocks.dart';

@GenerateMocks([GazelleContext, HttpServer])
void main() {
  group('StaticHostingPlugin', () {
    late MockGazelleContext mockContext;
    late Directory tempDir;
    late HttpServer mockServer;
    late StaticHostingPlugin plugin;

    setUp(() async {
      mockContext = MockGazelleContext();
      mockServer = MockHttpServer();

      // Create a temporary directory and setup a simple file structure
      tempDir = await Directory.systemTemp.createTemp('test_directory');
      File('${tempDir.path}/index.html')
        ..createSync()
        ..writeAsStringSync('<html><body>Hello World!</body></html>');

      // Mock server configurations
      when(mockServer.address).thenReturn(InternetAddress('127.0.0.1'));
      when(mockServer.port).thenReturn(8080);

      // Initialize the plugin with the real temporary directory
      plugin = StaticHostingPlugin(
        address: 'localhost',
        port: 8080,
        directoryFactory: () => tempDir,
        serveFunction: (handler, address, port) async => mockServer,
      );
    });

    tearDown(() async {
      await tempDir.delete(recursive: true);
    });

    test(
        'initialize configures handlers and starts the server with files available',
        () async {
      await plugin.initialize(mockContext);
      expect(mockServer.address.host, equals('127.0.0.1'));
      expect(mockServer.port, equals(8080));
    });

    test('Server correctly serves files', () async {
      // Ensure the server is initialized
      await plugin.initialize(mockContext);

      // Create a Handler using the plugin
      Handler handler = plugin.createRootHandler(tempDir);

      // Simulate a request to the server
      final request =
          Request('GET', Uri.parse('http://localhost:8080/index.html'));
      final response = await handler(request);

      expect(response.statusCode, equals(200));
      expect(await response.readAsString(), contains('Hello World!'));
      expect(response.headers['content-type'], contains('text/html'));
    });

    test('Server returns 404 for non-existing files', () async {
      // Ensure the server is initialized
      await plugin.initialize(mockContext);

      // Create a Handler using the plugin
      Handler handler = plugin.createRootHandler(tempDir);

      // Simulate a request to the server
      final request =
          Request('GET', Uri.parse('http://localhost:8080/nonexistent.html'));
      final response = await handler(request);

      expect(response.statusCode, equals(404));
    });
  });
}
