# Données traitées

## Description

Ce répertoire contient les données nettoyées et préparées pour l'analyse.

## Fichiers générés

- `patients_clean.rds` : Données nettoyées au format R natif (recommandé)
- `patients_clean.csv` : Données nettoyées au format CSV (portabilité)

## Processus

Les données sont générées par le script `scripts/01_import.R` qui :
1. Importe les données brutes
2. Nettoie les noms de colonnes
3. Standardise les formats (dates, catégories)
4. Supprime les doublons
5. Calcule les variables dérivées
6. Valide la cohérence des données

## Confidentialité

⚠️ **IMPORTANT** : 
- Ces fichiers contiennent des données de santé sensibles
- Ils ne sont PAS versionnés dans Git
- Respecter les mêmes règles de confidentialité que les données brutes

## Utilisation

Ces fichiers sont automatiquement chargés par les scripts d'analyse ultérieurs :
- `scripts/02_descriptive.R`
- `scripts/03_analytical.R`
- `report.Rmd`
