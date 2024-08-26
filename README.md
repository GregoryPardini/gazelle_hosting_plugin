
# Gazelle Static Hosting Plugin

Welcome to the Gazelle Static Hosting Plugin! This open source project enables seamless static file hosting with the Gazelle framework. Whether you're building a blog, a portfolio, or a full-fledged web application, our plugin simplifies the process of serving static content.

## Features

- **Simple Integration**: Easily plug into any Gazelle application.
- **Custom Configurations**: Host from the `web` directory on any port you choose.
- **Automatic Link Generation**: Access your hosted files through generated URLs automatically.

## Getting Started

To get started with the Gazelle Static Hosting Plugin, follow these steps:

### Prerequisites

Ensure you have Dart installed on your machine. If not, you can download it from [Dart's official site](https://dart.dev/get-dart).

### Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/yourgithub/gazelle_static_hosting_plugin.git
   ```
2. Navigate into the project directory and ensure your files are within the `web` directory:
   ```bash
   cd gazelle_static_hosting_plugin/web
   ```
3. Get the dependencies:
   ```bash
   dart pub get
   ```

### Usage

To use the plugin in your Gazelle app, first import it into your Dart project:

```dart
import 'package:gazelle_static_hosting_plugin/gazelle_static_hosting_plugin.dart';
```

Then, initialize and start your Gazelle application:

```dart
void main() async {
  final app = GazelleApp(
    plugins: [StaticHostingPlugin()],
    port: 3001,
  );

  await app.start();
  print("Static hosting plugin example started on port 3001");
}
```



## Contributing

Interested in contributing? Great! We welcome contributions from developers of all skill levels. Here's how you can contribute:

- **Submit Issues**: Found a bug or have a feature request? Submit an issue.
- **Send Pull Requests**: Have a fix or an improvement? Send us a pull request.

Check out our [Contributing Guidelines](CONTRIBUTING.md) for more details on how to start contributing.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

Thank you for exploring the Gazelle Static Hosting Plugin. Happy coding!
