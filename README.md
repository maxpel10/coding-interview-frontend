## Cómo ejecutar el proyecto

### Requisitos
- [Flutter](https://docs.flutter.dev/get-started/install) instalado (compatible con el SDK de Dart indicado en `pubspec.yaml`).

### Generación de código (`.g.dart`, `.freezed.dart`)
El proyecto usa **json_serializable**, **retrofit** y **freezed**, que generan archivos `*.g.dart` y `*.freezed.dart`. No están versionados de forma manual: hay que generarlos después de `flutter pub get` (o al cambiar modelos / anotaciones):

```bash
dart run build_runner build --delete-conflicting-outputs
```

Durante el desarrollo puedes usar `dart run build_runner watch --delete-conflicting-outputs` para regenerar al guardar.

### Archivo `env.json` y `dart-define`
La base del API se configura en **tiempo de compilación** con `String.fromEnvironment('API_URL')`. Por eso **debe existir un `env.json` en la raíz del proyecto** (junto a `pubspec.yaml`) y debes pasar sus valores al ejecutar o compilar con `--dart-define-from-file`.

> El archivo `env.json` no se sube al repositorio (está en `.gitignore`). Se debe crear en su máquina.

Ejemplo de `env.json`:

```json
{
  "API_URL": "https://74j6q7lg6a.execute-api.eu-west-1.amazonaws.com/stage"
}
```

`API_URL` es solo la **URL base** del API (el prefijo común a las rutas), no la ruta completa del endpoint de recomendaciones.

### Comandos
En la raíz del repositorio:

```bash
flutter pub get
flutter run --dart-define-from-file=env.json
```

Para compilar o correr tests, se usa el mismo flag si la ejecución necesita el cliente HTTP:

```bash
flutter test --dart-define-from-file=env.json
flutter build apk --dart-define-from-file=env.json
```

**VS Code / Cursor:** las configuraciones en `.vscode/launch.json` ya incluyen `--dart-define-from-file=env.json`; puedes lanzar la app en debug con esas configuraciones sin escribir el flag a mano.
