# Guide d'utilisation - NOVOPAL

## Introduction

Ce guide explique comment utiliser le projet NOVOPAL pour analyser les données de patients suivis en soins palliatifs.

## Installation

### Prérequis

1. **R** (version ≥ 4.0.0)
   - Télécharger depuis : https://cran.r-project.org/
   - Vérifier la version : `R --version`

2. **RStudio** (recommandé mais optionnel)
   - Télécharger depuis : https://posit.co/download/rstudio-desktop/

### Installation des packages R

Les packages nécessaires seront installés automatiquement lors de la première exécution. Pour une installation manuelle :

```r
# Lancer R ou RStudio
install.packages(c(
  "tidyverse",
  "gtsummary",
  "survival",
  "survminer",
  "rmarkdown",
  "knitr",
  "lubridate",
  "scales",
  "readxl",
  "writexl",
  "janitor",
  "broom",
  "flextable",
  "kableExtra",
  "here"
))
```

## Préparation des données

### Format des données

Les données peuvent être fournies dans les formats suivants :
- CSV (`.csv`)
- Excel (`.xlsx` ou `.xls`)
- RDS (`.rds`)

### Placement des fichiers

1. Placer votre fichier de données dans le répertoire `data/raw/`
2. Un seul fichier de données doit être présent (le script utilisera le premier trouvé)

### Structure requise

Votre fichier doit contenir au minimum les colonnes suivantes :

**Obligatoires :**
- `patient_id` : Identifiant unique du patient
- `age` : Âge en années
- `sexe` : M/F ou Homme/Femme

**Recommandées :**
- `diagnostic_principal` : Diagnostic principal
- `comorbidites` : Nombre de comorbidités
- `date_entree` : Date d'admission
- `date_sortie` : Date de sortie
- `statut_sortie` : Décès/Transfert/Domicile
- `karnofsky` : Score de Karnofsky (0-100)
- `douleur_entree` : Douleur à l'entrée (0-10)

**Exemple de structure CSV :**

```csv
patient_id,age,sexe,diagnostic_principal,comorbidites,date_entree,date_sortie,statut_sortie,karnofsky,douleur_entree
PAT0001,78,M,Cancer pulmonaire,3,2023-01-15,2023-02-20,Décès,30,7
PAT0002,65,F,Insuffisance cardiaque,2,2023-01-20,2023-02-10,Transfert,40,5
```

Voir `docs/data_dictionary.md` pour plus de détails.

## Utilisation

### Méthode 1 : Exécution complète (recommandé)

C'est la méthode la plus simple pour générer tous les résultats :

```r
# Ouvrir R ou RStudio
# Se placer dans le répertoire du projet
setwd("/chemin/vers/NOVOPAL")

# Exécuter le script principal
source("main.R")
```

Cette commande va :
1. Vérifier et installer les packages nécessaires
2. Importer et nettoyer les données
3. Effectuer les analyses descriptives
4. Effectuer les analyses analytiques
5. Générer le rapport complet (HTML et Word)

### Méthode 2 : Exécution étape par étape

Pour plus de contrôle, vous pouvez exécuter les scripts individuellement :

#### Étape 1 : Import et nettoyage

```r
source("scripts/01_import.R")
```

Résultats :
- Données nettoyées dans `data/processed/`
- Statistiques descriptives de base dans la console

#### Étape 2 : Analyses descriptives

```r
source("scripts/02_descriptive.R")
```

Résultats :
- Tableaux dans `output/tables/`
- Graphiques dans `output/figures/`

#### Étape 3 : Analyses analytiques

```r
source("scripts/03_analytical.R")
```

Résultats :
- Tableaux comparatifs dans `output/tables/`
- Courbes de survie dans `output/figures/`
- Modèles statistiques

#### Étape 4 : Génération du rapport

```r
# Rapport HTML
rmarkdown::render("report.Rmd", output_format = "html_document")

# Rapport Word
rmarkdown::render("report.Rmd", output_format = "word_document")
```

### Méthode 3 : Utilisation avec RStudio

1. Ouvrir le projet : `File > Open Project` → sélectionner `NOVOPAL.Rproj`
2. Ouvrir `main.R` dans l'éditeur
3. Cliquer sur `Source` (en haut à droite de l'éditeur)

ou

1. Ouvrir `report.Rmd`
2. Cliquer sur `Knit` pour générer le rapport

## Résultats

### Structure des sorties

```
output/
├── figures/           # Graphiques (PNG, 300 DPI)
│   ├── fig1_distribution_age.png
│   ├── fig2_repartition_sexe_age.png
│   ├── fig3_diagnostics.png
│   └── ...
├── tables/           # Tableaux (DOCX)
│   ├── tableau1_demographie.docx
│   ├── tableau2_clinique.docx
│   └── ...
└── reports/          # Rapports complets
    ├── NOVOPAL_rapport.html
    └── NOVOPAL_rapport.docx
```

### Interprétation des résultats

#### Tableaux descriptifs

- **Moyennes ± écarts-types** : Variables continues à distribution normale
- **Médianes [Q1-Q3]** : Variables continues à distribution non normale
- **Effectifs (%)** : Variables catégorielles

#### Tests statistiques

- **p < 0.05** : Différence statistiquement significative
- **p ≥ 0.05** : Pas de différence significative démontrée

#### Analyses de survie

- **Courbes de Kaplan-Meier** : Probabilité de survie au cours du temps
- **Hazard Ratio (HR)** : Risque relatif
  - HR > 1 : Risque augmenté
  - HR < 1 : Risque diminué
  - HR = 1 : Pas d'effet

## Personnalisation

### Modifier les analyses

Les scripts dans `scripts/` peuvent être modifiés selon vos besoins :

1. **Ajouter des variables** : Éditer les sélections de colonnes
2. **Modifier les graphiques** : Ajuster les paramètres ggplot2
3. **Changer les tests** : Adapter les méthodes statistiques

### Modifier le rapport

Le fichier `report.Rmd` peut être personnalisé :

```r
---
title: "Votre titre"      # Modifier le titre
author: "Votre nom"       # Modifier l'auteur
---
```

## Dépannage

### Problèmes courants

#### Erreur : "Aucun fichier de données trouvé"

**Solution :** 
- Vérifier que le fichier est dans `data/raw/`
- Vérifier l'extension (.csv, .xlsx, .xls, .rds)

#### Erreur : "Package XXX n'est pas installé"

**Solution :**
```r
install.packages("XXX")
```

#### Erreur : "Impossible d'ouvrir la connexion"

**Solution :**
- Vérifier le chemin du répertoire de travail
- Utiliser `setwd()` pour définir le bon répertoire

#### Erreur lors de la génération du rapport

**Solution :**
- Vérifier que pandoc est installé (inclus avec RStudio)
- Essayer de générer uniquement le HTML d'abord

### Vérification de l'installation

```r
# Vérifier la version de R
R.version.string

# Vérifier les packages installés
installed.packages()[, c("Package", "Version")]

# Tester un package spécifique
library(tidyverse)
packageVersion("tidyverse")
```

## Support et questions

### Documentation supplémentaire

- `docs/methodology.md` : Méthodologie détaillée
- `docs/data_dictionary.md` : Description des variables
- `README.md` : Vue d'ensemble du projet

### Logs et débogage

Activer les messages détaillés :

```r
options(verbose = TRUE)
source("main.R")
```

### Obtenir de l'aide sur une fonction

```r
?nom_de_la_fonction
help(nom_de_la_fonction)
```

## Bonnes pratiques

### Avant de commencer

1. ✓ Sauvegarder une copie de vos données brutes
2. ✓ Vérifier que les données sont anonymisées
3. ✓ Lire le dictionnaire des données
4. ✓ Tester avec un petit échantillon d'abord

### Pendant l'analyse

1. ✓ Exécuter les scripts dans l'ordre
2. ✓ Vérifier les messages d'avertissement
3. ✓ Examiner les résultats intermédiaires
4. ✓ Sauvegarder votre workspace régulièrement

### Après l'analyse

1. ✓ Vérifier la cohérence des résultats
2. ✓ Archiver les données et résultats
3. ✓ Documenter les modifications apportées
4. ✓ Ne pas versionner les données sensibles

## Exemples d'utilisation

### Exemple 1 : Analyse rapide

```r
# Se placer dans le projet
setwd("~/NOVOPAL")

# Tout exécuter
source("main.R")

# Ouvrir le rapport HTML
browseURL("output/reports/NOVOPAL_rapport.html")
```

### Exemple 2 : Analyses exploratoires

```r
# Importer les données
source("scripts/01_import.R")

# Explorer les données
str(df_patients)
summary(df_patients)
View(df_patients)

# Analyses descriptives seulement
source("scripts/02_descriptive.R")
```

### Exemple 3 : Modifications personnalisées

```r
# Importer les données
source("scripts/01_import.R")

# Analyses personnalisées
library(tidyverse)

# Analyser un sous-groupe spécifique
df_cancer <- df_patients %>%
  filter(grepl("Cancer", diagnostic_principal))

table(df_cancer$diagnostic_principal)
```

## Mise à jour

Pour mettre à jour le projet :

```r
# Mettre à jour les packages
update.packages(ask = FALSE)

# Vérifier les versions
packageVersion("gtsummary")
packageVersion("survival")
```

---

*Guide d'utilisation - Version 1.0*
*Pour toute question : consulter la documentation ou contacter le responsable du projet*
