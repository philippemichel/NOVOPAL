# Guide de contribution - NOVOPAL

Merci de votre intérêt pour contribuer au projet NOVOPAL ! Ce document fournit des lignes directrices pour contribuer au projet.

## Code de conduite

En participant à ce projet, vous acceptez de respecter les principes suivants :
- Respect mutuel et bienveillance
- Communication constructive
- Collaboration dans l'intérêt du projet
- Respect de la confidentialité des données

## Comment contribuer

### Signaler un bug

Si vous trouvez un bug, veuillez ouvrir une issue en incluant :
- Description claire du problème
- Étapes pour reproduire le bug
- Comportement attendu vs observé
- Environnement (version R, OS, packages)
- Messages d'erreur complets

### Proposer une amélioration

Pour proposer une nouvelle fonctionnalité :
1. Vérifier qu'elle n'existe pas déjà
2. Ouvrir une issue pour discussion
3. Décrire clairement le besoin et l'usage
4. Proposer une implémentation si possible

### Soumettre des modifications

1. **Fork** le projet
2. Créer une **branche** pour votre fonctionnalité
   ```bash
   git checkout -b feature/ma-fonctionnalite
   ```
3. **Commiter** vos changements
   ```bash
   git commit -m "Ajout: description de la fonctionnalité"
   ```
4. **Push** vers votre fork
   ```bash
   git push origin feature/ma-fonctionnalite
   ```
5. Ouvrir une **Pull Request**

## Standards de code

### Style R

Suivre le [tidyverse style guide](https://style.tidyverse.org/) :
- Utiliser `<-` pour l'affectation
- Indentation : 2 espaces
- Noms de variables : snake_case
- Noms de fonctions : snake_case
- Ligne max : 80 caractères (flexible à 100)

Exemple :
```r
# Bon
calculate_mean_age <- function(data) {
  mean_age <- mean(data$age, na.rm = TRUE)
  return(mean_age)
}

# À éviter
CalculateMeanAge = function(d) {
return(mean(d$age,na.rm=T))
}
```

### Documentation

- **Commentaires** : en français, clairs et concis
- **Fonctions** : documenter avec roxygen2
  ```r
  #' Calculer la moyenne d'âge
  #'
  #' @param data Un dataframe contenant une colonne age
  #' @return La moyenne d'âge
  #' @export
  calculate_mean_age <- function(data) {
    # Code
  }
  ```

### Structure des scripts

Chaque script doit suivre cette structure :
```r
# ============================================================================ #
# NOVOPAL - Titre du script
# ============================================================================ #
# Script: nom_du_script.R
# Objectif: Description
# Auteur: Nom
# ============================================================================ #

# Chargement des packages ------------------------------------------------------
library(package1)

# Configuration ----------------------------------------------------------------
# Variables de configuration

# Fonctions locales -----------------------------------------------------------
# Fonctions spécifiques au script

# Code principal ---------------------------------------------------------------
# Corps du script

# Résumé final -----------------------------------------------------------------
# Messages de fin et nettoyage
```

## Types de contributions

### Code

- Scripts d'analyse
- Fonctions utilitaires
- Corrections de bugs
- Optimisations

### Documentation

- Amélioration du README
- Guides utilisateur
- Exemples d'utilisation
- Traductions

### Tests

- Ajout de tests unitaires
- Validation de données
- Tests d'intégration

### Visualisations

- Nouveaux types de graphiques
- Amélioration des graphiques existants
- Templates de rapports

## Processus de revue

1. **Revue automatique** : vérification du style
2. **Revue par les pairs** : examen du code
3. **Tests** : validation fonctionnelle
4. **Discussion** : commentaires et ajustements
5. **Merge** : intégration après approbation

## Gestion des données

⚠️ **IMPORTANT** : 
- **Jamais** commiter de vraies données patients
- Utiliser des données anonymisées ou synthétiques pour les exemples
- Respecter le RGPD et la confidentialité
- Les données doivent rester dans les répertoires exclus (.gitignore)

## Versioning

Le projet suit [Semantic Versioning](https://semver.org/lang/fr/) :
- **MAJOR** : changements incompatibles
- **MINOR** : nouvelles fonctionnalités compatibles
- **PATCH** : corrections de bugs

Format : `MAJOR.MINOR.PATCH` (ex: 1.2.3)

## Commits

### Messages de commit

Format : `Type: Description courte`

Types :
- `Ajout:` nouvelle fonctionnalité
- `Fix:` correction de bug
- `Doc:` documentation
- `Style:` formatage, pas de changement de code
- `Refactor:` restructuration du code
- `Test:` ajout/modification de tests
- `Perf:` amélioration de performance

Exemples :
```
Ajout: fonction de calcul des IC pour proportions
Fix: correction du calcul de la durée de séjour
Doc: mise à jour du guide utilisateur
```

## Tests

Avant de soumettre :
1. Vérifier que le code s'exécute sans erreur
2. Tester avec différentes configurations
3. Vérifier les sorties (tableaux, graphiques)
4. Valider la documentation

### Tests manuels

```r
# Tester l'import
source("scripts/01_import.R")

# Vérifier les données
str(df_patients)
summary(df_patients)

# Tester les analyses
source("scripts/02_descriptive.R")
```

## Dépendances

### Ajouter un nouveau package

1. Vérifier la nécessité
2. Choisir un package maintenu
3. Ajouter à `main.R` dans `required_packages`
4. Documenter dans le README
5. Tester l'installation

## Documentation

### Mise à jour de la documentation

Lors d'un changement, mettre à jour :
- README.md (si impact utilisateur)
- CHANGELOG.md (toujours)
- docs/ (si changement méthodologique)
- Commentaires dans le code

## Questions

Pour toute question :
1. Consulter la documentation existante
2. Chercher dans les issues
3. Ouvrir une nouvelle issue si nécessaire

## Remerciements

Les contributions sont valorisées et reconnues :
- Mention dans CHANGELOG.md
- Co-auteurs dans les commits significatifs
- Remerciements dans les publications

## Licence

En contribuant, vous acceptez que vos contributions soient sous licence MIT (voir LICENSE).

---

Merci de contribuer à NOVOPAL ! 🙏
