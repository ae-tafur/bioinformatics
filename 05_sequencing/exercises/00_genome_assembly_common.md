# 🧬 Ensamblaje de Genomas: Guía de Prácticas — Introducción y Casos de Estudio

> [!NOTE]
> Este documento es el **punto de entrada compartido** para todas las prácticas de ensamblaje del Módulo 5. Contiene el contexto biológico, la plataforma de trabajo y los datos de cada caso. Las guías de procedimiento específicas están en los siguientes archivos:
>
> | Práctica                                                                            | Plataforma   | Herramientas                                                                                          |
> |:------------------------------------------------------------------------------------|:-------------|:------------------------------------------------------------------------------------------------------|
> | [Práctica A — Falco + Fastp + Shovill](01_1_genome_assembly_falco_fastp_shovill.md) | Galaxy       | Falco, Fastp, Shovill, QUAST (solo bloque Illumina)                                                   |
> | [Práctica B — FastQC + Trimmomatic + Velvet](01_2_genome_assembly_fastqc_velvet.md) | Galaxy       | FastQC, MultiQC, Trimmomatic, Velvet, QUAST (solo Illumina)                                           |
> | [Práctica C — Python + conda en Google Colab](01_3_genome_assembly_colab.ipynb)     | Google Colab | **Bloque Illumina:** fastp + SPAdes · **Bloque Nanopore:** NanoPlot + Filtlong + Flye · QUAST (común) |

## 🧫 Casos de estudio

Esta práctica se organiza por **casos numerados (01 a 20)**. El profesor asignará uno o más números de caso (a cada estudiante o grupo). Cada caso - **20 casos, el mismo numerado 01–20 del [Módulo 4 — Filogenética](../../04-phylogenetics/exercises/01_phylogenetics.md)** - tiene datos reales de **dos tecnologías de secuenciación distintas del mismo organismo** (Illumina paired-end y Oxford Nanopore long-read), para que se ensamble el mismo genoma con dos flujos de trabajo diferentes y se comparen los resultados. Cada microorganismo tiene su propio contexto biológico y ambiente de origen.

### Tabla de casos y contexto biológico

| Caso   | Ambiente / origen                  | Pistas fenotípicas (sin revelar la especie)                             |
|:------:|:-----------------------------------|:------------------------------------------------------------------------|
|   01   | Clínico (hemocultivo)              | Gram negativa, bacilo, fermentadora de lactosa, encapsulada             |
|   02   | Clínico (hemocultivo)              | Gram negativa, bacilo, fermentadora de lactosa                          |
|   03   | Ambiental (corteza de árbol)       | Gram negativa, bacilo, no fermentadora, oxidasa positiva                |
|   04   | Suelo agrícola                     | Gram positiva (alto %GC), filamentosa, olor terroso                     |
|   05   | Suelo agrícola (segundo aislado)   | Gram positiva (alto %GC), filamentosa, olor terroso                     |
|   06   | Suelo                              | Gram positiva, bacilo, formadora de endosporas, aerobia                 |
|   07   | Clínico / piel                     | Gram positiva, cocos en racimos, catalasa positiva                      |
|   08   | Marino / clínico                   | Gram negativa, bacilo curvo, oxidasa positiva, halofílica               |
|   09   | Clínico (pulmonar)                 | Ácido-alcohol resistente, bacilo, crecimiento muy lento                 |
|   10   | Rizosfera / suelo                  | Gram negativa, bacilo, induce tumores en plantas                        |
|   11   | Extremófilo                        | Gram positiva (pared atípica), cocos, resistente a radiación/desecación |
|   12   | Extremófilo (fuente termal)        | Gram negativa, bacilo, termófilo extremo                                |
|   13   | Intestinal / alimentos fermentados | Gram positiva, bacilo, productora de ácido láctico                      |
|   14   | Clínico (mucosa gástrica)          | Gram negativa, bacilo helicoidal, microaerófila                         |
|   15   | Clínico / alimentos                | Gram negativa, bacilo, no fermentadora de lactosa                       |
|   16   | Suelo                              | Gram positiva, bacilo, formadora de endosporas, productora de enzimas   |
|   17   | Suelo                              | Gram negativa, bacilo/cocoide, fijadora de nitrógeno de vida libre      |
|   18   | Acuático                           | Cianobacteria, fotosintética, unicelular                                |
|   19   | Intestinal / clínico               | Gram positiva, cocos en cadenas cortas                                  |
|   20   | Marino / sedimento                 | Gram negativa, bacilo, reductora de metales                             |

> [!NOTE]
> **Casos pareados:** los casos **04 y 05** provienen del mismo ambiente (suelo agrícola) y podrían pertenecer al mismo género. Si el profesor le asigna ambos, parte del análisis será determinar si son la misma especie o especies diferentes dentro del mismo género (igual que los antiguos "Caso C1/C2").

> [!IMPORTANT]
> El profesor asignará un **número de caso (01–20)**. Las Prácticas A y B (Galaxy) solo cubren el **bloque Illumina**. La Práctica C (Colab) permite trabajar **ambos bloques** (Illumina y/o Nanopore) cambiando la variable `TECH`.

---

## Introducción

El **ensamblaje de genomas** es el proceso mediante el cual se reconstruye la secuencia completa de un genoma a partir de millones de fragmentos cortos de ADN generados por secuenciadores modernos. Es, en esencia, como intentar reconstruir el texto de un libro del que solo se tienen tiras de papel con fragmentos de líneas desordenadas.

En estas prácticas trabajará con datos reales de secuenciación de **dos tecnologías distintas** del mismo organismo bacteriano:

- **Illumina** (lecturas cortas paired-end, ~150 pb, alta precisión, baja tasa de error) → ensamblado con **fastp + SPAdes** (Colab) o **Shovill/Velvet** (Galaxy).
- **Oxford Nanopore** (lecturas largas, miles a decenas de miles de pb, mayor tasa de error por base) → ensamblado con **NanoPlot + Filtlong + Flye** (solo disponible en la Práctica C / Colab).

Ambos flujos terminan en una **evaluación comparando contra un genoma de referencia** con QUAST. Esto significa que:

- El ensamblaje se construye **sin usar la referencia como guía** — el ensamblador une las lecturas por solapamiento, sin saber cómo es el genoma final.
- La referencia se usa **solo al final**, en QUAST, para medir qué tan bien quedó el ensamblaje: qué porcentaje del genoma se cubrió, cuántos errores tiene, etc.

> [!TIP]
> Para repasar los conceptos de ensamblaje de novo vs. guiado por referencia, cobertura, calidad Phred, N50/L50 y las métricas de evaluación, lea las secciones **3**, **4**, **5** y **6** del [README del Módulo 5](../README.md) antes de comenzar. Estos conceptos **no se repiten aquí** — este documento se enfoca en el flujo de trabajo práctico.

---

## 🔬 Flujo de trabajo general

Ambos bloques (Illumina y Nanopore) siguen la misma lógica general, pero con herramientas distintas en los pasos de QC y ensamblaje — esto es intencional: el objetivo es que aprenda que **el mismo problema se puede resolver con herramientas diferentes**, y que compare los resultados.

```
Lecturas crudas (FASTQ)
        │
        ├──────────────────────────┬────────────────────────────┐
        │   BLOQUE ILLUMINA        │   BLOQUE NANOPORE          │
        ▼                          ▼                            │
[ 1. QC ]  Falco/FastQC/fastp   [ 1. QC ]  NanoPlot             │
        │                          │                            │
        ▼                          ▼                            │
[ 2. Limpieza ] Fastp/Trimmomatic [ 2. Filtrado ] Filtlong      │
        │                          │                            │
        ▼                          ▼                            │
[ 3. Ensamblaje ] SPAdes/Shovill/Velvet  [ 3. Ensamblaje ] Flye │
        │                          │                            │
        └──────────────┬───────────┘                            │
                       ▼                                        │
         [ 4. Evaluación del ensamblaje ] ← QUAST (común, contra la misma referencia)
```

> [!NOTE]
> En el **paso 4**, QUAST usa el genoma de referencia para medir la calidad del ensamblaje, pero la referencia **no se usó** para construirlo (en ninguno de los dos bloques). Esto permite evaluar de forma objetiva qué tan bien cada ensamblador reconstruyó el genoma partiendo solo de las lecturas, y comparar directamente Illumina vs Nanopore para el mismo organismo.

---

## 🖥️ Plataformas de trabajo

Estas prácticas se pueden realizar en dos plataformas. El profesor indicará cuál usar, o puede elegir según disponibilidad.

### Opción 1: Galaxy Europe (Prácticas A y B)

Galaxy es una plataforma web que permite ejecutar herramientas bioinformáticas sin instalar nada ni escribir código.

🔗 **<https://usegalaxy.eu>**

> [!IMPORTANT]
> Use **<https://usegalaxy.eu>** (servidor europeo). El servidor <https://usegalaxy.org> puede presentar inconvenientes con algunas herramientas durante la práctica.

**Primeros pasos en Galaxy:**
1. Si no tiene cuenta, regístrese en <https://usegalaxy.eu>.
2. Si ya tiene cuenta de una práctica anterior, puede reutilizarla.
3. Para cada práctica nueva, cree un **historial nuevo**:
   - Haga clic en `+` en la esquina superior derecha del panel de historiales.
   - Haga clic en el ✏️ para darle un nombre descriptivo (ej. `Ensamblaje_CasoA_Shovill`).

**Códigos de color en Galaxy:**

| Color             | Estado                              |
|:------------------|:------------------------------------|
| 🟡 Gris / en cola | Esperando para ejecutarse           |
| 🟠 Naranja        | Ejecutándose                        |
| 🟢 Verde          | Listo ✅                             |
| 🔴 Rojo           | Falló — haga clic para ver el error |

> [!TIP]
> Si un paso falla en rojo, haga clic en el ícono de error (ⓘ) para ver el mensaje. Los errores más comunes son: archivo de entrada incorrecto, parámetro equivocado, o que el archivo aún no terminó de cargar.

### Opción 2: Google Colab con conda (Práctica C)

Google Colab es un entorno de notebooks de Python que corre en la nube de Google. En la **Práctica C** se usa junto con `conda` para instalar herramientas de línea de comandos directamente en el entorno del notebook, sin necesidad de instalar nada localmente. El notebook define dos variables al inicio — `CASO` (01–20) y `TECH` (`"illumina"` o `"nanopore"`) — que determinan automáticamente qué datos descargar y qué pipeline ejecutar:

- `TECH = "illumina"` → `sra-tools` (descarga) + `fastp` (QC/limpieza) + `SPAdes` (ensamblaje) + `QUAST` (evaluación).
- `TECH = "nanopore"` → `sra-tools` (descarga) + `NanoPlot` (QC) + `Filtlong` (filtrado) + `Flye` (ensamblaje) + `QUAST` (evaluación).

🔗 **<https://colab.research.google.com>**

**Ventajas de Colab para esta práctica:**
- Acceso a una terminal de Linux con GPU/CPU gratuita.
- Instalación de herramientas bioinformáticas con `conda` en una sola celda.
- Integración con Python para analizar y graficar resultados directamente en el notebook.
- Posibilidad de guardar el trabajo en Google Drive.

**Primeros pasos en Google Colab:**
1. Ingrese a <https://colab.research.google.com> con su cuenta de Google.
2. Abra el notebook [`01_3_genome_assembly_colab.ipynb`](01_3_genome_assembly_colab.ipynb) desde Google Drive o cárguelo desde GitHub.
3. Haga clic en `Entorno de ejecución` → `Cambiar tipo de entorno de ejecución` y seleccione **T4 GPU** o **CPU estándar**.
4. Ejecute las celdas en orden. La primera celda instala `conda` y los paquetes necesarios — puede tardar 5–10 minutos.

> [!WARNING]
> Las sesiones de Google Colab **se desconectan después de 90 minutos de inactividad**. Si esto ocurre, deberá volver a ejecutar las celdas de instalación. Guarde los archivos de resultados en Google Drive para no perderlos.

---

## 🧫 Datos de acceso para caso de estudio

Como se mencionó anteriormente, esta práctica se organiza por **20 casos**, los mismos numerados 01–20 del [Módulo 4 — Filogenética](../../04-phylogenetics/exercises/01_phylogenetics.md). El profesor indicará cuál caso trabajar (**mismo número que en filogenética**, para que compare la identidad real del organismo que dedujo con el árbol filogenético con los resultados de su propio ensamblaje).

> [!IMPORTANT]
> Cargue **solo los archivos del caso y bloque (Illumina o Nanopore) asignados** para no consumir espacio ni tiempo de cómputo innecesario. Varios casos tienen datasets **pesados** (marcados en la tabla) — en esos, se recomienda **subsamplear** antes de ensamblar (ver sección siguiente).

### 📋 Tabla maestra de datos de acceso a los reads de los casos

| Caso  | Organismo (se revela al hacer el árbol en Módulo 4)    | Tamaño genoma aprox.   | Accesión Illumina (SRA)    | Accesión Nanopore (SRA)    | Genoma de referencia (QUAST)                  | Notas                                                 |
|:-----:|:-------------------------------------------------------|:-----------------------|:---------------------------|:---------------------------|:----------------------------------------------|:------------------------------------------------------|
|  01   | *Klebsiella pneumoniae*                                | ~5.5 Mb                | `ERR14828471`              | `SRR40944313`              | GCF_061393185.1                               | —                                                     |
|  02   | *Escherichia coli*                                     | ~5.0 Mb                | `SRR40503160`              | `SRR24837712`              | Illu: GCA_060784565.1 · Nano: GCF_030285565.1 | Cepas **distintas** en cada bloque (ver nota abajo)   |
|  03   | *Pseudomonas abieticivorans*                           | ~6.7 Mb                | `SRR24684300`              | `SRR24684301`              | GCF_023509015.1                               | Mismo aislado en ambas tecnologías                    |
|  04   | *Streptomyces venezuelae*                              | ~8.2 Mb                | `SRR11960410`              | `SRR33220699`              | GCA_050632295.1                               | ⚠️ Nanopore pesado (~1.1 Gb) — subsamplear            |
|  05   | *Streptomyces coelicolor*                              | ~8.7 Mb                | `SRR39165540`              | `SRR24425373`              | GCF_047824265.1                               | —                                                     |
|  06   | *Bacillus subtilis*                                    | ~4.2 Mb                | `ERR15846824`              | `SRR40784809`              | GCF_982518465.1                               | —                                                     |
|  07   | *Staphylococcus aureus* (MRSA)                         | ~2.8 Mb                | `DRR187559`                | `SRR40597729`              | GCF_982303505.1                               | —                                                     |
|  08   | *Vibrio cholerae*                                      | ~4.0 Mb                | `SRR40968872`              | `ERR17674410`              | GCF_055797365.1                               | —                                                     |
|  09   | *Mycobacterium tuberculosis*                           | ~4.4 Mb                | `ERR17981994`              | `SRR40948678`              | GCF_061392705.1                               | ⚠️ Illumina y Nanopore pesados — subsamplear ambos    |
|  10   | *Agrobacterium tumefaciens*                            | ~5.6 Mb                | `DRR1119936`               | `SRR31799201`              | GCA_047731285.1                               | ⚠️ Illumina pesado (~939 Mb) — subsamplear            |
|  11   | *Deinococcus radiodurans*                              | ~3.3 Mb                | `SRR37705175`              | `ERR7055001`               | GCF_045277105.1                               | ⚠️ Nanopore pesado (~711 Mb, única opción disponible) |
|  12   | *Thermus thermophilus*                                 | ~2.1 Mb                | `SRR35352552`              | `ERR14102352`              | GCF_059705435.1                               | —                                                     |
|  13   | *Lactobacillus acidophilus*                            | ~2.0 Mb                | `SRR38995089`              | `SRR34642242`              | GCF_988235355.1                               | ⚠️ Illumina pesado (~1.1 Gb) — subsamplear            |
|  14   | *Helicobacter pylori*                                  | ~1.6 Mb                | `SRR40271341`              | `SRR40805640`              | GCA_059997335.1                               | —                                                     |
|  15   | *Salmonella enterica*                                  | ~4.8 Mb                | `SRR40979775`              | `SRR40942572`              | GCF_061253545.1                               | —                                                     |
|  16   | *Bacillus licheniformis*                               | ~4.3 Mb                | `SRR40374058`              | `DRR1081654`               | GCA_055397075.1                               | —                                                     |
|  17   | *Paenibacillus polymyxa*                               | ~5.8 Mb                | `SRR38851454`              | `SRR27678679`              | GCF_056645015.1                               | —                                                     |
|  18   | *Synechocystis* sp.                                    | ~3.6 Mb                | `ERR13636519`              | `ERR17229400`              | GCA_987480225.1                               | ⚠️ Nanopore pesado (~488 Mb) — subsamplear            |
|  19   | *Enterococcus faecalis*                                | ~3.0 Mb                | `SRR40894698`              | `SRR40784437`              | GCA_061255735.1                               | —                                                     |
|  20   | *Shewanella oneidensis*                                | ~4.9 Mb                | `SRR40344192`              | `SRR33906229`              | GCF_000146165.2                               | ⚠️ Illumina pesado (~623 Mb) — subsamplear            |

> [!NOTE]
> **Caso 02 (E. coli):** el bloque **Nanopore** usa la cepa **C51** (`SRR24837712`, aislada de heces bovinas, Rusia 2020 — la más reciente con datos MinION publicados para esta cepa). El bloque **Illumina** usa una cepa **distinta**, **ST131** (`SRR40503160`, bacteriemia humana, EE. UU. 2023), un clon pandémico multirresistente con alto número de genes de resistencia (ESBL + fluoroquinolonas) — ideal para practicar anotación de resistoma más adelante. No existen datos Illumina de la cepa C51 exacta, por lo que no se fuerza una coincidencia artificial; cada bloque usa la mejor cepa disponible para su propósito pedagógico. Use el genoma de referencia correspondiente a cada bloque (no son intercambiables).

### 🏋️ Datasets pesados — recomendación de subsampleo

Para los casos marcados con ⚠️ en la tabla, se recomienda **subsamplear antes de ensamblar**, para no saturar los recursos de cómputo (RAM/tiempo) del aula o de Colab:

- **Illumina (lecturas cortas):** `seqtk sample -s100 reads_1.fastq.gz 0.3 > sub_1.fastq.gz` (ajuste la fracción `0.3` según el tamaño original vs. la cobertura deseada, ~60-80×).
- **Nanopore (lecturas largas):** `filtlong --target_bases <genoma_esperado_bp × 80> reads.fastq.gz > sub.fastq.gz` (esto ya se incluye como paso estándar del bloque Nanopore en la Práctica C, no solo para los pesados).

### 📥 Cómo descargar los datos de su caso

En lugar de URLs manuales por caso (que cambian de disponibilidad con el tiempo), use las **herramientas de descarga por accesión SRA**, que funcionan igual para los 20 casos y ambos bloques:

<details>
<summary>📥 En Galaxy (haga clic para expandir)</summary>

1. Vaya a **Herramientas** → busque `Faster Download and Extract Reads in FASTQ`.
2. En el campo de accesión, pegue el accession de su caso/bloque (columna "Accesión Illumina" o "Accesión Nanopore" de la tabla).
3. Ejecute. Esto genera automáticamente los archivos FASTQ (R1/R2 para Illumina, un único archivo para Nanopore).
4. Para el genoma de referencia, use **Upload** → **Paste/Fetch data** y pegue la URL de la columna "Genoma de referencia" con el patrón:
   ```
   https://ftp.ncbi.nlm.nih.gov/genomes/all/<GCF_o_GCA>/<3-dig>/<3-dig>/<3-dig>/<accesion>_<nombre_ensamblaje>/<accesion>_<nombre_ensamblaje>_genomic.fna.gz
   ```
   (el notebook de Colab ya trae estas URLs completas y verificadas — cópielas de ahí si prefiere no construirlas a mano).

</details>

<details>
<summary>💻 En terminal o Colab, con sra-tools (haga clic para expandir)</summary>

```bash
# Instalar sra-tools si no está disponible (ya incluido en el entorno conda de la Práctica C)
# conda install -y -c bioconda sra-tools

CASO="05"        # <-- cambie al número de su caso (01-20)
TECH="illumina"  # <-- "illumina" o "nanopore"
ACC="SRR39165540"  # <-- copie el accession correspondiente de la tabla

mkdir -p "GenomeAssembly/caso_${CASO}/data" && cd "GenomeAssembly/caso_${CASO}"

prefetch "$ACC" -O data/
fasterq-dump "data/${ACC}/${ACC}.sra" -O data/ --split-files
gzip "data/${ACC}"*.fastq

# Genoma de referencia (reemplace por la URL de la tabla)
wget "<URL_referencia_de_la_tabla>" -O data/ref.fna.gz
gunzip data/ref.fna.gz
```

`fasterq-dump --split-files` genera `${ACC}_1.fastq` y `${ACC}_2.fastq` si es Illumina paired-end, o un único `${ACC}.fastq` si es Nanopore (single-end long reads).

</details>


## ❓ Preguntas de contexto (antes de empezar)

Responda estas preguntas con base en el [README del Módulo 5](../README.md) antes de iniciar el procedimiento:

1. ¿Cuál es la diferencia entre una lectura (*read*) y un contig?
2. ¿Qué representa la cobertura y por qué es importante para el ensamblaje?
3. ¿Por qué las lecturas paired-end ayudan a resolver regiones repetitivas? ¿Las lecturas largas de Nanopore tienen la misma ventaja, aunque no sean paired-end? ¿Por qué?
4. ¿Qué pasaría si ensambla con cobertura muy baja (<10×)?
5. Para el caso asignado: ¿cuántas lecturas se necesitarían para alcanzar una cobertura de 30× en el bloque Illumina (150 pb/lectura) y en el bloque Nanopore (longitud promedio variable, consulte `NanoPlot`)? Muestre el cálculo para ambos.
6. Si su organismo tiene un %GC muy alto o muy bajo (ej. *Streptomyces*, *Mycobacterium*), ¿por qué el gráfico de "Per Sequence GC Content" se desplaza sin que eso indique contaminación?
7. ¿Qué diferencia hay entre usar la referencia *durante* el ensamblaje y usarla *solo para evaluar* el resultado?
8. Compare las métricas de QUAST (N50, # contigs, Genome fraction, mismatches/100kbp) entre su ensamblaje Illumina y su ensamblaje Nanopore del **mismo caso**. ¿Cuál tiene menos contigs? ¿Cuál tiene más mismatches/indels? ¿Por qué ocurre esta diferencia dado lo que sabe sobre la tasa de error de cada tecnología?

---

## 📚 Bibliografía

Prjibelski, A., et al., 2020. *Current Protocols in Bioinformatics* 70:e102 (SPAdes). [10.1002/cpbi.102](https://doi.org/10.1002/cpbi.102)

Zerbino, D.R. & Birney, E., 2008. *Genome Research* 18:821–829 (Velvet).

Chen, S., et al., 2018. *Bioinformatics* 34:i884–i890 (fastp). [10.1093/bioinformatics/bty560](https://doi.org/10.1093/bioinformatics/bty560)

Gurevich, A., et al., 2013. *Bioinformatics* 29:1072–1075 (QUAST). [10.1093/bioinformatics/btt086](https://doi.org/10.1093/bioinformatics/btt086)

Kolmogorov, M., et al., 2019. *Nature Biotechnology* 37:540–546 (Flye). [10.1038/s41587-019-0072-8](https://doi.org/10.1038/s41587-019-0072-8)

De Coster, W. & Rademakers, R., 2023. *Bioinformatics* 39:btad311 (NanoPlot). [10.1093/bioinformatics/btad311](https://doi.org/10.1093/bioinformatics/btad311)

> [!NOTE]
> Las referencias biológicas específicas de cada organismo (contexto clínico/ambiental) se encuentran en el [Módulo 4 — Filogenética](../../04-phylogenetics/exercises/01_phylogenetics.md), donde se discute la identidad real de cada caso tras construir el árbol filogenético.
