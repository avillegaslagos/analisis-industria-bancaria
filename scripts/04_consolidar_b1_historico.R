# ==========================================================
# 04_consolidar_b1_historico.R
# Consolida histórico B1 desde archivos CMF
# ==========================================================

library(dplyr)
library(readr)
library(stringr)

# ----------------------------------------------------------
# Rutas
# ----------------------------------------------------------
ruta_b1     <- "data/raw/b1"
ruta_output <- "data/processed"

dir.create(ruta_output, recursive = TRUE, showWarnings = FALSE)

archivo_salida <- file.path(ruta_output, "b1_historico.csv")

# ----------------------------------------------------------
# Listar archivos B1
# ----------------------------------------------------------
archivos_b1 <- list.files(
  ruta_b1,
  pattern = "^b1\\d{9}\\.txt$",
  full.names = TRUE
)

cat("Archivos B1 encontrados:", length(archivos_b1), "\n")
stopifnot(length(archivos_b1) > 0)

# ----------------------------------------------------------
# Función lectura B1
# ----------------------------------------------------------
leer_b1 <- function(path) {
  
  nombre <- basename(path)
  
  periodo_yyyymm <- substr(nombre, 3, 8)
  banco_codigo   <- substr(nombre, 9, 11)
  
  # Leer archivo B1 (estructura real CMF)
  df_raw <- read_table(
    path,
    skip = 1,  # Salta encabezado tipo "037 BANCO SANTANDER-CHILE"
    col_names = c("ifrs", "clp", "uf", "mx", "total"),
    col_types = cols(.default = col_character())
  )
  
  df_raw %>%
    mutate(
      banco_codigo = banco_codigo,
      periodo = as.Date(paste0(periodo_yyyymm, "01"), "%Y%m%d"),
      
      clp = parse_number(clp, locale = locale(decimal_mark = ",")),
      uf  = parse_number(uf,  locale = locale(decimal_mark = ",")),
      mx  = parse_number(mx,  locale = locale(decimal_mark = ",")),
      mx2 = parse_number(total, locale = locale(decimal_mark = ","))
    ) %>%
    select(
      banco_codigo,
      periodo,
      ifrs,
      clp,
      uf,
      mx,
      mx2
    )
}

# ----------------------------------------------------------
# Procesamiento completo
# ----------------------------------------------------------
lista_datos <- lapply(archivos_b1, leer_b1)
df_nuevo <- bind_rows(lista_datos)

cat("Filas nuevas procesadas:", nrow(df_nuevo), "\n")
stopifnot(nrow(df_nuevo) > 0)

# ----------------------------------------------------------
# Guardado incremental consistente
# ----------------------------------------------------------
if (file.exists(archivo_salida)) {
  
  historico <- read_csv2(
    archivo_salida,
    col_types = cols(
      banco_codigo = col_character(),
      periodo      = col_date(),
      ifrs         = col_character(),
      clp          = col_double(),
      uf           = col_double(),
      mx           = col_double(),
      mx2          = col_double()
    )
  )
  
  df_final <- bind_rows(historico, df_nuevo) %>%
    distinct(banco_codigo, periodo, ifrs, .keep_all = TRUE)
  
} else {
  df_final <- df_nuevo
}

# ----------------------------------------------------------
# Guardar salida final (Excel-friendly)
# ----------------------------------------------------------
write_csv2(df_final, archivo_salida)

cat(
  "\nProceso finalizado correctamente",
  "\nFilas totales:", nrow(df_final),
  "\nPeriodo:",
  min(df_final$periodo, na.rm = TRUE), "a",
  max(df_final$periodo, na.rm = TRUE),
  "\nArchivo:", archivo_salida,
  "\n"
)
