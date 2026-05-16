# 🧬 Práctica A: Ensamblaje de Genomas con Falco + Fastp + Shovill

> [!NOTE]
> Esta es la **Práctica A** del módulo de ensamblaje. Antes de continuar:
> 1. Lea el [README del Módulo 5](../README.md) §§ 3–6 para los conceptos de calidad, cobertura, ensamblaje y métricas de evaluación.
> 2. Lea la [guía de prácticas compartida](00_genome_assembly_common.md) para el flujo de trabajo, las plataformas y los datos de su caso.

---

## 🎯 Objetivos

- Evaluar la calidad de las lecturas crudas con **Falco**.
- Limpiar y recortar lecturas usando **Fastp**.
- Comparar la calidad antes y después de la limpieza.
- Ensamblar un genoma bacteriano de novo con **Shovill** (basado en SPAdes).
- Calcular y evaluar métricas de calidad del ensamblaje con **QUAST**.

---

## 📦 Requisitos previos

- Haber leído el [README del Módulo 5](../README.md), especialmente las secciones de calidad de lecturas, cobertura, paired-end y ensamblaje.
- Haber leído la [introducción general a las prácticas de ensamblaje](00_genome_assembly_common.md).
- Tener cuenta activa en [Galaxy Europe](https://usegalaxy.eu).

---

## 🖥️ Herramientas utilizadas

| Herramienta   | Versión Galaxy    | Función                                  |
|:--------------|:------------------|:-----------------------------------------|
| **Falco**     | 1.2.4+galaxy0     | Evaluación de calidad de lecturas        |
| **Fastp**     | 0.23.4+galaxy0    | Limpieza y recorte de adaptadores        |
| **Shovill**   | 1.1.0+galaxy1     | Ensamblaje de novo (SPAdes optimizado)   |
| **QUAST**     | 5.2.0+galaxy1     | Estadísticas y evaluación del ensamblaje |

---

## 🧫 Caso asignado

Consulte el documento de [casos de estudio](00_genome_assembly_common.md#-casos-de-estudio) y cargue los datos del caso que le indique el profesor (**A**, **B**, **C** o **D**).

> [!IMPORTANT]
> Cargue **solo los archivos del caso asignado**. Si ya tiene un historial de una práctica anterior en Galaxy, cree uno nuevo para esta práctica haciendo clic en `+` (esquina superior derecha).

---

## 🔬 Procedimiento

### Paso 1 — Crear un nuevo historial y cargar los datos

1. En Galaxy, haga clic en `+` en la esquina superior derecha para crear un nuevo historial.
2. Renómbrelo, por ejemplo: `Ensamblaje_CasoA_Shovill`.
3. Cargue los datos de su caso usando la sección correspondiente del [documento de casos](00_genome_assembly_common.md#-casos-de-estudio) (haga clic en el bloque desplegable del caso asignado).
4. Haga clic en `Upload` → `Paste/Fetch data`, pegue los enlaces y haga clic en `Start`.
5. Espere a que todos los archivos estén en **verde** ✅ antes de continuar.

> [!TIP]
> **Naranja** = en proceso. **Rojo** = falló (repita la carga). **Verde** = listo.

#### Inspección inicial

Una vez cargados los datos, haga clic en el ícono del ojo 👁 para revisar uno de los archivos `.fastq.gz`.

**Preguntas:**

a. ¿Cuáles son las cuatro líneas que forman cada entrada en un archivo FASTQ?

b. ¿Cuál es la principal diferencia entre un archivo FASTQ y un archivo FASTA?

c. ¿Cómo interpreta la cadena de caracteres en la cuarta línea de cada lectura?

---

### Paso 2 — Evaluar la calidad con Falco

Antes de ensamblar, es fundamental conocer el estado de sus datos. Las preguntas clave son:

- ¿Cuál es la cobertura estimada del genoma?
- ¿Qué calidad tienen las lecturas?
- ¿Hay presencia de adaptadores o k-mers sobrerrepresentados?
- ¿Los datos son adecuados para el ensamblaje?

1. En el panel izquierdo de Galaxy, busque **Falco** y haga clic en la herramienta.
2. Configure los parámetros:
   - `Raw read data from your current history`: seleccione **ambos** archivos FASTQ (`*_1` y `*_2`).
     - Para seleccionar múltiples archivos, haga clic en el ícono de "múltiples datasets" (dos archivos superpuestos) a la izquierda del selector.
   - Deje los demás parámetros por defecto.
3. Haga clic en `Run Tool`.

#### Interpretación del reporte Falco

Falco genera un archivo HTML por cada conjunto de lecturas.

> [!NOTE]
> Antes de continuar, asegúrese de haber leído las secciones **3.2 Calidad Phred**, **3.3 Perfil de calidad** y **3.5 Trimming** del [README del Módulo 5](../README.md). Allí encontrará la explicación de los Q-scores, la tabla de interpretación de situaciones frecuentes y las preguntas de comprensión asociadas.

Al abrir el reporte, preste atención a estas secciones:

| Sección del reporte             | Qué evalúa                                                                                                                                            |
|:--------------------------------|:------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Per Base Sequence Quality**   | Calidad (Phred) en cada posición de la lectura — use la [tabla de casos frecuentes](../README.md#35-trimming-y-filtrado-de-lecturas) para interpretar |
| **Per Sequence Quality Scores** | Distribución general de calidad por lectura                                                                                                           |
| **Per Base N Content**          | Porcentaje de bases indeterminadas (N) por posición                                                                                                   |
| **Overrepresented Sequences**   | Detecta adaptadores u otras secuencias contaminantes                                                                                                  |
| **Kmer Content**                | k-mers inusualmente frecuentes (posibles adaptadores)                                                                                                 |
| **Per Sequence GC Content**     | Distribución del %GC — dos picos sugieren contaminación                                                                                               |

**Preguntas:**

1. ¿En qué posiciones cae la calidad por debajo de Q28? ¿Coincide con el patrón esperado para Illumina?
2. ¿Se detectaron secuencias sobrerrepresentadas? ¿A qué corresponden?
3. Calcule la cobertura estimada con la fórmula del [README § 3.4](../README.md#34-cobertura-y-profundidad). ¿Es suficiente para el ensamblaje?
4. Con base en la [tabla de casos frecuentes](../README.md#35-trimming-y-filtrado-de-lecturas), ¿qué problemas detecta y qué acción tomará en el paso de limpieza?

---

### Paso 3 — Limpiar las lecturas con Fastp

Fastp es una herramienta todo-en-uno para preprocesamiento de lecturas. En un solo paso realiza:
- Recorte de adaptadores (detección automática).
- Filtrado por calidad con ventana deslizante.
- Eliminación de lecturas demasiado cortas.
- Generación de un reporte de calidad.

1. En Galaxy, busque **Fastp** y haga clic en la herramienta.
2. Configure los parámetros:
   - `Single-end or paired reads`: `Paired`
   - `Input 1`: archivo `*_1.fastq.gz`
   - `Input 2`: archivo `*_2.fastq.gz`
   - En `Adapter Trimming Options`: deje la detección automática activada.
   - En `Filter Options`:
     - `Qualified quality phred`: `20`
     - `Unqualified percent limit`: `40`
     - `Length required`: `50`
3. Haga clic en `Run Tool`.

> [!TIP]
> Fastp conserva el **emparejamiento** de las lecturas: las salidas `out1` y `out2` contienen los pares en los que **ambas** lecturas superaron el filtro. Esto es esencial para ensambladores que esperan lecturas perfectamente pareadas.

#### Reporte Fastp

Fastp genera un reporte HTML con estadísticas antes y después del filtrado. Compare:
- Número total de lecturas antes y después.
- Tasa de lecturas filtradas.
- Distribución de calidad por posición antes vs. después.

---

### Paso 4 — Re-evaluar la calidad con Falco (post-limpieza)

Repita el análisis Falco sobre los archivos **filtrados** de Fastp para verificar la mejora.

1. Ejecute **Falco** con los mismos parámetros del Paso 2, usando como entrada:
   - `out1` de Fastp (lecturas forward limpias)
   - `out2` de Fastp (lecturas reverse limpias)

**Preguntas:**

1. ¿Mejoró la calidad media por posición respecto al análisis inicial?
2. ¿Cambió el número de lecturas totales después del filtrado?
3. ¿La cobertura estimada sigue siendo suficiente para el ensamblaje?

---

### Paso 5 — Ensamblar con Shovill

Shovill usa SPAdes internamente con optimizaciones para genomas bacterianos. El proceso se basa en la construcción de un **grafo de De Bruijn** (ver [introducción general](00_genome_assembly_common.md#del-fragmento-al-contig-grafo-de-de-bruijn)).

> [!NOTE]
> A diferencia de Velvet, Shovill prueba múltiples valores de k internamente y selecciona el mejor automáticamente.

1. En Galaxy, busque **Shovill** y haga clic en la herramienta.
2. Configure los parámetros:
   - `Input reads type`: `Paired End`
   - `Forward reads (R1)`: salida `out1` de Fastp
   - `Reverse reads (R2)`: salida `out2` de Fastp
   - Deje los demás parámetros por defecto.
3. Haga clic en `Run Tool`.

#### Resultados de Shovill

| Salida           | Descripción                                                        |
|:-----------------|:-------------------------------------------------------------------|
| **contigs.fa**   | FASTA con los contigs ensamblados. Salida principal.               |
| **assembly.gfa** | Grafo de ensamblaje con información de conectividad entre contigs. |
| **shovill.log**  | Registro del proceso: k-mers usados, estadísticas básicas.         |

Explore el archivo `contigs.fa`: ¿cuántos contigs tiene? ¿Cuál es el más largo?

---

### Paso 6 — Evaluar el ensamblaje con QUAST

QUAST compara los contigs obtenidos contra un genoma de referencia y calcula estadísticas detalladas.

1. En Galaxy, busque **QUAST** y configure:
   - `Assembly mode`: `Co-assembly`
   - `Use customized names?`: `No`
   - `Contigs/scaffolds file`: salida `contigs.fa` de Shovill
   - `Type of assembly`: `Genome`
   - `Use a reference genome?`: `Yes`
   - `Reference genome`: el archivo `.fna` cargado al inicio
   - `Generate Circos plot`: `Yes`
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

> [!TIP]
> El **gráfico Circos** muestra los contigs alineados sobre el genoma circular de referencia. Las regiones vacías indican posibles gaps en el ensamblaje.

---

## ❓ Preguntas para reflexionar

### Sobre el control de calidad

1. ¿Cuál fue la cobertura estimada antes y después del trimming?
2. ¿Cómo cambió la longitud media de lectura después del filtrado con Fastp?
3. ¿El trimming mejoró las puntuaciones medias de calidad?
4. ¿El trimming afectó al contenido de GC?
5. ¿Los datos son adecuados para el ensamblaje? ¿Sería necesario volver a secuenciar?

### Sobre el ensamblaje

6. ¿Cuántos contigs se ensamblaron con Shovill?
7. ¿Cuál es la longitud del contig más largo?
8. ¿Cuál es el N50 y L50 del ensamblaje?
9. ¿Qué porcentaje del genoma de referencia fue cubierto (Genome Fraction)?
10. ¿Cuántos mismatches e indels se reportan por cada 100 kbp?
11. ¿Qué diferencia espera ver en las métricas si el k-mer fuera muy pequeño o muy grande?
12. **Para el Caso C** (*Streptomyces*): ¿Cómo cree que afecta el alto contenido GC (~72%) a las puntuaciones de calidad Phred y al ensamblaje?

---

## 🏆 Reto adicional (opcional)

1. **Compare dos ensamblajes:** ejecute Shovill con `--minlen 200` y compare las métricas QUAST respecto al ensamblaje original.
2. **Evalúe completitud con BUSCO:** si está disponible en Galaxy, ejecute BUSCO sobre sus contigs con la base de datos `bacteria_odb10` y reporte el % de genes completos.
3. **Explore el grafo de ensamblaje:** descargue el archivo `.gfa` y visualícelo en [Bandage](https://rrwick.github.io/Bandage/). ¿Puede identificar regiones circulares que correspondan a plásmidos?

---

## 📚 Bibliografía

Ver la [bibliografía completa en el documento de introducción general](00_genome_assembly_common.md#-bibliografía).

- Seemann, T. (Shovill): <https://github.com/tseemann/shovill>
- Prjibelski, A., et al., 2020. Using SPAdes De Novo Assembler. *Current Protocols in Bioinformatics* 70:e102.
- Chen, S., et al., 2018. fastp. *Bioinformatics* 34:i884–i890.
- Gurevich, A., et al., 2013. QUAST. *Bioinformatics* 29:1072–1075.
