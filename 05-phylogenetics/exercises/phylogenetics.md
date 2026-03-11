# 🧬 Práctica: Análisis de secuencias 16S rRNA y construcción de un árbol filogenético

Para realizar la siguiente práctica por favor use el software **MEGA X**, disponible de forma gratuita en el siguiente enlace oficial:  
<https://www.megasoftware.net/>  

El programa se puede instalar en sistemas operativos **Windows**, **macOS** o **Linux**. Si no lo tiene instalado previamente, descárguelo e instálelo antes de comenzar la práctica.  

## Introducción

El análisis del gen 16S rRNA es una de las herramientas más utilizadas en microbiología para estudiar la diversidad bacteriana y establecer relaciones evolutivas entre especies. Este gen se encuentra en todos los procariotas y contiene regiones altamente conservadas junto con otras más variables, lo que lo convierte en un marcador molecular ideal para la identificación y clasificación bacteriana.  

Al comparar secuencias de 16S rRNA entre diferentes microorganismos, es posible evaluar su grado de similitud y construir **árboles filogenéticos**, representaciones gráficas que muestran los niveles de parentesco y divergencia evolutiva. Entre los métodos más utilizados se encuentran:  

- **Neighbor-Joining (NJ)**: método basado en distancias genéticas, rápido y ampliamente usado.  
- **Máxima Verosimilitud (ML)**: método más robusto, basado en modelos de sustitución de nucleótidos, que proporciona estimaciones más precisas.  

En esta práctica trabajaremos con secuencias del gen **16S rRNA** de seis bacterias de importancia clínica y biotecnológica:  

- *Escherichia coli* (**2 secuencias distintas**)  
- *Salmonella enterica* serovar Typhi  
- *Klebsiella pneumoniae*  
- *Bacillus subtilis*  
- *Pseudomonas aeruginosa*  

Además, durante el proceso de su investigación, usted como investigador también recibió una **secuencia 16S rRNA de una bacteria desconocida**, cuya tinción de Gram resultó resultando se Gram negativa y que presenta morfología de bacilo. Para este ejercicio, agregaremos dicha secuencia al archivo FASTA junto con las demás y construiremos un árbol filogenético que nos permitirá evaluar si esta bacteria desconocida corresponde a alguno de los microorganismos previamente seleccionados.  

De esta manera, los estudiantes experimentarán el uso del análisis molecular para apoyar la **identificación bacteriana**, reforzando el papel del gen 16S rRNA como herramienta central en microbiología clínica y ambiental.  

## 🎯 Objetivo
- Descargar secuencias de genes 16S rRNA de bacterias seleccionadas desde **NCBI**.  
- Alinear las secuencias utilizando **MEGA**.  
- Construir un árbol filogenético para visualizar las relaciones evolutivas.  

## 🦠 Organismos a analizar
Trabajaremos con 7 secuencias correspondientes a 6 bacterias conocidas y una desconocida:  

- *Escherichia coli* (**2 secuencias**)  
- *Salmonella enterica* serovar Typhi  
- *Klebsiella pneumoniae*  
- *Bacillus subtilis*  
- *Pseudomonas aeruginosa*  

---

## 📦 Requisitos previos
- Computador con **Windows/Linux/macOS**.  
- Software [MEGA X](https://www.megasoftware.net/) instalado.  
- Conexión a internet para acceder a **NCBI Nucleotide**.  

---

## 🔬 Procedimiento

### 1. Descargar secuencias 16S rRNA
1. Ingresar a [NCBI Nucleotide](https://www.ncbi.nlm.nih.gov/nucleotide/).  
2. Buscar:  
   - `"16S rRNA Escherichia coli"`  
   - `"16S rRNA Salmonella enterica serovar typhi"`  
   - `"16S rRNA Klebsiella pneumoniae"`  
   - `"16S rRNA Bacillus subtilis"`  
   - `"16S rRNA Pseudomonas aeruginosa"`  
3. Seleccionar **dos secuencias diferentes de _E. coli_** (de distintas cepas).  
4. Descargar cada secuencia en formato **FASTA**.  
5. Guardar los archivos en una carpeta llamada `16S_sequences`.  

---

### 2. Preparar un archivo FASTA combinado
1. Abrir un editor de texto (Notepad, VS Code, etc.).  
2. Copiar y pegar todas las secuencias descargadas en un único archivo.  
3. Guardar el archivo como:  

```
16S_all.fasta
```
4. Ahora agregue al archivo fasta creado previamente la siguiente secuencia del microorganismo desconocido.

```
>16S ribosomal RNA gene, partial sequence, unknown bacterium
TGAACGCTGGCGGCAGGCCTAACACATGCAAGTCGAGCGGTAGCACAGAGAGCTTGCTCTCGGGTGACGA
GCGGCGGACGGGTGAGTAATGTCTGGGAAACTGCCTGATGGAGGGGGATAACTACTGGAAACGGTAGCTA
ATACCGCATAACGTCGCAAGACCAAAGTGGGGGACCTTCGGGCCTCATGCCATCAGATGTGCCCAGATGG
GATTAGCTAGTAGGTGGGGTAACGGCTCACCTAGGCGACGATCCCTAGCTGGTCTGAGAGGATGACCAGC
CACACTGGAACTGAGACACGGTCCAGACTCCTACGGGAGGCAGCAGTGGGGAATATTGCACAATGGGCGC
AAGCCTGATGCAGCCATGCCGCGTGTGTGAAGAAGGCCTTCGGGTTGTAAAGCACTTTCAGCGGGGAGGA
AGGCGATAAGGTTAATAACCTTGTCGATTGACGTTACCCGCAGAAGAAGCACCGGCTAACTCCGTGCCAG
CAGCCGCGGTAATACGGAGGGTGCAAGCGTTAATCGGAATTACTGGGCGTAAAGCGCACGCAGGCGGTCT
GTCAAGTCGGATGTGAAATCCCCGGGCTCAACCTGGGAACTGCATTCGAAACTGGCAGGCTAGAGTCTTG
TAGAGGGGGGTAGAATTCCAGGTGTAGCGGTGAAATGCGTAGAGATCTGGAGGAATACCGGTGGCGAAGG
CGGCCCCCTGGACAAAGACTGACGCTCAGGTGCGAAAGCGTGGGGAGCAAACAGGATTAGATACCCTGGT
AGTCCACGCCGTAAACGATGTCGATTTGGAGGTTGTGCCCTTGAGGCGTGGCTTCCGGAGCTAACGCGTT
AAATCGACCGCCTGGGGAGTACGGCCGCAAGGTTAAAACTCAAATGAATTGACGGGGGCCCGCACAAGCG
GTGGAGCATGTGGTTTAATTCGATGCAACGCGAAGAACCTTACCTGGTCTTGACATCCACAGAACTTAGC
AGAGATGCTTTGGTGCCTTCGGGAACTGTGAGACAGGTGCTGCATGGCTGTCGTCAGCTCGTGTTGTGAA
ATGTTGGGTTAAGTCCCGCAACGAGCGCAACCCTTATCCTTTGTTGCCAGCGGTTAGGCCGGGAACTCAA
AGGAGACTGCCAGTGATAAACTGGAGGAAGGTGGGGATGACGTCAAGTCATCATGGCCCTTACGACCAGG
GCTACACACGTGCTACAATGGCATATACAAAGAGAAGCGACCTCGCGAGAGCAAGCGGACCTCATAAAGT
ATGTCGTAGTCCGGATTGGAGTCTGCAACTCGACTCCATGAAGTCGGAATCGCTAGTAATCGTAGATCAG
AATGCTACGGTGAATACGTTCCCGGGCCTTGTACACACCGCCCGTCACACCATGGGAGTGGGTTGCAAAA
GAAGTAGGTAGCTTAACCTTCGGGAGGGCGCTTACCACTTTGTGATTCATGA
```

### 3. Identificación de la secuencia desconocida mediante BLAST (NCBI)

Durante la práctica hemos añadido una secuencia 16S rRNA **desconocida** (tinción Gram negativa, bacilo) al archivo `16S_all.fasta`. Antes de construir el árbol filogenético definitivo, identifique esta secuencia usando **BLASTn** en NCBI para evaluar a qué microorganismo se parece más.

#### 3.1 Preparación
1. Copie la secuencia en FASTA (incluyendo la línea de encabezado `>`).

#### 3.2 Ejecutar BLASTn en NCBI
1. Ir a: **https://blast.ncbi.nlm.nih.gov/Blast.cgi** → **Nucleotide BLAST (BLASTn)**.  
2. Pegue la secuencia en el recuadro *Enter Query Sequence* o use *Choose file* para subir `unknown_16S.fasta`.  
3. En **Database**, seleccionar preferentemente:  
   - **`16S ribosomal RNA sequences (Bacteria and Archaea)`** si está disponible, **o**  
   - **`nr/nt (nucleotide collection)`** si desea búsqueda más amplia.  
4. Ajustar parámetros recomendados:  
   - **Max target sequences:** 10–50 (para ver varias coincidencias).  
   - **Expect threshold (E-value):** 1e-5 (por defecto está bien).  
   - Mantener el resto como predeterminado.  
   - **Truco**: Seleccione la casilla abrir en una nueva ventana para no perder la página actual.
5. Ejecutar **BLAST** y esperar a que aparezcan los resultados.

#### 3.3 Interpretación de resultados
Revise la lista de hits alineados y registre para las mejores coincidencias (ordenadas por bit score / % identidad):

- **Accession / Organism** (nombre del organismo y acceso).  
- **% Identity** (porcentaje de identidades en la alineación).  
- **Query cover** (porcentaje de la secuencia consulta que está alineada).  
- **Alignment length** (número de nucleótidos alineados).  
- **E-value** y **Bit score**.  
- **Descripción del acceso (strain/cepa)** si está disponible.

Criterios prácticos para interpretación (reglas empíricas comunes en 16S):  
- **≥ 99% identidad** y **query cover alta (≥ 95%)** → Muy probable correspondencia a la **misma especie**.  
- **97–99% identidad** → Probable correspondencia a **misma especie o especie cercana**; revisar alineamiento completo y descripciones de cepas.  
- **< 97% identidad** → Probable correspondencia **solo a nivel de género** o posible organismo no descrito con exactitud por 16S; se requieren genes adicionales o genómica completa para identificación de especie.

> Nota: Estos umbrales son orientativos. La identificación definitiva puede requerir marcadores adicionales o análisis genómico.

#### 3.4 Acciones tras BLAST
1. Anote la **mejor coincidencia** (organismo, acceso, % identity, query cover). Incluya el enlace o accession (por ejemplo: `NR_XXXXX`) en su informe.  
2. Si la mejor coincidencia concuerda con una de las seis especies objetivo (por ejemplo *Klebsiella pneumoniae*), anote la **probable identificación** y la evidencia (valores arriba).  
3. Si la coincidencia es ambigua, considere:  
   - Ejecutar BLAST contra la base `nr/nt` adicionalmente.  
   - Comparar top-hits y sus alineamientos completos.  
   - Construir un árbol filogenético que incluya las secuencias top-hit (descargue la referencia desde NCBI) para confirmación visual.  

#### 3.5 Exportar y documentar resultados
- Descargar y guardar la página de resultados BLAST (opción **Download** → formatos disponibles) como `unknown_blast_results.html` o `unknown_blast.tsv`.  
- Registrar en la entrega: accession, nombre del mejor hit, % identity, query cover, E-value, y una breve conclusión (1–2 líneas) sobre la identificación probable.  
- Incorporar la identificación (por ejemplo, `unknown -> Klebsiella pneumoniae (accession XXXXX)`) como etiqueta adicional en el árbol filogenético final o en el informe.

#### 3.6 (Opcional) Re-evaluación filogenética
Si BLAST sugiere que la secuencia desconocida pertenece a una de las especies incluidas en el experimento (p. ej. *E. coli*), vamos a construir el árbol filogenético y observar la posición de la secuencia desconocida frente a las secuencias de referencia descargadas: ¿se agrupa con la especie sugerida por BLAST? Esto proporciona una verificación filogenética visual de la llamada taxonómica.


### 4. Alineamiento múltiple en MEGA
1. Abrir MEGA X.
2. Ir a: Align → Edit/Build Alignment.
3. Crear un nuevo archivo de alineamiento seleccionando DNA como tipo de datos.
4. Importar el archivo `16S_all.fasta`.
5. Verificar que todas las secuencias estén cargadas.
6. Realizar el alineamiento múltiple:
   - Menú: Alignment → Align by ClustalW o Align by MUSCLE.
8. Guardar el alineamiento como:

```
16S_alignment.meg
```

### 5. Construcción del árbol filogenético
1. Abrir el archivo de alineamiento en MEGA.
2. Ir a: Phylogeny → Construct/Test Maximum Likelihood Tree. 
   - Alternativa rápida: Neighbor-Joining Tree.
3. Seleccionar un modelo de sustitución (ejemplo: Tamura-Nei).
4. Activar la opción de Bootstrap (500 repeticiones) para evaluar soporte estadístico.
5. Generar el árbol.

### 6. Visualización y exportación
1. Explorar el árbol y verificar la agrupación:
	- _E. coli_ debe agruparse con _Salmonella typhi_ y _K. pneumoniae_ (Proteobacterias γ).
	- _Bacillus subtilis_ (Firmicutes) debe aparecer más distante.
	- _Pseudomonas aeruginosa_ (Proteobacteria γ) debe estar separada de _E. coli_.
2. Exportar el árbol en dos formatos:

```
tree.png     # Imagen del árbol
tree.nwk     # Archivo del árbol en formato Newick
```

## ❓ Preguntas para reflexionar
1. ¿Las secuencias de _E. coli_ se agruparon juntas como se esperaba?
2. ¿Qué tan diferentes son _E. coli_ y _Salmonella enterica serovar Typhi_ en el árbol?
3. ¿Por qué _Bacillus subtilis_ aparece en una rama más alejada?
4. ¿Qué representan los valores de bootstrap en el árbol?
5. ¿Qué aplicaciones prácticas tiene el análisis de 16S rRNA en microbiología clínica y ambiental?
6. ¿Cúal es el microorganismo desconocido?