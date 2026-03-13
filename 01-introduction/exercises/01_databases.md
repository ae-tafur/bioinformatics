# 💻 Práctica: Bases de datos biológicas y elementos básicos de archivos y secuencias

## Introducción

En la era de la genómica, la capacidad de analizar secuencias de ADN se ha convertido en una habilidad fundamental para la biología moderna. Desde la identificación de genes asociados a enfermedades hasta el diseño de microorganismos para aplicaciones biotecnológicas, el análisis de secuencias es el punto de partida. Sin embargo, antes de poder analizar cualquier secuencia, primero debemos saber cómo encontrarla, descargarla y comprender su formato.

Esta práctica es su primera inmersión en el mundo de las bases de datos biológicas, los repositorios digitales que almacenan la vasta cantidad de información genética generada a nivel mundial. Nos centraremos en el NCBI (National Center for Biotechnology Information), uno de los recursos más importantes y utilizados por la comunidad científica.

A través de un ejercicio práctico, aprenderá a navegar por la base de datos Nucleotide del NCBI, buscar secuencias específicas y descargarlas en formatos estándar como FASTA y GenBank. Al finalizar, será capaz de identificar los componentes clave de estos archivos y comprenderá por qué la elección del formato es crucial según la información que necesite para su análisis.

## 🎯 Objetivo

- Familiarizarse con la interfaz y las funciones de la base de datos **NCBI Nucleotide**.
- Descargar secuencias seleccionadas en formato FASTA y otros formatos.
- Identificar y comprender los elementos clave de los archivos de secuencia, como encabezados, longitud y la propia secuencia.
- Comparar la información disponible en diferentes formatos de archivo (FASTA vs GenBank) para una misma secuencia.

---

## 📦 Requisitos previos
- Computador con **Windows/Linux/macOS**.
- Conexión a internet para acceder a **NCBI Nucleotide**.  

---

## 🔬 Procedimiento

### Explorando el NCBI (National Center for Biotechnology Information)

El NCBI es uno de los recursos más importantes en bioinformática. Alberga múltiples bases de datos integradas. La página principal del NCBI tiene un menú desplegable que permite buscar en todas las bases de datos (All Databases) o seleccionar una específica (ej. Nucleotide, Protein, Gene, PubMed).  Algunos de los tipos de datos que se encuentran en el NCBI incluyen:
* Secuencias de nucleótidos, 
* secuencias de proteínas, 
* estructuras 3D, 
* información de genes, 
* artículos científicos (PubMed), 
* datos de expresión génica (GEO), etc.

Estos están además interconectados o individualizados por bases de datos, algunos de los recursos principales incluyen:
* PubMed: Literatura científica
* Gene: Información génica
* Nucleotide: Secuencias de ADN/ARN
* Protein: Secuencias proteicas
* Genome: Genomas completos
* SRA: Sequence Read Archive
* BLAST: Herramienta de búsqueda de similitud

#### ¿Cómo usar NCBI?:

1. **Paso 1: Acceder a la URL**: https://www.ncbi.nlm.nih.gov/
2. **Paso 2: Seleccionar base de datos**. Menú desplegable: Gene, Nucleotide, Protein, etc.
3. **Paso 3: Buscar datos**. Ejemplo: "GPD1 Saccharomyces cerevisiae", puedes aplicar filtros: Organismo, tipo de molécula, fecha
4. **Paso 4: Visualizar secuencia.**
   * Número de acceso (ej.: NM_007294.4)
   * Información: longitud, organismo, referencias
   * Secuencia: nucleótidos o aminoácidos
5. **Paso 5: Descargar datos**
   * Formato: FASTA, GenBank, otros 
   * Opciones: secuencia completa o región específica

### ToDo: Ejercicio Práctico

Objetivo: Obtener y diferenciar la información genética de la Beta-lactamasa (resistencia a penicilina).

1. **Búsqueda**: En NCBI Nucleotide, busca: `Escherichia coli blaTEM-1`.
2. **Filtro:** En la barra lateral izquierda, selecciona "Source databases: Nucleotide" para evitar secuencias sintéticas.
3. **Análisis de Formato GenBank:**
   * Busca la sección FEATURES.
   * Identifica la palabra clave /`gene="blaTEM-1"` o `gene="blaTEM"` o alguna coincidencia con `gene="xxxxxx"`.
   * Identifica el número de acceso (ej. MZ123456.1).
   * Anota las coordenadas (ej. 1..861). Esto indica dónde empieza y termina el gen en esa secuencia.
4. **Descarga Comparativa** (Click `Send to` → `File` → `Format: FASTA`):
   * Descarga la secuencia en FASTA (para ver la secuencia limpia).
   * Descarga la secuencia en GenBank (Full) (para ver la "biografía" del gen).
   * Descarga la secuencia en GFF3 (para ver la anotación estructural).
5. Abrir con editor de texto. 
> [!TIP]
> Puedes dar en click derecho `Abrir con` → `Notepad++` o `VSCode` o `Block de notas` para una mejor visualización.
6. Reto 1: Localiza el nombre de la cepa bacteriana (Strain) de la cual proviene esa secuencia específica en el archivo GenBank.
7. Reto 2: Compara la longitud de la secuencia en ambos formatos. ¿Son iguales? ¿Por qué?
8. Reto 3: En el archivo GFF3, identifica la anotación de la región codificante (CDS) y compárala con las coordenadas encontradas en el formato GenBank.
9. Reto 4: En el archivo GFF3, solo aparecen las coordenadas de la región codificante (CDS) y no la secuencia completa. ¿Por qué crees que es así? ¿En qué situaciones sería más útil un archivo GFF3 en lugar de un archivo FASTA o GenBank? ¿Qué otros tipos de elementos podrían estar anotados en un archivo GFF3 además de las regiones codificantes?

### 📝 Preguntas de Reflexión (Post-Práctica)

Estas preguntas buscan que el estudiante no solo descargue archivos, sino que analice su utilidad en el laboratorio de microbiología:

**Sobre la estructura de los datos**

1. El lenguaje del formato FASTA: Al abrir el archivo .fasta en un editor de texto, ¿qué símbolo identifica el inicio de la secuencia? Si intentaras cargar este archivo en un software de análisis y borraras accidentalmente ese símbolo, ¿qué crees que sucedería?
2. Metadatos vs. Secuencia: Compara el archivo FASTA con el archivo GenBank (.gb). Enumera tres datos que aparecen en el formato GenBank que son imposibles de encontrar en el formato FASTA. ¿En qué situación experimental necesitarías obligatoriamente el archivo GenBank?
3. La importancia de la versión: Observa el número de acceso (ej. NM_000207.3). ¿Qué crees que significa el número decimal después del punto? ¿Por qué es crítico para un microbiólogo reportar el número de acceso completo en una publicación científica?

**Sobre el contexto microbiológico**

4. Identificación Taxonómica: Si estuvieras analizando una muestra ambiental y obtuvieras una secuencia desconocida, ¿por qué la base de datos Nucleotide sería tu primer paso antes de usar otras bases de datos del NCBI como PubMed o Structure?
5. Curación de datos: Durante tu búsqueda, ¿aparecieron resultados de "Synthetic constructs" o "Cloning vectors"? ¿Cómo afectaría esto tu investigación si lo que buscas es estudiar la evolución natural de una bacteria en un suelo contaminado?