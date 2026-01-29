#  ------------------------------------------------------------------------
#
# Title : import NOVOPAL
#    By : PhM
#  Date : 2026-01-29
#
#  ------------------------------------------------------------------------


# Packages ----------------------------------------------------------------
library("baseph")
library("tidyverse")
library("readODS")
library("janitor")
library("lubridate")
library("labelled")



# Import data -------------------------------------------------------------

tt <- read_ods("datas/novopal.ods", sheet = "BDD", na = c("", " ", "NC")) |>
  clean_names() |>
  mutate(across(starts_with("date"), ~ mdy(.x))) |>
  mutate(across(is.character, ~ as.factor(.x))) |>
  mutate(age_dc = fct_relevel(
    age_dc,
    "< 35 ans", "[35;45[", "[45;55[", "[55;65[", "[65;75[", "≥ 75 ans"
  )) |>
  mutate(distance_ch = fct_relevel(
    distance_ch,
    "< 10 min", "10-20 min", "> 20 min"
  )) |>
  mutate(age_mt = fct_relevel(
    age_mt,
    "< 35 ans", "[35;45[", "[45;55[", "[55;65["
  )) |>
  mutate(statut_oms = as.factor(statut_oms)) |>
  mutate(nb_hsop = as.factor(fct_recode(as.character(nb_hsop),
    "3 et plus" = "3",
    "3 et plus" = "4",
    "3 et plus" = "5"
  ))) |>
  mutate(nb_urg = as.factor(fct_recode(as.character(nb_urg),
    "3 et plus" = "3",
    "3 et plus" = "4",
    "3 et plus" = "5",
    "3 et plus" = "6"
  )))

bn <- read_ods("datas/novopal.ods", sheet = "bnom", na = c("", " ", "NC"))
var_label(tt) <- bn$code

tt <- tt |>
  mutate(delai_contact = as.numeric(tt$date_contact - tt$date_diagnostic)) |>
  mutate(delai_deces = as.numeric(tt$date_dc - tt$date_contact)) |>
  dplyr::select(-starts_with("date")) |>
  dplyr::select(-motif_urg)

var_label(tt$delai_contact) <- "Délai diagnostic / contact EMSP (j)"
var_label(tt$delai_deces) <- "Délai contact EMSP/décès (j)"

# Save data ---------------------------------------------------------------
save(tt, file = "datas/novopal.RData")
load("datas/novopal.RData")
