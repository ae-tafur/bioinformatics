# 🧬 Ensamblaje de Genomas: Guía de Prácticas — Introducción y Casos de Estudio

> [!NOTE]
> Este documento es el **punto de entrada compartido** para todas las prácticas de ensamblaje del Módulo 5. Contiene el contexto biológico, la plataforma de trabajo y los datos de cada caso. Las guías de procedimiento específicas están en los siguientes archivos:
>
> | Práctica                                                                            | Plataforma   | Herramientas                                |
> |:------------------------------------------------------------------------------------|:-------------|:--------------------------------------------|
> | [Práctica A — Falco + Fastp + Shovill](01_1_genome_assembly_falco_fastp_shovill.md) | Galaxy       | Falco, Fastp, Shovill, QUAST                |
> | [Práctica B — FastQC + Trimmomatic + Velvet](01_2_genome_assembly_fastqc_velvet.md) | Galaxy       | FastQC, MultiQC, Trimmomatic, Velvet, QUAST |
> | [Práctica C — Python + conda en Google Colab](01_3_genome_assembly_colab.ipynb)     | Google Colab | fastp, SPAdes, QUAST (via conda)            |
>
> **Casos:** A (*S. aureus* MRSA) y B (*K. pneumoniae*) → clínico · C (*S. venezuelae*) → biotecnológico · D (*P. abieticivorans*) → ambiental/bioprospección

---

## Introducción

El **ensamblaje de genomas** es el proceso mediante el cual se reconstruye la secuencia completa de un genoma a partir de millones de fragmentos cortos de ADN generados por secuenciadores modernos. Es, en esencia, como intentar reconstruir el texto de un libro del que solo se tienen tiras de papel con fragmentos de líneas desordenadas.

En estas prácticas trabajará con datos reales de secuenciación Illumina (lecturas paired-end de 150 pb) y realizará un **ensamblaje de novo** seguido de una **evaluación comparando contra un genoma de referencia**. Esto significa que:

- El ensamblaje se construye **sin usar la referencia como guía** — el ensamblador une las lecturas por solapamiento, sin saber cómo es el genoma final.
- La referencia se usa **solo al final**, en QUAST, para medir qué tan bien quedó el ensamblaje: qué porcentaje del genoma se cubrió, cuántos errores tiene, etc.

> [!TIP]
> Para repasar los conceptos de ensamblaje de novo vs. guiado por referencia, cobertura, calidad Phred, N50/L50 y las métricas de evaluación, lea las secciones **3**, **4**, **5** y **6** del [README del Módulo 5](../README.md) antes de comenzar. Estos conceptos **no se repiten aquí** — este documento se enfoca en el flujo de trabajo práctico.

---

## 🔬 Flujo de trabajo general

Todas las prácticas siguen el mismo flujo, independientemente de la herramienta usada:

```
Lecturas crudas (FASTQ paired-end)
        │
        ▼
[ 1. Evaluación de calidad ]     ← Falco / FastQC / fastp (reporte)
        │
        ▼
[ 2. Limpieza / Trimming ]       ← Fastp / Trimmomatic
        │
        ▼
[ 3. Re-evaluación de calidad ]  ← confirmar mejora
        │
        ▼
[ 4. Ensamblaje de novo ]        ← Shovill (SPAdes) / Velvet / SPAdes
        │
        ▼
[ 5. Evaluación del ensamblaje ] ← QUAST (comparando contra referencia)
```

> [!NOTE]
> En el **Paso 5**, QUAST usa el genoma de referencia para medir la calidad del ensamblaje, pero la referencia **no se usó** para construirlo. Esto permite evaluar de forma objetiva qué tan bien el ensamblador reconstruyó el genoma partiendo solo de las lecturas.

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

Google Colab es un entorno de notebooks de Python que corre en la nube de Google. En la **Práctica C** se usa junto con `conda` para instalar herramientas de línea de comandos (fastp, SPAdes, QUAST) directamente en el entorno del notebook, sin necesidad de instalar nada localmente.

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

## 🧫 Casos de estudio

Esta práctica se organiza por **casos**. El profesor indicará cuál caso trabajar. Cada caso corresponde a un organismo bacteriano diferente con datos de secuenciación reales disponibles públicamente.

> [!IMPORTANT]
> Cargue **solo los archivos del caso asignado** para no consumir espacio de almacenamiento innecesario.

---

### 🔴 Caso A — *Staphylococcus aureus* resistente a meticilina (MRSA)

**Contexto clínico:**

> *"Methicillin-resistant Staphylococcus aureus (MRSA) is a major pathogen causing nosocomial infections, and the clinical manifestations of MRSA range from asymptomatic colonization of the nasal mucosa to soft tissue infection to fulminant invasive disease."*
> — [Hikichi et al. 2019](https://journals.asm.org/doi/10.1128/mra.01212-19)

|                     |                              |
|:--------------------|:-----------------------------|
| **Organismo**       | *Staphylococcus aureus* MRSA |
| **Tamaño esperado** | ~2.8 Mb                      |
| **Contenido GC**    | ~33%                         |
| **Secuenciación**   | Illumina paired-end          |
| **Accesión**        | DRR187559                    |

<details>
<summary>📥 Cargar datos en Galaxy (haga clic para expandir)</summary>

En Galaxy, haga clic en `Upload` → `Paste/Fetch data` y pegue los siguientes enlaces:

```
https://zenodo.org/records/17156735/files/DRR187559_1.fastq.gz
https://zenodo.org/records/17156735/files/DRR187559_2.fastq.gz
https://zenodo.org/records/17156735/files/GCF_000013425.1_ASM1342v1_genomic.fna
```

Haga clic en `Start` y espere a que los archivos estén en **verde** antes de continuar.

</details>

<details>
<summary>💻 Descargar datos desde terminal o Colab (haga clic para expandir)</summary>

```bash
mkdir -p GenomeAssembly/caso_A/data && cd GenomeAssembly/caso_A

# Lecturas
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/DRR187/DRR187559/DRR187559_1.fastq.gz -O data/DRR187559_1.fastq.gz
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/DRR187/DRR187559/DRR187559_2.fastq.gz -O data/DRR187559_2.fastq.gz

# Genoma de referencia
wget "https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/013/425/GCF_000013425.1_ASM1342v1/GCF_000013425.1_ASM1342v1_genomic.fna.gz" \
     -O data/GCF_000013425.1_genomic.fna.gz
gunzip data/GCF_000013425.1_genomic.fna.gz
```

</details>

---

### 🔵 Caso B — *Klebsiella pneumoniae* (aislados hospitalarios, Colombia)

**Contexto clínico:**

> *"Klebsiella pneumoniae is one of the most important nosocomial pathogens worldwide. In Colombia, K. pneumoniae has been identified as the second most frequent microbial etiologic agent of healthcare-associated infections."*
> — [Medina et al. 2025](https://www.nature.com/articles/s44259-025-00127-x)

|                     |                         |
|:--------------------|:------------------------|
| **Organismo**       | *Klebsiella pneumoniae* |
| **Tamaño esperado** | ~5.5 Mb                 |
| **Contenido GC**    | ~57%                    |
| **Secuenciación**   | Illumina paired-end     |
| **Accesión**        | ERR14828471             |

<details>
<summary>📥 Cargar datos en Galaxy (haga clic para expandir)</summary>

En Galaxy, haga clic en `Upload` → `Paste/Fetch data` y pegue los siguientes enlaces:

```
https://zenodo.org/records/17156735/files/ERR14828471_1.fastq.gz
https://zenodo.org/records/17156735/files/ERR14828471_2.fastq.gz
https://zenodo.org/records/17156735/files/GCF_000240185.1_ASM24018v2_genomic.fna
```

Haga clic en `Start` y espere a que los archivos estén en **verde** antes de continuar.

</details>

<details>
<summary>💻 Descargar datos desde terminal o Colab (haga clic para expandir)</summary>

```bash
mkdir -p GenomeAssembly/caso_B/data && cd GenomeAssembly/caso_B

# Lecturas
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR148/071/ERR14828471/ERR14828471_1.fastq.gz -O data/ERR14828471_1.fastq.gz
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR148/071/ERR14828471/ERR14828471_2.fastq.gz -O data/ERR14828471_2.fastq.gz

# Genoma de referencia
wget "https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/240/185/GCF_000240185.1_ASM24018v2/GCF_000240185.1_ASM24018v2_genomic.fna.gz" \
     -O data/GCF_000240185.1_genomic.fna.gz
gunzip data/GCF_000240185.1_genomic.fna.gz
```

</details>

---

### 🟢 Caso C — *Streptomyces venezuelae* (actinobacteria de importancia biotecnológica)

**Contexto biotecnológico:**

*Streptomyces venezuelae* es una actinobacteria Gram positiva del suelo, conocida por ser productora natural del antibiótico **cloranfenicol** y de numerosos compuestos bioactivos. Es uno de los organismos modelo para el estudio de biosíntesis de productos naturales y sporulación en bacterias filamentosas.
> — [Pullan et al. 2011](https://link.springer.com/article/10.1186/1471-2164-12-175)

|                     |                                      |
|:--------------------|:-------------------------------------|
| **Organismo**       | *Streptomyces venezuelae* ATCC 10712 |
| **Tamaño esperado** | ~8.2 Mb                              |
| **Contenido GC**    | ~72%                                 |
| **Secuenciación**   | Illumina paired-end                  |
| **Accesión**        | SRR2589046                           |

> [!NOTE]
> Este caso es el más complejo por el tamaño del genoma y su alto contenido GC (~72%). En el reporte de FastQC/Falco, el gráfico "Per Sequence GC Content" mostrará una distribución desplazada hacia la derecha — esto es **completamente normal** para *Streptomyces* y no indica contaminación.

<details>
<summary>📥 Cargar datos en Galaxy (haga clic para expandir)</summary>

En Galaxy, haga clic en `Upload` → `Paste/Fetch data` y pegue los siguientes enlaces:

```
https://ftp.sra.ebi.ac.uk/vol1/fastq/SRR258/006/SRR2589046/SRR2589046_1.fastq.gz
https://ftp.sra.ebi.ac.uk/vol1/fastq/SRR258/006/SRR2589046/SRR2589046_2.fastq.gz
https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/240/185/GCF_000240185.1_ASM24018v2/GCF_000240185.1_ASM24018v2_genomic.fna.gz
```

Haga clic en `Start` y espere a que los archivos estén en **verde** antes de continuar.

</details>

<details>
<summary>💻 Descargar datos desde terminal o Colab (haga clic para expandir)</summary>

```bash
mkdir -p GenomeAssembly/caso_C/data && cd GenomeAssembly/caso_C

# Lecturas
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR258/006/SRR2589046/SRR2589046_1.fastq.gz -O data/SRR2589046_1.fastq.gz
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR258/006/SRR2589046/SRR2589046_2.fastq.gz -O data/SRR2589046_2.fastq.gz

# Genoma de referencia
wget "https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/253/235/GCF_000253235.1_ASM25323v1/GCF_000253235.1_ASM25323v1_genomic.fna.gz" \
     -O data/GCF_000253235.1_genomic.fna.gz
gunzip data/GCF_000253235.1_genomic.fna.gz
```

</details>

---

### 🟣 Caso D — *Pseudomonas abieticivorans* (bacteria degradadora de diterpenos del suelo)

**Contexto ambiental y biotecnológico:**

> *"Pseudomonas abieticivorans* is a soil bacterium capable of degrading abietic acid and other diterpenoid resin acids derived from conifer trees — compounds that are major components of forest litter and paper-mill effluents. Its genomic repertoire reveals an extensive capacity for aromatic compound catabolism."*
> — [Ristinmaa, A.S. et al. 2023, *Nature Communications*](https://doi.org/10.1038/s41467-023-43867-y)

|                         |                                            |
|:------------------------|:-------------------------------------------|
| **Organismo**           | *Pseudomonas abieticivorans*               |
| **Tamaño del genoma**   | ~6.7 Mb (cromosoma único, genoma completo) |
| **Contenido GC**        | ~63%                                       |
| **Secuenciación**       | Illumina paired-end                        |
| **Accesión lecturas**   | SRR24684300                                |
| **Accesión referencia** | GCF_023509015.1                            |
| **Cobertura estimada**  | ~60×                                       |

> [!NOTE]
> A diferencia de los casos A y B (patógenos clínicos) y del Caso C (*Streptomyces*), este caso tiene un enfoque **ambiental y de bioprospección**: el análisis se orienta a identificar genes de degradación de compuestos aromáticos y diterpenos. Es un buen ejemplo de genómica aplicada a la biotecnología blanca y la biorremediación.

<details>
<summary>📥 Cargar datos en Galaxy (haga clic para expandir)</summary>

En Galaxy, haga clic en `Upload` → `Paste/Fetch data` y pegue los siguientes enlaces:

```
ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR246/000/SRR24684300/SRR24684300_1.fastq.gz
ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR246/000/SRR24684300/SRR24684300_2.fastq.gz
https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/023/509/015/GCF_023509015.1_ASM2350901v1/GCF_023509015.1_ASM2350901v1_genomic.fna.gz
```

Haga clic en `Start` y espere a que los archivos estén en **verde** antes de continuar.

</details>

<details>
<summary>💻 Descargar datos desde terminal o Colab (haga clic para expandir)</summary>

```bash
mkdir -p GenomeAssembly/caso_D/data && cd GenomeAssembly/caso_D

# Lecturas
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR246/000/SRR24684300/SRR24684300_1.fastq.gz -O data/SRR24684300_1.fastq.gz
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR246/000/SRR24684300/SRR24684300_2.fastq.gz -O data/SRR24684300_2.fastq.gz

# Genoma de referencia
wget "https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/023/509/015/GCF_023509015.1_ASM2350901v1/GCF_023509015.1_ASM2350901v1_genomic.fna.gz" \
     -O data/GCF_023509015.1_genomic.fna.gz
gunzip data/GCF_023509015.1_genomic.fna.gz
```

</details>

---

## ❓ Preguntas de contexto (antes de empezar)

Responda estas preguntas con base en el [README del Módulo 5](../README.md) antes de iniciar el procedimiento:

1. ¿Cuál es la diferencia entre una lectura (*read*) y un contig?
2. ¿Qué representa la cobertura y por qué es importante para el ensamblaje?
3. ¿Por qué las lecturas paired-end ayudan a resolver regiones repetitivas?
4. ¿Qué pasaría si ensambla con cobertura muy baja (<10×)?
5. Para el caso asignado: ¿cuántas lecturas de 150 pb se necesitarían para alcanzar una cobertura de 30×? Muestre el cálculo.
6. ¿Por qué en el Caso C el gráfico de %GC se desplaza a ~72% sin que eso indique contaminación?
7. ¿Qué diferencia hay entre usar la referencia *durante* el ensamblaje y usarla *solo para evaluar* el resultado?

---

## 📚 Bibliografía

Hikichi, M., et al., 2019. *Microbiology Resource Announcements* 8. [10.1128/mra.01212-19](https://doi.org/10.1128/mra.01212-19)

Medina et al., 2025. *npj Antimicrobials and Resistance*. [10.1038/s44259-025-00127-x](https://doi.org/10.1038/s44259-025-00127-x)

Pullan et al., 2011. *BMC Genomics*. [10.1186/1471-2164-12-175](https://doi.org/10.1186/1471-2164-12-175)

Prjibelski, A., et al., 2020. *Current Protocols in Bioinformatics* 70:e102. [10.1002/cpbi.102](https://doi.org/10.1002/cpbi.102)

Ristinmaa, A.S. et al., 2023. *Nature Communications* 14. [10.1038/s41467-023-43867-y](https://doi.org/10.1038/s41467-023-43867-y)

Zerbino, D.R. & Birney, E., 2008. *Genome Research* 18:821–829.

Chen, S., et al., 2018. *Bioinformatics* 34:i884–i890. [10.1093/bioinformatics/bty560](https://doi.org/10.1093/bioinformatics/bty560)

Gurevich, A., et al., 2013. *Bioinformatics* 29:1072–1075. [10.1093/bioinformatics/btt086](https://doi.org/10.1093/bioinformatics/btt086)
