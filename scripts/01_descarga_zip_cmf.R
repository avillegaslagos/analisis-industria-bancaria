# ==========================================
# 01_descargar_zip.R
# Descarga ZIP mensuales CMF
# ==========================================

library(rvest)
library(stringr)

# --------------------------------------------------
# RUTA DEFINITIVA DE DESCARGA (RELATIVA AL PROYECTO)
# --------------------------------------------------
ruta_zip <- "data/raw/zip"
dir.create(ruta_zip, recursive = TRUE, showWarnings = FALSE)

# --------------------------------------------------
# URL base correcta
# --------------------------------------------------
url_base <- "https://www.cmfchile.cl/portal/estadisticas/617/w3-propertyvalue-28917.html"
url_base_descarga <- "https://www.cmfchile.cl/portal/estadisticas/617/"

cat("Leyendo página CMF...\n")

pagina <- read_html(url_base)

# --------------------------------------------------
# Extraer links ZIP
# --------------------------------------------------
links_zip <- pagina %>%
  html_nodes("a") %>%
  html_attr("href") %>%
  na.omit() %>%
  str_subset("^articles-.*_recurso_1\\.zip$")

cat("ZIP encontrados:", length(links_zip), "\n")

# --------------------------------------------------
# Descargar solo ZIP nuevos
# --------------------------------------------------
for (archivo in links_zip) {
  
  url_completa <- paste0(url_base_descarga, archivo)
  destino <- file.path(ruta_zip, archivo)
  
  if (!file.exists(destino)) {
    cat("Descargando:", archivo, "\n")
    
    try(
      download.file(
        url = url_completa,
        destfile = destino,
        mode = "wb",
        quiet = TRUE
      ),
      silent = TRUE
    )
    
  } else {
    cat("Ya existe:", archivo, "\n")
  }
}

cat("Descarga de ZIP finalizada.\n")
