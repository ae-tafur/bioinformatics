# Módulo 5: Secuenciación de ADN y ARN — De la Molécula al Genoma Ensamblado

## Introducción

La capacidad de leer el código genético ha revolucionado la biología moderna. Desde los primeros esfuerzos laboriosos hasta las tecnologías de alto rendimiento actuales, la secuenciación de ácidos nucleicos nos permite descifrar genomas completos, entender la diversidad microbiana, diagnosticar enfermedades genéticas y rastrear brotes epidemiológicos en tiempo real.

Este módulo cubre el camino completo desde la molécula de ADN hasta un genoma ensamblado y evaluado. Para entender *cómo* funcionan las tecnologías de secuenciación, primero repasaremos las bases moleculares (estructura del nucleótido, replicación del ADN). Luego exploraremos las plataformas de secuenciación, la calidad de los datos que producen y, finalmente, cómo se reconstruye un genoma a partir de millones de fragmentos.

Aunque muchas veces se habla principalmente de secuenciación de ADN, varios de estos principios también aplican al ARN. En RNA-seq, por ejemplo, el material biológico original es ARN, pero frecuentemente se convierte a ADN complementario (cDNA) antes de secuenciarse. En tecnologías como Oxford Nanopore, incluso es posible secuenciar ARN de forma directa.

Trabajaremos con siete grandes bloques:

1. **Bases moleculares** — la química del nucleótido y la replicación, para entender por qué Sanger e Illumina funcionan como funcionan.
2. **Tecnologías de secuenciación** — de Sanger a Nanopore: principios, perfiles de error y cuándo usar cada una.
3. **Datos de secuenciación** — FASTQ, calidad Phred, cobertura, profundidad y limpieza de lecturas.
4. **Estrategias de reconstrucción** — mapping vs ensamblaje *de novo*.
5. **Algoritmos de ensamblaje** — OLC, grafos de De Bruijn y k-mers.
6. **Evaluación del ensamblaje** — N50, L50, BUSCO, contaminación y métricas complementarias.
7. **Herramientas** — el ecosistema de software para cada paso.

> [!NOTE]
> Secuenciar no es el final del trabajo experimental; es el inicio del análisis bioinformático. Un buen bioinformático no es quien solo sabe correr un programa, sino quien entiende qué significan sus resultados y por qué el análisis puede fallar.

---

## Prerrequisitos y conexión con módulos previos

### Del Módulo 1

Ya conoce:
- los formatos **FASTA** y **FASTQ**;
- las bases de datos públicas (NCBI, ENA);
- el concepto de archivos de anotación (GFF, GenBank).

> [!NOTE]
> Si necesita repasar → [README del Módulo 1](../01-introduction/README.md).

### Del Módulo 3

Ya sabe:
- qué es un **alineamiento** y la diferencia entre global y local;
- cómo funciona **BLAST**;
- los conceptos de identidad y scoring.

> [!NOTE]
> Si necesita repasar → [README del Módulo 3](../03-sequence_analysis/README.md).

### Del Módulo 4

Ya entiende:
- la lógica de un **árbol filogenético**;
- por qué los **genes marcadores** (16S, ITS) son útiles y sus limitaciones;
- que un BLAST no basta para identificar especie.

> [!NOTE]
> Si necesita repasar → [README del Módulo 4](../04-phylogenetics/README.md).

En este módulo, todo ese conocimiento previo se conecta: las secuencias que usted buscaba en bases de datos fueron generadas por las tecnologías que aquí estudiará, y los genomas que ensamblará serán la materia prima para la anotación y el análisis genómico del Módulo 6.

---

## 1. Bases moleculares de la secuenciación

Antes de entender cómo funciona un secuenciador, necesita recordar qué es lo que está leyendo. Todas las tecnologías de secuenciación explotan propiedades químicas del ADN, así que un breve repaso molecular le ahorrará mucha confusión.

### 1.1 Estructura del nucleótido

Un **nucleótido** — la unidad básica del ADN y el ARN — tiene tres componentes:

```text
                         Base nitrogenada
                               │
                         ┌─────┴────┐
                         │  A/T/G/C │
                         └─────┬────┘
                               │
                               1'
    5'─ Fosfato ── Azúcar (desoxirribosa) ─┬ 
         (PO₄)                           3'┴OH ← Este grupo es CLAVE
```

| Componente                                       | Función                                                                            |
|:-------------------------------------------------|:-----------------------------------------------------------------------------------|
| **Grupo fosfato** (5')                           | Conecta un nucleótido con el siguiente → forma el esqueleto                        |
| **Azúcar** (desoxirribosa en ADN, ribosa en ARN) | Soporte estructural; la posición **3'-OH** es donde se une el siguiente nucleótido |
| **Base nitrogenada**                             | Porta la información genética (A, T, G, C en ADN; A, U, G, C en ARN)               |

> [!IMPORTANT]
> El grupo **3'-OH** del azúcar es esencial: es el punto donde la ADN polimerasa añade el siguiente nucleótido durante la replicación. **Si este grupo se elimina o se bloquea, la cadena no puede seguir creciendo.** Esto es exactamente lo que aprovecha la secuenciación Sanger.

### 1.2 Polaridad del ADN: 5' → 3'

Las cadenas de ADN tienen **dirección**. La síntesis siempre ocurre de **5' a 3'** porque el nuevo nucleótido se une al 3'-OH del nucleótido anterior:

```text
Dirección de síntesis →

5'──P──Azúcar──P──Azúcar──P──Azúcar──3'OH
       │          │          │
       A          T          G
       │          │          │
       T          A          C
       │          │          │
 3'OH──Azúcar──P──Azúcar──P──Azúcar──P──5'

                  ← Hebra complementaria (antiparalela)
```

Las dos hebras son **antiparalelas**: una va 5'→3' y la otra va 3'→5'. Esto es importante para entender cómo se leen las lecturas *paired-end*.

### 1.3 Replicación del ADN (repaso simplificado)

La replicación es el proceso mediante el cual la célula copia su ADN antes de dividirse. Los actores principales son:

```text
                    Horquilla de replicación
                            │
    5'════════════════════╗ │ ╔═══════════════════3'
    3'════════════════════╝ │ ╚═══════════════════5'
                            │
                        Helicasa
                    (abre la doble hebra)

    Hebra líder (continua):
    5'────────────→ 3'    La polimerasa copia sin interrupciones en dirección 5'→3'

    Hebra rezagada (discontinua):
    3'←────  ←────  ←──── 5'   Fragmentos de Okazaki, sintetizados "hacia atrás" y luego unidos
```

**¿Por qué importa esto para la secuenciación?**

- **Sanger** usa la ADN polimerasa in vitro para sintetizar una copia de la hebra molde. Los ddNTPs la detienen en posiciones aleatorias.
- **Illumina** usa amplificación **en puente** (*bridge amplification*): las moléculas de ADN, ancladas a una superficie sólida, se replican formando *clusters* clonales. Cada cluster contiene miles de copias idénticas de un fragmento, lo que permite detectar la señal fluorescente.
- **PacBio** observa una **sola polimerasa** incorporando nucleótidos fluorescentes en tiempo real.
- **Nanopore** no usa polimerasa para la lectura: la molécula de ADN (o ARN) pasa físicamente por un poro.

### 1.4 El truco de Sanger: didesoxinucleótidos (ddNTPs)

Un **didesoxi-nucleótido** (ddNTP) es un nucleótido modificado que carece del grupo **3'-OH**:

```text
Nucleótido normal (dNTP):          Didesoxinucleótido (ddNTP):

    Base                               Base
     │                                  │
  Azúcar ─ 3'─OH  ← Puede             Azúcar ─ 3'─H   ← NO puede
     │          seguir la cadena        │            seguir la cadena
  Fosfato                             Fosfato
```

Cuando la polimerasa incorpora un ddNTP en lugar de un dNTP normal, la cadena **se termina** en esa posición porque no hay 3'-OH donde añadir el siguiente nucleótido. Como cada ddNTP (ddATP, ddTTP, ddGTP, ddCTP) está marcado con un fluorocromo diferente, se puede leer qué base terminó la cadena en cada posición.

> [!TIP]
> Resumen en una frase: Sanger funciona porque **la ausencia del 3'-OH detiene la replicación** y cada parada se marca con un color diferente.

---

## 2. Historia y tecnologías de secuenciación

### 2.1 Línea de tiempo

```text
 1977         1987         1990        2005       2006        2010      2011       2014
  │            │            │            │          │           │         │          │
 Sanger    ABI 370A    Proyecto     454/Roche   Solexa/        Ion       PacBio    Oxford
 (ddNTPs)  (primer      Genoma      (piroseq)  Illumina      Torrent     (SMRT)    Nanopore
          automático)   Humano                  (SBS)          (pH)                (MinION)
```

La secuenciación suele dividirse en tres generaciones:

| Generación                | Tecnología líder | Longitud de lectura | Precisión       | Aplicación principal                          |
|:--------------------------|:-----------------|:--------------------|:----------------|:----------------------------------------------|
| **1ra (Sanger)**          | ABI 3730xl       | 800–1,000 pb        | 99.99%          | Validación, genes individuales                |
| **2da (NGS)**             | Illumina         | 50–300 pb           | 99.9%           | Genomas, RNA-seq, metagenómica                |
| **3ra (lecturas largas)** | PacBio / ONT     | 10 kb – 2 Mb        | Variable (Q20+) | Ensamblaje *de novo*, variantes estructurales |

### 2.2 Primera generación: Sanger

- **Principio:** usa ddNTPs marcados con fluorescencia que terminan la cadena en posiciones aleatorias. Los fragmentos se separan por electroforesis capilar y se leen en orden de tamaño.
- **Lecturas:** ~800–1,000 pb.
- **Calidad:** muy alta (Q > 40). Sigue siendo referencia para validación.
- **Aplicaciones:** secuenciación de genes individuales, confirmación de clones y plásmidos.

### 2.3 Segunda generación (NGS)

#### 454 (pirosecuenciación) — *histórica*

- **Principio:** detecta la liberación de pirofosfato cuando se incorpora un nucleótido.
- **Lecturas:** ~400–700 pb.
- **Limitaciones:** alta tasa de error en homopolímeros (`AAAAAA`). Discontinuada.

#### Illumina (secuenciación por síntesis)

- **Principio:** amplificación clonal en puente (*bridge amplification*) sobre una celda de flujo + nucleótidos con terminadores reversibles fluorescentes. En cada ciclo se fotografía la base incorporada.
- **Lecturas:** cortas, típicamente *paired-end* (2×150 pb).
- **Calidad:** muy alta, aunque disminuye hacia el final de la lectura. Error predominante: sustituciones.
- **Aplicaciones:** genomas completos, RNA-seq, metagenómica, vigilancia genómica.

### 2.4 Tercera generación (lecturas largas)

#### Pacific Biosciences (PacBio SMRT)

- **Principio:** una polimerasa inmovilizada incorpora nucleótidos fluorescentes en tiempo real dentro de un pozo nanoscópico (ZMW).
- **Lecturas:** 10–20 kb o más. En modo HiFi/CCS se logran lecturas de alta precisión (Q30+).
- **Aplicaciones:** ensamblaje *de novo*, variantes estructurales, transcritos completos.

#### Oxford Nanopore Technologies (ONT)

- **Principio:** una molécula de ADN o ARN atraviesa un nanoporo; cada base altera la corriente eléctrica de forma característica.
- **Lecturas:** ultra largas (hasta megabases), portátil, tiempo real.
- **Aplicaciones:** secuenciación rápida en campo, metagenómica en tiempo real, detección de metilación.

### 2.5 Single-end vs. Paired-end

Esta es una distinción fundamental en la preparación de librerías, especialmente en Illumina:

```text
═══════════════════════════════════════  Fragmento de ADN (~300-500 pb)

SINGLE-END:
→→→→→→→→→→                               Solo se lee un extremo
  Read 1 (150 pb)

PAIRED-END:
→→→→→→→→→→              ←←←←←←←←←←      Se leen ambos extremos
  Read 1 (150 pb)         Read 2 (150 pb)
├─────────────────────────────────────┤
         Distancia conocida (insert size)
```

| Tipo           | Qué produce                                                | Ventaja                                                                  | Limitación                                          |
|:---------------|:-----------------------------------------------------------|:-------------------------------------------------------------------------|:----------------------------------------------------|
| **Single-end** | 1 lectura por fragmento                                    | Más barato, suficiente para conteo (RNA-seq)                             | Menos info para ensamblaje y regiones repetitivas   |
| **Paired-end** | 2 lecturas por fragmento, separadas una distancia conocida | Mejor ensamblaje, resuelve repeticiones, detecta variantes estructurales | Mayor costo, requiere buena preparación de librería |

> [!TIP]
> Piense en paired-end como leer la primera y la última página de un capítulo: aunque no lea el medio, sabe qué tan largo es el capítulo y puede verificar que ambas páginas pertenecen al mismo libro.

### 2.6 ¿Cuándo usar cada tecnología?

| Tecnología   | Fortalezas                                        | Limitaciones                  | Ejemplos de uso                                       |
|:-------------|:--------------------------------------------------|:------------------------------|:------------------------------------------------------|
| **Sanger**   | Muy alta precisión                                | Bajo rendimiento              | Validar una mutación, confirmar un clon               |
| **Illumina** | Alta precisión, gran volumen, bajo costo por base | Lecturas cortas               | Genomas bacterianos, RNA-seq, metagenómica            |
| **PacBio**   | Lecturas largas, alta calidad en HiFi             | Mayor costo                   | Ensamblajes complejos, isoformas completas            |
| **Nanopore** | Ultra largas, portátil, tiempo real               | Mayor variabilidad en calidad | Vigilancia rápida, metagenómica, ensamblajes híbridos |

---

## 3. Datos de secuenciación: formatos, calidad y limpieza

### 3.1 El formato FASTQ

El archivo **FASTQ** es el formato estándar para almacenar secuencias con sus puntuaciones de calidad. 

> [!NOTE]
> Si necesita repasar → [Módulo 1 → Formatos de archivo](../01-introduction/README.md).

### 3.2 Calidad Phred (Q-score)

La puntuación Phred representa la probabilidad de error de cada base en escala logarítmica:

**Q = -10 × log₁₀(P)**

donde `P` es la probabilidad de que la base sea incorrecta.

| Q  | Probabilidad de error | Precisión | Significado práctico     |
|:---|:----------------------|:----------|:-------------------------|
| 10 | 1 en 10               | 90%       | Muy baja calidad         |
| 20 | 1 en 100              | 99%       | Umbral mínimo aceptable  |
| 30 | 1 en 1,000            | 99.9%     | Estándar de alta calidad |
| 40 | 1 en 10,000           | 99.99%    | Calidad Sanger           |

### 3.3 Perfil de calidad a lo largo de una lectura

En lecturas Illumina, la calidad **suele degradarse hacia el final** de la lectura. Esto es normal y se debe al desfase progresivo de las señales fluorescentes (*phasing*):

```text
Calidad
(Phred)
  40 │ ██████████████████
  35 │ ████████████████████████
  30 │ ████████████████████████████████         ← Umbral Q30
  25 │ ████████████████████████████████████
  20 │ ███████████████████████████████████████████
  15 │ █████████████████████████████████████████████████
  10 │ ██████████████████████████████████████████████████████
     └──────────────────────────────────────────────────────→
       Base 1                                          Base 150
                    Posición en la lectura

     ◀─── Alta calidad ───▶◀── Calidad degradada ──▶
```

Herramientas como **FastQC** y **Falco** generan este tipo de gráfico automáticamente.

### 3.4 Cobertura y profundidad

Estos términos se usan a veces como sinónimos, pero hay una diferencia:

- **Cobertura** (*coverage*): número **promedio** de veces que cada base del genoma fue leída.
- **Profundidad** (*depth*): número de lecturas que cubren una posición **específica**.

```text
Genoma de referencia:
═══════════════════════════════════════════

Lecturas alineadas:
  ──────────
     ──────────
        ──────────
           ──────────
              ──────────
                 ──────────
                    ──────────
                       ──────────
                          ──────────
                             ──────────

Profundidad en cada posición:
  1  2  3  4  5  6  6  6  6  5  4  3  2  1
  ↑                    ↑                 ↑
 Baja               Centro              Baja
(bordes)          (profundidad         (bordes)
                    máxima)

Cobertura promedio = suma de profundidades / longitud del genoma
```

Una cobertura de **30×** significa que, en promedio, cada posición fue leída 30 veces. Esto da confianza estadística para distinguir variantes reales de errores de secuenciación.

> [!NOTE]
> Alta cobertura no corrige problemas como contaminación, sesgos de GC o errores sistemáticos. Pero sí aumenta la confianza en el ensamblaje y la detección de variantes.

### 3.5 Trimming y filtrado de lecturas

Antes de ensamblar o alinear, suele ser necesario limpiar los datos:

```text
ANTES del trimming:
@lectura_001
NNNNATGCGTACGTTAGCAATCGATCGATCGAATTTAACCGGTTADAPTADORADAPTADOR
     ↑                                        ↑          ↑
  Bases N          Secuencia útil          Baja      Adaptadores
 (sin dato)                               calidad    residuales

DESPUÉS del trimming:
@lectura_001
ATGCGTACGTTAGCAATCGATCGATCG
         ↑
   Solo la región de buena calidad
```

¿Qué se elimina?

| Problema                     | Qué hacer                                                        |
|:-----------------------------|:-----------------------------------------------------------------|
| **Adaptadores residuales**   | Recortar secuencias de adaptador que quedaron al final           |
| **Bases de baja calidad**    | Recortar extremos con Q < 20 o Q < 30                            |
| **Bases N** (indeterminadas) | Eliminar o recortar                                              |
| **Lecturas muy cortas**      | Filtrar lecturas que quedan demasiado cortas después del recorte |

> [!WARNING]
> No siempre se debe hacer trimming agresivo. El objetivo es mejorar la calidad sin eliminar información útil. Para algunos ensambladores modernos (como SPAdes), el trimming excesivo puede ser contraproducente.

---

## 4. Estrategias de reconstrucción genómica: mapping vs *de novo*

Una vez que tiene lecturas limpias, el siguiente paso es reconstruir la información genómica. Hay dos estrategias fundamentales.

### 4.1 Mapping contra un genoma de referencia

Las lecturas se alinean contra un genoma ya conocido:

```text
Referencia:  ═══════════════════════════════════════════

Lecturas:      ──────────
                  ──────────
                     ──────────    ← Cada lectura se "coloca"
                        ──────────   donde mejor encaja
                           ──────────
                              ──────────

Resultado: Un mapa de cobertura sobre la referencia,
           con las variantes (SNPs/indels) marcadas.
```

- **Ventaja:** rápido, ideal cuando el organismo es muy parecido a uno ya secuenciado.
- **Aplicaciones:** detección de SNPs/indels, análisis de cobertura, vigilancia epidemiológica.
- **Limitación:** no detecta secuencias nuevas (genes, plásmidos, islas genómicas) que no están en la referencia.

### 4.2 Ensamblaje *de novo*

El genoma se reconstruye **sin referencia**, a partir de los solapamientos entre las propias lecturas:

```text
Lecturas (desordenadas):

  ──ATGCGT──    ──CGTACG──    ──TACGTTA──    ──GTTAGCA──

Solapamientos:

  ──ATGCGT──
      ──CGTACG──
          ──TACGTTA──
              ──GTTAGCA──

Contig resultante:
  ═══ATGCGTACGTTAGCA═══
```

- **Ventaja:** descubre secuencias nuevas, plásmidos, islas genómicas.
- **Aplicaciones:** genomas de organismos no modelo, análisis exploratorios.
- **Limitación:** depende de la calidad, cobertura, longitud de lectura y complejidad del genoma.

### 4.3 Comparación

| Estrategia  | ¿Cuándo usarla?                              | Ventajas                        | Limitaciones                    |
|:------------|:---------------------------------------------|:--------------------------------|:--------------------------------|
| **Mapping** | Hay buena referencia cercana                 | Rápido, sensible para variantes | Puede perder secuencias nuevas  |
| **De novo** | No hay referencia, o se quiere independencia | Descubre contenido nuevo        | Más exigente computacionalmente |

En la práctica, ambos enfoques se complementan: se ensambla *de novo* y luego se compara contra una referencia.

---

## 5. Algoritmos de ensamblaje

El ensamblaje es como reconstruir un libro a partir de millones de fragmentos de papel. El problema central: decidir qué fragmentos van juntos y en qué orden.

### 5.1 Conceptos básicos

| Término                  | Significado                                                         |
|:-------------------------|:--------------------------------------------------------------------|
| **Lectura** (*read*)     | Fragmento de ADN secuenciado                                        |
| **Contig**               | Secuencia continua ensamblada a partir de múltiples lecturas        |
| **Scaffold**             | Contigs ordenados y orientados entre sí (usando info de paired-end) |
| **Regiones repetitivas** | Secuencias similares que crean ambigüedad en el ensamblaje          |

### 5.2 Overlap-Layout-Consensus (OLC)

Este enfoque compara lecturas entre sí para encontrar solapamientos directos:

```text
Paso 1 — Overlap: encontrar lecturas que se solapan

  Lectura A:  ──ATGCGTACG──
  Lectura B:       ──GTACGTTAG──
                   ^^^^^^^^
                   Solapamiento

Paso 2 — Layout: organizar en un grafo

  A ──────→ B ──────→ C ──────→ D

Paso 3 — Consensus: derivar la secuencia final

  ═══ATGCGTACGTTAGCAATCG═══
```

- **Cuándo se usa:** lecturas largas (Sanger, PacBio, Nanopore) donde el número total de lecturas es menor.
- **Limitación:** comparar todas las lecturas entre sí es muy costoso con millones de lecturas cortas.

### 5.3 Grafos de De Bruijn

La estrategia dominante para ensamblar **lecturas cortas** (Illumina). En lugar de comparar lecturas completas, las divide en fragmentos de longitud fija llamados **k-mers**.

#### Paso a paso

Suponga la secuencia `ATGCGTACG` y `k = 5`:

```text
Paso 1 — Extraer k-mers de las lecturas:

Secuencia: A T G C G T A C G
           ─────               → ATGCG
             ─────             → TGCGT
               ─────           → GCGTA
                 ─────         → CGTAC
                   ─────       → GTACG

Paso 2 — Crear nodos con (k-1)-mers y conectar:

Cada k-mer "ATGCG" conecta el (k-1)-mer "ATGC" con "TGCG":

  ATGC → TGCG → GCGT → CGTA → GTAC → TACG

Paso 3 — Recorrer el grafo para obtener contigs:

  ═══ ATGCGTACG ═══
```

#### ¿Por qué funciona con lecturas cortas?

Porque evita comparar "todas contra todas". Resume la información de millones de lecturas en un grafo compacto.

#### Importancia del tamaño de k

```text
k pequeño (ej. k=21):
┌──────────────────────────────┐
│ + Más conexiones             │
│ + Tolera menor cobertura     │
│ - Mezcla regiones repetitivas│
│ - Ensamblaje más ambiguo     │
└──────────────────────────────┘

k grande (ej. k=77):
┌──────────────────────────────┐
│ + Resuelve mejor repeticiones│
│ + Contigs más específicos    │
│ - Requiere mayor cobertura   │
│ - Sensible a errores de seq. │
└──────────────────────────────┘
```

> [!TIP]
> Imagine que quiere reconstruir una frase con fragmentos de letras. Si los fragmentos son muy pequeños, muchas combinaciones parecerán posibles. Si son muy grandes, cualquier error ortográfico rompe la conexión. El ensamblaje debe encontrar un equilibrio.

### 5.4 Problemas frecuentes en ensamblaje

| Problema                     | Efecto                                       | Solución habitual                              |
|:-----------------------------|:---------------------------------------------|:-----------------------------------------------|
| **Baja cobertura**           | Huecos sin evidencia                         | Secuenciar más o usar lecturas largas          |
| **Errores de secuenciación** | k-mers falsos, "burbujas" en el grafo        | Corrección de errores pre-ensamblaje           |
| **Regiones repetitivas**     | Caminos ambiguos en el grafo                 | Lecturas largas o paired-end con insert grande |
| **Contaminación**            | Secuencias ajenas mezcladas                  | Filtrado de lecturas, análisis de GC           |
| **Múltiples replicones**     | Plásmidos ensamblados como contigs separados | Evaluación post-ensamblaje, circularización    |

---

## 6. Evaluación del ensamblaje

Un ensamblaje no debe aceptarse solo porque produjo contigs. Debe evaluarse críticamente en varias dimensiones.

### 6.1 Métricas de continuidad: N50 y L50

#### N50 — paso a paso

Suponga que ensambló un genoma y obtuvo 6 contigs:

```text
Paso 1 — Ordenar contigs de mayor a menor:

  Contig 3:  ══════════════════════════  (50 kb)
  Contig 1:  ════════════════════        (40 kb)
  Contig 5:  ═══════════════             (30 kb)
  Contig 2:  ══════════                  (20 kb)
  Contig 6:  ═══════                     (15 kb)
  Contig 4:  ═══                         ( 5 kb)
                                         ───────
                              Total:      160 kb

Paso 2 — Calcular el 50% del tamaño total:

  50% de 160 kb = 80 kb

Paso 3 — Sumar contigs desde el más grande hasta superar el 50%:

  Contig 3:  50 kb  →  acumulado =  50 kb  (no llega a 80)
  Contig 1:  40 kb  →  acumulado =  90 kb  (¡supera 80!)  ← ESTE
                                                     ↑
                                                   N50 = 40 kb
```

**N50 = 40 kb** → el contig que "cruza" el umbral del 50%.

#### L50

Es el **número mínimo de contigs** necesarios para llegar al 50%:

```text
  Contig 3 (50 kb) + Contig 1 (40 kb) = 90 kb ≥ 80 kb

  → L50 = 2  (solo necesitamos 2 contigs)
```

#### NG50 y LG50

Son más robustas que N50/L50 estándar. En lugar de usar el tamaño total del ensamblaje como referencia, usan el **tamaño estimado del genoma**. Esto evita que un ensamblaje incompleto parezca tener un "buen" N50.

| Métrica  | Referencia                  | ¿Qué mide?                                     |
|:---------|:----------------------------|:-----------------------------------------------|
| **N50**  | Tamaño total del ensamblaje | Continuidad respecto al propio ensamblaje      |
| **NG50** | Tamaño esperado del genoma  | Continuidad respecto al genoma real esperado   |
| **L50**  | 50% del ensamblaje          | Número mínimo de contigs para cubrir la mitad  |
| **LG50** | 50% del genoma esperado     | Igual, pero contra el tamaño genómico esperado |

### 6.2 Métricas de completitud

Un ensamblaje puede tener N50 alto y haber perdido la mitad de los genes.

#### BUSCO

**BUSCO** (*Benchmarking Universal Single-Copy Orthologs*) busca genes "core" que deberían estar en cualquier organismo del linaje evaluado:

```text
Resultado típico de BUSCO:

  ████████████████████████████████░░░░░  (95% Complete)
  ██                                     ( 1% Duplicated)
  ░░                                     ( 2% Fragmented)
  ░░                                     ( 2% Missing)

  C:95.0%  [S:94.0%, D:1.0%]  F:2.0%  M:2.0%  n:452
```

| Categoría           | Significado                                     |
|:--------------------|:------------------------------------------------|
| **Complete (C)**    | Gen presente de forma completa                  |
| **Single-copy (S)** | Una sola copia (lo esperado)                    |
| **Duplicated (D)**  | Más de una copia → duplicación real o artefacto |
| **Fragmented (F)**  | Gen incompleto                                  |
| **Missing (M)**     | Gen no encontrado                               |

#### Tamaño total vs. esperado

Si espera un genoma bacteriano de ~4.5 Mb y obtiene 3.0 Mb, algo salió mal (cobertura insuficiente, contaminación o pérdida durante la preparación de librería).

### 6.3 Métricas de exactitud y consistencia

| Métrica                  | ¿Qué evalúa?                                                                    | Herramienta    |
|:-------------------------|:--------------------------------------------------------------------------------|:---------------|
| **Mapping rate**         | ¿Qué % de las lecturas originales alinean contra el ensamblaje? (>95% es bueno) | BWA + samtools |
| **QV** (*Quality Value*) | Precisión a nivel de base (QV ≥ 40 = excelente)                                 | Merqury        |
| **Espectro de k-mers**   | Completitud y duplicaciones sin referencia                                      | Merqury, KAT   |

### 6.4 Métricas de pureza (contaminación)

En microbiología esto es vital:

```text
Distribución del contenido GC de los contigs:

  Contigs
    │
    │      ████
    │     ██████
    │    ████████        ██
    │   ██████████      ████
    │  ████████████    ██████
    └──────────────────────────→  %GC
       30%  35%  40%   55%  60%
       ↑                  ↑
   Organismo          ¿Contaminante?
    principal

Si hay DOS picos de GC → probable contaminación
```

### 6.5 Interpretación crítica

Un buen ensamblaje **no es** el que tiene el mayor N50, sino el que combina razonablemente:

- **continuidad** (pocos contigs largos);
- **completitud** (todos los genes esperados presentes);
- **exactitud** (bases correctas, buena tasa de mapeo);
- **pureza** (sin contaminación);
- **tamaño coherente** con lo esperado.

> [!IMPORTANT]
> Para detectar genes de resistencia puede bastar un ensamblaje fragmentado pero bien anotado. Para estudiar reordenamientos cromosómicos se necesita una estructura mucho más continua. **La calidad requerida depende de la pregunta biológica.**

---

## 7. Herramientas de análisis

### 7.1 Control de calidad (QC)

| Herramienta | Función                                                                                  |
|:------------|:-----------------------------------------------------------------------------------------|
| **FastQC**  | Visualización de métricas de calidad: Q por base, contenido GC, duplicación, adaptadores |
| **Falco**   | Alternativa más rápida a FastQC                                                          |
| **MultiQC** | Integra múltiples reportes en una vista resumida                                         |

### 7.2 Limpieza y procesamiento

| Herramienta     | Función                                                  |
|:----------------|:---------------------------------------------------------|
| **fastp**       | Todo-en-uno: QC + filtrado + trimming + reporte          |
| **Trimmomatic** | Clásico para remover adaptadores y bases de baja calidad |
| **Cutadapt**    | Especializado en remoción de adaptadores                 |

### 7.3 Alineamiento (mapping)

| Herramienta       | Tipo de lecturas                                    |
|:------------------|:----------------------------------------------------|
| **BWA / Bowtie2** | Lecturas cortas (Illumina)                          |
| **Minimap2**      | Lecturas largas (PacBio, Nanopore) y también cortas |

### 7.4 Ensamblaje *de novo*

| Herramienta          | Tipo                   | Nota                                             |
|:---------------------|:-----------------------|:-------------------------------------------------|
| **Velvet**           | Grafos de De Bruijn    | Clásico, bueno para entender el efecto del k-mer |
| **SPAdes / Shovill** | De Bruijn + corrección | Estándar para genomas bacterianos con Illumina   |
| **Canu / Flye**      | OLC y variantes        | Para lecturas largas (PacBio, Nanopore)          |

### 7.5 Evaluación del ensamblaje

| Herramienta | ¿Qué evalúa?                                                            |
|:------------|:------------------------------------------------------------------------|
| **QUAST**   | N50, L50, número de contigs, longitud total, comparación con referencia |
| **BUSCO**   | Completitud biológica (genes conservados)                               |
| **Merqury** | QV y espectro de k-mers (sin referencia)                                |
| **CheckM**  | Completitud y contaminación en genomas procariotas                      |

### 7.6 Visualización

| Herramienta                             | Función                                                |
|:----------------------------------------|:-------------------------------------------------------|
| **IGV** (*Integrative Genomics Viewer*) | Visualización de alineamientos, cobertura y variantes  |
| **Tablet**                              | Exploración visual de ensamblajes y lecturas alineadas |
| **Bandage**                             | Visualización de grafos de ensamblaje                  |

---

## 8. Cierre conceptual

Este módulo cubre el camino completo desde la molécula hasta el genoma ensamblado. Ha aprendido:

- que la química del nucleótido (especialmente el **3'-OH**) explica por qué funciona la secuenciación Sanger;
- que las tecnologías de secuenciación difieren en longitud, precisión, costo y aplicaciones;
- que la **calidad Phred** y el **formato FASTQ** son el lenguaje con el que se reportan los datos crudos;
- que **cobertura** y **profundidad** determinan la confianza estadística del análisis;
- que el **ensamblaje** puede ser contra referencia (*mapping*) o independiente (*de novo*);
- que los **grafos de De Bruijn** y los **k-mers** son la base de los ensambladores modernos para lecturas cortas;
- que la calidad de un ensamblaje se evalúa con **múltiples métricas** (N50, BUSCO, tasa de mapeo, pureza).

En el **Módulo 6** (Genómica) tomará estos genomas ensamblados y les dará significado biológico: anotación de genes, predicción de funciones, detección de variantes y genómica comparada.

> [!IMPORTANT]
> La secuenciación moderna no consiste solo en generar datos, sino en comprender qué representan y qué limitaciones arrastran desde el laboratorio hasta el análisis computacional. La elección de la tecnología, la evaluación de la calidad y la estrategia de ensamblaje dependen siempre de la pregunta biológica.

---

## Prácticas del módulo

| Práctica                                                                                        | Descripción                                                                 |
|:------------------------------------------------------------------------------------------------|:----------------------------------------------------------------------------|
| [Ensamblaje con FastQC + Velvet](exercises/01_2_genome_assembly_fastqc_velvet.md)               | Control de calidad con FastQC y ensamblaje *de novo* con Velvet             |
| [Ensamblaje con Falco + fastp + Shovill](exercises/01_1_genome_assembly_falco_fastp_shovill.md) | Pipeline moderno: QC con Falco, trimming con fastp y ensamblaje con Shovill |
| [Diseño de primers](../03-sequence_analysis/exercises/01_primer_design.md)                      | Alineamiento, complementariedad y especificidad de secuencias               |
| [Anotación genómica](../06-genomics/exercises/01_genome_annotation.md)                          | Predicción de genes y asignación de funciones en genomas bacterianos        |
