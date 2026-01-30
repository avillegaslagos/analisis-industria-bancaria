# ==========================================
# 02_descomprimir_zip.R
# Descomprime ZIP CMF de forma incremental
# ==========================================

# --------------------------------------------------
# Rutas (usar SIEMPRE / y no \)
# --------------------------------------------------
ruta_zip   <- "data/raw/zip"
ruta_unzip <- "data/raw/unzip"

dir.create(ruta_unzip, recursive = TRUE, showWarnings = FALSE)

# --------------------------------------------------
# Listar ZIP descargados
# --------------------------------------------------
zips <- list.files(
  ruta_zip,
  pattern = "\\.zip$",
  full.names = TRUE
)

cat("ZIP encontrados:", length(zips), "\n")

# --------------------------------------------------
# Descomprimir solo ZIP nuevos
# --------------------------------------------------
for (zipfile in zips) {
  
  nombre_base <- tools::file_path_sans_ext(basename(zipfile))
  carpeta_destino <- file.path(ruta_unzip, nombre_base)
  
  # Si ya está descomprimido, saltar
  if (dir.exists(carpeta_destino)) {
    cat("Ya descomprimido:", basename(zipfile), "\n")
    next
  }
  
  dir.create(carpeta_destino, recursive = TRUE)
  
  # Listar contenido real del ZIP
  contenido <- tryCatch(
    unzip(zipfile, list = TRUE),
    error = function(e) NULL
  )
  
  if (is.null(contenido) || nrow(contenido) == 0) {
    cat("ZIP vacío o corrupto:", basename(zipfile), "\n")
    next
  }
  
  # Extraer archivo por archivo (evita errores Windows)
  for (i in seq_len(nrow(contenido))) {
    try(
      unzip(
        zipfile,
        files = contenido$Name[i],
        exdir = carpeta_destino,
        overwrite = TRUE
      ),
      silent = TRUE
    )
  }
  
  cat("Descomprimido:", basename(zipfile), "\n")
}

cat("Descompresión finalizada.\n")
