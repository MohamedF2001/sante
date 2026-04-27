# 🔥 Guide de Configuration Firebase — Santé Famille

Suivez ces étapes pour connecter l'application à votre propre backend Firebase.

## 1. Création du projet
1. Allez sur la [Console Firebase](https://console.firebase.google.com/).
2. Cliquez sur **"Ajouter un projet"** et nommez-le `sante-famille`.
3. (Optionnel) Désactivez Google Analytics pour ce projet étudiant.

## 2. Configuration FlutterFire
Le plus simple est d'utiliser la CLI FlutterFire :
1. Installez Firebase CLI sur votre ordinateur.
2. Connectez-vous : `firebase login`.
3. À la racine du projet Flutter, lancez :
   ```bash
   flutterfire configure
   ```
4. Sélectionnez votre projet et les plateformes (Android/iOS/Web). Cela générera automatiquement le fichier `lib/firebase_options.dart`.

## 3. Activer les services

### A. Authentication
1. Dans le menu de gauche, allez dans **Build > Authentication**.
2. Cliquez sur **Get Started**.
3. Dans l'onglet **Sign-in method**, activez **Email/Password**.

### B. Cloud Firestore (Base de données)
1. Allez dans **Build > Cloud Firestore**.
2. Cliquez sur **Create database**.
3. Choisissez **"Start in test mode"** (pour le développement) et votre région.
4. Les collections seront créées automatiquement lors de la première utilisation de l'app.

### C. Firebase Storage (Images)
1. Allez dans **Build > Storage**.
2. Cliquez sur **Get Started**.
3. Choisissez **"Start in test mode"** et validez.

## 4. Règles de sécurité (Important)
Pour que l'application puisse lire et écrire des données, utilisez ces règles simplifiées en mode test :

### Firestore :
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

### Storage :
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```
