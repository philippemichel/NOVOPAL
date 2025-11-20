# Méthodologie de l'étude NOVOPAL

## Type d'étude

Étude rétrospective descriptive et analytique sur dossiers de patients suivis en soins palliatifs.

## Population d'étude

### Critères d'inclusion

- Patients adultes (≥ 18 ans)
- Suivis en unité de soins palliatifs
- Période d'étude définie
- Dossier médical complet

### Critères d'exclusion

- Patients mineurs
- Dossiers incomplets ne permettant pas l'analyse
- Refus de participation (si applicable selon la réglementation)

## Variables collectées

### Variables démographiques

- **Identifiant patient** : Identifiant anonymisé unique
- **Âge** : Âge en années au moment de l'admission
- **Sexe** : Homme / Femme
- **Groupe d'âge** : Catégorisation en tranches d'âge

### Variables cliniques

- **Diagnostic principal** : Pathologie principale ayant motivé l'admission en soins palliatifs
- **Comorbidités** : Nombre de pathologies associées
- **Score de Karnofsky** : Échelle d'évaluation de l'autonomie (0-100)
- **Évaluation de la douleur** : Échelle numérique (0-10)

### Variables de prise en charge

- **Date d'entrée** : Date d'admission dans l'unité
- **Date de sortie** : Date de sortie de l'unité
- **Durée de séjour** : Calculée en jours (date de sortie - date d'entrée)
- **Statut de sortie** : Décès / Transfert / Retour à domicile

## Méthodes statistiques

### Analyses descriptives

Les variables quantitatives sont présentées sous forme de :
- Moyenne ± écart-type pour les distributions normales
- Médiane [Q1 - Q3] pour les distributions non normales

Les variables qualitatives sont présentées sous forme de :
- Effectifs (n) et pourcentages (%)

### Analyses comparatives

**Pour les variables qualitatives :**
- Test du Chi² de Pearson (si effectifs théoriques ≥ 5)
- Test exact de Fisher (si effectifs théoriques < 5)

**Pour les variables quantitatives :**
- Test de Student (si distribution normale et variances égales)
- Test de Wilcoxon-Mann-Whitney (pour 2 groupes indépendants)
- Test de Kruskal-Wallis (pour >2 groupes indépendants)

### Analyses de survie

**Méthode de Kaplan-Meier :**
- Estimation de la survie globale
- Comparaison des courbes de survie (test du log-rank)
- Calcul de la survie médiane

**Modèle de Cox :**
- Analyses univariées : identification des facteurs associés
- Analyses multivariées : ajustement sur les facteurs confondants
- Présentation des Hazard Ratios (HR) avec intervalles de confiance à 95%

### Analyses multivariées

**Régression logistique :**
- Variable binaire : décès vs survie
- Odds Ratios (OR) avec IC95%

**Régression linéaire :**
- Variable continue : durée de séjour (transformation log si nécessaire)
- Coefficients β avec IC95%

### Gestion des données manquantes

- Analyse de la distribution des données manquantes
- Description des patterns de données manquantes
- Analyses en données complètes (complete case analysis)
- Analyses de sensibilité si nécessaire

### Seuil de significativité

Le seuil de significativité statistique est fixé à **p < 0.05** (bilatéral).

## Logiciels utilisés

- **R** (version ≥ 4.0.0)
- **RStudio** (environnement de développement)

### Packages R principaux

- `tidyverse` : manipulation et visualisation des données
- `gtsummary` : tableaux statistiques
- `survival` : analyses de survie
- `survminer` : visualisation des analyses de survie
- `rmarkdown` : génération de rapports
- `knitr` : intégration R dans les documents

## Aspects éthiques

### Confidentialité

- Anonymisation de toutes les données
- Identifiants patients non conservés dans les fichiers d'analyse
- Conformité au RGPD (Règlement Général sur la Protection des Données)

### Autorisation

- Étude rétrospective sur données de soins courants
- Conformité aux principes éthiques de la recherche clinique
- Information des patients selon réglementation en vigueur

### Déclaration aux autorités

- Déclaration CNIL si nécessaire
- Autorisation institutionnelle obtenue

## Contrôle qualité

### Validation des données

- Vérification de la cohérence des données
- Détection des valeurs aberrantes
- Contrôle des dates (date d'entrée < date de sortie)
- Vérification des intervalles de valeurs possibles

### Reproductibilité

- Code R versionné
- Scripts documentés
- Environnement R reproductible (packages et versions)

## Limitations méthodologiques

### Biais potentiels

- **Biais de sélection** : étude monocentrique
- **Biais d'information** : données rétrospectives
- **Données manquantes** : qualité variable des dossiers

### Facteurs confondants

- Ajustement sur les principaux facteurs confondants identifiés
- Analyses de sensibilité pour évaluer la robustesse des résultats

## Références méthodologiques

- Therneau, T. M., & Grambsch, P. M. (2000). *Modeling Survival Data: Extending the Cox Model*. Springer.
- Altman, D. G. (1991). *Practical Statistics for Medical Research*. Chapman and Hall.
- R Core Team. *R: A Language and Environment for Statistical Computing*.

---

*Document établi le 2025*
