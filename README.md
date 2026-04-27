# 🏗️ Architecture — Santé Famille (Flutter)

## Structure des dossiers

```
lib/
├── main.dart                        # Point d'entrée
├── firebase_options.dart            # Config Firebase (généré par FlutterFire CLI)
│
├── core/                            # Code partagé par toute l'app
│   ├── constants/
│   │   ├── app_colors.dart          # Palette de couleurs (vert/blanc)
│   │   ├── app_strings.dart         # Textes de l'app
│   │   └── app_routes.dart          # Noms des routes
│   ├── theme/
│   │   └── app_theme.dart           # Thème Flutter (Material)
│   ├── widgets/
│   │   ├── custom_button.dart       # Bouton réutilisable
│   │   ├── custom_text_field.dart   # Champ de saisie réutilisable
│   │   └── loading_overlay.dart     # Spinner de chargement
│   └── utils/
│       ├── validators.dart          # Validation des formulaires
│       └── date_formatter.dart      # Formatage des dates
│
└── features/                        # Fonctionnalités (Clean Architecture simplifiée)
    │
    ├── auth/                        # MODULE : Authentification
    │   ├── data/
    │   │   └── auth_service.dart    # Appels Firebase Auth
    │   ├── domain/
    │   │   └── user_model.dart      # Modèle utilisateur
    │   ├── presentation/
    │   │   ├── providers/
    │   │   │   └── auth_provider.dart   # Riverpod provider
    │   │   └── screens/
    │   │       ├── login_screen.dart
    │   │       └── register_screen.dart
    │
    ├── dashboard/                   # MODULE : Accueil / Dashboard
    │   └── presentation/
    │       └── screens/
    │           └── dashboard_screen.dart
    │
    ├── carnet/                      # MODULE : Carnet de santé
    │   ├── data/
    │   │   └── carnet_service.dart  # Appels Firestore + Storage
    │   ├── domain/
    │   │   ├── vaccin_model.dart    # Modèle vaccin
    │   │   └── scan_model.dart      # Modèle scan
    │   ├── presentation/
    │   │   ├── providers/
    │   │   │   └── carnet_provider.dart
    │   │   └── screens/
    │   │       ├── carnet_screen.dart      # Onglets : Vaccins / Scans
    │   │       ├── vaccins_screen.dart     # Liste vaccins
    │   │       ├── add_vaccin_screen.dart  # Ajouter vaccin
    │   │       └── scans_screen.dart       # Scanner carnet
    │
    ├── pleurs/                      # MODULE : Analyse pleurs (IA simulée)
    │   └── presentation/
    │       └── screens/
    │           └── pleurs_screen.dart
    │
    ├── toise/                       # MODULE : Toise AR (IA simulée)
    │   └── presentation/
    │       └── screens/
    │           └── toise_screen.dart
    │
    ├── hopitaux/                    # MODULE : Géo-Santé (hôpitaux)
    │   └── presentation/
    │       └── screens/
    │           └── hopitaux_screen.dart
    │
    ├── encyclopedie/                # MODULE : Encyclopédie santé
    │   └── presentation/
    │       └── screens/
    │           └── encyclopedie_screen.dart
    │
    ├── nutrition/                   # MODULE : Nutrition locale
    │   └── presentation/
    │       └── screens/
    │           └── nutrition_screen.dart
    │
    ├── forum/                       # MODULE : Forum / Ask a Pro
    │   ├── data/
    │   │   └── forum_service.dart
    │   ├── domain/
    │   │   └── post_model.dart
    │   ├── presentation/
    │   │   ├── providers/
    │   │   │   └── forum_provider.dart
    │   │   └── screens/
    │   │       ├── forum_screen.dart
    │   │       └── post_detail_screen.dart
    │
    └── profil/                      # MODULE : Profil + Paramètres
        └── presentation/
            └── screens/
                ├── profil_screen.dart
                └── parametres_screen.dart
```

## Conventions de code

- **Nommage** : `snake_case` pour fichiers, `PascalCase` pour classes, `camelCase` pour variables
- **Providers** : `AsyncNotifierProvider` ou `StateNotifierProvider` (Riverpod)
- **Services** : Injectés via `ref.read()` dans les providers
- **Firebase** : Toutes les opérations Firebase dans les fichiers `*_service.dart`

## pubspec.yaml — Dépendances principales

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # Firebase
  firebase_core: ^2.27.0
  firebase_auth: ^4.19.0
  cloud_firestore: ^4.17.0
  firebase_storage: ^11.7.0
  
  # State management
  flutter_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.5
  
  # UI
  google_fonts: ^6.2.1
  flutter_svg: ^2.0.10+1
  cached_network_image: ^3.3.1
  
  # Fonctionnalités
  image_picker: ^1.1.2        # Sélectionner photo/scan
  file_picker: ^8.0.4         # Importer documents
  intl: ^0.19.0               # Formatage dates
  uuid: ^4.4.0                # Générer IDs uniques
  
  # Navigation
  go_router: ^13.2.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.9
  riverpod_generator: ^2.4.0
  flutter_lints: ^3.0.2
```
