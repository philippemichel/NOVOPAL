# NOVOPAL
Étude descriptive et analytique des patients suivis en soins palliatifs

## Description

Étude clinique sur dossier portant sur l'analyse descriptive et analytique des patients suivis en soins palliatifs. Ce projet examine les caractéristiques des patients et leurs implications cliniques.

## Objectifs

### Objectif principal
Décrire les caractéristiques des patients suivis en soins palliatifs et analyser les implications cliniques de ces caractéristiques.

### Objectifs secondaires
- Analyser les données démographiques des patients
- Identifier les principales pathologies et comorbidités
- Évaluer les trajectoires de soins
- Analyser les facteurs pronostiques
- Explorer les implications pour l'organisation des soins

## Structure du projet

```
NOVOPAL/
├── data/
│   ├── raw/              # Données brutes (non versionnées)
│   └── processed/        # Données nettoyées et préparées
├── R/                    # Fonctions R personnalisées
├── scripts/              # Scripts d'analyse
│   ├── 01_import.R      # Import et nettoyage des données
│   ├── 02_descriptive.R # Analyses descriptives
│   └── 03_analytical.R  # Analyses analytiques
├── docs/                 # Documentation
├── output/              # Résultats
│   ├── figures/         # Graphiques
│   ├── tables/          # Tableaux
│   └── reports/         # Rapports générés
└── report.Rmd           # Rapport principal R Markdown

```

## Installation

### Prérequis
- R (version ≥ 4.0.0)
- RStudio (recommandé)

### Packages R nécessaires

```r
install.packages(c(
  "tidyverse",    # Manipulation et visualisation des données
  "gtsummary",    # Tableaux statistiques
  "survival",     # Analyses de survie
  "survminer",    # Visualisation des analyses de survie
  "rmarkdown",    # Génération de rapports
  "knitr",        # Intégration dans les rapports
  "lubridate",    # Manipulation des dates
  "scales",       # Formatage des graphiques
  "ggpubr"        # Amélioration des graphiques
))
```

## Utilisation

1. Placer les données brutes dans `data/raw/`
2. Exécuter les scripts dans l'ordre :
   ```r
   source("scripts/01_import.R")
   source("scripts/02_descriptive.R")
   source("scripts/03_analytical.R")
   ```
3. Générer le rapport final :
   ```r
   rmarkdown::render("report.Rmd")
   ```

## Données

Les données attendues doivent contenir au minimum :
- Identifiant patient anonymisé
- Données démographiques (âge, sexe)
- Diagnostic principal
- Comorbidités
- Dates d'entrée et de sortie
- Statut de sortie

**Note**: Les données brutes ne sont pas versionnées pour des raisons de confidentialité.

## Analyses

### Analyses descriptives
- Caractéristiques démographiques
- Caractéristiques cliniques
- Distribution des pathologies
- Durée de prise en charge

### Analyses analytiques
- Comparaisons entre groupes
- Analyses de survie
- Facteurs associés aux outcomes
- Modèles multivariés

## Conformité éthique

Cette étude est conforme aux principes éthiques de la recherche clinique. Toutes les données sont anonymisées.

## Auteur

Philippe MICHEL

## Licence

MIT License - voir le fichier [LICENSE](LICENSE)
