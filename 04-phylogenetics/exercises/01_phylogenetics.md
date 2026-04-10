# 🧬 Práctica: Identificación bacteriana por análisis filogenético del gen 16S rRNA

## Introducción

En microbiología, uno de los retos más comunes es identificar un microorganismo desconocido aislado de una muestra clínica, ambiental o industrial. Aunque las pruebas bioquímicas y la morfología aportan pistas, la identificación definitiva a menudo requiere comparar marcadores moleculares — en particular, el gen **16S rRNA** — contra secuencias de referencia depositadas en bases de datos públicas.

En esta práctica, usted recibirá una **secuencia 16S rRNA desconocida** correspondiente a uno de tres escenarios reales. Su trabajo será:

1. **Buscar secuencias similares** usando BLAST en NCBI.
2. **Seleccionar y descargar** secuencias de referencia de al menos **10 géneros/especies diferentes**.
3. **Construir un archivo FASTA combinado** que incluya las referencias y la secuencia desconocida.
4. **Realizar un alineamiento múltiple** y **construir un árbol filogenético** en MEGA.
5. **Interpretar el árbol** para proponer la identidad del microorganismo.

Esta práctica integra conceptos de los Módulos [1](../../01-introduction/README.md) (bases de datos), [3](../../03-sequence_analysis/README.md) (alineamiento y BLAST) y [4](../../04-phylogenetics/README.md) (filogenética).

---

## 🎯 Objetivos

- Aplicar **BLAST** para buscar secuencias homólogas a una secuencia problema.
- Evaluar críticamente los resultados de BLAST: **% Identity**, **Query Cover**, **E-value**.
- Seleccionar secuencias de referencia de **múltiples géneros y especies** para construir un árbol informativo.
- Crear un archivo **FASTA multisecuencia** combinando referencias y la muestra desconocida.
- Realizar un **alineamiento múltiple de secuencias (MSA)** con ClustalW o MUSCLE en MEGA.
- Construir un **árbol filogenético** (Neighbor-Joining y/o Maximum Likelihood) con evaluación por **bootstrap**.
- Interpretar el árbol para proponer una **identificación taxonómica**.

---

## 📦 Requisitos previos

- Computador con **Windows**, **macOS** o **Linux**.
- Software [**MEGA X**](https://www.megasoftware.net/) instalado.
- Conexión a internet para acceder a [NCBI BLAST](https://blast.ncbi.nlm.nih.gov/).
- Haber trabajado con bases de datos biológicas en el [Módulo 1](../../01-introduction/exercises/01_databases.md).
- Haber leído las secciones sobre BLAST y alineamiento en el [Módulo 3](../../03-sequence_analysis/README.md).
- Haber leído los conceptos de filogenética en el [Módulo 4](../../04-phylogenetics/README.md).

---

## 🧫 Casos de estudio

Esta práctica se organiza por **casos**. El profesor indicará cuál caso trabajar. Cada caso presenta un escenario real con una secuencia 16S rRNA desconocida y un contexto biológico diferente.

> [!IMPORTANT]
> Todas las secuencias se encuentran en el archivo [`data/unknown_seqs.fasta`](data/unknown_seqs.fasta). Descargue o copie **únicamente** la secuencia del caso asignado.

### Caso A — Aislado clínico (bacilo Gram negativo)

**Contexto:** En el laboratorio de microbiología clínica de un hospital se aisló una bacteria de un hemocultivo. La tinción de Gram mostró **bacilos Gram negativos** y las pruebas bioquímicas iniciales indican fermentación de lactosa. Se realizó la secuenciación parcial del gen 16S rRNA para confirmar la identidad.

- **Secuencia:** `>16S ribosomal RNA gene, partial sequence, unknown clinical bacterium` en `data/unknown_seqs.fasta`
- **Pistas:** Gram negativa, bacilo, fermentadora de lactosa, origen clínico.
- **Familia probable:** Enterobacteriaceae.

### Caso B — Aislado ambiental de corteza de árbol (bacilo Gram negativo)

**Contexto:** Durante un muestreo de biodiversidad en un bosque tropical, se aisló una bacteria de la corteza de un árbol de bosques del norte de Europa. La morfología muestra **bacilos Gram negativos**, no fermentadores. Se sospecha de un organismo asociado a la rizósfera.

- **Secuencia:** `>16S ribosomal RNA gene, partial sequence, unknown environment bacterium` en `data/unknown_seqs.fasta`
- **Pistas:** Gram negativa, bacilo, no fermentadora, asociada a planta/suelo.
- **Familias probables:** Rhizobiaceae, Bradyrhizobiaceae o Xanthomonadaceae.

### Caso C — Actinobacterias del suelo (dos aislados)

**Contexto:** En un proyecto de bioprospección, se aislaron dos colonias de aspecto pulverulento y olor terroso de muestras de suelo agrícola. La microscopía reveló filamentos ramificados compatibles con **actinobacterias**. Se sospecha que pertenecen al género *Streptomyces*, un grupo de enorme importancia biotecnológica por su producción de antibióticos.

- **Secuencias:** `>16S ribosomal RNA gene, partial sequence, unknown soil bacterium_1` y `>...unknown soil bacterium_2` en `data/unknown_seqs.fasta`
- **Pistas:** Gram positiva (alto contenido GC), filamentosa, olor terroso, suelo agrícola.
- **Familia probable:** Streptomycetaceae.

> [!NOTE]
> En el Caso C se trabaja con **dos secuencias** del mismo ambiente. Parte del análisis será determinar si ambos aislados pertenecen a la misma especie o a especies diferentes dentro del mismo género.

---

## 🔬 Procedimiento

### Parte 1: Obtener la secuencia problema

#### Paso 1 — Acceder al archivo de secuencias

Las secuencias están disponibles en la carpeta `data/` de esta práctica:

```text
04-phylogenetics/
└── exercises/
    ├── 01_phylogenetics.md   ← esta guía
    └── data/
        └── unknown_seqs.fasta  ← todas las secuencias problema
```

Abra el archivo `data/unknown_seqs.fasta` en un editor de texto y copie **únicamente** la secuencia correspondiente a su caso asignado.

#### Paso 2 — Crear un archivo individual para su caso

Cree un archivo FASTA separado para su secuencia problema. Puede hacerlo de dos formas:

**Opción A — Manual:** copie la secuencia y péguela en un archivo nuevo. Guárdelo como:

```text
caso_X_unknown.fasta
```

(donde `X` es A, B o C según su caso).

**Opción B — Desde terminal (Codespaces):**

```bash
# Crear carpeta de trabajo
mkdir -p phylo_analysis/data phylo_analysis/results
cd phylo_analysis

# Extraer solo la secuencia de su caso (ejemplo para Caso A):
grep -A 100 "unknown clinical" ../data/unknown_seqs.fasta | sed '/^>16S.*unknown environment/,$d' > data/caso_A_unknown.fasta

# Verificar
head data/caso_A_unknown.fasta
```

> [!TIP]
> El comando `grep -A 100` busca el encabezado que contiene la palabra clave y muestra las 100 líneas siguientes. El `sed '/^>16S.*unknown environment/,$d'` elimina todo desde la siguiente secuencia en adelante. Ajuste las palabras clave según su caso:
>
> | Caso | Comando                                                                                                                                     |
> |:-----|:--------------------------------------------------------------------------------------------------------------------------------------------|
> | A    | `grep -A 100 "unknown clinical" ../data/unknown_seqs.fasta \| sed '/^>16S.*unknown environment/,$d' > data/caso_A_unknown.fasta`            |
> | B    | `grep -A 100 "unknown environment" ../data/unknown_seqs.fasta \| sed '/^>16S.*unknown soil/,$d' > data/caso_B_unknown.fasta`                |
> | C    | `grep -A 200 "unknown soil" ../data/unknown_seqs.fasta > data/caso_C_unknown.fasta`                                                         |
>
> **Nota sobre el Caso C:** el `grep "unknown soil"` captura **ambas** secuencias (`bacterium_1` y `bacterium_2`) porque las dos contienen la palabra `soil`. Al usar `-A 200` se incluyen las líneas de secuencia de ambas. Como son las dos últimas del archivo, no se necesita `sed` para cortar.

#### Paso 3 — Inspección rápida de la secuencia

Antes de hacer BLAST, observe su secuencia:

```bash
# Longitud aproximada (en nucleótidos)
grep -v "^>" data/caso_A_unknown.fasta | tr -d '\n' | wc -c

# Primeros 200 caracteres
grep -v "^>" data/caso_A_unknown.fasta | tr -d '\n' | head -c 200
echo ""
```

**Preguntas de inspección:**
- ¿Cuántos nucleótidos tiene la secuencia?
- ¿Contiene caracteres ambiguos (`N`, `R`, `Y`, etc.)?
- ¿Es una longitud razonable para un gen 16S rRNA parcial (~800–1500 pb)?

> [!NOTE]
> **Recordatorio:** el gen 16S rRNA completo tiene ~1542 pb en *E. coli*. Una secuencia parcial típica obtenida por Sanger abarca 800–1000 pb. Si su secuencia es mucho más corta, el poder de resolución filogenética puede ser limitado.

---

### Parte 2: Identificación preliminar con BLAST

#### Paso 1 — Ejecutar BLASTn en NCBI

1. Vaya a [NCBI Nucleotide BLAST](https://blast.ncbi.nlm.nih.gov/Blast.cgi) y seleccione **Nucleotide BLAST**.
2. Pegue su secuencia en el recuadro *Enter Query Sequence*.
3. En **Database**, seleccione:
   - **`16S ribosomal RNA sequences (Bacteria and Archaea)`** — esta es la base de datos más adecuada para identificación de procariotas por 16S.

> [!TIP]
> Si la base de datos `16S ribosomal RNA sequences` no aparece, seleccione **`rRNA/ITS databases`** y luego la subcategoría correspondiente. Como alternativa, puede usar `nr/nt` (nucleotide collection), pero los resultados serán más difíciles de filtrar.

4. Parámetros recomendados:
   - **Max target sequences:** `50` (queremos ver variedad de hits).
   - **Expect threshold (E-value):** `1e-5` (valor por defecto, adecuado).
   - Marque la casilla **"Show results in a new window"** para no perder la página.
5. Haga clic en **BLAST** y espere los resultados (puede tardar 30 segundos a 2 minutos).

#### Paso 2 — Analizar los resultados

Cuando aparezcan los resultados, observe la **tabla de hits** (*Descriptions*). Registre para los **10 mejores hits**:

| Dato a registrar | ¿Dónde lo encuentra?                   |
|:-----------------|:---------------------------------------|
| **Accession**    | Columna "Accession" en la tabla        |
| **Organism**     | Nombre del organismo en la descripción |
| **% Identity**   | Columna "Per. Ident"                   |
| **Query Cover**  | Columna "Query Cover"                  |
| **E-value**      | Columna "E value"                      |
| **Bit Score**    | Columna "Total Score"                  |

> [!WARNING]
> **No se quede solo con el primer hit.** Es común que los primeros 5–10 hits tengan porcentajes de identidad muy similares (por ejemplo, 99.5% vs. 99.3%). Revise las descripciones para ver si pertenecen a **géneros diferentes** o son todas de la misma especie.

#### Paso 3 — Interpretar la identificación preliminar

Use estos criterios empíricos para 16S rRNA:

```text
┌─────────────────────────────┬──────────────────────────────────────────────────┐
│  % Identity (16S rRNA)      │  Interpretación                                  │
├─────────────────────────────┼──────────────────────────────────────────────────┤
│  ≥ 99%                      │  Muy probable: misma especie                     │
│  97 – 99%                   │  Probable: misma especie o especie muy cercana   │
│  95 – 97%                   │  Probable: mismo género, diferente especie       │
│  90 – 95%                   │  Probable: misma familia, diferente género       │
│  < 90%                      │  Relación lejana; puede ser familia diferente    │
└─────────────────────────────┴──────────────────────────────────────────────────┘
```

> [!IMPORTANT]
> **Recuerde:** BLAST es una herramienta de búsqueda por similitud, **no un método filogenético**. El % Identity de un BLAST no reemplaza un árbol filogenético. Dos secuencias pueden tener 98% de identidad y pertenecer a géneros diferentes (o tener 99.5% y ser cepas distintas de la misma especie). El árbol que construirá en las siguientes partes es la evidencia más sólida.

**Preguntas para registrar en su informe:**
1. ¿Cuál es el organismo del **mejor hit** (mayor % Identity y Query Cover)?
2. ¿Todos los top-10 hits pertenecen al **mismo género**? ¿O hay mezcla de géneros?
3. ¿Hay diferencia significativa entre el primer y el décimo hit en términos de % Identity?
4. Basándose solo en BLAST, ¿a qué especie cree que pertenece su secuencia desconocida? ¿Con qué nivel de confianza?

> [!TIP]
> **Para el Caso C:** ejecute BLAST para **ambas** secuencias (C1 y C2) por separado. Compare los resultados: ¿ambas dan el mismo organismo como mejor hit? ¿O sugieren especies diferentes dentro del mismo género?

---

### Parte 3: Selección y descarga de secuencias de referencia

Esta es la parte clave de la práctica. Un árbol filogenético es tan informativo como las **secuencias de referencia** que incluya. Si solo descarga secuencias de una sola especie, el árbol no le dirá mucho. Si incluye secuencias de múltiples géneros, podrá ver dónde se posiciona su muestra desconocida en un contexto evolutivo amplio.

#### Paso 1 — Definir el conjunto de referencias

A partir de los resultados de BLAST, seleccione **al menos 10 secuencias de referencia** que cumplan:

| Criterio                                                | Razón                                                                                  |
|:--------------------------------------------------------|:---------------------------------------------------------------------------------------|
| Al menos **3–4 géneros diferentes**                     | Para dar contexto filogenético amplio                                                  |
| Al menos **2–3 especies del género más cercano**        | Para evaluar a qué especie se acerca más su muestra                                    |
| Al menos **1 secuencia de un grupo externo (outgroup)** | Para enraizar el árbol (por ejemplo, un Firmicute si sus hits son Proteobacteria)      |
| Preferir secuencias de **cepas tipo** (*type strain*)   | Son la referencia oficial de cada especie                                              |

> [!TIP]
> **¿Qué es un outgroup?** Es una secuencia de un organismo que usted sabe que es más lejano que todos los demás en su análisis. Sirve para **enraizar** el árbol (definir qué dirección es "hacia el pasado"). Por ejemplo:
> - Si trabaja con **Enterobacteriaceae** (Caso A) → un buen outgroup podría ser *Bacillus subtilis* o *Pseudomonas aeruginosa*.
> - Si trabaja con **Rhizobiaceae** (Caso B) → un buen outgroup podría ser *Escherichia coli*.
> - Si trabaja con **Streptomyces** (Caso C) → un buen outgroup podría ser *Bacillus subtilis* o *Mycobacterium tuberculosis*.

#### Paso 2 — Descargar las secuencias de referencia

Tiene dos opciones:

**Opción A — Desde la página de resultados de BLAST:**

1. En los resultados de BLAST, marque las casillas de las secuencias que desea descargar.
2. Haga clic en **Download** → **FASTA (aligned sequences)** o **FASTA (complete sequences)**.
3. Guarde el archivo como `blast_references.fasta`.

**Opción B — Búsqueda individual en NCBI Nucleotide:**

1. Vaya a [NCBI Nucleotide](https://www.ncbi.nlm.nih.gov/nucleotide/).
2. Busque por nombre: por ejemplo, `"Salmonella enterica" 16S rRNA type strain`.
3. Seleccione un registro apropiado (secuencia parcial o completa del 16S).
4. Descargue en formato FASTA: **Send to → File → FASTA**.

**Opción C — Descarga con `wget` desde terminal:**

```bash
# Ejemplo: descargar una secuencia por su accession
ACCESSION="NR_114042"
wget -O data/ref_${ACCESSION}.fasta \
  "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=${ACCESSION}&rettype=fasta&retmode=text"
```

> [!WARNING]
> Si obtiene el error `data/ref_NR_114042.fasta: No such file or directory`, ejecute primero `mkdir -p data`.

> [!TIP]
> **Descarga en lote:** si tiene múltiples accessions, puede descargarlos todos de una vez separándolos por comas:
> ```bash
> ACCESSIONS="NR_114042,NR_028687,NR_113597,NR_074911"
> wget -O data/all_references.fasta \
>   "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=${ACCESSIONS}&rettype=fasta&retmode=text"
> ```

#### Paso 3 — Organizar las secuencias descargadas

Verifique que tiene al menos 10 secuencias de referencia:

```bash
grep -c "^>" data/*.fasta
```

Registre en una tabla como la siguiente (ejemplo):

| # | Accession  | Organismo                            | Rol en el árbol         |
|:--|:-----------|:-------------------------------------|:------------------------|
| 1 | NR_114042  | *Escherichia coli* (type strain)     | Referencia cercana      |
| 2 | NR_028687  | *Salmonella enterica* serovar Typhi  | Referencia cercana      |
| 3 | NR_113597  | *Klebsiella pneumoniae*              | Referencia del género   |
| 4 | NR_074911  | *Pseudomonas aeruginosa*             | Otro género (γ-Proteo.) |
| 5 | ...        | ...                                  | ...                     |
| 10| NR_027552  | *Bacillus subtilis*                  | **Outgroup**            |
| 11| —          | Secuencia desconocida (Caso X)       | **Query**               |

---

### Parte 4: Crear el archivo FASTA combinado

#### Paso 1 — Unir todas las secuencias en un solo archivo

Necesita un **único archivo FASTA** que contenga todas las secuencias de referencia + la secuencia desconocida.

**Opción A — Manual (editor de texto):**

1. Abra un editor de texto (Notepad, VS Code, etc.).
2. Copie y pegue todas las secuencias de referencia descargadas.
3. Al final, agregue la secuencia de su caso.
4. Guarde como `16S_analysis.fasta`.

**Opción B — Desde terminal:**

```bash
# Combinar todas las referencias y la secuencia desconocida
cat data/all_references.fasta data/caso_A_unknown.fasta > data/16S_analysis.fasta

# Verificar el número total de secuencias
grep -c "^>" data/16S_analysis.fasta
```

> [!WARNING]
> **Verifique siempre** que:
> - Cada secuencia tiene su encabezado (`>`) en una línea independiente.
> - No hay líneas en blanco dentro de una secuencia.
> - El archivo tiene al menos **11 secuencias** (10 referencias + 1 desconocida).
> - Para el **Caso C**, incluya **ambas** secuencias desconocidas (C1 y C2), lo que da al menos **12 secuencias**.

#### Paso 2 — Renombrar los encabezados (recomendado)

Los encabezados de NCBI suelen ser muy largos. Para que el árbol sea legible, conviene acortarlos. En el editor de texto, renombre los encabezados de forma informativa pero breve:

```text
Antes:
>NR_114042.1 Escherichia coli strain U 5/41 16S ribosomal RNA, partial sequence

Después:
>E_coli_U541_NR114042
```

> [!TIP]
> Incluya siempre el **nombre del organismo** y el **accession** en el encabezado abreviado. Así puede rastrear cada secuencia si necesita verificar algo. Para la secuencia desconocida, use algo como `>UNKNOWN_CaseA`.

---

### Parte 5: Alineamiento múltiple en MEGA

#### Paso 1 — Importar las secuencias

En este punto existen dos formas de hacerlo: 

En el primer caso, cargando el archivo FASTA directamente (es el más sencillo):

1. Abra **MEGA X**.
2. Vaya a **Align → Edit/Build Alignment**.
3. Seleccione **Retrieve Sequences From a File**
4. Importe el archivo `16S_analysis.fasta`.
5. Verifique que **todas** las secuencias aparecen en la lista.

En el segundo caso, pasando el archivo FASTA al editor de alineamiento:

1. Abra **MEGA X**.
2. Vaya a **Align → Edit/Build Alignment**.
3. Seleccione **Create a new alignment** → tipo de datos: **DNA**.
4. En la ventana del editor, vaya a **Edit → Insert sequence from file** (o arrastre el archivo).
5. Importe el archivo `16S_analysis.fasta`.
6. Verifique que **todas** las secuencias aparecen en la lista (revise el número en la esquina inferior y elimínela si está en blanco).

> [!TIP]
> Note que se usa el encabezado abreviado de cada secuencia para identificarla. Una buena estrategia es usar el nombre del organismo y el accession usando guiones bajos (`_`) para evitar espacios, lo que facilita la lectura del árbol posteriormente.

#### Paso 2 — Realizar el alineamiento

1. Seleccione **todas** las secuencias (Ctrl+A o Cmd+A).
2. Vaya a **Alignment → Align by MUSCLE** (recomendado) o **Align by ClustalW**.
3. Deje los parámetros por defecto y haga clic en **OK**.
4. Espere a que termine el alineamiento (puede tardar unos segundos a un minuto).

> [!TIP]
> **MUSCLE vs. ClustalW:** ambos son algoritmos de alineamiento múltiple. MUSCLE suele ser más rápido y preciso para conjuntos medianos de secuencias. ClustalW es más clásico y ampliamente citado. Para esta práctica, cualquiera de los dos funciona bien.

#### Paso 3 — Inspeccionar el alineamiento

Revise visualmente el alineamiento:

- ¿Hay **regiones muy conservadas** (columnas donde todas las secuencias tienen la misma base)?
- ¿Hay **regiones variables** (columnas con muchas diferencias)?
- ¿La secuencia desconocida tiene muchos **gaps** respecto a las demás? (esto podría indicar que es muy divergente o que la secuencia es de baja calidad).

> [!WARNING]
> Si observa que una secuencia tiene **muchos gaps** al inicio o al final mientras las demás no, puede ser que las secuencias tengan longitudes muy diferentes. Considere **recortar** (*trim*) los extremos del alineamiento para que todas las secuencias cubran la misma región.

#### Paso 4 — Guardar el alineamiento

Guarde el alineamiento en formato MEGA:

1. Vaya a **Data** (el que esta en la parte superior, no el icono verde) → **Export Alignment** → **MEGA format**.

```text
16S_alignment.meg
```

También puede exportar en formato FASTA alineado por si necesita usarlo en otro software.

2. Cierre la ventana del editor de alineamiento.

---

### Parte 6: Construcción del árbol filogenético

#### Paso 1 — Abrir el alineamiento para análisis

1. En MEGA X, vaya a **File → Open a File/Session**.
2. Abra el archivo `16S_alignment.meg`.
3. MEGA puede que le pregunte qué desea hacer → seleccione **Analyze**.

#### Paso 2 — Construir el árbol por Neighbor-Joining (NJ)

1. Vaya a **Phylogeny → Construct/Test Neighbor-Joining Tree**.
2. Configure los parámetros:
   - **Model/Method:** Tamura-Nei (para nucleótidos).
   - **Test of Phylogeny:** Bootstrap method.
   - **No. of Bootstrap Replications:** **500** (mínimo recomendado; 1000 es mejor si tiene tiempo).
   - **Gaps/Missing Data Treatment:** Pairwise deletion o Complete deletion.
3. Haga clic en **Compute**.

> [!NOTE]
> **¿Por qué Neighbor-Joining?** Es rápido, intuitivo y produce resultados razonables para conjuntos pequeños de secuencias con divergencia moderada. Es un buen punto de partida antes de usar métodos más complejos.

#### Paso 3 — (Opcional) Construir el árbol por Maximum Likelihood (ML)

Si el tiempo lo permite, construya también un árbol ML para comparar:

1. Vaya a **Phylogeny → Construct/Test Maximum Likelihood Tree**.
2. Use el mismo modelo (Tamura-Nei) y bootstrap (**500** réplicas).
3. Haga clic en **Compute** (este método tarda más que NJ).

> [!TIP]
> **NJ vs. ML:**
> | Característica | Neighbor-Joining | Maximum Likelihood |
> |:---------------|:-----------------|:-------------------|
> | Velocidad | Rápido | Más lento |
> | Base teórica | Distancias | Modelo probabilístico |
> | Precisión | Buena para datos simples | Más robusto con datos complejos |
> | Bootstrap | Rápido | Puede ser lento con muchas réplicas |

---

### Parte 7: Interpretación del árbol

#### Paso 1 — Visualización

1. En la ventana del árbol, explore las opciones de visualización:
   - Dando doble clic en el nombre de la secuencia puede editar su nombre para facilitar su lectura.
   - **Topology only** vs. **Branch lengths** (con longitudes de rama proporcionales a la distancia).
   - Active la opción de mostrar **valores de bootstrap** en los nodos.

2. Identifique en el árbol:
   - ¿Dónde se posiciona su **secuencia desconocida**?
   - ¿Con qué especie(s) de referencia se agrupa?
   - ¿El valor de bootstrap del nodo que la une a su grupo más cercano es **alto** (≥ 70%) o **bajo**?

```text
Ejemplo de lectura de un árbol (esquemático):

  ┌──── E. coli cepa 1
  ├──── E. coli cepa 2
──┤ 95%
  ├──── UNKNOWN_CaseA         ← ¿Se agrupa con E. coli? ¿Bootstrap alto?
  │
  ├──── Salmonella enterica
  │ 88%
  ├──── Klebsiella pneumoniae
  │
  └──── Bacillus subtilis     ← outgroup (la rama más lejana)
```

#### Paso 2 — Preguntas de interpretación

Responda las siguientes preguntas en su informe:

1. **¿Con qué especie se agrupa su secuencia desconocida?** ¿Es consistente con lo que predijo BLAST?
2. **¿El soporte de bootstrap es alto?** Un valor ≥ 70% generalmente se considera un soporte moderado-alto. Si es < 50%, la agrupación no es confiable.
3. **¿El outgroup se posiciona correctamente?** Debería estar en la rama más lejana del árbol.
4. **¿Las especies del mismo género se agrupan juntas?** Por ejemplo, si incluyó dos cepas de *E. coli*, ¿están en la misma rama?
5. **¿Hay alguna agrupación inesperada?** ¿Alguna especie que esperaba ver lejos aparece cerca, o viceversa?

> [!TIP]
> **Para el Caso C:** preste especial atención a la relación entre C1 y C2:
> - ¿Se agrupan juntas en la misma rama?
> - ¿Están más cerca entre sí que de cualquier referencia de *Streptomyces*?
> - ¿Podrían ser la misma especie o son especies diferentes del mismo género?

#### Paso 3 — Exportar el árbol

Guarde el árbol en dos formatos:

1. **Imagen:** haga clic derecho sobre el árbol → **Image → Save as PNG/PDF**.
   ```text
   tree_NJ.png
   ```
   
> [!TIP]
> Debido a calidad de la imagen, es recomendable usar formato **PDF** para que no pierda resolución al ampliarla ya que es un formato vectorial y puede ser editado posteriormente.

2. **Formato Newick:** **File → Export Current Tree (Newick)**.
   ```text
   tree_NJ.nwk
   ```

> [!NOTE]
> El formato **Newick** es un estándar de texto plano para representar árboles filogenéticos. Es útil para compartir árboles, importarlos en otros programas (como iTOL, FigTree, o R) o incluirlos en publicaciones.
>
> Ejemplo de un árbol en formato Newick:
> ```text
> ((E_coli_1:0.002,E_coli_2:0.003):0.01,S_enterica:0.015,B_subtilis:0.2);
> ```

---

### Parte 8: Informe final

Prepare un informe breve (1–2 páginas) que incluya:

| Sección                               | Contenido                                                                                           |
|:--------------------------------------|:----------------------------------------------------------------------------------------------------|
| **Caso asignado**                     | Indique cuál caso trabajó (A, B o C) y el contexto biológico                                        |
| **Resultados de BLAST**               | Tabla con los 10 mejores hits (accession, organismo, % Identity, Query Cover, E-value)              |
| **Identificación preliminar**         | ¿A qué organismo apuntan los resultados de BLAST? ¿Con qué confianza?                               |
| **Tabla de secuencias de referencia** | Lista de las secuencias incluidas en el árbol (accession, organismo, rol)                           |
| **Árbol filogenético**                | Imagen del árbol con valores de bootstrap (incluya NJ y ML si hizo ambos)                           |
| **Interpretación del árbol**          | ¿Dónde se posiciona la secuencia desconocida? ¿Es consistente con BLAST? ¿El bootstrap lo respalda? |
| **Conclusión**                        | Identidad propuesta del organismo desconocido + nivel de confianza + evidencia que la respalda      |

---

## ❓ Preguntas para reflexionar

1. Si BLAST sugiere que su secuencia tiene 99.5% de identidad con *Especie X*, pero en el árbol filogenético se agrupa con *Especie Y* (con alto bootstrap), ¿en cuál resultado confía más? ¿Por qué?
2. ¿Por qué es importante incluir un **outgroup** en el árbol? ¿Qué pasaría si no lo incluyera?
3. Si los primeros 10 hits de BLAST tienen entre 98.5% y 99.2% de identidad con **3 géneros diferentes**, ¿puede afirmar con certeza a qué género pertenece su secuencia? ¿Qué haría para resolver la ambigüedad?
4. ¿Por qué el gen **16S rRNA** es útil pero **no suficiente** para distinguir entre todas las especies bacterianas? ¿Qué otros marcadores o aproximaciones complementarias existen? (Revise la [sección 1.4 del README del Módulo 4](../README.md)).
5. **Para el Caso C:** si ambas secuencias (C1 y C2) se agrupan juntas pero lejos de cualquier especie descrita de *Streptomyces*, ¿qué podría significar esto desde el punto de vista taxonómico?
6. ¿Qué representan los **valores de bootstrap** en cada nodo del árbol? ¿Un nodo con bootstrap de 45% es confiable?
7. ¿Cómo podría afectar la **calidad del alineamiento** al resultado del árbol filogenético?

---

## 🏆 Reto adicional (opcional)

Si terminó la práctica y quiere profundizar:

- **Reto 1:** Descargue **20 secuencias** (en lugar de 10) de referencia, incluyendo más especies de la familia más cercana a su secuencia desconocida. Reconstruya el árbol y compare: ¿cambia la posición de su secuencia desconocida?

- **Reto 2:** Exporte el árbol en formato Newick y visualícelo en [**iTOL** (Interactive Tree of Life)](https://itol.embl.de/). Explore las opciones de visualización y coloreado.

- **Reto 3 (Caso C):** Calcule la **distancia genética** (en MEGA: **Distance → Compute Pairwise Distances**) entre C1 y C2. Compare ese valor con la distancia entre especies conocidas de *Streptomyces* en su árbol. ¿Están C1 y C2 más cerca entre sí que entre dos especies conocidas?

- **Reto 4:** Repita el BLAST usando la base de datos `nr/nt` en lugar de `16S ribosomal RNA sequences`. ¿Cambian los resultados? ¿Aparecen hits adicionales de organismos no cultivados (*uncultured bacterium*)?

---

## 📚 Recursos adicionales

- [NCBI BLAST](https://blast.ncbi.nlm.nih.gov/) — búsqueda por similitud.
- [MEGA Software](https://www.megasoftware.net/) — alineamiento y filogenética.
- [iTOL](https://itol.embl.de/) — visualización interactiva de árboles.
- [FigTree](http://tree.bio.ed.ac.uk/software/figtree/) — visualización de árboles en escritorio.
- [SILVA Database](https://www.arb-silva.de/) — base de datos curada de secuencias rRNA.
- [EzBioCloud](https://www.ezbiocloud.net/) — identificación de procariotas por 16S con cepas tipo.
- [README del Módulo 4](../README.md) — conceptos de filogenética, MSA, modelos de sustitución y métodos de construcción de árboles.

