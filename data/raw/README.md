# Données brutes

## Description

Ce répertoire contient les données brutes des patients à analyser.

## Instructions

1. Placer votre fichier de données dans ce répertoire
2. Formats acceptés : CSV, Excel (.xlsx, .xls), RDS
3. Un seul fichier de données à la fois

## Confidentialité

⚠️ **IMPORTANT** : 
- Les données contenues dans ce répertoire sont confidentielles
- Elles ne sont PAS versionnées dans Git (voir `.gitignore`)
- Assurer l'anonymisation complète des données avant import
- Ne jamais partager ces données sans autorisation

## Format attendu

Consulter le fichier `docs/data_dictionary.md` pour la structure détaillée des données.

Variables minimales requises :
- patient_id (identifiant anonymisé)
- age
- sexe
- date_entree
- date_sortie

## Note

Si aucun fichier n'est fourni, le script `01_import.R` générera automatiquement un jeu de données exemple pour la démonstration.
