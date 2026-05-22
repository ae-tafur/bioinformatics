# Módulo 10: Modelación de Redes Metabólicas — Del Genoma al Diseño de Biofábricas

## Introducción

A lo largo de los módulos anteriores, usted aprendió a obtener secuencias de bases de datos, alinearlas, reconstruir genomas, anotarlos y compararlos. Pero hay una pregunta que todavía no hemos respondido: **¿cómo le decimos a una célula qué producir?**

Los microorganismos no son simplemente portadores de genes: son máquinas bioquímicas que transforman nutrientes en energía, biomasa y productos de valor. La ingeniería metabólica busca reprogramar esas máquinas para que produzcan compuestos de interés: antibióticos, enzimas industriales, biocombustibles, plásticos biodegradables, alimentos funcionales.

Para hacerlo de forma racional —sin ensayo y error ciego— necesitamos una representación matemática del metabolismo. Eso es exactamente lo que son los **modelos metabólicos a escala genómica (GEM)**: traducciones del genoma en ecuaciones que nos permiten simular, predecir y diseñar el comportamiento celular.

Este módulo conecta todo lo que ha aprendido:

1. **El dogma central y más allá** — de la secuencia al fenotipo metabólico.
2. **Biología en tiempo y espacio** — por qué la célula es un sistema dinámico.
3. **Abstracciones matemáticas** — cómo simplificamos la complejidad para poder modelarla.
4. **Redes metabólicas como grafos** — nodos, aristas y flujos.
5. **Ecuaciones diferenciales ordinarias (ODEs)** — simular tasas de reacción.
6. **Modelos COBRA a escala genómica** — del genoma a la matriz estequiométrica.
7. **Flux Balance Analysis (FBA)** — optimizar flujos a estado estacionario.
8. **Modelos con restricciones enzimáticas: GECKO** — incorporar la capacidad catalítica real.

> [!NOTE]
> Este módulo requiere que usted haya trabajado con los conceptos de anotación genómica (Módulo 6) y tenga familiaridad básica con Python (Módulo 2), ya que la práctica usa **COBRApy** en Google Colab.

---

## Prerrequisitos y conexión con módulos previos

### Del Módulo 1 y 3
- Búsqueda de secuencias y genes en NCBI, formato FASTA y GenBank.
- Concepto de gen, ORF, producto génico.

### Del Módulo 2
- Python básico: variables, listas, funciones, lectura de archivos.

### Del Módulo 6
- Anotación genómica: genes, productos, EC numbers, rutas metabólicas (KEGG, COG).
- Concepto de reacción bioquímica representada como feature en un archivo GBK/GFF.

> [!NOTE]
> Si necesita repasar:
> - Módulo 2 → [README Módulo 2](../02-coding-basics/README.md)
> - Módulo 6 → [README Módulo 6](../06-genomics/README.md)

---

## 1. El dogma central de la biología molecular — y más allá

### 1.1 Lo que ya conoce

El dogma central de la biología molecular describe el flujo de información genética:

```text
ADN  ──replicación──▶  ADN
ADN  ──transcripción──▶  ARN  ──traducción──▶  Proteína
```

Los genes codifican proteínas, y las proteínas ejecutan funciones bioquímicas. Hasta aquí, el dogma clásico.

### 1.2 El panorama completo

Pero la información genética no termina en la proteína. Las proteínas catalizan **reacciones químicas** que transforman metabolitos, generan energía y producen la biomasa necesaria para crecer. El flujo completo es:

```text
                   ┌──────────────────────────────────────────────────────┐
                   │               Dogma Central Extendido                │
                   └──────────────────────────────────────────────────────┘

    ADN ──▶ ARNm ──▶ Proteína ──▶ Enzima ──▶ Reacción bioquímica
                        │                         │
               rRNA, tRNA, miRNA,            Metabolitos
               snRNA (regulación,           (glucosa, ATP,
               procesamiento,              aminoácidos,
               síntesis proteica)          lípidos, etc.)
                                                  │
                                          Fenotipo celular:
                                        crecimiento, producción,
                                       respuesta al ambiente
```

> [!IMPORTANT]
> 🔑 La imagen clave aquí es que el genoma no solo "guarda información": es la **receta operacional** de la maquinaria metabólica de la célula. Cada gen anotado con un número EC (Enzyme Commission) es, potencialmente, un nodo en la red metabólica.

---

## 2. Biología en tiempo y espacio

Una célula no es una fotografía estática: es un sistema **dinámico**. Las concentraciones de metabolitos cambian segundo a segundo dependiendo de:

- los **nutrientes disponibles** en el medio (glucosa, oxígeno, nitrógeno);
- la **expresión génica** en ese momento (qué enzimas están activas);
- las **condiciones físicas** (temperatura, pH, osmolaridad);
- la **historia del cultivo** (fase lag, exponencial, estacionaria).

Esto significa que para entender o predecir el comportamiento de una célula, no basta con conocer su genoma. Necesitamos un modelo que capture **cómo cambian las concentraciones en el tiempo** bajo distintas condiciones. Eso nos lleva a las matemáticas.

---

## 3. Abstracciones matemáticas para entender una célula

Para modelar sistemas biológicos complejos se utilizan diferentes niveles de abstracción:

| Nivel de abstracción  | Descripción                                           | Ejemplo                   |
|:----------------------|:------------------------------------------------------|:--------------------------|
| **Estequiométrico**   | Qué reacciones existen y cómo se conectan             | Matriz S                  |
| **Cinético**          | A qué velocidad ocurre cada reacción                  | ODEs con Michaelis-Menten |
| **Termodinámico**     | Qué tan favorables son las reacciones                 | ΔG de reacciones          |
| **Regulatorio**       | Qué genes están activos según las condiciones         | Redes de regulación (GRN) |
| **A escala genómica** | Todos los genes y reacciones del organismo integrados | GEM (Genome-Scale Model)  |

La clave de la modelación es que **no necesitamos conocer todo perfectamente**: usando el nivel de abstracción correcto podemos obtener predicciones útiles con información razonable.

---

## 4. Redes metabólicas: grafos, nodos y aristas

### 4.1 El metabolismo como grafo

Un **grafo** es una estructura matemática formada por **nodos** (vértices) y **aristas** (conexiones). El metabolismo se puede representar naturalmente como un grafo:

```text
Representación del metabolismo como grafo:

        Glucosa
           │
    (reacción: hexoquinasa)
           │
     Glucosa-6-P ──────────────────────────────────────┐
           │                                            │
   (fosfoglucosa                             (glucosa-6-P
    isomerasa)                               deshidrogenasa)
           │                                            │
     Fructosa-6-P                             6-P-gluconolactona
           │                                  (vía pentosa fosfato)
           ...

     ○ = Metabolito (nodo)
     ─ = Reacción (arista)
     → = Dirección del flujo
```

Cada **nodo** representa un metabolito o compuesto químico. Cada **arista** representa una reacción catalizada por una enzima. El **flujo** a través de esas aristas representa la tasa a la que ocurre cada reacción.

### 4.2 El mapa de KEGG: la complejidad real

Si alguna vez ha visto el mapa metabólico completo de KEGG (*Kyoto Encyclopedia of Genes and Genomes*), habrá notado su aparente caos:

```text
╔═══════════════════════════════════════════════════════════════╗
║     Mapa metabólico (representación esquemática tipo KEGG)    ║
║                                                               ║
║   ○──○    ○──○──○       ○       ○──○──○──○──○                 ║
║   │  │    │        ╲   / \     / │                            ║
║   ○  ○──○─○         ○─○   ○──○  ○──○                          ║
║   │     │  \        │     │        │                          ║
║   ○──○──○   ○──○──○─○─────○──○──○──○──○──○                    ║
║       │    /                   │       │                      ║
║       ○──○                     ○──○──○─○──○──○──○             ║
║                                                               ║
║  Cada nodo (○) = metabolito   Cada línea (─) = reacción       ║
╚═══════════════════════════════════════════════════════════════╝
```

> [!TIP]
> Puede explorar el mapa metabólico real en: https://www.kegg.jp/kegg/pathway.html

Lo que parece una telaraña infinita es, en realidad, un grafo muy denso donde cada nodo es un compuesto químico y cada arista es una reacción enzimática. Un modelo metabólico a escala genómica es una **representación matemática formal** de ese mismo grafo.

### 4.3 La analogía del Transmilenio

Una forma intuitiva de entender una red metabólica es comparándola con el sistema de transporte público de una ciudad:

```text
╔═══════════════════════════════════════════════════════╗
║          Red de Transmilenio vs. Red Metabólica       ║
╠═══════════════════╦═══════════════════════════════════╣
║ Transmilenio      ║ Red Metabólica                    ║
╠═══════════════════╬═══════════════════════════════════╣
║ Estaciones        ║ Metabolitos                       ║
║ Rutas de bus      ║ Reacciones enzimáticas            ║
║ Pasajeros         ║ Flujo de carbono / electrones     ║
║ Capacidad del bus ║ Actividad máxima de la enzima     ║
║ Nodo de Portal    ║ Metabolito hub (ej. ATP, NADH)    ║
║ Destino final     ║ Biomasa o producto de interés     ║
║ Rutas bloqueadas  ║ Genes deletados / inhibición      ║
╚═══════════════════╩═══════════════════════════════════╝
```

Así como en el Transmilenio existen múltiples rutas para llegar de un punto A a uno B, en el metabolismo existen múltiples caminos para transformar glucosa en un producto de interés. La tarea de la modelación es encontrar la **ruta óptima** dado el estado actual de la red.

---

> *"La modelación matemática ha emergido como una poderosa herramienta para entender y predecir el comportamiento de complejos sistemas biológicos."*
>
> — Hyunjae Woo, 2024 · [https://doi.org/10.1038/s44320-024-00017-w](https://doi.org/10.1038/s44320-024-00017-w)

---

## 5. Ecuaciones diferenciales ordinarias (ODEs) para simular el metabolismo

### 5.1 ¿Qué son las ODEs en este contexto?

Una **ecuación diferencial ordinaria (ODE)** describe cómo cambia una cantidad con respecto al tiempo. En biología, se usan para modelar cómo cambia la concentración de un metabolito:

$$\frac{d[X]}{dt} = \sum \text{tasas de producción} - \sum \text{tasas de consumo}$$

Donde $[X]$ es la concentración del metabolito X y $t$ es el tiempo.

### 5.2 Un ejemplo simple: glucosa → etanol

Considere una célula de levadura que consume glucosa (G) y produce etanol (E):

```text
Reacciones simplificadas:
  1. Glucosa (G)  ──(v₁)──▶  2 Piruvato (P)
  2. Piruvato (P) ──(v₂)──▶  Etanol (E) + CO₂
```

**Sistema de ODEs:**

$$\frac{d[G]}{dt} = -v_1$$

$$\frac{d[P]}{dt} = 2v_1 - v_2$$

$$\frac{d[E]}{dt} = v_2$$

donde $v_1$ y $v_2$ son tasas de reacción en $\text{mmol} \cdot \text{gDW}^{-1} \cdot \text{h}^{-1}$.

Cada tasa $v$ se modela con cinética de **Michaelis-Menten**:

$$v = \frac{V_{max} \cdot [S]}{K_m + [S]}$$

donde $V_{max}$ es la velocidad máxima de la enzima, $K_m$ es la concentración de sustrato a la que $v = V_{max}/2$, y $[S]$ es la concentración del sustrato.

Integrando el sistema en el tiempo obtenemos curvas de crecimiento y producción comparables a las que se miden experimentalmente en un biorreactor.

### 5.2.1 Ejemplo numérico resuelto

Usemos valores reales de parámetros para las dos reacciones y resolvamos el sistema paso a paso:

**Parámetros cinéticos:**

```text
Reacción 1 — Glucosa → 2 Piruvato  (complejo glucolítico simplificado)
  Vmax₁ = 2.5  mmol/gDW/h
  Km₁   = 0.5  mmol/L      (concentración media de saturación para glucosa)

Reacción 2 — Piruvato → Etanol + CO₂  (piruvato descarboxilasa + alcohol deshidrogenasa)
  Vmax₂ = 5.0  mmol/gDW/h
  Km₂   = 0.2  mmol/L      (concentración media de saturación para piruvato)

Condiciones iniciales (t = 0):
  [G]₀  = 10.0  mmol/L     (glucosa disponible en el medio)
  [P]₀  =  0.0  mmol/L     (sin piruvato acumulado al inicio)
  [E]₀  =  0.0  mmol/L     (sin etanol al inicio)
```

**Paso 1 — Calcular las tasas en t = 0:**

$$v_1(0) = \frac{V_{max,1} \cdot [G]_0}{K_{m,1} + [G]_0} = \frac{2.5 \times 10.0}{0.5 + 10.0} = \frac{25.0}{10.5} = 2.381 \ \text{mmol/gDW/h}$$

> Alta saturación: la enzima opera casi a $V_{max}$ porque $[G]_0 \gg K_{m,1}$.

$$v_2(0) = \frac{V_{max,2} \cdot [P]_0}{K_{m,2} + [P]_0} = \frac{5.0 \times 0.0}{0.2 + 0.0} = 0.000 \ \text{mmol/gDW/h}$$

> Sin piruvato disponible, la reacción 2 no puede ocurrir.

**Paso 2 — Calcular las derivadas en t = 0:**

$$\left.\frac{d[G]}{dt}\right|_{t=0} = -v_1 = -2.381 \ \text{mmol/L/h} \quad \rightarrow \text{glucosa disminuye}$$

$$\left.\frac{d[P]}{dt}\right|_{t=0} = 2v_1 - v_2 = +4.762 \ \text{mmol/L/h} \quad \rightarrow \text{piruvato se acumula}$$

$$\left.\frac{d[E]}{dt}\right|_{t=0} = v_2 = 0.000 \ \text{mmol/L/h} \quad \rightarrow \text{etanol aún no se produce}$$

**Paso 3 — Integración numérica (pasos de Δt = 0.5 h, método de Euler explícito):**

```text
 t (h) │  [G] (mmol/L) │  [P] (mmol/L) │  [E] (mmol/L) │  v₁     │  v₂
───────┼───────────────┼───────────────┼───────────────┼─────────┼─────────
   0.0 │    10.000     │     0.000     │     0.000     │  2.381  │  0.000
   0.5 │     8.810     │     2.381     │     0.000     │  2.291  │  4.297
   1.0 │     7.665     │     0.537     │     2.149     │  2.185  │  3.302
   1.5 │     6.572     │     0.213     │     3.800     │  2.065  │  2.760
   2.0 │     5.539     │     0.139     │     5.180     │  1.929  │  2.545
   3.0 │     3.595     │     0.104     │     7.853     │  1.608  │  2.282
   4.0 │     1.864     │     0.090     │     9.970     │  1.201  │  2.121
   5.0 │     0.500     │     0.080     │    11.482     │  0.625  │  2.000
   6.0 │     0.032     │     0.030     │    12.710     │  0.140  │  1.429
   7.0 │     0.001     │     0.003     │    13.066     │  0.005  │  0.067
   8.0 │     0.000     │     0.000     │    13.070     │  0.000  │  0.000
```

> [!NOTE]
> 📌 Lectura de la tabla:
> - **t = 0 → 0.5 h:** `v₁ ≫ v₂` porque hay mucha glucosa pero aún no hay piruvato. El piruvato se acumula rápidamente hasta ~2.38 mmol/L.
> - **t = 0.5 → 1.5 h:** Ahora `v₂` se dispara (piruvato disponible, alta concentración). El piruvato cae velozmente y el etanol empieza a acumularse.
> - **t > 1.5 h:** El piruvato se estabiliza en un nivel bajo (~0.1 mmol/L): lo que produce R1 es casi igual a lo que consume R2. **Este es el estado cuasi-estacionario que FBA asume desde t = 0.**
> - **t ≈ 8 h:** Toda la glucosa se agotó. El etanol final es ~13.07 mmol/L (el rendimiento no es exactamente 2:1 por las cinéticas de saturación a bajas concentraciones).

**Representación gráfica de la dinámica:**

```text
[mmol/L]
  10 ┤
     │  G ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░░░░░░░░░
   8 ┤
     │
   6 ┤                         E  ░░░░░░░░░░░░░░░░▓▓▓▓▓▓▓▓▓▓▓▓
     │
   4 ┤
     │
   2 ┤          P ▲ (pico ~t=0.5h)
     │              ╲_______________ ≈ 0.1 mmol/L (cuasi-estacionario)
   0 ┤─────┬─────────┬─────────┬──────────┬─────────▶ t (h)
     0    0.5       2.0       4.0        6.0       8.0

  ▓▓ Glucosa [G] — decrece suavemente al inicio (alta saturación), luego se agota
  ░░ Etanol  [E] — sigue a [G] con retraso; se acumula mientras hay glucosa
     Piruvato [P] — pico transitorio al inicio, luego nivel bajo cuasi-estacionario
```

> [!TIP]
> El piruvato acumulándose transitoriamente antes de ser consumido es un ejemplo clásico de **metabolito intermediario con dinámica no obvia**. Los sistemas cinéticos (ODEs) capturan este transitorio; FBA asume que [P] ya está en estado estacionario desde t = 0. Ambas aproximaciones son útiles: las ODEs para entender **cómo cambia** el sistema en el tiempo, y FBA para predecir el **estado final óptimo** a escala genómica sin necesidad de conocer los parámetros cinéticos de cada enzima.

### 5.3 El problema de escalar: de 3 a 3.000 reacciones

Una bacteria modelo como *E. coli* tiene aproximadamente **2.500 reacciones metabólicas** anotadas. Resolver un sistema de 2.500 ODEs simultáneas requiere:

- conocer los parámetros cinéticos (Vmax, Km) de **cada** enzima;
- medir las concentraciones iniciales de **todos** los metabolitos;
- integrar numéricamente el sistema en cada paso de tiempo.

En la práctica, los parámetros cinéticos son **extremadamente difíciles de medir** para la mayoría de las enzimas. Aquí es donde entran los modelos a escala genómica con una aproximación diferente.

---

## 6. Modelos metabólicos a escala genómica (GEM) y reconstrucción COBRA

### 6.1 La idea central: del genoma a la matriz

En lugar de requerir parámetros cinéticos, los modelos COBRA (*COnstraints-Based Reconstruction and Analysis*) trabajan con una simplificación poderosa: en lugar de simular la dinámica completa, asumen **estado estacionario**.

El estado estacionario implica que las concentraciones intracelulares de metabolitos no cambian en el tiempo:

$$\frac{d[X]}{dt} = 0 \quad \text{para todos los metabolitos internos}$$

Esto es equivalente a decir que **lo que entra a cada nodo de la red es igual a lo que sale**: el flujo neto sobre cada metabolito es cero.

Bajo esta suposición, el sistema de ODEs se reduce a un problema de **álgebra lineal**:

$$\mathbf{S} \cdot \mathbf{v} = \mathbf{0}$$

donde $\mathbf{S}$ es la matriz estequiométrica de dimensión $m \times n$ ($m$ metabolitos, $n$ reacciones), $\mathbf{v}$ es el vector de flujos de las $n$ reacciones, y $\mathbf{0}$ es el vector cero que impone la condición de estado estacionario.

### 6.2 La matriz estequiométrica S

La matriz estequiométrica codifica toda la información de la red metabólica. Su relación directa con el sistema de ODEs es:

```text
Ejemplo con 4 metabolitos y 4 reacciones:

Reacciones:          R1        R2        R3        R4
                  Glc→G6P   G6P→F6P   F6P→Pyr   Pyr→ATP

     Glc   │   -1        0         0         0   │
     G6P   │    1       -1         0         0   │   =  S
     F6P   │    0        1        -1         0   │
     Pyr   │    0        0         1        -1   │

  Convención:
  • Valor  1: el metabolito es PRODUCIDO por esa reacción
  • Valor -1: el metabolito es CONSUMIDO por esa reacción
  • Valor  0: el metabolito no participa en esa reacción
```

**Relación con las ODEs** — la fila de G6P en la matriz dice directamente:

$$\frac{d[\text{G6P}]}{dt} = 1 \cdot v_1 + (-1) \cdot v_2 = v_1 - v_2$$

En estado estacionario ($d[\text{G6P}]/dt = 0$):

$$v_1 - v_2 = 0 \implies v_1 = v_2$$

lo que se produce de G6P debe ser exactamente igual a lo que se consume.

> [!IMPORTANT]
> Cada **fila** de la matriz $\mathbf{S}$ corresponde exactamente a una **ecuación diferencial** del sistema de ODEs. Asumir estado estacionario ($d[X]/dt = 0$) convierte el problema dinámico en estático: $\mathbf{S} \cdot \mathbf{v} = \mathbf{0}$. Esto elimina la necesidad de parámetros cinéticos y permite trabajar a escala genómica.

### 6.3 Del genoma al modelo: el proceso de reconstrucción

Construir un GEM es un proceso iterativo que integra información genómica, bioquímica y de literatura:

```text
PASO 1: Anotación genómica
  Genoma (.fasta) → Prokka/Bakta → Genes con número EC
  Ej.: gen b0001 → EC 2.7.1.1 = hexoquinasa

PASO 2: Asignación de reacciones
  EC number → Reacción en BiGG/KEGG/MetaCyc
  HEX1: Glc + ATP → G6P + ADP

PASO 3: Reglas GPR (Gene–Protein–Reaction)
  (b0001 OR b0002)  → reacción activa si al menos un gen está presente
  (b0003 AND b0004) → reacción activa solo si ambos genes están presentes
                      (enzimas con múltiples subunidades)

PASO 4: Límites de flujo
  Reversibles:    -1000 ≤ v ≤ 1000  mmol/gDW/h
  Irreversibles:      0 ≤ v ≤ 1000  mmol/gDW/h
  Uptake ajustado según condición experimental

PASO 5: Reacciones de intercambio (Exchange reactions)
  EX_glc_e: Glucosa_ext ⇌ Glucosa_interna
  (representan la frontera entre la célula y el medio)

PASO 6: Función objetivo — reacción de biomasa
  aATP + bNADPH + cGly + dAla + ... → Biomasa
  (pseudoreacción que representa la síntesis de todos los
  componentes celulares necesarios para crecer)

PASO 7: Curación manual y validación
  → Verificar balance de masa y carga
  → Comparar predicciones vs. datos experimentales publicados
```

> [!TIP]
> Los modelos GEM curados están disponibles en **BiGG Models** (http://bigg.ucsd.edu/) para cientos de organismos, incluyendo *E. coli* iJO1366, *S. cerevisiae* iMM904, *P. putida* iJN1463, entre muchos más.

#### Herramientas para la reconstrucción de modelos GEM

En la práctica, los pasos 1–7 se realizan con ayuda de software especializado. Las herramientas se dividen en dos grandes categorías:

**Reconstrucción automática** — el software genera un borrador del modelo a partir del genoma anotado, que luego debe ser curado manualmente:

| Herramienta       | Lenguaje     | Descripción                                                                                                                                                        | Repositorio                                                                    |
|:------------------|:-------------|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------|:-------------------------------------------------------------------------------|
| **RAVEN Toolbox** | MATLAB       | Suite completa para reconstrucción automática, curación y análisis. Integra KEGG, MetaCyc y UniProt. Incluye herramientas de gap-filling y comparación de modelos. | [github.com/SysBioChalmers/RAVEN](https://github.com/SysBioChalmers/RAVEN)     |
| **ModelSEED**     | Web / Python | Plataforma en línea que genera un modelo GEM completo a partir de un genoma en minutos. Integrado con la plataforma KBase.                                         | [modelseed.org](https://modelseed.org)                                         |
| **CarveMe**       | Python       | Reconstrucción top-down usando una red metabólica universal (pan-reacción). Muy rápido y adecuado para estudios comparativos de muchos genomas.                    | [github.com/cdanielmachado/carveme](https://github.com/cdanielmachado/carveme) |
| **Merlin**        | Java         | Interfaz gráfica para reconstrucción semi-automática, especialmente útil para eucariotas y hongos.                                                                 | [merlin-sysbio.org](https://merlin-sysbio.org)                                 |

**Reconstrucción y curación manual** — usadas principalmente para refinar borradores automáticos, ajustar límites, corregir GPR y realizar gap-filling dirigido:

| Herramienta       | Lenguaje | Descripción                                                                                                                                                                   | Repositorio                                                                    |
|:------------------|:---------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:-------------------------------------------------------------------------------|
| **COBRApy**       | Python   | La librería estándar de Python para trabajar con modelos COBRA. Permite cargar, editar, simular y exportar modelos en SBML y JSON. Ideal para scripting y automatización.     | [github.com/opencobra/cobrapy](https://github.com/opencobra/cobrapy)           |
| **COBRA Toolbox** | MATLAB   | La implementación original del framework COBRA. Muy completa: incluye FBA, FVA, OptKnock, MOMA, gap-filling y decenas de métodos adicionales. Referencia histórica del campo. | [github.com/opencobra/cobratoolbox](https://github.com/opencobra/cobratoolbox) |

> [!NOTE]
> El flujo de trabajo más común en la actualidad combina ambas categorías:
> ```text
> Genoma anotado
>      │
>      ▼
> Borrador automático  ←── CarveMe o RAVEN (15–30 minutos)
>      │
>      ▼
> Curación manual      ←── COBRApy o COBRA Toolbox (días a semanas)
>      │
>      ▼
> Modelo curado publicado  →  BiGG / repositorio GitHub del laboratorio
> ```
> La curación manual sigue siendo el paso más costoso en tiempo: un modelo bien curado puede requerir semanas de trabajo comparando la literatura bioquímica con las predicciones del modelo.

### 6.4 Estructura de un archivo de modelo COBRA

Los modelos se guardan en formatos estándar como **SBML** (`.xml`) o **JSON**:

```text
Componentes de un modelo COBRA:
  ├── metabolites   → ID, nombre, fórmula química, carga, compartimento
  ├── reactions     → estequiometría, límites [lb, ub], regla GPR
  ├── genes         → lista de genes y sus IDs
  ├── objective     → función a optimizar (ej. maximizar biomasa)
  └── compartments  → [c] citoplasma, [p] periplasma, [e] extracelular
```

---

## 7. Flux Balance Analysis (FBA)

### 7.1 El problema de optimización

Dado que S · v = 0 tiene infinitas soluciones posibles (el sistema está subdeterminado), FBA agrega dos elementos adicionales:

> [!TIP]
> Las mismas herramientas usadas para construir y curar modelos GEM implementan FBA y todos los análisis derivados:
>
> | Herramienta       | Lenguaje | Función principal en FBA                                              | Enlace                                                                         |
> |:------------------|:---------|:----------------------------------------------------------------------|:-------------------------------------------------------------------------------|
> | **COBRApy**       | Python   | `model.optimize()`, `production_envelope()`, `single_gene_deletion()` | [github.com/opencobra/cobrapy](https://github.com/opencobra/cobrapy)           |
> | **COBRA Toolbox** | MATLAB   | `optimizeCbModel()`, `robustknock()`, `optKnock()`, FVA, MOMA         | [github.com/opencobra/cobratoolbox](https://github.com/opencobra/cobratoolbox) |
> | **RAVEN Toolbox** | MATLAB   | `solveLP()`, análisis de flujos, integración con datos ómicos         | [github.com/SysBioChalmers/RAVEN](https://github.com/SysBioChalmers/RAVEN)     |
>
> En esta práctica usamos **COBRApy** por ser Python y correr directamente en Google Colab. COBRA Toolbox es la referencia más completa para análisis avanzados (OptKnock, MOMA, ROOM), mientras que RAVEN es especialmente potente cuando se combina con el pipeline de GECKO para modelos con restricciones enzimáticas.

1. **Restricciones de desigualdad**: los flujos no pueden exceder ciertos límites (`lb ≤ v ≤ ub`).
2. **Función objetivo**: maximizar o minimizar una reacción específica (generalmente la tasa de crecimiento).

El problema de optimización de FBA se formula como un **programa lineal (LP)**:

$$\max_{\mathbf{v}} \quad \mathbf{c}^\top \mathbf{v}$$

$$\text{sujeto a:} \quad \mathbf{S} \cdot \mathbf{v} = \mathbf{0}$$

$$\mathbf{lb} \leq \mathbf{v} \leq \mathbf{ub}$$

donde $\mathbf{c}$ es el vector de coeficientes de la función objetivo (generalmente 1 para la reacción de biomasa y 0 para el resto), $\mathbf{v}$ es el vector de flujos incógnita, y $\mathbf{lb}$, $\mathbf{ub}$ son los vectores de límites inferior y superior de cada reacción.

### 7.2 ¿Qué nos dice FBA?

FBA nos da la **distribución óptima de flujos** que maximiza el objetivo biológico bajo las condiciones impuestas:

```text
Simulación de E. coli en glucosa mínima con FBA:

  Condición: uptake de glucosa = 10 mmol/gDW/h, aerobio
  Objetivo: maximizar tasa de crecimiento (μ)
  
  Resultado:
    μ_óptima  = 0.874 h⁻¹
    
  Flujos seleccionados:
    Glucólisis:            10.0  mmol/gDW/h
    Ciclo del citrato:      6.0  mmol/gDW/h
    Fosforilación oxidativa: 7.5  mmol/gDW/h
    Excreción de acetato:   0.4  mmol/gDW/h
```

### 7.3 Aplicaciones de FBA

| Análisis                      | Pregunta                                   | Método                           |
|:------------------------------|:-------------------------------------------|:---------------------------------|
| **Predicción de crecimiento** | ¿Puede la cepa crecer en este medio?       | Maximizar μ                      |
| **Knockout de genes**         | ¿Qué pasa si eliminamos este gen?          | Fijar v = 0 para esa reacción    |
| **Producción de metabolitos** | ¿Cuánto producto puede producirse?         | Maximizar flujo del producto     |
| **Esencialidad génica**       | ¿Qué genes son esenciales para crecer?     | Deleciones simples sistemáticas  |
| **OptKnock**                  | ¿Qué genes delegar para forzar producción? | Programación lineal de 2 niveles |

```text
Ejemplo: FBA con knockout del gen pgi (fosfoglucosa isomerasa)

  Condición normal:   μ = 0.874 h⁻¹
  Δpgi (v_pgi = 0):   μ = 0.460 h⁻¹, flujo hacia pentosa fosfato ↑↑
  
  Interpretación: la deleción redirige carbono hacia la vía de
  pentosa fosfato (útil para producción de NADPH, eritrosa-4-P,
  aromáticos).
```

### 7.4 Limitaciones del FBA estándar y variantes que las abordan

FBA es una herramienta poderosa, pero tiene limitaciones importantes. En la tabla se indican también las variantes que existen para resolverlas:

| Suposición de FBA                        | Limitación                                                                     | Variante que la aborda  |
|:-----------------------------------------|:-------------------------------------------------------------------------------|:------------------------|
| Estado estacionario                      | No captura dinámicas temporales                                                | **dFBA** (FBA dinámico) |
| Todas las enzimas igualmente disponibles | No refleja diferencias en capacidad catalítica real                            | **GECKO / ecGEM**       |
| Objetivo = maximizar $\mu$               | En estrés o condiciones industriales la célula no siempre maximiza crecimiento | **MOMA**, **ROOM**      |
| Sin regulación génica explícita          | No captura inducción / represión de genes según el ambiente                    | **rFBA**, **iFBA**      |

> [!WARNING]
> La limitación más crítica para el diseño de biofábricas es que FBA trata todas las enzimas como igualmente disponibles dentro de sus límites de flujo. En la realidad, cada enzima tiene una cantidad finita de proteína y una capacidad catalítica específica (kcat). Ignorar esto puede llevar a predicciones de producción irrealmente optimistas.

---

### 7.5 FBA dinámico (dFBA): combinando ODEs con FBA

Hasta ahora todo lo descrito corresponde al **FBA de estado estacionario (ssFBA)**: el modelo resuelve la distribución de flujos en un instante dado, asumiendo que las concentraciones extracelulares (glucosa, oxígeno, productos excretados) no cambian. Esto es razonable para cultivos en quimiostato, pero en un **cultivo batch** la glucosa se agota, el pH cambia y la biomasa crece: el sistema *sí* evoluciona en el tiempo.

El **FBA dinámico (dFBA)** combina lo mejor de ambos mundos: usa un sistema de ODEs para seguir las concentraciones extracelulares a lo largo del tiempo, y en cada paso de tiempo resuelve un FBA para obtener los flujos intracelulares óptimos bajo esas condiciones.

#### El principio del dFBA

```text
           t = 0          t = dt         t = 2*dt       ...
              |               |               |
  [Glc]_0 ----|               |               |
  [Biom]_0    |               |               |
  [EtOH]_0    |               |               |
              |               |               |
  +-----------v---------------v---------------v-----------+
  |         CAPA EXTERIOR  (ODEs extracelulares)          |
  |    concentraciones en el medio: Glc, X, EtOH, ...     |
  +-----------+---------------+---------------+-----------+
              |  flujos v(t)  |               |
              v               v               v
  +-----------------------------------------------------------+
  |     CAPA INTERIOR  (FBA intracelular, cada paso dt)       |
  |     resuelve el LP con los limites ub(t) del paso actual  |
  |     devuelve: mu(t), v_uptake(t), v_prod(t), ...          |
  +-----------------------------------------------------------+
```

**Capa exterior — ODEs extracelulares** (integradas en el tiempo):

$$\frac{d[\text{Glc}]}{dt} = -v_{uptake}(t) \cdot X(t)$$

$$\frac{d[X]}{dt} = \mu(t) \cdot X(t)$$

$$\frac{d[\text{EtOH}]}{dt} = v_{etoh}(t) \cdot X(t)$$

**Capa interior — FBA intracelular** (resuelto en cada instante $t$):

$$\max_{\mathbf{v}} \quad \mathbf{c}^\top \mathbf{v} \qquad \text{s.a.} \quad \mathbf{S}\cdot\mathbf{v} = \mathbf{0}, \quad \mathbf{lb} \leq \mathbf{v} \leq \mathbf{ub}(t)$$

Los límites de flujo $\mathbf{ub}(t)$ cambian en cada paso porque dependen de las concentraciones extracelulares actuales. Por ejemplo, el uptake de glucosa está acotado por la concentración disponible mediante una cinética de Michaelis-Menten:

$$v_{\mathrm{uptake}}(t) \leq \frac{v_{\mathrm{uptake}}^{\max} \cdot \mathrm{[Glc]}(t)}{K_s + \mathrm{[Glc]}(t)}$$

donde $v_{uptake}^{max}$ es el uptake máximo permitido (parámetro del modelo), $K_s$ es la constante de semisaturación para glucosa, y $X(t)$, $v_{glc}(t)$, $v_{prod}(t)$ son la biomasa, el flujo de uptake y el flujo de producción devueltos por el FBA en el instante $t$.

#### Ejemplo: simulación de un batch de *E. coli* en glucosa

```text
 t (h) │ [Glc] (g/L) │ [X] (g/L) │  [EtOH] (mmol/L) │  μ(t) (h⁻¹)
───────┼─────────────┼───────────┼──────────────────┼──────────────
   0.0 │    10.0     │   0.10    │       0.0        │    0.87
   1.0 │     8.1     │   0.24    │       1.8        │    0.87
   2.0 │     5.6     │   0.57    │       5.2        │    0.85
   3.0 │     2.2     │   1.31    │      11.3        │    0.74
   4.0 │     0.4     │   2.71    │      18.6        │    0.41
   4.5 │     0.0     │   3.10    │      20.1        │    0.00   ← glucosa agotada
   5.0 │     0.0     │   3.10    │      20.1        │    0.00
```

> [!NOTE]
> Observe que $\mu(t)$ disminuye al final **no porque cambie la red metabólica**, sino porque el FBA recibe como entrada $[Glc] \to 0$, lo que reduce el límite de uptake y por tanto la tasa de crecimiento predicha. Esta es la elegancia del dFBA: la dinámica temporal emerge del acoplamiento entre ODEs y FBA, sin necesidad de parámetros cinéticos intracelulares.

#### Comparación: ssFBA vs. dFBA vs. ODEs cinéticas

| Característica                                   | ssFBA  |          dFBA                                  | ODEs cinéticas   |
|:-------------------------------------------------|:------:|:----------------------------------------------:|:----------------:|
| Predice flujos intracelulares                    |   ✅    |                       ✅                        |        ✅         |
| Captura dinámica temporal                        |   ❌    |                       ✅                        |        ✅         |
| Requiere parámetros cinéticos ($K_m$, $V_{max}$) |   ❌    |                  Solo extrac.                  |    ✅ (todos)     |
| Escala a nivel genómico (miles de reacciones)    |   ✅    |                       ✅                        |        ❌         |
| Costo computacional                              |  Bajo  |                     Medio                      |       Alto       |
| Implementación en COBRApy / COBRA Toolbox        |   ✅    | ✅ (`cobra.flux_analysis.pfba`, `dfba` package) | Librería `scipy` |

> [!TIP]
> En Python existe el paquete **`dfba`** ([github.com/biosustain/dfba](https://github.com/biosustain/dfba)) desarrollado por el Novo Nordisk Foundation Center for Biosustainability, que integra COBRApy con `scipy.integrate` para resolver simulaciones dFBA directamente sobre cualquier modelo GEM.

---

## 8. Modelos con restricciones enzimáticas: GECKO

### 8.1 El problema de la capacidad enzimática

En FBA clásico, la única restricción sobre un flujo es el límite numérico `[lb, ub]`. Pero en la realidad, la tasa de una reacción depende de:

- **cuánta proteína enzimática hay** en la célula (nivel de expresión);
- **qué tan rápido trabaja** esa enzima (kcat: número de recambio catalítico).

La relación fundamental que introduce GECKO es:

$$v_i \leq k_{cat,i} \cdot [E_i]$$

donde $v_i$ es el flujo de la reacción $i$ (mmol·gDW⁻¹·h⁻¹), $k_{cat,i}$ es el número de recambio catalítico de la enzima $i$ (convertido a h⁻¹), y $[E_i]$ es la cantidad de enzima $i$ disponible (mmol·gDW⁻¹).

Adicionalmente, la suma de toda la proteína enzimática no puede exceder la capacidad proteómica total de la célula:

$$\sum_i MW_i \cdot [E_i] \leq P_{total}$$

donde $MW_i$ es la masa molecular de la enzima $i$ (g·mol⁻¹) y $P_{total}$ es la fracción proteómica disponible (g·gDW⁻¹, típicamente ≈ 0.5).

### 8.2 ¿Qué es GECKO?

**GECKO** (*Genome-scale model with Enzymatic Constraints using Kinetic and Omics data*) es un framework desarrollado por Benjamín Sánchez et al. que extiende los modelos GEM incorporando:

1. **Valores de kcat** para cada reacción (de BRENDA, sabio-rk o predicciones de DLKcat/TurNuP).
2. **Restricción del presupuesto proteómico** (la célula tiene un límite de cuánta proteína puede sintetizar).
3. **Variables de proteína explícitas** en el modelo, permitiendo simular sobreexpresión, downregulation y datos proteómicos cuantitativos.

El problema de optimización de un ecGEM (GECKO) extiende el LP de FBA con las nuevas restricciones:

|                            | FBA clásico                                    | ecGEM (GECKO)                                          |
|:---------------------------|:-----------------------------------------------|:-------------------------------------------------------|
| **Estado estacionario**    | $\mathbf{S} \cdot \mathbf{v} = \mathbf{0}$     | $\mathbf{S}_{ext} \cdot \mathbf{v}_{ext} = \mathbf{0}$ |
| **Límites de flujo**       | $\mathbf{lb} \leq \mathbf{v} \leq \mathbf{ub}$ | $\mathbf{lb} \leq \mathbf{v} \leq \mathbf{ub}$         |
| **Restricción enzimática** | —                                              | $v_i \leq k_{cat,i} \cdot [E_i]$                       |
| **Presupuesto proteómico** | —                                              | $\sum_i MW_i \cdot [E_i] \leq P_{total}$               |
| **No negatividad**         | —                                              | $[E_i] \geq 0$                                         |
| **Objetivo**               | $\max \ \mathbf{c}^\top \mathbf{v}$            | $\max \ \mathbf{c}^\top \mathbf{v}$                    |

### 8.3 ¿Por qué importa GECKO?

```text
Ejemplo: Producción de ácido succínico en S. cerevisiae

  FBA clásico predice:            GECKO predice:        Experimento:
  ─────────────────               ─────────────────     ────────────
  Producción: 3.2 mmol/h          Producción: 1.8 mmol/h    ~1.9 mmol/h
  Crecimiento: 0.41 h⁻¹           Crecimiento: 0.35 h⁻¹      ~0.36 h⁻¹
  
  FBA sobreestima porque          GECKO es más preciso porque
  no considera que la célula      incorpora que el presupuesto
  ya gasta proteína para crecer   proteómico es finito y compartido
  y no puede asignar "infinita"   entre crecimiento y producción.
  enzima a la producción.
```

### 8.4 Flujo de trabajo con GECKO

```text
1. Modelo GEM base (SBML / JSON)
           │
           ▼
2. Base de datos de kcat
   (BRENDA, sabio-rk, DLKcat, TurNuP)
           │
           ▼
3. [Opcional] Datos de proteómica cuantitativa
   (cuánta proteína hay en mg/gDW por condición)
           │
           ▼
4. GECKO pipeline (Python)
   → Expande S para incluir variables de proteína [E_i]
   → Asigna kcat a cada reacción enzimática
   → Define presupuesto proteómico total
           │
           ▼
5. ecGEM listo para simulación
   → FBA/pFBA con restricciones enzimáticas
   → Simulaciones de knockout y sobreexpresión realistas
   → Diseño de biofábricas con predicciones más precisas
```

> [!TIP]
> GECKO v3 no está disponible como paquete de Python compatible con COBRApy, debe usarse COBRAToolbox:
> https://github.com/SysBioChalmers/GECKO
>
> Los modelos ecGEM ya generados para *S. cerevisiae*, *E. coli* y otros organismos están en:
> https://github.com/SysBioChalmers/ecModels

---

## 9. Del genoma a la biofábrica: predicción de blancos de ingeniería metabólica

Esta sección integra todo lo visto y responde la pregunta central del módulo: **¿cómo usamos los modelos GEM y ecGEM para decidir qué genes modificar, cuáles eliminar y cuáles sobreexpresar para que una célula produzca lo que queremos?**

### 9.1 El ciclo de diseño racional (DBTL)

La ingeniería metabólica moderna sigue un ciclo iterativo:

```text
        ┌─────────────────────────────────────────────┐
        │       Ciclo DBTL (Design-Build-Test-Learn)  │
        └─────────────────────────────────────────────┘

   ┌──────────────┐     ┌──────────────┐     ┌──────────────┐     ┌──────────────┐
   │   DESIGN     │────▶│    BUILD     │────▶│     TEST     │────▶│    LEARN     │
   │              │     │              │     │              │     │              │
   │ GEM / ecGEM  │     │ Ingeniería   │     │ Cultivo +    │     │ Actualizar   │
   │ predicen los │     │ genética     │     │ medición de  │     │ el modelo    │
   │ blancos      │     │ (CRISPR,     │     │ producción   │     │ con nuevos   │
   │ óptimos      │     │ clonación)   │     │ y crecimiento│     │ datos        │
   └──────────────┘     └──────────────┘     └──────────────┘     └──────────────┘
          ▲                                                               │
          └───────────────────────────────────────────────────────────────┘
```

El modelo computacional actúa en la fase **DESIGN**: nos permite evaluar miles de combinaciones de modificaciones genéticas en horas, antes de tocar un solo tubo de ensayo.

---

### 9.2 Tipos de intervenciones que predice un modelo

Un modelo GEM puede simular cuatro tipos fundamentales de intervención genética:

```text
┌──────────────────────┬──────────────────────────────────────────────────────────┐
│ Intervención         │ Cómo se modela                                           │
├──────────────────────┼──────────────────────────────────────────────────────────┤
│ Deleción de gen      │ Fijar el flujo de la reacción asociada a v = 0           │
│                      │ (usando reglas GPR para propagar el efecto)              │
├──────────────────────┼──────────────────────────────────────────────────────────┤
│ Sobreexpresión       │ Aumentar el límite superior (ub) de la reacción          │
│                      │ En ecGEM: aumentar [E_i] → más capacidad catalítica      │
├──────────────────────┼──────────────────────────────────────────────────────────┤
│ Reducción de flujo   │ Disminuir el ub parcialmente (ej. ub × 0.3)              │
│ (downregulation)     │ En ecGEM: reducir [E_i] disponible                       │
├──────────────────────┼──────────────────────────────────────────────────────────┤
│ Introducción de gen  │ Añadir una nueva reacción al modelo con lb/ub apropiados │
│ heterólogo           │ (ruta biosintética de otro organismo)                    │
└──────────────────────┴──────────────────────────────────────────────────────────┘
```

---

### 9.3 Estrategia 1 — Deleciones: redirigir flujos eliminando rutas competidoras

La idea es sencilla: si la célula tiene una ruta alternativa que compite con la producción de nuestro compuesto de interés, **eliminarla** puede forzar el carbono hacia donde queremos.

```text
Ejemplo: producción de succinato en E. coli

  Red metabólica simplificada:

  Glucosa ──▶ PEP ──▶ Piruvato ──┬──▶ Acetato  (ruta competidora A)
                                 ├──▶ Etanol   (ruta competidora B)
                                 ├──▶ Lactato  (ruta competidora C)
                                 └──▶ OAA ──▶ Malato ──▶ Fumarato ──▶ SUCCINATO ✓

  Estrategia de deleción:
    Δpta  (fosfotransacetilasa)     → elimina ruta hacia acetato
    Δadhb (alcohol deshidrogenasa)  → elimina ruta hacia etanol
    Δldha (lactato deshidrogenasa)  → elimina ruta hacia lactato

  Resultado predicho por FBA:
    WT:       succinato = 0.1 mmol/gDW/h,  μ = 0.87 h⁻¹
    Δpta:     succinato = 0.4 mmol/gDW/h,  μ = 0.75 h⁻¹
    Δpta Δldha: succinato = 1.2 mmol/gDW/h, μ = 0.61 h⁻¹

  Interpretación:
    Cada deleción redirige más carbono hacia succinato,
    pero a costa de reducir el crecimiento (trade-off).
```

**Cómo hacerlo con COBRApy:**

```python
from cobra.flux_analysis import single_gene_deletion, double_gene_deletion

# Deleción simple sistemática: evaluar cada gen
resultados = single_gene_deletion(model)

# Filtrar genes cuya deleción aumenta la producción del producto
# (maximizando EX_succ_e como función objetivo)
with model:
    model.objective = "EX_succ_e"
    for gen_id in genes_a_evaluar:
        with model:
            model.genes.get_by_id(gen_id).knock_out()
            sol = model.optimize()
            produccion = sol.objective_value
```

---

### 9.4 Estrategia 2 — Sobreexpresión: aumentar la capacidad de pasos limitantes

A veces el flujo no llega al producto porque una enzima es el **paso limitante** (bottleneck) de la ruta. Sobreexpresarla aumenta su capacidad y puede disparar la producción.

```text
Ejemplo: sobreexpresión de PPC (fosfoenolpiruvato carboxilasa) para succinato

  PEP + CO₂ ──(PPC)──▶ OAA  ← paso que alimenta directamente la ruta del succinato

  En FBA estándar:
    Límite original de PPC: 0 ≤ v_PPC ≤ 1000 mmol/gDW/h
    Flujo predicho en WT:   v_PPC = 2.3 mmol/gDW/h

  Sobreexpresión (en ecGEM con GECKO):
    [E_PPC] × 3 → aumentar la cantidad de enzima disponible
    Nuevo flujo:  v_PPC = 6.8 mmol/gDW/h
    Producción succinato: +180% respecto al WT

  En FBA clásico (sin ecGEM):
    Simular con ub(PPC) × 3 = 3000 → menos preciso,
    pero captura la dirección del efecto.
```

**Cómo hacerlo con COBRApy:**

```python
with model:
    # Simular sobreexpresión: aumentar el límite superior de la reacción
    rxn = model.reactions.get_by_id("PPC")
    rxn.upper_bound = rxn.upper_bound * 3   # sobreexpresión 3x

    sol = model.optimize()
    print(f"Producción con sobreexpresión PPC: {sol.fluxes['EX_succ_e']:.3f}")
```

> [!NOTE]
> En un **ecGEM (GECKO)**, la sobreexpresión se modela aumentando `[E_i]`, la variable de cantidad de proteína para esa enzima. Esto es más preciso porque respeta el presupuesto proteómico: sobreexpresar una enzima consume parte del presupuesto proteico disponible para otras enzimas.

---

### 9.5 Estrategia 3 — Reducción parcial de flujo (CRISPRi / RNAi)

No siempre conviene eliminar completamente una reacción: a veces una **reducción parcial** (downregulation) permite mantener el crecimiento mientras se redirige el flujo. Esto es lo que hace experimentalmente el CRISPRi o el knockdown por RNAi.

```text
Ejemplo: reducción parcial de PYK (piruvato quinasa) en E. coli

  PEP ──(PYK)──▶ Piruvato + ATP

  Si eliminamos PYK completamente (Δpyk): la célula pierde ATP → μ cae mucho
  Si reducimos PYK al 20%: PEP se acumula → más carbono disponible para OAA → succinato ↑

  Simulación con diferentes niveles de reducción:

  Reducción PYK │ v_PYK (mmol/gDW/h) │ Succinato │ μ (h⁻¹)
  ──────────────┼────────────────────┼───────────┼─────────
  0%  (WT)      │        8.5         │   0.1     │  0.87
  50%           │        4.3         │   0.6     │  0.78
  80%           │        1.7         │   1.1     │  0.65
  100% (Δpyk)   │        0.0         │   0.8     │  0.31   ← peor que 80%!
```

**Cómo hacerlo con COBRApy:**

```python
niveles_reduccion = [1.0, 0.5, 0.2, 0.1, 0.0]  # fracción del ub original

resultados = []
with model:
    model.objective = "EX_succ_e"
    ub_original = model.reactions.get_by_id("PYK").upper_bound

    for nivel in niveles_reduccion:
        with model:
            model.reactions.get_by_id("PYK").upper_bound = ub_original * nivel
            sol = model.optimize()
            resultados.append((nivel, sol.objective_value))

for nivel, prod in resultados:
    print(f"  PYK al {nivel*100:.0f}%:  succinato = {prod:.3f} mmol/gDW/h")
```

---

### 9.6 Estrategia 4 — Introducción de rutas heterólogas

En muchos casos, el microorganismo huésped **no tiene la ruta biosintética** para el compuesto deseado. La solución es introducir genes de otro organismo. El modelo permite evaluar si la ruta heteróloga es viable **antes** de clonarla.

```text
Ejemplo: producción de 1,4-butanodiol (BDO) en E. coli
         (compuesto con múltiples aplicaciones industriales)

  E. coli no produce BDO de forma natural.
  Ruta heteróloga (tomada de varios organismos):

  Succinato ──▶ Succinil-CoA ──▶ 4-HB-CoA ──▶ 4-HB ──▶ BDO
                    ↑                ↑              ↑
                 (SucD de        (4hbD de       (adhE2 de
                Clostridium)    Porphyromonas)  Clostridium)

  Cómo se modela:
    1. Agregar las 3 nuevas reacciones al modelo GEM de E. coli
    2. Agregar el metabolito BDO y su reacción de excreción (EX_bdo_e)
    3. Ejecutar FBA maximizando EX_bdo_e
    4. Si la solución es factible y el flujo > 0: la ruta es viable

  Resultado:
    Sin optimización adicional:  BDO = 0.8 mmol/gDW/h
    + Deleción de rutas competidoras (succCoA se deriva más):  BDO = 2.1 mmol/gDW/h
```

**Cómo hacerlo con COBRApy:**

```python
from cobra import Reaction, Metabolite

with model:
    # Crear el nuevo metabolito
    bdo = Metabolite('bdo_c', formula='C4H10O2', name='1,4-Butanodiol', compartment='c')

    # Crear la reacción final de la ruta heteróloga (simplificada)
    rxn_bdo = Reaction('BDO_synth')
    rxn_bdo.name = 'BDO synthesis (heterologous)'
    rxn_bdo.lower_bound = 0
    rxn_bdo.upper_bound = 1000
    # Estequiometría: 4HB → BDO (simplificado)
    rxn_bdo.add_metabolites({
        model.metabolites.get_by_id('4hb_c'): -1,
        bdo: 1
    })
    model.add_reactions([rxn_bdo])

    # Reacción de excreción
    rxn_ex = Reaction('EX_bdo_e')
    rxn_ex.add_metabolites({bdo: -1})
    model.add_reactions([rxn_ex])

    # Evaluar
    model.objective = 'EX_bdo_e'
    sol = model.optimize()
    print(f"Producción de BDO con ruta heteróloga: {sol.objective_value:.3f}")
```

---

### 9.7 Búsqueda sistemática de blancos: OptKnock y similares

Evaluar manualmente todas las combinaciones posibles de modificaciones es inviable: con 1.000 genes candidatos, hay más de 10¹⁵ posibles dobles knockouts. Para esto existen algoritmos de **optimización combinatoria** sobre el modelo:

```text
Algoritmos de diseño de cepas:

┌────────────────┬────────────────────────────────────────────────────────┐
│ Algoritmo      │ Idea central                                           │
├────────────────┼────────────────────────────────────────────────────────┤
│ OptKnock       │ Bilevel LP: maximizar producción del compuesto         │
│                │ sujeto a que la célula maximiza su propio crecimiento  │
│                │ → Encuentra knockouts que "acoplan" crecimiento        │
│                │   con producción (la célula produce para crecer)       │
├────────────────┼────────────────────────────────────────────────────────┤
│ RobustKnock    │ Como OptKnock pero garantiza robustez frente a         │
│                │ variaciones en el flujo de biomasa                     │
├────────────────┼────────────────────────────────────────────────────────┤
│ OptForce       │ Identifica reacciones a sobreexpresar, subexpresar     │
│                │ o delegar comparando el WT vs. el estado deseado       │
├────────────────┼────────────────────────────────────────────────────────┤
│ FSEOF          │ Flux Scanning based on Enforced Objective Flux:        │
│                │ escanea el espacio de flujos para encontrar reacciones │
│                │ correlacionadas con el producto                        │
├────────────────┼────────────────────────────────────────────────────────┤
│ GECKO + MOMENT │ Usa el ecGEM para identificar enzimas limitantes       │
│                │ (con baja kcat o baja expresión) que son cuellos       │
│                │ de botella para la producción                          │
└────────────────┴────────────────────────────────────────────────────────┘
```

**El concepto clave detrás de OptKnock:**

```text
Problema bilevel de OptKnock:

  Nivel externo (ingeniero):
    Maximizar: producción del compuesto de interés (v_producto)
    Eligiendo: qué reacciones delegar (v_i = 0)

  Nivel interno (la célula):
    Maximizar: tasa de crecimiento (v_biomasa)
    Sujeto a:  S · v = 0,  lb ≤ v ≤ ub,  v_i = 0 (para genes deletados)

  Resultado: un conjunto de knockouts tal que cuando la célula
  intenta maximizar su propio crecimiento, inevitablemente produce
  el compuesto de interés como subproducto obligatorio.

  Ejemplo clásico: producción de lactato en E. coli
    OptKnock recomienda: Δpta Δadhb Δppc
    → La única forma de reoxidar NADH (necesario para crecer)
      es mediante la lactato deshidrogenasa → lactato se produce obligatoriamente
```

---

### 9.8 Usando modelos disponibles en BiGG y ecModels

No es necesario construir un modelo desde cero. Para la mayoría de los microorganismos de interés biotecnológico ya existen modelos curados y listos para usar:

```text
Modelos GEM disponibles (ejemplos):

  Organismo              │ ID del modelo │ Genes │ Reacciones │ URL
  ───────────────────────┼───────────────┼───────┼────────────┼──────────────────
  E. coli K-12           │ iJO1366       │ 1.366 │   2.583    │ bigg.ucsd.edu
  S. cerevisiae S288C    │ iMM904        │   904 │   1.577    │ bigg.ucsd.edu
  P. putida KT2440       │ iJN1463       │ 1.463 │   2.550    │ bigg.ucsd.edu
  B. subtilis 168        │ iYO844        │   844 │   1.250    │ bigg.ucsd.edu
  Synechocystis sp.      │ iJN678        │   678 │     863    │ bigg.ucsd.edu
  S. venezuelae          │ iKB1014       │ 1.014 │   1.473    │ BiGG / MEMOTE

  Modelos ecGEM (con restricciones enzimáticas, GECKO):
  E. coli K-12           │ ecModel_iJO   │       │            │ github: ecModels
  S. cerevisiae          │ ecYeast8      │       │            │ github: ecModels
  P. putida              │ ecPputida     │       │            │ github: ecModels
```

**Flujo de trabajo práctico con modelos existentes:**

```text
PASO 1 — Descargar el modelo
  → bigg.ucsd.edu → buscar organismo → Download JSON / SBML

PASO 2 — Cargar en COBRApy
  import cobra
  model = cobra.io.load_json_model("iJO1366.json")

PASO 3 — Definir las condiciones de cultivo
  → Ajustar las reacciones de intercambio (EX_) según el medio experimental
  model.reactions.get_by_id("EX_glc__D_e").lower_bound = -10   # glucosa
  model.reactions.get_by_id("EX_o2_e").lower_bound = -20       # oxígeno

PASO 4 — Verificar el modelo base
  sol = model.optimize()
  print(sol.objective_value)   # tasa de crecimiento predicha
  # Comparar con μ experimental publicada para validar

PASO 5 — Definir el compuesto objetivo
  model.objective = "EX_succ_e"   # succinato, por ejemplo

PASO 6 — Explorar blancos de ingeniería
  → Deleciones simples/dobles: single_gene_deletion(), double_gene_deletion()
  → Production envelope: production_envelope()
  → Reducción parcial: modificar ub de reacciones específicas

PASO 7 — Interpretar y priorizar
  → Ordenar por producción predicha
  → Filtrar los que mantienen μ > umbral mínimo (ej. μ > 0.1 h⁻¹)
  → Verificar que las deleciones sean experimentalmente viables

PASO 8 — Validar con ecGEM (GECKO) si está disponible
  → Cargar el ecGEM correspondiente de github.com/SysBioChalmers/ecModels
  → Repetir las simulaciones con restricciones enzimáticas
  → Comparar predicciones FBA vs. ecGEM → descartar candidatos sobreestimados
```

---

### 9.9 Resumen visual: el ciclo completo

```text
  ┌─────────────────────────────────────────────────────────────────────────┐
  │                    GENOMA DE INTERÉS                                    │
  │               (Módulos 5–6: secuenciación + anotación)                  │
  └────────────────────────────────┬────────────────────────────────────────┘
                                   │ genes + EC numbers
                                   ▼
  ┌─────────────────────────────────────────────────────────────────────────┐
  │             MODELO GEM (BiGG / reconstrucción propia)                   │
  │             metabolitos · reacciones · genes · GPR · S · v              │
  └──────────────────────────┬─────────────────────┬────────────────────────┘
                             │                     │
                    FBA / pFBA              ecGEM (GECKO)
                    (rápido, a             (más preciso,
                    escala genómica)        con kcat)
                             │                     │
            ┌────────────────┼──────────────┬──────┘
            ▼                ▼              ▼
   ┌──────────────┐  ┌──────────────┐  ┌──────────────────────┐
   │  Deleciones  │  │Sobreexpresión│  │  Reducción parcial   │
   │  (v_i = 0)   │  │ (ub_i × N)   │  │  (ub_i × fracción)   │
   │              │  │ [E_i] × N    │  │  [E_i] × fracción    │
   └──────┬───────┘  └──────┬───────┘  └──────────┬───────────┘
          │                 │                     │
          └─────────────────┼─────────────────────┘
                            │
                            ▼
              ┌─────────────────────────┐
              │  Evaluación de blancos  │
              │  OptKnock / OptForce /  │
              │  FSEOF / producción     │
              │  envelope               │
              └────────────┬────────────┘
                           │
                           ▼
              ┌─────────────────────────┐
              │  Priorización:          │
              │  producción ↑           │
              │  crecimiento aceptable  │
              │  modificaciones mínimas │
              └────────────┬────────────┘
                           │
                           ▼
              ┌─────────────────────────┐
              │  CEPA DISEÑADA          │
              │  (CRISPR, clonación,    │
              │   sobreexpresión)       │
              └────────────┬────────────┘
                           │
                           ▼
              ┌─────────────────────────┐
              │  Validación             │
              │  experimental           │
              │  → actualizar modelo    │
              └─────────────────────────┘
```

---

## 10. Cierre conceptual

En este módulo ha aprendido que:

- El **metabolismo** puede representarse como una **red (grafo)** de metabolitos conectados por reacciones enzimáticas, comparable en estructura a una red de transporte urbano.
- Las **ODEs** permiten simular cómo cambian las concentraciones de metabolitos en el tiempo, pero requieren parámetros cinéticos difíciles de medir a escala genómica.
- Los **modelos GEM** resuelven esa limitación asumiendo **estado estacionario** (S · v = 0) y formulando el problema como una optimización lineal.
- **FBA** encuentra la distribución de flujos óptima que maximiza un objetivo biológico (como el crecimiento) dentro de las restricciones de la red.
- **GECKO** extiende FBA incorporando la capacidad enzimática real (kcat, presupuesto proteómico), obteniendo predicciones más realistas y útiles para el diseño de biofábricas.
- Todo este flujo **parte del genoma**: un genoma bien anotado es el insumo inicial de cualquier modelo metabólico.

> [!IMPORTANT]
> La modelación metabólica no reemplaza el experimento: lo guía. Un buen modelo reduce el espacio de búsqueda experimental de cientos de posibles modificaciones genéticas a unas pocas candidatas con mayor probabilidad de éxito, acelerando el ciclo de diseño-construcción-prueba-aprendizaje (*DBTL cycle*) en ingeniería metabólica.

---

## Prácticas del módulo

| Práctica                                                                                  | Descripción                                                                                                                                                                       |
|:------------------------------------------------------------------------------------------|:----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [Práctica — Google Colab: Introducción a COBRApy](exercises/01_intro_cobrapy_colab.ipynb) | Exploración de un modelo GEM (*E. coli* iJO1366), simulaciones FBA, análisis de knockouts, exploración de la matriz estequiométrica y diseño básico de biofábricas usando COBRApy |

