# 🧬 Anotación de Genomas: Guía de Prácticas — Introducción y Casos de Estudio

> [!NOTE]
> Este documento es el **punto de entrada compartido** para todas las prácticas de anotación genómica del Módulo 6. Contiene el contexto biológico, las plataformas de trabajo y los datos de cada caso. Las guías de procedimiento específicas están en los siguientes archivos:
>
> | Práctica                                                         | Plataforma    | Herramientas                                                            |
> |:-----------------------------------------------------------------|:--------------|:------------------------------------------------------------------------|
> | [Práctica A — Galaxy](01_1_genome_annotation_galaxy.md)          | Galaxy Europe | Bakta, AMRFinderPlus, PlasmidFinder, IntegronFinder, ISEScan            |
> | [Práctica B — Google Colab](01_2_genome_annotattion_colab.ipynb) | Google Colab  | Bakta, AMRFinderPlus, PlasmidFinder, **antiSMASH** (via conda) + Python |
>
> Los **Casos A y B** tienen enfoque clínico. El **Caso C** (*Streptomyces venezuelae*) y el **Caso D** (*Pseudomonas abieticivorans*) tienen enfoque biotecnológico/ambiental e incluyen **antiSMASH** como herramienta adicional.

---

## Introducción

La **anotación genómica** es el proceso de describir la estructura y la función de los componentes de un genoma ensamblado. Es el paso que convierte un archivo FASTA con contigs — una secuencia larga pero "muda" — en un mapa biológico interpretable: dónde están los genes, qué hacen, qué elementos móviles lleva el organismo y qué genes de resistencia o virulencia posee.

El proceso se divide en dos grandes etapas:

- **Anotación estructural:** identifica la localización de genes codificantes (CDS), ARN de transferencia (ARNt), ARN ribosomales (ARNr), regiones reguladoras y otros elementos funcionales.
- **Anotación funcional:** asigna una función biológica a cada elemento estructural, comparando contra bases de datos de secuencias y perfiles de proteínas (BLAST, HMM).

> [!TIP]
> Para repasar los conceptos de estructura génica, tipos de genes, algoritmos de predicción y bases de datos de anotación, lea las secciones **2, 3 y 4** del [README del Módulo 6](../README.md) antes de comenzar. Estos conceptos **no se repiten aquí**.

En estas prácticas trabajará con **contigs ya ensamblados** — los mismos organismos usados en el Módulo 5. Si realizó las prácticas de ensamblaje, puede usar sus propios contigs; de lo contrario, los datos están disponibles en Zenodo (ver sección de casos más abajo).

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

El profesor indicará cuál caso trabajar. Use los datos de **un solo organismo** para no consumir espacio innecesario.

---

### 🔴 Caso A — *Staphylococcus aureus* MRSA

**Contexto clínico:**

> *"Methicillin-resistant Staphylococcus aureus (MRSA) is a major pathogen causing nosocomial infections, and the clinical manifestations of MRSA range from asymptomatic colonization of the nasal mucosa to soft tissue infection to fulminant invasive disease."*
> — [Hikichi et al. 2019](https://journals.asm.org/doi/10.1128/mra.01212-19)

En esta práctica se usan los contigs de la muestra **KUN1163** del estudio citado.

|                                |                                                           |
|:-------------------------------|:----------------------------------------------------------|
| **Organismo**                  | *Staphylococcus aureus* MRSA, muestra KUN1163             |
| **Tamaño esperado del genoma** | ~2.8 Mb                                                   |
| **Contenido GC**               | ~33%                                                      |
| **Gram**                       | Positiva — coco                                           |
| **Importancia clínica**        | Infecciones nosocomiales; resistencia a meticilina (MRSA) |

> [!NOTE]
> Para este caso, al ejecutar AMRFinderPlus, use el grupo taxonómico `Staphylococcus aureus`.

<details>
<summary>📥 Cargar contigs en Galaxy (haga clic para expandir)</summary>

En Galaxy, haga clic en `Upload` → `Paste/Fetch data` y pegue el siguiente enlace:

```
https://zenodo.org/records/17252812/files/DRR187559_contigs.fasta
```

Haga clic en `Start` y espere a que el archivo esté en **verde** antes de continuar.

</details>

<details>
<summary>💻 Descargar contigs desde terminal o Colab (haga clic para expandir)</summary>

```bash
mkdir -p annotation/caso_A/data && cd annotation/caso_A
wget https://zenodo.org/records/17252812/files/DRR187559_contigs.fasta \
     -O data/DRR187559_contigs.fasta
echo "✅ Contigs Caso A descargados"
```

</details>

---

### 🔵 Caso B — *Klebsiella pneumoniae* (aislados hospitalarios, Colombia)

**Contexto clínico:**

> *"Klebsiella pneumoniae is one of the most important nosocomial pathogens worldwide. In Colombia, K. pneumoniae has been identified as the second most frequent microbial etiologic agent of healthcare-associated infections. We found that the spread of carbapenem resistance was mediated by successful clones belonging to sequence types (ST) such as ST11, ST1082, and ST307."*
> — [Medina et al. 2025](https://www.nature.com/articles/s44259-025-00127-x)

En esta práctica se usan los contigs de la muestra **G20000754** del estudio citado.

|                                |                                                                           |
|:-------------------------------|:--------------------------------------------------------------------------|
| **Organismo**                  | *Klebsiella pneumoniae*, muestra G20000754                                |
| **Tamaño esperado del genoma** | ~5.5 Mb                                                                   |
| **Contenido GC**               | ~57%                                                                      |
| **Gram**                       | Negativa — bacilo                                                         |
| **Importancia clínica**        | Infecciones asociadas a la atención sanitaria; resistencia a carbapenemes |

> [!NOTE]
> Para este caso, al ejecutar AMRFinderPlus, use el grupo taxonómico `Klebsiella pneumoniae`.

<details>
<summary>📥 Cargar contigs en Galaxy (haga clic para expandir)</summary>

En Galaxy, haga clic en `Upload` → `Paste/Fetch data` y pegue el siguiente enlace:

```
https://zenodo.org/records/17252812/files/ERR14828471_contigs.fasta
```

Haga clic en `Start` y espere a que el archivo esté en **verde** antes de continuar.

</details>

<details>
<summary>💻 Descargar contigs desde terminal o Colab (haga clic para expandir)</summary>

```bash
mkdir -p annotation/caso_B/data && cd annotation/caso_B
wget https://zenodo.org/records/17252812/files/ERR14828471_contigs.fasta \
     -O data/ERR14828471_contigs.fasta
echo "✅ Contigs Caso B descargados"
```

</details>

---

### 🟢 Caso C — *Streptomyces venezuelae* (actinobacteria de importancia biotecnológica)

**Contexto biotecnológico:**

> *Streptomyces venezuelae* ATCC 10712 es una actinobacteria Gram positiva del suelo, productora natural del antibiótico **cloranfenicol** y de numerosos compuestos bioactivos. Es uno de los organismos modelo más estudiados para la biosíntesis de productos naturales, sporulación y regulación génica en bacterias filamentosas.
> — [Pullan,S.T. et al. 2011](https://doi.org/10.1186/1471-2164-12-175)
> 
A diferencia de los casos A y B (patógenos clínicos), este caso tiene un enfoque **biotecnológico**: en lugar de buscar resistencias y virulencia, el análisis se orienta a **identificar clústeres de genes biosintéticos (BGC)** — las "fábricas moleculares" que producen antibióticos y otros metabolitos secundarios de valor industrial y farmacéutico.

|                                       |                                                                        |
|:--------------------------------------|:-----------------------------------------------------------------------|
| **Organismo**                         | *Streptomyces venezuelae* ATCC 10712                                   |
| **Accesión del genoma de referencia** | GCF_000253235.1                                                        |
| **Tamaño del genoma**                 | ~8.2 Mb                                                                |
| **Contenido GC**                      | ~72%                                                                   |
| **Gram**                              | Positiva — filamentosa                                                 |
| **Importancia**                       | Bioproducción de antibióticos, productos naturales, biología sintética |

> [!NOTE]
> En este caso se usa directamente el **genoma de referencia completo** (GCF_000253235.1) en lugar de contigs ensamblados, ya que *S. venezuelae* ATCC 10712 tiene un genoma terminado y bien anotado — ideal para observar la diferencia entre una anotación automatizada y la anotación curada en RefSeq.
>
> Para AMRFinderPlus no existe un grupo taxonómico específico para *Streptomyces* — use la búsqueda genérica sin especificar organismo.

> [!IMPORTANT]
> **La herramienta adicional clave para este caso es antiSMASH**, que predice Clústeres de Genes Biosintéticos (BGC). antiSMASH está disponible en la **Práctica B (Google Colab)**. En la Práctica A (Galaxy), se puede usar el servidor web antiSMASH directamente.

<details>
<summary>📥 Cargar genoma en Galaxy (haga clic para expandir)</summary>

En Galaxy, haga clic en `Upload` → `Paste/Fetch data` y pegue el siguiente enlace:

```
https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/253/235/GCF_000253235.1_ASM25323v1/GCF_000253235.1_ASM25323v1_genomic.fna.gz
```

Haga clic en `Start`. Galaxy descomprimirá el archivo automáticamente.

</details>

<details>
<summary>💻 Descargar genoma desde terminal o Colab (haga clic para expandir)</summary>

```bash
mkdir -p annotation/caso_C/data && cd annotation/caso_C
wget "https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/253/235/GCF_000253235.1_ASM25323v1/GCF_000253235.1_ASM25323v1_genomic.fna.gz" \ 
     -O data/GCF_000253235.1_genomic.fna.gz
gunzip data/GCF_000253235.1_genomic.fna.gz
echo "✅ Genoma Caso C descargado: $(grep -c '>' GCF_000253235.1_genomic.fna) secuencias"
```

</details>

---

### 🟣 Caso D — *Pseudomonas abieticivorans* (bacteria degradadora de diterpenos del suelo)

**Contexto ambiental y biotecnológico:**

> *"Pseudomonas abieticivorans* is a soil bacterium with the remarkable ability to degrade abietic acid and other diterpenoid resin acids — major components of conifer forest litter and paper-mill effluents. Its genome encodes an extensive repertoire for aromatic and terpenoid compound catabolism, positioning it as a promising candidate for bioremediation and biotransformation applications."*
> — [Ristinmaa, A.S. et al. et al. 2023, *Nature Communications*](https://doi.org/10.1038/s41467-023-43867-y)

A diferencia de los casos A y B (patógenos clínicos) y del Caso C (*Streptomyces*), este caso tiene un enfoque **ambiental y de biorremediación**: el análisis se orienta a identificar rutas de degradación de compuestos aromáticos y diterpenos, y a explorar el potencial biotecnológico del organismo.

|                                       |                                                          |
|:--------------------------------------|:---------------------------------------------------------|
| **Organismo**                         | *Pseudomonas abieticivorans*                             |
| **Accesión del genoma de referencia** | GCF_023509015.1                                          |
| **Tamaño del genoma**                 | ~6.7 Mb (cromosoma único, genoma completo)               |
| **Contenido GC**                      | ~63%                                                     |
| **Gram**                              | Negativa — bacilo                                        |
| **Importancia**                       | Biorremediación, degradación de diterpenos, biocatálisis |

> [!NOTE]
> Al igual que en el Caso C, se usa el **genoma de referencia completo** (GCF_023509015.1) — un cromosoma único sin gaps. Esto permite observar la diferencia en calidad de anotación entre un genoma *finished* y un borrador fragmentado.
>
> Para AMRFinderPlus, use el grupo taxonómico `Pseudomonas aeruginosa` como el más cercano disponible.

> [!TIP]
> **antiSMASH también es relevante para este caso.** Aunque *Pseudomonas* es menos conocido que *Streptomyces* por producción de metabolitos secundarios, los genomas de *P. abieticivorans* contienen BGC para sideróforos, lipopéptidos y otros compuestos bioactivos. Úselo en la **Práctica B (Colab)** o en el servidor web.

<details>
<summary>📥 Cargar genoma en Galaxy (haga clic para expandir)</summary>

En Galaxy, haga clic en `Upload` → `Paste/Fetch data` y pegue el siguiente enlace:

```
https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/023/509/015/GCF_023509015.1_ASM2350901v1/GCF_023509015.1_ASM2350901v1_genomic.fna.gz
```

Haga clic en `Start`. Galaxy descomprimirá el archivo automáticamente.

</details>

<details>
<summary>💻 Descargar genoma desde terminal o Colab (haga clic para expandir)</summary>

```bash
mkdir -p annotation/caso_D/data && cd annotation/caso_D
wget "https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/023/509/015/GCF_023509015.1_ASM2350901v1/GCF_023509015.1_ASM2350901v1_genomic.fna.gz" \
     -O data/GCF_023509015.1_genomic.fna.gz
gunzip data/GCF_023509015.1_genomic.fna.gz
mv data/GCF_023509015.1_genomic.fna data/contigs.fasta
echo "✅ Genoma Caso D descargado: $(grep -c '>' data/contigs.fasta) secuencias"
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
7. Para el caso asignado: con base en el contexto clínico/biotecnológico, ¿qué elementos esperaría encontrar?
8. **Solo Caso C:** ¿Qué es un clúster de genes biosintéticos (BGC)? ¿Por qué *Streptomyces* es el género bacteriano más prolífico en producción de metabolitos secundarios?
9. **Solo Caso C:** ¿Qué diferencia hay entre anotar un genoma completo (*finished*) y un borrador (*draft*) con muchos contigs?

---

## 📚 Bibliografía

Schwengers, O., et al., 2021. Bakta: rapid and standardized annotation of bacterial genomes via alignment-free sequence identification. *Microbial Genomics* 7:000685. [10.1099/mgen.0.000685](https://doi.org/10.1099/mgen.0.000685)

Seemann, T., 2014. Prokka: rapid prokaryotic genome annotation. *Bioinformatics* 30:2068–2069. [10.1093/bioinformatics/btu153](https://doi.org/10.1093/bioinformatics/btu153)

Feldgarden, M., et al., 2019. Using the NCBI AMRFinder tool and resistance gene database to screen the NCBI pathogen isolates browser. [10.1128/AAC.00483-19](https://doi.org/10.1128/AAC.00483-19)

Carattoli, A., & Hasman, H., 2020. PlasmidFinder and *in silico* pMLST. *Horizontal Gene Transfer: Methods and Protocols* 285–294. [10.1007/978-1-4939-9877-7_20](https://doi.org/10.1007/978-1-4939-9877-7_20)

Néron, B., et al., 2022. IntegronFinder 2.0: identification and analysis of integrons across bacteria, with a focus on antibiotic resistance in *Klebsiella*. *Microorganisms* 10:700. [10.3390/microorganisms10040700](https://doi.org/10.3390/microorganisms10040700)

Xie, Z., & Tang, H., 2017. ISEScan: automated identification of insertion sequence elements in prokaryotic genomes. *Bioinformatics* 33:3340–3347. [10.1093/bioinformatics/btx433](https://doi.org/10.1093/bioinformatics/btx433)

Hikichi, M., et al., 2019. *Microbiology Resource Announcements* 8. [10.1128/mra.01212-19](https://doi.org/10.1128/mra.01212-19)

Medina et al., 2025. *npj Antimicrobials and Resistance*. [10.1038/s44259-025-00127-x](https://doi.org/10.1038/s44259-025-00127-x)

Pullan, S.T.. et al., et al., 2011. *BMC Genomics* 12. [10.1186/1471-2164-12-175](https://doi.org/10.1186/1471-2164-12-175)

Ristinmaa, A.S. et al., et al., 2023. *Nature Communications* 14. [10.1038/s41467-023-43867-y](https://doi.org/10.1038/s41467-023-43867-y)

Blin, K., et al., 2023. antiSMASH 7.0: new and improved predictions for detection, regulation and visualisation. *Nucleic Acids Research* 51:W46–W50. [10.1093/nar/gkad344](https://doi.org/10.1093/nar/gkad344)

