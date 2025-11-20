# ============================================================================ #
# NOVOPAL - Analyses analytiques
# ============================================================================ #
# Script: 03_analytical.R
# Objectif: Analyses statistiques comparatives et multivariées
# Auteur: Philippe MICHEL
# ============================================================================ #

# Chargement des packages ------------------------------------------------------
library(tidyverse)
library(gtsummary)
library(survival)
library(survminer)
library(broom)

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

cat("\n=== ANALYSES ANALYTIQUES ===\n\n")

# 1. COMPARAISONS SELON LE STATUT DE SORTIE ------------------------------------

cat("1. Analyses comparatives selon le statut de sortie\n")
cat("--------------------------------------------------\n\n")

# Tableau comparatif stratifié par statut de sortie
tbl_comparaison_sortie <- df_patients %>%
  select(age, sexe, diagnostic_principal, comorbidites, 
         karnofsky, douleur_entree, duree_sejour, statut_sortie) %>%
  tbl_summary(
    by = statut_sortie,
    label = list(
      age ~ "Âge (années)",
      sexe ~ "Sexe",
      diagnostic_principal ~ "Diagnostic principal",
      comorbidites ~ "Nombre de comorbidités",
      karnofsky ~ "Score de Karnofsky",
      douleur_entree ~ "Douleur à l'entrée",
      duree_sejour ~ "Durée de séjour (jours)"
    ),
    statistic = list(
      all_continuous() ~ "{median} [{p25}, {p75}]",
      all_categorical() ~ "{n} ({p}%)"
    )
  ) %>%
  add_p() %>%
  add_overall() %>%
  modify_header(label ~ "**Caractéristique**") %>%
  modify_caption("**Tableau 4. Comparaison selon le statut de sortie**") %>%
  bold_labels() %>%
  bold_p()

print(tbl_comparaison_sortie)

# Sauvegarder
tbl_comparaison_sortie %>%
  as_flex_table() %>%
  flextable::save_as_docx(path = file.path(tables_path, "tableau4_comparaison_sortie.docx"))

# 2. ANALYSES SELON LE GROUPE D'ÂGE -------------------------------------------

cat("\n2. Analyses selon le groupe d'âge\n")
cat("---------------------------------\n\n")

# Tableau comparatif par groupe d'âge
tbl_comparaison_age <- df_patients %>%
  select(age_groupe, sexe, diagnostic_principal, comorbidites, 
         karnofsky, douleur_entree, duree_sejour, statut_sortie) %>%
  tbl_summary(
    by = age_groupe,
    label = list(
      sexe ~ "Sexe",
      diagnostic_principal ~ "Diagnostic principal",
      comorbidites ~ "Nombre de comorbidités",
      karnofsky ~ "Score de Karnofsky",
      douleur_entree ~ "Douleur à l'entrée",
      duree_sejour ~ "Durée de séjour (jours)",
      statut_sortie ~ "Statut de sortie"
    ),
    statistic = list(
      all_continuous() ~ "{median} [{p25}, {p75}]",
      all_categorical() ~ "{n} ({p}%)"
    )
  ) %>%
  add_p() %>%
  modify_header(label ~ "**Caractéristique**") %>%
  modify_caption("**Tableau 5. Comparaison selon le groupe d'âge**") %>%
  bold_labels() %>%
  bold_p()

print(tbl_comparaison_age)

# Sauvegarder
tbl_comparaison_age %>%
  as_flex_table() %>%
  flextable::save_as_docx(path = file.path(tables_path, "tableau5_comparaison_age.docx"))

# 3. ANALYSE DE SURVIE ---------------------------------------------------------

cat("\n3. Analyse de survie\n")
cat("--------------------\n\n")

# Préparer les données pour l'analyse de survie
df_survie <- df_patients %>%
  mutate(
    # Événement = décès (1 si décès, 0 sinon)
    event = if_else(statut_sortie == "Décès", 1, 0),
    # Temps = durée de séjour
    time = duree_sejour
  ) %>%
  filter(!is.na(time) & time > 0)

# Modèle de survie de base
surv_fit <- survfit(Surv(time, event) ~ 1, data = df_survie)

# Tableau récapitulatif de survie
cat("Survie médiane:", 
    round(summary(surv_fit)$table["median"], 1), 
    "jours\n")

# Graphique de survie global
p_surv_global <- ggsurvplot(
  surv_fit,
  data = df_survie,
  conf.int = TRUE,
  risk.table = TRUE,
  risk.table.height = 0.25,
  ggtheme = theme_minimal(),
  palette = "steelblue",
  title = "Courbe de survie globale",
  xlab = "Temps (jours)",
  ylab = "Probabilité de survie",
  legend = "none"
)

ggsave(file.path(figures_path, "fig6_survie_globale.png"), 
       print(p_surv_global), width = 10, height = 8, dpi = 300)

# Survie stratifiée par sexe
surv_fit_sexe <- survfit(Surv(time, event) ~ sexe, data = df_survie)

p_surv_sexe <- ggsurvplot(
  surv_fit_sexe,
  data = df_survie,
  conf.int = TRUE,
  pval = TRUE,
  risk.table = TRUE,
  risk.table.height = 0.25,
  ggtheme = theme_minimal(),
  palette = c("#4A90E2", "#E94B3C"),
  title = "Courbe de survie par sexe",
  xlab = "Temps (jours)",
  ylab = "Probabilité de survie",
  legend.title = "Sexe",
  legend.labs = c("Homme", "Femme")
)

ggsave(file.path(figures_path, "fig7_survie_sexe.png"), 
       print(p_surv_sexe), width = 10, height = 8, dpi = 300)

# Survie stratifiée par groupe d'âge
surv_fit_age <- survfit(Surv(time, event) ~ age_groupe, data = df_survie)

p_surv_age <- ggsurvplot(
  surv_fit_age,
  data = df_survie,
  conf.int = FALSE,
  pval = TRUE,
  risk.table = TRUE,
  risk.table.height = 0.3,
  ggtheme = theme_minimal(),
  palette = "Set1",
  title = "Courbe de survie par groupe d'âge",
  xlab = "Temps (jours)",
  ylab = "Probabilité de survie",
  legend.title = "Groupe d'âge"
)

ggsave(file.path(figures_path, "fig8_survie_age.png"), 
       print(p_surv_age), width = 10, height = 8, dpi = 300)

# 4. MODÈLE DE COX -------------------------------------------------------------

cat("\n4. Modèle de régression de Cox\n")
cat("------------------------------\n\n")

# Modèle de Cox univarié pour chaque variable
cox_univarie <- df_survie %>%
  select(time, event, age, sexe, comorbidites, karnofsky, douleur_entree) %>%
  tbl_uvregression(
    method = coxph,
    y = Surv(time, event),
    exponentiate = TRUE,
    label = list(
      age ~ "Âge (années)",
      sexe ~ "Sexe",
      comorbidites ~ "Nombre de comorbidités",
      karnofsky ~ "Score de Karnofsky",
      douleur_entree ~ "Douleur à l'entrée"
    )
  ) %>%
  bold_p() %>%
  bold_labels()

print(cox_univarie)

# Sauvegarder
cox_univarie %>%
  as_flex_table() %>%
  flextable::save_as_docx(path = file.path(tables_path, "tableau6_cox_univarie.docx"))

# Modèle de Cox multivarié
cox_model <- coxph(Surv(time, event) ~ age + sexe + comorbidites + karnofsky, 
                   data = df_survie)

tbl_cox_multivarie <- cox_model %>%
  tbl_regression(
    exponentiate = TRUE,
    label = list(
      age ~ "Âge (années)",
      sexe ~ "Sexe",
      comorbidites ~ "Nombre de comorbidités",
      karnofsky ~ "Score de Karnofsky"
    )
  ) %>%
  bold_p() %>%
  bold_labels() %>%
  modify_caption("**Tableau 7. Modèle de Cox multivarié**")

print(tbl_cox_multivarie)

# Sauvegarder
tbl_cox_multivarie %>%
  as_flex_table() %>%
  flextable::save_as_docx(path = file.path(tables_path, "tableau7_cox_multivarie.docx"))

# 5. FACTEURS ASSOCIÉS À LA DURÉE DE SÉJOUR ------------------------------------

cat("\n5. Facteurs associés à la durée de séjour\n")
cat("-----------------------------------------\n\n")

# Régression linéaire pour la durée de séjour
df_duree <- df_patients %>%
  filter(!is.na(duree_sejour)) %>%
  mutate(log_duree = log(duree_sejour + 1))  # Transformation log

model_duree <- lm(log_duree ~ age + sexe + comorbidites + karnofsky + douleur_entree,
                  data = df_duree)

tbl_duree <- model_duree %>%
  tbl_regression(
    label = list(
      age ~ "Âge (années)",
      sexe ~ "Sexe",
      comorbidites ~ "Nombre de comorbidités",
      karnofsky ~ "Score de Karnofsky",
      douleur_entree ~ "Douleur à l'entrée"
    )
  ) %>%
  add_glance_table(include = c(r.squared, adj.r.squared)) %>%
  bold_p() %>%
  bold_labels() %>%
  modify_caption("**Tableau 8. Facteurs associés à la durée de séjour (log-transformée)**")

print(tbl_duree)

# Sauvegarder
tbl_duree %>%
  as_flex_table() %>%
  flextable::save_as_docx(path = file.path(tables_path, "tableau8_facteurs_duree.docx"))

# Graphique: Durée de séjour selon le score de Karnofsky
p_duree_karnofsky <- df_patients %>%
  mutate(karnofsky_cat = factor(karnofsky)) %>%
  ggplot(aes(x = karnofsky_cat, y = duree_sejour)) +
  geom_boxplot(fill = "steelblue", alpha = 0.6) +
  geom_jitter(width = 0.2, alpha = 0.3, color = "darkblue") +
  labs(
    title = "Durée de séjour selon le score de Karnofsky",
    x = "Score de Karnofsky",
    y = "Durée de séjour (jours)"
  ) +
  theme_minimal() +
  theme(plot.title = element_text(face = "bold"))

ggsave(file.path(figures_path, "fig9_duree_karnofsky.png"), 
       p_duree_karnofsky, width = 10, height = 6, dpi = 300)

# 6. ANALYSE DES COMORBIDITÉS --------------------------------------------------

cat("\n6. Impact des comorbidités\n")
cat("--------------------------\n\n")

# Créer des catégories de comorbidités
df_patients_comor <- df_patients %>%
  mutate(
    comorbidite_cat = case_when(
      comorbidites == 0 ~ "Aucune",
      comorbidites <= 2 ~ "1-2 comorbidités",
      TRUE ~ "≥3 comorbidités"
    ),
    comorbidite_cat = factor(comorbidite_cat, 
                             levels = c("Aucune", "1-2 comorbidités", "≥3 comorbidités"))
  )

# Tableau comparatif
tbl_comorbidites <- df_patients_comor %>%
  select(comorbidite_cat, age, sexe, karnofsky, duree_sejour, statut_sortie) %>%
  tbl_summary(
    by = comorbidite_cat,
    label = list(
      age ~ "Âge (années)",
      sexe ~ "Sexe",
      karnofsky ~ "Score de Karnofsky",
      duree_sejour ~ "Durée de séjour (jours)",
      statut_sortie ~ "Statut de sortie"
    ),
    statistic = list(
      all_continuous() ~ "{median} [{p25}, {p75}]",
      all_categorical() ~ "{n} ({p}%)"
    )
  ) %>%
  add_p() %>%
  modify_header(label ~ "**Caractéristique**") %>%
  modify_caption("**Tableau 9. Caractéristiques selon le nombre de comorbidités**") %>%
  bold_labels() %>%
  bold_p()

print(tbl_comorbidites)

# Sauvegarder
tbl_comorbidites %>%
  as_flex_table() %>%
  flextable::save_as_docx(path = file.path(tables_path, "tableau9_comorbidites.docx"))

# Graphique: Impact des comorbidités sur la survie
df_survie_comor <- df_survie %>%
  mutate(
    comorbidite_cat = case_when(
      comorbidites == 0 ~ "Aucune",
      comorbidites <= 2 ~ "1-2 comorbidités",
      TRUE ~ "≥3 comorbidités"
    ),
    comorbidite_cat = factor(comorbidite_cat, 
                             levels = c("Aucune", "1-2 comorbidités", "≥3 comorbidités"))
  )

surv_fit_comor <- survfit(Surv(time, event) ~ comorbidite_cat, data = df_survie_comor)

p_surv_comor <- ggsurvplot(
  surv_fit_comor,
  data = df_survie_comor,
  conf.int = FALSE,
  pval = TRUE,
  risk.table = TRUE,
  risk.table.height = 0.25,
  ggtheme = theme_minimal(),
  palette = c("#2ECC71", "#F39C12", "#E74C3C"),
  title = "Courbe de survie selon les comorbidités",
  xlab = "Temps (jours)",
  ylab = "Probabilité de survie",
  legend.title = "Comorbidités"
)

ggsave(file.path(figures_path, "fig10_survie_comorbidites.png"), 
       print(p_surv_comor), width = 10, height = 8, dpi = 300)

# Résumé final -----------------------------------------------------------------

cat("\n=== RÉSUMÉ DES ANALYSES ANALYTIQUES ===\n\n")
cat("Analyses réalisées:\n")
cat("  - Comparaisons selon le statut de sortie\n")
cat("  - Comparaisons selon le groupe d'âge\n")
cat("  - Analyses de survie (globale et stratifiées)\n")
cat("  - Modèles de Cox (univariés et multivariés)\n")
cat("  - Facteurs associés à la durée de séjour\n")
cat("  - Impact des comorbidités\n")
cat("\nFigures sauvegardées dans:", figures_path, "\n")
cat("Tableaux sauvegardés dans:", tables_path, "\n")

cat("\n✓ Analyses analytiques terminées avec succès\n")
