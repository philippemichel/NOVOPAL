# Dictionnaire des données - NOVOPAL

Ce document décrit la structure et le format des données utilisées dans l'étude NOVOPAL.

## Structure des fichiers

Les données brutes doivent être placées dans le répertoire `data/raw/` aux formats suivants :
- CSV (`.csv`)
- Excel (`.xlsx` ou `.xls`)
- RDS (`.rds` - format natif R)

## Variables requises

### Variables d'identification

| Variable | Type | Description | Format | Exemple |
|----------|------|-------------|--------|---------|
| `patient_id` | Texte | Identifiant unique anonymisé du patient | PATXXXX | PAT0001 |

### Variables démographiques

| Variable | Type | Description | Format | Valeurs possibles |
|----------|------|-------------|--------|-------------------|
| `age` | Numérique | Âge du patient en années | Entier | 18-110 |
| `sexe` | Catégorielle | Sexe du patient | M/F ou Homme/Femme | M, F |
| `age_groupe` | Catégorielle | Groupe d'âge | Texte | <65, 65-74, 75-84, ≥85 ans |

### Variables cliniques

| Variable | Type | Description | Format | Valeurs possibles |
|----------|------|-------------|--------|-------------------|
| `diagnostic_principal` | Catégorielle | Diagnostic principal | Texte libre | Cancer pulmonaire, etc. |
| `comorbidites` | Numérique | Nombre de comorbidités | Entier | 0-10 |
| `karnofsky` | Numérique | Score de Karnofsky | Entier | 0-100 (par paliers de 10) |
| `douleur_entree` | Numérique | Intensité de la douleur à l'entrée | Entier | 0-10 |

**Note sur le score de Karnofsky :**
- 100 : Normal, aucune plainte, aucun signe de maladie
- 90 : Capable d'une activité normale, symptômes mineurs
- 80 : Activité normale avec effort, symptômes mineurs
- 70 : Autonome, incapable d'activité normale
- 60 : Assistance occasionnelle nécessaire
- 50 : Assistance considérable et soins médicaux fréquents
- 40 : Invalide, assistance spécialisée nécessaire
- 30 : Invalide sévère, hospitalisation indiquée
- 20 : Très malade, hospitalisation nécessaire
- 10 : Moribond, processus mortel progressant rapidement
- 0 : Décédé

### Variables de prise en charge

| Variable | Type | Description | Format | Exemple |
|----------|------|-------------|--------|---------|
| `date_entree` | Date | Date d'admission dans l'unité | YYYY-MM-DD | 2023-01-15 |
| `date_sortie` | Date | Date de sortie de l'unité | YYYY-MM-DD | 2023-02-20 |
| `duree_sejour` | Numérique | Durée de séjour en jours | Entier | 36 |
| `statut_sortie` | Catégorielle | Statut à la sortie | Texte | Décès, Transfert, Domicile |

## Variables dérivées (calculées automatiquement)

Ces variables sont créées automatiquement lors du traitement des données :

| Variable | Type | Description | Calcul |
|----------|------|-------------|--------|
| `age_groupe` | Catégorielle | Groupe d'âge | Si age < 65 alors "<65 ans", etc. |
| `duree_sejour` | Numérique | Durée de séjour | date_sortie - date_entree |
| `event` | Binaire | Événement décès pour analyse de survie | 1 si statut_sortie = "Décès", 0 sinon |
| `time` | Numérique | Temps de suivi pour analyse de survie | duree_sejour |

## Règles de codage

### Valeurs manquantes

- Les valeurs manquantes doivent être codées : `NA`, vide, ou laissées blanches
- **Ne pas utiliser** : 999, 9999, -1, "manquant", "inconnu"

### Format des dates

- Format standard : `YYYY-MM-DD` (ex: 2023-01-15)
- Format alternatif accepté : `DD/MM/YYYY` (ex: 15/01/2023)

### Standardisation du sexe

Accepté en entrée :
- `M`, `H`, `Homme`, `Masculin` → converti en `Homme`
- `F`, `Femme`, `Féminin` → converti en `Femme`

### Statut de sortie

Valeurs standardisées :
- `Décès` : Patient décédé dans l'unité
- `Transfert` : Transfert vers une autre unité/établissement
- `Domicile` : Retour au domicile

## Exemple de fichier CSV

```csv
patient_id,age,sexe,diagnostic_principal,comorbidites,date_entree,date_sortie,statut_sortie,karnofsky,douleur_entree
PAT0001,78,M,Cancer pulmonaire,3,2023-01-15,2023-02-20,Décès,30,7
PAT0002,65,F,Insuffisance cardiaque,2,2023-01-20,2023-02-10,Transfert,40,5
PAT0003,82,M,Cancer digestif,4,2023-02-01,2023-03-15,Décès,20,8
```

## Contrôles de qualité automatiques

Le script `01_import.R` effectue automatiquement les contrôles suivants :

### Contrôles de cohérence

1. **Identifiants uniques** : Vérification de l'unicité des patient_id
2. **Cohérence des dates** : date_entree ≤ date_sortie
3. **Intervalles de valeurs** :
   - age : 18-110
   - karnofsky : 0-100 (multiples de 10)
   - douleur : 0-10
   - comorbidites : ≥ 0
   - duree_sejour : > 0

### Détection des valeurs aberrantes

- Valeurs extrêmes pour l'âge
- Durées de séjour exceptionnellement longues ou courtes
- Scores de Karnofsky non conformes

### Rapport de qualité

Le script génère automatiquement :
- Nombre de valeurs manquantes par variable
- Distribution des variables
- Identification des doublons potentiels

## Format de sortie

Les données nettoyées sont sauvegardées dans `data/processed/` :

- `patients_clean.rds` : Format R natif (recommandé)
- `patients_clean.csv` : Format CSV pour portabilité

## Confidentialité et sécurité

### Données sensibles

Les fichiers dans `data/raw/` et `data/processed/` contiennent des données de santé :
- **Ne jamais versionner** ces répertoires avec Git
- Ajoutés au `.gitignore` par défaut
- Stockage sécurisé uniquement

### Anonymisation

- Aucun nom, prénom, numéro de sécurité sociale
- Identifiants patients anonymisés
- Pas de variables permettant une ré-identification

## Support

Pour toute question sur la structure des données, consulter :
- Ce dictionnaire
- Le fichier `docs/methodology.md`
- Les scripts commentés dans `scripts/`

---

*Version 1.0 - Novembre 2025*
