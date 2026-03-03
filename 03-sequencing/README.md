# Módulo 3: Secuenciación de ADN y ARN

## Introducción

La capacidad de leer el código genético ha revolucionado la biología moderna. Desde los primeros esfuerzos laboriosos hasta las tecnologías de alto rendimiento actuales, la secuenciación de ácidos nucleicos nos permite descifrar genomas completos, entender la diversidad microbiana, diagnosticar enfermedades genéticas y rastrear brotes epidemiológicos en tiempo real.

En este módulo, exploraremos la evolución de las tecnologías de secuenciación, desde el método de Sanger hasta la secuenciación de tercera generación de lectura larga. Entenderemos no solo cómo funcionan estas máquinas, sino también qué tipo de datos producen, sus perfiles de error y sus aplicaciones específicas. Además, nos adentraremos en los desafíos bioinformáticos que surgen tras la secuenciación: ¿Cómo reconstruimos un genoma original a partir de millones de fragmentos pequeños? ¿Cómo encontramos y anotamos los genes dentro de esa secuencia?

Al finalizar este módulo, tendrá una comprensión sólida de los fundamentos de la secuenciación, el alineamiento de secuencias, el ensamblaje de genomas y la predicción de genes.

> **Reflexión:** Un buen bioinformático no es quien sabe correr el programa, sino quien entiende por qué el programa falló mirando los parámetros de calidad.

## 1. Historia y Línea de Tiempo de la Secuenciación

La historia de la secuenciación es una carrera constante hacia mayor velocidad, menor costo y mayor longitud de lectura.

*   **1977 - Secuenciación Sanger:** Frederick Sanger desarrolla el método de terminación de cadena, permitiendo secuenciar fragmentos de ADN de 500-1000 pb. Fue el estándar de oro durante 30 años y se usó para el Proyecto Genoma Humano.
*   **1987:** Aparece el primer secuenciador automático (ABI 370A).
*   **1990:** Inicio del Proyecto Genoma Humano.
*   **2005 - 454 Life Sciences (Pirosecuenciación):** Primera tecnología de "Nueva Generación" (NGS). Alta capacidad pero lecturas más cortas y problemas con homopolímeros.
*   **2006 - Solexa (Adquirida por Illumina):** Introduce la secuenciación por síntesis con terminadores reversibles. Domina el mercado actual por su bajo costo y alta precisión.
*   **2010 - Ion Torrent:** Secuenciación basada en detección de cambios de pH (semiconductores).
*   **2011 - Pacific Biosciences (PacBio):** Secuenciación de molécula única en tiempo real (SMRT). Tercera generación. Lecturas muy largas (>10kb) pero con mayor tasa de error inicial.
*   **2014 - Oxford Nanopore Technologies (MinION):** Secuenciación portátil basada en cambios de corriente eléctrica al pasar ADN por un nanoporo. Lecturas ultra largas y análisis en tiempo real.

En resumen, la secuenciación se divide tradicionalmente en tres "generaciones":

| Generación           | Tecnología Líder   | Longitud de Lectura   | Precisión       | Aplicación Principal                           |
|:---------------------|:-------------------|:----------------------|:----------------|:-----------------------------------------------|
| **1ra (Sanger)**     | ABI 3730xl         | 800 - 1000 bp         | 99.99%          | Validación de clones, plásmidos.               |
| **2da (NGS)**        | Illumina           | 50 - 300 bp           | 99.9%           | Re-secuenciación, RNA-Seq, Exomas.             |
| **3ra (Long Reads)** | PacBio / ONT       | 10 kb - 2 Mb          | Variable (Q20+) | Ensamblaje *de novo*, variantes estructurales. |

## 2. Tecnologías de Secuenciación

### 2.1 Primera Generación: Sanger
*   **Principio:** Uso de didesoxinucleótidos (ddNTPs) marcados con fluorescencia que detienen la polimerización del ADN en posiciones específicas. Los fragmentos se separan por electroforesis capilar.
*   **Características:** Lecturas de ~800-1000 pb.
*   **Calidad:** Calidad muy alta (Q > 40), es el estándar para validación.
*   **Aplicaciones:** Secuenciación de genes individuales, validación de variantes, plásmidos pequeños.

### 2.2 Segunda Generación (NGS - Next Generation Sequencing)

#### 454 (Pirosecuenciación) - *Histórico*
*   **Principio:** Detecta la liberación de pirofosfato (luz) cuando se incorpora un nucleótido.
*   **Características:** Lecturas de ~400-700 pb.
*   **Problemas:** Alta tasa de error en regiones de homopolímeros (ej. AAAAA). Ya no se usa ampliamente.

#### Illumina (Secuenciación por Síntesis)
*   **Principio:** Amplificación clonal en puente (bridge amplification) sobre una celda de flujo. Uso de nucleótidos con terminadores reversibles fluorescentes. Se toma una foto en cada ciclo.
*   **Características:** Lecturas cortas (paired-end 2x150bp o 2x300bp). Millones de lecturas por corrida (alto throughput).
*   **Calidad:** Muy alta, aunque decae al final de la lectura. El error principal es la sustitución.
*   **Aplicaciones:** Genomas completos, exomas, transcriptomas (RNA-Seq), metagenómica, ChIP-Seq.

### 2.3 Tercera Generación (Lecturas Largas)

#### Pacific Biosciences (PacBio SMRT)
*   **Principio:** Una polimerasa fija en el fondo de un pozo (ZMW) incorpora nucleótidos fosfolinked fluorescentes. Se detecta la luz en tiempo real.
*   **Características:** Lecturas largas (10kb - 20kb+). HiFi reads (lecturas consensuadas de alta precisión).
*   **Calidad:** Inicialmente ruidosa (10-15% error), pero con el modo CCS (Circular Consensus Sequencing) se obtiene alta precisión (Q30+).
*   **Aplicaciones:** Ensamblaje *de novo* de genomas complejos, detección de variantes estructurales, isoformas completas de ARN.

#### Oxford Nanopore (ONT)
*   **Principio:** Una molécula de ADN/ARN pasa a través de un poro proteico en una membrana. El paso de las bases altera la corriente iónica característica.
*   **Características:** Lecturas ultra largas (hasta Mb). Portátil (dispositivo USB).
*   **Calidad:** Históricamente menor que Illumina, pero ha mejorado drásticamente (Q20+ con kits recientes). Error principal: Indels.
*   **Aplicaciones:** Secuenciación en campo, genomas completos rápidos, detección directa de metilación, metagenómica en tiempo real.

> Si bien los años han marcado aspectos evolutivos claves en las tecnologías de secuenciación, es importante destacar que cada avance ha sido impulsado por la necesidad de superar limitaciones anteriores: desde la longitud de lectura hasta la precisión y el costo. Hoy en día, la elección de la tecnología de secuenciación depende del proyecto específico, el presupuesto y los objetivos científicos.

## 3. Principios Fundamentales

*   **Calidad Phred (Q-score):** Medida logarítmica de la probabilidad de error en una base. Q30 significa 1 error en 1000 bases (99.9% precisión).
*   **Paired-End Reads:** Lectura de ambos extremos de un fragmento de ADN. Ayuda a resolver regiones repetitivas y mejorar el ensamblaje.
*   **Librería:** Colección de fragmentos de ADN preparados con adaptadores listos para ser secuenciados.
*   **Archivos FASTQ:** Es el formato estándar de facto para almacenar secuencias biológicas junto con sus correspondientes puntuaciones de calidad. Cada lectura ocupa 4 líneas (ver **[Módulo 1 → Formato `.fastq`](../01-introduction/README.md#fastq)**):
    1.  Encabezado (comienza con `@`).
    2.  Secuencia de nucleótidos.
    3.  Separador (comienza con `+`).
    4.  Calidad codificada en caracteres ASCII (Phred Score).
*   **Cobertura (Coverage):** Número promedio de veces que cada base del genoma ha sido leída. (Ej. 30X para genomas humanos).
*   **Profundidad (Depth):** Similar a la cobertura, refiere a cuántas lecturas cubren una posición específica.

Como se mencionó anteriormente, la calidad de las lecturas es un aspecto crucial a considerar. Las tecnologías de secuenciación modernas producen datos masivos, pero no todos los datos son igualmente confiables. Es por eso que el control de calidad (QC) y la limpieza de datos son pasos esenciales antes de cualquier análisis posterior. 
La calidad de las lecturas se representa mediante la puntuación Phred, que es una medida logarítmica de la probabilidad de que una base se haya llamado
incorrectamente. La puntuación Phred (Q) se calcula utilizando la siguiente fórmula: 

$Q = -10 \log_{10}(P)$

donde P es la probabilidad de que la base se haya llamado incorrectamente. 
Por ejemplo, una puntuación Phred de 20 indica que hay un 1% de probabilidad 
de que la base se haya llamado incorrectamente, mientras que una puntuación 
de 30 indica una probabilidad del 0,1%.

Acá te presento una tabla con los valores de calidad y su significado:

#### Tabla 1. Calidad Phred
| Nivel de calidad Phred (Q) | Probabilidad de error de base (Pe) | Precisión de la base |
|----------------------------|------------------------------------|----------------------|
| 10                         | 1 en 10                            | 90%                  |
| 20                         | 1 en 100                           | 99%                  |
| 30                         | 1 en 1000                          | 99.9%                |
| 40                         | 1 en 10.000                        | 99.99%               |
| 50                         | 1 en 100.000                       | 99.999%              |

> Usualmente, se considera que una lectura de alta calidad tiene una puntuación Phred de al menos 30 (Q30), lo que significa que la probabilidad de error es de 1 en 1000 bases. Sin embargo, la calidad puede variar a lo largo de la lectura, y es común observar una disminución de la calidad hacia el final de las lecturas, especialmente en tecnologías como Illumina. Por eso, es fundamental realizar un control de calidad exhaustivo y aplicar filtros adecuados para garantizar que los datos utilizados en los análisis posteriores sean confiables.

## 4. Programas de Análisis de Secuenciación

El ecosistema de herramientas es vasto, pero algunos nombres son omnipresentes y se explorarán en ejercicios prácticos:

*   **Control de Calidad (QC):**
    *   **FastQC:** La herramienta estándar para visualizar métricas de calidad (bases por posición, contenido GC, niveles de duplicación).
    *   **Falco:** Una implementación alternativa en C++ de FastQC, diseñada para ser más rápida en grandes volúmenes de datos.
*   **Limpieza y Procesamiento (Trimming):**
    *   **Trimmomatic / Cutadapt:** Herramientas clásicas para eliminar adaptadores y bases de baja calidad.
    *   **Fastp:** Herramienta "todo en uno" ultra rápida que realiza control de calidad, filtrado y recorte en un solo paso.
*   **Alineamiento:**
    *   **BWA / Bowtie2:** Estándares para alinear lecturas cortas (Illumina) a un genoma de referencia.
    *   **Minimap2:** Versátil, utilizado principalmente para lecturas largas (PacBio/Nanopore).
*   **Ensamblaje *De Novo*:**
    *   **Velvet:** Uno de los primeros ensambladores basados en grafos de De Bruijn. Aunque antiguo, es excelente para entender el impacto del tamaño del *k-mer*.
    *   **SPAdes / Shovill:** SPAdes es el ensamblador más popular actualmente para bacterias y genomas pequeños. Shovill es un "wrapper" que optimiza SPAdes para hacerlo más rápido y eficiente.
    *   **Canu / Flye:** Diseñados específicamente para manejar los errores y la longitud de lecturas de tercera generación.
*   **Visualización:** IGV (Integrative Genomics Viewer), Tablet.
*   **Anotación:**
    *   **Prokka:** Herramienta rápida para la anotación de genomas procariotas. Integra múltiples bases de datos para predecir CDS, tRNA, rRNA y CRISPRs en minutos.

## 5. Alineamiento de Secuencias

El alineamiento es el proceso de organizar secuencias para identificar regiones de similitud que pueden ser consecuencia de relaciones funcionales, estructurales o evolutivas.

### 5.1 Conceptos Básicos
*   **Identidad:** Porcentaje de caracteres exactos que coinciden en la misma posición.
*   **Similitud:** Porcentaje de caracteres que son "parecidos" fisicoquímicamente (relevante en proteínas, ej. Leucina e Isoleucina).
*   **Homología:** Conclusión evolutiva basada en la similitud. Dos secuencias son homólogas si comparten un ancestro común. (No se dice "homología del 80%", o son homólogas o no lo son).

### 5.2 Tipos de Alineamiento
*   **Alineamiento Global:** Intenta alinear toda la longitud de ambas secuencias. Útil cuando las secuencias son de tamaño y composición similar. (Algoritmo: Needleman-Wunsch).
*   **Alineamiento Local:** Busca las regiones de mayor similitud dentro de secuencias que pueden ser muy divergentes en el resto. Es el fundamento de BLAST. (Algoritmo: Smith-Waterman).

## 6. Algoritmos de Ensamblaje de Genomas

El ensamblaje se parece a reconstruir un libro sin tener el original: primero lo “trituramos” en millones de copias y leemos pedacitos sueltos \(lecturas\); luego, usando sus solapamientos, armamos de nuevo el texto para inferir qué decía.

### 6.1 Enfoques Principales

#### Overlap-Layout-Consensus (OLC)
*   **Principio:** Busca solapamientos (overlaps) entre todas las lecturas para construir un grafo. Luego determina el camino (layout) y calcula la secuencia final (consensus).
*   **Uso:** Común en ensambladores de lecturas largas (Canu). Es computacionalmente costoso para millones de lecturas cortas.

#### Grafos de De Bruijn
*   **Principio:** En lugar de solapar lecturas enteras, divide las lecturas en fragmentos pequeños de tamaño fijo llamados **k-mers**. El grafo conecta k-mers que se superponen por k-1 bases.
*   **Importancia del K-mer:** La elección del tamaño de *k* es crítica (como veremos en prácticas con **Velvet**).
    *   *k* pequeño: Alta conectividad, pero confunde regiones repetitivas (el grafo se enmaraña).
    *   *k* grande: Resuelve repeticiones, pero requiere mayor cobertura y es sensible a errores de secuenciación (el grafo se rompe).
*   **Ventaja:** Maneja eficientemente la redundancia masiva de los datos de Illumina. No compara "todos contra todos".
*   **Uso:** Estándar para lecturas cortas (**SPAdes**, Velvet).
*   **Explicación Sencilla:** Imagina que en lugar de armar oraciones completas, rompes todo en sílabas de 3 letras y tratas de encadenarlas basándote en que el final de una sílaba coincide con el principio de la siguiente.

## 7. Anotación del Genoma

Una vez tenemos la secuencia ensamblada (FASTA), es solo una larga cadena de letras. La anotación es el proceso de identificar dónde están los "elementos funcionales" y qué hacen.

### 7.1 ¿Qué es un Gen?
Biológicamente, es una secuencia de ADN que se transcribe a ARN funcional (mRNA, tRNA, rRNA). Computacionalmente, buscamos patrones específicos que señalan su presencia.

### 7.2 Estructura del Gen y Predicción

#### Procariotas (Bacterias/Arqueas)
*   **Estructura:** Genes continuos, sin intrones. Densidad génica alta.
*   **Señales:** Promotor (-35, -10), Sitio de unión al ribosoma (RBS/Shine-Dalgarno), Codón de inicio (ATG), Marco de lectura abierto (ORF), Codón de parada.
*   **Algoritmos:** Buscan ORFs largos y modelos de Markov (HMM) entrenados para reconocer la "gramática" del ADN codificante. (Software: Prokka, Prodigal).

#### Eucariotas
*   **Estructura:** Genes discontinuos (exones e intrones). Promotores complejos, regiones UTR, splicing alternativo.
*   **Desafío:** Mucho más difícil de predecir solo con el ADN. A menudo se requiere evidencia de ARN (transcriptoma) para saber exactamente dónde están los exones.
*   **Algoritmos:** Usan modelos HMM complejos, homología con proteínas conocidas y pistas extrínsecas (RNA-Seq). (Software: Augustus, MAKER).

### 7.3 Anotación Funcional
Una vez predicho *dónde* está el gen, ¿qué hace?
*   **Búsqueda de Homología:** BLAST contra bases de datos (UniProt, NCBI nr).
*   **Dominios y Motivos:** Búsqueda de patrones conservados (InterProScan, Pfam).
*   **Ontología Génica (GO):** Asignación de vocabularios controlados para describir función molecular, proceso biológico y componente celular.

## 8. Flujos de Trabajo Típicos (Pipelines)

En la práctica bioinformática real, estos pasos no ocurren de forma aislada, sino que se integran en un flujo de trabajo. A continuación, se presenta un esquema del proceso que se explorará con herramientas específicas como **Fastp**, **Velvet**, **Shovill** y **Prokka**:

1.  **Obtención de datos crudos (`.fastq`):** Secuenciación de una muestra bacteriana.
2.  **Control de Calidad (QC):**
    *   Revisión de métricas con **FastQC** o **Falco**.
    *   ¿Hay adaptadores? ¿La calidad baja al final de la lectura?
3.  **Limpieza (Trimming):**
    *   Uso de **Fastp** para filtrar lecturas de mala calidad y recortar adaptadores.
    *   *Resultado:* Archivos FASTQ limpios.
4.  **Ensamblaje *De Novo*:**
    *   Construcción de contigs a partir de lecturas limpias.
    *   Uso de **Shovill** (wrapper de SPAdes) para un ensamblaje robusto o **Velvet** para comprender los fundamentos de los grafos.
    *   *Resultado:* Archivo FASTA con el genoma ensamblado.
5.  **Evaluación del Ensamblaje:**
    *   ¿Cuántos contigs obtuvimos? ¿Cuál es el N50? (Uso de herramientas como **QUAST**).
6.  **Anotación:**
    *   Identificación de genes en el ensamblaje.
    *   Uso de **Prokka** para generar tablas de características (`.gff`) y secuencias de proteínas (`.faa`).
