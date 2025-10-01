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
cortas utilizando el ensamblador Shovill. Shovill es un ensamblador de 
genomas basado en SPAdes, mejorado para funcionar más rápido y solo para 
genomas más pequeños (bacterianos). Shovill es uno de los numerosos 
ensambladores de novo que utilizan conjuntos de lecturas cortas como 
entrada (por ejemplo, Illumina Reads). El método de ensamblaje se basa 
en la manipulación de gráficos de de Bruijn, mediante la eliminación de 
errores y la simplificación de regiones repetidas.

## Procedimiento

1.  Cree y nombre un nuevo historial para este tutorial. En la parte
    superior derecha de sus pantallas encontraran un simbolo (+) donde
    podrán crear una nueva historia y dando click en el simbolo de lapiz
    podrá editar el nombre

### Cargar los reads

Las lecturas han sido secuenciadas utilizando un instrumento de 
secuenciación de ADN Illumina. Obtuvimos los 2 archivos que importamos 
que finalizan en `_1` y `_2`

2. Vamos a importar desde Zenodo o desde la biblioteca de datos los 
archivos. Para esto, en galaxy, de click en `Upload` en la parte superior 
izquierda de las  pantalla. Alli luego mantenga la pestaña `regular` y en 
la parte inferior del lado derecho de click en `Paste/Fecth data`. Luego 
copie los link de abajo (seleccione solo los datos de un microorganismo para 
esta practica) y click en `start`. Una vez inicie el proceso, se observará 
un fondo verde. Cierre la ventana y luego en la parte derecha podrá ver que 
se están cargando los archivos, espere a que este en verde. Esto indica que 
ya esta listo. Naranja indica que esta en proceso y rojo que no se pudo 
realizar y debe repetir el cargue.

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

3. Inspeccione el contenido de un conjunto de datos

    **Pregunta**

    a\. ¿Cuáles son las cuatro características principales de un archivo
    FASTQ?

    b\. ¿Cuál es la principal diferencia entre un archivo FASTQ y un
    archivo FASTA?

### Evaluar las lecturas de entrada

Durante la secuenciación se producen errores, como la identificación incorrecta 
de nucleótidos. Estos se deben a las limitaciones técnicas de cada plataforma de 
secuenciación. Los errores de secuenciación pueden sesgar el análisis y dar lugar 
a una interpretación errónea de los datos. También pueden aparecer adaptadores si 
las lecturas son más largas que los fragmentos secuenciados, y recortarlos puede 
mejorar el número de lecturas mapeadas. Por lo tanto, el control de calidad de la 
secuencia es un primer paso esencial en cualquier análisis.

Evaluar la calidad manualmente supondría demasiado trabajo. Por eso se han creado 
herramientas como Fastqc, NanoPlot o Falco, que generan un resumen y gráficos de las 
estadísticas de los datos. NanoPlot se utiliza principalmente para datos de lectura 
larga, como ONT y PACBIO, y Falco para lectura corta, como Illumina y Sanger. Falco 
es una reescritura optimizada en cuanto a eficiencia de FastQC. Puede obtener más 
información en nuestro tutorial dedicado al control de calidad.

Antes de realizar cualquier ensamblaje, las primeras preguntas que debe
plantearse sobre las lecturas de entrada son:

-   ¿Cuál es la cobertura de mi genoma?
-   ¿Qué calidad tiene mi conjunto de lecturas?
-   ¿Necesito solicitar una nueva secuencia?
-   ¿Es adecuada para el análisis que necesito hacer?

Uno de los parametros importantes es la calidad de las lecturas. La calidad
de las lecturas se representa mediante la puntuación Phred, que es una
medida logarítmica de la probabilidad de que una base se haya llamado
incorrectamente. La puntuación Phred (Q) se calcula utilizando la siguiente
fórmula: 

$Q = -10 \log_{10}(P)$

donde P es la probabilidad de que la base se haya  llamado incorrectamente. 
Por ejemplo, una puntuación Phred de 20 indica que hay un 1% de probabilidad 
de que la base se haya llamado incorrectamente, mientras que una puntuación 
de 30 indica una probabilidad del 0,1%.

Acá te presento una tabla con los valores de calidad y su significado:

#### Tabla 1. Calidad Phred
| Nivel de calidad Phred (Q) | Probabilidad de error de base (Pe) | Precisión de la base |
|----------------------------|------------------------------------|----------------------|
| 10                         | 1 en 10                            | 90%                  |
| 20                         | 1 en 100                           | 99%                  |
| 30                         | 1 en 1000                          | 99.9%                |
| 40                         | 1 en 10.000                        | 99.99%               |
| 50                         | 1 en 100.000                       | 99.999%              |

Ahora vamos a evaluar la calidad de las lecturas utilizando Falco. Para usar 
las herramientas en Galaxy, simplemente haga clic en `tools` en la parte 
izquierda superior de la pantalla y busque la herramienta por su nombre en la
barra de búsqueda. Luego, haga clic en el nombre de la herramienta para abrir
el formulario de parámetros.

4. **Falco** (Galaxy version 1.2.4+galaxy0) con los siguientes
    parametros:

    -   “Raw read data from your current history”: both `*_1.fastq`
        and `*_2.fastq`. Para seleccionar ambos archivos: de click en 
        seleccionar multiples datasets (el icono con dos archivos ubicado en 
        la parte izquierda del recuadro de selección de archivos)
    - Luego `Run Tool`

5. Revisa el archivo html de los resultados de Falco. 2 para cada uno.

```
Falco combina estadísticas de calidad de todas las lecturas separadas y las 
combina en gráficos. Un gráfico importante es el de calidad de secuencia por base.

Aquí tiene la longitud de la secuencia de lecturas en el eje X frente a la 
puntuación de calidad (puntuación Phred) en el eje Y. El color de las barras 
indica tres niveles de calidad:

- Verde = buena calidad,
- Amarillo = calidad mediocre y
- Rojo = mala calidad.

Para cada posición, se dibuja un diagrama de caja con:

- el valor mediano, representado por la línea central de color intenso
- el rango intercuartílico (25-75 %), representado por el recuadro verde, amarillo o rojo
- los valores del 10 % y el 90 % en las barbas superior e inferior

En el caso de los datos de Illumina, es normal que las primeras bases sean de menor 
calidad y que, cuanto más largas sean las lecturas, peor sea la calidad. Esto se debe 
a menudo a la disminución de la señal o a la fase durante la secuenciación.

```

### Limpiar los datos
Dependiendo del análisis, es posible que se requiera una determinada calidad o longitud. 
En este caso, vamos a recortar los datos utilizando fastp [(Chen et al. 2018)](https://doi.org/10.1093/bioinformatics/bty560):

- Recorte el inicio y el final de las lecturas si estos tienen una puntuación de calidad inferior a 20.
	
  - Las diferentes herramientas de recorte tienen diferentes algoritmos para decidir cuándo cortar, pero Trimmomatic cortará basándose únicamente en la puntuación de calidad de una sola base. Trimmomatic comienza por cada extremo y, siempre que la base sea inferior a 20, se cortará hasta alcanzar una puntuación superior a 20. Se realizará un recorte de ventana deslizante en el que, si la calidad media de 4 bases cae por debajo de 20, la lectura se truncará en ese punto.

- Filtrar las lecturas para conservar solo aquellas con al menos 30 bases: cualquier lectura más corta complicará el ensamblaje.

6. **Trimmomatic** (Galaxy Version 0.39+galaxy2) con los siguientes
    parametros:
   - “Single-end or paired reads”: `Paired-end (two separate input files)`
     - “Input FASTQ file (R1/first of pair)”: `DRR187559_1`
     - “Input FASTQ file (R2/second of pair)”: `DRR187559_2`
   - Luego `Run Tool`

*Nota*: Una vez que se ejecuta Trimmomatic, se generan cuatro archivos de salida:

Para los datos emparejados, una ventaja particular de Trimmomatic es que conserva 
el emparejamiento de las lecturas (de R1 y R2) en los archivos de salida filtrados:

- Dos archivos FASTQ (R1-emparejado y R2-emparejado) contienen una lectura de 
  cada par en la que ambos han superado el filtrado.
- Además, dos archivos FASTQ (R1-sin emparejar y R2-sin emparejar) contienen 
  lecturas en las que uno de los pares no superó los pasos de filtrado.

Si la entrada consiste en una colección de conjuntos de datos con el par R1/R2 FASTQ,
las salidas también incluirán dos colecciones de conjuntos de datos: una para las 
salidas «emparejadas» y otra para las «no emparejadas» (como se ha descrito anteriormente).

Mantener el mismo orden y número de lecturas en los archivos fastq de salida filtrados 
es esencial para muchas herramientas de análisis posteriores.

### Ensamblar lecturas con Shovill

Ahora que se ha determinado la calidad de las lecturas y se han filtrado 
y/o recortado los datos, podemos intentar ensamblar las lecturas para construir 
secuencias más largas.

Existen muchas herramientas que crean ensamblajes para datos de lectura corta, por 
ejemplo, SPAdes (Prjibelski et al. 2020) y Abyss (Simpson et al. 2009). En este 
tutorial, utilizamos Shovill. Shovill es un ensamblador de genomas basado en SPAdes, 
mejorado para funcionar más rápido y solo para genomas más pequeños (bacterianos).

El primer paso del ensamblador es construir un grafo de Bruijn. Para
ello, dividirá nuestras lecturas en k-mers, es decir, fragmentos de
longitud k. El ensamblador requiere que el usuario introduzca un valor de k
(tamaño k-mer) para el proceso de ensamblaje. Los k-mers pequeños darán
mayor conectividad, pero los k-mers grandes darán mayor especificidad.

7. **Shovill** (Galaxy version 1.1.0+galaxy1) con los
    siguientes parametros:

   - “Input reads type, collection or single library”: `Paired End`
     - “Forward reads (R1)”: **fastp** `Read 1 output`
     - “Reverse reads (R2)”: **fastp** `Read 2 output`
   

Nota: en otros ensambladores, una lista de valores k puede ser introducida, y el
ensamblador elegirá el mejor valor k. En velvet se permite solo un valor k. Por 
lo tanto, si ese fuera el caso se elegiria un valor k de 29, que es adecuado para 
lecturas de 150 pb. Pero se puede variar el valor k para evaluar cual es la mejor
aproximación. 

**Shovill** genera 3 resultados:

- Un archivo de registro.
- Un archivo FASTA con contigs, es decir, secuencias genómicas contiguas en las que las bases se conocen con un alto grado de certeza.
- Un archivo con el gráfico de contigs o el gráfico de ensamblaje.
  - El gráfico de ensamblaje contiene más información, ya que no solo incluye las secuencias de todos los fragmentos ensamblados (incluidos los que son más cortos que la longitud mínima definida para la inclusión de los fragmentos en el resultado FASTA), sino que también indica la cobertura media relativa de los fragmentos por lecturas secuenciadas y cómo algunos de los fragmentos podrían unirse tras resolver manualmente las ambigüedades.

### Recopilar algunas estadísticas sobre los contigs

Esta tabla es limitada, pero ahora recopilaremos estadísticas más
básicas sobre nuestro ensamblaje.

8. **Quast** (Galaxy version 5.2.0+galaxy1) con los siquientes
    parametros:

    -   “Assembly mode”: `Co-assembly`
    -   “Use customized names?”: `No`
    -   “Contigs/scaffolds file”: `contigs output of Shovill`
    -   “Type of assembly”: `Genome`
    -   “Use a reference genome?”: `Yes`
    -   “Reference genome”: `GCF*.fna`
    -   “Type of organism”: `Prokaryotes`
    -   “Lower Threshold”: `500`
    -   “Advanced options: Comma-separated list of contig length
        thresholds”: `0,1000`


## ❓ Preguntas para reflexionar

1. ¿Cuál es la cobertura del genoma?
2. ¿Qué calidad tiene el conjunto de lecturas?
3. ¿Necesito solicitar una nueva secuencia?
4. ¿Es adecuada para el análisis que necesito hacer?
5. ¿Cómo cambió la longitud media de lectura antes y después del filtrado? 
6. ¿El recorte mejoró las puntuaciones medias de calidad? 
7. ¿El recorte afectó al contenido de GC? 
8. ¿Estos datos son adecuados para el ensamblaje? 
9. ¿Es necesario volver a secuenciarlos?
10. ¿Qué tamaño tiene el primer contig? 
11. ¿Cuál es la cobertura de su contig más grande (el primero)?
12. ¿Cuántos contigs se han construido?
13. ¿Cuál es la longitud total de todos los contigs?
14. ¿Cuál es la longitud media, mínima y máxima de los contigs?
15. ¿Qué proporción del genoma de referencia representan?
16. ¿Cuántos montajes erróneos se han encontrado?
17. ¿Qué son N50 y L50?
18. ¿Existe un sesgo en el porcentaje de GC inducido por el ensamblaje?


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
