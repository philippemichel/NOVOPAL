# ============================================================================ #
# NOVOPAL - Analyses descriptives
# ============================================================================ #
# Script: 02_descriptive.R
# Objectif: Analyses descriptives des caractéristiques des patients
# Auteur: Philippe MICHEL
# ============================================================================ #

# Chargement des packages ------------------------------------------------------
library(tidyverse)
library(gtsummary)
library(scales)
library(knitr)

# Configuration ----------------------------------------------------------------
if (!exists("project_root")) {
  project_root <- here::here()
}

output_path <- file.path(project_root, "output")
figures_path <- file.path(output_path, "figures")
tables_path <- file.path(output_path, "tables")

# Créer les répertoires de sortie
dir.create(figures_path, recursive = TRUE, showWarnings = FALSE)
dir.create(tables_path, recursive = TRUE, showWarnings = FALSE)

# Chargement des données -------------------------------------------------------
if (!exists("df_patients")) {
  processed_data_path <- file.path(project_root, "data", "processed")
  df_patients <- readRDS(file.path(processed_data_path, "patients_clean.rds"))
}

cat("\n=== ANALYSES DESCRIPTIVES DES PATIENTS ===\n\n")

# 1. CARACTÉRISTIQUES DÉMOGRAPHIQUES -------------------------------------------

cat("1. Caractéristiques démographiques\n")
cat("----------------------------------\n\n")

# Tableau descriptif général
tbl_demographie <- df_patients %>%
  select(age, age_groupe, sexe) %>%
  tbl_summary(
    label = list(
      age ~ "Âge (années)",
      age_groupe ~ "Groupe d'âge",
      sexe ~ "Sexe"
    ),
    statistic = list(
      all_continuous() ~ "{mean} ({sd})",
      all_categorical() ~ "{n} ({p}%)"
    )
  ) %>%
  modify_header(label ~ "**Caractéristique**") %>%
  modify_caption("**Tableau 1. Caractéristiques démographiques**") %>%
  bold_labels()

print(tbl_demographie)

# Sauvegarder le tableau
tbl_demographie %>%
  as_flex_table() %>%
  flextable::save_as_docx(path = file.path(tables_path, "tableau1_demographie.docx"))

# Graphique: Distribution de l'âge
p_age <- ggplot(df_patients, aes(x = age)) +
  geom_histogram(binwidth = 5, fill = "steelblue", color = "white", alpha = 0.8) +
  geom_vline(aes(xintercept = mean(age, na.rm = TRUE)), 
             color = "red", linetype = "dashed", linewidth = 1) +
  labs(
    title = "Distribution de l'âge des patients",
    x = "Âge (années)",
    y = "Effectif",
    caption = paste0("Âge moyen: ", round(mean(df_patients$age, na.rm = TRUE), 1), " ans")
  ) +
  theme_minimal() +
  theme(plot.title = element_text(face = "bold"))

ggsave(file.path(figures_path, "fig1_distribution_age.png"), 
       p_age, width = 8, height = 5, dpi = 300)

# Graphique: Répartition par sexe et groupe d'âge
p_sexe_age <- df_patients %>%
  count(age_groupe, sexe) %>%
  ggplot(aes(x = age_groupe, y = n, fill = sexe)) +
  geom_col(position = "dodge", alpha = 0.8) +
  geom_text(aes(label = n), position = position_dodge(width = 0.9), 
            vjust = -0.5, size = 3.5) +
  scale_fill_manual(values = c("Homme" = "#4A90E2", "Femme" = "#E94B3C")) +
  labs(
    title = "Répartition des patients par groupe d'âge et sexe",
    x = "Groupe d'âge",
    y = "Effectif",
    fill = "Sexe"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold"),
    legend.position = "top"
  )

ggsave(file.path(figures_path, "fig2_repartition_sexe_age.png"), 
       p_sexe_age, width = 10, height = 6, dpi = 300)

# 2. CARACTÉRISTIQUES CLINIQUES ------------------------------------------------

cat("\n2. Caractéristiques cliniques\n")
cat("-----------------------------\n\n")

# Tableau des caractéristiques cliniques
tbl_clinique <- df_patients %>%
  select(diagnostic_principal, comorbidites, karnofsky, douleur_entree) %>%
  tbl_summary(
    label = list(
      diagnostic_principal ~ "Diagnostic principal",
      comorbidites ~ "Nombre de comorbidités",
      karnofsky ~ "Score de Karnofsky",
      douleur_entree ~ "Douleur à l'entrée (0-10)"
    ),
    statistic = list(
      all_continuous() ~ "{median} [{p25}, {p75}]",
      all_categorical() ~ "{n} ({p}%)"
    )
  ) %>%
  modify_header(label ~ "**Caractéristique**") %>%
  modify_caption("**Tableau 2. Caractéristiques cliniques**") %>%
  bold_labels()

print(tbl_clinique)

# Sauvegarder le tableau
tbl_clinique %>%
  as_flex_table() %>%
  flextable::save_as_docx(path = file.path(tables_path, "tableau2_clinique.docx"))

# Graphique: Distribution des diagnostics principaux
p_diagnostics <- df_patients %>%
  count(diagnostic_principal, sort = TRUE) %>%
  mutate(
    diagnostic_principal = fct_reorder(diagnostic_principal, n),
    pct = n / sum(n) * 100
  ) %>%
  ggplot(aes(x = diagnostic_principal, y = n)) +
  geom_col(fill = "steelblue", alpha = 0.8) +
  geom_text(aes(label = paste0(n, "\n(", round(pct, 1), "%)")), 
            hjust = -0.1, size = 3) +
  coord_flip() +
  labs(
    title = "Distribution des diagnostics principaux",
    x = NULL,
    y = "Nombre de patients"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold"),
    axis.text.y = element_text(size = 9)
  ) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.15)))

ggsave(file.path(figures_path, "fig3_diagnostics.png"), 
       p_diagnostics, width = 10, height = 7, dpi = 300)

# 3. PRISE EN CHARGE ET OUTCOMES -----------------------------------------------

cat("\n3. Prise en charge et outcomes\n")
cat("------------------------------\n\n")

# Tableau de la prise en charge
tbl_prise_en_charge <- df_patients %>%
  select(duree_sejour, statut_sortie) %>%
  tbl_summary(
    label = list(
      duree_sejour ~ "Durée de séjour (jours)",
      statut_sortie ~ "Statut de sortie"
    ),
    statistic = list(
      duree_sejour ~ "{median} [{p25}, {p75}]"
    )
  ) %>%
  add_stat_label() %>%
  modify_header(label ~ "**Caractéristique**") %>%
  modify_caption("**Tableau 3. Prise en charge et outcomes**") %>%
  bold_labels()

print(tbl_prise_en_charge)

# Sauvegarder le tableau
tbl_prise_en_charge %>%
  as_flex_table() %>%
  flextable::save_as_docx(path = file.path(tables_path, "tableau3_prise_en_charge.docx"))

# Graphique: Distribution de la durée de séjour
p_duree <- ggplot(df_patients, aes(x = duree_sejour)) +
  geom_histogram(binwidth = 10, fill = "steelblue", color = "white", alpha = 0.8) +
  geom_vline(aes(xintercept = median(duree_sejour, na.rm = TRUE)), 
             color = "red", linetype = "dashed", linewidth = 1) +
  labs(
    title = "Distribution de la durée de séjour",
    x = "Durée de séjour (jours)",
    y = "Effectif",
    caption = paste0("Médiane: ", median(df_patients$duree_sejour, na.rm = TRUE), " jours")
  ) +
  theme_minimal() +
  theme(plot.title = element_text(face = "bold")) +
  scale_x_continuous(limits = c(0, NA))

ggsave(file.path(figures_path, "fig4_duree_sejour.png"), 
       p_duree, width = 8, height = 5, dpi = 300)

# Graphique: Statut de sortie
p_sortie <- df_patients %>%
  count(statut_sortie) %>%
  mutate(
    pct = n / sum(n) * 100,
    label_pos = cumsum(pct) - 0.5 * pct
  ) %>%
  ggplot(aes(x = "", y = pct, fill = statut_sortie)) +
  geom_col(alpha = 0.8, color = "white", linewidth = 1) +
  geom_text(aes(y = label_pos, label = paste0(n, "\n(", round(pct, 1), "%)")), 
            color = "white", fontface = "bold", size = 4) +
  coord_polar(theta = "y") +
  scale_fill_brewer(palette = "Set2") +
  labs(
    title = "Répartition des statuts de sortie",
    fill = "Statut"
  ) +
  theme_void() +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5),
    legend.position = "bottom"
  )

ggsave(file.path(figures_path, "fig5_statut_sortie.png"), 
       p_sortie, width = 8, height = 6, dpi = 300)

# 4. TABLEAU RÉCAPITULATIF COMPLET ---------------------------------------------

cat("\n4. Tableau récapitulatif\n")
cat("------------------------\n\n")

# Créer un tableau complet avec tous les indicateurs principaux
tbl_complet <- df_patients %>%
  select(age, sexe, diagnostic_principal, comorbidites, 
         karnofsky, douleur_entree, duree_sejour, statut_sortie) %>%
  tbl_summary(
    label = list(
      age ~ "Âge (années)",
      sexe ~ "Sexe",
      diagnostic_principal ~ "Diagnostic principal",
      comorbidites ~ "Nombre de comorbidités",
      karnofsky ~ "Score de Karnofsky",
      douleur_entree ~ "Douleur à l'entrée (0-10)",
      duree_sejour ~ "Durée de séjour (jours)",
      statut_sortie ~ "Statut de sortie"
    ),
    statistic = list(
      all_continuous() ~ "{mean} ({sd}) | {median} [{p25}, {p75}]",
      all_categorical() ~ "{n} ({p}%)"
    ),
    missing = "no"
  ) %>%
  modify_header(label ~ "**Caractéristique**", stat_0 ~ "**N = {N}**") %>%
  modify_caption("**Tableau récapitulatif. Caractéristiques de la cohorte**") %>%
  bold_labels()

print(tbl_complet)

# Sauvegarder le tableau complet
tbl_complet %>%
  as_flex_table() %>%
  flextable::save_as_docx(path = file.path(tables_path, "tableau_complet.docx"))

# Résumé final -----------------------------------------------------------------

cat("\n=== RÉSUMÉ DES ANALYSES DESCRIPTIVES ===\n\n")
cat("Nombre total de patients:", nrow(df_patients), "\n")
cat("Âge moyen:", round(mean(df_patients$age, na.rm = TRUE), 1), "ans\n")
cat("Sex-ratio H/F:", round(sum(df_patients$sexe == "Homme") / sum(df_patients$sexe == "Femme"), 2), "\n")
cat("Durée médiane de séjour:", median(df_patients$duree_sejour, na.rm = TRUE), "jours\n")
cat("\nFigures sauvegardées dans:", figures_path, "\n")
cat("Tableaux sauvegardés dans:", tables_path, "\n")

cat("\n✓ Analyses descriptives terminées avec succès\n")
