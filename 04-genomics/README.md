# Módulo 4: Genómica: Ensamblaje y Anotación

## Introducción

La genómica busca reconstruir, interpretar y comparar el contenido completo de ADN de un organismo. En términos prácticos, “hacer genómica” significa transformar millones de lecturas cortas o largas producidas por un secuenciador en información biológica útil: un genoma ensamblado, genes anotados, funciones predichas y, en muchos casos, variantes que explican diferencias entre cepas, fenotipos o linajes evolutivos.

En el laboratorio, el resultado inicial de una secuenciación no es un cromosoma listo para analizar, sino un gran conjunto de fragmentos. Por ello, uno de los retos centrales de la bioinformática moderna es responder preguntas como: ¿cómo reconstruimos un genoma a partir de fragmentos incompletos?, ¿cómo evaluamos si ese ensamblaje es confiable?, ¿cómo identificamos genes y otras regiones funcionales?, y ¿cómo detectamos cambios puntuales respecto a una referencia?

En este módulo trabajaremos especialmente con genómica bacteriana, donde los genomas suelen ser más compactos y permiten entender con mayor claridad los principios computacionales detrás del ensamblaje y la anotación. Sin embargo, también haremos contraste con genomas eucariotas, ya que presentan desafíos adicionales como intrones, regiones repetitivas extensas y estructuras génicas más complejas.

Al finalizar este módulo, deberá comprender la lógica general de un flujo de análisis genómico: control de calidad, ensamblaje o mapeo contra referencia, evaluación del ensamblaje, anotación estructural y funcional, e identificación de variantes genómicas.

> **Idea clave:** en genómica, no basta con obtener una secuencia larga; también hay que demostrar que es suficientemente completa, consistente y biológicamente interpretable.

## 1. ¿Qué significa “hacer genómica”?

En sentido amplio, la genómica estudia el conjunto completo del ADN de un organismo. A diferencia del análisis de un solo gen, aquí el objetivo es trabajar con miles de genes, regiones intergénicas, elementos repetitivos, plásmidos y otras características del genoma como un sistema integrado.

En un proyecto genómico típico, el flujo de trabajo incluye:

1. **Obtención de datos crudos (`.fastq`)** a partir de una plataforma de secuenciación.
2. **Control de calidad (QC)** para revisar calidad por base, adaptadores, duplicación y contenido GC.
3. **Limpieza o trimming** para remover adaptadores y lecturas de baja calidad.
4. **Reconstrucción del genoma**, ya sea mediante:
   * **Mapping contra una referencia**, si existe un genoma cercano bien caracterizado.
   * **Ensamblaje *de novo***, si se desea reconstruir el genoma sin depender de una referencia.
5. **Evaluación del resultado**, usando métricas de continuidad, tamaño, cobertura y completitud.
6. **Anotación genómica**, para identificar genes y asignar posibles funciones.
7. **Análisis comparativo o detección de variantes**, según la pregunta biológica.

Este flujo es especialmente importante en microbiología, donde puede aplicarse para:

* identificar bacterias y comparar cepas;
* estudiar genes de resistencia a antibióticos;
* analizar factores de virulencia;
* describir la capacidad metabólica de un microorganismo;
* vigilar brotes infecciosos y rutas de transmisión.

## 2. Estrategias de análisis genómico: *mapping* vs. *de novo*

Uno de los primeros pasos conceptuales en genómica es decidir cómo reconstruir la información a partir de las lecturas.

### 2.1 *Mapping* contra un genoma de referencia

En esta estrategia, las lecturas se alinean contra un genoma ya conocido y se analiza cómo encajan sobre esa referencia.

*   **Ventaja principal:** es rápido y muy útil cuando el organismo estudiado es muy parecido a uno ya secuenciado.
*   **Aplicaciones comunes:** detección de SNPs e indels, análisis de cobertura, identificación de regiones ausentes o presentes, vigilancia epidemiológica.
*   **Limitación:** si el genoma del organismo tiene reordenamientos, inserciones nuevas o regiones muy divergentes, estas pueden pasarse por alto o alinearse incorrectamente.

Un ejemplo clásico sería secuenciar una nueva cepa de *Escherichia coli* y alinear sus lecturas contra un genoma de referencia de *E. coli* ya publicado.

### 2.2 Ensamblaje *de novo*

En el ensamblaje *de novo*, no se parte de una referencia previa. El genoma se reconstruye a partir de los solapamientos o relaciones entre las propias lecturas.

*   **Ventaja principal:** permite descubrir secuencias nuevas, plásmidos, islas genómicas o regiones ausentes en genomas de referencia.
*   **Aplicaciones comunes:** secuenciación de nuevos aislados, genomas poco estudiados, análisis exploratorios y comparación de estructuras genómicas.
*   **Limitación:** depende fuertemente de la calidad de las lecturas, la cobertura, la longitud de lectura y la complejidad del genoma.

### 2.3 Comparación general

| Estrategia  | ¿Cuándo usarla?                                                   | Ventajas                                                                      | Limitaciones                                                            |
|:------------|:------------------------------------------------------------------|:------------------------------------------------------------------------------|:------------------------------------------------------------------------|
| **Mapping** | Cuando existe una buena referencia cercana                        | Rápido, sensible para variantes, fácil de interpretar                         | Puede perder secuencias nuevas o reordenamientos                        |
| **De novo** | Cuando no hay referencia o se quiere reconstrucción independiente | Descubre contenido nuevo y organiza el genoma sin sesgo directo de referencia | Más exigente computacionalmente y más sensible a errores y repeticiones |

En la práctica, ambos enfoques suelen complementarse: primero puede ensamblarse el genoma *de novo*, y luego alinear contigs o lecturas contra una referencia para comparar estructuras y detectar variantes.

## 3. Algoritmos de ensamblaje de genomas

El ensamblaje puede entenderse como la reconstrucción de un texto original a partir de millones de fragmentos pequeños. El problema central consiste en decidir qué fragmentos pertenecen juntos y en qué orden.

### 3.1 Conceptos básicos

Antes de revisar algoritmos concretos, conviene tener claros algunos términos:

*   **Lectura (*read*):** fragmento de ADN secuenciado.
*   **Contig:** secuencia continua ensamblada a partir de múltiples lecturas.
*   **Scaffold:** conjunto de contigs ordenados y orientados entre sí, normalmente usando información adicional como lecturas paired-end.
*   **Cobertura:** número promedio de veces que una posición del genoma fue leída.
*   **Regiones repetitivas:** secuencias similares que dificultan decidir dónde encaja cada lectura.

### 3.2 Overlap-Layout-Consensus (OLC)

#### Principio
Este enfoque compara lecturas entre sí para encontrar solapamientos directos.

1. **Overlap:** identificar qué lecturas comparten extremos similares.
2. **Layout:** organizar esas relaciones en un mapa o grafo.
3. **Consensus:** derivar la secuencia final más probable.

#### ¿Cuándo se usa?
*   Fue muy importante en secuenciación Sanger.
*   Sigue siendo útil para lecturas largas, donde el número total de fragmentos es menor y cada lectura cubre regiones más extensas.

#### Ventajas y limitaciones
*   **Ventaja:** funciona bien cuando las lecturas son largas.
*   **Limitación:** comparar todas las lecturas entre sí puede ser muy costoso si hay millones de lecturas cortas.

### 3.3 Grafos de De Bruijn

Los grafos de De Bruijn son la estrategia dominante para ensamblar lecturas cortas, especialmente datos Illumina.

#### Principio
En lugar de comparar lecturas completas entre sí, el algoritmo divide las lecturas en fragmentos pequeños de longitud fija llamados **k-mers**.

Por ejemplo, si la secuencia es `ATGCG` y usamos `k = 3`, los k-mers serían:

* `ATG`
* `TGC`
* `GCG`

El grafo conecta k-mers que comparten una superposición de `k-1` nucleótidos. Esto permite reconstruir trayectorias compatibles con la secuencia original.

#### ¿Por qué funciona bien con lecturas cortas?
Porque evita el problema de comparar “todas contra todas”. En su lugar, resume la información redundante de millones de lecturas en una estructura de grafo más eficiente.

#### Importancia del tamaño de *k*
La elección del valor de *k* es crítica:

*   **k pequeño:** conecta más fácilmente las lecturas, pero mezcla regiones repetitivas y puede generar ensamblajes ambiguos.
*   **k grande:** ayuda a resolver repeticiones, pero exige mayor cobertura y es más sensible a errores de secuenciación.

#### Explicación sencilla
Imagine que quiere reconstruir una frase no usando palabras completas, sino fragmentos cortos de letras. Si los fragmentos son demasiado pequeños, muchas combinaciones distintas parecerán posibles. Si son demasiado grandes, cualquier error ortográfico romperá la conexión. El ensamblaje debe encontrar un equilibrio.

### 3.4 Problemas frecuentes en ensamblaje

Los ensamblajes pueden fragmentarse o contener errores por varias razones:

*   **baja cobertura**, que deja huecos sin suficiente evidencia;
*   **errores de secuenciación**, que introducen k-mers falsos;
*   **regiones repetitivas**, que generan caminos ambiguos en el grafo;
*   **contaminación**, que añade secuencias ajenas a la muestra;
*   **plásmidos o múltiples replicones**, que complican la reconstrucción del conjunto completo.

Por ello, un ensamblaje no debe interpretarse solo por haber producido contigs; siempre debe evaluarse críticamente.

## 4. Evaluación del ensamblaje

Una vez ensamblado un genoma, la siguiente pregunta es: **¿qué tan bueno es el ensamblaje?** No existe una única métrica suficiente; deben considerarse varias dimensiones de calidad.

### 4.1 Métricas básicas

*   **Número de contigs:** cuantos menos contigs haya, en general, más continuo es el ensamblaje.
*   **Longitud total ensamblada:** debe ser razonable respecto al tamaño esperado del genoma.
*   **Contig más largo:** da una idea de continuidad local.
*   **Cobertura promedio:** ayuda a valorar si hubo suficiente información para ensamblar bien.

### 4.2 N50 y L50

Estas son dos métricas clásicas de continuidad.

#### N50
Es la longitud del contig a partir de la cual se alcanza al menos el 50% del tamaño total del ensamblaje, ordenando los contigs de mayor a menor.

*   Un **N50 alto** suele indicar que una parte importante del genoma está representada en contigs largos.
*   Sin embargo, **N50 no garantiza exactitud**: un ensamblaje puede tener contigs largos y aun así estar mal construido.

#### L50
Es el número mínimo de contigs necesarios para alcanzar el 50% del tamaño total ensamblado.

*   Un **L50 bajo** suele ser mejor, porque implica que pocos contigs concentran gran parte del ensamblaje.

### 4.3 Completitud del ensamblaje

La continuidad no es lo mismo que la completitud. Un ensamblaje puede tener un N50 alto y aun así faltar genes importantes.

#### BUSCO
**BUSCO** (*Benchmarking Universal Single-Copy Orthologs*) evalúa cuántos genes conservados universalmente están presentes en el ensamblaje.

Sus resultados suelen clasificarse como:

*   **Complete:** el gen esperado está presente de forma completa.
*   **Duplicated:** aparece más de una copia, lo que puede sugerir duplicación real o artefactos.
*   **Fragmented:** el gen está incompleto.
*   **Missing:** el gen no fue encontrado.

BUSCO es muy útil porque aporta una medida biológicamente informativa de completitud, más allá de la simple longitud de los contigs.

### 4.4 Interpretación crítica

Un buen ensamblaje no es necesariamente el que tiene el mayor N50, sino el que combina de manera razonable:

*   continuidad;
*   completitud;
*   baja contaminación;
*   tamaño esperado coherente;
*   utilidad para la pregunta biológica.

Por ejemplo, para detectar genes de resistencia en bacterias, puede ser suficiente un ensamblaje fragmentado pero bien anotado. En cambio, para estudiar reordenamientos cromosómicos, se requiere una estructura mucho más continua.

## 5. Anotación del genoma

Una vez se obtiene un ensamblaje en formato FASTA, todavía no sabemos automáticamente dónde están los genes ni qué función cumplen. La anotación transforma una secuencia “cruda” en un mapa biológico interpretable.

### 5.1 ¿Qué es un gen?

Desde el punto de vista biológico, un gen es una región del ADN que produce un producto funcional, ya sea un ARN o una proteína. Desde el punto de vista computacional, la anotación intenta reconocer patrones de secuencia que sugieren dónde comienza y termina esa unidad funcional.

### 5.2 Anotación estructural vs. funcional

#### Anotación estructural
Busca identificar **qué elementos hay y dónde están**. Por ejemplo:

*   genes codificantes (CDS);
*   tRNA;
*   rRNA;
*   regiones reguladoras;
*   exones e intrones en eucariotas.

#### Anotación funcional
Busca inferir **qué hace** cada gen o producto génico. Para ello se compara la secuencia con bases de datos y modelos conocidos.

### 5.3 ¿Cómo se reconoce un gen?

Los algoritmos de predicción no “entienden” biología como un humano, sino que buscan señales estadísticas y biológicas como:

*   codones de inicio y parada;
*   marcos de lectura abiertos (ORFs);
*   sesgo de uso de codones;
*   señales promotoras;
*   sitios de splicing en eucariotas;
*   similitud con genes ya conocidos.

### 5.4 Procariotas vs. eucariotas

| Característica           | Procariotas                    | Eucariotas                                      |
|:-------------------------|:-------------------------------|:------------------------------------------------|
| Organización génica      | Compacta                       | Más dispersa                                    |
| Intrones                 | Generalmente ausentes          | Frecuentes                                      |
| Densidad génica          | Alta                           | Menor                                           |
| Predicción computacional | Relativamente más sencilla     | Más compleja                                    |
| Evidencia adicional útil | Homología, motivos conservados | RNA-Seq, proteínas conocidas, modelos complejos |

#### Procariotas
En bacterias y arqueas, los genes suelen ser continuos, sin intrones, y están muy próximos entre sí. Esto hace que la predicción basada en ORFs y modelos estadísticos sea bastante efectiva.

Herramientas comunes:
*   **Prodigal**
*   **Prokka**

#### Eucariotas
En eucariotas, los genes pueden estar interrumpidos por intrones, presentar splicing alternativo y depender de señales reguladoras complejas. Por eso, la anotación suele requerir evidencia adicional como transcriptomas o proteínas homólogas.

Herramientas comunes:
*   **Augustus**
*   **MAKER**

### 5.5 Anotación funcional

Una vez predicho un gen, el siguiente paso es inferir su función.

Las estrategias más comunes incluyen:

*   **búsqueda de homología** con BLAST contra bases de datos como NCBI o UniProt;
*   **detección de dominios conservados** con Pfam o InterProScan;
*   **asignación de categorías funcionales** como GO (*Gene Ontology*) o rutas metabólicas.

Es importante recordar que la anotación funcional suele ser una **predicción** basada en semejanza, no una demostración experimental directa.

### 5.6 Formatos comunes: GFF y GBK

#### GFF
El formato **GFF** (*General Feature Format*) describe coordenadas y características anotadas sobre una secuencia.

Suele incluir información como:
*   tipo de característica (`gene`, `CDS`, `tRNA`);
*   coordenadas de inicio y fin;
*   hebra (`+` o `-`);
*   atributos como identificadores o productos.

#### GBK / GenBank
El formato **GBK** contiene tanto la secuencia como la anotación integrada en una estructura más rica y legible, muy usada para compartir genomas anotados.

En términos prácticos:
*   **FASTA** responde a “¿cuál es la secuencia?”
*   **GFF** responde a “¿dónde están las características?”
*   **GBK** integra secuencia y anotación en un mismo archivo

## 6. Variantes genómicas: SNPs e indels

Además de ensamblar y anotar genomas, muchas veces interesa comparar una muestra contra una referencia para identificar cambios puntuales.

### 6.1 ¿Qué es una variante?

Una **variante genómica** es una diferencia en la secuencia respecto a otra secuencia de referencia.

Las variantes más comunes son:

*   **SNPs** (*Single Nucleotide Polymorphisms*): cambio de una sola base.
*   **Indels**: inserciones o deleciones cortas.

Ejemplo:

* Referencia: `ATGCCGTA`
* Muestra:     `ATGTCGTA`

Aquí existe un SNP en la cuarta posición (`C → T`).

### 6.2 ¿Cómo se detectan?

El flujo más habitual consiste en:

1. alinear las lecturas contra un genoma de referencia;
2. revisar en cada posición qué bases apoyan las lecturas;
3. usar algoritmos de llamada de variantes para decidir si la diferencia es real o si podría ser error de secuenciación.

### 6.3 ¿Por qué son importantes?

Las variantes pueden ayudar a:

*   diferenciar cepas muy cercanas;
*   estudiar evolución y filogenia fina;
*   identificar mutaciones asociadas a resistencia antimicrobiana;
*   analizar adaptación, virulencia o cambios metabólicos.

### 6.4 Precauciones al interpretar variantes

No toda diferencia observada representa una mutación biológicamente real. También pueden influir:

*   calidad baja de lectura;
*   cobertura insuficiente;
*   alineamientos ambiguos;
*   regiones repetitivas;
*   sesgos introducidos por la referencia.

Por ello, la detección de variantes requiere filtros y criterios de calidad específicos.

## 7. Flujos de trabajo típicos en este módulo

En las prácticas de este módulo, varios de estos conceptos se aplicarán con herramientas concretas para genómica bacteriana.

### Flujo general

1. **Obtención de datos crudos (`.fastq`)**.
2. **Control de calidad** con herramientas como **FastQC** o **Falco**.
3. **Limpieza de lecturas** con **Fastp**.
4. **Ensamblaje *de novo*** con herramientas como **Velvet**, **SPAdes** o **Shovill**.
5. **Evaluación del ensamblaje**, integrando varias preguntas complementarias:
   * **Continuidad:** número de contigs, longitud máxima, **N50/L50** y métricas relacionadas, con apoyo de herramientas como **QUAST**.
   * **Completitud:** presencia de genes esperados y tamaño global coherente, usando por ejemplo **BUSCO**.
   * **Exactitud y consistencia:** evaluación del ensamblaje frente a los datos originales mediante mapeo de lecturas y, cuando sea pertinente, análisis de **QV** y espectro de **k-mers** con herramientas como **Merqury**.
   * **Pureza:** revisión del contenido GC y otras señales que puedan sugerir contaminación o mezcla de secuencias.
6. **Anotación del genoma** con herramientas como **Prokka**.
7. **Comparación contra referencia o análisis de variantes**, según la pregunta de investigación.

### Herramientas que se explorarán o se mencionan en las prácticas

*   **Falco / FastQC:** control de calidad de lecturas antes del ensamblaje.
*   **Fastp:** limpieza, filtrado y trimming de lecturas.
*   **Velvet:** comprensión conceptual del ensamblaje con grafos de De Bruijn.
*   **Shovill / SPAdes:** ensamblaje bacteriano práctico y eficiente.
*   **QUAST:** evaluación de continuidad del ensamblaje y comparación de métricas como número de contigs, longitud total y N50.
*   **BUSCO:** estimación de completitud biológica mediante genes conservados esperados para un linaje.
*   **Merqury:** evaluación complementaria de calidad a nivel de base (QV) y consistencia mediante espectro de k-mers.
*   **Prokka:** anotación rápida de genomas procariotas.

En un análisis real, estas herramientas no se usan de manera aislada. Se combinan para responder una pregunta más amplia: si el ensamblaje obtenido no solo es largo, sino también suficientemente completo, preciso y libre de contaminación como para sostener una interpretación biológica confiable.

## 8. Cierre conceptual

La genómica moderna integra biología molecular, estadística y ciencias computacionales para transformar datos crudos en conocimiento interpretable. Un ensamblaje no es el final del proceso, sino el punto de partida para entender la organización del genoma, el repertorio génico de un organismo y las diferencias que lo distinguen de otros.

En módulos y prácticas posteriores, estos principios se conectarán con preguntas biológicas concretas: desde la identificación de genes y funciones hasta la comparación entre cepas, la búsqueda de variantes y la interpretación de resultados en contextos clínicos, ambientales y biotecnológicos.
