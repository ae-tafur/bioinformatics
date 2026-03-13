# Módulo 3: Análisis de Secuencias

## Introducción

En el Módulo 1 aprendió a buscar y descargar secuencias en bases de datos públicas como el NCBI, y a distinguir formatos como FASTA y GenBank. En el Módulo 2 adquirió las herramientas para trabajar desde la terminal y programar en Python. Ahora, en este módulo, va a usar todo eso para hacer lo que un bioinformático hace la mayor parte del tiempo: **comparar secuencias**.

Comparar secuencias es, probablemente, la operación más fundamental en bioinformática. ¿Esa secuencia que acaba de obtener se parece a algo ya conocido? ¿Cuánto se parece? ¿En qué posiciones difiere? ¿Dónde poner un primer para amplificarla? Todas esas preguntas se responden comparando secuencias, y en este módulo aprenderá cómo hacerlo a nivel conceptual, algorítmico y práctico.

Trabajaremos con tres grandes bloques:

1. **BLAST**, la herramienta más utilizada en el mundo para buscar secuencias similares en bases de datos.
2. **Alineamiento de secuencias**, entendiendo los algoritmos de programación dinámica que permiten comparar dos secuencias de forma exacta.
3. **Diseño de primers y PCR *in silico***, donde la comparación de secuencias se aplica a un problema experimental concreto.

> [!NOTE]
> Saber comparar secuencias no es solo una habilidad técnica: es la base sobre la cual se construyen la filogenética, la genómica comparada, la detección de variantes y casi cualquier análisis bioinformático que haga en su carrera.

---

## Prerrequisitos y conexión con módulos previos

### Del Módulo 1

Ya conoce:
- qué es el **NCBI** y cómo buscar secuencias en **Nucleotide**, **Protein** y **Gene**;
- los formatos **FASTA** y **GenBank**, y qué información contiene cada uno;
- cómo descargar secuencias desde la web.

> [!NOTE]
> Si necesita repasar → [README del Módulo 1](../01-introduction/README.md) y [Práctica de bases de datos](../01-introduction/exercises/01_databases.md).

### Del Módulo 2

Ya sabe:
- moverse en la terminal Unix y manipular archivos con `grep`, `cut`, `sort`, pipes y redirección;
- programar en **Python**: variables, tipos de datos, condicionales, bucles, lectura de archivos y funciones;
- ejecutar scripts `.py` desde Codespaces.

> [!NOTE]
> Si necesita repasar → [README del Módulo 2](../02-coding-basics/README.md).

En este módulo usará Python para **implementar un algoritmo de alineamiento desde cero**, así que asegúrese de sentirse cómodo con listas, bucles anidados y funciones antes de continuar.

---

## 1. Búsqueda por similitud con BLAST

### 1.1 ¿Qué es BLAST y por qué es tan importante?

**BLAST** (*Basic Local Alignment Search Tool*) es la herramienta más utilizada en bioinformática para buscar secuencias similares en bases de datos. Fue publicada por Altschul *et al.* en 1990 y desde entonces se ha convertido en el equivalente bioinformático de un buscador web: usted le da una secuencia y BLAST le devuelve las secuencias más parecidas que existen en una base de datos.

> [!NOTE]
**Analogía:** imagine que tiene una frase en un idioma desconocido y quiere encontrar frases parecidas en una biblioteca con millones de libros. No puede leer cada libro completo, así que primero busca palabras clave coincidentes, luego extiende la comparación alrededor de esas coincidencias y finalmente evalúa cuáles son parecidos reales y cuáles son casualidades.

BLAST funciona exactamente así.

### 1.2 ¿Cómo funciona BLAST conceptualmente?

BLAST no compara su secuencia contra todas las secuencias de la base de datos base por base (eso sería demasiado lento). En cambio, usa una **estrategia heurística** en tres fases:

#### Fase 1 — Semillas (*seeding*)

BLAST divide su secuencia en fragmentos cortos (llamados "palabras" o *words*) y busca coincidencias exactas o casi exactas en la base de datos. Estas coincidencias iniciales se llaman **semillas** (*seeds*).

#### Fase 2 — Extensión

A partir de cada semilla, BLAST **extiende el alineamiento** en ambas direcciones, calculando una puntuación. Si la puntuación sube, sigue extendiendo. Si baja demasiado, se detiene.

#### Fase 3 — Evaluación estadística

Los alineamientos extendidos se evalúan para determinar si son **estadísticamente significativos** o si podrían haber ocurrido por azar.

> [!IMPORTANT]
> Esta estrategia hace que BLAST sea muy rápido, pero no garantiza encontrar el alineamiento óptimo en todos los casos. Para eso existen los algoritmos exactos como Smith-Waterman, que veremos más adelante.

### 1.3 Tipos de BLAST

Dependiendo de qué tipo de secuencia usted tiene (la *query*) y qué tipo de base de datos quiere buscar (el *subject*), BLAST ofrece diferentes programas:

| Programa    | Query                 | Base de datos         | ¿Cuándo usarlo?                                                         |
|:------------|:----------------------|:----------------------|:------------------------------------------------------------------------|
| **blastn**  | Nucleótidos           | Nucleótidos           | Buscar genes similares, identificar especies por 16S rRNA               |
| **blastp**  | Proteínas             | Proteínas             | Buscar proteínas homólogas, anotar funciones                            |
| **blastx**  | Nucleótidos (traduce) | Proteínas             | Tiene ADN y quiere buscar en bases de datos de proteínas                |
| **tblastn** | Proteínas             | Nucleótidos (traduce) | Buscar genes en genomas no anotados usando proteínas como query         |
| **tblastx** | Nucleótidos (traduce) | Nucleótidos (traduce) | Comparación traducida en ambas direcciones (más lento, menos frecuente) |

### 1.4 Interpretación de resultados

Cuando BLAST devuelve resultados, hay cuatro valores que debe aprender a interpretar:

| Parámetro             | ¿Qué mide?                                                                             | ¿Qué significa un "buen" valor?                                              |
|:----------------------|:---------------------------------------------------------------------------------------|:-----------------------------------------------------------------------------|
| **E-value**           | Probabilidad de encontrar ese alineamiento por azar en una base de datos de ese tamaño | Mientras más bajo, mejor. Un E-value < 1e-5 suele considerarse significativo |
| **Score (bit score)** | Puntuación normalizada del alineamiento                                                | Mientras más alto, mejor                                                     |
| **% Identity**        | Porcentaje de posiciones idénticas en el alineamiento                                  | Depende del contexto biológico                                               |
| **Query coverage**    | Qué porcentaje de su secuencia se alineó                                               | Un coverage bajo puede indicar que solo una parte de su secuencia es similar |

> [!WARNING]
> **Error frecuente:** un E-value bajo con un coverage del 10% puede significar que solo un dominio pequeño es similar, no que toda la proteína sea homóloga. Siempre mire los cuatro parámetros juntos.

### 1.5 BLAST en la práctica

BLAST se puede usar de dos formas principales:

- **BLAST web** en [https://blast.ncbi.nlm.nih.gov/](https://blast.ncbi.nlm.nih.gov/) — ideal para búsquedas rápidas y exploratorias.
- **BLAST en línea de comandos** — ideal para búsquedas automatizadas, grandes volúmenes de datos o bases de datos locales.

En este módulo trabajaremos principalmente con la versión web. La versión de línea de comandos se cubrirá cuando sea necesario en módulos posteriores.

---

## 2. Alineamiento de secuencias

### 2.1 ¿Qué es un alineamiento y por qué importa?

Un **alineamiento de secuencias** organiza dos (o más) secuencias una encima de otra para identificar posiciones equivalentes: coincidencias, diferencias, inserciones y deleciones.

Desde el punto de vista biológico, alinear secuencias permite:

- identificar genes **homólogos** (que comparten un ancestro común);
- detectar **mutaciones** entre variantes;
- encontrar **regiones conservadas** que probablemente tienen función importante;
- evaluar la **distancia evolutiva** entre organismos.

### 2.2 Matriz de puntos (*Dot Plot*)

Antes de hablar de algoritmos sofisticados, existe una herramienta visual sorprendentemente simple y poderosa para comparar dos secuencias: la **matriz de puntos** o *dot plot*.

#### ¿Cómo funciona?

Se colocan las dos secuencias en los ejes de una tabla (una en el eje horizontal y otra en el vertical). En cada celda donde las bases coinciden, se marca un punto. Al terminar, los patrones que emergen revelan la relación entre ambas secuencias **sin necesidad de realizar un alineamiento formal**.

#### Ejemplo básico

Comparemos las secuencias `ATGCGA` (horizontal) y `ATGCGA` (vertical) — es decir, una secuencia contra sí misma:

```text
        A   T   G   C   G   A
  A     •               •   •
  T         •
  G             •       •
  C                 •
  G             •       •
  A     •               •   •
```

La **diagonal principal** (de esquina superior izquierda a inferior derecha) aparece completa: esto confirma que las secuencias son idénticas. Pero también aparecen puntos fuera de la diagonal — estos revelan **repeticiones internas** (por ejemplo, la `G` aparece en dos posiciones, y lo mismo con la `A`).

#### ¿Qué patrones se pueden detectar?

El poder real del dot plot está en la interpretación visual de los patrones:

| Patrón en el dot plot | ¿Qué indica? |
|:--|:--|
| **Diagonal continua** | Región de alta similitud entre las dos secuencias |
| **Diagonal desplazada (paralela a la principal)** | Secuencia repetida o duplicación |
| **Diagonal perpendicular (anti-diagonal)** | Secuencia en complemento inverso (*palindrome* o repetición invertida) |
| **Ruptura en la diagonal** | Inserción, deleción o región divergente |
| **Múltiples diagonales cortas** | Repeticiones dispersas o baja complejidad |
| **Sin patrón claro** | Las secuencias no comparten similitud significativa |

#### Ejemplo con dos secuencias diferentes

Comparemos `ATGCATGC` consigo misma:

```text
          A   T   G   C   A   T   G   C
    A     •               •
    T         •               •
    G             •               •
    C                 •               •
    A     •               •
    T         •               •
    G             •               •
    C                 •               •
```

Aquí aparecen **dos diagonales paralelas**: la diagonal principal y otra desplazada exactamente 4 posiciones. Esto revela inmediatamente que la secuencia contiene una **repetición en tándem** (`ATGC` repetido dos veces), algo que sería menos evidente mirando solo el texto de la secuencia.

#### ¿Para qué se usa en la práctica?

La matriz de puntos es especialmente útil para:

- **Comparar un genoma o gen consigo mismo** → detectar repeticiones, duplicaciones y palíndromos.
- **Comparar dos genomas relacionados** → ver regiones conservadas, reordenamientos cromosómicos o inversiones.
- **Exploración inicial** antes de hacer un alineamiento formal → hacerse una idea rápida de cuánta similitud hay y dónde.
- **Visualizar resultados complejos** → un dot plot de dos genomas bacterianos puede revelar de un vistazo si son colineales o si hubo rearreglos.

#### Ventana y umbral (filtering)

En la práctica, un dot plot base por base genera mucho ruido (puntos aleatorios que no representan similitud real). Para filtrar ese ruido se usa una **ventana deslizante** (*window*): en lugar de marcar cada coincidencia individual, se marca un punto solo si al menos `X` de las `W` bases en una ventana de tamaño `W` coinciden.

Por ejemplo, con ventana `W=5` y umbral `X=4`:
- se evalúan bloques de 5 bases;
- solo se marca un punto si al menos 4 de las 5 coinciden.

Esto elimina las coincidencias aleatorias y deja solo las diagonales que representan **similitud real**.

#### Herramientas

- **Dotlet** (web, para secuencias cortas): https://dotlet.vital-it.ch/
- **Gepard** (Java, para genomas completos): https://cube.univie.ac.at/gepard
- **D-Genies** (web, para comparación de genomas grandes): https://dgenies.toulouse.inra.fr/

> [!TIP]
> El dot plot no le dice *cuál* es el mejor alineamiento, pero sí le da una **visión global** de la relación entre dos secuencias que ningún alineamiento individual puede ofrecer. Es como mirar un mapa antes de entrar a recorrer las calles.

### 2.3 Alineamiento global vs. local

Esta es una distinción fundamental:

#### Alineamiento global

Compara las secuencias **de extremo a extremo**, intentando alinear toda su longitud.

> [!TIP]
> **¿Cuándo usarlo?** Cuando ambas secuencias son del mismo gen o región y tienen longitudes similares.

```text
Secuencia 1:  A T G C G A T C G
Secuencia 2:  A T G C - A T C A
              * * * *   * * * ·
```

#### Alineamiento local

Busca solo la **mejor región de similitud** dentro de secuencias que pueden ser de longitud muy diferente.

> [!TIP]
> **¿Cuándo usarlo?** Cuando solo una parte de las secuencias comparte similitud (por ejemplo, un dominio dentro de una proteína larga, o una región conservada en un genoma).

```text
Secuencia 1:  ...xxxATGCGATCGxxx...
Secuencia 2:  ...yyyATGCGATCGyyy...
                    **********
              Solo esta región se reporta
```

En términos sencillos:

- **Global** = "comparemos todo con todo, de punta a punta"
- **Local** = "encontremos el mejor fragmento compartido"

> [!NOTE]
> BLAST usa alineamiento **local**. Por eso puede encontrar similitudes parciales entre secuencias muy diferentes.

### 2.4 Conceptos de scoring

Para decidir si un alineamiento es "bueno" o "malo", necesitamos un sistema de puntuación (*scoring*).

#### Match y mismatch

Para secuencias de ADN, lo más simple es asignar:
- un **premio** por cada coincidencia (*match*), por ejemplo **+1**;
- una **penalización** por cada diferencia (*mismatch*), por ejemplo **-1**.

#### Penalización por gap

Un **gap** (`-`) representa una inserción o deleción (*indel*). Si no penalizamos los gaps, el algoritmo podría introducir gaps innecesarios para maximizar las coincidencias.

Existen dos modelos principales:
- **Penalización lineal:** cada gap cuesta lo mismo (por ejemplo, **-2** por gap).
- **Penalización afín:** abrir un gap cuesta más que extenderlo. Esto es más biológicamente realista, porque una deleción de 5 bases consecutivas es un solo evento evolutivo, no cinco eventos independientes.

#### Matrices de sustitución (para proteínas)

En proteínas, no todas las sustituciones son iguales. Cambiar una leucina por una isoleucina (ambos aminoácidos hidrofóbicos) es menos "grave" que cambiar una leucina por un ácido aspártico (hidrofóbico → cargado). Las matrices **BLOSUM** y **PAM** capturan estas diferencias asignando puntuaciones distintas a cada par de aminoácidos.

Para ADN en este módulo, usaremos el esquema simple de match/mismatch/gap.

### 2.5 Algoritmo de Needleman-Wunsch (alineamiento global)

Este algoritmo, publicado en 1970, fue el primero en resolver el problema de alineamiento global de forma exacta usando **programación dinámica**.

#### ¿Qué es programación dinámica?

Es una estrategia de resolución de problemas que divide un problema grande en subproblemas más pequeños, los resuelve de forma ordenada y guarda los resultados intermedios para no repetir cálculos. En alineamiento, esto se traduce en llenar una **matriz** paso a paso.

#### Ejemplo paso a paso

Alineemos las secuencias `GCATG` y `GATTG` con:
- Match: **+1**
- Mismatch: **-1**
- Gap: **-2**

##### Paso 1: Crear la matriz

Se crea una tabla donde las filas representan una secuencia y las columnas la otra. La primera fila y columna se inicializan con penalizaciones acumuladas por gaps:

```text
        -     G     C     A     T     G
  -     0    -2    -4    -6    -8   -10
  G    -2
  A    -4
  T    -6
  T    -8
  G   -10
```

##### Paso 2: Llenar la matriz

Para cada celda, se calcula el máximo entre tres opciones:

1. **Diagonal** (viene de arriba-izquierda): la celda diagonal + match/mismatch.
2. **Arriba** (viene de la celda de arriba): la celda de arriba + gap.
3. **Izquierda** (viene de la celda de la izquierda): la celda de la izquierda + gap.

La celda guarda el **mejor valor** de los tres y una flecha que indica de dónde vino.

Ejemplo para la celda [G, G] (primera fila de datos, primera columna de datos):
- Diagonal: 0 + 1 (match G=G) = **1**
- Arriba: -2 + (-2) = -4
- Izquierda: -2 + (-2) = -4
- Resultado: **1** (viene de la diagonal)

La matriz completa:

```text
        -     G     C     A     T     G
  -     0    -2    -4    -6    -8   -10
  G    -2     1    -1    -3    -5    -7
  A    -4    -1     0     0    -2    -4
  T    -6    -3    -2    -1     1    -1
  T    -8    -5    -4    -3     0     0
  G   -10    -7    -6    -5    -2     1
```

##### Paso 3: Traceback

Desde la celda **inferior derecha** (valor = 1), se sigue el camino de flechas hacia la celda superior izquierda para reconstruir el alineamiento:

```text
G C A T G
G A-T G
* · · * *
```

Con un gap insertado:

```text
G C A T - G
G - A T T G
*   * *   *
```

> [!NOTE]
(El alineamiento exacto depende de cómo se resuelvan los empates en el traceback.)

> [!IMPORTANT]
> Lo importante no es memorizar los números, sino entender la lógica: cada celda representa **la mejor forma de alinear esas dos subsecuencias hasta ese punto**.

### 2.6 Algoritmo de Smith-Waterman (alineamiento local)

Publicado en 1981, es una modificación del Needleman-Wunsch con dos diferencias clave:

| Característica        | Needleman-Wunsch (global)                            | Smith-Waterman (local)                                     |
|:----------------------|:-----------------------------------------------------|:-----------------------------------------------------------|
| **Inicialización**    | Primera fila y columna con penalizaciones acumuladas | Primera fila y columna con **ceros**                       |
| **Valores negativos** | Se permiten                                          | Se reemplazan por **0** (nunca bajan de cero)              |
| **Traceback**         | Desde la celda **inferior derecha**                  | Desde la celda con el **valor más alto** en toda la matriz |
| **Fin del traceback** | Llega a la celda [0,0]                               | Se detiene al llegar a un **0**                            |

Usando las mismas secuencias `GCATG` y `GATTG`:

```text
        -     G     C     A     T     G
  -     0     0     0     0     0     0
  G     0     1     0     0     0     1
  A     0     0     0     1     0     0
  T     0     0     0     0     2     0
  T     0     0     0     0     1     1
  G     0     1     0     0     0     2
```

El valor más alto es **2** (aparece en dos celdas). El traceback desde la celda [T, T] con valor 2 reconstruye la mejor región local de similitud.

> [!NOTE]
> La diferencia es sutil pero poderosa: Smith-Waterman ignora las regiones que no aportan similitud, mientras que Needleman-Wunsch fuerza a alinear todo.

### 2.7 Identidad vs. similitud

Estos conceptos son diferentes y no deben usarse como sinónimos:

- **Identidad:** porcentaje de posiciones **exactamente iguales** en un alineamiento.
- **Similitud:** grado de semejanza que también considera **sustituciones conservadoras**, especialmente relevante en proteínas.

En **ADN**, generalmente se habla de **identidad** porque las bases no tienen propiedades químicas comparables entre sí (una A no "se parece" a una G como una leucina se parece a una isoleucina).

En **proteínas**, la **similitud** puede ser más informativa que la identidad, porque dos aminoácidos diferentes pueden cumplir funciones parecidas si comparten propiedades químicas.

### 2.8 De la teoría a la práctica: relación con BLAST

Ahora puede entender por qué BLAST es rápido pero no exacto:

- **Smith-Waterman** (local, exacto) examina **todas** las posiciones posibles → es lento para bases de datos grandes.
- **BLAST** (local, heurístico) usa semillas para saltar directamente a las zonas prometedoras y luego extiende → es mucho más rápido, pero puede perder similitudes débiles.

En la práctica, BLAST es suficiente para la mayoría de las búsquedas. Smith-Waterman se reserva para casos donde se necesita sensibilidad máxima.

---

## 3. Ejemplo de código: alineamiento en Python

### 3.1 Objetivo del ejercicio

El objetivo es que usted entienda el algoritmo de alineamiento "por dentro", no como una caja negra. Para eso, en la carpeta de ejercicios del módulo encontrará un script Python que implementa tanto **Needleman-Wunsch** (global) como **Smith-Waterman** (local) desde cero usando programación dinámica.

> [!NOTE]
> El script se encuentra en: [`exercises/code/alignment_dp.py`](./exercises/code/alignment_dp.py)

### 3.2 ¿Qué hace el script?

El script contiene:

1. **Función `needleman_wunsch(seq1, seq2, match, mismatch, gap)`**
   - Crea la matriz de scoring.
   - La llena usando las reglas de programación dinámica.
   - Realiza el traceback desde la esquina inferior derecha.
   - Devuelve el alineamiento global y la puntuación.

2. **Función `smith_waterman(seq1, seq2, match, mismatch, gap)`**
   - Similar, pero inicializa con ceros, no permite valores negativos y hace traceback desde el máximo.
   - Devuelve el mejor alineamiento local y la puntuación.

3. **Función `print_matrix(matrix, seq1, seq2)`**
   - Imprime la matriz de forma legible para que pueda verificar los cálculos a mano.

4. **Bloque principal**
   - Ejecuta ambos algoritmos con dos secuencias de ejemplo y muestra los resultados.

### 3.3 Cómo ejecutarlo

Desde la terminal de Codespaces:

```bash
cd exercises/code/
python3 alignment_dp.py
```

Salida esperada (ejemplo):

```text
=======================================================
  NEEDLEMAN-WUNSCH  (Global Alignment)
=======================================================

Sequences: 'GCATG' vs 'GATTG'
Scoring:   match=+1, mismatch=-1, gap=-2

Scoring matrix:
           -     G     C     A     T     G
     -     0    -2    -4    -6    -8   -10
     G    -2     1    -1    -3    -5    -7
     A    -4    -1     0     0    -2    -4
     T    -6    -3    -2    -1     1    -1
     T    -8    -5    -4    -3     0     0
     G   -10    -7    -6    -5    -2     1

Alignment:
  GCATG
  GATTG
  *..**

Score: 1
```

> [!NOTE]
> El script resuelve los empates del traceback tomando un solo camino. Si usted resolvió la matriz a mano y obtuvo un alineamiento diferente (por ejemplo, con gaps), puede ser igualmente correcto. Lo importante es que la **puntuación** coincida.

### 3.4 Extensiones sugeridas

Una vez que entienda cómo funciona el script, puede intentar:

- **Cambiar las secuencias** por otras más largas o con más diferencias.
- **Modificar los parámetros de scoring** (match, mismatch, gap) y observar cómo cambia el alineamiento.
- **Implementar penalización afín de gaps** (gap open vs. gap extension).
- **Comparar con Biopython:** usar `Bio.Align.PairwiseAligner` y verificar que los resultados coincidan.

```python
# Ejemplo con Biopython (si está instalado)
from Bio import Align

aligner = Align.PairwiseAligner()
aligner.mode = "global"
aligner.match_score = 1
aligner.mismatch_score = -1
aligner.open_gap_score = -2
aligner.extend_gap_score = -2

alignments = aligner.align("GCATG", "GATTG")
print(alignments[0])
```

---

## 4. Diseño de primers y PCR *in silico*

### 4.1 ¿Qué es un primer y por qué importa su diseño?

Un **primer** (cebador) es un oligonucleótido corto de ADN (~18–25 nt) que se une a una secuencia molde y permite iniciar la replicación en una PCR. El diseño de primers es una de las aplicaciones más directas de los conceptos de complementariedad de bases y alineamiento.

Diseñar un buen primer es un problema bioinformático: no basta con elegir cualquier secuencia corta. Hay que verificar que sea específica, que no forme estructuras secundarias y que funcione bien en las condiciones de la PCR.

### 4.2 Parámetros clave de un buen primer

| Parámetro                  | Recomendación                            | ¿Por qué?                                                     |
|:---------------------------|:-----------------------------------------|:--------------------------------------------------------------|
| **Longitud**               | 18–25 nt                                 | Equilibrio entre especificidad y eficiencia de unión          |
| **Contenido GC**           | 40–60%                                   | Estabilidad del dúplex primer-molde                           |
| **Tm**                     | 55–65 °C                                 | El par de primers debe tener Tm similares (diferencia ≤ 2 °C) |
| **Extremo 3'**             | Evitar desajustes; a veces un "GC clamp" | Crítico para la extensión por la polimerasa                   |
| **Auto-complementariedad** | Baja                                     | Evitar horquillas y dímeros de primer                         |
| **Tamaño del amplicón**    | 100–500 pb (PCR convencional)            | Productos muy largos son más difíciles de amplificar          |

### 4.3 Herramientas de diseño

- **Primer-BLAST** ([https://www.ncbi.nlm.nih.gov/tools/primer-blast/](https://www.ncbi.nlm.nih.gov/tools/primer-blast/)): diseña primers y evalúa especificidad contra bases de datos.
- **Primer3**: herramienta clásica para proponer pares de primers con restricciones configurables.

### 4.4 PCR *in silico* y electroforesis *in silico*

La **PCR *in silico*** consiste en verificar computacionalmente si un par de primers amplificaría el producto esperado. Esto incluye:

- comprobar el **tamaño esperado del amplicón**;
- evaluar si existen **productos inespecíficos**;
- anticipar cómo se vería el resultado en un **gel de electroforesis** (electroforesis *in silico*).

La práctica completa con procedimiento guiado, opciones A y B, y actividades de electroforesis *in silico* está disponible en:

📄 **[Práctica: Diseño de primers](exercises/01_primer_design.md)**

---

## 5. Cierre conceptual

El análisis de secuencias es la base sobre la cual se construye casi todo en bioinformática. Comparar secuencias permite identificar genes, encontrar homólogos, detectar variantes, diseñar primers y establecer relaciones evolutivas.

En este módulo ha aprendido:

- cómo **BLAST** usa heurísticas para buscar similitudes de forma rápida;
- cómo los algoritmos de **Needleman-Wunsch** y **Smith-Waterman** resuelven el problema de alineamiento de forma exacta;
- por qué la elección entre alineamiento **global** y **local** depende de la pregunta biológica;
- cómo el **diseño de primers** conecta el análisis computacional con el laboratorio.

En el **Módulo 4** (Filogenética) usará estos conceptos de alineamiento para construir árboles evolutivos a partir de secuencias múltiples. En el **Módulo 5** (Secuenciación) entenderá cómo se generan las lecturas que luego se alinean y ensamblan. Y en el **Módulo 6** (Genómica) aplicará todo esto a genomas completos.

> [!IMPORTANT]
> El análisis de secuencias no es un paso aislado; es el lenguaje con el que la bioinformática lee la biología.

---

## Prácticas del módulo

| Práctica                                                                             | Descripción                                                                                     |
|:-------------------------------------------------------------------------------------|:------------------------------------------------------------------------------------------------|
| [Bases de datos biológicas (Módulo 1)](../01-introduction/exercises/01_databases.md) | Búsqueda por similitud en NCBI y descarga de secuencias — base para los análisis de este módulo |
| [Alineamiento con programación dinámica](./exercises/code/alignment_dp.py)           | Script Python que implementa Needleman-Wunsch y Smith-Waterman desde cero                       |
| [Diseño de primers y PCR *in silico*](exercises/01_primer_design.md)                  | Diseño de primers con Primer-BLAST, validación del amplicón y electroforesis *in silico*        |

