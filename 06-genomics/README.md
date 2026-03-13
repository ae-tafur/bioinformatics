# Módulo 6: Genómica — Del Genoma Ensamblado al Conocimiento Biológico

## Introducción

En el Módulo 5 aprendió cómo se generan las lecturas de secuenciación, cómo se evalúa su calidad y cómo se reconstruye un genoma mediante ensamblaje. El resultado de ese proceso es un archivo FASTA con contigs o scaffolds: una secuencia larga, pero todavía "muda" — no sabemos dónde están los genes, qué funciones cumplen ni qué diferencias tiene respecto a otros organismos.

Este módulo se enfoca en darle **significado biológico** a un genoma ensamblado. Trabajaremos con tres grandes bloques:

1. **Anotación genómica** — identificar genes, asignar funciones y generar archivos interpretables (GFF, GBK).
2. **Variantes genómicas** — detectar SNPs e indels comparando contra una referencia.
3. **Genómica comparada** — comparar genomas completos: ANI, pan-genoma, sintenia e islas genómicas.

> [!NOTE]
> En genómica, no basta con obtener una secuencia larga; también hay que demostrar que es suficientemente completa, consistente y biológicamente interpretable. Este módulo le enseña a pasar de la secuencia al conocimiento.

---

## Prerrequisitos y conexión con módulos previos

### Del Módulo 5

Ya sabe:
- cómo funcionan las **tecnologías de secuenciación** y qué tipo de datos producen;
- cómo evaluar la **calidad de las lecturas** (Phred, FASTQ);
- la diferencia entre **mapping** y **ensamblaje *de novo***;
- cómo evaluar un ensamblaje (**N50**, **BUSCO**, contaminación).

> [!NOTE]
> Si necesita repasar → [README del Módulo 5](../05_sequencing/README.md).

### Del Módulo 3

Ya conoce:
- cómo funciona **BLAST** y cómo interpretar identidad, E-value y coverage;
- la diferencia entre alineamiento **global** y **local**.

> [!NOTE]
> Si necesita repasar → [README del Módulo 3](../03-sequence_analysis/README.md).

### Del Módulo 4

Ya entiende:
- por qué un **BLAST del 16S no basta** para identificar especie;
- el concepto de **ANI** como alternativa genómica.

> [!NOTE]
> Si necesita repasar → [README del Módulo 4](../04-phylogenetics/README.md).

En este módulo, todo converge: tomará un genoma ensamblado (Módulo 5), le encontrará genes usando conceptos de alineamiento y búsqueda por similitud (Módulo 3), y podrá compararlo con otros genomas usando las ideas de distancia evolutiva y marcadores (Módulo 4).

---

## 1. Anotación del genoma

Una vez que tiene un ensamblaje en formato FASTA, el siguiente paso es transformar esa secuencia "cruda" en un **mapa biológico interpretable**: ¿dónde están los genes? ¿Qué hacen?

### 1.1 ¿Qué es un gen?

Desde el punto de vista biológico, un gen es una región del ADN que produce un producto funcional (ARN o proteína). Desde el punto de vista computacional, la anotación busca reconocer **patrones de secuencia** que indiquen dónde comienza y termina esa unidad funcional.

### 1.2 Anotación estructural vs. funcional

#### Anotación estructural

Busca identificar **qué elementos hay y dónde están**:

- genes codificantes (CDS);
- tRNA y rRNA;
- regiones reguladoras (promotores, terminadores);
- exones e intrones en eucariotas.

#### Anotación funcional

Busca inferir **qué hace** cada gen o producto génico, comparando la secuencia con bases de datos y modelos conocidos.

### 1.3 ¿Cómo se reconoce un gen?

Los algoritmos de predicción buscan señales estadísticas y biológicas:

```text
Gen procariota típico:

  Promotor   RBS  Codón   ──── Marco de lectura abierto (ORF) ────   Codón
    ─┤        ┤   inicio                                             parada
                   ATG ───────────────────────────────────────────── TAA/TAG/TGA
                    ↑                                                    ↑
                La anotación busca ORFs largos con sesgo de codones
                  y señales reguladoras upstream
```

Señales que buscan los programas:

- **codones de inicio y parada** (ATG → TAA/TAG/TGA);
- **marcos de lectura abiertos** (ORFs) suficientemente largos;
- **sesgo de uso de codones** (cada organismo prefiere ciertos codones sinónimos);
- **señales promotoras** y sitios de unión al ribosoma (RBS);
- **sitios de splicing** en eucariotas;
- **similitud con genes ya conocidos** (BLAST, modelos de Pfam).

### 1.4 Procariotas vs. eucariotas

| Característica           | Procariotas                    | Eucariotas                                      |
|:-------------------------|:-------------------------------|:------------------------------------------------|
| Organización génica      | Compacta, genes continuos      | Dispersa, genes interrumpidos                   |
| Intrones                 | Generalmente ausentes          | Frecuentes                                      |
| Densidad génica          | Alta (~85% codificante)        | Baja (~1.5% en humanos)                         |
| Predicción computacional | Relativamente sencilla         | Mucho más compleja                              |
| Evidencia adicional útil | Homología, motivos conservados | RNA-Seq, proteínas homólogas, modelos complejos |

```text
Gen procariota:                    Gen eucariota:
                                           Exón  Exón  Exón  Exón
                                            ↑      ↑     ↑     ↑
ATG═══════════════TGA                    ATG══╗  ╔══╗  ╔══╗  ╔═══TGA
    ↑ ORF continuo ↑                          └──┘  └──┘  └──┘
                                                ↑     ↑     ↑
                                             Intrón Intrón Intrón
                                       
                                      El mRNA maduro solo contiene exones
```

#### Herramientas para procariotas

| Herramienta  | Función                                             | Nota                                 |
|:-------------|:----------------------------------------------------|:-------------------------------------|
| **Prodigal** | Predicción de genes (CDS)                           | Rápido, muy preciso para procariotas |
| **Prokka**   | Pipeline completo: predicción + anotación funcional | Estándar en genómica bacteriana      |
| **Bakta**    | Alternativa moderna a Prokka                        | Bases de datos más actualizadas      |

#### Herramientas para eucariotas

| Herramienta  | Función                                                | Nota                                        |
|:-------------|:-------------------------------------------------------|:--------------------------------------------|
| **Augustus** | Predicción *ab initio* con modelos entrenados          | Necesita datos de entrenamiento por especie |
| **MAKER**    | Pipeline completo con evidencia de RNA-Seq y proteínas | Más complejo pero más preciso               |

### 1.5 Anotación funcional

Una vez predichos los genes, se infiere su función:

```text
Gen predicho (secuencia de aa)
         │
         ▼
  ┌─────────────┐     ┌───────────────┐     ┌─────────────────┐
  │  BLAST vs   │     │  Búsqueda de  │     │  Asignación de  │
  │  UniProt/nr │     │  dominios     │     │  categorías     │
  │             │     │  Pfam/InterPro│     │  GO, KEGG, COG  │
  └──────┬──────┘     └──────┬────────┘     └────────┬────────┘
         │                   │                       │
         ▼                   ▼                       ▼
   "Proteasa"        "Dominio serina-     "Categoría: Metabolismo"
                        proteasa"            
```

Estrategias comunes:

- **Búsqueda de homología** con BLAST contra bases de datos como NCBI nr o UniProt;
- **Detección de dominios** con Pfam, InterProScan o CDD;
- **Asignación funcional** con GO (*Gene Ontology*), KEGG (rutas metabólicas) o COG.

> [!WARNING]
> La anotación funcional suele ser una **predicción** basada en semejanza, no una demostración experimental directa. Un gen con 40% de identidad con una proteasa *podría* ser una proteasa, pero también podría haber divergido funcionalmente.

### 1.6 Formatos de salida: GFF y GBK

Los formatos **GFF** y **GBK** (GenBank) se utilizan para representar las anotaciones sobre una secuencia genómica. En resumen:

- **FASTA** → "¿Cuál es la secuencia?"
- **GFF** → "¿Dónde están las características?" (coordenadas, tipo, hebra, atributos)
- **GBK** → Secuencia + anotación integradas en un solo archivo

> [!TIP]
> Si necesita repasar la estructura y campos de estos formatos → [Módulo 1 → Formatos de archivo](../01-introduction/README.md).

---

## 2. Variantes genómicas: SNPs e indels

Además de anotar genomas, muchas veces interesa comparar una muestra contra una referencia para identificar cambios puntuales.

### 2.1 ¿Qué es una variante?

Una **variante genómica** es una diferencia en la secuencia respecto a otra secuencia de referencia:

```text
Referencia:  A T G C C G T A
Muestra:     A T G T C G T A
                 ↑
                SNP (C → T)

Referencia:  A T G C C G T A
Muestra:     A T G C - G T A
                   ↑
               Deleción (C eliminada)

Referencia:  A T G C C G T A
Muestra:     A T G C A C G T A
                   ↑
              Inserción (A agregada)
```

| Tipo                                       | Definición                 |
|:-------------------------------------------|:---------------------------|
| **SNP** (*Single Nucleotide Polymorphism*) | Cambio de una sola base    |
| **Indel**                                  | Inserción o deleción corta |

### 2.2 ¿Cómo se detectan?

```text
Flujo de detección de variantes:

      Lecturas (FASTQ)
             │
             ▼
   Alinear contra referencia     ← BWA, Bowtie2, Minimap2
             │
             ▼
  Archivo de alineamiento (BAM)
             │
             ▼
     Llamada de variantes         ← bcftools, GATK, Snippy
             │
             ▼
  Archivo de variantes (VCF)
             │
             ▼
    Filtrado y anotación           ← SnpEff, SnpSift
```

#### Formato VCF (*Variant Call Format*)

Es el formato estándar para reportar variantes:

```text
#CHROM  POS   ID  REF  ALT  QUAL  FILTER  INFO
contig1 1045  .   C    T    200   PASS    DP=45;MQ=60
contig1 2300  .   AT   A    150   PASS    DP=38;MQ=55
```

| Campo | Significado                            |
|:------|:---------------------------------------|
| CHROM | Cromosoma o contig                     |
| POS   | Posición de la variante                |
| REF   | Base(s) en la referencia               |
| ALT   | Base(s) en la muestra                  |
| QUAL  | Calidad de la llamada                  |
| DP    | Profundidad de lectura en esa posición |

### 2.3 Herramientas para llamada de variantes

| Herramienta   | Contexto                  | Nota                                         |
|:--------------|:--------------------------|:---------------------------------------------|
| **Snippy**    | Genómica bacteriana       | Pipeline completo: mapping + variant calling |
| **bcftools**  | General                   | Flexible, parte de samtools                  |
| **GATK**      | Genómica humana/eucariota | Muy robusto, estándar en clínica             |
| **FreeBayes** | General                   | Bayesiano, bueno para haplotipos             |

### 2.4 ¿Por qué son importantes las variantes?

| Aplicación                 | Ejemplo                                               |
|:---------------------------|:------------------------------------------------------|
| Diferenciar cepas cercanas | Rastreo de brotes hospitalarios por SNPs              |
| Resistencia antimicrobiana | Mutación en *gyrA* → resistencia a fluoroquinolonas   |
| Evolución y filogenia fina | Reconstruir transmisión de SARS-CoV-2 entre pacientes |
| Virulencia                 | Identificar mutaciones en factores de virulencia      |

### 2.5 Precauciones al interpretar variantes

No toda diferencia observada es biológicamente real. Fuentes de falsos positivos:

- calidad baja de lectura en esa posición;
- cobertura insuficiente (<10×);
- alineamientos ambiguos (regiones repetitivas);
- sesgos introducidos por la referencia elegida.

> [!TIP]
> Siempre filtre variantes por calidad (QUAL), profundidad (DP) y calidad de mapeo (MQ). Una variante con 3 lecturas de soporte en una zona de cobertura 5× no es confiable.

---

## 3. Genómica comparada

La genómica comparada busca entender las diferencias y similitudes entre genomas completos. Va más allá de comparar un solo gen: aquí se comparan **miles de genes simultáneamente**.

### 3.1 ANI (*Average Nucleotide Identity*)

Ya lo mencionamos en el [Módulo 4](../04-phylogenetics/README.md) como alternativa al 16S para delimitar especies. El ANI calcula el porcentaje promedio de identidad de nucleótidos entre regiones ortólogas de dos genomas:

| ANI     | Interpretación                    |
|:--------|:----------------------------------|
| ≥95–96% | Misma especie                     |
| 90–95%  | Mismo género, diferentes especies |
| <90%    | Géneros diferentes                |

Herramientas: **fastANI**, **pyani**, **JSpeciesWS**, **EzBioCloud ANI Calculator**.

### 3.2 Pan-genoma

Cuando se comparan múltiples genomas de una misma especie, se observa que no todos los genes están presentes en todos los aislados. El **pan-genoma** describe el repertorio genético total de una especie:

```text
Pan-genoma de una especie bacteriana:

┌─────────────────────────────────────────────────────────┐
│                                                         │
│    ┌───────────────────┐                                │
│    │   CORE GENOME     │  ← Genes presentes en TODOS    │
│    │   (esenciales)    │    los aislados                │
│    └───────────────────┘                                │
│                                                         │
│    ┌──────────┐ ┌──────────┐ ┌──────────┐               │
│    │ Accesorio│ │ Accesorio│ │ Accesorio│               │
│    │ Cepa A   │ │ Cepa B   │ │ Cepa C   │  ← Genes      │
│    │          │ │          │ │          │    variables  │
│    └──────────┘ └──────────┘ └──────────┘               │
│                                                         │
│    ┌─────┐  ← Genes únicos (singletons):                │
│    │Único│    presentes en una sola cepa                │
│    └─────┘                                              │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

| Componente           | Definición                              | Ejemplo biológico                     |
|:---------------------|:----------------------------------------|:--------------------------------------|
| **Core genome**      | Genes presentes en ≥95% de los aislados | Genes housekeeping, ribosomales       |
| **Accessory genome** | Genes presentes en algunos aislados     | Islas de patogenicidad, plásmidos     |
| **Singletons**       | Genes presentes en un solo aislado      | Profagos, elementos móviles recientes |

Herramientas: **Roary**, **Panaroo**, **PIRATE**.

### 3.3 Detección de genes de resistencia y virulencia

Una aplicación directa de la genómica es buscar genes de interés clínico en genomas ensamblados:

| Tipo de búsqueda                     | Base de datos                  | Herramienta                  |
|:-------------------------------------|:-------------------------------|:-----------------------------|
| **Resistencia antimicrobiana (AMR)** | CARD, ResFinder, AMRFinderPlus | ABRicate, AMRFinderPlus, RGI |
| **Factores de virulencia**           | VFDB                           | ABRicate, VFanalyzer         |
| **Plásmidos**                        | PlasmidFinder                  | MOB-suite, PlasmidFinder     |
| **Tipificación (MLST)**              | PubMLST                        | mlst (Seemann), MLST 2.0     |

> [!NOTE]
> Estas búsquedas se hacen contra bases de datos curadas y generalmente usan BLAST o comparaciones de k-mers internamente. Los resultados dependen de la calidad de la base de datos y del ensamblaje.

### 3.4 Sintenia y reordenamientos

La **sintenia** se refiere a la conservación del orden y orientación de los genes entre genomas:

```text
Genoma A:  ═══ gen1 → gen2 → gen3 → gen4 → gen5 ═══

Genoma B:  ═══ gen1 → gen2 → gen3 → gen4 → gen5 ═══   (Colineal: sintenia conservada)

Genoma C:  ═══ gen1 → gen2 → gen5 ← gen4 ← gen3 ═══   (Inversión detectada)

Genoma D:  ═══ gen1 → gen2 → genX → gen3 → gen4 ═══   (Inserción de genX: isla genómica?)
```

Los reordenamientos (inversiones, translocaciones, inserciones de islas genómicas) se detectan mediante **dot plots** genómicos (ver [Módulo 3, sección 2.2](../03-sequence_analysis/README.md)) o herramientas como **Mauve**, **MUMmer** o **D-Genies**.

---

## 4. Flujo de trabajo genómico completo

Integrando los módulos 5 y 6, el flujo de trabajo genómico típico es:

```text
     Lecturas crudas (FASTQ)         ← Módulo 5
                │
                ▼
         QC + Trimming               ← Módulo 5
                │
                ▼
Ensamblaje (de novo o mapping)       ← Módulo 5
                │
                ▼
Evaluación (N50, BUSCO, pureza)      ← Módulo 5
                │
                ▼
═══════════════════════════════════════════
                │
                ▼
   Anotación (Prokka/Bakta)          ← Módulo 6 (este módulo)
                │
                ▼
Detección de variantes (Snippy)      ← Módulo 6
                │
                ▼
Genómica comparada (ANI, pan-genoma) ← Módulo 6
                │
                ▼
  Interpretación biológica
```

---

## 5. Cierre conceptual

La genómica moderna no termina con el ensamblaje. El verdadero valor de un genoma está en lo que podemos extraer de él:

- la **anotación** transforma una secuencia en un catálogo de genes y funciones;
- la **detección de variantes** permite comparar genomas a resolución de una sola base;
- la **genómica comparada** revela la diversidad, adaptación y evolución a escala de genoma completo.

En este módulo ha aprendido:

- cómo los programas **predicen genes** en procariotas y eucariotas, y por qué es más difícil en eucariotas;
- que la anotación funcional es una **predicción basada en similitud**, no una certeza experimental;
- cómo se **detectan variantes** (SNPs/indels) y cómo interpretarlas con cautela;
- qué es el **pan-genoma** y cómo compara el repertorio genético de múltiples aislados;
- cómo buscar **genes de resistencia, virulencia y plásmidos** en un genoma ensamblado.

> [!IMPORTANT]
> Un genoma anotado no es un producto final; es una hipótesis que debe validarse experimentalmente y actualizarse a medida que las bases de datos mejoran.

---

## Prácticas del módulo

| Práctica                                               | Descripción                                                          |
|:-------------------------------------------------------|:---------------------------------------------------------------------|
| [Anotación genómica](exercises/01_genome_annotation.md) | Predicción de genes y asignación de funciones en genomas bacterianos |
