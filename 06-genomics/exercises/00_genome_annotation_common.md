# 🧬 Anotación de Genomas: Guía de Prácticas — Introducción y Casos de Estudio

> [!NOTE]
> Este documento es el **punto de entrada compartido** para todas las prácticas de anotación genómica del Módulo 6. Contiene el contexto biológico, las plataformas de trabajo y los datos de cada caso. Las guías de procedimiento específicas están en los siguientes archivos:
>
> | Práctica                                                         | Plataforma    | Herramientas                                                            |
> |:-----------------------------------------------------------------|:--------------|:------------------------------------------------------------------------|
> | [Práctica A — Galaxy](01_1_genome_annotation_galaxy.md)          | Galaxy Europe | Bakta, AMRFinderPlus, PlasmidFinder, IntegronFinder, ISEScan            |
> | [Práctica B — Google Colab](01_2_genome_annotattion_colab.ipynb) | Google Colab  | Bakta, AMRFinderPlus, PlasmidFinder, **antiSMASH** (via conda) + Python |
>
> Esta práctica reutiliza los **mismos 20 casos** (organismos) de los Módulos 4 (filogenética) y 5 (ensamblaje). Defina el mismo número de `CASO` (01–20) que trabajó antes. Algunos casos tienen grupo taxonómico disponible en AMRFinderPlus y/o son especialmente recomendados para **antiSMASH** (género productor de metabolitos secundarios) — esto se indica en la tabla de casos más abajo.

---

## Introducción

La **anotación genómica** es el proceso de describir la estructura y la función de los componentes de un genoma ensamblado. Es el paso que convierte un archivo FASTA con contigs — una secuencia larga pero "muda" — en un mapa biológico interpretable: dónde están los genes, qué hacen, qué elementos móviles lleva el organismo y qué genes de resistencia o virulencia posee.

El proceso se divide en dos grandes etapas:

- **Anotación estructural:** identifica la localización de genes codificantes (CDS), ARN de transferencia (ARNt), ARN ribosomales (ARNr), regiones reguladoras y otros elementos funcionales.
- **Anotación funcional:** asigna una función biológica a cada elemento estructural, comparando contra bases de datos de secuencias y perfiles de proteínas (BLAST, HMM).

> [!TIP]
> Para repasar los conceptos de estructura génica, tipos de genes, algoritmos de predicción y bases de datos de anotación, lea las secciones **2, 3 y 4** del [README del Módulo 6](../README.md) antes de comenzar. Estos conceptos **no se repiten aquí**.

En estas prácticas trabajará con el **mismo organismo (caso)** que usó en los Módulos 4 y 5, pero el genoma de entrada **no es su propio ensamblaje** sino el **genoma de referencia de NCBI** usado para evaluar con QUAST en el Módulo 5. Esto es intencional:

- Garantiza que **todos los estudiantes con el mismo caso anoten exactamente el mismo genoma**, sin importar la calidad de su propio ensamblaje — así las comparaciones entre compañeros y con la literatura son justas.
- Permite comparar directamente los resultados de Bakta con la anotación curada de RefSeq/GenBank para el mismo genoma.
- Evita que un ensamblaje fragmentado o de baja calidad (muchos contigs pequeños) complique la interpretación de genes de resistencia, plásmidos o BGC.

> [!TIP]
> Si ya ensambló sus propias lecturas en el Módulo 5 y quiere comparar su ensamblaje contra el de referencia, puede ejecutar esta práctica dos veces: una con `contigs_path` apuntando al genoma de referencia (por defecto) y otra apuntando a sus propios contigs (`GenomeAssembly/caso_XX_<tech>/results/assembly/contigs.fasta`). Esto es opcional y no se pide por defecto.

---

## 🔬 Flujo de trabajo general

Todas las prácticas siguen el mismo flujo de anotación:

```
Contigs ensamblados (FASTA)
        │
        ▼
[ 1. Anotación estructural + funcional ] ← Bakta
        │
        ├──────────────────────────────────────────┐
        ▼                                          ▼
[ 2. Genes de resistencia y virulencia ]  [ 3. Plásmidos ]
        AMRFinderPlus                       PlasmidFinder
        │
        ▼
[ 4. Integrones ]   ← IntegronFinder
        │
        ▼
[ 5. Elementos IS ] ← ISEScan
        │
        ▼
[ 6. Interpretación integrada ]
```

> [!NOTE]
> Bakta realiza la anotación principal (estructura + función). Las herramientas adicionales (AMRFinderPlus, PlasmidFinder, IntegronFinder, ISEScan) complementan la anotación con análisis específicos de **elementos de resistencia y movilidad génica** — de particular importancia en microbiología clínica.

---

## 🖥️ Plataformas de trabajo

### Opción 1: Galaxy Europe (Práctica A)

Galaxy es una plataforma web que permite ejecutar herramientas bioinformáticas sin instalar nada ni escribir código.

🔗 **<https://usegalaxy.eu>**

> [!IMPORTANT]
> Use **<https://usegalaxy.eu>** (servidor europeo). El servidor <https://usegalaxy.org> puede presentar inconvenientes con algunas herramientas.

**Primeros pasos:**
1. Si no tiene cuenta, regístrese en <https://usegalaxy.eu>.
2. Para cada práctica, cree un **historial nuevo**: haga clic en `+` (esquina superior derecha) y renómbrelo con ✏️.

**Códigos de color en Galaxy:**

| Color             | Estado                                   |
|:------------------|:-----------------------------------------|
| 🟡 Gris / en cola | Esperando para ejecutarse                |
| 🟠 Naranja        | Ejecutándose                             |
| 🟢 Verde          | Listo ✅                                  |
| 🔴 Rojo           | Falló — haga clic en ⓘ para ver el error |

### Opción 2: Google Colab con conda (Práctica B)

Google Colab es un entorno de notebooks Python en la nube de Google. La **Práctica B** usa `conda` para instalar las herramientas directamente en el entorno del notebook.

🔗 **<https://colab.research.google.com>**

**Primeros pasos:**
1. Ingrese a <https://colab.research.google.com> con su cuenta de Google.
2. Abra el notebook [`01_2_genome_annotattion_colab.ipynb`](01_2_genome_annotattion_colab.ipynb).
3. Haga clic en `Entorno de ejecución` → `Cambiar tipo` → seleccione **CPU estándar**.
4. Ejecute las celdas en orden. La primera celda instala conda y los paquetes (~5–10 min).

> [!WARNING]
> Las sesiones de Google Colab **se desconectan tras ~90 min de inactividad**. Guarde los resultados en Google Drive antes de cerrar.

---

## 🧫 Casos de estudio

El profesor indicará cuál caso trabajar (**mismo número usado en los Módulos 4 y 5**). Use los datos de **un solo organismo** para no consumir espacio innecesario.

> [!NOTE]
> Para el contexto biológico/clínico/ambiental detallado de cada organismo, consulte la [guía del Módulo 5](../05_sequencing/exercises/00_genome_assembly_common.md#-casos-de-estudio) (misma numeración de casos). Aquí solo se listan los datos necesarios para la anotación: genoma de referencia, grupo taxonómico de AMRFinderPlus (si existe) y si antiSMASH es especialmente recomendado.

| Caso | Especie                             | Tamaño genoma  | Referencia (anotación)   | Grupo AMRFinderPlus          | antiSMASH recomendado   |
|:----:|:------------------------------------|:---------------|:-------------------------|:-----------------------------|:-----------------------:|
|  01  | *Klebsiella pneumoniae*             | ~5.5 Mb        | GCF_061393185.1          | `Klebsiella_pneumoniae`      |            —            |
|  02  | *Escherichia coli*                  | ~5.0 Mb        | GCF_030285565.1 ⚠️       | `Escherichia`                |            —            |
|  03  | *Pseudomonas abieticivorans*        | ~6.7 Mb        | GCF_023509015.1          | `Pseudomonas_aeruginosa`     |            ✅            |
|  04  | *Streptomyces venezuelae*           | ~8.2 Mb        | GCA_050632295.1          | — (sin grupo)                |            ✅            |
|  05  | *Streptomyces coelicolor*           | ~8.7 Mb        | GCF_047824265.1          | — (sin grupo)                |            ✅            |
|  06  | *Bacillus subtilis*                 | ~4.2 Mb        | GCF_982518465.1          | — (sin grupo)                |            ✅            |
|  07  | *Staphylococcus aureus* (MRSA)      | ~2.8 Mb        | GCF_982303505.1          | `Staphylococcus_aureus`      |            —            |
|  08  | *Vibrio cholerae*                   | ~4.0 Mb        | GCF_055797365.1          | `Vibrio_cholerae`            |            —            |
|  09  | *Mycobacterium tuberculosis*        | ~4.4 Mb        | GCF_061392705.1          | `Mycobacterium_tuberculosis` |            —            |
|  10  | *Agrobacterium tumefaciens*         | ~5.6 Mb        | GCA_047731285.1          | — (sin grupo)                |            —            |
|  11  | *Deinococcus radiodurans*           | ~3.3 Mb        | GCF_045277105.1          | — (sin grupo)                |            —            |
|  12  | *Thermus thermophilus*              | ~2.1 Mb        | GCF_059705435.1          | — (sin grupo)                |            —            |
|  13  | *Lactobacillus acidophilus*         | ~2.0 Mb        | GCF_988235355.1          | — (sin grupo)                |            —            |
|  14  | *Helicobacter pylori*               | ~1.6 Mb        | GCA_059997335.1          | — (sin grupo)                |            —            |
|  15  | *Salmonella enterica*               | ~4.8 Mb        | GCF_061253545.1          | `Salmonella`                 |            —            |
|  16  | *Bacillus licheniformis*            | ~4.3 Mb        | GCA_055397075.1          | — (sin grupo)                |            —            |
|  17  | *Paenibacillus polymyxa*            | ~5.8 Mb        | GCF_056645015.1          | — (sin grupo)                |            ✅            |
|  18  | *Synechocystis* sp.                 | ~3.6 Mb        | GCA_987480225.1          | — (sin grupo)                |            —            |
|  19  | *Enterococcus faecalis*             | ~3.0 Mb        | GCA_061255735.1          | `Enterococcus_faecalis`      |            —            |
|  20  | *Shewanella oneidensis*             | ~4.9 Mb        | GCF_000146165.2          | — (sin grupo)                |            —            |

> [!IMPORTANT]
> **⚠️ Caso 02 — nota especial:** en el Módulo 5 este caso usó **dos genomas de referencia distintos** (uno por bloque Illumina/Nanopore, porque las lecturas provienen de cepas diferentes — ver guía del Módulo 5). Para anotación se usa un **único** genoma: `GCF_030285565.1` (genoma completo, cepa C51), por ser el ensamblaje *finished* (cromosoma cerrado) y dar una anotación más limpia que el borrador de 74 contigs del otro genoma.
>
> **Casos sin grupo taxonómico en AMRFinderPlus:** igual se ejecuta la herramienta, solo que sin el flag `--organism` (búsqueda genérica por homología, sin la curación adicional específica de especie). Esto no impide detectar genes de resistencia, solo reduce la resolución de algunas reglas específicas de la especie.
>
> **antiSMASH recomendado (✅):** son géneros con historial conocido de producción de metabolitos secundarios (antibióticos, sideróforos, lipopéptidos). **Puede ejecutar antiSMASH en cualquier caso** — el paso 9 del notebook no está restringido — pero en los casos marcados es más probable encontrar BGC interesantes para las preguntas de reflexión.

<details>
<summary>📥 Cargar genoma en Galaxy (haga clic para expandir)</summary>

En Galaxy, haga clic en `Upload` → `Paste/Fetch data` y pegue la URL de referencia de su caso (columna "Referencia" de la tabla — use el [listado completo de URLs de la guía del Módulo 5](../05_sequencing/exercises/00_genome_assembly_common.md) para construir la URL FTP, o pida la lista al profesor).

Formato general de la URL FTP de NCBI:

```
https://ftp.ncbi.nlm.nih.gov/genomes/all/<GCF_o_GCA>/<3-dig>/<3-dig>/<3-dig>/<accesion>_<nombre_ensamblaje>/<accesion>_<nombre_ensamblaje>_genomic.fna.gz
```

Haga clic en `Start`. Galaxy descomprimirá el archivo automáticamente.

</details>

<details>
<summary>💻 Descargar genoma desde terminal o Colab (haga clic para expandir)</summary>

En la Práctica B (Colab), la descarga es automática: solo defina `CASO = "01"` (o el número asignado) en la celda de configuración y ejecute — el notebook ya tiene embebidas las 20 URLs de referencia. Para Galaxy o terminal manual:

```bash
mkdir -p annotation/caso_XX/data && cd annotation/caso_XX
wget "<URL_de_referencia_de_su_caso>" -O data/ref_genomic.fna.gz
gunzip data/ref_genomic.fna.gz
mv data/ref_genomic.fna data/contigs.fasta
echo "✅ Genoma descargado: $(grep -c '>' data/contigs.fasta) secuencias"
```

</details>

---

## 🧠 Conceptos clave antes de empezar

### ¿Qué hace Bakta y por qué es el estándar actual?

**Bakta** (Schwengers et al. 2021) es el sucesor recomendado de Prokka para la anotación de genomas bacterianos. En un solo flujo de trabajo realiza:

| Elemento anotado                      | Método                                          |
|:--------------------------------------|:------------------------------------------------|
| Genes codificantes (CDS)              | Comparación contra base de datos propia + BLAST |
| ARNt                                  | tRNAscan-SE                                     |
| ARNr                                  | Infernal (perfiles de covariance models)        |
| ncRNA y cis-regulatory elements       | Infernal                                        |
| Genes de resistencia a antibióticos   | AMRFinderPlus integrado                         |
| Secuencias CRISPR                     | Pilercr                                         |
| Péptidos señal y péptidos de membrana | DeepSig / Phobius                               |

Los formatos de salida incluyen **GFF3**, **GenBank (.gbk)**, **FASTA de proteínas**, **FASTA de nucleótidos** y un **SVG** con el mapa circular del genoma.

### ¿Por qué anotar también genes de resistencia y elementos móviles?

En microbiología clínica, la anotación estándar no es suficiente. Para comprender el potencial patogénico y epidemiológico de un aislado es necesario identificar:

| Elemento                                      | Herramienta    | ¿Por qué importa?                                                                       |
|:----------------------------------------------|:---------------|:----------------------------------------------------------------------------------------|
| **Genes de resistencia a antibióticos (ARG)** | AMRFinderPlus  | Guía el tratamiento clínico; detecta resistencias emergentes                            |
| **Factores de virulencia**                    | AMRFinderPlus  | Explica la capacidad de causar enfermedad                                               |
| **Plásmidos**                                 | PlasmidFinder  | Los plásmidos son los principales vehículos de transferencia horizontal de resistencias |
| **Integrones**                                | IntegronFinder | Capturan y expresan casetes de genes de resistencia                                     |
| **Elementos IS**                              | ISEScan        | Facilitan la movilización y reorganización genómica                                     |

> [!IMPORTANT]
> La presencia de genes de resistencia en un plásmido (en lugar del cromosoma) tiene implicaciones clínicas directas: los plásmidos pueden transferirse horizontalmente a otras bacterias, incluso de especies diferentes.

### Archivos de salida que encontrará en esta práctica

| Archivo            | Formato   | Contenido                                                |
|:-------------------|:----------|:---------------------------------------------------------|
| `*.gff3`           | GFF3      | Coordenadas de todos los elementos anotados              |
| `*.gbk` / `*.gbff` | GenBank   | Anotación + secuencia en formato NCBI                    |
| `*.fna`            | FASTA     | Secuencias nucleotídicas de los genes                    |
| `*.faa`            | FASTA     | Secuencias de aminoácidos de las proteínas               |
| `*.tsv`            | Tabla     | Resumen de anotaciones (coordenadas, función, identidad) |
| `*.txt`            | Texto     | Resumen estadístico del genoma                           |
| `*.svg`            | Imagen    | Mapa circular del genoma anotado                         |

---

## ❓ Preguntas de contexto (antes de empezar)

Responda estas preguntas con base en el [README del Módulo 6](../README.md):

1. ¿Cuál es la diferencia entre anotación estructural y anotación funcional?
2. ¿Qué es un CDS (*Coding Sequence*)? ¿Cómo lo identifica un algoritmo como Prodigal?
3. ¿Por qué los genes de ARNr y ARNt se anotan con métodos diferentes a los CDS?
4. ¿Qué es un gen de copia única conservado (*single-copy core gene*)? ¿Para qué se usa en evaluación de calidad?
5. ¿Cuál es la diferencia entre un gen de resistencia en el cromosoma y uno en un plásmido? ¿Por qué importa clínicamente?
6. ¿Qué es un integrón y por qué su detección es relevante en microbiología clínica?
7. Para el caso asignado: consultando la guía del Módulo 5, ¿qué elementos esperaría encontrar (resistencias, plásmidos, BGC) dado su contexto clínico/biotecnológico/ambiental?
8. **Si su caso tiene antiSMASH recomendado (✅ en la tabla):** ¿qué es un clúster de genes biosintéticos (BGC)? ¿Qué géneros bacterianos son conocidos por ser prolíficos productores de metabolitos secundarios?
9. Todos los genomas de esta práctica son ensamblajes *finished* (completos) de NCBI. ¿Qué ventaja tiene esto frente a anotar un borrador (*draft*) con muchos contigs pequeños?

---

## 📚 Bibliografía

Schwengers, O., et al., 2021. Bakta: rapid and standardized annotation of bacterial genomes via alignment-free sequence identification. *Microbial Genomics* 7:000685. [10.1099/mgen.0.000685](https://doi.org/10.1099/mgen.0.000685)

Seemann, T., 2014. Prokka: rapid prokaryotic genome annotation. *Bioinformatics* 30:2068–2069. [10.1093/bioinformatics/btu153](https://doi.org/10.1093/bioinformatics/btu153)

Feldgarden, M., et al., 2019. Using the NCBI AMRFinder tool and resistance gene database to screen the NCBI pathogen isolates browser. [10.1128/AAC.00483-19](https://doi.org/10.1128/AAC.00483-19)

Carattoli, A., & Hasman, H., 2020. PlasmidFinder and *in silico* pMLST. *Horizontal Gene Transfer: Methods and Protocols* 285–294. [10.1007/978-1-4939-9877-7_20](https://doi.org/10.1007/978-1-4939-9877-7_20)

Néron, B., et al., 2022. IntegronFinder 2.0: identification and analysis of integrons across bacteria, with a focus on antibiotic resistance in *Klebsiella*. *Microorganisms* 10:700. [10.3390/microorganisms10040700](https://doi.org/10.3390/microorganisms10040700)

Xie, Z., & Tang, H., 2017. ISEScan: automated identification of insertion sequence elements in prokaryotic genomes. *Bioinformatics* 33:3340–3347. [10.1093/bioinformatics/btx433](https://doi.org/10.1093/bioinformatics/btx433)

Blin, K., et al., 2023. antiSMASH 7.0: new and improved predictions for detection, regulation and visualisation. *Nucleic Acids Research* 51:W46–W50. [10.1093/nar/gkad344](https://doi.org/10.1093/nar/gkad344)

> [!NOTE]
> Para las referencias bibliográficas específicas de cada organismo (artículo de origen de la cepa, contexto clínico/ambiental), consulte la bibliografía de la [guía del Módulo 5](../05_sequencing/exercises/00_genome_assembly_common.md).

