# Módulo 1: Introducción a la Bioinformática

## Introducción

En esta sección, sentaremos las bases para su viaje al nuevo mundo del laboratorio sin bata (dry lab). Comenzaremos por definir qué es la bioinformática y por qué se ha convertido en una disciplina indispensable en la ciencia moderna. Exploraremos su naturaleza multidisciplinaria y repasaremos los hitos históricos que han moldeado el campo. Además, abordaremos los conceptos biológicos fundamentales, como el dogma central y las ciencias "ómicas". Finalmente, nos adentraremos en el aspecto práctico, discutiendo las capacidades computacionales necesarias y familiarizándonos con las bases de datos y los formatos de archivo esenciales que todo bioinformático debe conocer. Al finalizar este módulo, tendrá una comprensión sólida de los conceptos y herramientas clave para empezar a trabajar con datos biológicos.
Recuerde que este módulo y en general este curso proporciona los fundamentos necesarios para comenzar en bioinformática. La práctica constante con bases de datos y formatos de archivo es esencial para dominar estas habilidades.

---

## Parte 1: Fundamentos y Conceptos Básicos

### 1.1 ¿Qué es la Bioinformática?

La bioinformática es una disciplina científica que combina biología, informática, matemáticas y estadística para analizar e interpretar datos biológicos. Su objetivo principal es comprender procesos biológicos complejos mediante herramientas computacionales.

**Definiciones clave:**

- **Bioinformática:** Aplicación de herramientas computacionales para capturar, almacenar, analizar y distribuir datos biológicos.
- **Biología Computacional:** Desarrollo de métodos teóricos, modelos matemáticos y técnicas computacionales para estudiar sistemas biológicos.
- **Biología de Sistemas:** Enfoque holístico que estudia las interacciones entre componentes de sistemas biológicos y cómo estas interacciones dan lugar a la función y comportamiento del sistema.
- **Biología Sintética:** Diseño y construcción de nuevos componentes, dispositivos y sistemas biológicos, o rediseño de sistemas naturales existentes.

### 1.2 Importancia de la Bioinformática

La bioinformática es crucial porque:

- Permite manejar el volumen masivo de datos generados por tecnologías modernas (secuenciación de nueva generación)
- Acelera el descubrimiento de fármacos y desarrollo de medicina personalizada
- Facilita la comprensión de enfermedades a nivel molecular
- Permite estudiar la evolución y relaciones entre especies
- Optimiza la agricultura y biotecnología

### 1.3 Naturaleza Multidisciplinaria

La bioinformática integra múltiples áreas:

- **Biología Molecular:** Proporciona el contexto biológico
- **Informática:** Desarrollo de algoritmos y software
- **Estadística:** Análisis e interpretación de datos
- **Matemáticas:** Modelado de sistemas biológicos
- **Química:** Estructura de moléculas
- **Física:** Propiedades moleculares

####  Ejemplos de proceso multidisciplinario:

**Problema biológico:** Identificar genes asociados a cáncer por _Helicobacter pylori_

1. **Biología:** Se obtienen muestras de ADN de pacientes y personas sanas. 
2. **Biología Molecular:** Se secuencian los genomas.
3. **Bioinformática/Matemática/Ingeniería de Sistemas:** Se utilizan herramientas como BLAST para alinear las secuencias contra un genoma de referencia y programas de ensamblaje para construir los genomas.
4. **Estadística:** Se realizan pruebas de asociación (GWAS) para encontrar variantes genéticas (SNPs) que son significativamente más frecuentes en los pacientes.
5. **Biología Computacional/Fisca/Quimica:** Se modela cómo una variante específica podría afectar la estructura 3D de una proteína y su función, prediciendo el impacto biológico.
6. **Biología (Laboratorio):** Se valida experimentalmente la función del gen y el efecto de la mutación en células o modelos animales.

### 1.4 Capacidades Computacionales

Hardware Recomendado:

- **Para principiantes:**
  * Procesador: Intel Core i5/i7 o AMD Ryzen 5/7
  * RAM: Mínimo 8GB, recomendado 16GB
  * Almacenamiento: 256GB SSD + disco externo para datos
  * GPU: Opcional, útil para deep learning


- **Para trabajo avanzado:**
  * Procesador: Multi-core (16+ cores)
  * RAM: 32GB o más
  * Almacenamiento: 1 TB SSD + almacenamiento en red
  * Clusters/Cloud: AWS, Google Cloud, servidores institucionales
  * Sistemas Operativos:
  * Linux (Ubuntu, CentOS): Preferido, mayoría de herramientas nativas
  * macOS: Compatible con muchas herramientas
  * Windows: WSL (Windows Subsystem for Linux) recomendado

**Ejemplo real**: Ensamblaje de genoma bacteriano

* Datos entrada: 5GB de lecturas Illumina
* RAM necesaria: 16-32GB
* Tiempo procesamiento: 2-6 horas
* Software: SPAdes, Velvet
* Sistema: Linux preferido

En resumen: 
- Computador Personal (Laptop/Desktop):
  * **Uso**: Ideal para análisis de pequeña escala, visualización de datos, escritura de scripts (Python, R), y manejo de secuencias individuales o genomas pequeños (bacterias).
  * **Ejemplo Real:** Alinear la secuencia de un gen como la insulina humana, visualizar la estructura de una proteína con UCSF chimerax, o ejecutar un script simple para contar nucleótidos.
  * **Sistema Operativo**: macOS o Linux (y sus subsistemas en Windows como WSL) son preferidos por su terminal de línea de comandos nativa, que es fundamental para la mayoría de las herramientas bioinformáticas.


- Servidores de Cómputo de Alto Rendimiento (HPC/Clusters):
  * **Uso:** Necesarios para tareas que requieren gran poder de cómputo y memoria, como el ensamblaje de genomas de novo, análisis de transcriptómica (RNA-seq) de muchas muestras, o simulaciones de dinámica molecular.
  * **Ejemplo Real:** Ensamblar el genoma de una planta a partir de millones de lecturas de secuenciación o analizar los datos de expresión génica de 100 tumores de cáncer.


### 1.5 Historia de la Bioinformática

Cronología:
* 1953: Watson y Crick descubren estructura del ADN
* 1965: Primera base de datos de secuencias de proteínas (Margaret Dayhoff)
* 1977: Método de secuenciación de Sanger
* 1982: GenBank se establece como repositorio público
* 1990-2003: Proyecto Genoma Humano
* 1990: BLAST (Basic Local Alignment Search Tool)
* 2000s: Era de la secuenciación de nueva generación (NGS)
* 2010s: CRISPR, single-cell sequencing
* 2020s: IA y aprendizaje automático en bioinformática

### 1.6 Las Ciencias Ómicas

Las ómicas estudian moléculas biológicas de forma global:
* **Genómica:** Estudio del genoma completo
* **Transcriptómica:** Análisis de ARN/expresión génica
* **Proteómica:** Conjunto de proteínas
* **Metabolómica:** Metabolitos celulares
* **Epigenómica**: Modificaciones epigenéticas

### 1.7 Dogma Central de la Biología Molecular

`ADN → ARN → Proteína`

`(Replicación) → (Transcripción) → (Traducción)`

* **ADN:** Almacena información genética
* **ARN:** Intermediario, lleva información
* **Proteína:** Ejecuta funciones celulares

Extensiones modernas:

* ARN puede ser replicado (virus ARN)
* Transcripción reversa (retrovirus)
* ARNs no codificantes con función reguladora

Finalmente, en conclusión, la bioinformática es una disciplina multidisciplinaria esencial que combina biología, informática y estadística para analizar datos biológicos masivos. Requiere conocimientos técnicos en programación, estadística y biología molecular, así como infraestructura computacional adecuada. Las ciencias ómicas y el dogma central proporcionan el marco conceptual para entender cómo la información fluye en sistemas biológicos.

---

## Parte 2: Bases de Datos y Recursos Bioinformáticos

### 2.1 Bases de datos y Tipos de Bases de Datos Biológicas

- **Bases de Datos Primarias:** Contienen datos experimentales directos. Almacenan datos crudos enviados directamente por los investigadores. Son un archivo histórico.
  * GenBank/NCBI: Secuencias nucleotídicas
  * UniProt: Secuencias de proteínas
  * PDB: Estructuras 3D de proteínas
  * SRA: Datos de secuenciación raw


- **Bases de Datos Secundarias:** Derivan de la información de las bases de datos primarias, añadiendo valor a través de la revisión manual, la anotación y la integración de datos.
  * Pfam: Familias de proteínas
  * GO (Gene Ontology): Funciones génicas
  * KEGG: Vías metabólicas
  * Ensembl: Genomas anotados


- **Bases de Datos Especializadas:** Se centran en un organismo, un tipo de dato o un problema biológico específico.
  * ClinVar: Variantes clínicas
  * dbSNP: Polimorfismos
  * TCGA: Datos de cáncer
  * GTEx: Expresión génica en tejidos
  * Saccharomyces Genome Database | SGD: Base de datos de la levadura Saccharomyces cerevisiae

### 2.3 Formatos de Archivo en Bioinformática

#### `.fasta` / `.fa` / `.fna`

- **Descripción:** Formato de texto para secuencias. Consiste en una línea de encabezado que empieza con > seguida de un identificador y una descripción, y luego las líneas de la secuencia de nucleótidos o aminoácidos.
- **Uso:** Es el formato más común para almacenar secuencias. Usado por BLAST, alineadores, etc.
- **Estructura:**

```
>gi|345678|ref|NM_007294.4| Homo sapiens BRCA1
ATGGATTTATCTGCTCTTCGCGTTGAAGAAGTACAAAATGTCATTAATGCTATGCAGAAAATCTTAGAGT
GTCCCATCTGTCTGGAGTTGATCAAGGAACCTGTCTCCACAAAGTGTGACCACATATTTTGCAAATTTTG
```
- **Características:**
  * Línea encabezado: > seguido de identificador
  * Secuencia: múltiples líneas
  * Simple y universal

#### `.fastq`

- **Descripción:** Similar a FASTA, pero incluye una puntuación de calidad para cada base. Tiene 4 líneas por secuencia: 1) Encabezado (@), 2) Secuencia, 3) Separador (+), 4) Puntuaciones de calidad (codificadas en ASCII).
- **Uso:** Es el formato de salida estándar de los secuenciadores de nueva generación (NGS).
- **Estructura:**

```
@SEQ_ID
GATTTGGGGTTCAAAGCAGTATCGATCAAATAGTAAATCCATTTGTTCAACTCACAGTTT
+
!''*((((***+))%%%++)(%%%%).1***-+*''))**55CCF>>>>>>CCCCCCC65
```

- **Características:**
  - 4 líneas por lectura
    * Línea 1: @ + identificador
    * Línea 2: Secuencia
    * Línea 3: + (opcional repetir ID)
    * Línea 4: Calidad (codificación Phred)

#### `.gff` (General Feature Format) / `.gtf`

- **Descripción:** Formato de texto tabular (separado por tabulaciones) para describir características de un genoma. Cada línea representa una característica (gen, exón, CDS) y especifica su ubicación (cromosoma, inicio, fin).
- **Uso:** Anotación de genomas.
- **Estructura:**

```
chr1	HAVANA	gene	11869	14409	.	+	.	ID=gene1;Name=DDX11L1
chr1	HAVANA	transcript	11869	14409	.	+	.	ID=transcript1;Parent=gene1
chr1	HAVANA	exon	11869	12227	.	+	.	ID=exon1;Parent=transcript1
Columnas: seqid, source, type, start, end, score, strand, phase, attributes
```

#### `.genbank` / `.gb`

- **Descripción:** Formato de texto enriquecido que combina la secuencia con una gran cantidad de anotaciones (locus, definición, número de acceso, características, origen, referencias bibliográficas).
- **Uso:** Formato de registro estándar en la base de datos GenBank del NCBI.
- **Estructura:**

```
LOCUS       NM_007294               7207 bp    mRNA    linear   PRI 15-MAR-2020
DEFINITION  Homo sapiens BRCA1, DNA repair associated (BRCA1), transcript
            variant 1, mRNA.
ACCESSION   NM_007294
FEATURES             Location/Qualifiers
     source          1..7207
                     /organism="Homo sapiens"
     gene            1..7207
                     /gene="BRCA1"
ORIGIN
        1 atggatttat ctgctcttcg cgttgaagaa gtacaaaatg tcattaatgc tatgcagaaa
        2 atggatttat ctgctcttcg cgttgaagaa gtacaaaatg tcattaatgc tatgcagaaa
```

#### `.csv` (Comma-Separated Values) / `.tsv` / `.txt` (Tab-Separated Values)

- **Descripción:** Archivos de texto plano con valores separados por comas (.csv) o tabulaciones (.tsv). Son formatos genéricos para datos tabulares.
- **Uso:** Muy utilizados para almacenar tablas de resultados, como conteos de expresión génica, listas de variantes genéticas, o metadatos de muestras. Fáciles de importar en R, Python (con Pandas) o Excel.

Ejemplo .csv:
```
Gene,Expression,P-value,FoldChange
BRCA1,456.2,0.001,2.3
TP53,789.1,0.0001,3.5
EGFR,234.8,0.05,1.2
```

Ejemplo .tsv:
```
Gene	Expression	P-value	FoldChange
BRCA1	456.2	0.001	2.3
TP53	789.1	0.0001	3.5
```

### 2.4 ¿Cuándo Usar Cada Formato?


| Formato       | Cuándo Usar                                         |
|---------------|-----------------------------------------------------|
| `.fasta`      | Secuencias simples, alineamientos, BLAST            |
| `.fastq`      | Datos crudos de NGS, control de calidad             |
| `.gff`        | Anotaciones genómicas, visualización en navegadores |
| `.genbank`    | Información completa, depositar en bases de datos   |
| `.csv`/`.tsv` | Resultados numéricos, análisis estadísticos, Excel  |


#### Recursos Adicionales

NCBI Handbook: Guía completa de recursos
Tutorial BLAST: https://blast.ncbi.nlm.nih.gov/Blast.cgi?CMD=Web&PAGE_TYPE=BlastDocs
Bioinformatics Data Skills (Libro): Vince Buffalo
Rosalind: Plataforma de ejercicios prácticos
