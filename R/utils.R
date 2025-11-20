# ============================================================================ #
# NOVOPAL - Fonctions utilitaires
# ============================================================================ #
# Fichier: R/utils.R
# Fonctions personnalisées pour l'analyse des données
# ============================================================================ #

#' Créer un résumé descriptif personnalisé
#'
#' @param data Un dataframe
#' @param var_continuous Variables continues à résumer
#' @param var_categorical Variables catégorielles à résumer
#'
#' @return Un dataframe avec les statistiques descriptives
#' @export
summary_stats <- function(data, var_continuous = NULL, var_categorical = NULL) {
  
  results <- list()
  
  # Statistiques pour les variables continues
  if (!is.null(var_continuous)) {
    cont_stats <- data %>%
      select(all_of(var_continuous)) %>%
      summarise(across(
        everything(),
        list(
          n = ~sum(!is.na(.)),
          mean = ~mean(., na.rm = TRUE),
          sd = ~sd(., na.rm = TRUE),
          median = ~median(., na.rm = TRUE),
          q25 = ~quantile(., 0.25, na.rm = TRUE),
          q75 = ~quantile(., 0.75, na.rm = TRUE),
          min = ~min(., na.rm = TRUE),
          max = ~max(., na.rm = TRUE)
        ),
        .names = "{.col}_{.fn}"
      ))
    
    results$continuous <- cont_stats
  }
  
  # Statistiques pour les variables catégorielles
  if (!is.null(var_categorical)) {
    cat_stats <- data %>%
      select(all_of(var_categorical)) %>%
      summarise(across(
        everything(),
        list(
          n = ~sum(!is.na(.)),
          n_unique = ~n_distinct(., na.rm = TRUE)
        ),
        .names = "{.col}_{.fn}"
      ))
    
    results$categorical <- cat_stats
  }
  
  return(results)
}

#' Calculer les intervalles de confiance pour une proportion
#'
#' @param x Nombre de succès
#' @param n Nombre total d'observations
#' @param conf_level Niveau de confiance (par défaut 0.95)
#'
#' @return Un vecteur avec la proportion et son IC à 95%
#' @export
prop_ci <- function(x, n, conf_level = 0.95) {
  
  if (n == 0) return(c(prop = NA, lower = NA, upper = NA))
  
  prop <- x / n
  se <- sqrt(prop * (1 - prop) / n)
  z <- qnorm((1 + conf_level) / 2)
  
  lower <- max(0, prop - z * se)
  upper <- min(1, prop + z * se)
  
  return(c(prop = prop, lower = lower, upper = upper))
}

#' Formatter les p-values pour affichage
#'
#' @param p P-value
#' @param digits Nombre de décimales
#'
#' @return Une chaîne formatée
#' @export
format_pvalue <- function(p, digits = 3) {
  if (is.na(p)) return("NA")
  if (p < 0.001) return("< 0.001")
  if (p < 0.01) return(paste0("< 0.01"))
  return(format(round(p, digits), nsmall = digits))
}

#' Créer un tableau de contingence avec pourcentages
#'
#' @param data Un dataframe
#' @param var1 Première variable
#' @param var2 Deuxième variable
#'
#' @return Un tableau avec effectifs et pourcentages
#' @export
cross_table <- function(data, var1, var2) {
  
  tbl <- table(data[[var1]], data[[var2]])
  prop_tbl <- prop.table(tbl, margin = 1) * 100
  
  result <- as.data.frame(tbl)
  result$Percentage <- as.vector(prop_tbl)
  
  names(result) <- c(var1, var2, "Count", "Percentage")
  
  return(result)
}

#' Calculer les OR avec IC95%
#'
#' @param a Cellule a du tableau 2x2
#' @param b Cellule b du tableau 2x2
#' @param c Cellule c du tableau 2x2
#' @param d Cellule d du tableau 2x2
#'
#' @return Un vecteur avec OR et IC95%
#' @export
odds_ratio <- function(a, b, c, d) {
  
  or <- (a * d) / (b * c)
  se_log_or <- sqrt(1/a + 1/b + 1/c + 1/d)
  
  lower <- exp(log(or) - 1.96 * se_log_or)
  upper <- exp(log(or) + 1.96 * se_log_or)
  
  return(c(OR = or, lower_95 = lower, upper_95 = upper))
}

#' Appliquer le test approprié selon le type de variables
#'
#' @param data Un dataframe
#' @param var_outcome Variable de résultat
#' @param var_predictor Variable prédictive
#'
#' @return Résultat du test statistique
#' @export
auto_test <- function(data, var_outcome, var_predictor) {
  
  outcome_type <- class(data[[var_outcome]])
  predictor_type <- class(data[[var_predictor]])
  
  # Numérique vs Catégorielle
  if (outcome_type %in% c("numeric", "integer") && 
      predictor_type %in% c("factor", "character")) {
    
    groups <- unique(data[[var_predictor]])
    n_groups <- length(groups)
    
    if (n_groups == 2) {
      # Test de Wilcoxon
      result <- wilcox.test(data[[var_outcome]] ~ data[[var_predictor]])
      return(list(test = "Wilcoxon", p_value = result$p.value))
    } else {
      # Test de Kruskal-Wallis
      result <- kruskal.test(data[[var_outcome]] ~ data[[var_predictor]])
      return(list(test = "Kruskal-Wallis", p_value = result$p.value))
    }
  }
  
  # Catégorielle vs Catégorielle
  if (outcome_type %in% c("factor", "character") && 
      predictor_type %in% c("factor", "character")) {
    
    tbl <- table(data[[var_outcome]], data[[var_predictor]])
    
    # Test exact de Fisher si petit effectif
    if (any(tbl < 5)) {
      result <- fisher.test(tbl)
      return(list(test = "Fisher", p_value = result$p.value))
    } else {
      result <- chisq.test(tbl)
      return(list(test = "Chi-square", p_value = result$p.value))
    }
  }
  
  # Numérique vs Numérique
  if (outcome_type %in% c("numeric", "integer") && 
      predictor_type %in% c("numeric", "integer")) {
    
    result <- cor.test(data[[var_outcome]], data[[var_predictor]], 
                       method = "spearman")
    return(list(test = "Spearman", correlation = result$estimate, 
                p_value = result$p.value))
  }
  
  return(list(test = "Unknown", p_value = NA))
}

#' Créer un graphique en forêt pour les résultats de régression
#'
#' @param model Un modèle de régression (lm, glm, coxph)
#'
#' @return Un graphique ggplot
#' @export
forest_plot <- function(model) {
  
  # Extraire les coefficients
  coefs <- broom::tidy(model, conf.int = TRUE, exponentiate = TRUE)
  
  # Filtrer l'intercept si présent
  coefs <- coefs %>%
    filter(term != "(Intercept)")
  
  # Créer le graphique
  p <- ggplot(coefs, aes(x = estimate, y = term)) +
    geom_vline(xintercept = 1, linetype = "dashed", color = "red") +
    geom_errorbarh(aes(xmin = conf.low, xmax = conf.high), height = 0.2) +
    geom_point(size = 3, color = "steelblue") +
    labs(
      title = "Forest Plot - Hazard Ratios / Odds Ratios",
      x = "HR / OR (IC 95%)",
      y = NULL
    ) +
    theme_minimal() +
    theme(
      plot.title = element_text(face = "bold"),
      panel.grid.major.y = element_blank()
    )
  
  return(p)
}

#' Exporter plusieurs tableaux vers Excel
#'
#' @param table_list Liste nommée de tableaux
#' @param file_path Chemin du fichier Excel
#'
#' @export
export_tables_excel <- function(table_list, file_path) {
  
  if (!requireNamespace("writexl", quietly = TRUE)) {
    stop("Le package 'writexl' est nécessaire pour cette fonction.")
  }
  
  writexl::write_xlsx(table_list, path = file_path)
  message("Tableaux exportés vers: ", file_path)
}

#' Nettoyer les noms de colonnes
#'
#' @param data Un dataframe
#'
#' @return Dataframe avec noms de colonnes nettoyés
#' @export
clean_names <- function(data) {
  
  names(data) <- names(data) %>%
    tolower() %>%
    gsub("[^[:alnum:]_]", "_", .) %>%
    gsub("_+", "_", .) %>%
    gsub("^_|_$", "", .)
  
  return(data)
}

#' Vérifier la qualité des données
#'
#' @param data Un dataframe
#'
#' @return Un rapport de qualité
#' @export
data_quality_report <- function(data) {
  
  report <- data.frame(
    variable = names(data),
    n_total = nrow(data),
    n_missing = sapply(data, function(x) sum(is.na(x))),
    pct_missing = sapply(data, function(x) round(sum(is.na(x)) / length(x) * 100, 2)),
    n_unique = sapply(data, function(x) n_distinct(x, na.rm = TRUE)),
    type = sapply(data, class)
  )
  
  rownames(report) <- NULL
  
  return(report)
}
