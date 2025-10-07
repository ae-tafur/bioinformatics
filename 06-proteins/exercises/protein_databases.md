# Proteinas

En esta sección trabajaremos y analizaremos proteinas, para ello dividiremos esta sección en cinco componentes:

1. Bases de Datos

## Bases de Datos

Existe un gran número de bases de datos donde se puede encontrar información, algunas de ellas especializadas o curadas. En esta sección explicaremos 4 de las usadas y con mayor volumen de datos.

1. UniProt: [https://www.uniprot.org/](https://www.uniprot.org/)
2. Pfam: [https://Pfam.xfam.org/](https://Pfam.xfam.org/) [Legacy Version]
3. TMHMM: [https://services.healthtech.dtu.dk/service.php?TMHMM-2.0](https://services.healthtech.dtu.dk/service.php?TMHMM-2.0)
4. InterPro: [https://www.ebi.ac.uk/interpro/](https://www.ebi.ac.uk/interpro/)

### 1. UniProt
UniProt es la colección más abarcativa y actualizada de secuencias de proteínas, las cuales se encuentran anotadas a múltiples niveles. Esta base de datos debería ser el primer paso para cualquier investigador/a que esté buscando la información disponible para una proteína, ya que es tan abarcativa que evita el esfuerzo de integrar los datos de múltiples fuentes.

### UniProtKb. The UniProt KnowledgeBase.
La mayor base de datos de Uniprot es UniProtKB (UniProt **K**nowledge**B**ase) que está dividida en dos secciones: TrEMBL y Swiss-Prot.

* **TrEMBL** es una recolección de proteínas anotadas automáticamente que en su mayoría, aunque no de manera exclusiva, fueron obtenidas a partir de la traducción de secuencias nucleotídicas codificantes (CoDing Sequences, CDS) disponibles en GenBank.

!!! Importante, recordemos que:

    Una *secuencia codificante (CDS)* es una región de ADN o ARN cuya secuencia determina la secuencia de aminoácidos en una proteína. No se debe confundir con un marco abierto de lectura (Open Reading Frame, ORF) que es una región continua de codones de ADN que empiezan con un codón de inicio y termina con un codón stop. Todos los CDS son ORFs pero no todos los ORFs son CDS, por ejemplo, los ORFs incluye a los intrones.


* **Swiss-Prot** es una base de datos de proteínas que fueron revisadas y anotadas manualmente por un curador/a experto/a.

Por lo tanto, Swiss-Prot contiene la información de más alta calidad para secuencias de proteínas.

TrEMBL brinda los datos crudos para que los curadores de Swiss-Prot los revisen. Por lo tanto, TrEMBL tiene más entradas que Swiss-Prot, pero carece de la anotación manual de un experto.

#### UniParc y UniRef
Dentro de UniProt también se encuentra UniParc (the UniProt Archive), una base de datos no-redundante de casi todas las secuencias proteicas disponibles en el mundo. Actualmente, UniParc contiene las secuencias de proteínas de más de 20 bases de datos públicas, como ser:

* EMBL-Bank/DDBJ/GenBank nucleotide sequence databases

* Ensembl

* EnsemblGenomes

* Protein Data Bank (PDB)

* RefSeq

* Saccharomyces Genome database (SGD)

* TAIR Arabidopsis thaliana Information Resource

* UniProtKB/Swiss-Prot, UniProtKB/Swiss-Prot protein isoforms, UniProtKB/TrEMBL

UniRef (the UniProt Reference Clusters) son colecciones de secuencias de proteínas de UniProtKB (inluyendo isoformas) y de una selección de UniParc para obtener una cobertura completa del espacio de secuencia agrupadas (o clusterizadas), según un umbral de similitud de secuencia específico, por ejemplo

* **UniRef100:** Contiene secuencias y sub-fragmentos de secuencia de cualquier organismo que son idénticos. Contiene todas las secuencias de UniProtKB y algunas secuencias seleccionadas de UniParc.

* **UniRef90:** Se construye agrupando las secuencias de UniRef100 y sub-fragmentos de secuencia de más de 11 residuos. de manera que cada grupo está compuesto por secuencias que poseen por lo menos un 90% de identidad y 80% de superposición con la secuencia de mayor longitud del grupo (la secuencia seed).

* **UniRef50:** Se construye agrupando las secuencias seed de UniRef90 que comparten un 50% de identidad y 80% de superposición con la secuencia de mayor longitud del grupo.

El identificador de las secuencias se construye como: UniRef100_P99999, o UniRef90_P99999, o UniRef50_P99999.


### Página web de UniProt

El sitio web de UniProt permite navegar los distintos conjuntos de datos desde el homepage, herramientas de análisis y a través de los links al pie de la página (Figura 1).

En la parte superior de la página web hay una barra de búsqueda y distintos accesos directos:

* **BLAST**, para realizar búsquedas por similitud en toda la base de datos UniProtKB.

* **Align**, para realizar alineamientos de pares con el algoritmo Clustal Omega.

* **Peptide search/ID mapping**, permite buscar una lista de identificadores de proteínas y obtener las entradas de UniProt individuales. También permite convertir los identificadores a sus equivalentes en bases de datos externas como GenBank, PDB, entre otras.

### Realizando búsquedas en UniProt

Las búsquedas pueden realizarse en la barra de búsqueda en la parte superior de la página. Contiene un menú desplegable que permite seleccionar la base de datos y la opción de búsqueda avanzada (Advanced) que permite refinar la búsqueda.

!!! Info
    UniProt es actualizada constantemente. Los últimos conjuntos de datos pueden recolectarse en la sección *UniProt data* en el homepage en el link: *Download latest release*.

    ¿Puedes encontrar en qué fecha se realizó el release actual?

La búsqueda en UniProtKB conduce a una página de resultados donde se muestra en formato tabla determinada información de las secuencias obtenidas como resultado de la búsqueda. Los distintos campos de la tabla pueden editarse utilizando el botón *Customize columns*, cuyo ícono es un lápiz en la parte superior.

Los resultados obtenidos además pueden filtrarse por la base de datos, el organismo, utilizando las opciones en *Filter* by a la izquierda de la página. También hay una sección *View* by que permite agrupar los resultados por taxonomía, pathway u otros criterios.

Una vez que se selecciona una entrada haciendo click en el identificador, se abre la página correspondiente a dicha entrada.

Por debajo del nombre de la *Entry*, se muestra una barra con pestañas que permiten cambiar entre la información de la *Entry*, publicaciones, links a sitios externos y el *Feature viewer*.

La visualización *Feature viewer* es una alternativa muy útil que permite visualizar todas las anotaciones a lo largo de la secuencia de la proteína.

A la izquierda, se muestra una barra de navegación que lista todas las secciones con información para la proteína seleccionada.

### Entradas Uniprot
Cada entrada en UniProt posee dos identificadores únicos.

* El **Accession number** es una secuencia de 6 a 10 caracteres alfanuméricos (ej. P04637) que se mantiene a lo largo de las actualizaciones y que debería ser usada en todas las publicaciones.

* El **Entry name** es un identificador más fácil de leer que en general se selecciona de manera tal que refleje las propiedades biológicas, como el nombre de la proteína o el organismo (ej. P53_HUMAN). Este identificador puede llegar a cambiar si se obtuviera nueva información sobre la entrada o secuencias relacionadas.

Una entrada de UniProt puede poseer datos experimentales y predichos. Los datos anotados manualmente, tomados de experimentos publicados, transferidos de experimentos en proteínas similares o importados desde otras bases de datos están indicados con un listón amarillo/dorado en la etiqueta. Los datos que son generados por anotación automática están anotados como *Automatic Annotation*.

Las entradas de UniProt están ranqueadas por un sistema de 5 puntos (*Annotation score*). El puntaje de cada entrada se calcula en base al número y puntaje de sus anotaciones. Una anotación con evidencia experimental tiene mayor puntaje que una anotación equivalente predicha o inferida. Un mayor número de puntaje refleja una entrada con más anotaciones; sin embargo, este sistema no refleja la correctitud de las anotaciones.

## Uniprot - Ejercicios

### Ejercicio 1. Proteína GPD2
1. Busca en UniProt la proteína *GPD2*.
2. ¿Cuál es el nombre de la proteína? ¿Cuál es su longitud en **_S. cerevisiae_**?
3. ¿Cuántas entradas existen en organismos populares y cuántas en humanos?
4. Encuentra la proteína `Q9FY99` entre los resultados. ¿Por qué te parece que está entre los resultados? 
5. ¿Cuántas de las entradas corresponden a entradas anotadas manualmente (Swiss-Prot) y cuántas no (TrEmBl)? 
6. ¿Cuál es el nombre de la entrada? 
7. ¿A qué base de datos de UniProtKB pertenece? 
8. ¿Cuáles son algunas de las funciones moleculares y actividades biológicas asociadas con esta proteína? 
9. ¿Dónde se localiza esta proteína?¿De donde se obtuvo esta información? 
10. ¿Donde se sabe que interactúa? 
11. ¿Existe alguna estructura conocida para esta proteína? Si las hay, ¿Son estructuras obtenidas experimentalmente o predichas? ¿abarcan toda la secuencia? 
12. ¿Cuántas isoformas están anotadas para esta proteína? Si las hay, ¿Cómo difieren de la secuencia canónica?

    !!! info

        Una **isoforma** de una proteína o variante proteica, es una proteína que pertenece a un conjunto de proteínas muy similares que se originan a partir de un único gen o familia de genes y son el resultado de diferencias genéticas. Si bien la mayoría lleva a cabo las mismas o similares funciones biológicas, algunas isoformas tienen funciones específicas y únicas. Las isoformas pueden formarse por splicing alternativo, variaciones en el uso del promotor u otras modificaciones post-transcripcionales.
        
        Cada entrada UniProtKB/swiss-Prot contiene todas las secuencias curadas producto de un gen.
        
        Para cada entrada se elige una **secuencia canónica** (o representativa) que cumple con ciertos criterios de manera que permita la descripción de la mayoría de los dominios, motivos, modificaciones post-traduccionales que ocurren en las distintas variantes. Algunos de los criterios son: funcionalidad, expresión, conservación en secuencias ortólogas. Si la información es escasa, entonces se elige la secuencia más extensa.


13. ¿Puedes encontrar la fecha de creación de esta entrada y cuál es la fecha de su última modificación? ¿Cuántas veces fue modificada? ¿Cuándo fue incorporada a SwissProt?

   ??? idea "Pista"

       Explora la pestaña *History*

## Pfam

Pfam es un recurso muy útil para identificar regiones funcionales conservadas en proteínas. Permite encontrar regiones de similitud entre una secuencia *query* y una base de datos de familias de proteínas anotadas con el objetivo de incrementar el conocimiento de la arquitectura, función y relaciones de la proteína de interés (la secuencia *query*).

Una entrada Pfam se construye a partir de un alineamiento de secuencia múltiple de un conjunto de secuencias curadas que se sabe que pertenecen a una familia. Este es conocido como el alineamiento **semilla** (*seed*) y es utilizado para entrenar un *profile Hidden Markov Model* (o perfil de HMM) que brinda una representación extendida de la familia contemplando inserciones y deleciones. Este modelo probabilístico refleja la variabilidad de secuencia en cada posición de la familia y es utilizado para una búsqueda exhaustiva en una base de datos (como UniProtKB) de todas las secuencias homólogas. Las secuencias recolectadas que muestran una similitud significativa con el perfil de HMM son alineadas a este modelo obteniendo como resultado un alineamiento más completo de la familia.

!!! question "Pregunta"

    Antes de seguir leyendo, piense y discuta, ¿Cuál es la definición de un Dominio?       


Si bien algunas regiones en Pfam se llaman comúnmente Dominios, las entradas de Pfam no representan necesariamente una región de secuencia que se pliega en una estructura terciaria discreta, sino más bien, representan unidades conservadas evolutivamente.

Una **Familia (Family)** Pfam representa un conjunto de secuencias relacionadas por un HMM. Las familias grandes y divergentes pueden compartir una gran similitud de secuencia, estructura o función con los miembros de otras familias. Dada la dificultad de representar estas **superfamilias** por un único alineamiento o perfil HMM, Pfam provee un nivel superior de agrupamiento de las familias relacionadas evolutivamente en **Clanes (clans)**.

Cada residuo de cada secuencia dada sólo puede pertenecer a una familia Pfam.

Los perfiles de HMM son construidos con el paquete HMMER3 (disponible en [http://hmmer.org](http://hmmer.org)). Al igual que BLAST, HMMER3 utiliza e-values. El e-value devuelto por Pfam refleja la significancia del hit.

!!! Info

    **e-value (expectation values):** El e-value es el número de *hits* que uno espera que tengan una puntuación igual o mejor que ese valor por azar solo. Un buen e-value es mucho menor a 1. Un valor de 1 es lo que uno esperaría por azar. Los e-values dependen del tamaño de la base de datos donde se realiza la búsqueda.

Pfam utiliza un segundo sistema de puntuación (*bit score*) para el mantenimiento de los modelos que es independiente del tamaño de la base de datos donde se realiza la búsqueda.

!!! Info

    **Bit-score:**

    * Un *bit-score* de 0 significa que el likelihood del *hit* encontrado por el modelo es igual al likelihood por azar.
    * Un *bit-score* de 1 significa que el likelihood del hit es el doble que el likelihood por azar.
    * Un *bit-score* de 2 significa que el likelihood del hit es el cuádruple que el likelihood por azar.
    * Un *bit-score* de 20 significa que el likelihood del hit es 2^20^ veces el likelihood por azar.


Cuando una familia proteica es construida, se establece un umbral en el bit-score para la recolección (bit score gathering, GA) de manera manual para cada familia. Este puntaje (GA) determina el menor puntaje que una secuencia debe obtener en la búsqueda con el perfil de HMM para ser incluida en el alineamiento completo.

Tanto los alineamientos semilla, como los alineamientos completos y el perfil de HMM están disponibles en Pfam para su descarga.

En el año 2022, la base de datos Pfam fue incorporada a la base de datos InterPro. La base de datos original de Pfam puede todavía accederse parcialmente en la versión Legacy: [https://Pfam.xfam.org/](https://Pfam.xfam.org/). Pero los datos desde este servidor ya no tendrán actualizaciones y la mayoría de las cosas redirigen a InterPro.

En InterPro, [https://www.ebi.ac.uk/interpro/](https://www.ebi.ac.uk/interpro/), se pueden realizar muchas de las búsquedas que se realizaban en la página original de Pfam.

## InterPro
La base de datos InterPro es un compendio de bases de datos que incluye a Pfam entre otras bases de datos para la clasificación de proteínas. InterPro también predice **características funcionales** distintivas o **functional  signatures** de las proteínas por asignación a familias, reconocimiento de dominios y otros sitios relevantes. Sin embargo, InterPro es una meta-base de datos, ya que unifica las características de las proteínas tomando la información a partir de múltiples bases de datos independientes en un recurso único para una clasificación integradora de la secuencia.

En InterPro, una **protein signature** es un modelo computacional que refleja el patrón de conservación de aminoácidos sitio-específico en un alineamiento. Puede tener la forma de un patrón de secuencia, un perfil que describe un motivo de secuencia determinado o un sofisticado perfil de HMM, que contempla las inserciones y deleciones en las familias de proteínas. Los modelos iniciales se usan para búsquedas iterativas en distintas bases de datos como UniProtKB para recolectar homólogos remotos y aumentar el número de secuencias distantes que representa el modelo. La **protein signature** final es un modelo predictivo muy descriptivo que puede ser utilizado para el análisis de secuencias.

Dentro de las muchas bases de datos que usa InterPro están:

* Pfam.
* SMART: base de datos de arquitecturas de dominios de proteínas.
* Superfamily: una base de datos basada en perfiles de HMM de anotaciones funcionales y estructurales en proteínas.
* CATH/Gene3D: una base de datos de superfamilias de dominios con una estructura conocida y su predicción en genomas completos.
* MobiDB: un recurso central para la anotación de desorden intrínseco en secuencias UniProt.

Dado que las distintas bases de datos probablemente posean información redundante, un equipo de curadores de InterPro chequean manualmente y fusionan las *signatures* que se refieren a la misma familia, dominio o sitio en una entrada única de InterPro. Por lo tanto, cada **protein signature** posee un único código de acceso InterPro junto al código correspondiente de las bases de datos individuales.

Lo más importante de InterPro es la integración de múltiples fuentes de información, cada una con sus fortalezas y no en la cantidad de información que se extrae de ellas. Esto convierte a InterPro en una fuerte herramienta de diagnóstico. Sin embargo, una vez que se encuentran las *signatures* de interés, en general se aconseja ir a las bases de datos correspondientes para mayor información.

Una entrada InterPro puede ser de distintos tipos:

* Un Dominio (**domain**) en InterPro son unidades discretas con secuencia, estructura o función distintiva que se puede encontrar en diferentes contextos biológicos.

* Los miembros de una familia (**family**) de proteínas, además de compartir un origen evolutivo común, poseen secuencias, estructura sy/o funciones similares.
* Las entradas de una superfamilia de homólogos (**homologous superfamily**) abarca proteínas con un ancestro común que normalmente poseen baja conservación de secuencia pero una similitud estructural notable.
* Las repeticiones (**repeats**), identifican secuencias cortas que se encuentran múltiples veces dentro de una proteína.
* Un sitio (**site**), es una secuencia corta, pero con uno o más residuos conservados que poseen una función definida.
    * Sitio activo (**active site**), es una secuencia corta que contiene uno o más residuos conservados que permiten que la proteína se una a un ligando y lleve a cabo una actividad catalítica.
    * Sitio de unión (**binding site**), es una secuencia corta que contiene uno o más residuos conservados que forman un sitio de interacción de la proteína.
    * Sitios de modificación post-traduccionales (**PTMs, Post-translational modification sites**), una secuencia corta que contiene uno o más residuos conservados que son modificados post-traduccionalmente.
    * Sitio conservado (**conserved site**), una secuencia corta que posee uno o más residuos conservados.
* Los **unintegrated** son *signatures* de bases de datos que no están integradas en InterPro. Estas *signatures* pueden no haber sido curadas aún o no cumplir con los estándares de InterPro para su integración. Sin embargo, pueden brindar información importante de una proteína de interés.

### Realizando búsquedas relacionadas a Pfam en InterPro

Para realizar una búsqueda se puede utilizar el código de acceso de InterPro, que está formado por IPR más un número, o un identificador de UniProtKB o un identificador de cualquier otra base de datos miembro de InterPro. Así como también se puede utilizar la secuencia de la proteína, o keywords relacionadas con la función o actividad de una proteína.

En esta sección nos vamos a enfocar principalmente en los datos relacionados a Pfam. Los identificadores Pfam tienen la forma `PF99999`.

## Pfam - Ejercicios

### Ejercicio 1. Entendiendo Pfam usando la entrada PF07479

Busque en InterPro la entrada Pfam utilizando el identificador de Pfam: `PF07479`.

1. ¿Pertenece a una proteína, un dominio, una familia o un clan?
2. En la página principal de la entrada, ¿puedes encontrar el nombre de tres proteínas que poseen este dominio?
3. En el menú de la izquierda ¿Cuántas secuencias están conectadas con esta entrada?
4. En el menú de la izquierda, *Domain Architectures* lista las arquitecturas de dominios (arreglos específicos de ciertos dominios) donde se encuentra esta familia. ¿cuántas arquitecturas de dominio existen?
5. ¿Cuántas proteínas poseen la arquitectura Acyltransferase? ¿Cual es la proteína representante? ¿A qué organismo pertenece?

## TMHMM
TMHMM es un servidor dedicado a la predicción de hélices transmembranas en proteínas. Si bien se desarrolló hace ya dos décadas, es constantemente actualizado y aún es una buena referencia.

El programa está basado en el desarrollo de un Hidden Markov Model que sirve como una herramienta predictiva.

A partir de la secuencia, TMHMM devuelve un conjunto de estadísticas y una lista de las hélices transmembranas predichas. Esta lista mapea el inicio y fin de cada hélice predicha y loop. También devuelve la ubicación de estos loops, ya sea en el interior o exterior de la célula. Por lo tanto, se puede trazar el camino de la proteína de un lado a otro de la membrana.

Un plot de probabilidades posteriores permite la identificación de los segmentos transmembrana que se encuentran en el modelo final y otros segmentos predichos débilmente que no fueron considerados. El HMM calcula la probabilidad total de que un residuo sea parte de una hélice, un loop interno o externo y luego combina estas evaluaciones en el modelo final.


## TMHMM - Ejercicios

### Ejercicio 1. Bacteriorodopsina.
La interfaz de [TMHMM Server 2.0](https://services.healthtech.dtu.dk/services/TMHMM-2.0/) es simple. Se usa la caja de búsqueda en la página principal para correr la predicción a partir de una secuencia.
1. Ingrese la secuencia de la proteína bacteriorodopsina que se encuentra a continuación para realizar la búsqueda en TMHMM. Use el formato de salida por defecto (‘Extensive, with graphics’) para obtener resultados más descriptivos.


    >sp|P02945|BACR_HALSA Bacteriorhodopsin OS=Halobacterium salinarum
    MLELLPTAVEGVSQAQITGRPEWIWLALGTALMGLGTLYFLVKGMGVSDPDAKKFYAITT
    LVPAIAFTMYLSMLLGYGLTMVPFGGEQNPIYWARYADWLFTTPLLLLDLALLVDADQGT
    ILALVGADGIMIGTGLVGALTKVYSYRFVWWAISTAAMLYILYVLFFGFTSKAESMRPEV
    ASTFKVLRNVTVVLWSAYPVVWLIGSEGAGIVPLNIETLLFMVLDVSAKVGFGLILLRSR
    AIFGEAEAPEPSAGDGAAATSD


2. Inspeccione los resultados de la búsqueda. ¿Cuántas hélices transmembrana encontró?
3. Entre los estadísticos encontrará *Exp number of AAs in TMHs*. Este es el número esperado de aminoácidos en hélices transmembrana según este HMM como método de predicción. Cuando este número es mayor que 18, la proteína es probablemente una proteína transmembrana. ¿Es la bacteriorodopsina una proteína transmembrana?
4. Otro estadístico es *Exp number, first 60 AAs*. Este valor es el mismo que el anterior pero limitado a los primeros 60 aminoácidos. Si este estadístico no posee un valor bajo, es decir de unos pocos residuos, entonces puede llegar a ocurrir que una hélice transmembrana predicha en la región N-terminal sea en realidad un péptido señal.

    Se pueden utilizar otras herramientas dedicadas a la predicción de péptidos señal, como [SignalP](https://services.healthtech.dtu.dk/service.php?SignalP-5.0). sabiendo que Halobacterium es una Archea, ¿SignalP predice el N-terminal como un péptido señal?

5. En el gráfico, los bloques rojos corresponden a hélices transmembrana, las líneas azules indican regiones en el interior y los segmentos violetas corresponden a regiones en el exterior. Observando el gráfico, ¿puede haber otra hélice transmembrana que el modelo esté descartando?
6. ¿Cuántos pasos transmembrana tienen las Rodopsinas? En base a las herramientas aprendidas en este trabajo práctico ¿Se le ocurre donde puede encontrar esta información? (Pista: Tiene el Accession number de esta proteína!).

## Modelación por Homologia y predicción de estructura 3D

Si bien ya hablamos de datos, es necesario mencionar que existen bases de datos estructurales, es decir, donde se alojan la estructura 3D de las proteinas. En ellas trabajaremos en esta sección inicialmente dado el enfoque de este submodulo.

### Bases de Datos Estructurales.

¿Dónde se almacenan todas las estructuras? ¿Cómo accedemos a ellas?

La base de datos de proteínas (Protein Data Bank, PDB) almacena actualmente más de 150000 estructuras. Puedes acceder a ella aquí: [http://www.rcsb.org/](http://www.rcsb.org/). Existe también una versión europea de esta base de datos (European Protein Data Bank, PDBe). Puedes acceder a ella desde aquí: [https://www.ebi.ac.uk/pdbe/](https://www.ebi.ac.uk/pdbe/).

Las estructuras poseen un identificador de 4 caracteres alfanuméricos. Por ejemplo: 1GUX es el identificador, o PDB ID, de la proteína retinoblastoma unida a un péptido de la proteína E7 de Papillomavirus.

La búsqueda de estructuras puede realizarse utilizando palabras claves, por ejemplo, la palabra clave **retinoblastoma** devuelve un total de 236 estructuras, o por otras características como nombre de alguno de los autores que participó en el estudio de esa estructura, por ejemplo, “Rubin, S.M.” devuelve un total de 41 estructuras. Pueden explorar la base de datos RCSB PDB para familiarizarse con ella.

El repositorio PDB es mantenido por tres sitios independientes:

* [RCSB](http://www.rcsb.org) PDB en estados unidos.
* [PDBe](http://www.ebi.ac.uk/pdbe) en Europa.
* [PDBj](https://pdbj.org/) en Japón.

Si bien los datos principales y recursos son compartidos, cada sitio provee un conjunto exclusivo de servicios para que los usuarios puedan inspeccionar los datos.

### El archivo PDB. ¿Cómo están codificadas las estructuras?

Las estructuras tridimensionales de las proteínas pueden generarse por diferentes métodos (cristalografía de rayos X o X-Ray, resonancia magnética nuclear o RMN, criomicroscopía electrónica o CryoEM) y están codificadas en archivos pdb. Un archivo pdb está compuesto por múltiples líneas de registros, cada uno identificado por una etiqueta determinada incluidos dentro de distintas secciones. En la Figura 1 se muestra un fragmento de la sección de coordenadas que describe la estructura de la proteína dando las coordenadas “x”, “y” y “z” (azul claro) de cada uno de los átomos identificados.

<img src="/Users/ae.tafur/Documents/Training/bioinformatics/06-proteins/exercises/img/archivo_pdb_fig1.png"/>
Figura 1. Archivo PDB.

En cada línea, además, se identifica si es un átomo (rojo) perteneciente a un aminoácido o nucleótido, o heteroátomo (azul oscuro), la numeración (verde oscuro), el nombre del átomo (naranja), el nombre del residuo en el que está incluido el átomo (violeta), la cadena a la que pertenece (negro), el número del residuo al que pertenece (verde claro). Este archivo puede incluir más columnas para cada átomo con datos relacionados con la movilidad del átomo (el factor de temperatura o B-factor), el sı́mbolo que representa al átomo y la carga del mismo (señaladas con “...” en la figura). El encabezado o header del archivo PDB puede tener muchísima información no relacionada directamente con la conformación tridimensional de la proteína, sino con cómo se hizo el experimento, las publicaciones relacionadas y otros. La descripción del resto del contenido de las secciones del archivo pdb puede obtenerse en la sección documentación de [http://www.wwpdb.org/](http://www.wwpdb.org/). Recientemente, se desarrolló un nuevo formato de archivo, MMCIF, que puede codificar estructuras de complejos macromoleculares mucho más grandes. Sin embargo, no todos los programas utilizados para visualizar estructuras soportan este formato.

### ¿Qué significa la resolución de una estructura?
Otra característica de las estructuras es la resolución con la cuál se obtuvieron. Hay una muy buena explicación en [pdb-101](https://pdb101.rcsb.org/learn/guide-to-understanding-pdb-data/resolution) que traigo aquí.

La resolución es una medida de la calidad de los datos que se recolectaron del cristal. Si el cristal es perfecto, es decir que todas las proteínas están estructuralmente alineadas de manera idéntica, entonces el patrón de difracción generado mostrará detalles muy finos. Por otro lado, si las proteínas en el cristal no alinean estructuralmente debido a movimientos o flexibilidad local, el patrón de difracción no brindará mucha información. Estructuras de alta resolución, con valores de 1 Å o similar, están altamente ordenadas y es fácil ver cada átomo en un mapa de densidad electrónica. Estructuras de baja resolución, con valores de 3 Å o mayores, muestran los contornos de la cadena proteica y la estructura atómica debe inferirse. En general, la localización de los átomos en estructuras que tienen un valor de resolución pequeño es de mayor confianza.

<img src="/Users/ae.tafur/Documents/Training/bioinformatics/06-proteins/exercises/img/resolucion_fig2.png"/>
Figura 2. Resolución en una estructura

En la Figura 2 se muestra el mapa de densidad electrónica de distintas estructuras (las regiones de alta densidad electrónica se muestran en azul y amarillo) dentro de un rango de resoluciones.

Las tres primeras muestran la tirosina 103 de la mioglobina (con palitos verdes se muestra el *modelo atómico*), los pdbs correspondientes son 1a6m (resolución de 1.0 Å), 106m (resolución de 2.0 Å) y 108m (resolución de 2.7 Å). El último ejemplo muestra la tirosina 130 de la cadena B de la hemoglobina del pdb 1s0h (resolución de 3.0 Å).

En la estructura de resolución de 1.0 Å se pueden ver la alta densidad electrónica en cada uno de los carbonos del anillo de la tirosina. A medida que aumenta ese valor, la densidad electrónica se va reduciendo (disminuye el contorno amarillo).
Si bien los archivos PDB pueden inspeccionarse con un editor de texto cualquiera (para revisar el encabezado por ejemplo), normalmente es mejor utilizar un programa de visualización particular que mostrará la estructura en un sistema virtual de coordenadas tridimensionales. De esta manera, el usuario podrá hacer zoom, rotar y trasladar la estructura. Cambiar la representación, mostrar las uniones y calcular las distancias, encontrar características estructurales de interés, etc. Estas herramientas pueden accederse online y están disponibles en los sitios de PDB, pero existen programas más poderosos y versátiles que se pueden descargar (como UCSF Chimera o Pymol).

Los archivos PDB normalmente tienen un modelo para cada molécula. Sin embargo, una entrada PDB puede tener uno o múltiples modelos de la misma molécula. Por ejemplo, debido a características de la técnica, las estructuras resueltas por NMR usualmente tienen 20 modelos alternativos en el mismo archivo.

Muchas entradas PDB poseen missing residues. Estas son porciones que no fueron observadas durante la determinación experimental de la estructura posiblemente debido a un aumento en la flexibilidad de esa región. La amplitud de estas regiones puede variar desde pequeños loops dentro de dominios globulares hasta largos segmentos desordenados.

La secuencia de la proteína en un PDB no necesariamente se corresponde al 100% con la de la entrada UniProt, debido a decisiones del experimentalista o dificultades técnicas. Siempre hay que revisar.

## PDB - Ejercicios

### Ejercicio 1. Familiarizándonos con el PDB.

El represor del operon lactosa de _E. coli_ se une al DNA formando un complejo y juega un papel importante en la regulación del uso de lactosa como fuente de carbono. Esta posee una estructura cuyo PDB ID es 1LBG.

1. Busque la estructura en el PDB (Si quiere aunque no es necesario, puede descargar el archivo PDB utilizando los botones en la parte superior derecha *Download Files*).
2. Inspecciona la sección *Structure Summary*.
    * ¿Cuándo se publicó la estructura en la PDB?
    * ¿Es una estructura de buena calidad?
3. En la sección *Macromolecules*, encontrará la mención a la proteína Mioglobina.
    * ¿Cuántas cadenas tiene?
    * ¿Puede identificar su UniProt accession?
4. En la sección *Protein Feature View* hay un mapeo sitio-específico entre UniProt y el PDB, con algunos adicionales de otras bases de datos. Si hace click en **expand**, podrá acceder a toda la información.
    * ¿Qué tipo de estructura secundaria adopta esta proteína?
    * ¿Puede encontrar los sitios de unión del hierro?
    * ¿Qué aminoácidos están involucrados?
5. Vuelva a la pestaña *Structure Summary*
    * ¿Esta estructura tiene unida una molécula de oxígeno?
6. En la sección *Macromolecules*, en la subsección *Entity groups* encuentre cuantas cadenas de otras entradas en el PDB son 100% idénticas a esta proteína.
7. Inspeccione la pestaña *Experiment* y responda:
    * ¿A qué pH fueron realizados los experimentos de cristalización?