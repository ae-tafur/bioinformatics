# 🖥️ Práctica: Uso de la línea de comandos Unix con archivos biológicos

## Introducción

Hasta ahora ha configurado su entorno de trabajo en GitHub Codespaces y ha dado sus primeros pasos en la terminal Unix. En esta práctica dará el siguiente paso: aprender a moverse con soltura en el sistema de archivos, inspeccionar y manipular archivos biológicos reales directamente desde la línea de comandos, y construir sus primeros pipelines usando pipes y redirección.

La línea de comandos no es solo una herramienta técnica: es el lenguaje con el que el bioinformático habla con el computador. Saber usarla bien significa poder inspeccionar un archivo de miles de secuencias en segundos, contar genes anotados en un genoma sin abrir ningún programa, o filtrar resultados de antibiogramas con un solo comando. Todo lo que haría manualmente con un software de escritorio, pero de forma reproducible, automática y escalable.

En esta práctica trabajará con archivos del tipo que encontrará en cualquier proyecto bioinformático real: secuencias en formato **FASTA**, resultados de **PCR**, anotaciones de genomas en **GFF3**, datos de **antibiogramas**, curvas de crecimiento bacteriano y más. Todos los archivos están disponibles en la carpeta `data/` del repositorio.

---

## 🎯 Objetivos

- Navegar por el sistema de archivos Linux desde la terminal usando rutas absolutas y relativas.
- Inspeccionar archivos biológicos de diferentes formatos (FASTA, CSV, TSV, GFF3) sin salir de la terminal.
- Usar comandos de búsqueda y filtrado (`grep`, `cut`, `sort`, `wc`) sobre archivos biológicos reales.
- Construir pipelines básicos con pipes `|` y redirigir resultados a nuevos archivos.
- Organizar un proyecto bioinformático con la estructura de directorios correcta.

---

## 📦 Requisitos previos

- Cuenta de **GitHub** activa (ver Práctica 1).
- Acceso a **GitHub Codespaces** con el repositorio del curso abierto.
- Haber leído la **Parte 1** del README del Módulo 2 (secciones 1.1 a 1.8).

---

## 🗂️ Archivos de datos disponibles

Todos los archivos de esta práctica se encuentran en la carpeta `data/` dentro del directorio de ejercicios. Antes de comenzar, familiarícese con su contenido:

| Archivo                | Formato   | Descripción                                  |
|------------------------|-----------|----------------------------------------------|
| `01_sequences.fasta`   | FASTA     | 10 secuencias de ADN de ejemplo              |
| `02_results_pcr_96.csv` | CSV       | Resultados de PCR en placa de 96 pocillos    |
| `03_nucleotides.fa`    | FASTA     | Secuencia única de ADN para análisis         |
| `05_genome.gff3`       | GFF3      | Anotación de genes en dos cromosomas         |
| `06_bacterial_growth.tsv` | TSV       | Absorbancias OD600 de tres cepas bacterianas |
| `07_mutations.fasta`   | FASTA     | Secuencia de referencia y dos mutantes       |
| `08_antibiogram.csv`   | CSV       | Resultados de antibiograma (R/S/I)           |
| `09_short_sequences.fasta` | FASTA     | Secuencias de distinta longitud              |
| `12_gene_annotations.tsv` | TSV       | Anotación funcional de genes (KO IDs)        |

---

## 🔬 Procedimiento

### Parte 1: Navegación y exploración del entorno

#### Paso a paso:

1. **Abra su Codespace existente.** Si ya creó un Codespace en la Práctica 1, **úselo**. No cree uno nuevo cada vez: cada Codespace ocupa cuota de su plan gratuito y los archivos creados en uno no están disponibles en otro.
   - Vaya a [github.com/codespaces](https://github.com/codespaces) y verá la lista de sus Codespaces activos.
   - Haga clic en el que ya creó para retomarlo exactamente donde lo dejó.
   - Si fue eliminado automáticamente (tras 30 días de inactividad), entonces sí cree uno nuevo desde el repositorio del curso siguiendo los pasos de la Práctica 1.

   Una vez dentro, **abra la terminal** (`Terminal` → `New Terminal` o `` Ctrl + ` ``).

2. **Ubíquese en el directorio correcto.** Navegue hasta la carpeta de ejercicios:
   ```bash
   cd exercises/
   pwd
   ```
   Confirme que la ruta termina en `.../02-coding-basics/exercises`.

3. **Explore la estructura de archivos disponibles:**
   ```bash
   ls
   ls -lh data/
   ```
   - ¿Cuántos archivos hay en la carpeta `data/`?
   - ¿Cuál es el archivo más grande? ¿Y el más pequeño?

4. **Cree la estructura de directorios para esta práctica:**
   ```bash
   mkdir -p results/sequences
   mkdir -p results/annotations
   mkdir -p results/reports
   ```
   Verifique que se crearon correctamente:
   ```bash
   tree .
   ```
   > 💡 La opción `-p` en `mkdir` crea también los directorios intermedios si no existen. Si `tree` no está disponible, use `ls -R`.

5. **Copie los archivos de datos a su área de trabajo:**
   ```bash
   cp data/*.fasta results/sequences/
   cp data/*.fa results/sequences/
   ls -lh results/sequences/
   ```

---

### Parte 2: Inspección de archivos biológicos

Una de las tareas más frecuentes en bioinformática es inspeccionar archivos sin abrirlos con un editor gráfico. Estos comandos le permitirán hacerlo directamente desde la terminal.

#### Con archivos FASTA

6. **Ver las primeras líneas** del archivo de secuencias:
   ```bash
   head data/01_sequences.fasta
   ```
   ¿Qué símbolo identifica el inicio de cada secuencia?

7. **Contar cuántas secuencias tiene el archivo:**
   ```bash
   grep -c ">" data/01_sequences.fasta
   ```
   El símbolo `>` marca el encabezado de cada secuencia en formato FASTA. `grep -c` cuenta las líneas que coinciden con el patrón.

8. **Ver solo los encabezados (identificadores) de las secuencias:**
   ```bash
   grep ">" data/01_sequences.fasta
   ```

9. **Ver el archivo completo de mutaciones:**
   ```bash
   cat data/07_mutations.fasta
   ```
   ¿Cuántas secuencias hay? ¿Cuál es la de referencia?

10. **Comparar longitudes visualmente** entre las secuencias cortas:
    ```bash
    cat data/09_short_sequences.fasta
    ```
    ¿Cuál parece ser la secuencia más corta? ¿Cuál la más larga?

#### Con archivos tabulares (CSV / TSV)

11. **Inspeccionar el antibiograma:**
    ```bash
    cat data/08_antibiogram.csv
    ```
    ¿Qué significan los valores R, S e I?
    > R = Resistente, S = Sensible, I = Intermedio

12. **Ver solo las primeras filas del archivo de PCR:**
    ```bash
    head -5 data/02_results_pcr_96.csv
    ```

13. **Contar cuántos pocillos amplificaron** en la placa de PCR:
    ```bash
    grep -c "Amplificó" data/02_results_pcr_96.csv
    ```
    Luego cuente los que **no** amplificaron:
    ```bash
    grep -c "No amplificó" data/02_results_pcr_96.csv
    ```

14. **Inspeccionar la anotación del genoma GFF3:**
    ```bash
    cat data/05_genome.gff3
    ```
    - ¿En cuántos cromosomas están anotados los genes?
    - ¿Cuántos genes están en la hebra positiva (`+`) y cuántos en la negativa (`-`)?

---

### Parte 3: Búsqueda, filtrado y procesamiento

Aquí es donde la terminal comienza a mostrar su verdadero poder. Estos comandos le permiten extraer información específica de archivos grandes de forma instantánea.

15. **Extraer solo los genes del archivo GFF3** (filtrar por tipo de elemento):
    ```bash
    grep "gene" data/05_genome.gff3
    ```

16. **Extraer solo los genes anotados en `chr2`:**
    ```bash
    grep "chr2" data/05_genome.gff3
    ```

17. **Contar cuántos genes tiene cada cromosoma** (combinando `grep` y `wc -l`):
    ```bash
    grep "chr1" data/05_genome.gff3 | grep "gene" | wc -l
    grep "chr2" data/05_genome.gff3 | grep "gene" | wc -l
    ```

18. **Ver solo la primera columna** (cromosoma) del archivo GFF3 con `cut`:
    ```bash
    cut -f1 data/05_genome.gff3
    ```
    > 💡 `cut -f1` extrae la primera columna usando tabulación como separador por defecto. Para CSV use `cut -d',' -f1`.

19. **Extraer la columna de resultados del antibiograma** y ordenarla:
    ```bash
    cut -d',' -f3 data/08_antibiogram.csv | sort
    ```
    ¿Cuántas cepas son Resistentes (R)?

20. **Filtrar solo las cepas resistentes** y guardar el resultado:
    ```bash
    grep ",R" data/08_antibiogram.csv > results/reports/cepas_resistentes.txt
    cat results/reports/cepas_resistentes.txt
    ```

21. **Buscar genes con anotación funcional** (que no sean `NA`) en el archivo de anotaciones:
    ```bash
    grep -v "NA" data/12_gene_annotations.tsv | head -10
    ```
    > 💡 `grep -v` invierte el filtro: muestra las líneas que **no** contienen el patrón.

22. **Contar cuántos genes tienen y no tienen anotación funcional:**
    ```bash
    grep -c "NA" data/12_gene_annotations.tsv
    grep -v "NA" data/12_gene_annotations.tsv | grep -v "gene_ID" | wc -l
    ```

---

### Parte 4: Pipes y construcción de pipelines

23. **Extraer los IDs de todas las secuencias** del archivo principal y guardarlos en un archivo:
    ```bash
    grep ">" data/01_sequences.fasta | sed 's/>//' > results/reports/sequence_ids.txt
    cat results/reports/sequence_ids.txt
    ```
    > 💡 `sed 's/>//'` sustituye el símbolo `>` por nada (lo elimina), dejando solo el nombre de la secuencia.

24. **Contar el total de bases** en la secuencia del archivo `03_nucleotides.fa`:
    ```bash
    grep -v ">" data/03_nucleotides.fa | wc -c
    ```
    > Nota: `wc -c` cuenta caracteres incluyendo el salto de línea (`\n`). Reste 1 al resultado para obtener el número real de bases.

25. **Construir un reporte rápido de todos los archivos FASTA** — número de secuencias por archivo:
    ```bash
    for archivo in data/*.fasta data/*.fa; do
        echo -n "$archivo: "
        grep -c ">" "$archivo"
    done
    ```
    Guarde este reporte:
    ```bash
    for archivo in data/*.fasta data/*.fa; do
        echo -n "$archivo: "
        grep -c ">" "$archivo"
    done > results/reports/resumen_fasta.txt

    cat results/reports/resumen_fasta.txt
    ```

26. **Extraer todas las anotaciones funcionales únicas** del archivo de anotaciones:
    ```bash
    cut -f4 data/12_gene_annotations.tsv | grep -v "NA" | grep -v "KO_annotation" | sort | uniq | head -20
    ```
    ¿Reconoce alguna de las funciones listadas?

---

### Parte 5: Descarga de datos desde la terminal

En bioinformática, rara vez los datos viven en su computador desde el principio. Lo más habitual es descargarlos directamente desde bases de datos públicas como **NCBI**, **UniProt** o **Ensembl** sin salir de la terminal. El comando `wget` es la herramienta estándar para hacerlo.

> 💡 `wget` ("World Wide Web get") descarga archivos desde una URL, exactamente como lo haría un navegador, pero sin interfaz gráfica. Esto lo hace ideal para scripts automatizados y servidores remotos.

#### Descargando un archivo FASTA desde NCBI con `wget`

El NCBI ofrece acceso programático a sus bases de datos a través de su API **Entrez**. Con una URL bien construida puede descargar cualquier secuencia directamente.

27. **Descargue la secuencia del gen 16S rRNA de *Escherichia coli* K-12** directamente desde NCBI:
    ```bash
    wget -O data/ecoli_16S.fasta "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=NR_102804&rettype=fasta&retmode=text"
    ```
    - `-O data/ecoli_16S.fasta` indica el nombre y ubicación del archivo de salida.
    - El parámetro `id=NR_102804` es el número de acceso al gen 16S rRNA de *E. coli* K-12 en NCBI.

28. **Verifique que el archivo se descargó correctamente:**
    ```bash
    head data/ecoli_16S.fasta
    grep -c ">" data/ecoli_16S.fasta
    ```
    ¿Reconoce el formato? ¿Cuántas secuencias contiene?

29. **Descargue una segunda secuencia para comparar** — 16S rRNA de *Bacillus subtilis*:
    ```bash
    wget -O data/bsubtilis_16S.fasta "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=NR_112116&rettype=fasta&retmode=text"
    ```

30. **Combine las dos secuencias descargadas en un solo archivo FASTA** (como lo haría antes de un análisis filogenético):
    ```bash
    cat data/ecoli_16S.fasta data/bsubtilis_16S.fasta > results/sequences/16S_comparison.fasta
    grep ">" results/sequences/16S_comparison.fasta
    ```

> 💡 **Sobre FTP:** Algunas bases de datos grandes como **NCBI FTP** o **Ensembl** distribuyen sus archivos a través del protocolo **FTP** (File Transfer Protocol). `wget` también soporta FTP con URLs que comienzan por `ftp://`. Por ejemplo, para descargar el genoma completo de *E. coli* K-12 desde NCBI FTP usaría:
> ```bash
> wget ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2/GCF_000005845.2_ASM584v2_genomic.fna.gz
> ```
> Los archivos de genomas suelen estar comprimidos (`.gz`). Para descomprimirlos use `gunzip archivo.fna.gz`. **No ejecute este comando en la práctica** ya que el archivo es grande (~4.6 MB), pero tenga esto en mente para sus proyectos reales.

---

### Parte 6: Organización final del proyecto

31. **Mueva los archivos generados** a los directorios correctos:
    ```bash
    mv results/reports/cepas_resistentes.txt results/reports/
    mv results/reports/sequence_ids.txt results/reports/
    mv results/reports/resumen_fasta.txt results/reports/
    ```

32. **Verifique la estructura final** de su área de trabajo:
    ```bash
    tree results/
    ```

33. **Genere un archivo README para sus resultados:**
    ```bash
    echo "# Resultados - Práctica Unix Terminal" > results/README.txt
    echo "Fecha: $(date)" >> results/README.txt
    echo "Archivos generados en esta práctica:" >> results/README.txt
    ls results/reports/ >> results/README.txt
    cat results/README.txt
    ```
    > 💡 `$(date)` es una sustitución de comando: ejecuta `date` y pega su resultado en la línea. Este es el mismo mecanismo que usamos con `$(grep -c ...)` en los scripts de Bash.

---

### ToDo: Retos adicionales

Estos retos integran varios comandos en un solo pipeline. Intente resolverlos sin ver la solución primero.

**Reto 1:** Del archivo `08_antibiogram.csv`, extraiga solo las filas correspondientes a *E. coli* y guárdelas en `results/reports/ecoli_antibiogram.txt`.

**Reto 2:** Del archivo `12_gene_annotations.tsv`, extraiga únicamente la columna `KO_ID` de los genes que **sí tienen anotación** (es decir, que no sean `NA`), elimine duplicados y cuente cuántas anotaciones únicas hay.

**Reto 3:** Del archivo `05_genome.gff3`, extraiga solo los genes en la **hebra negativa** (`-`) y guárdelos en `results/annotations/genes_hebra_negativa.txt`.

**Reto 4:** Cree un script Bash llamado `mi_resumen.sh` en la carpeta `results/` que al ejecutarse imprima en pantalla:
   - El número total de secuencias en `01_sequences.fasta`.
   - El número de cepas resistentes en `08_antibiogram.csv`.
   - El número de genes anotados (no NA) en `12_gene_annotations.tsv`.

   ```bash
   #!/bin/bash
   echo "=== Resumen del análisis ==="
   echo -n "Secuencias en 01_sequences.fasta: "
   # complete el comando aquí
   echo -n "Cepas resistentes: "
   # complete el comando aquí
   echo -n "Genes con anotación funcional: "
   # complete el comando aquí
   ```

---

### 📝 Preguntas de Reflexión (Post-Práctica)

**Sobre navegación y archivos**

1. **Rutas absolutas vs. relativas:** Durante la práctica usó rutas relativas como `data/01_sequences.fasta`. ¿En qué situación sería más seguro usar la ruta absoluta completa? Piense en un script que va a ejecutarse desde diferentes ubicaciones del sistema.

2. **El comando `grep -v`:** En el paso 21 usó `grep -v "NA"` para excluir líneas. ¿Cómo podría usar este mismo principio para filtrar secuencias de baja calidad de un archivo FASTA si sabe que todas las secuencias problemáticas tienen un patrón específico en su encabezado?

3. **Conteo de bases con `wc -c`:** ¿Por qué el resultado de `wc -c` sobre una secuencia FASTA no es exactamente igual al número de bases? ¿Qué otros caracteres estarían siendo contados?

**Sobre pipelines y reproducibilidad**

4. **El pipe como herramienta de análisis:** En el paso 26 encadenó `cut | grep | grep | sort | uniq`. Describa con sus propias palabras qué hace cada paso de ese pipeline, como si fuera un protocolo de laboratorio paso a paso.

5. **Reproducibilidad:** Si guardara todos los comandos de esta práctica en un script `.sh` y lo compartiera en GitHub, otro investigador podría reproducir exactamente sus resultados. ¿En qué se diferencia esto de enviarle a un colega el archivo de resultados directamente? ¿Cuál es más valioso científicamente y por qué?

6. **`grep` en microbiología clínica:** Imagine que tiene un archivo con los resultados de antibiogramas de 500 pacientes y necesita identificar urgentemente todos los casos con *Klebsiella pneumoniae* resistente a carbapenémicos. ¿Cómo construiría un comando o pipeline con `grep` para extraer esa información en segundos?

