# Changelog - NOVOPAL

Toutes les modifications notables du projet NOVOPAL seront documentées dans ce fichier.

## [1.0.0] - 2025-11-20

### Ajouté

#### Structure du projet
- Création de la structure complète du projet avec répertoires organisés
- Configuration du projet RStudio (NOVOPAL.Rproj)
- Configuration .gitignore pour protéger les données sensibles
- Fichiers .gitkeep pour maintenir la structure des répertoires

#### Scripts d'analyse
- **01_import.R** : Import et nettoyage des données
  - Support de multiples formats (CSV, Excel, RDS)
  - Nettoyage automatique des données
  - Validation et contrôle qualité
  - Génération de données exemple si aucune donnée fournie
  
- **02_descriptive.R** : Analyses descriptives
  - Caractéristiques démographiques
  - Caractéristiques cliniques
  - Analyses de la prise en charge
  - Génération automatique de tableaux et graphiques
  
- **03_analytical.R** : Analyses analytiques avancées
  - Comparaisons selon différents critères
  - Analyses de survie (Kaplan-Meier)
  - Modèles de Cox (univariés et multivariés)
  - Analyses de régression
  - Impact des comorbidités

- **main.R** : Script principal d'exécution
  - Orchestration de toutes les analyses
  - Installation automatique des packages
  - Vérification de l'environnement
  - Génération de rapports

#### Rapports et documentation
- **report.Rmd** : Template R Markdown complet
  - Rapport HTML interactif
  - Rapport Word éditable
  - Intégration automatique de toutes les analyses
  - Documentation des méthodes et résultats

- **README.md** : Documentation principale du projet
  - Vue d'ensemble du projet
  - Instructions d'installation
  - Guide d'utilisation rapide
  - Structure du projet

#### Documentation technique
- **docs/methodology.md** : Méthodologie détaillée
  - Type d'étude et population
  - Variables collectées
  - Méthodes statistiques
  - Aspects éthiques
  
- **docs/data_dictionary.md** : Dictionnaire des données
  - Structure des fichiers
  - Description des variables
  - Formats et règles de codage
  - Exemples et contrôles qualité
  
- **docs/user_guide.md** : Guide utilisateur complet
  - Installation pas à pas
  - Préparation des données
  - Utilisation des scripts
  - Dépannage et support

#### Fonctions utilitaires
- **R/utils.R** : Bibliothèque de fonctions personnalisées
  - Statistiques descriptives
  - Calculs d'intervalles de confiance
  - Formatage des p-values
  - Tableaux de contingence
  - Odds ratios
  - Tests statistiques automatiques
  - Forest plots
  - Rapport de qualité des données

#### Fichiers README spécifiques
- **data/raw/README.md** : Instructions pour les données brutes
- **data/processed/README.md** : Description des données traitées
- **output/README.md** : Description des résultats générés

### Fonctionnalités

#### Analyses descriptives
- Distribution de l'âge (histogramme)
- Répartition par sexe et groupe d'âge
- Distribution des diagnostics principaux
- Analyse de la durée de séjour
- Distribution des statuts de sortie
- Tableaux statistiques professionnels

#### Analyses analytiques
- Comparaisons selon le statut de sortie
- Comparaisons selon le groupe d'âge
- Courbes de survie globales et stratifiées
- Modèles de Cox pour facteurs pronostiques
- Analyse des facteurs associés à la durée de séjour
- Impact des comorbidités sur les outcomes

#### Visualisations
- Graphiques haute résolution (PNG 300 DPI)
- Histogrammes pour distributions
- Graphiques en barres pour comparaisons
- Diagrammes circulaires pour proportions
- Courbes de Kaplan-Meier
- Boxplots pour analyses comparatives
- Forest plots pour résultats de régression

#### Tableaux
- Format Word (DOCX) pour faciliter l'édition
- Tableaux avec gtsummary (standard publications)
- Tests statistiques intégrés
- Formatage professionnel français
- Légendes et notes explicatives

### Sécurité et confidentialité
- Données brutes non versionnées
- Données traitées non versionnées
- Résultats non versionnés (régénérables)
- Instructions de confidentialité dans la documentation
- Vérification d'anonymisation

### Qualité et reproductibilité
- Code commenté en français
- Structure modulaire
- Gestion des erreurs
- Messages informatifs
- Validation des données
- Reproductibilité complète

### Technologies utilisées
- R (≥ 4.0.0)
- tidyverse pour manipulation de données
- gtsummary pour tableaux statistiques
- survival/survminer pour analyses de survie
- rmarkdown/knitr pour rapports
- ggplot2 pour visualisations

---

## Format

Le format de ce changelog est basé sur [Keep a Changelog](https://keepachangelog.com/fr/1.0.0/),
et ce projet adhère au [Semantic Versioning](https://semver.org/lang/fr/).

## Types de changements

- **Ajouté** : nouvelles fonctionnalités
- **Modifié** : changements de fonctionnalités existantes
- **Déprécié** : fonctionnalités bientôt supprimées
- **Supprimé** : fonctionnalités supprimées
- **Corrigé** : corrections de bugs
- **Sécurité** : corrections de vulnérabilités
