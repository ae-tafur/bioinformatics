# 🧬 Práctica A: Anotación de Genomas en Galaxy

> [!NOTE]
> Esta es la **Práctica A** del módulo de anotación genómica. Antes de continuar:
> 1. Lea las secciones **2, 3 y 4** del [README del Módulo 6](../README.md) para los conceptos de estructura génica, predicción y bases de datos.
> 2. Lea la [guía de prácticas compartida](00_genome_annotation_common.md) para el contexto biológico de cada caso, las plataformas y los archivos de salida esperados.

---

## 🎯 Objetivos

- Realizar la anotación estructural y funcional de un genoma bacteriano con **Bakta**.
- Identificar genes de resistencia a antibióticos y factores de virulencia con **AMRFinderPlus**.
- Detectar plásmidos con **PlasmidFinder**.
- Identificar integrones con **IntegronFinder**.
- Detectar elementos de inserción (IS) con **ISEScan**.
- Integrar e interpretar los resultados de todas las herramientas.

---

## 📦 Requisitos previos

- Haber leído el [README del Módulo 6](../README.md) §§ 2–4.
- Haber leído la [guía de prácticas compartida](00_genome_annotation_common.md).
- Tener cuenta activa en [Galaxy Europe](https://usegalaxy.eu).
- (Opcional) Haber realizado las prácticas de ensamblaje del Módulo 5 — puede usar sus propios contigs.

---

## 🖥️ Herramientas utilizadas

| Herramienta        | Versión Galaxy   | Función                                       |
|:-------------------|:-----------------|:----------------------------------------------|
| **Bakta**          | 1.9.4+galaxy1    | Anotación estructural y funcional completa    |
| **AMRFinderPlus**  | 3.12.8+galaxy0   | Genes de resistencia y factores de virulencia |
| **PlasmidFinder**  | 2.1.6+galaxy1    | Identificación de plásmidos                   |
| **IntegronFinder** | 2.x              | Detección de integrones                       |
| **ISEScan**        | 1.7.x            | Detección de elementos IS                     |

---

## 🧫 Caso asignado

Consulte la sección de [casos de estudio](00_genome_annotation_common.md#-casos-de-estudio) en la guía compartida para el contexto biológico, y cargue los datos del caso que le indique el profesor (**A**, **B**, **C** o **D**).

---

## 🔬 Procedimiento

### Paso 1 — Crear un historial y cargar los datos

1. En Galaxy, haga clic en `+` (esquina superior derecha) para crear un historial nuevo.
2. Renómbrelo, por ejemplo: `Anotacion_CasoA_Galaxy`.
3. Cargue los contigs de su caso usando el bloque desplegable de la [guía compartida](00_genome_annotation_common.md#-casos-de-estudio):
   - Haga clic en `Upload` → `Paste/Fetch data`.
   - Pegue el enlace del caso asignado.
   - Haga clic en `Start` y espere el **verde** ✅.

---

### Paso 2 — Anotación principal con Bakta

Bakta realiza en un solo paso la anotación estructural (CDS, ARNt, ARNr, ncRNA, CRISPR) y funcional (asignación de función por similitud contra su base de datos curada). Es el estándar actual para genomas bacterianos y el sucesor recomendado de Prokka.

1. En Galaxy, busque **Bakta** y configure:

   **Input/Output options:**
   - `Select genome in fasta format`: `*_contigs.fasta`
   - `Bakta database`: `V5.1_2024-01-19`
   - `AMRFinderPlus database`: `V3.12-2024-05-02.2`

   **Optional annotation:**
   - `Keep original contig header`: `Yes`

   **Selection of the output files:**
   Seleccione las siguientes salidas:
   - ✅ Annotation file in TSV
   - ✅ Annotation and sequence in GFF3
   - ✅ Feature nucleotide sequences as FASTA
   - ✅ Summary as TXT
   - ✅ Plot of the annotation result as SVG

2. Haga clic en `Run Tool`.

> [!TIP]
> Bakta puede tardar varios minutos. Mientras espera, lea la descripción de los archivos de salida en la [guía compartida](00_genome_annotation_common.md#archivos-de-salida-que-encontrará-en-esta-práctica).

#### Explorar los resultados de Bakta

Una vez terminado, abra el archivo **Summary (TXT)** con el ojo 👁:

**Preguntas:**

1. ¿Cuántos contigs había en el input?
2. ¿Cuál es la longitud total del borrador del genoma (*draft genome length*)?
3. ¿Cuántos CDS fueron predichos?
4. ¿Cuántas *small proteins* se encontraron?
5. ¿Cuántos ARNt y ARNr se anotaron?
6. ¿Hay secuencias CRISPR? ¿Cuántas?
7. Compare sus resultados con los de la **Tabla 1 de Hikichi et al. 2019** (Caso A) o con el artículo de referencia (Caso B). ¿Qué tan similares son?

Abra el archivo **GFF3** y el **SVG**:

8. ¿Qué información contiene cada columna del archivo GFF3?
9. En el mapa circular SVG, ¿qué representan los dos anillos del centro?
10. ¿Qué representan los anillos de color gris?

Abra el archivo **Feature nucleotide sequences (FASTA)**:

11. ¿Cuántas secuencias hay?
12. ¿Qué tipo de elementos están almacenados?

---

### Paso 3 — Genes de resistencia y virulencia con AMRFinderPlus

AMRFinderPlus usa BLAST + perfiles HMM para identificar genes de resistencia a antibióticos (ARG) y factores de virulencia contra la base de datos curada del NCBI. La especificación del grupo taxonómico activa búsquedas adicionales de mutaciones puntuales de resistencia específicas del organismo.

1. Busque **AMRFinderPlus** en Galaxy y configure:

   **Input parameters:**
   - `Choose input type`: `nucleotide`
   - `Input nucleotide sequence file`: `*_contigs.fasta`

   **Organism options:**
   - `Add organism specifications`: `Add organism specifications`
   - `Taxonomy group / point mutation`:
     - Caso A → `Staphylococcus aureus`
     - Caso B → `Klebsiella pneumoniae`
     - Caso C → deje en blanco (no existe grupo taxonómico específico para *Streptomyces* en AMRFinderPlus)
     - Caso D → `Pseudomonas aeruginosa` (el más cercano disponible para *P. abieticivorans*)

2. Haga clic en `Run Tool`.

**Preguntas:**

13. ¿Qué genes de resistencia a antibióticos se encontraron?
14. ¿A qué familias de antibióticos pertenecen?
15. ¿En qué contigs se encuentran esos genes?
16. ¿Se encontraron factores de virulencia? ¿Cuáles?

---

### Paso 4 — Identificación de plásmidos con PlasmidFinder

PlasmidFinder identifica secuencias de replicón de plásmidos en el genoma comparando contra su base de datos curada. Los plásmidos son los principales vectores de transferencia horizontal de genes de resistencia entre bacterias.

1. Busque **PlasmidFinder** en Galaxy y configure:

   **Input parameters:**
   - `Choose a fasta or fastq file`: `*_contigs.fasta`
   - `PlasmidFinder database`: use la versión más reciente disponible

2. Haga clic en `Run Tool`.

#### Interpretar los resultados de PlasmidFinder

PlasmidFinder genera tres archivos principales:

| Archivo               | Contenido                                                             |
|:----------------------|:----------------------------------------------------------------------|
| `results.tsv`         | Tabla: plásmido identificado, % identidad, longitud, contig, posición |
| `plasmid.fasta`       | Secuencias del genoma que coinciden con plásmidos de la base de datos |
| `hit_in_genome.fasta` | Secuencias de los genes plasmídicos que mejor encajan                 |

La columna **Identidad** indica el % de similitud con el plásmido de referencia. Una identidad del 100% que cubra toda la longitud es una coincidencia perfecta.

**Preguntas:**

17. ¿Cuántas secuencias de plásmidos se encontraron?
18. ¿A qué replicones / familias de plásmidos están asociados?
19. ¿En qué contigs se encuentran?
20. Cruzando con AMRFinderPlus: ¿alguno de los genes de resistencia encontrados está en un contig con plásmido? ¿Qué implica esto?

---

### Paso 5 — Detección de integrones con IntegronFinder

Los integrones son sistemas genéticos que capturan y expresan casetes de genes — frecuentemente genes de resistencia. Un integrón completo contiene: una integrasa (IntI), un sitio de recombinación (attI) y un promotor (Pc).

IntegronFinder detecta tres tipos de elementos:
- **Integrón completo:** integrasa + sitio(s) attC
- **Elemento In0:** integrasa sola, sin attC cercano
- **Elemento CALIN:** grupo de sitios attC sin integrasa cercana

1. Busque **IntegronFinder** en Galaxy y configure:
   - `Replicon file`: `*_contigs.fasta`
   - `Thorough local detection`: `Yes`
   - `Search also for promoter and attI sites?`: `Yes`
   - `Remove log file`: `Yes`

2. Haga clic en `Run Tool`.

**Preguntas:**

21. ¿Cuántos integrones completos se encontraron?
22. ¿Cuántos elementos In0 y CALIN?
23. ¿En qué contigs se localizan?

---

### Paso 6 — Detección de elementos IS con ISEScan

Los elementos de inserción (IS) son las secuencias transponibles más pequeñas y abundantes en genomas bacterianos. Solo codifican proteínas de transposición pero juegan un papel clave en la reorganización genómica y en la movilización de genes de resistencia.

ISEScan usa modelos de Markov ocultos (HMM) construidos a partir de IS curados manualmente para identificarlos con alta sensibilidad.

1. Busque **ISEScan** en Galaxy y configure:
   - `Genome fasta input`: `*_contigs.fasta`

2. Haga clic en `Run Tool`.

**Preguntas:**

24. ¿Cuántos elementos IS se detectaron?
25. ¿En qué contigs se encuentran?
26. ¿Cuáles son las distintas familias de IS identificadas?

---

### Paso 7 — (Casos C y D) Predicción de clústeres de genes biosintéticos con antiSMASH

> [!NOTE]
> Este paso es para los **Casos C y D**. Los Casos A y B pueden omitirlo y pasar directamente a las preguntas integradoras.

Los clústeres de genes biosintéticos (BGC, *Biosynthetic Gene Clusters*) son grupos de genes contiguos que codifican coordinadamente la síntesis de un metabolito secundario. **antiSMASH** es el estándar para su detección.

- **Caso C** (*S. venezuelae*): género con la mayor diversidad de BGC conocida — antibióticos, antifúngicos, sideróforos.
- **Caso D** (*P. abieticivorans*): BGC para sideróforos (pioverdina), lipopéptidos y compuestos de degradación de diterpenos.

**Opción 1 — antiSMASH web server (más rápido):**

1. Vaya a **<https://antismash.secondarymetabolites.org>**.
2. En `Input sequence`, seleccione `Upload file` y cargue el archivo FASTA del genoma de *S. venezuelae*.
3. En `Detection strictness`, seleccione `relaxed` para detectar más BGC candidatos.
4. Active `KnownClusterBlast` y `MIBiG cluster comparison`.
5. Haga clic en `Submit`.

> [!TIP]
> El análisis puede tardar 20–40 minutos dependiendo de la carga del servidor. Mientras espera, continúe con las preguntas de los pasos anteriores.

**Opción 2 — antiSMASH en Galaxy:**

1. En Galaxy, busque **antiSMASH** (puede estar como `antiSMASH bacterial version`).
2. Configure:
   - `Sequence file`: genoma FASTA del Caso C
   - `Taxon`: `Bacteria`
   - `Detection strictness`: `relaxed`
   - `KnownClusterBlast`: activado
3. Haga clic en `Run Tool`.

#### Interpretar los resultados de antiSMASH

antiSMASH genera un **reporte HTML interactivo** con un mapa del genoma coloreado por tipo de BGC. Cada BGC tiene una página propia con:

| Sección                | Qué muestra                                                        |
|:-----------------------|:-------------------------------------------------------------------|
| **Cluster type**       | Tipo de metabolito predicho (NRPS, PKS, terpeno, sideróforo, etc.) |
| **Region coordinates** | Posición en el cromosoma / contig                                  |
| **KnownClusterBlast**  | Similitud con BGC conocidos en MIBiG                               |
| **Gene functions**     | Función predicha de cada gen dentro del BGC                        |
| **Cluster chemistry**  | Estructura química predicha del producto (si está disponible)      |

**Preguntas — Caso C (*S. venezuelae*):**

31. ¿Cuántos BGC predijo antiSMASH?
32. ¿Qué tipos de BGC están presentes? ¿Qué tipo es el más frecuente?
33. ¿Cuál BGC corresponde al clúster del **cloranfenicol** según KnownClusterBlast?
34. ¿Hay BGC sin homología conocida en MIBiG ("unknown")? ¿Qué implicaría caracterizar uno de ellos?
35. Elija un BGC que le llame la atención y describa: tipo, tamaño (pb), genes principales y metabolito predicho.

**Preguntas — Caso D (*P. abieticivorans*):**

36. ¿Cuántos BGC predijo antiSMASH? ¿Cuántos tipos diferentes hay?
37. ¿Detectó antiSMASH algún clúster relacionado con **sideróforos** (ej. pioverdina)? ¿En qué posición del cromosoma?
38. Compare el número y diversidad de BGC entre *P. abieticivorans* y *S. venezuelae* (si realizó ambos casos o tiene acceso a los resultados del Caso C). ¿Cuál tiene mayor potencial biosintético?
39. ¿Qué relación podría haber entre la capacidad de degradar diterpenos y la presencia de ciertos BGC?

---

## ❓ Preguntas integradoras

Responda estas preguntas integrando los resultados de todas las herramientas:

27. Considerando los resultados de Bakta, AMRFinderPlus y PlasmidFinder juntos: ¿qué puede concluir sobre la movilidad de los genes de resistencia encontrados?
28. Si un gen de resistencia está en un plásmido que también contiene un integrón, ¿qué implicaciones tiene esto para la diseminación de resistencias?
29. ¿Todos los contigs que contienen secuencias plasmídicas pertenecen claramente al organismo en estudio? ¿Cómo lo verifica?
30. Para el **Caso B** (*K. pneumoniae*): el artículo menciona resistencia a carbapenemes mediada por los clones ST11, ST307 y ST1082. ¿Los resultados de AMRFinderPlus son consistentes con este perfil?
31. Para el **Caso C** (*S. venezuelae*): ¿cuántos BGC identificó Bakta en su anotación estándar? ¿El número coincide con los predichos por antiSMASH? ¿Por qué podrían diferir?
32. Para el **Caso C**: compare el número de BGC predichos con lo reportado en la literatura para *Streptomyces venezuelae*. ¿Cuántos tienen producto conocido y cuántos son "silenciosos" o sin homología en MIBiG?
33. Para el **Caso D** (*P. abieticivorans*): ¿los genes de degradación de diterpenos están anotados como CDS con función asignada en Bakta, o aparecen como "hypothetical protein"? ¿Qué implica esto sobre la cobertura de la base de datos de Bakta para este tipo de metabolismo?
34. Comparando los Casos C y D: ambos son organismos de suelo. ¿Qué diferencias observa en el número de BGC, genes de resistencia y movilidad genómica entre una actinobacteria (*Streptomyces*) y una proteobacteria (*Pseudomonas*)?

---

## 🏆 Reto adicional (opcional)

1. **Visualización en JBrowse 2:** Galaxy tiene JBrowse integrado. Cargue el archivo GFF3 de Bakta y visualice la distribución de los genes anotados a lo largo de los contigs. ¿Hay contigs sin ninguna anotación?
2. **Comparación entre casos:** si tiene acceso a los resultados del otro caso (A o B), compare el número de genes de resistencia y el perfil de plásmidos. ¿Qué organismo tiene mayor carga de elementos móviles?
3. **MLST:** busque la herramienta **mlst** en Galaxy y ejecute un tipado de secuencia multilocus sobre los contigs. ¿A qué sequence type (ST) pertenece el aislado?

---

## 📚 Bibliografía

Ver la [bibliografía completa en la guía de prácticas compartida](00_genome_annotation_common.md#-bibliografía).
