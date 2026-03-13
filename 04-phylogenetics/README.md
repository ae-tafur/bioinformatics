# Módulo 4: Filogenética y Análisis Evolutivo

## Introducción

En el Módulo 3 aprendió a comparar secuencias: BLAST, alineamiento global y local, scoring, identidad vs. similitud. Todas esas herramientas le permiten comparar **dos** secuencias a la vez. Pero en biología, rara vez trabajamos con solo dos secuencias. Cuando tiene un gen de 10 cepas bacterianas distintas, o 50 secuencias de 16S rRNA de un muestreo ambiental, necesita compararlas **todas simultáneamente** y entender cómo se relacionan entre sí.

Eso es exactamente lo que hace la filogenética: toma un conjunto de secuencias, las alinea, estima cuánto han divergido y construye un **árbol filogenético** que representa sus relaciones evolutivas.

Este módulo es la evolución natural del anterior. Si en el Módulo 3 aprendió el "cómo" de comparar secuencias, aquí aprenderá el "para qué": reconstruir la historia evolutiva que conecta organismos, genes o proteínas.

Trabajaremos con cinco grandes bloques:

1. **Conceptos fundamentales** — genes marcadores, bases de datos, por qué BLAST no basta para identificar especies y alternativas como ANI.
2. **Construir un árbol a mano** — para entender la lógica antes de usar software.
3. **Alineamiento múltiple de secuencias (MSA)** — la base de todo análisis filogenético molecular.
4. **Modelos de sustitución** — cómo se mide la "distancia evolutiva" real entre secuencias.
5. **Métodos de construcción de árboles** — Neighbor-Joining, Máxima Parsimonia y Máxima Verosimilitud.

> [!NOTE]
> La filogenética no es solo un ejercicio académico. En microbiología clínica se usa para rastrear brotes hospitalarios, en epidemiología para seguir la evolución de patógenos (como se hizo con SARS-CoV-2), en biotecnología para identificar enzimas de organismos relacionados y en ecología para estudiar la diversidad de comunidades microbianas.

---

## Prerrequisitos y conexión con módulos previos

### Del Módulo 1

Ya conoce:
- cómo buscar y descargar secuencias desde el **NCBI**;
- los formatos **FASTA** y **GenBank**;
- el concepto de genes marcadores como el **16S rRNA**.

> [!NOTE]
> Si necesita repasar → [README del Módulo 1](../01-introduction/README.md).

### Del Módulo 3

Ya sabe:
- qué es un **alineamiento** y la diferencia entre global y local;
- cómo funcionan **Needleman-Wunsch** y **Smith-Waterman**;
- los conceptos de **identidad**, **similitud**, **scoring** y **gaps**;
- cómo interpretar resultados de **BLAST**.

> [!NOTE]
> Si necesita repasar → [README del Módulo 3](../03-sequence_analysis/README.md).

En este módulo extenderá esos conceptos: pasará de alinear **2 secuencias** a alinear **muchas** simultáneamente, y de medir similitud a **reconstruir relaciones evolutivas**.

---

## 1. Conceptos fundamentales: genes marcadores, identificación y sus limitaciones

Antes de construir árboles, necesita entender **qué secuencias se usan** para filogenética y, sobre todo, **qué puede y qué no puede decirle** una búsqueda por similitud sobre la identidad de un organismo.

### 1.1 Genes conservados y por qué son útiles

No todas las regiones del genoma son igualmente útiles para estudiar relaciones evolutivas. Para comparar organismos que divergieron hace millones de años, necesitamos genes que:

- estén presentes en **todos** los organismos del grupo de interés (universales);
- tengan regiones **conservadas** (para poder alinearlos) intercaladas con regiones **variables** (para poder distinguir entre organismos);
- evolucionen a una tasa adecuada: ni tan rápido que se saturen de cambios, ni tan lento que no aporten información.

Estos genes se conocen como **genes marcadores** o **marcadores filogenéticos**. Los más importantes provienen del **ribosoma**, así que antes de verlos conviene recordar cómo está constituido.

> [!NOTE]
> 📌 El ribosoma: de dónde salen los nombres 16S, 23S, ITS y compañía
>
> El **ribosoma** es la maquinaria celular que traduce ARN mensajero en proteínas. Todos los seres vivos lo tienen, lo que lo convierte en una fuente ideal de marcadores universales. Está formado por dos subunidades de diferente tamaño, cada una compuesta por **ARN ribosomal (rRNA)** y proteínas.
> 
> La "**S**" en 16S, 23S, etc. se refiere a **Svedberg**, una unidad que mide la velocidad de sedimentación de una partícula en una ultracentrífuga. No es una medida de tamaño directa, sino de cómo "cae" la molécula en un campo centrífugo — depende del tamaño, la forma y la densidad. Por eso los valores no son aditivos: una subunidad 30S + una 50S no dan 80S sino ~70S.
> 
> * **Ribosoma procariota (70S)**
> 
> ```text
> Ribosoma 70S (bacterias y arqueas)
> ├── Subunidad pequeña (30S)
> │   └── rRNA 16S  ← El marcador más usado en microbiología
> │
> └── Subunidad grande (50S)
>     ├── rRNA 23S  ← Marcador complementario (más largo, más info)
>     └── rRNA 5S   ← Muy corto (~120 nt), poco usado como marcador
> ```
> 
> Los genes que codifican estos rRNAs están organizados en un **operón ribosomal**, que en muchas bacterias tiene esta estructura:
> 
> ```text
> ──[16S]──ITS──[23S]──ITS──[5S]──
>            ↑           ↑
>      Espaciador    Espaciador
>      transcrito    transcrito
>       interno       interno
> ```
> 
> Las regiones **ITS** (*Internal Transcribed Spacer*) en procariotas son los espacios entre los genes ribosomales. Se transcriben pero luego se eliminan durante la maduración del rRNA. En bacterias, el ITS entre 16S y 23S a veces contiene genes de tRNA y es variable entre especies, pero no se usa tanto como marcador en procariotas (se prefiere el 16S directamente).
> 
> * **Ribosoma eucariota (80S)**
> 
> ```text
> Ribosoma 80S (eucariotas: hongos, animales, plantas, protistas)
> ├── Subunidad pequeña (40S)
> │   └── rRNA 18S  ← Equivalente al 16S de procariotas
> │
> └── Subunidad grande (60S)
>     ├── rRNA 28S  ← Equivalente al 23S
>     ├── rRNA 5.8S ← Exclusivo de eucariotas
>     └── rRNA 5S
> ```
> 
> En eucariotas, los genes ribosomales están organizados así:
> 
> ```text
> ──[18S]──ITS1──[5.8S]──ITS2──[28S]──
>           ↑             ↑
>      Espaciador    Espaciador
>      transcrito    transcrito
>      interno 1     interno 2
> ```
> 
> Aquí es donde las regiones **ITS** cobran protagonismo: **ITS1** (entre 18S y 5.8S) e **ITS2** (entre 5.8S y 28S) son las más utilizadas para la identificación de **hongos**. ¿Por qué?
> 
> - Los genes ribosomales (18S, 5.8S, 28S) están muy conservados → se pueden usar **primers universales** que anclan en estas regiones conservadas para amplificar los ITS.
> - Las regiones ITS **no tienen función en el ribosoma maduro** (se eliminan) → están bajo menos presión de selección → evolucionan más rápido → tienen mayor resolución a nivel de especie.
> - En conjunto, ITS1 + 5.8S + ITS2 suman ~500–800 pb, un tamaño ideal para amplificación y secuenciación.
> 
> **Resumen comparativo**
> 
> | Componente             | Procariotas   | Eucariotas          | Tamaño aprox.      | Uso como marcador                              |
> |:-----------------------|:--------------|:--------------------|:-------------------|:-----------------------------------------------|
> | Subunidad pequeña rRNA | **16S**       | **18S**             | ~1,500 / ~1,800 pb | Principal en bacterias / útil en eucariotas    |
> | Subunidad grande rRNA  | **23S**       | **28S**             | ~2,900 / ~5,000 pb | Complementario, más info filogenética          |
> | rRNA corto             | 5S            | 5S + **5.8S**       | ~120 / ~160 pb     | Poco usado (muy corto)                         |
> | Espaciadores (ITS)     | ITS (16S–23S) | **ITS1** + **ITS2** | Variable           | Principal en hongos; poco usado en procariotas |

> [!TIP]
> Cuando lea un artículo que menciona "análisis del gen 16S", recuerde que se refiere al gen que codifica el rRNA de la subunidad pequeña del ribosoma **procariota**. Si el organismo es un hongo, busque ITS; si es un animal, COI; si es una planta, matK/rbcL.

Con este contexto, veamos los marcadores específicos más usados:

* #### Gen 16S rRNA (procariotas)

El gen que codifica la subunidad pequeña del **ARN ribosomal 16S** (~1,500 pb) es el marcador molecular más utilizado en microbiología. Está presente en **todas las bacterias y arqueas**, contiene **9 regiones hipervariables** (V1–V9) flanqueadas por regiones conservadas, y tiene una enorme base de datos de referencia.

Se usa para:
- **identificación taxonómica** de bacterias;
- estudios de **diversidad microbiana** (metagenómica amplificada);
- establecer **relaciones filogenéticas** entre especies y géneros.

> [!NOTE]
> Las regiones conservadas permiten diseñar **primers universales** que amplifican el gen en prácticamente cualquier bacteria. Las regiones variables son las que permiten distinguir entre especies o géneros.

* #### Gen 23S rRNA (procariotas)

Codifica la subunidad grande del ARN ribosomal (~2,900 pb). Es más largo que el 16S y contiene más información filogenética, pero su base de datos de referencia es más pequeña. Se usa como complemento del 16S cuando este no tiene suficiente resolución.

* #### Región ITS (hongos y eucariotas)

La región **ITS** (*Internal Transcribed Spacer*) es el marcador más utilizado para la identificación y filogenia de **hongos**. Se encuentra entre los genes 18S y 28S del ARN ribosomal. Es altamente variable entre especies (más que el 16S entre bacterias), lo que le da buena resolución a nivel de especie.

Para hongos, ITS se considera el **código de barras oficial** (*DNA barcode*) desde 2012.

* #### Otros marcadores importantes

| Marcador                           | Grupo      | Características                                                                            |
|:-----------------------------------|:-----------|:-------------------------------------------------------------------------------------------|
| **18S rRNA**                       | Eucariotas | Equivalente al 16S en eucariotas; menor resolución a nivel de especie                      |
| **rpoB**                           | Bacterias  | Gen de la ARN polimerasa; útil cuando el 16S no distingue entre especies cercanas          |
| **gyrB**                           | Bacterias  | Gen de la girasa; buena resolución intraespecífica                                         |
| **recA**                           | Bacterias  | Gen de recombinación; usado frecuentemente en *Burkholderia* y otros géneros problemáticos |
| **COI** (*cytochrome c oxidase I*) | Animales   | El "código de barras" de animales; gen mitocondrial                                        |
| **matK / rbcL**                    | Plantas    | Genes de cloroplasto; usados como códigos de barras en plantas                             |

### 1.2 Bases de datos para búsqueda de marcadores

No todas las bases de datos son iguales. La elección de la base de datos correcta en BLAST afecta directamente la calidad de sus resultados:

#### Bases de datos generales del NCBI

| Base de datos                    | Contenido                                        | ¿Cuándo usarla?                                                                |
|:---------------------------------|:-------------------------------------------------|:-------------------------------------------------------------------------------|
| **nr** (*non-redundant protein*) | Todas las secuencias de proteínas no redundantes | Búsqueda de proteínas homólogas (`blastp`, `blastx`)                           |
| **nt** (*nucleotide collection*) | Todas las secuencias de nucleótidos del NCBI     | Búsqueda general de nucleótidos (`blastn`); incluye genomas, genes, ESTs, etc. |
| **refseq_rna**                   | ARNs de referencia curados (RefSeq)              | Cuando busca específicamente transcritos o ARN ribosomales curados             |

#### Bases de datos especializadas para marcadores

| Base de datos                          | Marcador           | Enlace                        | Ventaja                                               |
|:---------------------------------------|:-------------------|:------------------------------|:------------------------------------------------------|
| **SILVA**                              | 16S, 18S, 23S rRNA | https://www.arb-silva.de/     | Curada, con taxonomía alineada; la más usada para 16S |
| **RDP** (*Ribosomal Database Project*) | 16S rRNA           | https://rdp.cme.msu.edu/      | Clasificación taxonómica con intervalos de confianza  |
| **Greengenes2**                        | 16S rRNA           | https://greengenes2.ucsd.edu/ | Integrada con herramientas de metagenómica (QIIME 2)  |
| **UNITE**                              | ITS (hongos)       | https://unite.ut.ee/          | La referencia estándar para identificación fúngica    |
| **BOLD**                               | COI (animales)     | https://www.boldsystems.org/  | DNA barcoding animal con datos morfológicos asociados |

#### ¿Cuándo usar `nt` y cuándo una base de datos especializada?

- **Use `nt`** cuando no sabe qué tiene y quiere una búsqueda exploratoria amplia, o cuando trabaja con genes que no son marcadores ribosomales.
- **Use `refseq_rna`** o **16S rRNA sequences** (disponible como opción en BLAST web del NCBI) cuando sabe que tiene un gen ribosomal y quiere resultados más limpios y mejor curados.
- **Use SILVA, RDP o UNITE** cuando necesita una clasificación taxonómica precisa con asignación de confianza, especialmente para estudios de comunidades microbianas.

> [!TIP]
> En el BLAST web del NCBI, al seleccionar `blastn`, puede elegir la base de datos **"16S ribosomal RNA sequences (Bacteria and Archaea)"** directamente. Esto restringe la búsqueda a secuencias 16S curadas y evita que aparezcan genomas completos o secuencias genómicas donde el 16S está sin anotar.

### 1.3 ¿Por qué un BLAST del gen 16S rRNA NO es suficiente para determinar género y especie?

Esta es una de las confusiones más comunes en microbiología y bioinformática, y merece una explicación detallada.

#### El escenario típico

Usted secuencia el gen 16S rRNA de una bacteria aislada de una muestra clínica o ambiental. Hace un BLAST contra la base de datos `nt` o `16S ribosomal RNA` del NCBI. El primer resultado dice:

```text
Klebsiella pneumoniae strain XYZ    99.5% identity    E-value: 0.0    Query coverage: 100%
```

La tentación inmediata es concluir: *"Mi bacteria es Klebsiella pneumoniae"*. Pero esa conclusión **puede ser incorrecta** por varias razones fundamentales:

#### Razón 1: El 16S rRNA no tiene suficiente resolución a nivel de especie

El gen 16S es excelente para distinguir entre **familias** y **géneros** lejanos, pero muchas especies cercanamente emparentadas tienen secuencias 16S **casi idénticas** (>99% de identidad). Esto ocurre porque el 16S evoluciona lentamente — que es precisamente lo que lo hace útil como marcador universal, pero también lo que limita su resolución.

Ejemplos bien documentados:

| Grupo                                                 | Problema                                                                 |
|:------------------------------------------------------|:-------------------------------------------------------------------------|
| *Escherichia coli* y *Shigella* spp.                  | Comparten >99% de identidad en 16S, pero son clínicamente muy diferentes |
| *Bacillus cereus*, *B. anthracis*, *B. thuringiensis* | Prácticamente indistinguibles por 16S (~99.5–100%)                       |
| *Streptococcus pneumoniae* y *S. mitis*               | 16S >99% idéntico                                                        |
| *Mycobacterium abscessus* y *M. chelonae*             | Resolución insuficiente del 16S                                          |
| *Burkholderia* complex                                | Numerosas especies con 16S casi idéntico                                 |

#### Razón 2: BLAST busca similitud, no identifica

BLAST le dice cuánto se **parece** su secuencia a las que están en la base de datos. No le dice que su organismo **es** esa especie. Hay varias fuentes de error:

- **La base de datos puede tener secuencias mal clasificadas**: hay un porcentaje no despreciable de secuencias 16S en GenBank con asignaciones taxonómicas incorrectas, ya que muchas fueron depositadas sin verificación experimental rigurosa.
- **El mejor hit puede no ser el más cercano filogenéticamente**: BLAST optimiza por score, no por filogenia. Dos secuencias pueden compartir alto porcentaje de identidad por convergencia o por cobertura parcial.
- **El porcentaje de identidad depende del fragmento secuenciado**: si usted secuenció solo la región V3–V4 (~450 pb) y su BLAST reporta 99%, esa identidad se calcula solo sobre ese fragmento. La misma comparación con el gen completo podría dar un valor diferente.

#### Razón 3: Umbrales de identidad son guías, no reglas

Se suelen citar estos umbrales para 16S:

| Identidad 16S | Interpretación comúnmente citada |
|:--------------|:---------------------------------|
| ≥97%          | Posiblemente la misma especie    |
| ≥95%          | Posiblemente el mismo género     |
| <95%          | Probablemente géneros diferentes |

Pero estos umbrales son **aproximaciones estadísticas** establecidas hace décadas. Hay especies diferentes con >99% de identidad en 16S, y hay variantes intraespecíficas con <97%. Además, el umbral de 97% fue calibrado para el gen completo (~1,500 pb); con fragmentos parciales, los valores son menos confiables.

#### Razón 4: Las copias múltiples del 16S varían dentro de un mismo genoma

Muchas bacterias tienen **múltiples copias** del operón ribosomal (desde 1 en *Mycobacterium* hasta 15 en *Photobacterium*). Estas copias no siempre son idénticas entre sí: puede haber diferencias de hasta 1–2% entre copias dentro de un mismo genoma. Esto significa que la "identidad" que observa puede estar comparando diferentes copias, no diferentes organismos.

#### ¿Entonces para qué sirve el BLAST del 16S?

El BLAST del 16S **sí es útil**, pero como **primera aproximación**, no como veredicto final:

| BLAST del 16S sirve para...                                                     | BLAST del 16S NO sirve para...                                 |
|:--------------------------------------------------------------------------------|:---------------------------------------------------------------|
| Ubicar su organismo en un contexto taxonómico amplio (familia, género probable) | Asignar especie con certeza                                    |
| Descartar candidatos claramente diferentes (<95% identidad)                     | Distinguir entre especies con 16S casi idéntico                |
| Identificar el grupo de organismos para un análisis más detallado               | Reemplazar un análisis filogenético formal                     |
| Punto de partida para seleccionar secuencias de referencia para un árbol        | Publicar una identificación taxonómica sin evidencia adicional |

#### ¿Qué hacer entonces?

La respuesta correcta es: **construir un árbol filogenético**, que es exactamente lo que aprenderá en este módulo. Un árbol filogenético con múltiples secuencias de referencia, un alineamiento curado, un modelo de sustitución adecuado y evaluación por bootstrap es **mucho más informativo** que un simple BLAST, porque:

- considera **todas las posiciones** del alineamiento simultáneamente, no solo un score global;
- evalúa la relación de su secuencia **con múltiples especies**, no solo con el mejor hit;
- permite visualizar si su secuencia cae **dentro** de un clado o **entre** clados;
- proporciona **valores de soporte** que indican la confianza del agrupamiento.

### 1.4 Más allá del 16S: ANI y genómica comparada

Para los casos donde el 16S no tiene resolución suficiente, la solución moderna es comparar **genomas completos**:

#### ANI (*Average Nucleotide Identity*)

El **ANI** calcula el porcentaje promedio de identidad de nucleótidos entre dos genomas completos, considerando solo las regiones ortólogas compartidas. Es actualmente el **estándar de oro** para la delimitación de especies procariotas.

| ANI     | Interpretación                    |
|:--------|:----------------------------------|
| ≥95–96% | Misma especie                     |
| 90–95%  | Mismo género, diferentes especies |
| <90%    | Géneros diferentes                |

El umbral de ~95% ANI corresponde aproximadamente al concepto clásico de >70% de hibridación ADN-ADN, que fue durante décadas el estándar para definir especies bacterianas.

#### Herramientas para ANI

| Herramienta                     | Tipo              | Enlace                               |
|:--------------------------------|:------------------|:-------------------------------------|
| **JSpeciesWS**                  | Web               | https://jspecies.rivm.nl/            |
| **ANI Calculator (EzBioCloud)** | Web               | https://www.ezbiocloud.net/tools/ani |
| **fastANI**                     | Línea de comandos | https://github.com/ParBLiSS/FastANI  |
| **pyani**                       | Python            | https://github.com/widdowquinn/pyani |

#### MLST (*Multi-Locus Sequence Typing*)

Otra alternativa es el **MLST**, que compara fragmentos de **múltiples genes housekeeping** (típicamente 7) en lugar de un solo marcador. Cada combinación única de alelos define un **sequence type** (ST). El MLST tiene mucha mejor resolución que el 16S para distinguir entre cepas dentro de una especie y es ampliamente usado en epidemiología hospitalaria.

#### ¿Cuándo usar cada enfoque?

| Situación                                           | Enfoque recomendado                                                      |
|:----------------------------------------------------|:-------------------------------------------------------------------------|
| Primera aproximación, no tengo genoma completo      | BLAST 16S + árbol filogenético                                           |
| Necesito identificar a nivel de especie             | Árbol filogenético con múltiples marcadores o ANI si tengo genoma        |
| Necesito distinguir entre cepas de la misma especie | MLST o SNP analysis con genoma completo                                  |
| Estudio de diversidad en comunidad microbiana       | Amplicón 16S con base de datos curada (SILVA, RDP)                       |
| Hongos                                              | ITS + árbol filogenético (complementar con TEF1α o RPB2 si es necesario) |
| Publicación científica                              | Árbol filogenético con bootstrap + ANI si hay genomas disponibles        |

> [!IMPORTANT]
> La regla general es: **un solo gen, un solo método, una sola herramienta** casi nunca es suficiente para una identificación taxonómica confiable a nivel de especie. La filogenética le da contexto, el ANI le da precisión, y la combinación de ambos le da confianza. Un BLAST es el punto de partida, no el punto de llegada.

---

## 2. Antes de las secuencias: construir un árbol a mano

Antes de trabajar con secuencias de ADN y software especializado, es fundamental entender **la lógica detrás de un árbol filogenético**. Y la mejor forma de entenderla es construir uno con las manos.

### 2.1 ¿Qué es un árbol filogenético?

Un **árbol filogenético** es un diagrama que representa las relaciones de parentesco evolutivo entre un conjunto de organismos (o genes, o proteínas). Los puntos donde las ramas se separan (**nodos**) representan ancestros comunes, y la longitud de las ramas puede representar la cantidad de cambio evolutivo o el tiempo transcurrido.

Componentes básicos de un árbol:

```text
         ┌── Especie A
    ┌────┤
    │    └── Especie B
────┤
    │    ┌── Especie C
    └────┤
         └── Especie D
```

| Elemento           | ¿Qué representa?                                                            |
|:-------------------|:----------------------------------------------------------------------------|
| **Hojas** (puntas) | Los organismos actuales que se están comparando                             |
| **Nodos internos** | Ancestros comunes hipotéticos                                               |
| **Ramas**          | Líneas evolutivas; su longitud puede indicar divergencia                    |
| **Raíz**           | El ancestro común más antiguo de todo el grupo (si el árbol está enraizado) |
| **Clado**          | Un ancestro y todos sus descendientes (un "grupo natural")                  |

### 2.2 Ejemplo práctico: un árbol con caracteres morfológicos

Vamos a construir un árbol filogenético sin usar ningún software ni secuencias de ADN. Solo necesitamos una tabla de **caracteres** (presencia/ausencia de rasgos) y lógica.

#### Los datos

Tenemos cinco animales vertebrados y cinco caracteres morfológicos:

| Carácter   | Lamprea | Robalo | Caimán | Águila calva | Antílope |
|:-----------|:-------:|:------:|:------:|:------------:|:--------:|
| Mandíbulas |    —    |   ✓    |   ✓    |      ✓       |    ✓     |
| Pulmones   |    —    |   —    |   ✓    |      ✓       |    ✓     |
| Molleja    |    —    |   —    |   ✓    |      ✓       |    —     |
| Plumas     |    —    |   —    |   —    |      ✓       |    —     |
| Pelo       |    —    |   —    |   —    |      —       |    ✓     |

> [!TIP]
> El orden de las columnas se ha reorganizado para reflejar la adquisición progresiva de caracteres. La lamprea es el organismo con menos caracteres derivados (sin mandíbulas, sin pulmones) y servirá como **grupo externo** (*outgroup*).

#### Paso 1: Identificar el grupo externo

La **lamprea** es el único organismo sin mandíbulas. Como todos los demás sí las tienen, la lamprea representa la condición más ancestral. Esto la convierte en el **outgroup**, el punto de referencia a partir del cual se enraíza el árbol.

#### Paso 2: Agrupar por caracteres compartidos

Ahora buscamos **caracteres derivados compartidos** (*sinapomorfias*) que permitan agrupar organismos:

1. **Mandíbulas** → presentes en robalo, caimán, águila y antílope, pero no en lamprea. Esto agrupa a los cuatro como un clado (los **gnatóstomos**).

2. **Pulmones** → presentes en caimán, águila y antílope, pero no en robalo. Esto agrupa a estos tres en un subgrupo (los **tetrápodos**).

3. **Molleja** → presente en caimán y águila, pero no en antílope. Esto agrupa a caimán y águila más cerca entre sí (los **arcosaurios**).

4. **Plumas** → presentes solo en el águila. Es un carácter **autapomórfico** (exclusivo de una sola línea), así que no agrupa, pero confirma la identidad del águila dentro de los arcosaurios.

5. **Pelo** → presente solo en antílope. Otro carácter autapomórfico que define a los mamíferos.

#### Paso 3: Construir el árbol

Con esta lógica, el árbol se construye de afuera hacia adentro:

```text
                            ┌─── Águila calva     [Mandíbulas, Pulmones, Molleja, Plumas]
                     ┌──────┤
                     │      └─── Caimán           [Mandíbulas, Pulmones, Molleja]
              ┌──────┤
              │      └────────── Antílope          [Mandíbulas, Pulmones, Pelo]
       ┌──────┤
       │      └──────────────── Robalo             [Mandíbulas]
───────┤
       └────────────────────── Lamprea             [— (grupo externo)]
```

Leído de abajo hacia arriba:
- La **lamprea** se separa primero: es la más distinta.
- El **robalo** se separa después: tiene mandíbulas pero no pulmones.
- El **antílope** se separa del grupo caimán-águila: comparten pulmones pero difieren en molleja.
- El **caimán** y el **águila** son los más cercanos: comparten mandíbulas, pulmones y molleja.

#### Paso 4: Interpretar

Este árbol nos dice que:

- El **águila** y el **caimán** están más emparentados entre sí que cualquiera de los dos con el antílope. Esto es contraintuitivo para muchas personas (¡un ave y un reptil más cercanos que un mamífero!), pero es lo que los datos morfológicos indican — y lo que la filogenia molecular ha confirmado.
- El **antílope** (mamífero) se separó de la línea reptil-ave antes de que aparecieran la molleja y las plumas.
- La **lamprea** es el organismo más basal: no tiene ninguno de los caracteres derivados del grupo.

> [!IMPORTANT]
> Esta es exactamente la misma lógica que se usa con secuencias de ADN, solo que en lugar de "tiene mandíbulas / no tiene mandíbulas" se usa "tiene una A en la posición 150 / tiene una G en la posición 150". Los caracteres cambian, pero el razonamiento es el mismo.

### 2.3 Conceptos clave del ejemplo

| Concepto         | Significado                                             | En el ejemplo                                                                               |
|:-----------------|:--------------------------------------------------------|:--------------------------------------------------------------------------------------------|
| **Outgroup**     | Organismo de referencia para enraizar el árbol          | Lamprea                                                                                     |
| **Sinapomorfia** | Carácter derivado compartido que define un grupo        | Pulmones (define tetrápodos)                                                                |
| **Autapomorfia** | Carácter derivado exclusivo de una línea                | Plumas (solo águila)                                                                        |
| **Clado**        | Grupo que incluye un ancestro y todos sus descendientes | Caimán + águila = arcosaurios                                                               |
| **Homoplasia**   | Similitud que NO refleja ancestro común (convergencia)  | No aparece en este ejemplo, pero sería como si la lamprea tuviera plumas independientemente |

### 2.4 Del papel al ADN

Lo que acaba de hacer a mano es conceptualmente idéntico a lo que hará con software:

| A mano (este ejercicio)            | Con software (resto del módulo)            |
|:-----------------------------------|:-------------------------------------------|
| Tabla de caracteres morfológicos   | Alineamiento múltiple de secuencias        |
| Presencia/ausencia de rasgos       | Nucleótidos en cada posición (A, T, G, C)  |
| Agrupar por caracteres compartidos | Calcular distancias o evaluar modelos      |
| Dibujar el árbol en papel          | Construir el árbol con NJ, ML o parsimonia |

La diferencia es que con secuencias de ADN tiene **cientos o miles de "caracteres"** (posiciones del alineamiento), lo que hace imposible hacerlo a mano pero mucho más robusto estadísticamente.

---

## 3. Alineamiento Múltiple de Secuencias (MSA)

### 3.1 ¿Qué es un MSA y por qué es necesario?

En el Módulo 3 aprendió a alinear **dos secuencias** (alineamiento *pairwise*). Un **alineamiento múltiple de secuencias** (*Multiple Sequence Alignment*, MSA) extiende esto a **tres o más secuencias simultáneamente**.

El MSA es el **primer paso obligatorio** en cualquier análisis filogenético molecular. Sin un buen alineamiento, todo lo que viene después — distancias, modelos, árboles — estará distorsionado.

```text
Secuencia 1:   A T G C G A - T C G
Secuencia 2:   A T G C - A A T C G
Secuencia 3:   A T G C G A A T C A
Secuencia 4:   A T G C G A - T C G
               * * * *     * * *
```

Cada **columna** del MSA representa una posición homóloga: las bases en esa columna descienden, en principio, de la misma posición en el ancestro común. Las columnas conservadas (marcadas con `*`) son las más informativas para confirmar homología; las columnas variables son las más informativas para distinguir entre organismos.

### 3.2 ¿Por qué no simplemente hacer todos los alineamientos de a pares?

Alinear secuencias de a pares y luego "juntarlas" no funciona bien porque:

- un gap insertado en un alineamiento de dos secuencias puede ser **inconsistente** con el gap necesario en otro par;
- no hay garantía de que las posiciones homólogas queden alineadas de forma coherente en todas las secuencias;
- el MSA busca una solución **globalmente óptima**, no una colección de óptimos locales.

### 3.3 ¿Cómo se construye un MSA?

Construir un MSA óptimo de forma exacta es un problema computacionalmente imposible para más de unas pocas secuencias (la complejidad crece exponencialmente). Por eso se usan **heurísticas**, siendo la más común el enfoque **progresivo**:

#### Estrategia progresiva (Clustal, MUSCLE, MAFFT)

1. **Alinear todos los pares** de secuencias y calcular una puntuación de similitud entre cada par.
2. **Construir un árbol guía** (*guide tree*) a partir de esas distancias, que indica cuáles secuencias son más similares.
3. **Alinear progresivamente**: primero las secuencias más similares, luego se van incorporando las más distantes siguiendo el orden del árbol guía.

```text
Secuencias: A, B, C, D

Paso 1: Comparar todos los pares → A-B muy similares, C intermedia, D más distante
Paso 2: Árbol guía:
            ┌── A
         ┌──┤
         │  └── B
      ┌──┤
      │  └───── C
   ───┤
      └──────── D

Paso 3: Alinear A+B → luego agregar C → luego agregar D
```

> [!WARNING]
> El árbol guía NO es el árbol filogenético final. Es solo un recurso para decidir el orden del alineamiento. El árbol final se construirá después, a partir del MSA completo.

### 3.4 Herramientas para MSA

| Herramienta                  | Características                                                                  | Enlace                                         |
|:-----------------------------|:---------------------------------------------------------------------------------|:-----------------------------------------------|
| **ClustalW / Clustal Omega** | Método clásico; Omega es la versión moderna, rápida para muchas secuencias       | https://www.ebi.ac.uk/jdispatcher/msa/clustalo |
| **MUSCLE**                   | Rápido y preciso; buena opción general                                           | https://www.ebi.ac.uk/jdispatcher/msa/muscle   |
| **MAFFT**                    | Muy versátil; excelente para conjuntos grandes o secuencias muy divergentes      | https://mafft.cbrc.jp/alignment/server/        |
| **T-Coffee**                 | Combina información de múltiples métodos; más lento pero a menudo más preciso    | https://tcoffee.crg.eu/                        |
| **MEGA**                     | Incluye ClustalW y MUSCLE integrados; ideal para el flujo completo (MSA → árbol) | https://www.megasoftware.net/                  |

### 3.5 ¿Cómo evaluar un MSA?

Un MSA no se acepta "tal cual sale del programa". Debe revisarse:

- **Columnas con demasiados gaps**: pueden indicar regiones mal alineadas o difíciles de alinear.
- **Regiones de baja confianza**: zonas donde las secuencias son tan divergentes que el alineamiento es ambiguo.
- **Inspección visual**: siempre mire el alineamiento antes de continuar. Software como **MEGA**, **AliView** o **Jalview** permiten visualizarlo.

> [!TIP]
> En la práctica, a veces es necesario **recortar** (*trim*) las regiones mal alineadas antes de construir el árbol. Herramientas como **trimAl** o **Gblocks** automatizan este paso.

---

## 4. Modelos de sustitución

### 4.1 ¿Por qué no basta con contar diferencias?

Si dos secuencias difieren en 10 posiciones de 100, podríamos decir que tienen un 10% de diferencia. Pero eso subestima la distancia real, porque:

- una posición puede haber cambiado **más de una vez** (por ejemplo, A → G → A, lo que parece "sin cambio" pero tuvo dos sustituciones);
- no todas las sustituciones son igual de probables (las **transiciones** A↔G, C↔T son más frecuentes que las **transversiones** A↔C, A↔T, G↔C, G↔T);
- la frecuencia de cada nucleótido en el genoma varía entre organismos.

Los **modelos de sustitución** corrigen estos sesgos y estiman la distancia evolutiva "real" entre secuencias.

### 4.2 Tipos de sustituciones

Antes de ver los modelos, es importante distinguir:

- **Transiciones**: cambios entre purinas (A ↔ G) o entre pirimidinas (C ↔ T). Son más frecuentes porque implican cambios entre bases de estructura química similar.
- **Transversiones**: cambios entre una purina y una pirimidina (A ↔ C, A ↔ T, G ↔ C, G ↔ T). Son menos frecuentes.

```text
         Purinas          Pirimidinas
        ┌───────┐        ┌───────┐
        │ A ↔ G │        │ C ↔ T │
        └───────┘        └───────┘
         Transiciones      Transiciones

        A ↔ C,  A ↔ T,  G ↔ C,  G ↔ T
                Transversiones
```

### 4.3 Modelos comunes (de menor a mayor complejidad)

| Modelo                            | Parámetros | Supuestos principales                                                                       |
|:----------------------------------|:-----------|:--------------------------------------------------------------------------------------------|
| **JC69** (Jukes-Cantor)           | 1          | Todas las sustituciones son igual de probables; frecuencias de bases iguales (25% cada una) |
| **K2P** (Kimura 2-parámetros)     | 2          | Distingue transiciones de transversiones; frecuencias iguales                               |
| **HKY85** (Hasegawa-Kishino-Yano) | 5          | Distingue transiciones de transversiones Y permite frecuencias de bases desiguales          |
| **GTR** (General Time Reversible) | 9          | Cada tipo de sustitución tiene su propia tasa; frecuencias libres. Es el más general        |

#### ¿Cuál elegir?

- Para un análisis rápido con secuencias similares → **JC69** o **K2P** suelen ser suficientes.
- Para análisis más rigurosos → **HKY85** o **GTR**.
- Muchos programas pueden **seleccionar el modelo automáticamente** usando criterios estadísticos (AIC, BIC). MEGA, por ejemplo, tiene la opción "Find Best DNA/Protein Models".

> [!TIP]
> No necesita memorizar las fórmulas de cada modelo. Lo importante es entender que cada modelo hace **supuestos sobre cómo evoluciona el ADN**, y que un modelo más complejo no siempre es mejor — puede sobreajustar si tiene pocas secuencias.

### 4.4 Parámetros adicionales

Además del modelo base, algunos análisis incluyen:

- **Proporción de sitios invariantes (+I)**: asume que una fracción de posiciones no cambia nunca (por ejemplo, sitios esenciales para la función de una proteína).
- **Variación entre sitios (+G, distribución gamma)**: asume que diferentes posiciones evolucionan a velocidades diferentes. Esto es biológicamente muy realista.

Cuando vea algo como **GTR+G+I**, significa: modelo GTR con variación de tasas entre sitios (gamma) y proporción de sitios invariantes.

---

## 5. Métodos de construcción de árboles

### 5.1 Clasificación general

Los métodos se dividen en dos grandes familias:

| Familia                   | Métodos principales                                                     | ¿Cómo funcionan?                                                             |
|:--------------------------|:------------------------------------------------------------------------|:-----------------------------------------------------------------------------|
| **Basados en distancias** | Neighbor-Joining (NJ), UPGMA                                            | Calculan una matriz de distancias entre todas las secuencias y luego agrupan |
| **Basados en caracteres** | Máxima Parsimonia (MP), Máxima Verosimilitud (ML), Inferencia Bayesiana | Evalúan directamente las posiciones del alineamiento para inferir el árbol   |

### 5.2 Neighbor-Joining (NJ)

Es el método basado en distancias más utilizado. Fue propuesto por Saitou y Nei en 1987.

#### ¿Cómo funciona?

1. Se calcula una **matriz de distancias** entre todos los pares de secuencias (usando un modelo de sustitución).
2. Se busca el par de secuencias que, al agruparse, **minimiza la longitud total del árbol**.
3. Se reemplaza ese par por un nodo nuevo y se recalcula la matriz.
4. Se repite hasta que solo queda un nodo.

#### Ventajas y limitaciones

| Ventajas                               | Limitaciones                                                 |
|:---------------------------------------|:-------------------------------------------------------------|
| Muy rápido                             | Solo produce **un** árbol (no evalúa alternativas)           |
| Funciona bien con secuencias similares | Al comprimir la información en distancias, se pierde detalle |
| Ideal para conjuntos grandes           | No usa un criterio de optimalidad estadístico                |
| Buen punto de partida                  | Puede ser impreciso con secuencias muy divergentes           |

### 5.3 Máxima Parsimonia (MP)

El principio de parsimonia dice: **el mejor árbol es el que requiere el menor número de cambios evolutivos** para explicar los datos.

#### ¿Cómo funciona?

1. Para cada posible topología de árbol, se cuenta cuántos cambios (sustituciones) se necesitan para explicar el alineamiento.
2. Se elige la topología que requiere **menos cambios**.

#### Ventajas y limitaciones

| Ventajas                              | Limitaciones                                                                             |
|:--------------------------------------|:-----------------------------------------------------------------------------------------|
| Intuitivo y fácil de entender         | Puede ser inconsistente con tasas de evolución muy desiguales (*long-branch attraction*) |
| No requiere un modelo de sustitución  | Es lento para muchas secuencias (explora muchas topologías)                              |
| Bueno para datos con poca divergencia | Asume implícitamente que la evolución es parsimoniosa, lo cual no siempre es cierto      |

> [!NOTE]
> *Long-branch attraction* es un artefacto donde dos linajes que evolucionan rápidamente se agrupan juntos en el árbol, aunque en realidad no estén cercanamente emparentados. Ocurre porque ambos acumulan muchos cambios y algunos coinciden por azar.

### 5.4 Máxima Verosimilitud (ML)

Es el método más robusto y ampliamente utilizado hoy en día. Fue introducido por Felsenstein en 1981.

#### ¿Cómo funciona?

1. Se propone una topología de árbol con longitudes de ramas.
2. Dado un **modelo de sustitución**, se calcula la **probabilidad de observar el alineamiento** si ese árbol fuera el verdadero.
3. Se prueba con muchas topologías y longitudes de ramas.
4. Se elige el árbol que **maximiza la verosimilitud** (la probabilidad de los datos dado el modelo).

#### Ventajas y limitaciones

| Ventajas                                                  | Limitaciones                                        |
|:----------------------------------------------------------|:----------------------------------------------------|
| Estadísticamente riguroso                                 | Computacionalmente intensivo                        |
| Incorpora modelos de sustitución explícitos               | Requiere elegir un modelo adecuado                  |
| Robusto frente a artefactos como *long-branch attraction* | Para muchas secuencias puede tardar horas o días    |
| Permite comparar árboles con tests estadísticos           | La interpretación requiere más conocimiento teórico |

### 5.5 Comparación rápida de métodos

| Criterio                    | NJ                                    | MP                                      | ML                              |
|:----------------------------|:--------------------------------------|:----------------------------------------|:--------------------------------|
| **Velocidad**               | ⚡⚡⚡ Muy rápido                        | ⚡ Lento                                 | ⚡⚡ Moderado                     |
| **Modelo de sustitución**   | Sí (para las distancias)              | No                                      | Sí (explícito)                  |
| **Criterio de optimalidad** | Mínima longitud total                 | Mínimo número de cambios                | Máxima probabilidad             |
| **Robustez**                | Buena para secuencias similares       | Buena si hay poca divergencia           | La más robusta en general       |
| **Uso recomendado**         | Exploración rápida, conjuntos grandes | Datos morfológicos, secuencias cercanas | Análisis finales, publicaciones |

### 5.6 ¿Cómo saber si el árbol es confiable? — Bootstrap

Un árbol filogenético es una **hipótesis**, no una certeza. Para evaluar qué tan confiable es cada rama del árbol, se usa el **bootstrap**:

1. Se **re-muestrea** el alineamiento con reemplazo: se toman columnas al azar (con repetición) hasta tener un alineamiento del mismo tamaño que el original, pero con algunas columnas duplicadas y otras ausentes.
2. Se construye un árbol con ese alineamiento re-muestreado.
3. Se repite el proceso **cientos o miles de veces** (típicamente 100–1000).
4. Para cada rama del árbol original, se calcula en qué **porcentaje** de las réplicas apareció esa misma agrupación.

Ese porcentaje es el **valor de bootstrap**:

| Valor de bootstrap | Interpretación           |
|:-------------------|:-------------------------|
| ≥ 95%              | Soporte muy fuerte       |
| 70–95%             | Soporte moderado a bueno |
| 50–70%             | Soporte débil            |
| < 50%              | La rama no es confiable  |

```text
         ┌── E. coli cepa 1
    ┌─99─┤
    │    └── E. coli cepa 2
─78─┤
    │    ┌── Salmonella enterica
    └─85─┤
         └── Klebsiella pneumoniae
```

En este ejemplo, el agrupamiento de las dos cepas de *E. coli* tiene un soporte del 99% (muy robusto), mientras que el nodo que separa al clado *Salmonella*-*Klebsiella* tiene un 85% (bueno) y el nodo basal tiene un 78% (aceptable).

> [!WARNING]
> Un valor de bootstrap alto no demuestra que la relación sea "verdadera" en la naturaleza — solo indica que los datos respaldan consistentemente esa agrupación. Un bootstrap bajo puede significar que los datos son insuficientes o que la relación es genuinamente difícil de resolver.

---

## 6. Flujo de trabajo completo

Resumiendo todo el módulo, el flujo de trabajo estándar para un análisis filogenético molecular es:

```text
Secuencias (FASTA)
       │
       ▼
Alineamiento Múltiple (MSA)       ← ClustalW, MUSCLE, MAFFT
       │
       ▼
Inspección y recorte              ← AliView, trimAl
       │
       ▼
Selección de modelo               ← jModelTest, MEGA "Find Best Model"
       │
       ▼
Construcción del árbol            ← NJ (rápido), ML (robusto)
       │
       ▼
Evaluación (Bootstrap)            ← 100–1000 réplicas
       │
       ▼
Interpretación biológica          ← ¿Qué agrupa con qué? ¿Tiene sentido?
```

Cada paso depende del anterior: un MSA mal hecho producirá un árbol poco confiable, y un modelo inadecuado puede distorsionar las distancias. Por eso es importante entender la lógica completa, no solo el paso final.

---

## 7. Cierre conceptual

La filogenética conecta la comparación de secuencias (Módulo 3) con la interpretación biológica profunda: ¿de dónde viene este organismo? ¿Con quién está más emparentado? ¿Cuándo divergieron? ¿Cómo evolucionó este gen?

En este módulo ha aprendido:

- a construir un árbol a mano usando **caracteres morfológicos**, para entender la lógica antes del software;
- que un **MSA** es la base de todo análisis filogenético y que su calidad determina la calidad del resultado;
- que los **modelos de sustitución** corrigen sesgos en la medición de distancias evolutivas;
- que existen múltiples **métodos de construcción de árboles** y cada uno tiene fortalezas y limitaciones;
- que el **bootstrap** es la herramienta estándar para evaluar la confianza en cada rama.

En el **Módulo 5** (Secuenciación) entenderá cómo se generan los datos con los que aquí trabaja. En el **Módulo 6** (Genómica) aplicará todo esto a genomas completos. Y en la práctica de este módulo, construirá un árbol real con secuencias de 16S rRNA para identificar una bacteria desconocida.

> [!IMPORTANT]
> Un árbol filogenético es una hipótesis, no un hecho. Su fuerza depende de la calidad de los datos, la adecuación del modelo y la coherencia con otros tipos de evidencia.

---

## Prácticas del módulo

| Práctica                                                              | Descripción                                                                                                           |
|:----------------------------------------------------------------------|:----------------------------------------------------------------------------------------------------------------------|
| [Análisis filogenético con 16S rRNA](exercises/01_phylogenetics.md) | Alineamiento de secuencias 16S, construcción de árboles NJ y ML en MEGA, e identificación de una bacteria desconocida |

