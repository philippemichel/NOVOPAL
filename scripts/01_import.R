# ============================================================================ #
# NOVOPAL - Import et nettoyage des données
# ============================================================================ #
# Script: 01_import.R
# Objectif: Importer et nettoyer les données brutes des patients en soins palliatifs
# Auteur: Philippe MICHEL
# ============================================================================ #

# Chargement des packages ------------------------------------------------------
library(tidyverse)
library(lubridate)
library(readxl)

# Configuration ----------------------------------------------------------------
# Définir le répertoire de travail
if (!exists("project_root")) {
  project_root <- here::here()
}

# Chemins des fichiers
raw_data_path <- file.path(project_root, "data", "raw")
processed_data_path <- file.path(project_root, "data", "processed")

# Créer les répertoires s'ils n'existent pas
dir.create(processed_data_path, recursive = TRUE, showWarnings = FALSE)

# Import des données -----------------------------------------------------------
# Fonction d'import personnalisée
import_patient_data <- function(file_path) {
  
  # Détection du format de fichier
  file_ext <- tools::file_ext(file_path)
  
  data <- switch(file_ext,
    "csv" = read_csv(file_path, locale = locale(encoding = "UTF-8")),
    "xlsx" = read_excel(file_path),
    "xls" = read_excel(file_path),
    "rds" = readRDS(file_path),
    stop("Format de fichier non supporté")
  )
  
  return(data)
}

# Rechercher le fichier de données
data_files <- list.files(raw_data_path, 
                         pattern = "\\.(csv|xlsx|xls|rds)$", 
                         full.names = TRUE)

if (length(data_files) == 0) {
  message("Aucun fichier de données trouvé dans data/raw/")
  message("Création d'un jeu de données exemple...")
  
  # Créer des données exemple pour la démonstration
  set.seed(123)
  n_patients <- 150
  
  df_raw <- tibble(
    patient_id = sprintf("PAT%04d", 1:n_patients),
    age = round(rnorm(n_patients, mean = 75, sd = 12)),
    sexe = sample(c("M", "F"), n_patients, replace = TRUE, prob = c(0.48, 0.52)),
    diagnostic_principal = sample(
      c("Cancer pulmonaire", "Cancer digestif", "Cancer hématologique",
        "Insuffisance cardiaque", "BPCO", "Démence", "Cancer ORL",
        "Cancer urologique", "Cancer gynécologique"),
      n_patients, replace = TRUE
    ),
    comorbidites = sample(0:5, n_patients, replace = TRUE, prob = c(0.1, 0.2, 0.3, 0.2, 0.15, 0.05)),
    date_entree = as.Date("2023-01-01") + sample(0:364, n_patients, replace = TRUE),
    duree_sejour = round(rexp(n_patients, 1/45)),
    statut_sortie = sample(c("Décès", "Transfert", "Domicile"), 
                           n_patients, replace = TRUE, 
                           prob = c(0.65, 0.25, 0.10)),
    karnofsky = sample(seq(10, 50, by = 10), n_patients, replace = TRUE),
    douleur_entree = sample(0:10, n_patients, replace = TRUE)
  ) %>%
    mutate(
      date_sortie = date_entree + days(duree_sejour),
      age_groupe = case_when(
        age < 65 ~ "<65 ans",
        age < 75 ~ "65-74 ans",
        age < 85 ~ "75-84 ans",
        TRUE ~ "≥85 ans"
      )
    )
  
} else {
  message("Import du fichier: ", data_files[1])
  df_raw <- import_patient_data(data_files[1])
}

# Nettoyage des données --------------------------------------------------------

# Fonction de nettoyage
clean_patient_data <- function(data) {
  
  data_clean <- data %>%
    # Supprimer les doublons potentiels
    distinct() %>%
    
    # Nettoyer les noms de colonnes
    janitor::clean_names() %>%
    
    # Traiter les valeurs manquantes critiques
    filter(!is.na(patient_id)) %>%
    
    # Standardiser les variables catégorielles
    mutate(
      sexe = toupper(sexe),
      sexe = factor(sexe, levels = c("M", "F"), labels = c("Homme", "Femme"))
    ) %>%
    
    # Calculer des variables dérivées si nécessaire
    mutate(
      duree_sejour = if_else(is.na(duree_sejour) & !is.na(date_entree) & !is.na(date_sortie),
                             as.numeric(difftime(date_sortie, date_entree, units = "days")),
                             duree_sejour)
    ) %>%
    
    # Créer des catégories d'âge si elles n'existent pas
    mutate(
      age_groupe = if_else(is.na(age_groupe),
                           case_when(
                             age < 65 ~ "<65 ans",
                             age < 75 ~ "65-74 ans",
                             age < 85 ~ "75-84 ans",
                             TRUE ~ "≥85 ans"
                           ),
                           age_groupe)
    ) %>%
    
    # Ordonner les colonnes
    select(patient_id, age, age_groupe, sexe, everything())
  
  return(data_clean)
}

# Appliquer le nettoyage
df_clean <- clean_patient_data(df_raw)

# Validation des données -------------------------------------------------------

# Résumé des données
cat("\n=== RÉSUMÉ DES DONNÉES IMPORTÉES ===\n\n")
cat("Nombre de patients:", nrow(df_clean), "\n")
cat("Nombre de variables:", ncol(df_clean), "\n\n")

cat("Variables disponibles:\n")
print(names(df_clean))

cat("\n=== STATISTIQUES DESCRIPTIVES ===\n\n")
cat("Âge:\n")
print(summary(df_clean$age))

cat("\nDistribution par sexe:\n")
print(table(df_clean$sexe))

cat("\nValeurs manquantes par variable:\n")
missing_summary <- df_clean %>%
  summarise(across(everything(), ~sum(is.na(.)))) %>%
  pivot_longer(everything(), names_to = "variable", values_to = "n_missing") %>%
  filter(n_missing > 0)

if (nrow(missing_summary) > 0) {
  print(missing_summary)
} else {
  cat("Aucune valeur manquante détectée.\n")
}

# Sauvegarde des données nettoyées ---------------------------------------------

# Sauvegarder en format RDS (recommandé pour R)
saveRDS(df_clean, file.path(processed_data_path, "patients_clean.rds"))

# Sauvegarder également en CSV pour portabilité
write_csv(df_clean, file.path(processed_data_path, "patients_clean.csv"))

cat("\n=== EXPORT DES DONNÉES ===\n\n")
cat("Données nettoyées sauvegardées dans:\n")
cat("  - ", file.path(processed_data_path, "patients_clean.rds"), "\n")
cat("  - ", file.path(processed_data_path, "patients_clean.csv"), "\n")

# Créer un objet global pour les autres scripts
assign("df_patients", df_clean, envir = .GlobalEnv)

cat("\n✓ Import et nettoyage terminés avec succès\n")
