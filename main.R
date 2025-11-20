# ============================================================================ #
# NOVOPAL - Script principal d'analyse
# ============================================================================ #
# Script: main.R
# Description: Script principal pour exécuter toutes les analyses
# Auteur: Philippe MICHEL
# ============================================================================ #

# Configuration initiale -------------------------------------------------------
cat("\n")
cat("╔═══════════════════════════════════════════════════════════════════════════╗\n")
cat("║                              NOVOPAL                                      ║\n")
cat("║  Étude descriptive et analytique des patients en soins palliatifs        ║\n")
cat("╚═══════════════════════════════════════════════════════════════════════════╝\n")
cat("\n")

# Définir le répertoire de travail
if (!requireNamespace("here", quietly = TRUE)) {
  install.packages("here")
}
library(here)
project_root <- here::here()

# Vérification et installation des packages ------------------------------------
cat("Vérification des packages nécessaires...\n")

required_packages <- c(
  "tidyverse",    # Manipulation et visualisation des données
  "gtsummary",    # Tableaux statistiques
  "survival",     # Analyses de survie
  "survminer",    # Visualisation des analyses de survie
  "rmarkdown",    # Génération de rapports
  "knitr",        # Intégration dans les rapports
  "lubridate",    # Manipulation des dates
  "scales",       # Formatage des graphiques
  "readxl",       # Lecture de fichiers Excel
  "writexl",      # Écriture de fichiers Excel
  "janitor",      # Nettoyage des données
  "broom",        # Extraction des résultats de modèles
  "flextable",    # Tableaux pour Word
  "kableExtra"    # Tableaux pour HTML
)

# Fonction pour installer les packages manquants
install_if_missing <- function(packages) {
  new_packages <- packages[!(packages %in% installed.packages()[,"Package"])]
  if(length(new_packages) > 0) {
    cat("Installation des packages manquants:", paste(new_packages, collapse = ", "), "\n")
    install.packages(new_packages, dependencies = TRUE)
  }
}

install_if_missing(required_packages)

# Chargement de tous les packages
cat("Chargement des packages...\n")
suppressPackageStartupMessages({
  library(tidyverse)
  library(gtsummary)
  library(survival)
  library(survminer)
  library(here)
})

# Configurer le thème gtsummary en français
theme_gtsummary_language("fr", decimal.mark = ",", big.mark = " ")

cat("✓ Packages chargés avec succès\n\n")

# Créer la structure des répertoires ------------------------------------------
cat("Vérification de la structure des répertoires...\n")

required_dirs <- c(
  "data/raw",
  "data/processed",
  "R",
  "scripts",
  "docs",
  "output/figures",
  "output/tables",
  "output/reports"
)

for (dir in required_dirs) {
  dir_path <- file.path(project_root, dir)
  if (!dir.exists(dir_path)) {
    dir.create(dir_path, recursive = TRUE)
    cat("  Créé:", dir, "\n")
  }
}

cat("✓ Structure des répertoires OK\n\n")

# Charger les fonctions personnalisées -----------------------------------------
cat("Chargement des fonctions personnalisées...\n")

if (file.exists(file.path(project_root, "R", "utils.R"))) {
  source(file.path(project_root, "R", "utils.R"))
  cat("✓ Fonctions utilitaires chargées\n\n")
}

# Options d'exécution ----------------------------------------------------------
cat("╔═══════════════════════════════════════════════════════════════════════════╗\n")
cat("║                         OPTIONS D'EXÉCUTION                               ║\n")
cat("╚═══════════════════════════════════════════════════════════════════════════╝\n\n")

cat("Sélectionnez les analyses à exécuter:\n")
cat("  1. Import et nettoyage des données\n")
cat("  2. Analyses descriptives\n")
cat("  3. Analyses analytiques\n")
cat("  4. Génération du rapport complet\n")
cat("  5. Tout exécuter (1+2+3+4)\n")
cat("\n")

# Pour l'exécution automatique, on fait tout par défaut
run_mode <- 5  # Tout exécuter par défaut

# Mode interactif si souhaité (décommenter pour utilisation interactive)
# cat("Votre choix (1-5) : ")
# run_mode <- as.integer(readLines("stdin", n = 1))

# Exécution des analyses -------------------------------------------------------

start_time <- Sys.time()

# 1. Import et nettoyage
if (run_mode %in% c(1, 5)) {
  cat("\n")
  cat("╔═══════════════════════════════════════════════════════════════════════════╗\n")
  cat("║                  ÉTAPE 1: IMPORT ET NETTOYAGE DES DONNÉES                ║\n")
  cat("╚═══════════════════════════════════════════════════════════════════════════╝\n\n")
  
  tryCatch({
    source(file.path(project_root, "scripts", "01_import.R"))
  }, error = function(e) {
    cat("✗ Erreur lors de l'import:", conditionMessage(e), "\n")
    stop("Arrêt de l'exécution")
  })
}

# 2. Analyses descriptives
if (run_mode %in% c(2, 5)) {
  cat("\n")
  cat("╔═══════════════════════════════════════════════════════════════════════════╗\n")
  cat("║                    ÉTAPE 2: ANALYSES DESCRIPTIVES                        ║\n")
  cat("╚═══════════════════════════════════════════════════════════════════════════╝\n\n")
  
  tryCatch({
    source(file.path(project_root, "scripts", "02_descriptive.R"))
  }, error = function(e) {
    cat("✗ Erreur lors des analyses descriptives:", conditionMessage(e), "\n")
  })
}

# 3. Analyses analytiques
if (run_mode %in% c(3, 5)) {
  cat("\n")
  cat("╔═══════════════════════════════════════════════════════════════════════════╗\n")
  cat("║                    ÉTAPE 3: ANALYSES ANALYTIQUES                         ║\n")
  cat("╚═══════════════════════════════════════════════════════════════════════════╝\n\n")
  
  tryCatch({
    source(file.path(project_root, "scripts", "03_analytical.R"))
  }, error = function(e) {
    cat("✗ Erreur lors des analyses analytiques:", conditionMessage(e), "\n")
  })
}

# 4. Génération du rapport
if (run_mode %in% c(4, 5)) {
  cat("\n")
  cat("╔═══════════════════════════════════════════════════════════════════════════╗\n")
  cat("║                  ÉTAPE 4: GÉNÉRATION DU RAPPORT                          ║\n")
  cat("╚═══════════════════════════════════════════════════════════════════════════╝\n\n")
  
  report_file <- file.path(project_root, "report.Rmd")
  
  if (file.exists(report_file)) {
    tryCatch({
      # Générer le rapport HTML
      cat("Génération du rapport HTML...\n")
      output_html <- file.path(project_root, "output", "reports", "NOVOPAL_rapport.html")
      rmarkdown::render(
        report_file,
        output_format = "html_document",
        output_file = output_html,
        quiet = FALSE
      )
      cat("✓ Rapport HTML généré:", output_html, "\n")
      
      # Générer le rapport Word si possible
      cat("\nGénération du rapport Word...\n")
      output_word <- file.path(project_root, "output", "reports", "NOVOPAL_rapport.docx")
      rmarkdown::render(
        report_file,
        output_format = "word_document",
        output_file = output_word,
        quiet = FALSE
      )
      cat("✓ Rapport Word généré:", output_word, "\n")
      
    }, error = function(e) {
      cat("✗ Erreur lors de la génération du rapport:", conditionMessage(e), "\n")
    })
  } else {
    cat("✗ Fichier report.Rmd introuvable\n")
  }
}

# Résumé final -----------------------------------------------------------------

end_time <- Sys.time()
duration <- difftime(end_time, start_time, units = "secs")

cat("\n")
cat("╔═══════════════════════════════════════════════════════════════════════════╗\n")
cat("║                         ANALYSES TERMINÉES                                ║\n")
cat("╚═══════════════════════════════════════════════════════════════════════════╝\n\n")

cat("Durée totale d'exécution:", round(duration, 2), "secondes\n\n")

cat("Résultats disponibles dans:\n")
cat("  - Figures:  ", file.path(project_root, "output", "figures"), "\n")
cat("  - Tableaux: ", file.path(project_root, "output", "tables"), "\n")
cat("  - Rapports: ", file.path(project_root, "output", "reports"), "\n")

cat("\n")
cat("═══════════════════════════════════════════════════════════════════════════\n")
cat("Pour consulter les résultats:\n")
cat("  - Ouvrir le rapport HTML dans un navigateur\n")
cat("  - Consulter les figures dans output/figures/\n")
cat("  - Consulter les tableaux dans output/tables/\n")
cat("═══════════════════════════════════════════════════════════════════════════\n\n")

cat("✓ Analyse NOVOPAL terminée avec succès!\n\n")
