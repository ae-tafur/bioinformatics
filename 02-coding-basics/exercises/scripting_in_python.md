# 🐍 Práctica: Introducción a la programación en Python para bioinformáticos

## Introducción

Hasta ahora ha aprendido a navegar el sistema de archivos y a manipular archivos biológicos desde la terminal Unix. En esta práctica dará el siguiente gran paso: programar en **Python**, el lenguaje más utilizado en bioinformática hoy en día.

Python le permitirá ir más allá de lo que los comandos de terminal pueden hacer: tomar decisiones basadas en los datos, repetir operaciones sobre miles de secuencias, calcular estadísticas y construir herramientas reutilizables. En esta práctica comenzará desde los fundamentos —variables, tipos de datos, operadores y estructuras de control— y progresará hasta escribir scripts completos que analizan los mismos archivos biológicos que ya conoce de la práctica anterior.

Esta práctica corresponde a la **Parte 2 del Módulo 2**. Todos los conceptos teóricos que aquí se aplican (variables, tipos de datos, operadores, condicionales, bucles y funciones) están explicados en detalle en las secciones 2.2 a 2.4 del README del módulo. Si tiene dudas conceptuales durante la práctica, consulte esa referencia antes de continuar.

---

## 🎯 Objetivos

- Declarar variables respetando las reglas de nomenclatura y tipos de datos de Python.
- Aplicar operadores aritméticos, de comparación y lógicos sobre datos biológicos.
- Usar estructuras condicionales (`if/elif/else`) y bucles (`for`, `while`) para procesar secuencias y tablas.
- Leer archivos biológicos (FASTA, CSV, TSV) desde un script Python.
- Escribir scripts completos que resuelvan problemas reales de análisis biológico.

---

## 📦 Requisitos previos

- Haber completado las **Prácticas 1 y 2** (GitHub Codespaces y terminal Unix).
- Haber leído la **Parte 2** del README del Módulo 2 (secciones 2.2 a 2.4).
- Codespace activo con el repositorio del curso abierto.

> 💡 **¿Ya tiene un Codespace activo?** Reutilícelo. Vaya a [github.com/codespaces](https://github.com/codespaces), seleccione el que ya creó y retómelo donde lo dejó. No cree uno nuevo cada vez.

---

## 🗂️ Archivos de datos disponibles

Todos los archivos se encuentran en la carpeta `data/`. Los usará progresivamente a lo largo de la práctica:

| Archivo | Formato | Descripción |
|---|---|---|
| `01_sequences.fasta` | FASTA | 10 secuencias de ADN |
| `02_results_pcr_96.csv` | CSV | Resultados de PCR en placa de 96 pocillos |
| `03_nucleotides.fa` | FASTA | Secuencia única de ADN |
| `05_genome.gff3.txt` | GFF3 | Anotación de genes en dos cromosomas |
| `06_bacterial_growth.tsv` | TSV | Absorbancias OD600 de tres cepas bacterianas |
| `07_mutations.fasta` | FASTA | Secuencia de referencia y dos mutantes |
| `08_antibiogram.csv` | CSV | Resultados de antibiograma (R/S/I) |
| `09_short_sequences.fasta` | FASTA | Secuencias de distinta longitud |
| `10_temperature.csv` | CSV | Temperaturas de incubación en tres experimentos |
| `11_pcr_ct.csv` | CSV | Valores Ct de PCR cuantitativa |
| `12_gene_annotations.tsv` | TSV | Anotación funcional de genes (KO IDs) |
| `13_glucose_comsumption.tsv` | TSV | Consumo de glucosa de 10 cultivos en 3 réplicas |
| `14_bacterias_muestreo.csv` | CSV | Identificación de bacterias en muestreo ambiental |
| `15_aa_sequences.fa` | FASTA | Secuencias de proteínas (aminoácidos) |

---

## 🔬 Procedimiento

### Parte 1: Primeros pasos — variables, tipos de datos y errores comunes

En esta parte **usted mismo creará variables** desde cero, aplicando las reglas que aprendió en la teoría. El objetivo no es solo que funcione: es que entienda **por qué falla** cuando algo sale mal.

#### Paso 1: Abrir el intérprete interactivo de Python

En la terminal de Codespaces, escriba:

```bash
python3
```

Verá el prompt `>>>`, lo que indica que Python está listo para recibir instrucciones línea por línea. Para salir cuando termine, escriba `exit()`.

---

#### Paso 2: Crear sus primeras variables — piense antes de escribir

> 📝 **Antes de abrir Codespaces, tome una hoja de papel.**
> Para cada variable a continuación se le presenta un enunciado y luego **dos o tres formas de declararla**. En su hoja:
> 1. Indique cuál(es) cree que son **correctas** y cuál(es) cree que **fallarán**.
> 2. Para las que cree que fallan, escriba **por qué** cree que fallarán.
> 3. Solo después de haber anotado sus respuestas, pruébelas en el intérprete de Python y compare.
>
> No hay respuestas incorrectas en el papel — el objetivo es que usted razone primero y luego contraste con lo que Python le dice.

---

**Variable 1 — Nombre del investigador**

Un investigador se llama *Ana García*. Necesita guardar su nombre en una variable llamada `nombre`.

Evalúe cada opción **en papel** antes de probarla:

```python
# Opción A
nombre = Ana García

# Opción B
nombre = "Ana García"

# Opción C
nombre = 'Ana García'

# Opción D
Ana García = "investigadora"
```

Pruébelas una por una en el intérprete. Luego responda:
- ¿Cuáles funcionaron? ¿Cuáles fallaron?
- ¿Coincidió con lo que predijo en papel?
- ¿Qué tienen en común las que sí funcionaron?
- ¿Qué tipo de dato es `nombre`? Verifíquelo con `print(type(nombre))`.

<details>
<summary>💡 Ver explicación (ábrala solo después de haber intentado)</summary>

- **Opción A** falla: `SyntaxError`. Sin comillas, Python interpreta `Ana` y `García` como dos variables separadas, no como un valor de texto.
- **Opción B** ✅ funciona: el texto entre comillas dobles es un `str`.
- **Opción C** ✅ funciona: Python acepta comillas simples o dobles indistintamente para texto.
- **Opción D** falla: `SyntaxError`. Los nombres de variables no pueden contener espacios. `Ana García` con espacio es inválido como nombre de variable.

</details>

---

**Variable 2 — Edad**

Un estudiante tiene 28 años. Necesita guardar su edad y luego sumarle 1 para calcular cuántos años tendrá el próximo año.

Evalúe cada opción **en papel** antes de probarla:

```python
# Opción A
edad = 28
print(edad + 1)

# Opción B
edad = "28"
print(edad + 1)

# Opción C
edad = "28"
print(edad + "1")

# Opción D
edad = 28
edad_texto = "1"
print(edad + edad_texto)
```

Pruébelas una por una. Luego responda:
- ¿Cuáles funcionaron como esperaba?
- ¿Cuáles dieron un error? ¿Cuáles dieron un resultado *sorpresivo* sin error?
- ¿Qué diferencia hay entre sumar dos números y "sumar" dos textos en Python?

<details>
<summary>💡 Ver explicación (ábrala solo después de haber intentado)</summary>

- **Opción A** ✅ funciona: `28 + 1 = 29`. Suma numérica normal.
- **Opción B** falla: `TypeError`. `"28"` es un `str`, no un `int`. Python no puede sumar texto con número aunque el texto parezca un número.
- **Opción C** ✅ no falla, pero el resultado es `"281"`, no `29`. Cuando se "suman" dos `str`, Python los **concatena** (los pega uno tras otro). No hace suma aritmética.
- **Opción D** falla: `TypeError`. Mismo motivo que B: no se puede mezclar `int` y `str` con `+`.

**La solución** cuando necesita operar con un número que viene como texto (muy común al leer archivos CSV):
```python
edad = "28"
print(int(edad) + 1)    # → 29  (convierte el str a int primero)
```
Esto se llama **casting** y es fundamental en bioinformática, porque cuando Python lee un archivo, todos los valores llegan como `str` por defecto.

</details>

---

**Variable 3 — Dirección del laboratorio**

Necesita guardar la dirección *"Calle 50 # 10-25, Laboratorio 302"* en una variable.

Evalúe cada opción **en papel** antes de probarla:

```python
# Opción A
mi dirección = "Calle 50 # 10-25, Laboratorio 302"

# Opción B
2direccion = "Calle 50 # 10-25, Laboratorio 302"

# Opción C
mi_direccion = "Calle 50 # 10-25, Laboratorio 302"

# Opción D
MiDireccion = "Calle 50 # 10-25, Laboratorio 302"

# Opción E
mi_direccion = Calle 50 # 10-25, Laboratorio 302
```

Pruébelas una por una. Luego responda:
- ¿Cuáles funcionaron?
- Las que fallaron, ¿qué regla de nomenclatura de variables violan?
- Las opciones C y D funcionan las dos, pero ¿cuál es más legible? ¿Cuál se usa más por convención en Python?

<details>
<summary>💡 Ver explicación (ábrala solo después de haber intentado)</summary>

- **Opción A** falla: `SyntaxError`. El espacio en `mi dirección` no está permitido en nombres de variables.
- **Opción B** falla: `SyntaxError`. Los nombres de variables no pueden comenzar con un número.
- **Opción C** ✅ funciona. Usa `snake_case` (palabras unidas con guión bajo): el estilo convencional en Python.
- **Opción D** ✅ funciona. Usa `CamelCase` (palabras con mayúscula inicial). Es válido, pero en Python se reserva por convención para nombres de clases, no variables.
- **Opción E** falla: `SyntaxError`. El valor no está entre comillas, por lo que Python intenta interpretar `Calle` como una variable inexistente.

**Reglas de nomenclatura de variables en Python:**
- Solo letras, números y guión bajo `_`.
- No puede empezar con un número.
- No puede contener espacios.
- Es sensible a mayúsculas: `Mi_Direccion` ≠ `mi_direccion`.
- Convención en Python: usar `snake_case` para variables y funciones.

</details>

---

**Variable 4 — Datos del experimento con tipos mixtos:**

Ahora declare un conjunto de variables que representan una muestra de laboratorio y opere sobre ellas:

```python
cepa           = "Escherichia coli"
num_colonias   = 156
concentracion  = 0.45        # µg/µL
es_patogena    = True
nucleotidos    = ["A", "T", "G", "C"]
conteo_bases   = {"A": 45, "T": 42, "G": 38, "C": 40}

# Verifique el tipo de cada variable
print(type(cepa))
print(type(num_colonias))
print(type(concentracion))
print(type(es_patogena))
print(type(nucleotidos))
print(type(conteo_bases))
```

Opere sobre ellas:
```python
# Acceder a elementos de una lista por índice (empieza en 0)
print(nucleotidos[0])    # → "A"
print(nucleotidos[-1])   # → "C" (último elemento)

# Acceder a valores de un diccionario por clave
print(conteo_bases["G"])         # → 38
print(conteo_bases["A"] + conteo_bases["T"])   # → 87

# Calcular el total de bases
total = sum(conteo_bases.values())
print(f"Total de bases: {total}")

# Calcular %GC directamente desde el diccionario
gc = conteo_bases["G"] + conteo_bases["C"]
gc_porcentaje = (gc / total) * 100
print(f"Contenido GC: {gc_porcentaje:.2f}%")
```

> ⚠️ **Error frecuente con diccionarios:** intentar acceder a una clave que no existe:
> ```python
> print(conteo_bases["N"])   # KeyError: 'N'
> ```
> Use `.get()` para evitar el error: `conteo_bases.get("N", 0)` devuelve `0` si la clave no existe.

---

#### Paso 3: Salir del intérprete y crear un script

El intérprete interactivo es útil para probar cosas rápidas, pero para trabajo real se usan **scripts** (archivos `.py`). Salga del intérprete:

```python
exit()
```

Cree su primer script Python:
```bash
touch mi_primer_script.py
```

Ábralo en el editor (panel izquierdo de Codespaces) y escriba:

```python
#!/usr/bin/env python3
"""
Mi primer script de Python para bioinformática.
"""

# Variables del experimento
cepa          = "Escherichia coli K-12"
num_colonias  = 156
gc_content    = 0.508
es_patogena   = False

# Imprimir un reporte básico
print("=== Reporte de muestra ===")
print(f"Cepa: {cepa}")
print(f"Colonias contadas: {num_colonias}")
print(f"Contenido GC: {gc_content * 100:.1f}%")
print(f"¿Es patógena?: {es_patogena}")

# Condicional basado en GC
if gc_content > 0.60:
    print("Alto contenido GC")
elif gc_content >= 0.40:
    print("Contenido GC moderado")
else:
    print("Bajo contenido GC")
```

Ejecute el script desde la terminal:
```bash
python3 mi_primer_script.py
```

---

### Parte 2: Operadores, condicionales y bucles con datos biológicos

#### Paso 4: Operadores sobre secuencias

Abra el intérprete Python nuevamente (`python3`) y trabaje con la secuencia del archivo `03_nucleotides.fa`:

```python
secuencia = "TACTTGATTTTATTACTACAGGATCCAAACTGGCTAGTATCGGATTCAAGGACAGGCTAATATGTAGACTATCCTCCAGATAACGAATCAGGCAAATGCCTCCTAGGGGTATTGCAGATATTTAAGCGTCAGTGGTAAAATCTGTTCGTCAGTGCGCTCCGTGGGATCGTGACGACGGCTCAATCTACATTCAGTCCAAC"

# Longitud
longitud = len(secuencia)
print(f"Longitud: {longitud} bases")

# Conteo de nucleótidos
A = secuencia.count("A")
T = secuencia.count("T")
G = secuencia.count("G")
C = secuencia.count("C")
print(f"A={A}, T={T}, G={G}, C={C}")

# Verificar que suman la longitud total
print(f"Suma: {A+T+G+C} == {longitud}: {A+T+G+C == longitud}")

# %GC
gc_porcentaje = (G + C) / longitud * 100
print(f"%GC: {gc_porcentaje:.2f}%")

# Número de codones posibles (sin considerar marcos de lectura)
num_codones = longitud // 3
residuo = longitud % 3
print(f"Codones: {num_codones}, bases sobrantes: {residuo}")
```

#### Paso 5: Condicionales con datos de antibiograma

```python
# Datos del antibiograma (08_antibiogram.csv)
resultados = [
    ("E.coli",       "Ampicilina",      "R"),
    ("E.coli",       "Ciprofloxacina",  "S"),
    ("S.aureus",     "Ampicilina",      "R"),
    ("S.aureus",     "Eritromicina",    "I"),
    ("K.pneumoniae", "Ampicilina",      "S"),
]

print("=== Interpretación de antibiograma ===")
for cepa, antibiotico, resultado in resultados:
    if resultado == "R":
        interpretacion = "⛔ Resistente — no usar este antibiótico"
    elif resultado == "I":
        interpretacion = "⚠️  Intermedio — usar con precaución"
    else:
        interpretacion = "✅ Sensible — tratamiento viable"

    print(f"{cepa} | {antibiotico}: {interpretacion}")
```

#### Paso 6: Bucles sobre secuencias FASTA

```python
# Simular el contenido de 07_mutations.fasta
secuencias = {
    "Ref":  "ATGCGTACGTTAGC",
    "Mut1": "ATGCGTACGCTAGC",
    "Mut2": "ATGCGTACGCTTGC",
}

referencia = secuencias["Ref"]

print("=== Detección de mutaciones ===")
for nombre, seq in secuencias.items():
    if nombre == "Ref":
        continue   # saltar la referencia

    mutaciones = 0
    posiciones = []
    for i in range(len(referencia)):
        if referencia[i] != seq[i]:
            mutaciones += 1
            posiciones.append(i + 1)   # posición en base 1

    print(f"{nombre}: {mutaciones} mutación(es) en posición(es) {posiciones}")
```

---

### Parte 3: Lectura de archivos y scripts completos

A partir de aquí trabajará con los archivos reales de la carpeta `data/`. Cree un nuevo script para cada ejercicio.

#### Paso 7: Leer un archivo FASTA

Cree el archivo `leer_fasta.py`:

```python
#!/usr/bin/env python3
"""
Lee un archivo FASTA y muestra información básica de cada secuencia.
"""

archivo = "data/01_sequences.fasta"
secuencias = {}
id_actual = None

with open(archivo, "r") as f:
    for linea in f:
        linea = linea.strip()
        if linea.startswith(">"):
            id_actual = linea[1:]       # quita el ">"
            secuencias[id_actual] = ""
        elif id_actual:
            secuencias[id_actual] += linea

# Reportar
print(f"Total de secuencias: {len(secuencias)}")
print("-" * 40)
for nombre, seq in secuencias.items():
    gc = (seq.count("G") + seq.count("C")) / len(seq) * 100
    print(f"{nombre}: {len(seq)} bp | %GC: {gc:.1f}%")
```

Ejecute:
```bash
python3 leer_fasta.py
```

#### Paso 8: Leer un archivo CSV

Cree el archivo `leer_csv.py`:

```python
#!/usr/bin/env python3
"""
Lee el archivo de antibiograma y clasifica los resultados.
"""

archivo = "data/08_antibiogram.csv"
conteo = {"R": 0, "I": 0, "S": 0}

with open(archivo, "r") as f:
    encabezado = f.readline()   # saltar la primera línea
    for linea in f:
        linea = linea.strip()
        if linea:
            partes = linea.split(",")
            resultado = partes[2]
            if resultado in conteo:
                conteo[resultado] += 1

print("=== Resumen del antibiograma ===")
print(f"Resistentes (R):   {conteo['R']}")
print(f"Intermedios (I):   {conteo['I']}")
print(f"Sensibles (S):     {conteo['S']}")
```

Ejecute:
```bash
python3 leer_csv.py
```

#### Paso 9: Leer un archivo TSV

Cree el archivo `crecimiento_bacteriano.py`:

```python
#!/usr/bin/env python3
"""
Calcula el promedio de OD600 de cada cepa bacteriana.
"""

archivo = "data/06_bacterial_growth.tsv"

with open(archivo, "r") as f:
    encabezado = f.readline()
    for linea in f:
        linea = linea.strip()
        if linea:
            partes = linea.split(",")
            cepa = partes[0]
            replicas = [float(partes[1]), float(partes[2]), float(partes[3])]
            promedio = sum(replicas) / len(replicas)
            print(f"{cepa}: OD600 promedio = {promedio:.3f}")
```

Ejecute:
```bash
python3 crecimiento_bacteriano.py
```

---

### ToDo: Ejercicios — aplique lo aprendido con los archivos de datos

Estos ejercicios deben resolverse escribiendo un script Python independiente (`.py`) para cada uno. Use los archivos de la carpeta `data/` como entrada. Guarde todos sus scripts en una carpeta `scripts/` que creará dentro del directorio de ejercicios.

```bash
mkdir -p scripts/
```

---

**Ejercicio 1 — Conteo de secuencias en archivo FASTA**
Archivo: `data/01_sequences.fasta`
Escriba un script que abra el archivo y cuente cuántas secuencias contiene.
> 💡 Recuerde: cada secuencia empieza con `>`. Cuente esas líneas.

---

**Ejercicio 2 — Conteo de resultados en una placa de PCR 96**
Archivo: `data/02_results_pcr_96.csv`
Lea el archivo y cuente cuántos pocillos amplificaron y cuántos no.

---

**Ejercicio 3 — Conteo de nucleótidos**
Archivo: `data/03_nucleotides.fa`
Lea la secuencia y cuente el número de A, T, C y G. Imprima cada conteo.

---

**Ejercicio 4 — Porcentaje de GC**
Archivo: `data/03_nucleotides.fa`
Usando la misma secuencia del ejercicio anterior, calcule e imprima el **%GC**.

---

**Ejercicio 5 — Contar genes en un archivo GFF**
Archivo: `data/05_genome.gff3.txt`
Lea el archivo línea por línea y cuente cuántas líneas contienen la palabra `gene` en la tercera columna (tipo de elemento).
> 💡 Use `.split()` para dividir la línea en columnas y verifique `columnas[2] == "gene"`.

---

**Ejercicio 6 — Cálculo de crecimiento bacteriano**
Archivo: `data/06_bacterial_growth.tsv`
Para cada cepa, calcule el **promedio de OD600** de sus tres réplicas e imprímalo.

---

**Ejercicio 7 — Detección de mutaciones**
Archivo: `data/07_mutations.fasta`
Lea las tres secuencias del archivo. Usando la secuencia `Ref` como referencia, compare cada mutante base por base y cuente cuántas posiciones son diferentes.

---

**Ejercicio 8 — Clasificar resultados de antibiograma**
Archivo: `data/08_antibiogram.csv`
Lea el archivo y cuente cuántas cepas son **Resistentes (R)**, **Intermedias (I)** y **Sensibles (S)**.

---

**Ejercicio 9 — Identificar secuencias cortas**
Archivo: `data/09_short_sequences.fasta`
Lea el archivo FASTA y cuente cuántas secuencias tienen **menos de 15 nucleótidos**.

---

**Ejercicio 10 — Promedio de temperatura de incubación**
Archivo: `data/10_temperature.csv`
Para cada experimento, calcule el **promedio de las tres temperaturas** medidas e imprímalo.

---

**Ejercicio 11 — Clasificar muestras por valor Ct de PCR**
Archivo: `data/11_pcr_ct.csv`
Lea el archivo. Si `Ct < 30` → **positivo**; si `Ct ≥ 30` → **negativo**. Cuente e imprima el total de positivos y negativos.

---

**Ejercicio 12 — Número de genes anotados**
Archivo: `data/12_gene_annotations.tsv`
Lea el archivo y cuente cuántos genes tienen una anotación funcional real (es decir, cuyo `KO_ID` **no sea** `NA`).

---

**Ejercicio 13 — Promedio de consumo de glucosa**
Archivo: `data/13_glucose_comsumption.tsv`
Para cada cultivo, calcule el **promedio de consumo** de sus tres réplicas. Al final, calcule e imprima el **promedio general** de todos los cultivos.

---

**Ejercicio 14 — Conteo de especies en muestreo bacteriano**
Archivo: `data/14_bacterias_muestreo.csv`
Lea el archivo e imprima cuántas veces aparece cada especie. Al final, indique cuántas **especies distintas** fueron encontradas.
> 💡 Use un diccionario donde la clave sea la especie y el valor sea el conteo.

---

**Ejercicio 15 — Filtrar secuencias de proteínas por longitud**
Archivo: `data/15_aa_sequences.fa`
Lea el archivo FASTA de secuencias de aminoácidos y cuente cuántas secuencias tienen **más de 500 aminoácidos**.

---

### 📝 Preguntas de Reflexión (Post-Práctica)

**Sobre variables y tipos de datos**

1. **El error de tipos:** En el Paso 2 intentó sumar un `int` con un `str` y obtuvo un `TypeError`. En bioinformática, cuando se lee un archivo CSV con Python, **todos los valores llegan como `str`** por defecto. ¿Qué implicación tiene esto para los ejercicios 6, 10 y 13, donde necesita calcular promedios? ¿Qué función usaría para convertir esos valores antes de operar sobre ellos?

2. **Nombres de variables:** ¿Por qué cree que es importante elegir nombres descriptivos como `gc_porcentaje` en lugar de `x` o `resultado`? Imagine que un colega debe leer su script 6 meses después sin ninguna documentación. ¿Qué pasaría si todas las variables se llamaran `a`, `b`, `c`?

**Sobre estructuras de control**

3. **El `continue` en el Paso 6:** En el bucle de detección de mutaciones usó `continue` para saltar la secuencia de referencia. ¿Qué hubiera pasado si no lo hubiera incluido? ¿Habría generado un error o simplemente un resultado incorrecto?

4. **Diccionarios para contar:** En el Ejercicio 14 se le sugiere usar un diccionario para contar especies. ¿Por qué un diccionario es más apropiado que una lista para esta tarea? ¿Cómo accedería al conteo de *Escherichia coli* específicamente una vez construido el diccionario?

**Sobre lectura de archivos**

5. **La línea del encabezado:** En los scripts de los pasos 8 y 9 usó `f.readline()` para saltar la primera línea del archivo. ¿Qué pasaría si no la saltara? ¿Generaría un error inmediato o un resultado silenciosamente incorrecto? ¿Cuál es más peligroso en un análisis científico?

6. **Reproducibilidad vs. resultado:** Tiene dos opciones para reportar el %GC de una muestra: (a) calcular el valor manualmente con una calculadora y escribirlo en un email a su tutor, o (b) escribir un script Python que lo calcule leyendo el archivo directamente. Si mañana el archivo de secuencias se actualiza con una corrección, ¿cuál de las dos opciones le permite obtener el resultado actualizado de forma inmediata y sin riesgo de error?

