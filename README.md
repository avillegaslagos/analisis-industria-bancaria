# Análisis de la Industria Bancaria Chilena con Datos CMF

## Descripción del proyecto
Este proyecto desarrolla un pipeline en R para automatizar la descarga, limpieza y consolidación de información financiera pública de la industria bancaria chilena, utilizando datos publicados por la Comisión para el Mercado Financiero (CMF).

El objetivo es reducir el desfase en la disponibilidad de análisis comparativos entre instituciones financieras, proporcionando una base de datos histórica reproducible y lista para análisis.

---

## Objetivo general
- Automatizar la obtención de datos financieros desde la CMF
- Limpiar y consolidar información financiera histórica
- Construir un dataset base para análisis comparativos de la industria bancaria

---

## Alcance del MVP (Entrega 2)
En la segunda etapa del proyecto se desarrolla el Producto Mínimo Viable (MVP), enfocado en:

- Descarga automatizada de archivos ZIP publicados por la CMF
- Extracción y lectura de archivos contables B1
- Limpieza y validación de datos
- Consolidación histórica de la información en un único dataset
- Generación de un archivo CSV reproducible como fuente oficial de análisis

---

# El resultado de esta etapa corresponde al archivo:

data/processed/b1_historico.csv

---

## Estructura del repositorio

analisis-industria-bancaria/
│
├── scripts/ 
│ ├── 01_descargar_zip.R
│ ├── 02_descomprimir_zip.R
│ ├── 03_extraer_b1.R
│ └── 04_consolidar_b1_historico.R
│
├── data/
│ ├── raw/                # Datos crudos CMF (TXT B1)
│ └── processed/          # Dataset consolidado
│ └── b1_historico.csv    # 
│
├── docs/ # Documentación del proyecto
│ ├── entrega_1.pdf
│ ├── entrega_2_mvp.Rmd
│ └── entrega_2_mvp.pdf
│
└── README.md

---

## Próximos pasos (Entrega 3)
La siguiente etapa del proyecto contempla:

- Definición y cálculo de indicadores financieros comparables
- Análisis descriptivo de la industria bancaria
- Visualización de variables clave
- Documentación completa de la solución
- Descripción de despliegue y monitoreo del proceso

---

## Tecnologías utilizadas
- R
- RStudio
- tidyverse
- Git / GitHub


## Autor
Angélica Villegas  
Diplomado en Ciencia de Datos para Finanzas
