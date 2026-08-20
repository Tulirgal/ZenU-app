# ZenU Mobile — 3D Architecture

## Decision

ZenU uses a **native-only** 3D architecture for the Panda companion.

One Flutter codebase targets Android and iOS. Shared Dart owns UI, theme,
components, business logic, and Panda **state**. Platform GPU renderers are
used only behind a replaceable `PandaRenderer`.

## Explicit rejection

The following are **not** used for Panda rendering:

- WebView
- WebGL through WebView
- Three.js / HTML / JavaScript 3D
- `flutter_3d_controller`
- Browser-based model viewers
- Full game engines (Unity / Unreal) unless simpler native options fail later

**Why:** native feel, better Flutter lifecycle / haptics / gesture integration,
and no unnecessary WebView runtime in a lightweight wellness app.

## Renderer architecture

```text
PandaWidget
     ↓
PandaController   (renderer-agnostic presentation)
     ↓
PandaState
     ↓
PandaRenderer     (replaceable contract)
     ├── PlaceholderPandaRenderer   (TEMPORARY — Design System Showcase)
     └── NativePandaRenderer        (scaffold → Filament / SceneKit)
              ├── Android: Filament
              └── iOS: SceneKit
```

The rest of the app must never call Filament or SceneKit APIs directly.

## Current phase

- No production 3D package in `pubspec.yaml`
- No fake Panda GLB committed
- `assets/panda/` is reserved for the future production asset
- Showcase uses the temporary placeholder, clearly labeled

## Asset strategy

When the real Panda GLB/glTF arrives:

- Reasonable polygon count for mid-range Android
- Compressed textures / appropriate resolution
- Minimal materials and animation clips
- Efficient skeleton; no unused meshes or environments
- Lazy load via `NativePandaRenderer.loadAsset`
- Measure APK/AAB, IPA, startup, memory, GPU, FPS, battery — then optimize

## Lifecycle

```text
Panda visible → initialize / load → render → animate
Panda hidden  → pause → release unnecessary GPU resources
```

No continuous background 3D rendering. No global game loop.

## Adaptive quality

`PandaQuality` (`high` | `medium` | `low`) is an interface for future
device-aware presentation. Automatic benchmarking is **not** implemented yet.

## Lightweight goals

- No unnecessary 3D dependencies
- No WebView-based 3D
- Minimal bundled media
- Panda is a feature layer — not the foundation of the whole app
