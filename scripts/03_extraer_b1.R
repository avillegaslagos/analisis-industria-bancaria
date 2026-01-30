# ==========================================================
# 03_extraer_b1.R
# Extrae archivos B1 desde 2021 en adelante
# (maneja .txt oculto en Windows)
# ==========================================================

library(stringr)

# -----------------------
# Rutas (usar /)
# -----------------------
ruta_unzip <- "data/raw/unzip"
ruta_b1    <- "data/raw/b1"

dir.create(ruta_b1, recursive = TRUE, showWarnings = FALSE)

# -----------------------
# Listar carpetas unzip
# -----------------------
carpetas <- list.dirs(ruta_unzip, recursive = FALSE)
cat("Carpetas a revisar:", length(carpetas), "\n")

contador <- 0

# -----------------------
# Recorrer carpetas
# -----------------------
for (carpeta in carpetas) {
  
  archivos <- list.files(
    carpeta,
    recursive = TRUE,
    full.names = TRUE
  )
  
  if (length(archivos) == 0) next
  
  # -----------------------
  # B1 reales:
  # b1YYYYMMBBB o b1YYYYMMBBB.txt
  # desde 2021
  # -----------------------
  archivos_b1 <- archivos[
    str_detect(
      basename(archivos),
      "^b1(202[1-9]|203[0-9])\\d{2}\\d{3}(\\.txt)?$"
    )
  ]
  
  if (length(archivos_b1) == 0) next
  
  # -----------------------
  # Copiar a carpeta b1
  # -----------------------
  for (archivo in archivos_b1) {
    
    nombre <- basename(archivo)
    destino <- file.path(ruta_b1, nombre)
    
    if (!file.exists(destino)) {
      file.copy(archivo, destino)
      contador <- contador + 1
      cat("Copiado:", nombre, "\n")
    }
  }
}

cat(
  "\nExtracción B1 finalizada.",
  "\nTotal archivos nuevos:", contador,
  "\n"
)
