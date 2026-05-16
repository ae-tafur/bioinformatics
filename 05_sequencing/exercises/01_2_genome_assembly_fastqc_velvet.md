# 🧬 Práctica B: Ensamblaje de Genomas con FastQC + Trimmomatic + Velvet

> [!NOTE]
> Esta es la **Práctica B** del módulo de ensamblaje. Antes de continuar:
> 1. Lea el [README del Módulo 5](../README.md) §§ 3–6 para los conceptos de calidad, cobertura, ensamblaje y métricas de evaluación.
> 2. Lea la [guía de prácticas compartida](00_genome_assembly_common.md) para el flujo de trabajo, las plataformas y los datos de su caso.

---

## 🎯 Objetivos

- Evaluar la calidad de las lecturas crudas con **FastQC** y **MultiQC**.
- Limpiar y recortar lecturas usando **Trimmomatic**.
- Comparar la calidad antes y después de la limpieza.
- Ensamblar un genoma bacteriano de novo con **Velvet**.
- Explorar el efecto del tamaño de k-mer en la calidad del ensamblaje.
- Calcular y evaluar métricas de calidad del ensamblaje con **QUAST**.

---

## 📦 Requisitos previos

- Haber leído el [README del Módulo 5](../README.md), especialmente las secciones de calidad de lecturas, cobertura, paired-end y ensamblaje.
- Haber leído la [introducción general a las prácticas de ensamblaje](00_genome_assembly_common.md).
- Tener cuenta activa en [Galaxy Europe](https://usegalaxy.eu).

---

## 🖥️ Herramientas utilizadas

| Herramienta          | Versión Galaxy   | Función                                  |
|:---------------------|:-----------------|:-----------------------------------------|
| **FastQC**           | 0.73+galaxy0     | Evaluación de calidad de lecturas        |
| **MultiQC**          | 1.11+galaxy1     | Consolidación de reportes FastQC         |
| **Trimmomatic**      | 0.39+galaxy2     | Limpieza y recorte de lecturas           |
| **FASTQ interlacer** | 1.2.0.1+galaxy0  | Entrelazado de lecturas paired-end       |
| **velveth**          | 1.2.10.3         | Construcción del grafo de De Bruijn      |
| **velvetg**          | 1.2.10.2         | Ensamblaje a partir del grafo            |
| **QUAST**            | 5.2.0+galaxy1    | Estadísticas y evaluación del ensamblaje |

---

## 🧫 Caso asignado

Consulte el documento de [casos de estudio](00_genome_assembly_common.md#-casos-de-estudio) y cargue los datos del caso que le indique el profesor (**A**, **B**, **C**, o **D**).

> [!IMPORTANT]
> Cargue **solo los archivos del caso asignado**. Si ya tiene un historial de una práctica anterior en Galaxy, cree uno nuevo para esta práctica haciendo clic en `+` (esquina superior derecha).

---

## 🔬 Procedimiento

### Paso 1 — Crear un nuevo historial y cargar los datos

1. En Galaxy, haga clic en `+` en la esquina superior derecha para crear un nuevo historial.
2. Renómbrelo, por ejemplo: `Ensamblaje_CasoA_Velvet`.
3. Cargue los datos de su caso usando la sección correspondiente del [documento de casos](00_genome_assembly_common.md#-casos-de-estudio) (haga clic en el bloque desplegable del caso asignado).
4. Haga clic en `Upload` → `Paste/Fetch data`, pegue los enlaces y haga clic en `Start`.
5. Espere a que todos los archivos estén en **verde** ✅ antes de continuar.

> [!TIP]
> **Naranja** = en proceso. **Rojo** = falló (repita la carga). **Verde** = listo.

#### Inspección inicial

Haga clic en el ícono del ojo 👁 para revisar uno de los archivos `.fastq.gz`.

**Preguntas:**

a. ¿Cuáles son las cuatro líneas que forman cada entrada en un archivo FASTQ?

b. ¿Cuál es la principal diferencia entre un archivo FASTQ y un archivo FASTA?

c. ¿Cómo interpreta la cadena de caracteres en la cuarta línea de cada lectura?

---

### Paso 2 — Evaluar la calidad con FastQC y MultiQC

1. En Galaxy, busque **FastQC** y configure:
   - `Raw read data from your current history`: seleccione **ambos** archivos FASTQ (`*_1` y `*_2`).
2. Haga clic en `Run Tool`.

3. Luego busque **MultiQC** y configure:
   - `Results: Which tool was used to generate logs?`: `FastQC`
   - Haga clic en `Insert FastQC output`
     - `Type of FastQC output?`: seleccione los archivos de resultados crudos de FastQC (múltiples datasets)
4. Haga clic en `Run Tool`.

#### Interpretación del reporte MultiQC

MultiQC combina los reportes de ambos archivos FASTQ en una sola página web interactiva.

> [!NOTE]
> Antes de continuar, asegúrese de haber leído las secciones **3.2 Calidad Phred**, **3.3 Perfil de calidad** y **3.5 Trimming** del [README del Módulo 5](../README.md). Allí encontrará la explicación de los Q-scores, la tabla de interpretación de situaciones frecuentes y las preguntas de comprensión asociadas.

**Estadísticas generales (General Statistics):**

Para ver la longitud de las lecturas:
- Abra la tabla `General Statistics`.
- Haga clic en `Configure Columns` y active la columna `Length`.

Al revisar el reporte, evalúe estas secciones clave:

| Sección del reporte             | Qué evalúa                                                                                                             |
|:--------------------------------|:-----------------------------------------------------------------------------------------------------------------------|
| **Per Base Sequence Quality**   | Calidad (Phred) en cada posición — use la [tabla de casos frecuentes](../README.md#35-trimming-y-filtrado-de-lecturas) |
| **Per Sequence Quality Scores** | Distribución general de calidad por lectura                                                                            |
| **Per Base N Content**          | Bases indeterminadas (N) por posición                                                                                  |
| **Overrepresented Sequences**   | Posibles adaptadores u otros contaminantes                                                                             |
| **Per Sequence GC Content**     | Distribución del %GC — dos picos sugieren contaminación                                                                |

**Preguntas:**

1. ¿Qué longitud tienen las lecturas?
2. ¿Cuál es la cobertura estimada? Use la fórmula del [README § 3.4](../README.md#34-cobertura-y-profundidad) y el tamaño del genoma en el [documento de casos](00_genome_assembly_common.md#-casos-de-estudio).
3. ¿En qué posiciones decae la calidad por debajo de Q28? ¿Es el patrón esperado para Illumina?
4. ¿Qué representa el eje Y en el gráfico de calidad por posición?
5. Con base en la [tabla de situaciones frecuentes](../README.md#35-trimming-y-filtrado-de-lecturas), ¿qué problemas identifica y qué acciones tomará?

---

### Paso 3 — Limpiar las lecturas con Trimmomatic

Trimmomatic recorta lecturas de baja calidad y elimina adaptadores con varios algoritmos:

- **LEADING / TRAILING:** recorta bases desde el inicio o el final de la lectura si tienen calidad menor al umbral.
- **SLIDINGWINDOW:** recorre la lectura en ventanas de 4 bases; si la calidad media de la ventana cae por debajo del umbral, recorta desde ese punto.
- **MINLEN:** descarta lecturas más cortas que la longitud mínima especificada.

1. En Galaxy, busque **Trimmomatic** y configure:
   - `Single-end or paired reads`: `Paired-end (two separate input files)`
   - `Input FASTQ file (R1/first of pair)`: `*_1.fastq.gz`
   - `Input FASTQ file (R2/second of pair)`: `*_2.fastq.gz`
   - En `Trimmomatic Operation`:
     - Agregue operación: `SLIDINGWINDOW` → Window: `4`, Quality: `20`
     - Agregue operación: `MINLEN` → Length: `30`
   - Deje los demás parámetros por defecto.
2. Haga clic en `Run Tool`.

> [!NOTE]
> Trimmomatic genera **cuatro archivos** de salida para datos paired-end:
> - **R1-paired / R2-paired:** lecturas donde **ambas** superaron el filtro. ✅ Úselas para el ensamblaje.
> - **R1-unpaired / R2-unpaired:** lecturas donde solo una del par superó el filtro. Se pueden usar en ensambladores que lo soporten.

---

### Paso 4 — Re-evaluar la calidad con FastQC + MultiQC (post-limpieza)

Repita los pasos 2 usando los archivos **paired** de Trimmomatic para verificar que la limpieza mejoró la calidad.

**Preguntas:**

1. ¿Mejoró la calidad media por posición respecto al análisis inicial?
2. ¿Cambió la longitud media de las lecturas?
3. ¿La cobertura estimada sigue siendo suficiente para el ensamblaje?
4. ¿El trimming afectó el contenido de GC?

---

### Paso 5 — Preparar las lecturas para Velvet: FASTQ Interlacer

Velvet requiere un único archivo FASTQ donde cada lectura esté junto a su pareja. Las lecturas 0 y 1 son pares, 2 y 3 son pares, etc. Debemos entrelazar los archivos R1 y R2.

1. En Galaxy, busque **FASTQ interlacer** y configure:
   - `Type of paired-end datasets`: `2 separate datasets`
   - `Left-hand mates`: archivo R1-paired de Trimmomatic
   - `Right-hand mates`: archivo R2-paired de Trimmomatic
2. Haga clic en `Run Tool`.

---

### Paso 6 — Construir el grafo de De Bruijn con velveth

velveth toma las lecturas entrelazadas y construye el grafo de k-mers que Velvet usará para el ensamblaje.

> [!NOTE]
> El parámetro **k** (Hash Length) define el tamaño de los k-mers. Es el parámetro más importante en Velvet y debe ser menor a la longitud de las lecturas. Para lecturas de 150 pb, valores entre 29 y 101 son razonables.
>
> - **k pequeño** → mayor conectividad, pero más ambigüedad en regiones repetitivas.
> - **k grande** → mayor especificidad, pero necesita mayor cobertura.

1. En Galaxy, busque **velveth** y configure:
   - `Hash Length`: `29`
   - En `Input Files`, haga clic en `+ Input Files`:
     - `Choose the input type`: `interleaved paired end`
     - `read type`: `shortPaired reads`
     - `Dataset`: salida del FASTQ interlacer
2. Haga clic en `Run Tool`.

---

### Paso 7 — Ensamblar con velvetg

velvetg toma el grafo construido por velveth y genera los contigs finales.

1. En Galaxy, busque **velvetg** y configure:
   - `Velvet Dataset`: salida de velveth
   - `Using Paired Reads`: `Yes`
2. Haga clic en `Run Tool`.

#### Resultados de Velvet

| Salida         | Descripción                                   |
|:---------------|:----------------------------------------------|
| **contigs.fa** | FASTA con los contigs ensamblados.            |
| **stats.txt**  | Tabla con longitudes y coberturas por contig. |
| **Log**        | Registro del proceso.                         |

En el encabezado de cada contig verá:
- `length` = longitud en k-mers
- `coverage` = cobertura media de k-mers en ese contig

---

### Paso 8 — Evaluar el ensamblaje con QUAST

1. En Galaxy, busque **QUAST** y configure:
   - `Assembly mode`: `Individual assembly (1 contig file per sample)`
   - `Use customized names?`: `No`
   - `Contigs/scaffolds file`: salida `contigs.fa` de velvetg
   - `Type of assembly`: `Genome`
   - `Use a reference genome?`: `Yes`
   - `Reference genome`: el archivo `.fna` cargado al inicio
   - `Type of organism`: `Prokaryotes`
   - `Lower Threshold`: `500`
   - `Advanced options – Comma-separated list of contig length thresholds`: `0,1000`
2. Haga clic en `Run Tool`.

#### Interpretación del reporte QUAST

| Métrica                    | ¿Qué significa?                                                                    |
|:---------------------------|:-----------------------------------------------------------------------------------|
| `# contigs (≥ 0 bp)`       | Total de contigs ensamblados                                                       |
| `# contigs (≥ 500 bp)`     | Contigs de tamaño significativo                                                    |
| `Total length`             | Tamaño total del ensamblaje                                                        |
| `N50`                      | Ver [definición en README § 6](../README.md#métricas-de-evaluación-del-ensamblaje) |
| `L50`                      | Número mínimo de contigs que suman el N50                                          |
| `Genome fraction (%)`      | % del genoma de referencia cubierto                                                |
| `# mismatches per 100 kbp` | Errores de base respecto a la referencia                                           |
| `# indels per 100 kbp`     | Inserciones/deleciones respecto a la referencia                                    |

---

### Paso 9 — Experimento: efecto del k-mer en el ensamblaje

Una de las ventajas pedagógicas de Velvet es que el usuario controla el k-mer directamente, lo que permite explorar cómo afecta al ensamblaje.

1. Repita los **Pasos 6, 7 y 8** con **al menos dos valores de k diferentes**:
   - Un valor más pequeño (ej. `k = 21`)
   - Un valor más grande (ej. `k = 51` o `k = 71`)

2. Compare las métricas QUAST entre los tres ensamblajes:

| k-mer | # contigs | Total length | N50 | L50 | Genome fraction (%) |
|:------|:---------:|:------------:|:---:|:---:|:-------------------:|
| 21    |           |              |     |     |                     |
| 29    |           |              |     |     |                     |
| 51    |           |              |     |     |                     |

**Preguntas:**

1. ¿Qué k-mer produjo el mejor N50?
2. ¿Qué k-mer produjo la mayor cobertura del genoma de referencia?
3. ¿Qué pasa cuando el k-mer es demasiado pequeño o demasiado grande?
4. ¿Preferiría usar Velvet o Shovill para un ensamblaje de rutina? ¿Por qué?

---

## ❓ Preguntas para reflexionar

### Sobre el control de calidad

1. ¿Cuál fue la cobertura estimada antes y después del trimming con Trimmomatic?
2. ¿Cómo cambió la longitud media de lectura después del filtrado?
3. ¿El trimming mejoró las puntuaciones medias de calidad?
4. ¿Los datos son adecuados para el ensamblaje? ¿Sería necesario volver a secuenciar?

### Sobre el ensamblaje

5. ¿Cuántos contigs se ensamblaron con Velvet (k=29)?
6. ¿Cuál es la longitud media, mínima y máxima de los contigs?
7. ¿Qué proporción del genoma de referencia representan?
8. ¿Cuántos mismatches e indels se encontraron?
9. ¿Se introdujo sesgo en el porcentaje de GC durante el ensamblaje?
10. ¿Cuál es el N50 y L50? ¿Cómo cambian con diferentes valores de k?
11. **Para el Caso C** (*Streptomyces*): ¿Cómo cree que afecta el alto contenido GC (~72%) al ensamblaje con Velvet?

### Comparación entre prácticas (si realizó ambas)

12. ¿Qué diferencias observa entre el ensamblaje de Shovill (Práctica A) y Velvet (Práctica B)?
13. ¿Cuál herramienta es más fácil de usar? ¿Cuál ofrece más control al usuario?

---

## 🏆 Reto adicional (opcional)

1. **Optimización de k:** explore valores de k entre 31 y 101 en pasos de 10. Grafique N50 vs. k-mer y determine el valor óptimo para su caso.
2. **Comparación con Shovill:** si tiene acceso a la Práctica A, compare las métricas QUAST entre ambos ensambladores para el mismo caso. ¿Cuál produce un mejor ensamblaje?
3. **BUSCO:** si Galaxy lo tiene disponible, evalúe la completitud del ensamblaje con la base de datos `bacteria_odb10`.

---

## 📚 Bibliografía

Ver la [bibliografía completa en el documento de introducción general](00_genome_assembly_common.md#-bibliografía).

- Zerbino, D.R. & Birney, E., 2008. Velvet: Algorithms for de novo short read assembly using de Bruijn graphs. *Genome Research* 18:821–829.
- Bolger, A.M., et al., 2014. Trimmomatic: a flexible trimmer for Illumina sequence data. *Bioinformatics* 30:2114–2120.
- Andrews, S. (FastQC): <https://www.bioinformatics.babraham.ac.uk/projects/fastqc/>
- Gurevich, A., et al., 2013. QUAST. *Bioinformatics* 29:1072–1075.
