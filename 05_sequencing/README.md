# Módulo 5: Secuenciación de ADN y ARN

## Introducción

La capacidad de leer el código genético ha revolucionado la biología moderna. Desde los primeros esfuerzos laboriosos hasta las tecnologías de alto rendimiento actuales, la secuenciación de ácidos nucleicos nos permite descifrar genomas completos, entender la diversidad microbiana, diagnosticar enfermedades genéticas y rastrear brotes epidemiológicos en tiempo real.

En este módulo exploraremos la evolución de las tecnologías de secuenciación, desde el método de Sanger hasta las plataformas de lectura larga de tercera generación. Entenderemos no solo cómo funcionan estas tecnologías, sino también qué tipo de datos producen, cuáles son sus perfiles de error y en qué contextos conviene utilizarlas. Además, nos adentraremos en los desafíos bioinformáticos que aparecen después de secuenciar: ¿cómo evaluamos la calidad de las lecturas?, ¿cómo alineamos secuencias?, ¿cómo reconstruimos un genoma a partir de millones de fragmentos?, ¿y cómo reconocemos genes dentro de esa secuencia?

Aunque muchas veces se habla principalmente de secuenciación de ADN, varios de estos principios también aplican al ARN. En RNA-seq, por ejemplo, el material biológico original es ARN, pero frecuentemente se convierte a ADN complementario (cDNA) antes de secuenciarse. En tecnologías como Oxford Nanopore, incluso es posible secuenciar ARN de forma más directa en ciertos flujos de trabajo.

Al finalizar este módulo, tendrá una comprensión sólida de los fundamentos de la secuenciación, la calidad de lecturas, el alineamiento de secuencias, el ensamblaje de genomas y la lógica general de la anotación genómica.

> **Reflexión:** Un buen bioinformático no es quien solo sabe correr un programa, sino quien entiende qué significan sus resultados y por qué el análisis puede fallar.

## Ruta conceptual del módulo

Este módulo sigue una lógica parecida a la de un análisis real:

1. **Generación de lecturas** mediante una plataforma de secuenciación.
2. **Evaluación de calidad** de los archivos FASTQ.
3. **Limpieza y filtrado** de lecturas cuando sea necesario.
4. **Alineamiento o mapeo** contra una referencia, o **ensamblaje *de novo***.
5. **Interpretación biológica** del resultado: comparación, anotación y análisis posterior.

En otras palabras, secuenciar no es el final del trabajo experimental; es el inicio del análisis bioinformático.

## 1. Historia y línea de tiempo de la secuenciación

La historia de la secuenciación es una carrera constante hacia mayor velocidad, menor costo y mayor longitud de lectura.

*   **1977 - Secuenciación Sanger:** Frederick Sanger desarrolla el método de terminación de cadena, permitiendo secuenciar fragmentos de ADN de 500-1000 pb. Fue el estándar de oro durante décadas y se utilizó en el Proyecto Genoma Humano.
*   **1987:** aparece el primer secuenciador automático (ABI 370A).
*   **1990:** inicio del Proyecto Genoma Humano.
*   **2005 - 454 Life Sciences (pirosecuenciación):** primera tecnología de “Nueva Generación” (NGS). Aumentó enormemente la capacidad de secuenciación, aunque tenía problemas con homopolímeros.
*   **2006 - Solexa / Illumina:** introduce la secuenciación por síntesis con terminadores reversibles. Se convierte en la plataforma dominante por su alta precisión y bajo costo por base.
*   **2010 - Ion Torrent:** secuenciación basada en detección de cambios de pH.
*   **2011 - Pacific Biosciences (PacBio):** secuenciación de molécula única en tiempo real (SMRT), con lecturas largas.
*   **2014 - Oxford Nanopore Technologies (ONT):** secuenciación portátil basada en cambios de corriente eléctrica al pasar ADN o ARN por un nanoporo.

En resumen, la secuenciación suele dividirse en tres generaciones:

| Generación                | Tecnología líder | Longitud de lectura | Precisión       | Aplicación principal                                               |
|:--------------------------|:-----------------|:--------------------|:----------------|:-------------------------------------------------------------------|
| **1ra (Sanger)**          | ABI 3730xl       | 800 - 1000 pb       | 99.99%          | Validación de genes, plásmidos y fragmentos individuales           |
| **2da (NGS)**             | Illumina         | 50 - 300 pb         | 99.9%           | Re-secuenciación, RNA-seq, genomas bacterianos, metagenómica       |
| **3ra (lecturas largas)** | PacBio / ONT     | 10 kb - 2 Mb        | Variable (Q20+) | Ensamblaje *de novo*, variantes estructurales, isoformas completas |

## 2. Tecnologías de secuenciación

### 2.1 Primera generación: Sanger

*   **Principio:** uso de didesoxinucleótidos (ddNTPs) marcados con fluorescencia que detienen la polimerización del ADN en posiciones específicas. Los fragmentos resultantes se separan por electroforesis capilar.
*   **Características:** lecturas de ~800-1000 pb.
*   **Calidad:** muy alta (Q > 40), por lo que sigue siendo una referencia para validación.
*   **Aplicaciones:** secuenciación de genes individuales, validación de variantes, confirmación de clones y plásmidos.

### 2.2 Segunda generación (NGS)

#### 454 (pirosecuenciación) - *histórica*

*   **Principio:** detecta la liberación de pirofosfato cuando se incorpora un nucleótido.
*   **Características:** lecturas de ~400-700 pb.
*   **Limitaciones:** alta tasa de error en regiones con homopolímeros (por ejemplo, `AAAAAA`). Actualmente se usa poco.

#### Illumina (secuenciación por síntesis)

*   **Principio:** amplificación clonal en puente sobre una celda de flujo y uso de nucleótidos con terminadores reversibles fluorescentes. En cada ciclo, el sistema “fotografía” la base incorporada.
*   **Características:** lecturas cortas, usualmente `paired-end` (por ejemplo, 2x150 pb).
*   **Calidad:** muy alta, aunque suele disminuir hacia el final de la lectura. El error más frecuente es la sustitución.
*   **Aplicaciones:** genomas completos, exomas, transcriptomas (RNA-seq), metagenómica, estudios de diversidad y vigilancia genómica.

### 2.3 Tercera generación (lecturas largas)

#### Pacific Biosciences (PacBio SMRT)

*   **Principio:** una polimerasa inmovilizada incorpora nucleótidos fluorescentes en tiempo real dentro de un pozo nanoscópico (ZMW).
*   **Características:** lecturas largas (10 kb - 20 kb o más).
*   **Calidad:** inicialmente presentaba errores relativamente altos por lectura individual, pero con HiFi/CCS se logran lecturas de alta precisión (Q30+).
*   **Aplicaciones:** ensamblaje *de novo* de genomas complejos, detección de variantes estructurales y secuenciación de transcritos completos.

#### Oxford Nanopore Technologies (ONT)

*   **Principio:** una molécula de ADN o ARN atraviesa un nanoporo, y cada base altera la corriente eléctrica de forma característica.
*   **Características:** lecturas ultra largas, posibilidad de análisis en tiempo real y dispositivos portátiles.
*   **Calidad:** históricamente inferior a Illumina, aunque ha mejorado mucho. Los errores suelen incluir inserciones y deleciones.
*   **Aplicaciones:** secuenciación rápida en campo, ensamblaje de genomas completos, metagenómica en tiempo real, detección de metilación y, en algunos protocolos, secuenciación directa de ARN.

### 2.4 ¿Cuándo usar cada tecnología?

| Tecnología   | Fortalezas                                        | Limitaciones                  | Ejemplos de uso                                       |
|:-------------|:--------------------------------------------------|:------------------------------|:------------------------------------------------------|
| **Sanger**   | Muy alta precisión, fácil de interpretar          | Bajo rendimiento              | Validar una mutación o un clon                        |
| **Illumina** | Alta precisión, gran volumen, costo por base bajo | Lecturas cortas               | Genomas bacterianos, RNA-seq, metagenómica            |
| **PacBio**   | Lecturas largas y alta calidad en modo HiFi       | Mayor costo por muestra       | Ensamblajes complejos, isoformas completas            |
| **Nanopore** | Lecturas ultra largas, portátil, tiempo real      | Mayor variabilidad en calidad | Vigilancia rápida, metagenómica, ensamblajes híbridos |

> La mejor tecnología no es necesariamente la más nueva, sino la que responde mejor a la pregunta biológica, al presupuesto disponible y al tipo de muestra.

## 3. Principios fundamentales

### 3.1 ¿Qué produce realmente un secuenciador?

El producto directo de un secuenciador moderno no es un genoma completo, sino una colección de **lecturas** (*reads*): fragmentos de secuencia que luego deben analizarse computacionalmente.

Conceptos clave:

*   **Lectura (*read*):** fragmento de ADN o ARN secuenciado.
*   **Librería:** colección de fragmentos preparados con adaptadores para entrar al secuenciador.
*   **Adaptadores:** secuencias artificiales añadidas durante la preparación de librería; si no se eliminan cuando aparecen en los datos, pueden interferir con el análisis.
*   **Paired-end reads:** lecturas obtenidas desde ambos extremos de un mismo fragmento. Ayudan a resolver regiones repetitivas, mejorar alineamientos y apoyar ensamblajes.

### 3.2 Formatos de salida: FASTQ

El archivo **FASTQ** es el formato estándar para almacenar secuencias junto con sus puntuaciones de calidad. Cada lectura ocupa 4 líneas:

1. **Encabezado**, que comienza con `@`.
2. **Secuencia** de nucleótidos.
3. **Separador**, que comienza con `+`.
4. **Calidad**, codificada en caracteres ASCII.

Ver también **[Módulo 1 → Formato `.fastq`](../01-introduction/README.md#fastq)**.

La diferencia principal entre FASTA y FASTQ es que:

*   **FASTA** almacena solo la secuencia;
*   **FASTQ** almacena la secuencia **y** la calidad de cada base.

### 3.3 Calidad Phred (Q-score)

La calidad de las lecturas es un aspecto crucial antes de cualquier análisis posterior. Las plataformas modernas producen grandes volúmenes de datos, pero no todas las bases tienen el mismo nivel de confianza.

La puntuación Phred representa, en escala logarítmica, la probabilidad de error de una base:

$Q = -10 \log_{10}(P)$

Donde `P` es la probabilidad de que la base se haya llamado incorrectamente.

Por ejemplo:

*   **Q20** = 1 error por cada 100 bases (99% precisión)
*   **Q30** = 1 error por cada 1000 bases (99.9% precisión)
*   **Q40** = 1 error por cada 10,000 bases (99.99% precisión)

#### Tabla 1. Calidad Phred

| Nivel de calidad Phred (Q) | Probabilidad de error | Precisión de la base |
|:---------------------------|:----------------------|:---------------------|
| 10                         | 1 en 10               | 90%                  |
| 20                         | 1 en 100              | 99%                  |
| 30                         | 1 en 1000             | 99.9%                |
| 40                         | 1 en 10,000           | 99.99%               |
| 50                         | 1 en 100,000          | 99.999%              |

Usualmente, se considera que una lectura de alta calidad tiene una puntuación Phred de al menos **Q30**. Sin embargo, la calidad puede variar a lo largo de la lectura, y es frecuente que disminuya hacia el final, especialmente en lecturas Illumina.

### 3.4 Cobertura y profundidad

Estos términos a veces se usan como sinónimos, pero conviene diferenciarlos:

*   **Cobertura (coverage):** número promedio de veces que cada base del genoma fue leída a escala global. Por ejemplo, una cobertura de 30X sugiere que, en promedio, cada posición fue observada 30 veces.
*   **Profundidad (depth):** número de lecturas que cubren una posición específica del genoma.

Una cobertura suficiente aumenta la confianza en el ensamblaje y en la detección de variantes. Sin embargo, una cobertura alta no corrige por sí sola problemas como contaminación, sesgos de secuenciación o errores sistemáticos.

### 3.5 Adaptadores, trimming y filtrado

Antes de ensamblar o alinear lecturas, suele ser necesario revisar si contienen:

*   **adaptadores residuales**;
*   **bases de baja calidad** al inicio o al final;
*   **lecturas demasiado cortas** después del recorte;
*   **duplicación excesiva** o sesgos de contenido GC.

A este proceso se le suele llamar **trimming** o limpieza de lecturas. No siempre se hace de forma agresiva: el objetivo no es “recortar por recortar”, sino mejorar la calidad de los datos sin eliminar información útil.

## 4. Programas de análisis de secuenciación

El ecosistema de herramientas es muy amplio, pero algunos nombres aparecen con frecuencia en flujos de trabajo reales y en las prácticas del curso.

### 4.1 Control de calidad (QC)

*   **FastQC:** herramienta clásica para visualizar métricas de calidad como calidad por base, contenido GC, duplicación y presencia de adaptadores.
*   **Falco:** implementación alternativa y más rápida para datos de lectura corta, especialmente útil cuando se manejan múltiples archivos.
*   **MultiQC:** integra múltiples reportes en una sola vista resumida.

### 4.2 Limpieza y procesamiento de lecturas

*   **Trimmomatic / Cutadapt:** herramientas clásicas para remover adaptadores y bases de baja calidad.
*   **Fastp:** herramienta todo-en-uno para control de calidad, filtrado y trimming.

### 4.3 Alineamiento

*   **BWA / Bowtie2:** estándares para alinear lecturas cortas contra una referencia.
*   **Minimap2:** especialmente útil para lecturas largas, aunque también puede utilizarse en otros contextos.

### 4.4 Ensamblaje *de novo*

*   **Velvet:** uno de los ensambladores clásicos basados en grafos de De Bruijn. Es muy útil para entender el efecto del tamaño del *k-mer*.
*   **SPAdes / Shovill:** ampliamente utilizados en genómica bacteriana con lecturas Illumina.
*   **Canu / Flye:** diseñados para lecturas largas de tercera generación.

### 4.5 Visualización y anotación

*   **IGV (Integrative Genomics Viewer):** visualización de alineamientos, cobertura y variantes.
*   **Tablet:** exploración visual de ensamblajes y lecturas alineadas.
*   **Prokka / Bakta:** anotación rápida de genomas procariotas.

De esta forma, el módulo 5 funciona como un puente entre los conceptos fundamentales de secuenciación y las prácticas más aplicadas de ensamblaje, anotación y análisis genómico del módulo 6.

## 7. Cierre conceptual

La secuenciación moderna no consiste solo en generar datos, sino en comprender qué representan esos datos y qué limitaciones arrastran desde el laboratorio hasta el análisis computacional. La elección de la tecnología, la evaluación de la calidad, el tipo de alineamiento y la estrategia de ensamblaje dependen siempre de la pregunta biológica.

En los siguientes módulos, estos principios se aplicarán a problemas más concretos: reconstrucción de genomas, anotación de genes, comparación entre cepas, búsqueda de variantes y análisis funcional. Comprender bien esta base le permitirá interpretar mejor los resultados y tomar decisiones bioinformáticas más informadas.

---

## Prácticas del módulo

Este módulo teórico prepara directamente el trabajo práctico que se desarrolla en análisis de secuencias y genómica. Las prácticas asociadas se encuentran en los módulos 3 y 6:

| Práctica                                                                                                  | Descripción                                                          |
|:----------------------------------------------------------------------------------------------------------|:---------------------------------------------------------------------|
| [Ensamblaje con FastQC + Velvet](../06-genomics/exercises/genome_assembly_fastqc_velvet.md)               | Calidad de lecturas (FASTQ) y ensamblaje *de novo* con Velvet        |
| [Ensamblaje con Falco + fastp + Shovill](../06-genomics/exercises/genome_assembly_falco_fastp_shovill.md) | QC, trimming y ensamblaje con pipeline moderno                       |
| [Diseño de primers](../03-sequence_analysis/exercises/primer_design.md)                                   | Alineamiento, complementariedad y especificidad de secuencias        |
| [Anotación genómica](../06-genomics/exercises/genome_annotation.md)                                       | Predicción de genes y asignación de funciones en genomas bacterianos |
