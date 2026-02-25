# Módulo 2: Conceptos Básicos de Scripting y Línea de Comandos

## Introducción

Si el módulo anterior le presentó el *qué* y el *por qué* de la bioinformática, este módulo le enseñará el *cómo*. La capacidad de trabajar con la línea de comandos y escribir scripts es la habilidad más transversal en toda la bioinformática: sin ella, es imposible procesar miles de secuencias, automatizar análisis repetitivos o ejecutar las herramientas que la comunidad científica ha desarrollado durante décadas.

En este módulo aprenderá a moverse con soltura en un entorno **Linux/Unix**, que es el sistema operativo predominante en servidores de cómputo, clústeres de alto rendimiento y entornos en la nube como GitHub Codespaces. Aprenderá los comandos esenciales para navegar por el sistema de archivos, manipular archivos biológicos directamente desde la terminal, gestionar permisos y ejecutar scripts de automatización.

Posteriormente, dará sus primeros pasos en la programación con **Bash** y **Python**, los dos lenguajes más utilizados en bioinformática. Bash para orquestar herramientas y automatizar flujos de trabajo, y Python para manipular datos, procesar secuencias y construir análisis más complejos con código limpio y reutilizable.

Al finalizar este módulo, usted será capaz de moverse con autonomía en una terminal Unix, escribir scripts básicos y aplicar estos conocimientos directamente al análisis de archivos biológicos como secuencias FASTA y datos genéticos.

> 🧪 Las prácticas de laboratorio de este módulo se realizarán usando **GitHub Codespaces**, el entorno de desarrollo en la nube configurado en la Práctica 1 (creating_an_github_account). Asegúrese de tener su cuenta de GitHub activa antes de comenzar.

---

## Parte 1: Introducción al Sistema Operativo Linux

### 1.1 Unix, Linux y macOS: el origen común

Para entender por qué Linux domina en bioinformática, es necesario conocer su historia. Todo comienza con **Unix**, un sistema operativo desarrollado en los laboratorios Bell de AT&T en la década de 1970. Unix sentó las bases de lo que hoy conocemos como la filosofía de la línea de comandos: herramientas pequeñas, especializadas, que se pueden encadenar entre sí para construir análisis complejos.

De Unix derivan directamente dos sistemas operativos que probablemente ya conoce:

- **Linux:** Un sistema operativo de código abierto inspirado en Unix, creado por Linus Torvalds en 1991. No es Unix propiamente dicho, pero sigue su misma filosofía y comparte la gran mayoría de sus comandos y comportamientos.
- **macOS:** El sistema operativo de Apple está construido sobre **Darwin**, un núcleo de código abierto derivado directamente de BSD Unix. Por esta razón, la terminal de macOS (`zsh`/`bash`) funciona prácticamente igual que la de Linux y la mayoría de comandos son idénticos.

```
        Unix (AT&T Bell Labs, 1970s)
               /           \
         BSD Unix          System V
            |
          Darwin (Apple)          Linux (Torvalds, 1991)
            |                            |
          macOS / iOS             Ubuntu, CentOS, Debian...
```

> 💡 Esto significa que si aprende a usar la terminal en Linux (usando GitHub Codespaces, por ejemplo), podrá aplicar exactamente los mismos conocimientos en macOS y en cualquier servidor Unix del mundo.

**¿Y Windows?**

Windows tiene un origen completamente distinto y no pertenece a la familia Unix. Sin embargo, esto **no significa que no pueda usarse en bioinformática**. Microsoft ofrece el **WSL (Windows Subsystem for Linux)**, que permite correr un entorno Linux completo dentro de Windows, accesible desde la terminal. La mayoría de herramientas bioinformáticas corren perfectamente dentro de WSL. En este curso usamos GitHub Codespaces precisamente para eliminar esa diferencia: todos los estudiantes, independientemente de su sistema operativo, trabajan en el mismo entorno Linux en la nube.

### 1.2 ¿Por qué Linux/Unix en Bioinformática?

La gran mayoría de las herramientas bioinformáticas —ensambladores de genomas, alineadores de secuencias, callers de variantes— fueron diseñadas para correr en sistemas **Unix/Linux**. Los servidores de cómputo de alto rendimiento (HPC) de universidades y centros de investigación casi universalmente corren Linux. Por tanto, dominar este entorno no es opcional: es una competencia fundamental.

Las razones principales por las que Linux/Unix domina en bioinformática son:

- **Software libre y de código abierto:** La mayoría de herramientas (BLAST, SAMtools, BWA, SPAdes) son gratuitas y se instalan nativamente en Linux/macOS.
- **Terminal poderosa:** La línea de comandos permite automatizar tareas que serían imposibles o muy lentas con una interfaz gráfica.
- **Estabilidad y rendimiento:** Linux está optimizado para correr procesos largos e intensivos en recursos sin interrupciones.
- **Reproducibilidad:** Los scripts documentan exactamente qué comandos se ejecutaron, facilitando la reproducibilidad científica.
- **Universalidad:** Un script escrito en Linux funcionará igual en macOS y en cualquier servidor Unix del mundo.

### 1.3 Estructura del Sistema de Archivos Linux

A diferencia de Windows (que organiza los archivos por unidades como `C:\`, `D:\`), Linux organiza todo en una jerarquía de directorios que parte desde la **raíz** `/`.

```
/
├── home/        → Directorios personales de usuarios (ej. /home/usuario)
├── bin/         → Programas esenciales del sistema (ls, cp, mv...)
├── usr/         → Programas y utilidades instaladas
├── etc/         → Archivos de configuración del sistema
├── tmp/         → Archivos temporales
├── var/         → Datos variables (logs, bases de datos locales)
└── data/        → (convención) Datos de análisis en servidores
```

**Conceptos clave de navegación:**

| Símbolo / Término | Significado |
|---|---|
| `/` | Directorio raíz (el "tope" del sistema) |
| `~` | Directorio personal del usuario (`/home/usuario`) |
| `.` | Directorio actual |
| `..` | Directorio padre (un nivel arriba) |
| **Ruta absoluta** | Empieza desde `/`, ej. `/home/usuario/datos/seq.fasta` |
| **Ruta relativa** | Relativa al directorio actual, ej. `datos/seq.fasta` |

### 1.4 Comandos Básicos de Navegación

Los comandos de navegación son los primeros que debe memorizar. Permiten moverse por el sistema de archivos y conocer el entorno de trabajo.

| Comando | Descripción | Ejemplo |
|---|---|---|
| `pwd` | Muestra el directorio actual (*print working directory*) | `pwd` |
| `ls` | Lista archivos y carpetas | `ls -la` |
| `cd` | Cambia de directorio (*change directory*) | `cd /home/usuario` |
| `mkdir` | Crea un nuevo directorio | `mkdir resultados` |
| `rmdir` | Elimina un directorio vacío | `rmdir temp` |
| `tree` | Muestra la estructura de directorios en árbol | `tree datos/` |

**Opciones útiles de `ls`:**

```bash
ls -l       # Lista con detalles (permisos, tamaño, fecha)
ls -a       # Muestra archivos ocultos (empiezan con .)
ls -la      # Combinación de ambos
ls -lh      # Tamaños legibles para humanos (KB, MB, GB)
ls *.fasta  # Lista solo archivos con extensión .fasta
```

### 1.5 Comandos de Manipulación de Archivos

Una vez que puede navegar, necesita crear, copiar, mover y eliminar archivos. Estos comandos son los más usados en el día a día bioinformático.

| Comando | Descripción | Ejemplo |
|---|---|---|
| `touch` | Crea un archivo vacío | `touch secuencias.fasta` |
| `cp` | Copia archivos o directorios | `cp seq.fasta backup/` |
| `mv` | Mueve o renombra archivos | `mv seq.fasta datos/` |
| `rm` | Elimina archivos | `rm temp.txt` |
| `cat` | Muestra el contenido de un archivo | `cat seq.fasta` |
| `less` | Visualiza archivos paginados (útil para archivos grandes) | `less genome.fastq` |
| `head` | Muestra las primeras líneas de un archivo | `head -10 seq.fasta` |
| `tail` | Muestra las últimas líneas de un archivo | `tail -5 resultados.txt` |
| `wc` | Cuenta líneas, palabras y caracteres | `wc -l seq.fasta` |

> ⚠️ **Precaución:** El comando `rm` en Linux **no envía archivos a la papelera**. Los elimina de forma permanente e irrecuperable. Úselo con cuidado, especialmente con `rm -r` (elimina directorios completos).

**Comandos de búsqueda y filtrado — fundamentales en bioinformática:**

| Comando | Descripción | Ejemplo bioinformático |
|---|---|---|
| `grep` | Busca patrones de texto en archivos | `grep ">" seq.fasta` (cuenta secuencias) |
| `sort` | Ordena líneas de un archivo | `sort genes.txt` |
| `uniq` | Elimina líneas duplicadas consecutivas | `sort genes.txt \| uniq` |
| `cut` | Extrae columnas de un archivo tabular | `cut -f1,3 anotaciones.gff` |
| `sed` | Editor de flujo para sustituir texto | `sed 's/chr/chromosome/g' archivo.gff` |
| `awk` | Procesamiento de texto por columnas | `awk '$3 == "gene"' anotaciones.gff` |

### 1.6 El Pipe `|` y la Redirección

Una de las características más poderosas de la terminal Unix es la capacidad de **encadenar comandos** y **redirigir** la salida de uno como entrada de otro. Esto permite construir análisis complejos combinando comandos simples.

**Redirección de salida:**
```bash
# Guardar la salida de un comando en un archivo
ls -la > lista_archivos.txt

# Agregar (sin sobreescribir) a un archivo existente
echo "nueva línea" >> notas.txt

# Redirigir errores a un archivo de log
blast.exe 2> errores.log
```

**Pipes `|`:**
```bash
# Contar cuántas secuencias tiene un archivo FASTA
# (cada secuencia empieza con ">")
grep ">" secuencias.fasta | wc -l

# Ver los primeros 5 identificadores de secuencias
grep ">" secuencias.fasta | head -5

# Buscar genes anotados como CDS en un archivo GFF y ordenarlos
grep "CDS" anotacion.gff | sort -k1,1 -k4,4n
```

> 💡 Piense en el `|` como una línea de ensamblaje: la salida de cada trabajador pasa directamente al siguiente. Esta filosofía de "hacer una sola cosa bien y pasarla al siguiente" es uno de los principios de diseño de Unix.

### 1.7 Permisos en Linux

Linux es un sistema multiusuario. Cada archivo y directorio tiene un conjunto de **permisos** que controlan quién puede leer, escribir o ejecutar ese archivo. Esto es especialmente relevante cuando se trabaja en servidores compartidos o se ejecutan scripts.

**Lectura de permisos:**

```bash
$ ls -la
-rwxr-xr-- 1 usuario grupo 4096 Feb 25 10:00 mi_script.sh
```

| Parte | Significado |
|---|---|
| `-` | Tipo: `-` archivo, `d` directorio, `l` enlace |
| `rwx` | Permisos del **dueño**: lectura, escritura, ejecución |
| `r-x` | Permisos del **grupo**: lectura, sin escritura, ejecución |
| `r--` | Permisos de **otros**: solo lectura |

**Modificar permisos con `chmod`:**

```bash
chmod +x mi_script.sh        # Dar permiso de ejecución
chmod 755 mi_script.sh       # rwxr-xr-x (dueño: todo; grupo y otros: leer y ejecutar)
chmod 644 datos.fasta        # rw-r--r-- (dueño: leer/escribir; otros: solo leer)
```

> 💡 En bioinformática, el error más común al ejecutar un script es `Permission denied`. La solución es casi siempre `chmod +x nombre_script.sh`.

### 1.8 Ejecución de Scripts en Linux

Un **script** es un archivo de texto que contiene una secuencia de comandos que se ejecutan de forma automática. Para ejecutar un script en Linux:

1. El archivo debe tener permisos de ejecución (`chmod +x`).
2. Debe indicar al sistema qué intérprete usar (**shebang** en la primera línea).
3. Se ejecuta con `./nombre_script.sh` o `bash nombre_script.sh`.

**Estructura básica de un script ejecutable:**

```bash
#!/bin/bash
# Este es un comentario
# Descripción: script de ejemplo

echo "Iniciando análisis..."
mkdir -p resultados/
grep ">" secuencias.fasta > resultados/ids.txt
echo "Proceso completado. IDs guardados en resultados/ids.txt"
```

**Para ejecutarlo:**
```bash
chmod +x mi_analisis.sh
./mi_analisis.sh
```

---

## Parte 2: Fundamentos de Programación para Bioinformática

### 2.1 ¿Por qué Programar en Bioinformática?

Los comandos de terminal son poderosos, pero tienen límites. Cuando necesita:
- Tomar **decisiones** basadas en el contenido de los datos.
- **Repetir** una operación miles de veces sobre diferentes archivos o secuencias.
- **Calcular** estadísticas, transformar datos o construir modelos.
- Crear herramientas **reutilizables** con parámetros personalizables.

...entonces necesita programar. Los dos lenguajes más utilizados en bioinformática son **Bash** (para automatizar flujos de trabajo) y **Python** (para análisis de datos y desarrollo de herramientas).

---

### 2.2 Conceptos Fundamentales: ¿Qué es programar?

Antes de escribir una sola línea de código, es importante entender los conceptos sobre los que se construye cualquier programa. Usaremos analogías del laboratorio de microbiología para hacer estos conceptos más intuitivos.

#### 🧪 Algoritmo

Imagine que va a realizar un protocolo de extracción de ADN. Antes de empezar, tiene escrito en su cuaderno de laboratorio una secuencia de pasos ordenados: centrifugar, descartar sobrenadante, agregar buffer de lisis, incubar 10 minutos a 65°C, y así sucesivamente. Cada paso depende del anterior, y el orden importa.

Un **algoritmo** es exactamente eso: una secuencia finita y ordenada de instrucciones que resuelven un problema o realizan una tarea. No es código todavía; es la *lógica* del proceso, independiente del lenguaje que se use para implementarlo. Todo programa comienza como un algoritmo en papel (o en la mente del programador) antes de convertirse en código.

> 💡 **Analogía:** El protocolo de laboratorio = el algoritmo. El código = el protocolo escrito en un lenguaje que la computadora puede leer y ejecutar.

#### 📄 Script

Un **script** es un archivo de texto que contiene un algoritmo escrito en un lenguaje de programación específico (Bash, Python, R...) para que una computadora lo ejecute automáticamente, línea por línea.

Si el algoritmo es su protocolo de laboratorio, el script es ese mismo protocolo transcrito en un lenguaje que el computador entiende. La ventaja: un script puede ejecutar en segundos lo que a usted le tomaría horas o días hacer manualmente, y puede repetirlo exactamente de la misma manera una y otra vez, sin errores de transcripción.

En bioinformática, los scripts son la herramienta de trabajo diaria: desde extraer secuencias de un archivo FASTA hasta orquestar pipelines completos de análisis genómico.

---

#### 🧫 Variables: las etiquetas de sus tubos de ensayo

Imagine que en su laboratorio necesita etiquetar tubos para diferentes soluciones o muestras, y que el contenido de esos tubos puede cambiar a lo largo del experimento. Hoy el tubo "Muestra A" contiene 5 mL de cultivo de *E. coli*; mañana podría contener la misma cepa después de un tratamiento diferente.

En programación, esos tubos son las **variables**. Una variable es un contenedor que almacena un dato en la memoria del computador, y al igual que la etiqueta del tubo, tiene un **nombre** que usamos para referirnos a su contenido. Lo más importante: el valor guardado en una variable **puede cambiar** mientras el programa se ejecuta.

**Reglas para nombrar variables:**
- El nombre debe comenzar con una **letra** (no un número ni un símbolo especial).
- Puede contener letras, números y guiones bajos `_`.
- **No se permiten espacios** (use `gc_content` en lugar de `gc content`).
- Los nombres deben ser **descriptivos**: `longitud_gen` es mejor que `x`.
- Son sensibles a mayúsculas: `Secuencia` y `secuencia` son variables diferentes.

```python
# ✅ Nombres válidos y descriptivos
secuencia_adn = "ATGGCTAGC"
num_muestras = 24
gc_content = 0.573
organismo = "Escherichia coli"

# ❌ Nombres inválidos
2muestra = "..."      # Empieza con número
gc content = 0.5      # Tiene espacio
```

> 💡 **Sintaxis**: La sintaxis es el conjunto de reglas que define la estructura de un lenguaje de programación. Al igual que en español existen reglas gramaticales (sujeto + verbo + predicado), cada lenguaje de programación tiene su propia sintaxis. Si no se respeta la sintaxis, el computador no puede interpretar el código, igual que una oración sin estructura gramatical no transmite su mensaje correctamente.

---

#### ⚗️ Tipos de Datos: ¿qué sustancia contiene el frasco?

Una vez que tiene una variable (el frasco etiquetado), necesita saber **qué tipo de sustancia va a almacenar**: ¿es un líquido, un sólido, un gas? ¿Es una solución acuosa o un aceite? El tipo de sustancia determina cómo debe manipularse.

En programación, esto se llama **tipo de dato** (*data type*). Cada variable tiene un tipo de dato, y ese tipo determina qué clase de valor puede almacenar y qué operaciones se pueden realizar con ella.

Los tipos de datos fundamentales son:

| Tipo | Analogía de laboratorio | Descripción | Ejemplo |
|---|---|---|---|
| `int` (entero) | Número de colonias contadas (sin decimales) | Números enteros, positivos o negativos | `num_colonias = 156` |
| `float` (decimal) | Volumen en mL o concentración en µg/µL | Números con decimales | `concentracion = 0.45` |
| `str` (cadena de texto) | La secuencia escrita en el gel o el nombre de la cepa | Texto: letras, números, símbolos entre comillas | `cepa = "E. coli K-12"` |
| `bool` (booleano) | Resultado de una prueba: positivo o negativo | Solo dos valores: `True` o `False` | `es_patogena = True` |
| `list` (lista) | Una gradilla con múltiples tubos ordenados | Colección ordenada y modificable de valores | `muestras = ["M1", "M2", "M3"]` |
| `dict` (diccionario) | Un cuaderno de laboratorio: clave → valor | Pares clave:valor, accesibles por nombre | `conteo = {"A": 45, "T": 42}` |
| `tuple` (tupla) | Coordenadas fijas de un gen en el genoma | Colección ordenada e **inmutable** | `coords = (1450, 2300)` |

> 💡 En Python, el tipo de dato se asigna **automáticamente** según el valor que se guarda. No es necesario declararlo explícitamente como en otros lenguajes. Python infiere que `num_colonias = 156` es un entero y que `cepa = "E. coli"` es un string.

---

#### ➕ Operadores: las operaciones sobre sus muestras

Los **operadores** son los símbolos que le indican al programa qué hacer con los valores almacenados en las variables. Son el equivalente a las operaciones que realiza en el laboratorio: mezclar, medir, comparar, decidir. Existen cuatro categorías principales:

| Operador | Tipo | Significado | Ejemplo bioinformático | Resultado |
|---|---|---|---|---|
| `+` | Aritmético | Suma | `A + T + G + C` | `total_bases` |
| `-` | Aritmético | Resta | `longitud - gc` | bases no GC |
| `*` | Aritmético | Multiplicación | `stock * factor_dilucion` | concentración final |
| `/` | Aritmético | División real | `gc / longitud * 100` | % GC con decimales |
| `//` | Aritmético | División entera (sin decimales) | `longitud // 3` | número de codones |
| `%` | Aritmético | Módulo — residuo de la división | `longitud % 3` | `0` si divisible por 3 |
| `**` | Aritmético | Potencia | `4 ** 10` | posibles k-mers de 10 bases |
| `=` | Asignación | Asigna un valor a una variable | `gc_content = 0.57` | — |
| `+=` | Asignación | Suma y reasigna | `conteo += 1` | incrementa en 1 |
| `-=` | Asignación | Resta y reasigna | `restantes -= 1` | decrementa en 1 |
| `==` | Comparación | Igual a | `organismo == "E. coli"` | `True` o `False` |
| `!=` | Comparación | Distinto de | `organismo != "humano"` | `True` o `False` |
| `>` | Comparación | Mayor que | `longitud > 500` | `True` o `False` |
| `<` | Comparación | Menor que | `calidad < 30` | `True` o `False` |
| `>=` | Comparación | Mayor o igual que | `cobertura >= 20` | `True` o `False` |
| `<=` | Comparación | Menor o igual que | `longitud <= 200` | `True` o `False` |
| `and` | Lógico | Ambas condiciones verdaderas | `gc > 0.4 and longitud > 200` | `True` solo si ambas son `True` |
| `or` | Lógico | Al menos una condición verdadera | `org == "E. coli" or org == "Salmonella"` | `True` si alguna es `True` |
| `not` | Lógico | Invierte el resultado | `not es_patogena` | `True` si era `False` |
| `in` | Pertenencia | Comprueba si un elemento está en una colección | `"A" in secuencia` | `True` o `False` |
| `not in` | Pertenencia | Comprueba si un elemento NO está en una colección | `"X" not in nucleotidos` | `True` o `False` |

> ⚠️ **Error frecuente:** `=` y `==` son completamente diferentes. `=` **asigna** un valor (`gc = 0.5` guarda el número en la variable). `==` **compara** dos valores (`gc == 0.5` pregunta si son iguales y devuelve `True` o `False`). Confundirlos es uno de los errores más comunes al comenzar a programar.

---

#### 🔬 Operadores Lógicos y Tablas de Verdad

Los operadores lógicos (`and`, `or`, `not`) trabajan con valores booleanos (`True`/`False`) y son el núcleo de cualquier sistema de toma de decisiones en un programa. Para entender cómo se comportan, se usan las **tablas de verdad**.

**Analogía de laboratorio:** Imagine que tiene dos pruebas diagnósticas para identificar una bacteria: la **tinción de Gram** y la **prueba de catalasa**. Dependiendo del operador lógico que use, el resultado combinado cambia.

**Operador `and` — ambas condiciones deben ser verdaderas:**

> *"La bacteria es Gram positiva **Y** catalasa positiva"* → solo si ambas pruebas dan positivo.

| Condición A | Condición B | A `and` B |
|---|---|---|
| `True` | `True` | ✅ `True` |
| `True` | `False` | ❌ `False` |
| `False` | `True` | ❌ `False` |
| `False` | `False` | ❌ `False` |

**Operador `or` — al menos una condición debe ser verdadera:**

> *"La bacteria es Gram positiva **O** produce beta-lactamasa"* → basta con que una de las dos sea cierta.

| Condición A | Condición B | A `or` B |
|---|---|---|
| `True` | `True` | ✅ `True` |
| `True` | `False` | ✅ `True` |
| `False` | `True` | ✅ `True` |
| `False` | `False` | ❌ `False` |

**Operador `not` — invierte el resultado:**

> *"La bacteria **NO** es Gram negativa"* → si era `False`, pasa a `True`, y viceversa.

| Condición A | `not` A |
|---|---|
| `True` | ❌ `False` |
| `False` | ✅ `True` |

---

> ⚠️ **Aclaración frecuente: ¿`False and False` no debería ser `True` porque "ambas se cumplen igual"?**
>
> No. La clave está en entender **qué pregunta hace cada operador**:
>
> - `and` pregunta: *"¿Son ambas condiciones **verdaderas**?"* — no pregunta si son iguales.
> - `False and False` dice: ¿Es `False` verdadero? → No. ¿Es `False` verdadero? → No. → Resultado: `False`.
>
> El hecho de que ambos valores sean iguales entre sí **no importa** para `and`. Lo único que importa es si cada uno es `True`.
>
> **Analogía:** Regla del laboratorio: *"Solo puede usar la muestra si está descongelada **Y** está etiquetada."*
>
> | ¿Está descongelada? | ¿Está etiquetada? | ¿Puede usarla? (`and`) |
> |---|---|---|
> | ✅ Sí | ✅ Sí | ✅ Sí |
> | ✅ Sí | ❌ No | ❌ No |
> | ❌ No | ✅ Sí | ❌ No |
> | ❌ No | ❌ No | ❌ No |
>
> En la última fila, la muestra **no** está descongelada **y tampoco** está etiquetada. El hecho de que ambas condiciones fallen de la misma manera no cambia el resultado: sigue siendo **No**.
>
> **Si lo que quiere preguntar es "¿son iguales?", eso es el operador `==`, no `and`:**
>
> ```python
> False == False   # → True  ✅ (son iguales entre sí)
> True  == True    # → True  ✅ (son iguales entre sí)
> False == True    # → False ❌ (no son iguales)
>
> False and False  # → False ❌ (ninguna es verdadera)
> ```
>
> | Expresión | Pregunta que hace | Resultado |
> |---|---|---|
> | `False and False` | ¿Ambas son **verdaderas**? | ❌ `False` |
> | `False or False` | ¿**Alguna** es verdadera? | ❌ `False` |
> | `not False` | ¿Lo opuesto de `False`? | ✅ `True` |
> | `False == False` | ¿Son **iguales** entre sí? | ✅ `True` |

---

#### 🔢 Orden de Evaluación y el Uso de Paréntesis

Al igual que en matemáticas, los operadores tienen un **orden de precedencia**: algunos se evalúan antes que otros. Cuando hay ambigüedad, el computador sigue este orden (de mayor a menor prioridad):

| Prioridad | Operador(es) | Descripción |
|---|---|---|
| 1 (más alta) | `( )` | **Paréntesis** — lo que está dentro se evalúa primero |
| 2 | `**` | Potencia |
| 3 | `*`, `/`, `//`, `%` | Multiplicación y división |
| 4 | `+`, `-` | Suma y resta |
| 5 | `==`, `!=`, `<`, `>`, `<=`, `>=` | Comparación |
| 6 | `not` | Negación lógica |
| 7 | `and` | Y lógico |
| 8 (más baja) | `or` | O lógico |

**Los paréntesis son su mejor herramienta para controlar el orden de evaluación y hacer el código más legible:**

```python
# Sin paréntesis — puede ser ambiguo o dar resultados inesperados
resultado = gc > 0.4 and longitud > 200 or es_patogena

# Con paréntesis — la intención es clara y el orden es el deseado
resultado = (gc > 0.4 and longitud > 200) or es_patogena

# Ejemplo aritmético: calcular el % GC correctamente
# ❌ Sin paréntesis: primero divide gc entre longitud, luego suma C
porcentaje = G + C / longitud * 100

# ✅ Con paréntesis: primero suma G+C, luego divide por longitud
porcentaje = (G + C) / longitud * 100
```

> 💡 **Regla de oro:** cuando combine múltiples operadores lógicos o aritméticos en una sola línea, use paréntesis aunque no sean estrictamente necesarios. Su código será más claro y evitará errores difíciles de detectar.

---

#### 🔀 Estructuras Condicionales: las decisiones del protocolo

En el laboratorio, muchos protocolos incluyen puntos de decisión: *"Si el pH es menor a 7, agregar buffer neutralizante; si está entre 7 y 8, continuar; si es mayor a 8, descartar la muestra"*. Esta lógica de decisión existe también en programación y se llama **estructura condicional**.

Una estructura condicional permite que el programa **ejecute diferentes bloques de código según si una condición es verdadera o falsa**. Es el mecanismo fundamental para que un programa tome decisiones inteligentes basadas en los datos.

> 💡 **Analogía:** Es como el árbol de decisiones en un flujograma de diagnóstico clínico microbiológico: *"¿Tinción de Gram positiva?"* → Sí → *"¿Morfología en racimos?"* → Sí → posible *Staphylococcus*. Cada rama del árbol depende del resultado anterior.

**Estructura básica (`if` / `elif` / `else`):**

```
si <condición> es verdadera:
    ejecutar este bloque
si no, si <otra condición> es verdadera:
    ejecutar este otro bloque
si ninguna de las anteriores:
    ejecutar este bloque por defecto
```

**En Python:**

```python
gc_content = 0.65

# if: se ejecuta si la condición es True
if gc_content > 0.60:
    print("Alto contenido GC — posiblemente Actinobacteria")

# elif (else if): condición alternativa, se evalúa solo si la anterior fue False
elif gc_content >= 0.40:
    print("Contenido GC moderado")

# else: se ejecuta si ninguna condición anterior fue True
else:
    print("Bajo contenido GC — posiblemente Firmicutes de baja GC")
```

**Condicionales con operadores lógicos combinados:**

```python
longitud = 850
gc = 0.58
es_completo = True

# and: ambas condiciones deben cumplirse
if longitud > 500 and gc > 0.50:
    print("Secuencia larga con alto contenido GC")

# or: al menos una condición debe cumplirse
if longitud < 100 or gc < 0.30:
    print("⚠️ Secuencia sospechosa: muy corta o muy bajo GC")

# not: evalúa la negación
if not es_completo:
    print("Advertencia: el genoma está incompleto")

# Combinación con paréntesis para mayor claridad
if (longitud > 200 and gc > 0.40) or es_completo:
    print("Secuencia aceptable para el análisis")
```

**Condicionales anidados** — un `if` dentro de otro, como las ramas de un árbol de diagnóstico:

```python
gram = "positivo"
morfologia = "cocos"
agrupacion = "racimos"

if gram == "positivo":
    if morfologia == "cocos":
        if agrupacion == "racimos":
            print("Posible: Staphylococcus")
        elif agrupacion == "cadenas":
            print("Posible: Streptococcus")
        else:
            print("Cocos Gram positivos — agrupación no determinada")
    elif morfologia == "bacilos":
        print("Posible: Bacillus o Clostridium")
else:
    print("Gram negativo — continuar con otras pruebas")
```

**En Bash:**

```bash
#!/bin/bash
ARCHIVO="datos.fasta"
MIN_SEQS=10

# Verificar si el archivo existe
if [ -f "$ARCHIVO" ]; then
    NUM_SEQS=$(grep -c ">" "$ARCHIVO")

    # Condicional anidado: verificar cantidad mínima de secuencias
    if [ "$NUM_SEQS" -ge "$MIN_SEQS" ]; then
        echo "✅ Archivo válido con $NUM_SEQS secuencias. Procesando..."
    else
        echo "⚠️ Solo $NUM_SEQS secuencias encontradas. Se requieren al menos $MIN_SEQS."
    fi
else
    echo "❌ Error: el archivo $ARCHIVO no fue encontrado."
    exit 1
fi
```

**Operadores de comparación en Bash** (la sintaxis es distinta a Python):

| Operador Bash | Tipo | Equivalente en Python | Significado |
|---|---|---|---|
| `-eq` | Numérico | `==` | Igual a |
| `-ne` | Numérico | `!=` | Distinto de |
| `-gt` | Numérico | `>` | Mayor que |
| `-lt` | Numérico | `<` | Menor que |
| `-ge` | Numérico | `>=` | Mayor o igual que |
| `-le` | Numérico | `<=` | Menor o igual que |
| `==` | Texto | `==` | Igual a (cadenas) |
| `!=` | Texto | `!=` | Distinto de (cadenas) |
| `-f` | Archivo | — | El archivo existe |
| `-d` | Directorio | — | El directorio existe |
| `-z` | Texto | `== ""` | La cadena está vacía |
| `!` | Lógico | `not` | Negación |
| `-a` | Lógico | `and` | Y lógico (dentro de `[ ]`) |
| `-o` | Lógico | `or` | O lógico (dentro de `[ ]`) |

---

#### 🔄 Bucles: los procesos repetitivos del laboratorio

Imagine que debe medir la absorbancia de 96 muestras en una placa de ELISA. El procedimiento es idéntico para cada pocillo: leer el valor, registrarlo, pasar al siguiente. Sería ineficiente (e impensable) escribir 96 veces las mismas instrucciones.

Un **bucle** (*loop*) permite repetir un bloque de instrucciones múltiples veces, ya sea un número determinado de veces (`for`) o mientras se cumpla una condición (`while`). En bioinformática, los bucles son omnipresentes: procesar cada secuencia de un archivo FASTA, cada lectura de un FASTQ, cada gen de una anotación.

> 💡 **Analogía:** El bucle es como el brazo robótico de un secuenciador: realiza exactamente la misma operación sobre miles de muestras, sin fatiga y sin errores.

---

#### 🧩 Funciones: los protocolos estandarizados y reutilizables

En un laboratorio bien organizado, los protocolos más usados se estandarizan y se documentan: extracción de ADN, PCR, electroforesis. Una vez que el protocolo está validado, cualquier miembro del laboratorio puede seguirlo sin necesidad de reinventar el proceso cada vez.

En programación, esto se logra con las **funciones**. Una función es un bloque de código con un nombre, que realiza una tarea específica y puede ser llamado (ejecutado) cuantas veces sea necesario, desde cualquier parte del programa, pasándole diferentes datos de entrada (**parámetros**) y obteniendo un resultado de salida (**retorno**).

> 💡 **Analogía:** La función = el protocolo estandarizado. Los parámetros = las muestras que le pasa al protocolo. El retorno = el resultado que obtiene del protocolo.

### 2.3 Introducción a Bash Scripting

**Bash** (*Bourne Again SHell*) es el lenguaje de scripting nativo de Linux. Es ideal para orquestar herramientas bioinformáticas, automatizar pipelines y procesar archivos en lote.

#### Variables en Bash

```bash
#!/bin/bash
# Declaración de variables (sin espacios alrededor del =)
ARCHIVO="secuencias.fasta"
ORGANISMO="E. coli"
NUM_SECUENCIAS=$(grep -c ">" $ARCHIVO)   # Captura la salida de un comando

echo "Analizando: $ORGANISMO"
echo "Número de secuencias en $ARCHIVO: $NUM_SECUENCIAS"
```

> 💡 Los ejemplos de condicionales en Bash y la tabla completa de operadores de comparación se encuentran en la sección 2.2. Allí también se explican las tablas de verdad y el uso de paréntesis.

#### Bucles en Bash

Los bucles son esenciales para procesar múltiples archivos biológicos de forma automática:

```bash
#!/bin/bash
# Procesar todos los archivos FASTA en un directorio
for ARCHIVO in *.fasta; do
    echo "Procesando: $ARCHIVO"
    NUM_SEQ=$(grep -c ">" "$ARCHIVO")
    echo "  → $NUM_SEQ secuencias encontradas"
done
```

```bash
#!/bin/bash
# Bucle while: leer líneas de un archivo de lista de muestras
while IFS= read -r MUESTRA; do
    echo "Descargando datos de: $MUESTRA"
    # aquí iría el comando de descarga
done < lista_muestras.txt
```

#### Funciones en Bash

```bash
#!/bin/bash
# Definir una función reutilizable
contar_secuencias() {
    local archivo=$1
    local count=$(grep -c ">" "$archivo")
    echo "$count"
}

# Llamar la función
TOTAL=$(contar_secuencias "genoma.fasta")
echo "Total de secuencias: $TOTAL"
```

### 2.4 Introducción a Python para Bioinformática

**Python** es el lenguaje de programación más popular en bioinformática hoy en día. Su sintaxis clara, su amplia comunidad y la disponibilidad de librerías especializadas (como **Biopython**, **Pandas**, **NumPy**) lo hacen ideal para el análisis de datos biológicos.

A continuación se muestra cómo se implementan en Python los conceptos definidos en la sección 2.2.

#### Tipos de Datos y Variables en Python

Todos los tipos de datos descritos anteriormente (ver sección 2.2) se declaran en Python de forma directa, sin necesidad de especificar el tipo: Python lo infiere automáticamente según el valor asignado.

```python
# Enteros (int)
longitud_gen = 1200

# Flotantes (float)
gc_content = 0.573

# Cadenas de texto (str) — fundamentales para manejar secuencias
secuencia = "ATGGCTAGCTAGCTAGC"
organismo = "Escherichia coli"

# Booleanos (bool)
es_codificante = True

# Listas — colecciones ordenadas y modificables
nucleotidos = ["A", "T", "G", "C"]
longitudes = [1200, 850, 2340, 670]

# Diccionarios — pares clave:valor, ideales para contar nucleótidos
conteo = {"A": 45, "T": 42, "G": 38, "C": 40}

# Tuplas — colecciones ordenadas e inmutables
coordenadas_gen = (1450, 2300)
```

#### Variables y Operadores

```python
# Asignación de variables
secuencia = "ATGGCTAGCTAGCTAGC"
longitud = len(secuencia)       # Función len() para longitudes

# Operadores aritméticos
gc = secuencia.count("G") + secuencia.count("C")
gc_porcentaje = (gc / longitud) * 100

# Operadores de comparación
print(gc_porcentaje > 50)       # True o False
print(longitud == 18)           # True

# Operaciones con strings (secuencias)
complemento = secuencia.replace("A","t").replace("T","a").replace("G","c").replace("C","g").upper()
print(secuencia[::-1])          # Secuencia invertida
```

#### Estructuras Condicionales en Python

> Los conceptos, tablas de verdad y uso de paréntesis están explicados en la sección 2.2. Aquí se muestra la implementación en Python con ejemplos de análisis de secuencias.

```python
gc_content = 0.65

if gc_content > 0.60:
    print("Alto contenido GC — posiblemente Actinobacteria o Firmicutes de alta GC")
elif gc_content >= 0.40:
    print("Contenido GC moderado")
else:
    print("Bajo contenido GC")
```

#### Bucles en Python

```python
# Iterar sobre una secuencia de ADN
secuencia = "ATGGCTAGCTAGCTAGC"

# Contar cada nucleótido
conteo = {"A": 0, "T": 0, "G": 0, "C": 0}

for nucleotido in secuencia:
    if nucleotido in conteo:
        conteo[nucleotido] += 1

print(conteo)
# Output: {'A': 2, 'T': 3, 'G': 5, 'C': 4, ...}

# Bucle for con range — procesar codones
for i in range(0, len(secuencia)-2, 3):
    codon = secuencia[i:i+3]
    print(f"Codón: {codon}")
```

#### Funciones en Python

Las funciones permiten encapsular lógica y reutilizarla. En bioinformática, se usan constantemente para procesar secuencias:

```python
def calcular_gc(secuencia):
    """
    Calcula el contenido GC de una secuencia de ADN.
    
    Args:
        secuencia (str): Secuencia de ADN en mayúsculas.
    
    Returns:
        float: Porcentaje de GC (0-100).
    """
    secuencia = secuencia.upper()
    gc = secuencia.count("G") + secuencia.count("C")
    return (gc / len(secuencia)) * 100


def leer_fasta(ruta_archivo):
    """
    Lee un archivo FASTA y devuelve un diccionario {id: secuencia}.
    """
    secuencias = {}
    id_actual = None
    with open(ruta_archivo, "r") as f:
        for linea in f:
            linea = linea.strip()
            if linea.startswith(">"):
                id_actual = linea[1:]
                secuencias[id_actual] = ""
            else:
                secuencias[id_actual] += linea
    return secuencias


# Uso de las funciones
secuencias = leer_fasta("bacterias.fasta")

for nombre, seq in secuencias.items():
    gc = calcular_gc(seq)
    print(f"{nombre}: GC = {gc:.2f}%")
```

### 2.5 Aplicación de la Programación al Análisis de Secuencias Genéticas

La programación cobra sentido cuando se aplica a problemas reales. A continuación se presentan algunos ejemplos del tipo de operaciones que se realizan rutinariamente en bioinformática y que se automatizarán con código:

#### Manipulación de archivos FASTA

Los archivos FASTA son el formato de secuencias más universal. Con Python es posible:
- Leer y parsear archivos con miles de secuencias.
- Filtrar secuencias por longitud, contenido GC u otros criterios.
- Renombrar identificadores, eliminar duplicados y reformatear encabezados.
- Dividir archivos FASTA grandes en lotes más pequeños.

#### Conteo y análisis de composición nucleotídica

Una de las primeras métricas en cualquier análisis genómico es la composición de bases:
- **Contenido GC:** Indicador del organismo (bacterias de alta GC vs. baja GC).
- **Frecuencia de codones:** Importante para expresión heteróloga de proteínas.
- **Distribución de k-mers:** Base de muchos ensambladores de genomas.

#### Procesamiento en lote con scripts

Una tarea fundamental es procesar decenas o cientos de archivos de la misma manera. Un script de Python o Bash puede:
- Recorrer todos los archivos `.fastq` de un directorio.
- Aplicar el mismo análisis a cada uno.
- Generar un reporte consolidado con los resultados.

```python
import os

directorio = "datos_fastq/"
reporte = []

for archivo in os.listdir(directorio):
    if archivo.endswith(".fastq"):
        ruta = os.path.join(directorio, archivo)
        with open(ruta) as f:
            lineas = f.readlines()
        num_lecturas = len(lineas) // 4   # Cada lectura FASTQ ocupa 4 líneas
        reporte.append(f"{archivo}: {num_lecturas} lecturas")

# Guardar reporte
with open("reporte_muestras.txt", "w") as out:
    out.write("\n".join(reporte))

print("Reporte generado.")
```

### 2.6 Buenas Prácticas de Programación en Bioinformática

El código bioinformático no solo debe funcionar: debe ser **legible**, **reproducible** y **mantenible**. Algunas buenas prácticas fundamentales:

**Documentación y comentarios:**
```python
# ✅ Bueno: el comentario explica el POR QUÉ, no el qué
# Eliminamos secuencias menores a 200 bp ya que son artefactos de secuenciación
secuencias_filtradas = {k: v for k, v in secuencias.items() if len(v) >= 200}

# ❌ Malo: el comentario solo repite lo que el código ya dice
# Filtramos las secuencias
secuencias_filtradas = {k: v for k, v in secuencias.items() if len(v) >= 200}
```

**Organización del proyecto:**
```
proyecto_genomica/
├── data/
│   ├── raw/          → Datos originales (nunca se modifican)
│   └── processed/    → Datos después del análisis
├── code/             → Codigo o Scripts de análisis
├── results/          → Salidas de los análisis
│   ├── raw/          → Datos originales (nunca se modifican)
│   └── processed/    → Datos después del análisis
├── docs/             → Todo lo relacionado a informes o texto para publicación
│   ├── reports/      → Reportes que se presentan a supervisores o colaboradores
│   └── text/         → Texto para publicación en revistas, lo ideal es agregar tres sub carpetas, text, figures, y supplementary
└── README.md         → Descripción del proyecto
```

> 💡 **¿No quieres crear esta estructura manualmente cada vez?** Existe un template de GitHub diseñado específicamente para proyectos de biología computacional que genera esta estructura automáticamente. Puedes usarlo como punto de partida para cualquier proyecto:
> **[github.com/ae-tafur/computational-biology-projects](https://github.com/ae-tafur/computational-biology-projects)**
> Para usarlo, ve al repositorio y haz clic en **"Use this template"** → **"Create a new repository"**. GitHub creará un repositorio nuevo en tu cuenta con toda la estructura de carpetas lista para trabajar.

**Otras buenas prácticas:**
- Usar **nombres descriptivos** para variables y funciones (`gc_content` en lugar de `x`).
- **Nunca modificar los datos crudos** originales; trabajar siempre sobre copias.
- Registrar las **versiones del software** utilizado (Python 3.11, Biopython 1.81...).
- Usar **control de versiones** (Git/GitHub) para todos los scripts.
- Escribir scripts que **fallen con mensajes claros** cuando algo no funciona.

---

## Resumen del Módulo

Este módulo sienta las bases computacionales para todo el trabajo bioinformático que vendrá. La línea de comandos de Linux, combinada con la capacidad de escribir scripts en Bash y Python, le da acceso a prácticamente la totalidad del ecosistema de herramientas bioinformáticas.

| Habilidad                | Herramienta          | Aplicación bioinformática                                |
|--------------------------|----------------------|----------------------------------------------------------|
| Navegación del sistema   | Linux terminal       | Organizar proyectos, acceder a servidores                |
| Manipulación de archivos | `grep`, `awk`, `sed` | Procesar FASTA, GFF, FASTQ desde la terminal             |
| Automatización           | Bash scripting       | Pipelines, procesamiento en lote                         |
| Análisis de datos        | Python               | Parsear secuencias, calcular estadísticas, filtrar datos |
| Reproducibilidad         | Git + GitHub         | Versionar código, compartir análisis                     |

Recuerde: la programación es una habilidad que se adquiere con práctica constante. No se preocupe si al principio los comandos o el código no le resultan intuitivos: con cada ejercicio, cada error y cada solución encontrada, estará construyendo una competencia que transformará la manera en que hace ciencia.

---

## Recursos Adicionales

- **The Linux Command Line** (William Shotts) — Libro gratuito en línea: https://linuxcommand.org/tlcl.php
- **Python for Biologists** — https://pythonforbiologists.com/
- **Biopython Tutorial** — https://biopython.org/DIST/docs/tutorial/Tutorial.html
- **Software Carpentry: Unix Shell** — https://swcarpentry.github.io/shell-novice/
- **Software Carpentry: Programming with Python** — https://swcarpentry.github.io/python-novice-inflammation/
- **Rosalind** (ejercicios prácticos de bioinformática) — https://rosalind.info/

