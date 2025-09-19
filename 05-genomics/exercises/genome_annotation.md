# 🧬 Práctica: Anotación de genomas

Para realizar la siguiente practica por favor use el servidor Galaxy en
el servidor de la union europea, disponible en el siguiente link,
<https://usegalaxy.eu> (por favor no use <https://usegalaxy.org>, porque
puede presentar incovenientes durante la practica al usar algunas
herramientas), el sistema pedirá que se registre nuevamente si no se
habia registrado antes.

## Introducción

La anotación genómica consiste en describir la estructura y función de
los componentes del genoma, prediciéndolos, analizándolos e
interpretándolos para extraer su significado biológico y comprender los
procesos biológicos en los que participan. Entre otras cosas, identifica
la localización de los genes y todas las regiones codificantes de un
genoma (anotación estructural) y determina qué hacen esos genes
(anotación funcional).

Para ilustrar el proceso de anotación de un genoma bacteriano, tomamos
un ensamblaje de un genoma bacteriano (muestra KUN1163) generado
siguiendo un tutorial de ensamblaje de genomas bacterianos a partir de
los datos producidos en «Complete Genome Sequences of Eight
Methicillin-Resistant Staphylococcus aureus Strains Isolated from
Patients in Japan» (Hikichi et al. 2019).

*Staphylococcus aureus* resistente a la meticilina (MRSA) es un patógeno
importante que causa infecciones nosocomiales, y las manifestaciones
clínicas de MRSA van desde la colonización asintomática de la mucosa
nasal hasta la infección de tejidos blandos y la enfermedad invasiva
fulminante. Aquí presentamos las secuencias genómicas completas de ocho
cepas de SARM aisladas de pacientes en Japón.

## Procedimiento

### Cargue los datos

Importe el archivo contig desde Zenodo o desde las bibliotecas de datos
compartidos Galaxy:

`https://zenodo.org/record/10572227/files/DRR187559_contigs.fasta`

### Anotación de contigs

Para anotar los contigs, existen varias herramientas para hacerlo:
**Prokka** (Seemann 2014), **Bakta** (Schwengers et al. 2021), etc.
Aquí, utilizamos Bakta como recomendado por Torsten Seemann avatar
Torsten Seemann como el sucesor de Prokka.

**Bakta** es una herramienta para la anotación rápida y estandarizada de
genomas bacterianos y plásmidos tanto de aislados como de genomas
ensamblados de metagenomas (MAGs). Implementa un flujo de trabajo de
anotación exhaustivo para genes codificantes y no codificantes (es
decir, ARNt, ARNr).

1.  En el panel de herramientas busque `Bakta` y ajuste los siguientes
    parametros:

    -   En “Input/Output options”:
        -   “Select genome in fasta format”: DRR187559_contigs.fasta
        -   “Bakta database”: V5.1_2024-01-19
        -   “AMRFinderPlus database”: V3.12-2024-05-02.2
    -   En “Optional annotation”:
        -   “Keep original contig header”: Yes
    -   En “Selection of the output files”:
        -   “Output files selection”:
            1.  Annotation file in TSV
            2.  Annotation and sequence in GFF3
            3.  Feature nucleotide sequences as FASTA
            4.  Summary as TXT
            5.  Plot of the annotation result as SVG

### Anotación adicional

#### Plasmidos

Para identificar plásmidos en nuestros contigs, utilizamos PlasmidFinder
(Carattoli y Hasman 2020), una herramienta para la identificación y
tipificación de secuencias de plásmidos en la secuenciación del genoma
completo. Utiliza la base de datos plasmidfinder con cientos de
secuencias para predecir el plásmido en los datos.

1.  En el panel de herramientas busque `PlasmidFinder` y ajuste los
    siguientes parametros:
    -   En “Input parameters”:
        -   “Choose a fasta or fastq file”: `DRR187559_contigs.fasta`
        -   “PlasmidFinder database”: utilice la más actualizada

`PlasmidFinder` genera varios resultados:

`raw_results.txt`: Un archivo de texto que contiene la tabla de
resultados y las alineaciones `results.tsv`: Un archivo tabular con las
siguientes columnas:

```         
- Base de datos
- Plásmido: Plásmido contra el que se ha alineado el genoma de entrada.
- Identidad: Porcentaje de identidad en el alineamiento entre el plásmido
  que mejor coincide en la base de datos y la secuencia correspondiente en 
  el genoma de entrada (también llamado par de segmentos de alta puntuación 
  (HSP)). Una alineación perfecta es del 100%, pero también debe cubrir toda 
  la longitud del plásmido en la base de datos (compare los ejemplos 1 y 3).
- Longitud de la consulta/plantilla: La longitud de consulta es la longitud 
  del plásmido que mejor coincide en la base de datos, mientras que la 
  longitud HSP es la longitud de la alineación entre el plásmido que mejor
  coincide y la secuencia correspondiente en el genoma (también denominada 
  par de segmentos de alta puntuación (HSP)).
- Contig: Nombre del contig en el que se encuentra el plásmido.
- Posición en el contig: Posición inicial del gen encontrado en el contig.
- Nota: Notas sobre el plásmido
- Número de acceso: Número de acceso al Genbank de referencia según el NCBI 
  para el plásmido en la base de datos.
```

`plasmid.fasta`: Un archivo fasta que contiene las mejores secuencias
coincidentes del genoma de consulta `hit_in_genome.fasta`: Un archivo
fasta que contiene los genes plasmídicos que mejor coinciden con los de
la base de datos

#### Integrones

Los integrones son mecanismos genéticos que permiten a las bacterias
adaptarse y evolucionar rápidamente mediante el almacenamiento y la
expresión de nuevos genes. Un integrón está compuesto mínimamente por

-   un gen que codifica para una recombinasa de sitio específico (intI)
-   un sitio de recombinación proximal (attI), que es reconocido por la
    integrasa y en el que pueden insertarse casetes de genes
-   un promotor (Pc) que dirige la transcripción de los genes
    codificados en casetes.

Para detectar los integrones, utilizaremos `IntegronFinder` (Néron et
al. 2022). Esta herramienta

- Anota el CDS con Prodigal 
- Detecta de forma independiente
    -   integrón integrasa utilizando la intersección de dos perfiles
        HMM: uno específico de tirosina-recombinasa (PF00589) y otro
        específico del integrón integrasa, cerca del dominio patch III
        de tirosina recombinasas
    -   attC con un modelo de covarianza (CM), que modela la estructura
        secundaria además de las pocas posiciones de secuencia
        conservadas.
- Integra los resultados para distinguir 3 tipos de elementos
    -   Integrón completo: Integrón con integrasa de integrón cerca de
        sitio(s) attC
    -   Elemento In0: Integrón integrasa solamente, sin ningún sitio
        attC cercano
    -   Elemento CALIN: Grupo de sitios attC Sin integrasa cercana

En el panel de herramientas busque `IntegronFinder` y ajuste los
siguientes parametros: - “Replicon file”: `DRR187559_contigs.fasta` -
“Thorough local detection”: `Yes` - “Search also for promoter and attI
sites?”: `Yes` - “Remove log file”: `Yes`

`IntegronFinder` genera 2 salidas:

1.  Un resumen con para cada secuencia en la entrada el número de
    elementos CALIN identificados, elementos In0, e integrones
    completos.

2.  Un archivo de anotación de integrones en forma de tabla.

#### Elementos IS (secuencia de inserción)

El elemento de secuencia de inserción (IS) es una secuencia corta de ADN
que actúa como elemento transponible simple. Los IS son los elementos
transponibles autónomos más pequeños pero más abundantes en los genomas
bacterianos. Sólo codifican proteínas implicadas en la actividad de
transposición. Desempeñan, pues, un papel clave en la organización y
evolución del genoma bacteriano.

Para detectar elementos IS, utilizaremos `ISEScan` (Xie y Tang 2017).
ISEScan es un software altamente sensible basado en modelos de Markov
ocultos construidos a partir de elementos IS curados manualmente.

1.  En el panel de herramientas busque `ISEScan` y ajuste los siguientes
    parametros:
    -   “Genome fasta input”: `DRR187559_contigs.fasta`


## ❓ Preguntas para reflexionar
1. En el archivo `Analisis summary` ¿Cuantos contigs habian en el input?
2. En el archivo `Analisis summary` ¿Cuan largo es el draft genome?
3. En el archivo `Analisis summary` ¿Cuantos CDSs fueron encontrados?
4. En el archivo `Analisis summary` ¿Cuantas small proteins?
5. En el archivo `Analisis summary` ¿Que otros componentes fueron encontrados?
6. En el archivo `Analisis summary` ¿Si compara los resultados obtenidos con aquellos para KUN1163 en la
    Tabla 1 en Hikichi et al. 2019, que tal va?
7. En el archivo `nucleotide_sequences` ¿Cuantas secuencias hay en el archivo?
8. En el archivo `nucleotide_sequences` ¿Cuales secuencias hay almacenadas ahi?
9. En el archivo `annotation_summary` ¿Que hay almacenado ahi?
10. En el archivo `Annotation_and_sequences` ¿Que hay almacenado ahi?
11. En el archivo `SVG` ¿Que significan los dos anillos en el centro?
12. ¿Que significan los dos anillos de color gris?
13. ¿Cuántas secuencias de plásmidos se encontraron?
14. ¿Dónde se encuentran?
15. ¿Están todas estas secuencias asociadas a *Staphylococcus aureus*?
16. ¿Qué podemos concluir sobre contig00019?
17. ¿Cuántos elementos de integrón se han encontrado?
18. ¿Cuántos elementos IS se han detectado?
19. ¿Dónde se encuentran?
20. ¿Cuáles son las distintas familias de especies invasoras?

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
