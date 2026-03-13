# Módulo 4: Filogenética y Análisis Evolutivo

## Introducción

En el Módulo 3 aprendió a comparar secuencias: BLAST, alineamiento global y local, scoring, identidad vs. similitud. Todas esas herramientas le permiten comparar **dos** secuencias a la vez. Pero en biología, rara vez trabajamos con solo dos secuencias. Cuando tiene un gen de 10 cepas bacterianas distintas, o 50 secuencias de 16S rRNA de un muestreo ambiental, necesita compararlas **todas simultáneamente** y entender cómo se relacionan entre sí.

Eso es exactamente lo que hace la filogenética: toma un conjunto de secuencias, las alinea, estima cuánto han divergido y construye un **árbol filogenético** que representa sus relaciones evolutivas.

Este módulo es la evolución natural del anterior. Si en el Módulo 3 aprendió el "cómo" de comparar secuencias, aquí aprenderá el "para qué": reconstruir la historia evolutiva que conecta organismos, genes o proteínas.

Trabajaremos con cuatro grandes bloques:

1. **Construir un árbol a mano** — para entender la lógica antes de usar software.
2. **Alineamiento múltiple de secuencias (MSA)** — la base de todo análisis filogenético molecular.
3. **Modelos de sustitución** — cómo se mide la "distancia evolutiva" real entre secuencias.
4. **Métodos de construcción de árboles** — Neighbor-Joining, Máxima Parsimonia y Máxima Verosimilitud.

> [!NOTE]
> La filogenética no es solo un ejercicio académico. En microbiología clínica se usa para rastrear brotes hospitalarios, en epidemiología para seguir la evolución de patógenos (como se hizo con SARS-CoV-2), en biotecnología para identificar enzimas de organismos relacionados y en ecología para estudiar la diversidad de comunidades microbianas.

---

## Prerrequisitos y conexión con módulos previos

### Del Módulo 1

Ya conoce:
- cómo buscar y descargar secuencias desde el **NCBI**;
- los formatos **FASTA** y **GenBank**;
- el concepto de genes marcadores como el **16S rRNA**.

Si necesita repasar → [README del Módulo 1](../01-introduction/README.md).

### Del Módulo 3

Ya sabe:
- qué es un **alineamiento** y la diferencia entre global y local;
- cómo funcionan **Needleman-Wunsch** y **Smith-Waterman**;
- los conceptos de **identidad**, **similitud**, **scoring** y **gaps**;
- cómo interpretar resultados de **BLAST**.

Si necesita repasar → [README del Módulo 3](../03-sequence_analysis/README.md).

En este módulo extenderá esos conceptos: pasará de alinear **2 secuencias** a alinear **muchas** simultáneamente, y de medir similitud a **reconstruir relaciones evolutivas**.

---

## 1. Antes de las secuencias: construir un árbol a mano

Antes de trabajar con secuencias de ADN y software especializado, es fundamental entender **la lógica detrás de un árbol filogenético**. Y la mejor forma de entenderla es construir uno con las manos.

### 1.1 ¿Qué es un árbol filogenético?

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

### 1.2 Ejemplo práctico: un árbol con caracteres morfológicos

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

> 💡 El orden de las columnas se ha reorganizado para reflejar la adquisición progresiva de caracteres. La lamprea es el organismo con menos caracteres derivados (sin mandíbulas, sin pulmones) y servirá como **grupo externo** (*outgroup*).

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

### 1.3 Conceptos clave del ejemplo

| Concepto         | Significado                                             | En el ejemplo                                                                               |
|:-----------------|:--------------------------------------------------------|:--------------------------------------------------------------------------------------------|
| **Outgroup**     | Organismo de referencia para enraizar el árbol          | Lamprea                                                                                     |
| **Sinapomorfia** | Carácter derivado compartido que define un grupo        | Pulmones (define tetrápodos)                                                                |
| **Autapomorfia** | Carácter derivado exclusivo de una línea                | Plumas (solo águila)                                                                        |
| **Clado**        | Grupo que incluye un ancestro y todos sus descendientes | Caimán + águila = arcosaurios                                                               |
| **Homoplasia**   | Similitud que NO refleja ancestro común (convergencia)  | No aparece en este ejemplo, pero sería como si la lamprea tuviera plumas independientemente |

### 1.4 Del papel al ADN

Lo que acaba de hacer a mano es conceptualmente idéntico a lo que hará con software:

| A mano (este ejercicio)            | Con software (resto del módulo)            |
|:-----------------------------------|:-------------------------------------------|
| Tabla de caracteres morfológicos   | Alineamiento múltiple de secuencias        |
| Presencia/ausencia de rasgos       | Nucleótidos en cada posición (A, T, G, C)  |
| Agrupar por caracteres compartidos | Calcular distancias o evaluar modelos      |
| Dibujar el árbol en papel          | Construir el árbol con NJ, ML o parsimonia |

La diferencia es que con secuencias de ADN tiene **cientos o miles de "caracteres"** (posiciones del alineamiento), lo que hace imposible hacerlo a mano pero mucho más robusto estadísticamente.

---

## 2. Alineamiento Múltiple de Secuencias (MSA)

### 2.1 ¿Qué es un MSA y por qué es necesario?

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

### 2.2 ¿Por qué no simplemente hacer todos los alineamientos de a pares?

Alinear secuencias de a pares y luego "juntarlas" no funciona bien porque:

- un gap insertado en un alineamiento de dos secuencias puede ser **inconsistente** con el gap necesario en otro par;
- no hay garantía de que las posiciones homólogas queden alineadas de forma coherente en todas las secuencias;
- el MSA busca una solución **globalmente óptima**, no una colección de óptimos locales.

### 2.3 ¿Cómo se construye un MSA?

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

### 2.4 Herramientas para MSA

| Herramienta                  | Características                                                                  | Enlace                                         |
|:-----------------------------|:---------------------------------------------------------------------------------|:-----------------------------------------------|
| **ClustalW / Clustal Omega** | Método clásico; Omega es la versión moderna, rápida para muchas secuencias       | https://www.ebi.ac.uk/jdispatcher/msa/clustalo |
| **MUSCLE**                   | Rápido y preciso; buena opción general                                           | https://www.ebi.ac.uk/jdispatcher/msa/muscle   |
| **MAFFT**                    | Muy versátil; excelente para conjuntos grandes o secuencias muy divergentes      | https://mafft.cbrc.jp/alignment/server/        |
| **T-Coffee**                 | Combina información de múltiples métodos; más lento pero a menudo más preciso    | https://tcoffee.crg.eu/                        |
| **MEGA**                     | Incluye ClustalW y MUSCLE integrados; ideal para el flujo completo (MSA → árbol) | https://www.megasoftware.net/                  |

### 2.5 ¿Cómo evaluar un MSA?

Un MSA no se acepta "tal cual sale del programa". Debe revisarse:

- **Columnas con demasiados gaps**: pueden indicar regiones mal alineadas o difíciles de alinear.
- **Regiones de baja confianza**: zonas donde las secuencias son tan divergentes que el alineamiento es ambiguo.
- **Inspección visual**: siempre mire el alineamiento antes de continuar. Software como **MEGA**, **AliView** o **Jalview** permiten visualizarlo.

> [!TIP]
> En la práctica, a veces es necesario **recortar** (*trim*) las regiones mal alineadas antes de construir el árbol. Herramientas como **trimAl** o **Gblocks** automatizan este paso.

---

## 3. Modelos de sustitución

### 3.1 ¿Por qué no basta con contar diferencias?

Si dos secuencias difieren en 10 posiciones de 100, podríamos decir que tienen un 10% de diferencia. Pero eso subestima la distancia real, porque:

- una posición puede haber cambiado **más de una vez** (por ejemplo, A → G → A, lo que parece "sin cambio" pero tuvo dos sustituciones);
- no todas las sustituciones son igual de probables (las **transiciones** A↔G, C↔T son más frecuentes que las **transversiones** A↔C, A↔T, G↔C, G↔T);
- la frecuencia de cada nucleótido en el genoma varía entre organismos.

Los **modelos de sustitución** corrigen estos sesgos y estiman la distancia evolutiva "real" entre secuencias.

### 3.2 Tipos de sustituciones

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

### 3.3 Modelos comunes (de menor a mayor complejidad)

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

### 3.4 Parámetros adicionales

Además del modelo base, algunos análisis incluyen:

- **Proporción de sitios invariantes (+I)**: asume que una fracción de posiciones no cambia nunca (por ejemplo, sitios esenciales para la función de una proteína).
- **Variación entre sitios (+G, distribución gamma)**: asume que diferentes posiciones evolucionan a velocidades diferentes. Esto es biológicamente muy realista.

Cuando vea algo como **GTR+G+I**, significa: modelo GTR con variación de tasas entre sitios (gamma) y proporción de sitios invariantes.

---

## 4. Métodos de construcción de árboles

### 4.1 Clasificación general

Los métodos se dividen en dos grandes familias:

| Familia                   | Métodos principales                                                     | ¿Cómo funcionan?                                                             |
|:--------------------------|:------------------------------------------------------------------------|:-----------------------------------------------------------------------------|
| **Basados en distancias** | Neighbor-Joining (NJ), UPGMA                                            | Calculan una matriz de distancias entre todas las secuencias y luego agrupan |
| **Basados en caracteres** | Máxima Parsimonia (MP), Máxima Verosimilitud (ML), Inferencia Bayesiana | Evalúan directamente las posiciones del alineamiento para inferir el árbol   |

### 4.2 Neighbor-Joining (NJ)

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

### 4.3 Máxima Parsimonia (MP)

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

### 4.4 Máxima Verosimilitud (ML)

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

### 4.5 Comparación rápida de métodos

| Criterio                    | NJ                                    | MP                                      | ML                              |
|:----------------------------|:--------------------------------------|:----------------------------------------|:--------------------------------|
| **Velocidad**               | ⚡⚡⚡ Muy rápido                        | ⚡ Lento                                 | ⚡⚡ Moderado                     |
| **Modelo de sustitución**   | Sí (para las distancias)              | No                                      | Sí (explícito)                  |
| **Criterio de optimalidad** | Mínima longitud total                 | Mínimo número de cambios                | Máxima probabilidad             |
| **Robustez**                | Buena para secuencias similares       | Buena si hay poca divergencia           | La más robusta en general       |
| **Uso recomendado**         | Exploración rápida, conjuntos grandes | Datos morfológicos, secuencias cercanas | Análisis finales, publicaciones |

### 4.6 ¿Cómo saber si el árbol es confiable? — Bootstrap

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

## 5. Flujo de trabajo completo

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

## 6. Cierre conceptual

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
| [Análisis filogenético con 16S rRNA](./exercises/02_phylogenetics.md) | Alineamiento de secuencias 16S, construcción de árboles NJ y ML en MEGA, e identificación de una bacteria desconocida |

