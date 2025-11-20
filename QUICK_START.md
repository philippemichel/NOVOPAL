# Guide de démarrage rapide - NOVOPAL

## Installation en 3 étapes

### 1. Installer R et RStudio

**R** (requis) : https://cran.r-project.org/
**RStudio** (recommandé) : https://posit.co/download/rstudio-desktop/

### 2. Télécharger le projet

```bash
git clone https://github.com/philippemichel/NOVOPAL.git
cd NOVOPAL
```

ou télécharger le ZIP depuis GitHub

### 3. Préparer vos données

Placer votre fichier de données dans `data/raw/`
- Format : CSV, Excel (.xlsx), ou RDS
- Voir `docs/data_dictionary.md` pour la structure

## Utilisation rapide

### Méthode 1 : Tout exécuter (recommandé)

Ouvrir R ou RStudio dans le répertoire du projet :

```r
source("main.R")
```

✅ C'est tout ! Le script va :
1. Installer les packages nécessaires
2. Importer et nettoyer les données
3. Générer toutes les analyses
4. Créer les rapports HTML et Word

### Méthode 2 : Avec RStudio

1. Double-cliquer sur `NOVOPAL.Rproj`
2. Dans RStudio : `File > Open File > main.R`
3. Cliquer sur le bouton `Source`

### Méthode 3 : Étape par étape

```r
# 1. Import
source("scripts/01_import.R")

# 2. Analyses descriptives
source("scripts/02_descriptive.R")

# 3. Analyses analytiques
source("scripts/03_analytical.R")

# 4. Rapport complet
rmarkdown::render("report.Rmd")
```

## Où trouver les résultats ?

```
output/
├── figures/          # Graphiques PNG (300 DPI)
├── tables/           # Tableaux DOCX
└── reports/          # Rapports complets
    ├── NOVOPAL_rapport.html  ← Ouvrir dans navigateur
    └── NOVOPAL_rapport.docx  ← Ouvrir dans Word
```

## Pas de données ?

Pas de problème ! Le script génère automatiquement des données exemple si aucun fichier n'est trouvé dans `data/raw/`.

## Commandes essentielles

```r
# Installer un package manquant
install.packages("nom_du_package")

# Vérifier les données importées
str(df_patients)
summary(df_patients)
View(df_patients)

# Voir les figures disponibles
list.files("output/figures")

# Ouvrir le rapport HTML
browseURL("output/reports/NOVOPAL_rapport.html")
```

## Structure minimale des données

Votre fichier CSV doit contenir au minimum :

```csv
patient_id,age,sexe,date_entree,date_sortie,statut_sortie
PAT001,75,M,2023-01-15,2023-02-20,Décès
PAT002,68,F,2023-01-20,2023-02-10,Transfert
```

## Packages requis

Les packages suivants seront installés automatiquement :
- tidyverse (manipulation de données)
- gtsummary (tableaux statistiques)
- survival (analyses de survie)
- survminer (visualisation survie)
- rmarkdown (rapports)

## Problèmes courants

### "Aucun fichier trouvé"
➡️ Placer votre fichier dans `data/raw/`

### "Package XXX introuvable"
➡️ `install.packages("XXX")`

### "Impossible de générer le rapport"
➡️ Installer pandoc (inclus avec RStudio)

### "Chemin introuvable"
➡️ Vérifier que vous êtes dans le bon répertoire : `getwd()`

## Personnalisation rapide

### Changer le titre du rapport

Éditer `report.Rmd`, ligne 2 :
```yaml
title: "Votre nouveau titre"
```

### Ajouter une analyse

Créer un nouveau script dans `scripts/` et l'appeler depuis `main.R`

### Modifier les graphiques

Éditer `scripts/02_descriptive.R` ou `scripts/03_analytical.R`

## Aide et documentation

- **Guide complet** : `docs/user_guide.md`
- **Méthodologie** : `docs/methodology.md`
- **Structure données** : `docs/data_dictionary.md`
- **README** : `README.md`

## Commandes de dépannage

```r
# Vérifier version R
R.version.string

# Lister packages installés
installed.packages()[, "Package"]

# Réinstaller tous les packages
source("main.R")  # Le script vérifie et installe

# Nettoyer l'environnement
rm(list = ls())
gc()

# Redémarrer R
.rs.restartR()  # Dans RStudio
```

## Exemple complet

```r
# 1. Démarrer
setwd("~/NOVOPAL")

# 2. Exécuter tout
source("main.R")

# 3. Voir les résultats
browseURL("output/reports/NOVOPAL_rapport.html")

# 4. Explorer les données
str(df_patients)
summary(df_patients$age)
table(df_patients$statut_sortie)

# 5. Graphique personnalisé
library(ggplot2)
ggplot(df_patients, aes(x = age, y = duree_sejour)) +
  geom_point() +
  geom_smooth(method = "lm") +
  theme_minimal()
```

## Temps d'exécution

- Import : ~10 secondes
- Analyses descriptives : ~30 secondes
- Analyses analytiques : ~30 secondes
- Génération rapports : ~60 secondes
- **Total : ~2-3 minutes**

## Prochaines étapes

Une fois familiarisé avec l'outil :
1. Lire le guide utilisateur complet
2. Comprendre la méthodologie
3. Personnaliser les analyses
4. Adapter le rapport

## Support

En cas de difficulté :
1. Consulter `docs/user_guide.md`
2. Vérifier les issues GitHub
3. Contacter le maintainer

---

**Prêt à commencer ?**

```r
source("main.R")
```

**Bonne analyse ! 📊**
