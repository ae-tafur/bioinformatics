# 🧬 Práctica: Ensamblaje de genomas

Para realizar la siguiente practica por favor use el servidor Galaxy en
el servidor de la union europea, disponible en el siguiente link,
<https://usegalaxy.eu> (por favor no use <https://usegalaxy.org>, porque
puede presentar incovenientes durante la practica al usar algunas
herramientas), el sistema pedirá que se registre nuevamente si no se
habia registrado antes.

## Introducción

El ensamblaje de genomas es el proceso mediante el cual se reconstruye
un genoma completo a partir de fragmentos de ADN obtenidos a través de
técnicas de secuenciación. En términos más sencillos, se trata de
ensamblar pequeñas piezas de información genética (lecturas de
secuencias de ADN) en un genoma completo.

La secuenciación (determinación de la secuencia de nucleótidos del 
ADN/ARN) se utiliza en todo el mundo para todo tipo de análisis. El 
producto de estos secuenciadores son lecturas, que son secuencias de 
nucleótidos detectados. Dependiendo de la técnica, estas tienen 
longitudes específicas (30-500 pb) o, si se utiliza la secuenciación de
Oxford Nanopore Technologies o PacBio, tienen longitudes variables mucho más 
largas.

Cuando se realiza la secuenciación de un genoma, la tecnología moderna
divide el ADN en fragmentos más pequeños, que se leen y generan
secuencias de bases (A, T, C, G). Estas lecturas deben ser organizadas y
alineadas correctamente para crear una representación precisa y continua
del genoma original. El proceso de ensamblaje puede llevarse a cabo con
diferentes enfoques, como:

- **Ensamblaje de novo**: Se realiza cuando no se tiene un genoma de
referencia, y el objetivo es reconstruir el genoma desde cero a partir
de las lecturas sin ninguna guía externa. 

- **Ensamblaje de referencia**: Se realiza cuando se tiene un genoma de 
referencia conocido, y las lecturas se alinean y ensamblan sobre este 
genoma para obtener la secuencia específica del organismo en estudio.

### Fundamentos de secuenciación con illumina.

La secuenciación Illumina MiSeq se basa en la secuenciación por síntesis. 
Como su nombre indica, se miden las etiquetas fluorescentes de cada base 
que se une en un momento específico y en un lugar específico de una celda de 
flujo. Estas celdas de flujo están cubiertas con oligonucleótidos (pequeñas 
cadenas de ADN monocatenario). En la preparación de la biblioteca, las 
cadenas de ADN se cortan en pequeños fragmentos de ADN (varía según el kit 
o dispositivo) y se añaden piezas específicas de ADN (adaptadores) que son 
complementarias a los oligonucleótidos. Mediante la amplificación en puente
se crean grandes cantidades de grupos de estos fragmentos de ADN. La cadena 
inversa se elimina, lo que hace que los grupos sean monocatenarios. Se 
añaden bases fluorescentes una por una, que emiten una luz específica para 
las diferentes bases cuando se añaden. Esto ocurre en todos los grupos, por 
lo que esta luz puede detectarse y estos datos se traducen (traducción de 
la luz a un nucleótido) a una secuencia de nucleótidos (lectura). Para cada 
base se determina una puntuación de calidad y también se guarda por lectura. 
Este proceso se repite para la cadena inversa en el mismo lugar de la celda 
de flujo, de modo que las lecturas directas e inversas proceden de la misma 
cadena de ADN. Las lecturas directas e inversas están vinculadas entre sí 
y siempre deben procesarse juntas.

## Sobre esta practica

En esta práctica construiremos un ensamblaje de un genoma bacteriano a partir
de los datos producidos en 

1. «Complete Genome Sequences of Eight Methicillin-Resistant _Staphylococcus 
aureus_ Strains Isolated from Patients in Japan». [Hikichi et al. 2019](https://journals.asm.org/doi/10.1128/mra.01212-19):

`
Methicillin-resistant _Staphylococcus aureus_ (MRSA) is a major pathogen 
causing nosocomial infections, and the clinical manifestations of MRSA 
range from asymptomatic colonization of the nasal mucosa to soft tissue 
infection to fulminant invasive disease. Here, we report the complete 
genome sequences of eight MRSA strains isolated from patients in Japan.
`

2. «Epidemiological Genomics of _Klebsiella pneumoniae_ isolates from 
hospitals across Colombia». [Medina et al. 2025](https://www.nature.com/articles/s44259-025-00127-x):

`
_Klebsiella pneumoniae_ is one of the most important nosocomial pathogens 
worldwide. In Colombia, _K. pneumoniae_ has been identified as the second 
most frequent microbial etiologic agent of healthcare-associated 
infections. We conducted a prospective local study of 335  _K. 
pneumoniae_ isolates in 26 nationwide hospitals from 2020 to 2021. 
We found that the spread of carbapenem resistance was mediated by 
successful clones belonging to sequence types (ST) such as ST11, ST1082, 
and ST307, related to intra-hospital infections.
`
Nuestro conjunto de lecturas de la cepa mutante se secuenció con el
método de escopeta de genoma completo, utilizando un instrumento de
secuenciación de ADN Illumina. A partir de estas lecturas, nos gustaría
reconstruir el genoma de *Staphylococcus aureus* o de *Klebsiella 
pneuomoniae* mediante un ensamblaje de novo de un conjunto de lecturas 
cortas utilizando el ensamblador Velvet. Velvet es uno de los numerosos 
ensambladores de novo que utilizan conjuntos de lecturas cortas como 
entrada (por ejemplo, Illumina Reads). El método de ensamblaje se basa 
en la manipulación de gráficos de de Bruijn, mediante la eliminación de 
errores y la simplificación de regiones repetidas.

## Procedimiento

### Cargar los reads

Las lecturas han sido secuenciadas utilizando un instrumento de 
secuenciación de ADN Illumina. Obtuvimos los 2 archivos que importamos 
que finalizan en `_1` y `_2`

1.  Cree y nombre un nuevo historial para este tutorial. En la parte
    superior derecha de sus pantallas encontraran un simbolo (+) donde
    podrán crear una nueva historia y dando click en el simbolo de lapiz
    podrá editar el nombre

Importa desde Zenodo o desde la biblioteca de datos los archivos, solo 
seleccione un set de datos para esta practicas. Para
esto de click en `Upload` en la parte superior izquierda de las
pantallas. Alli luego mantenga la pestaña `regular` y en la parte
inferior del lado derecho de click en `Paste/Fecth data`. Luego copie
los link de abajo y continuar. Cierre la ventana y luego en la parte
derecha podrá ver que se estan cargando los archivos, espere a que este
en verde. Esto indica que ya esta listo. Naranja indica que esta en
proceso y rojo que no se pudo realizar y debe repetir el cargue.

Para importar los archivos de *Staphylococcus aureus* desde Zenodo, copie y
pegue los siguientes enlaces en la ventana de carga:
```         
https://zenodo.org/records/17156735/files/DRR187559_1.fastq.gz
https://zenodo.org/records/17156735/files/DRR187559_2.fastq.gz
https://zenodo.org/records/17156735/files/GCF_000013425.1_ASM1342v1_genomic.fna
```

Para importar los archivos de *Klebsiella pneumoniae* desde Zenodo, copie y
pegue los siguientes enlaces en la ventana de carga:
```  
https://zenodo.org/records/17156735/files/ERR14828471_1.fastq.gz
https://zenodo.org/records/17156735/files/ERR14828471_2.fastq.gz
https://zenodo.org/records/17156735/files/GCF_000240185.1_ASM24018v2_genomic.fna
```  

Nota: Los archivos tambien estan disponibles en la biblioteca de datos para ser descargados via linea de comandos.

Para descargar los archivos de *Staphylococcus aureus* desde la 
biblioteca de datos, ejecute los siguientes comandos:

``` 
cd
mkdir GenomeAssembly
cd GenomeAssembly
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/DRR187/DRR187559/DRR187559_1.fastq.gz
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/DRR187/DRR187559/DRR187559_2.fastq.gz
``` 

Para descargar los archivos de *Klebsiella pneumoniae* desde la 
biblioteca de datos, ejecute los siguientes comandos:

``` 
cd
mkdir GenomeAssembly
cd GenomeAssembly
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR148/071/ERR14828471/ERR14828471_1.fastq.gz
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR148/071/ERR14828471/ERR14828471_2.fastq.gz
``` 

2. Inspeccione el contenido de un conjunto de datos

    **Pregunta**

    a\. ¿Cuáles son las cuatro características principales de un archivo
    FASTQ?

    b\. ¿Cuál es la principal diferencia entre un archivo FASTQ y un
    archivo FASTA?

### Evaluar las lecturas de entrada

Antes de realizar cualquier ensamblaje, las primeras preguntas que debe
plantearse sobre las lecturas de entrada son:

-   ¿Cuál es la cobertura de mi genoma?
-   ¿Qué calidad tiene mi conjunto de lecturas?
-   ¿Necesito solicitar una nueva secuencia?
-   ¿Es adecuada para el análisis que necesito hacer?

Evaluaremos las lecturas de entrada con la herramienta **FastQC**. Esta
herramienta ejecuta una serie de pruebas estándar en su conjunto de
lecturas y devuelve un informe relativamente fácil de interpretar. La
utilizaremos para evaluar la calidad de nuestros archivos FASTQ y
combinar los resultados con MultiQC.

1. **FastQC** (Galaxy version 0.73+galaxy0) con los siguientes
    parametros:

    -   “Raw read data from your current history”: `*_1.fastq`
        and `*_2.fastq`

2. **MultiQC** (Galaxy version 1.11+galaxy1) con los siguientes
    parametros:

    -   “Results: Which tool was used to generate logs?”: `FastQC`
    -   Click “Insert FastQC output”
        -   “Type of FastQC
            output?”:`multiple datasets, select the raw data files from FastQC`

```
MultiQC genera una página web que combina informes para FastQC en ambos
conjuntos de datos. Incluye estos gráficos y tablas:

 - Estadísticas generales

Necesitamos conocer los datos para nuestro análisis. En
particular, necesitamos conocer las longitudes de lectura, ya
que es importante para establecer el tamaño máximo de k-mer para
un ensamblaje. Para obtener la longitud de las secuencias:

a. Busque la salida MultiQC que es una página web y haga clic
para verla

b. La primera tabla muestra las estadísticas generales de los
archivos de lectura de entrada.

c. En la parte superior de esta tabla, haga clic en Configurar
columnas

d. Asegúrese de que la casilla junto a Longitud está marcada

e. Cierre la ventana

f. Esta tabla debería mostrar ahora una columna para las
longitudes de lectura

Pregunta

¿Qué longitud tienen las secuencias?

¿Cuál es la cobertura media del genoma, teniendo en cuenta que
nuestra bacteria imaginaria \*Staphylococcus aureus\* tiene un
genoma de 197.394 pb?

 - Histogramas de calidad de la secuencia

Las caídas en la calidad cerca del principio, el medio o el
final de las lecturas pueden determinar los métodos y parámetros
de recorte/limpieza que deben utilizarse, o pueden indicar
problemas técnicos con el proceso de secuenciación/la ejecución
de la máquina.

Pregunta

¿Qué representa el eje y?

¿Por qué disminuye la puntuación de calidad a lo largo de las
lecturas?

 - Contenido GC por secuencia

Los organismos con alto GC tienden a no ensamblarse bien y
pueden tener una distribución desigual de la cobertura de
lectura.

 - Contenido de N por base

La presencia de un gran número de Ns en las lecturas puede
indicar un proceso de secuenciación de baja calidad. Deberá
recortar estas lecturas para eliminar los Ns.

 - Contenido de k-mer

La presencia de k-mers muy recurrentes puede indicar
contaminación de las lecturas con códigos de barras o secuencias
adaptadoras.
```

### Ensamblar lecturas con Velvet

Ahora queremos ensamblar nuestras lecturas para encontrar la secuencia
de nuestra bacteria imaginaria *Staphylococcus aureus*. Realizaremos un
ensamblaje de novo de las lecturas en secuencias largas contiguas
utilizando el ensamblador de lecturas cortas Velvet.

El primer paso del ensamblador es construir un grafo de Bruijn. Para
ello, dividirá nuestras lecturas en k-mers, es decir, fragmentos de
longitud k. Velvet requiere que el usuario introduzca un valor de k
(tamaño k-mer) para el proceso de ensamblaje. Los k-mers pequeños darán
mayor conectividad, pero los k-mers grandes darán mayor especificidad.

1. **FASTQ interlacer** ( Galaxy version 1.2.0.1+galaxy0) con los
    siguientes parametros:

    -   “Type of paired-end datasets”: `2 separate datasets`

    -   “Left-hand mates”: `*_1.fastq`

    -   “Right-hand mates”: `*_2.fastq`

Actualmente, nuestras lecturas emparejadas están en 2 archivos (uno con
las lecturas hacia delante y otro con las lecturas hacia atrás), pero
Velvet sólo necesita un archivo, en el que cada lectura esté junto a su
lectura emparejada. En otras palabras, si las lecturas están indexadas
desde 0, entonces las lecturas 0 y 1 están emparejadas, 2 y 3, 4 y 5,
etc. Antes de hacer el ensamblaje propiamente dicho, tenemos que
preparar los archivos combinándolos.

2. **velveth** ( Galaxy version 1.2.10.3) con los siguientes
    parametros:

    -   “Hash Length”: `29`
    -   “Input Files”
        -   Click on + “Input Files”
            -   In “1: Input Files”
                -   “Choose the input type”: `interleaved paired end`
                -   “read type”: `shortPaired reads param-files`
                -   “Dataset”: `pairs output of *FASTQ interlacer*`

La herramienta toma nuestras lecturas y las descompone en k-mers.

3. **velvetg** ( Galaxy version 1.2.10.2) con los siguientes
    parametros:

    -   param-files “Velvet Dataset”: `outputs of velveth`
    -   “Using Paired Reads”: `Yes`

Esta última herramienta realiza realmente el ensamblaje.

Se generan cinco archivos. Veremos el archivo **contigs** y el archivo
**stats**:

-   El archivo **contigs**

Este archivo contiene las secuencias de los contigs. En la cabecera de
cada contig, se añade un poco de información:

la longitud k-mer (llamada «length»): Para el valor de k elegido en el
ensamblaje, una medida de cuántos k-mers se solapan (en 1 pb cada
solapamiento) para dar esta longitud la cobertura de k-mers (denominada
«cobertura»): Para el valor de k elegido en el ensamblaje, una medida de
cuántos k-mers se solapan cada posición de base (en el ensamblaje).

-   El archivo de **stats**

Se trata de un archivo tabular que proporciona para cada contig las
longitudes de k-mer, las coberturas de k-mer y otras medidas. Tenga en
cuenta que sus resultados pueden diferir del ejemplo de la imagen
siguiente.

### Recopilar algunas estadísticas sobre los contigs

Esta tabla es limitada, pero ahora recopilaremos estadísticas más
básicas sobre nuestro ensamblaje.

1. **Quast** (Galaxy version 5.2.0+galaxy1) con los siquientes
    parametros:

    -   “Assembly mode”:
        `Individual assembly (1 contig file per sample)`
    -   “Use customized names?”: `No`
    -   “Contigs/scaffolds file”: `contigs output of velvetg`
    -   “Type of assembly”: `Genome`
    -   “Use a reference genome?”: `Yes`
    -   “Reference genome”: `GCF*.fna`
    -   “Type of organism”: `Prokaryotes`
    -   “Lower Threshold”: `500`
    -   “Advanced options: Comma-separated list of contig length
        thresholds”: `0,1000`

### Trabajo para analizar

Corran nuevamente pero en el paso 6

1. *velveth* ( Galaxy version 1.2.10.3) con los mismos parametros de
    antes pero prueben

-   “Hash Length”: un valor entre 31 y 101


## ❓ Preguntas para reflexionar

1. ¿Cuál es la cobertura del genoma?
2. ¿Qué calidad tiene el conjunto de lecturas?
3. ¿Necesito solicitar una nueva secuencia?
4. ¿Es adecuada para el análisis que necesito hacer?
5. ¿Cuántos contigs se han construido?
6. ¿Cuál es la longitud media, mínima y máxima de los contigs?
7. ¿Qué proporción del genoma de referencia representan?
8. ¿Cuántos montajes erróneos se han encontrado?
9. ¿Ha introducido el ensamblaje desajustes e indels?
10. ¿Qué son N50 y L50?
11. ¿Existe un sesgo en el porcentaje de GC inducido por el ensamblaje?


## Bibliografia

Seemann, T., 2014 Prokka: rapid prokaryotic genome annotation.
Bioinformatics 30: 2068–2069. 10.1093/bioinformatics/btu153

Xie, Z., and H. Tang, 2017 ISEScan: automated identification of
insertion sequence elements in prokaryotic genomes. Bioinformatics 33:
3340–3347. 10.1093/bioinformatics/btx433

Hikichi, M., M. Nagao, K. Murase, C. Aikawa, T. Nozawa et al., 2019
Complete Genome Sequences of Eight Methicillin-Resistant Staphylococcus
aureus Strains Isolated from Patients in Japan (I. L. G. Newton, Ed.).
Microbiology Resource Announcements 8: 10.1128/mra.01212-19

Carattoli, A., and H. Hasman, 2020 PlasmidFinder and in silico pMLST:
identification and typing of plasmid replicons in whole-genome
sequencing (WGS). Horizontal gene transfer: methods and protocols
285–294. 10.1007/978-1-4939-9877-7_20

Schwengers, O., L. Jelonek, M. A. Dieckmann, S. Beyvers, J. Blom et al.,
2021 Bakta: rapid and standardized annotation of bacterial genomes via
alignment-free sequence identification. Microbial genomics 7: 000685.
10.1099/mgen.0.000685

Néron, B., E. Littner, M. Haudiquet, A. Perrin, J. Cury et al., 2022
IntegronFinder 2.0: identification and analysis of integrons across
bacteria, with a focus on antibiotic resistance in Klebsiella.
Microorganisms 10: 700. 10.3390/microorganisms10040700

Diesh, C., G. J. Stevens, P. Xie, T. De Jesus Martinez, E. A. Hershberg
et al., 2023 JBrowse 2: a modular genome browser with views of synteny
and structural variation. Genome biology 24: 1–21.
10.1186/s13059-023-02914-z