# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Este es un paquete Flutter de UI de chat (`chatview` v1.3.1) altamente personalizable, con soporte para mensajes de texto, imagen, voz y tipos personalizados. Es un fork/variante del paquete [flutter_chatview de SimformSolutions](https://github.com/SimformSolutionsPvtLtd/flutter_chatview).

## Commands

```bash
# Instalar dependencias
flutter pub get

# Ejecutar análisis de código
flutter analyze

# Ejecutar tests
flutter test

# Ejecutar un test específico
flutter test test/<nombre_del_archivo>_test.dart

# Verificar formateo
dart format --set-exit-if-changed lib/

# Formatear código
dart format lib/

# Construir ejemplo
cd example && flutter run
```

## Architecture

### Entry Point & Exports

[lib/chatview.dart](lib/chatview.dart) es el único archivo público del paquete — exporta todos los modelos, widgets, el controlador y las enumeraciones. Todo lo que va dentro de `lib/src/` es privado.

### Core Widget Flow

```
ChatView (widget principal)
  └── ChatViewInheritedWidget  (InheritedWidget — propaga config a toda la árbol)
        ├── ChatAppBar
        ├── ChatListWidget
        │     └── ChatGroupedListWidget  (agrupado por fecha)
        │           └── MessageView  (polimórfico por MessageType)
        │                 ├── TextMessageView
        │                 ├── ImageMessageView
        │                 └── VoiceMessageView (solo iOS/Android)
        └── SendMessageWidget
```

### ChatController (`lib/src/controller/chat_controller.dart`)

El único punto de mutación de estado externo. Sus responsabilidades son:
- Mantener la lista de mensajes y notificar cambios vía `StreamController<List<Message>>`
- Manejar scroll con `ScrollController`
- Exponer `setReaction`, `loadMoreData`, `scrollToLastMessage`, `getUserFromId`
- El `ValueNotifier<bool> typeIndicatorNotifier` controla el indicador de escritura

### Data Models (`lib/src/models/`)

**Modelos de datos principales:**
- `Message`: Objeto central. Contiene `messageType` (`text`/`image`/`voice`/`custom`), `status` como `ValueNotifier<MessageStatus>`, `reaction`, y `replyMessage` para hilos.
- `ChatUser`: Perfil de usuario con `id`, `name`, `profilePhoto`.
- `ReplyMessage`: Contexto de respuesta vinculado a un `Message`.
- `Reaction`: Lista de emojis y los IDs de usuarios que reaccionaron.

**Configuration objects** — todos son clases inmutables que se pasan como parámetros a `ChatView`. Los más importantes:
- `ChatBubbleConfiguration`: Estilo de las burbujas
- `SendMessageConfiguration`: Personalización completa del campo de texto (el más extenso)
- `MessageConfiguration`: Builders para tipos de mensaje custom
- `FeatureActiveConfig`: Activa/desactiva 12+ features (swipe-to-reply, reactions, paginación, etc.)

### State Management Pattern

El paquete usa **múltiples ValueNotifiers** en lugar de un state manager externo:
- `ValueNotifier<ReplyMessage>` — mensaje al que se está respondiendo
- `ValueNotifier<MessageStatus>` en cada `Message` — actualizaciones de recibo sin reconstruir toda la lista
- `StreamController<List<Message>>` — cambios reactivos en la lista de mensajes

No hay dependencia de `provider`, `bloc`, `riverpod` ni similares.

### Key Patterns

- **InheritedWidget**: `ChatViewInheritedWidget` propaga configuración compartida. Acceder vía `ChatViewInheritedWidget.of(context)`.
- **Builder callbacks**: La mayoría de elementos visuales son personalizables mediante builders opcionales.
- **GlobalKey per message**: Cada mensaje tiene un `GlobalKey` para medir su `RenderBox` (usado en reaction popup y swipe).
- **VoiceMessageView**: Solo se compila para Android e iOS — protegido con guardias de plataforma. Usa `audio_waveforms`.

### Localization (`lib/src/chatview_l10n.dart`)

Extender `ChatViewL10n` para añadir un nuevo idioma. Hay implementaciones incluidas para inglés (`ChatViewL10nEn`) y español (`ChatViewL10nEs`). Se inyecta como `l10n` en `ChatView`.

### Extensions & Utilities

- `lib/src/extensions/extensions.dart`: Helpers en `DateTime`, `String`, `MessageType`, `MessageStatus`.
- `lib/src/values/enumaration.dart`: Todas las enumeraciones del paquete.
- `lib/src/values/typedefs.dart`: Definiciones de tipos para todos los callbacks.

## Example App

El directorio [example/](example/) contiene una implementación de referencia completa:
- `example/lib/main.dart`: Setup completo de `ChatView` con callbacks
- `example/lib/data.dart`: Datos de muestra (mensajes y usuarios)
- `example/lib/models/theme.dart`: Configuración de temas

Usar el ejemplo como referencia antes de modificar la API pública.
