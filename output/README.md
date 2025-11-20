# Résultats de l'analyse

## Structure

Ce répertoire contient tous les résultats générés par les analyses :

```
output/
├── figures/          # Graphiques et visualisations (PNG, 300 DPI)
├── tables/           # Tableaux statistiques (DOCX)
└── reports/          # Rapports complets (HTML, DOCX)
```

## Figures

Les graphiques générés incluent :
- Distribution de l'âge des patients
- Répartition par sexe et groupe d'âge
- Distribution des diagnostics
- Durée de séjour
- Statut de sortie
- Courbes de survie (Kaplan-Meier)
- Analyses stratifiées

Format : PNG haute résolution (300 DPI)

## Tableaux

Les tableaux générés incluent :
- Caractéristiques démographiques
- Caractéristiques cliniques
- Prise en charge et outcomes
- Comparaisons selon différents critères
- Modèles de régression (Cox, linéaire)
- Analyses multivariées

Format : DOCX (Microsoft Word)

## Rapports

Les rapports complets incluent :
- Rapport HTML interactif (recommandé pour visualisation)
- Rapport Word (pour édition et distribution)

Ces rapports intègrent :
- Toutes les analyses descriptives et analytiques
- Tableaux et figures
- Interprétations statistiques
- Code R reproductible

## Notes

- Les fichiers de ce répertoire ne sont pas versionnés (voir `.gitignore`)
- Ils peuvent être régénérés à tout moment en exécutant les scripts
- Sauvegarder manuellement les résultats importants
