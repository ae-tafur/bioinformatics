# 🧪 Práctica: Diseño de primers para amplificación de ADN

## Introducción

El diseño de **primers** (cebadores) es una de las aplicaciones más directas y útiles de los conceptos de secuencias, complementariedad de bases y alineamiento. Un primer no es más que un oligonucleótido corto de ADN que se une a una región específica de una secuencia molde y permite iniciar la amplificación por PCR.

Aunque en el laboratorio los primers se compran como moléculas físicas, su diseño es un problema bioinformático: hay que seleccionar una región adecuada, verificar que la secuencia sea específica, evitar uniones inespecíficas, controlar propiedades termodinámicas básicas y estimar si el amplicón esperado tendrá el tamaño correcto.

Por eso, esta práctica encaja muy bien en el **Módulo 3**. Aquí ya ha trabajado con bases de datos biológicas, formatos de secuencia y conceptos de alineamiento. El diseño de primers le permite aplicar todo esto a una tarea experimental real. Además, esta práctica funciona como un puente natural hacia el **Módulo 4**, porque en genómica los primers se usan para:

- verificar por PCR la presencia de un gen anotado;
- confirmar resultados obtenidos por ensamblaje o anotación;
- diseñar estrategias para cerrar *gaps* o validar contigs;
- comprobar la presencia de genes de resistencia, virulencia o marcadores taxonómicos.

En esta práctica obtendrá una secuencia de interés desde una base de datos pública, revisará sus características, diseñará un par de primers con una herramienta accesible como **NCBI Primer-BLAST** y evaluará si ese diseño parece razonable desde el punto de vista biológico y bioinformático.

---

## 🎯 Objetivos

- Comprender qué características hacen que un primer sea adecuado o inadecuado.
- Obtener una secuencia blanco desde una base de datos pública usando un **GenBank ID** o el comando **`wget`**.
- Identificar una región candidata para amplificación dentro de una secuencia de ADN.
- Diseñar un par de primers con **Primer-BLAST** o **Primer3**.
- Interpretar parámetros básicos como **longitud**, **%GC**, **Tm**, **tamaño del amplicón** y **especificidad**.
- Realizar una validación *in silico* del tamaño esperado del amplicón.
- Interpretar de forma básica una **electroforesis *in silico*** a partir del tamaño esperado del producto.
- Aplicar el concepto de **reverse complement** para entender la lógica del primer reverso.

---

## 📦 Requisitos previos

- Haber trabajado con bases de datos biológicas en el **Módulo 1**.
- Haber leído el **README del Módulo 3**, especialmente las secciones sobre FASTA, alineamiento, identidad y similitud.
- Tener acceso a un navegador web.
- Tener acceso a **GitHub Codespaces** o a una terminal Unix si desea descargar la secuencia con `wget`.
- Como apoyo opcional, haber realizado la práctica [`scripting_in_python.md`](../../02-coding-basics/exercises/scripting_in_python.md), ya que reutilizaremos la idea de **complemento inverso**.

---

## 🧠 Conceptos clave antes de empezar

Un buen primer no se elige al azar. Debe cumplir, en general, varios criterios básicos:

| Parámetro                        | Recomendación general                                                                 | ¿Por qué importa?                                                                         |
|:---------------------------------|:--------------------------------------------------------------------------------------|:------------------------------------------------------------------------------------------|
| **Longitud del primer**          | 18–25 nt                                                                              | Demasiado corto reduce especificidad; demasiado largo puede dificultar la unión eficiente |
| **Contenido GC**                 | 40–60%                                                                                | Influye en estabilidad y temperatura de fusión                                            |
| **Tm**                           | 55–65 °C                                                                              | El par de primers debe tener Tm similares para funcionar bien en la misma PCR             |
| **Diferencia de Tm entre F y R** | Idealmente ≤ 2 °C                                                                     | Reduce desbalance en la amplificación                                                     |
| **Extremo 3'**                   | Evitar desajustes y estructuras problemáticas; a veces conviene un pequeño “GC clamp” | El extremo 3' es crítico para la extensión por la polimerasa                              |
| **Repeticiones / homopolímeros** | Evitarlos si es posible                                                               | Pueden favorecer uniones inespecíficas o errores                                          |
| **Auto-complementariedad**       | Baja                                                                                  | Reduce la formación de horquillas y dímeros                                               |
| **Tamaño del amplicón**          | Depende del objetivo; 100–500 pb es cómodo para PCR convencional y análisis básico    | Productos muy largos pueden ser más difíciles de amplificar                               |

> 💡 **Idea clave:** la PCR no "lee intenciones". Si el primer puede unirse a varios sitios o formar dímeros, lo hará. Por eso la especificidad es tan importante como la longitud o la Tm.

---

## 🗂️ Escenario de trabajo

En esta práctica usted actuará como si necesitara diseñar primers para amplificar un gen de interés bacteriano. Puede escoger uno de estos enfoques:

### Opción A — Diseño básico sobre una secuencia individual
**Esta debe ser la ruta principal para una primera práctica.**

Ejemplos de genes o regiones que puede buscar en NCBI:
- **16S rRNA**
- **rpoB**
- **gyrA**
- **recA**
- un gen de resistencia como **blaKPC** o **blaCTX-M**

### Opción B — Diseño sobre una región conservada
**Esta opción funciona como reto o ampliación** y conecta directamente con alineamientos múltiples y filogenética.

Aquí descargará varias secuencias homólogas (por ejemplo, del mismo gen en varias cepas o especies), las alineará y luego elegirá una región conservada para diseñar los primers.

> 💡 Recomendación docente: todos los estudiantes pueden completar primero la **Opción A** y luego, si el tiempo lo permite, avanzar a la **Opción B**.

---

## 🔬 Procedimiento

### Parte 1: Elegir la secuencia blanco

Antes de diseñar un primer, debe definir con claridad **qué quiere amplificar**.

Preguntas orientadoras:
- ¿Quiere detectar la presencia de un gen?
- ¿Quiere confirmar una anotación genómica?
- ¿Quiere amplificar una región conservada para identificación taxonómica?
- ¿Quiere amplificar una región variable para distinguir cepas?

> ⚠️ **Importante:** para esta práctica inicial, es mejor trabajar con la secuencia de un **gen** o una **región puntual**, no con un genoma completo. Si descarga un cromosoma entero, el análisis será menos manejable.

---

### Parte 2: Obtener la secuencia desde NCBI

Tiene dos formas sugeridas de hacerlo.

#### Opción 1 — Desde la web usando un GenBank ID

1. Vaya a [NCBI Nucleotide](https://www.ncbi.nlm.nih.gov/nucleotide/).
2. Busque un gen bacteriano de interés. Por ejemplo:
   - `Escherichia coli recA gene`
   - `Klebsiella pneumoniae blaKPC`
   - `bacterial 16S ribosomal RNA`
3. Abra un registro que corresponda a una **secuencia nucleotídica específica**.
4. Identifique el **accession** o **GenBank ID** del registro.
5. Use la opción **Send to → File → FASTA** para descargar la secuencia.

**Preguntas**
- ¿Qué organismo seleccionó?
- ¿Qué gen o región eligió?
- ¿Cuál es el accession del registro?
- ¿La secuencia descargada corresponde a un gen, un ARNr o un genoma completo?

#### Opción 2 — Descarga desde terminal con `wget`

Si ya tiene el accession, puede descargar la secuencia directamente desde la terminal.

Primero cree una carpeta de trabajo:

```bash
mkdir -p primer_design/data primer_design/results
cd primer_design
```

Luego defina el accession y descargue la secuencia en formato FASTA:

```bash
ACCESSION="PEGUE_AQUI_EL_ACCESSION"
wget -O data/target.fasta "https://www.ncbi.nlm.nih.gov/sviewer/viewer.fcgi?id=${ACCESSION}&db=nuccore&report=fasta&retmode=text"
```

Inspeccione el archivo descargado:

```bash
head data/target.fasta
```

Y estime la longitud de la secuencia:

```bash
grep -v "^>" data/target.fasta | tr -d '\n' | wc -c
```

> 💡 Si el archivo es enorme, probablemente descargó un genoma completo o un registro que no era el ideal para esta práctica.

---

### Parte 3: Inspección básica de la secuencia

Una vez descargada la secuencia, responda:

- ¿Cuál es la longitud aproximada de la secuencia?
- ¿Es una secuencia corta, moderada o muy larga para diseñar un amplicón?
- ¿Cree que conviene amplificar toda la secuencia o solo una región?

Si quiere inspeccionarla rápidamente desde terminal:

```bash
grep -v "^>" data/target.fasta | head -c 200
printf "\n"
```

Observe si la secuencia contiene solo `A`, `T`, `C` y `G`, o si aparecen letras ambiguas como `N`.

**Pregunta:** ¿Por qué una región con muchas `N` o ambigüedades no sería una buena candidata para diseñar primers?

---

### Parte 4: Mini-actividad — entender el *reverse complement*

El **primer forward** suele escribirse en la misma orientación 5'→3' de la región blanco. El **primer reverse**, en cambio, también se reporta en orientación 5'→3', pero corresponde al **complemento inverso** de la hebra opuesta.

Este punto confunde a muchos estudiantes al principio, así que haremos una mini-actividad.

#### Visualización conceptual: doble hebra, primers y dirección de síntesis

Para entenderlo mejor, no basta con mirar una sola secuencia lineal. Hay que recordar que el ADN es una **doble hebra antiparalela**: una va de **5' → 3'** y la otra de **3' → 5'**.

```text
Hebra sentido (superior)      5' - A T G C G G T T A C C A - 3'
Hebra antisentido (inferior)  3' - T A C G C C A A T G G T - 5'
```

##### 1. Primer forward

El **primer forward** se une a la **hebra antisentido** y su secuencia suele coincidir con el inicio de la hebra sentido.

```text
Hebra sentido                 5' - A T G C G G T T A C C A - 3'
Hebra antisentido             3' - T A C G C C A A T G G T - 5'
Primer forward                    5' - A T G C G G - 3'
```

La polimerasa extenderá desde el extremo **3'** del primer y sintetizará ADN nuevo en dirección **5' → 3'**, avanzando hacia la derecha sobre este esquema.

##### 2. Primer reverse

El **primer reverse** se une a la **hebra sentido**. Pero como todos los primers se escriben en dirección **5' → 3'**, no basta con tomar la secuencia complementaria: hay que obtener el **complemento inverso** de la región donde se unirá.

Si queremos que el primer reverse se una al extremo derecho de la hebra sentido, por ejemplo sobre la región:

```text
5' - ... T T A C C A - 3'
```

entonces:

- la secuencia **complementaria** sería: `A A T G G T`
- pero el primer debe escribirse en orientación **5' → 3'**
- por tanto, el **primer reverse** será el **reverse complement**:

```text
5' - T G G T A A - 3'
```

En el esquema completo:

```text
Hebra sentido                 5' - A T G C G G T T A C C A - 3'
Hebra antisentido             3' - T A C G C C A A T G G T - 5'
Primer reverse                                    5' - T G G T A A - 3'
```

La polimerasa extenderá también desde el extremo **3'** de este primer, pero ahora avanzando hacia la **izquierda** en el dibujo, es decir, hacia el interior de la región a amplificar.

#### Idea clave: los primers “se miran”

En una PCR, el primer forward y el reverse no apuntan hacia afuera, sino **hacia la región que se desea amplificar**. Ese fragmento intermedio es el **amplicón**.

```text
Molécula molde (representación esquemática)

Hebra superior      5' --------------------------------------------------------------- 3'
Hebra inferior      3' --------------------------------------------------------------- 5'

Forward primer             --->
Reverse primer                                                <---

Amplicón esperado:            [================ ~80–100 pb ================]
```

En este esquema, los primers están claramente **separados** sobre la molécula molde y cada uno marca uno de los límites del fragmento que se amplificará.

#### Aclaración importante: en la realidad las secuencias son mucho más largas

En este ejemplo usamos una secuencia corta porque es más fácil de visualizar. Pero en la práctica real:

- la secuencia molde puede tener **cientos, miles o millones de bases**;
- el **primer forward** y el **primer reverse** suelen estar **alejados uno del otro**;
- cada uno se une cerca de uno de los extremos de la región que se quiere amplificar;
- lo que se amplifica no es “todo el genoma”, sino solo el segmento comprendido **entre ambos primers**.

Por ejemplo, si diseña primers para obtener un producto de **250 pb**, eso significa que el forward y el reverse estarán separados aproximadamente por esa distancia sobre la molécula molde. Cada primer marca, en la práctica, uno de los límites del amplicón.

#### Analogía para recordarlo

Puede pensar en el ADN como una **calle de doble carril**, donde los carriles van en sentidos opuestos.

- El **primer forward** es como un carro que entra por un carril y avanza “hacia adelante” dentro de la región a copiar.
- El **primer reverse** quiere copiar desde el otro extremo, pero como la polimerasa siempre trabaja en dirección **5' → 3'**, ese primer debe colocarse orientado hacia el interior de la región. Por eso su secuencia no es simplemente “la del otro lado”, sino su **imagen invertida y complementaria**.

Si esta idea queda clara, entonces el concepto de **reverse complement** deja de parecer un truco matemático y empieza a verse como una consecuencia natural de cómo están organizadas las dos hebras del ADN.

#### Opción manual

Si la secuencia es:

```text
5' - ATGCCGAA - 3'
```

Entonces:
- Complementaria: `TACGGCTT`
- Reverse complement: `TTCGGCAT`

Ahora haga lo mismo con la siguiente secuencia corta:

```text
ATGACCTTAGC
```

Escriba:
1. su secuencia complementaria;
2. su secuencia reversa;
3. su **reverse complement**.

#### Opción con Python

Puede reutilizar lo aprendido en la práctica de Python y ejecutar esto en el intérprete:

```python
secuencia = "ATGACCTTAGC"
complemento = str.maketrans("ATCG", "TAGC")
reverse_complement = secuencia.translate(complemento)[::-1]
print(reverse_complement)
```

**Preguntas**
- ¿Por qué no basta con escribir la secuencia complementaria sin invertirla?
- ¿Qué pasaría si ordenara un primer reverso incorrectamente orientado?

---

### Parte 5: Ruta A — diseño básico sobre una sola secuencia

En esta ruta trabajará con **una sola secuencia blanco**. El objetivo es seleccionar una región adecuada y diseñar un par de primers que genere un amplicón razonable.

#### Paso 5A.1 — Elegir la región a amplificar

Ahora piense qué parte de la secuencia quiere amplificar.

Puede elegir una región interna que permita un amplicón de tamaño manejable, por ejemplo entre **150 y 400 pb**.

Preguntas orientadoras:
- ¿Quiere amplificar una región central del gen?
- ¿Quiere evitar extremos con muchas ambigüedades o baja calidad?
- ¿El tamaño del producto sería adecuado para PCR convencional?

#### Paso 5A.2 — Diseñar los primers con Primer-BLAST

Para esta práctica, se recomienda **NCBI Primer-BLAST**, porque combina diseño de primers con una verificación de especificidad contra bases de datos.

Abra la herramienta:
[https://www.ncbi.nlm.nih.gov/tools/primer-blast/](https://www.ncbi.nlm.nih.gov/tools/primer-blast/)

##### Paso a paso sugerido

1. Pegue la secuencia en el cuadro de entrada **o** use el accession si la herramienta lo reconoce.
2. Defina una región de interés si no desea amplificar toda la secuencia.
3. Ajuste parámetros básicos como:
   - **Product size**: por ejemplo `150-400 bp`
   - **Primer size**: preferido alrededor de `20 nt`
   - **Tm**: preferido alrededor de `60 °C`
   - **GC%**: dentro de rangos razonables
4. En la parte de especificidad, seleccione el organismo si desea restringir la búsqueda.
5. Ejecute el análisis.

##### Parámetros orientadores para esta práctica

| Parámetro | Valor sugerido |
|:--|:--|
| Product size | 150–400 bp |
| Primer length | 18–25 nt |
| Optimum Tm | ~60 °C |
| GC content | 40–60% |
| Número de pares a devolver | 5 o menos |

##### Qué debe revisar en los resultados

Para cada par de primers candidato, observe:
- secuencia del **forward primer**;
- secuencia del **reverse primer**;
- longitud de cada primer;
- **Tm**;
- **%GC**;
- tamaño esperado del amplicón;
- auto-complementariedad;
- posibles productos inespecíficos.

**Preguntas**
- ¿Cuál fue el mejor par sugerido por la herramienta y por qué?
- ¿Cuál es el tamaño esperado del amplicón?
- ¿La diferencia de Tm entre ambos primers es pequeña?
- ¿La herramienta predice productos inespecíficos adicionales?

### Parte 6: Ruta B — diseño sobre una región conservada

En esta ruta trabajará con **varias secuencias homólogas**. El objetivo ya no es solo diseñar un primer para una secuencia puntual, sino encontrar una región que sea suficientemente conservada para que los primers puedan funcionar en varias secuencias relacionadas.

#### Paso 6B.1 — Reunir varias secuencias del mismo gen

1. Descargue **3–5 secuencias** del mismo gen en organismos o cepas distintas.
2. Asegúrese de que correspondan realmente a la misma región biológica.
3. Guárdelas en formato FASTA.

#### Paso 6B.2 — Hacer un alineamiento simple

Alinéelas con una herramienta sencilla como:
- **MEGA**,
- **Clustal Omega** (web),
- o cualquier visualizador de alineamiento disponible en el curso.

#### Paso 6B.3 — Identificar la región conservada

Busque una región que:
- sea suficientemente conservada para que el primer se una bien en todas o casi todas las secuencias;
- no tenga demasiadas ambigüedades;
- permita generar un amplicón de tamaño razonable;
- idealmente flanquee una región informativa, si su objetivo es comparación o identificación.

> 💡 En diseño de primers, el extremo **3'** merece atención especial. Un desajuste en esa zona suele ser más problemático que uno más interno.

#### Paso 6B.4 — Diseñar los primers a partir de la región conservada

Una vez identificada la zona conservada:

1. Seleccione la región donde quiere ubicar el primer forward y el reverse.
2. Lleve esa región a **Primer-BLAST** o **Primer3**.
3. Ajuste los mismos criterios básicos de longitud, Tm, %GC y tamaño del producto.
4. Compare si el diseño parece compatible con varias secuencias del alineamiento.

**Preguntas**
- ¿Qué parte del alineamiento eligió para diseñar los primers?
- ¿La región escogida es completamente conservada o tiene algunas posiciones variables?
- ¿Serían estos primers potencialmente más “universales” que los de la opción A?

### Parte 7: Validación *in silico* del amplicón

Tanto en la **Opción A** como en la **Opción B**, el siguiente paso es comprobar si el diseño parece producir el amplicón esperado.

#### ¿Qué debe validar?

1. **Tamaño esperado del amplicón**
   - Revise cuántos pares de bases separan el primer forward y el reverse.
   - Confirme que el producto tenga el tamaño esperado según la herramienta.

2. **Unicidad del producto**
   - Idealmente, el par de primers debe producir **un único amplicón principal**.
   - Si aparecen varios productos posibles, el diseño puede no ser suficientemente específico.

3. **Coherencia biológica**
   - Verifique que el amplicón realmente cae dentro del gen o región que desea estudiar.

#### Interpretación básica

- Si el producto esperado mide, por ejemplo, **220 pb**, entonces ese debería ser el tamaño de banda principal si la PCR funciona correctamente.
- Si la herramienta predice también productos de **500 pb** o **900 pb**, eso puede sugerir amplificación inespecífica.

**Preguntas**
- ¿Cuál es el tamaño esperado del amplicón principal?
- ¿Se predicen otros productos adicionales?
- Si hubiera dos productos posibles, ¿cómo afectaría eso la interpretación del experimento?

### Parte 8: Electroforesis *in silico*

La electroforesis *in silico* no reemplaza una PCR real, pero ayuda a anticipar **cómo se verían los productos** en un gel.

#### ¿Qué se busca en esta etapa?

A partir del tamaño esperado del amplicón, imagine o represente cómo se visualizaría el producto en una corrida de gel:

- un amplicón de **150 pb** migrará más abajo que uno de **400 pb**;
- si existe **un único producto**, esperaría una sola banda bien definida;
- si hay **productos inespecíficos**, podrían aparecer varias bandas.

#### Actividad sugerida

Con base en los tamaños predichos por Primer-BLAST:

1. Dibuje un esquema simple de gel con:
   - un carril de marcador de peso molecular;
   - un carril para su muestra.
2. Ubique la banda esperada según el tamaño del amplicón.
3. Si hubo productos alternativos predichos, agregue esas bandas al esquema.

#### Extensión opcional

Si dispone de una herramienta externa que permita simular PCR o visualizar productos de distinta longitud, úsela como apoyo. Si no, el esquema manual del gel sigue siendo completamente válido para este nivel del curso.

**Preguntas**
- ¿Dónde esperaría ver la banda principal en el gel?
- ¿Cómo distinguiría un producto específico de uno inespecífico?
- ¿Qué patrón de bandas le haría sospechar que el diseño de primers no fue adecuado?

### Parte 9: Puente hacia el módulo 4

Imagine que en el módulo de genómica usted ensambló un genoma bacteriano y el software de anotación predijo un gen de resistencia. Un uso muy natural de esta práctica sería diseñar primers para:

- verificar experimentalmente que el gen está presente;
- confirmar su orientación y región aproximada;
- comprobar si una cepa clínica realmente porta ese marcador.

Es decir, el diseño de primers traduce una predicción bioinformática en una estrategia experimental concreta.

### Parte 10: Entregable sugerido

Prepare una tabla corta con la siguiente información:

| Elemento | Respuesta |
|:--|:--|
| Ruta elegida (A o B) | |
| Organismo | |
| Gen o región blanco | |
| Accession / GenBank ID | |
| Longitud de la secuencia descargada | |
| Primer forward (5'→3') | |
| Primer reverse (5'→3') | |
| Tm forward | |
| Tm reverse | |
| %GC forward | |
| %GC reverse | |
| Tamaño esperado del amplicón | |
| ¿Hubo productos inespecíficos? | |
| Interpretación de la electroforesis *in silico* | |
| Observaciones finales | |

---

## ToDo: Actividades para resolver

### Actividad 1 — Descarga y documentación

Seleccione una secuencia de interés bacteriana en NCBI y documente:
- organismo;
- gen o región;
- accession;
- longitud del archivo descargado.

Si usa terminal, incluya el comando `wget` que empleó.

### Actividad 2 — Reverse complement

Calcule manualmente o con Python el **reverse complement** de una secuencia corta propuesta por el docente.

### Actividad 3 — Opción A: diseño básico de primers

Diseñe al menos **un par de primers** para una secuencia seleccionada usando Primer-BLAST.

### Actividad 4 — Opción A: validación del amplicón

Registre el **tamaño esperado del amplicón** y explique si se predicen productos inespecíficos.

### Actividad 5 — Opción B: alineamiento y región conservada (opcional)

Descargue 3 secuencias homólogas del mismo gen, alinéelas e identifique una región conservada. Diseñe primers sobre esa zona y discuta si serían una mejor opción para un diseño “más universal”.

### Actividad 6 — Electroforesis *in silico*

Represente cómo esperaría ver el producto de PCR en un gel, usando el tamaño del amplicón principal y, si existen, productos alternativos.

---

## 📝 Preguntas de reflexión (Post-práctica)

1. **Especificidad vs. sensibilidad:** ¿Por qué un primer muy corto puede amplificar más fácilmente, pero también unirse a sitios no deseados?
2. **El extremo 3':** ¿Por qué los desajustes en el extremo 3' suelen ser más problemáticos que en otras posiciones del primer?
3. **Alineamiento y diseño:** ¿Cómo ayuda un alineamiento a distinguir regiones conservadas de regiones variables durante el diseño?
4. **Relación con genómica:** Si en un ensamblaje *de novo* encuentra un gen interesante, ¿cómo usaría primers para validar ese hallazgo?
5. **Relación con filogenética:** ¿Por qué para diseñar primers “universales” resulta útil alinear secuencias de varias especies antes de escoger la región blanco?
6. **Bioinformática aplicada:** ¿Qué parte de esta práctica dependió más claramente de herramientas computacionales y no podría resolverse de manera confiable solo “a ojo”?

---

## Cierre conceptual

El diseño de primers es una excelente demostración de cómo los conceptos de bioinformática se conectan con el laboratorio. Aquí convergen la búsqueda en bases de datos, el análisis de secuencias, el alineamiento, la especificidad y la interpretación biológica. Un primer bien diseñado no es solo una secuencia corta: es una hipótesis experimental construida a partir de evidencia computacional.

Esta misma lógica reaparecerá más adelante cuando trabaje con ensamblaje de genomas, anotación y validación de genes en el **Módulo 4**, y también cuando piense en regiones conservadas para identificación o comparación evolutiva en módulos posteriores.
