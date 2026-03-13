# 📄 Práctica: Bases de datos de proteínas y biología estructural

Esta practica tiene como objetivo explorar las principales bases de datos de proteínas, tanto de secuencias como de estructuras, y comprender cómo se interrelacionan. A través de ejercicios prácticos, los estudiantes aprenderán a navegar y extraer información relevante para el estudio de proteínas.

## Introducción
Las proteínas son moléculas esenciales en todos los organismos vivos. Su estudio requiere tanto información de **secuencia** como de **estructura**. Para ello, se han desarrollado diversas bases de datos que centralizan y organizan la información experimental y computacional disponible.  

En esta práctica exploraremos recursos ampliamente utilizados en bioinformática: **UniProt, Pfam, InterPro, TMHMM y PDB**, comprendiendo cómo se complementan entre sí y cómo acceder a sus datos de forma aplicada.  

---

## Bases de datos de secuencias y anotaciones

### 1. UniProt
La **Universal Protein Resource (UniProt)** es la base de datos más completa de secuencias y anotaciones proteicas. Está compuesta por tres recursos principales:  

- **UniProtKB (KnowledgeBase):**  
  Contiene secuencias de proteínas y anotaciones.  
  - **Swiss-Prot:** es una base de datos de proteínas que fueron revisadas y anotadas manualmente por un curador/a experto/a. 
  - **TrEMBL:** es una recolección de proteínas anotadas automáticamente, sin revisión manual, que en su mayoría, aunque no de manera exclusiva, fueron obtenidas a partir de la traducción de secuencias nucleotídicas codificantes (CoDing Sequences, CDS) disponibles en GenBank.
  
> **Info, importante, recordemos que:**
> Una secuencia codificante (CDS) es una región de ADN o ARN cuya secuencia determina la secuencia de aminoácidos en una proteína. No se debe confundir con un marco abierto de lectura (Open Reading Frame, ORF) que es una región continua de codones de ADN que empiezan con un codón de inicio y termina con un codón stop. Todos los CDS son ORFs pero no todos los ORFs son CDS, por ejemplo, los ORFs incluye a los intrones.


- **UniRef (UniProt Reference Clusters):**  
  Es un conjunto de secuencias agrupadas para reducir redundancia en distintos niveles de identidad (100%, 90%, 50%). Son colecciones de secuencias de proteínas de UniProtKB (inluyendo isoformas) y de una selección de UniParc para obtener una cobertura completa del espacio de secuencia agrupadas (o clusterizadas), según un umbral de similitud de secuencia específico, por ejemplo

    * **UniRef100:** Contiene secuencias y sub-fragmentos de secuencia de cualquier organismo que son idénticos. Contiene todas las secuencias de UniProtKB y algunas secuencias seleccionadas de UniParc.

    * **UniRef90:** Se construye agrupando las secuencias de UniRef100 y sub-fragmentos de secuencia de más de 11 residuos. de manera que cada grupo está compuesto por secuencias que poseen por lo menos un 90% de identidad y 80% de superposición con la secuencia de mayor longitud del grupo (la secuencia seed).

    * **UniRef50:** Se construye agrupando las secuencias seed de UniRef90 que comparten un 50% de identidad y 80% de superposición con la secuencia de mayor longitud del grupo.

- **UniParc:**  
  Archivo que contiene todas las secuencias únicas de proteínas reportadas, sin anotación adicional.  

#### **Ejercicio 1 – Búsqueda en UniProt**

1. Ingrese a [UniProt](https://www.uniprot.org). En la parte superior de la página web hay una barra de búsqueda y distintos accesos directos:

   * **BLAST**, para realizar búsquedas por similitud en toda la base de datos UniProtKB.
   * **Align**, para realizar alineamientos de pares con el algoritmo Clustal Omega.
   * **Peptide search/ID mapping**, permite buscar una lista de identificadores de proteínas y obtener las entradas de UniProt individuales. También permite convertir los identificadores a sus equivalentes en bases de datos externas como GenBank, PDB, entre otras.

2. Como puede observar hay una barra de busqueda. Busque la proteína **Glicerol-3-fosfato deshidrogenasa de *S. cerevisiae***. Le pedirá que seleccione una forma de visualización, elija la opción **Table** y luego `View Results`.
3. Identifique:  
   - Acceso `Entry` UniProtKB (ejemplo: `P13035`). Este es un identificador único que no cambia con las actualizaciones. Similar al GenBank ID para secuencias de ADN.
   - ¿Por qué hay múltiples entradas para la misma proteína?
   - ¿Cuántas entradas hay en total?
   - ¿Cuántas son Swiss-Prot y cuántas TrEMBL? 
   - ¿Porque se diferencian entre anotación en Swiss-Prot y TrEMBL?
   - ¿Cuántas entradas para organismos diferentes a _S. cerevisiae_? ¿Por qué?
   - ¿Cuál es la longitud de la secuencia en _S. cerevisiae_?
4. Haga click en la entrada **P41911**. Explore las distintas secciones de la entrada:
   - ¿Cuál es el nombre recomendado de la proteína?
   - ¿Qué función molecular tiene?
   - ¿Dónde se localiza en la célula?
   - ¿Qué modificaciones post-traduccionales se conocen?
   - ¿Qué dominios y sitios funcionales se han anotado?
   - ¿Existen estructuras 3D disponibles? ¿Cuántas y cuáles son los métodos experimentales usados para obtenerlas?
   - ¿Cuántas isoformas están anotadas? Si las hay, ¿Cómo difieren de la secuencia canónica?

> **Info:** 
> - Una **isoforma** de una proteína o variante proteica, es una proteína que pertenece a un conjunto de proteínas muy similares que se originan a partir de un único gen o familia de genes y son el resultado de diferencias genéticas. Si bien la mayoría lleva a cabo las mismas o similares funciones biológicas, algunas isoformas tienen funciones específicas y únicas. Las isoformas pueden formarse por splicing alternativo, variaciones en el uso del promotor u otras modificaciones post-transcripcionales. 
> - Cada entrada UniProtKB/swiss-Prot contiene todas las secuencias curadas producto de un gen. 
> - Para cada entrada se elige una **secuencia canónica** (o representativa) que cumple con ciertos criterios de manera tal que permita la descripción de la mayoría de los dominios, motivos, modificaciones post-traduccionales que ocurren en las distintas variantes. Algunos de los criterios son: funcionalidad, expresión, conservación en secuencias ortólogas. Si la información es escasa, entonces se elige la secuencia más extensa.


### 2. InterPro
**InterPro** integra resultados de múltiples bases de datos (Pfam, SMART, PROSITE, TIGRFAMs, etc.) para una clasificación más robusta de dominios y familias proteicas.  

En particular **Pfam** es una base de datos de familias de proteínas. Cada familia se representa mediante:  
- Alineamientos múltiples de secuencias.  
- Modelos ocultos de Markov (HMM).  

> Info: 
> - Una familia de proteínas es un conjunto de proteínas que comparten una secuencia y/o estructura similar, lo que sugiere un origen evolutivo común. Las proteínas dentro de una familia suelen tener funciones biológicas similares o relacionadas. La identificación y clasificación de familias de proteínas es fundamental para comprender la función y evolución de las proteínas en los organismos vivos.
> - Un **Modelo Oculto de Markov (HMM)** es un modelo estadístico que representa sistemas que son procesos de Markov con estados ocultos. En bioinformática, los HMMs se utilizan para modelar secuencias biológicas, como proteínas o ADN, capturando patrones y variaciones en las secuencias. Son especialmente útiles para identificar dominios funcionales y familias de proteínas debido a su capacidad para manejar la variabilidad en las secuencias.

Pfam permite identificar **dominios conservados** en proteínas y predecir funciones. 

> **Info:** Un dominio es una región de una proteína que puede evolucionar, funcionar y existir de manera independiente de la proteína completa. Los dominios suelen ser responsables de una función específica o interacción, contribuyendo a la función general de la proteína. Asi, un **dominio conservado** es aquel que se encuentra en múltiples proteínas a lo largo de diferentes especies, indicando su importancia funcional y estructural.

**Ejercicio 2 – Clasificación en InterPro**  
1. Ingrese a [InterPro](https://www.ebi.ac.uk/interpro/).  
2. Busque la proteína **beta-galactosidasa**. Una proteina se puede buscar por su nombre, por su secuencia o por su identificador UniProt. En este caso busque por su nombre (`text`).
3. Se mostrarán los resultados para todas las bases de datos en **InterPro**, seleccione una de **Pfam**.
4. Explore las distintas secciones de la entrada:  
   - ¿Cuál es el nombre de la familia y el clan?  
   - ¿Qué función tiene? 
   - ¿Qúe es un TIM-barrel?
   - ¿Qué organismos la poseen?  
   - ¿Cuántas secuencias y estructuras están asociadas a esta familia?  
   - ¿Qué dominios y sitios funcionales se han anotado?

---

### 3. TMHMM
**TMHMM** es un programa basado en HMMs para predecir la topología de proteínas de membrana.  

**Ejercicio 3 – Predicción de transmembrana**  
1. Acceda a [TMHMM Server](https://services.healthtech.dtu.dk/services/DeepTMHMM-1.0/).  
2. Analice la proteína **bacteriorodopsina (`P02945`)**.  
3. Verifique el número de hélices transmembrana predichas.  
4. Compare con otra proteína soluble de *E. coli* (por ejemplo, beta-galactosidasa `P00722`). ¿Qué diferencias observa?

---

## Bases de datos de estructuras proteicas

### 4. Protein Data Bank (PDB)
A diferencia de las bases de datos anteriores, que se enfocan en secuencias y anotaciones, el **Protein Data Bank (PDB)** almacena datos experimentales de estructuras tridimensionales de proteínas. Es el repositorio central de estructuras tridimensionales de proteínas, ácidos nucleicos y complejos macromoleculares.  

> **Info:** 
> - La base de datos de proteínas (Protein Data Bank, PDB) almacena actualmente más de 150000 estructuras. Puedes acceder a ella aquí: http://www.rcsb.org/. Existe también una versión europea de esta base de datos (European Protein Data Bank, PDBe). Puedes acceder a ella desde aquí: https://www.ebi.ac.uk/pdbe/.
> - Las estructuras poseen un identificador de 4 caracteres alfanuméricos. Por ejemplo: 1GUX es el identificador, o PDB ID, de la proteína retinoblastoma unida a un péptido de la proteína E7 de Papillomavirus.

Cada entrada del PDB contiene:  
- Coordenadas atómicas en formato `.pdb`.  
- Información sobre el método experimental (difracción de rayos X, RMN, criomicroscopía).  
- Datos de calidad estructural.  

**Ejercicio 4 – Explorando el PDB**  
1. Ingrese a [PDB](https://www.rcsb.org).  
2. Busque la proteína del **operon lactosa** (ID: 1LBG).  
3. Explore las distintas secciones de la entrada:  
   - ¿Cuál es el nombre de la proteína?  
   - ¿Qué método experimental se utilizó para determinar la estructura?  
   - ¿Cuál es la resolución de la estructura?  
   - ¿Cuántas cadenas y ligandos tiene?  
   - ¿Qué dominios y sitios funcionales se han anotado?  
   - ¿Qué organismos poseen esta proteína?
   - ¿Cuando fue depositada la estructura?
4. Visualice la estructura 3D usando el visor interactivo.
5. Descargue el archivo PDB y ábralo en un software de visualización de archivos de texto (como Notepad++ o cualquier editor de texto plano). Examine el archivo y localice las siguientes secciones:

> Nota: ¿Qué es un archivo PDB? 
> 
> El formato **PDB (.pdb)** es el estándar utilizado por el *Protein Data Bank* para almacenar y compartir estructuras tridimensionales de biomoléculas. Cada archivo PDB contiene:
> 
> - **Encabezado (HEADER, TITLE, KEYWDS):** información general sobre la estructura, como el nombre de la proteína, fecha de depósito y palabras clave.  
> - **Información experimental (EXPDTA, RESOLUTION):** describe la técnica empleada (rayos X, RMN, criomicroscopía) y la resolución de la estructura.  
> - **Datos de referencia (AUTHOR, JRNL):** autores que depositaron la estructura y publicación asociada.  
> - **Coordenadas atómicas (ATOM, HETATM):**  
>   - Incluyen el número de átomo, nombre, residuo, cadena, número de residuo, coordenadas en 3D (x, y, z), ocupancia y factor de temperatura (B-factor).  
>   - Ejemplo de línea:  
>    ```
>    ATOM   1129  CA  GLY A 145      24.447  18.322  10.365  1.00 33.45
>    ```
>    - **1129:** número del átomo.  
>    - **CA:** tipo de átomo (carbono alfa).  
>    - **GLY:** residuo (glicina).  
>    - **A:** cadena proteica.  
>    - **145:** número de residuo.  
>    - **24.447  18.322  10.365:** coordenadas espaciales.  
>    - **1.00:** ocupancia.  
>    - **33.45:** B-factor (movilidad atómica).  
>
>    ```
>    HELIX    1  A1 LEU A    6  TYR A   12  1                                   7
>    ```
>    - `HELIX`: palabra clave para una hélice α.
>    - `1`: número secuencial de la hélice.  
>    - `A1`: identificador interno de la hélice.  
>    - `LEU A 6`: aminoácido inicial (Leucina, cadena A, residuo 6).  
>    - `TYR A 12`: aminoácido final (Tirosina, cadena A, residuo 12).  
>    - `1`: tipo de hélice (1 = α-hélice estándar).  
>    - `7`: longitud de la hélice en residuos.
>    
>    ```
>    SHEET    1 S1A 6 ALA A  92  MET A  98  0
>    ```
>    - `SHEET`: palabra clave.  
>    - `1`: número de la hoja (sheet).  
>    - `S1A`: identificador de la hebra dentro de la hoja.  
>    - `6`: número de hebras en la hoja (en este caso 6).  
>    - `ALA A 92`: residuo inicial (Alanina, cadena A, residuo 92).  
>    - `MET A 98`: residuo final (Metionina, cadena A, residuo 98).  
>    - `0`: relación con otras hebras (0 indica que no hay alineamiento especificado con otra hebra).  
>
> - **Conectividad (CONECT):** describe enlaces entre átomos, útil para ligandos o moléculas pequeñas.  
> - **Información de ligandos y moléculas de agua (HETATM, HET):** indican compuestos distintos de la proteína principal.  
> - **Secuencia de la proteína (SEQRES):** lista de residuos en cada cadena.  

En resumen, un archivo PDB no solo contiene la geometría tridimensional de la proteína, sino también **metadatos** sobre cómo se obtuvo la estructura, qué moléculas la componen y qué tan confiables son los datos.

## Preguntas de reflexión
1. ¿Cuál es la principal diferencia entre UniProt y PDB?  
2. ¿Cómo se complementan Pfam e InterPro en la anotación de proteínas?  
3. ¿Qué ventajas y limitaciones presentan las predicciones computacionales (como TMHMM) frente a los datos experimentales (PDB)?  
4. ¿Por qué es importante integrar información de secuencia y estructura en biología molecular?