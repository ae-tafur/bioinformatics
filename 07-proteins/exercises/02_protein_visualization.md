# 📄 Práctica 02: Visualización de estructuras proteicas con UCSF Chimera v1.19

> 📖 **Módulo 7** — [Volver al README del módulo](../README.md) | Secciones relacionadas: [§3 Niveles de estructura](../README.md#3-niveles-de-estructura-proteica) · [§4 Bases de datos](../README.md#4-bases-de-datos-de-proteínas)

La práctica tiene como propósito que los estudiantes se familiaricen con el entorno de Chimera y sus principales herramientas, de manera que puedan reconocer la nomenclatura utilizada para seleccionar modelos, cadenas, residuos y átomos, así como visualizar y analizar los diferentes niveles estructurales de proteínas. Igualmente, se busca que sean capaces de identificar elementos clave de la estructura terciaria, como los puentes disulfuro, los puentes de hidrógeno y las modificaciones postraduccionales, y que exploren métodos de análisis estructural aplicados específicamente al estudio del complejo RBD-ACE2 del SARS-CoV-2.

UCSF Chimera puede ser descargado gratuitamente desde su [sitio](https://www.cgl.ucsf.edu/chimera/download.html)  

## Introducción

UCSF Chimera es un software de visualización molecular ampliamente utilizado para el análisis de proteínas, ácidos nucleicos y complejos macromoleculares. A lo largo de esta práctica exploraremos sus funciones principales, desde la carga de estructuras hasta el análisis de elementos estructurales secundarios y terciarios.  

> 💡 Para reflexionar:  
> - ¿Por qué es importante visualizar estructuras proteicas?  
> - ¿Qué información podemos obtener de ellas?  
> - ¿Son estas estructuras objetos reales o modelos derivados de datos experimentales?  

---

## Procedimiento

### Ejercicio 1. Primeros pasos en Chimera
1. Abrir Chimera en el computador.  
   - Activar la **Command Line**, **Reply Log** y **Model Panel** desde el menú *Favorites*.  
2. Cargar una proteína desde el PDB:
    - Puedes usar el comando:
    ```
    open 1lbg
    ```
    - O abrir un archivo local `.pdb` con el menu *File > Open...*
3. Explorar la interfaz:
    - ¿Qué proteínas están incluidas en este PDB?  
    - ¿Qué aparece en el panel de modelos?
4. Practicar el uso del mouse:  
    - Izquierdo → rotar  
    - Derecho → trasladar  
    - Rueda → zoom

### Ejercicio 2. Nomenclatura en Chimera
Aprender a seleccionar por:
- **Modelos:** `select #0`  
- **Cadenas:** `select #0:.A`  
- **Residuos:** `select :300` o `select :300.A`  
- **Aminoácidos específicos:** `select #0:glu.A`  
- **Átomos:** `select #0:.A@CA`  

También se pueden usar **palabras clave** como `helix`, `strand`, `coil`, `ligand`, `solvent`, `ions`.

---

### Ejercicio 3. Análisis de la estructura del Receptor Binding Domain (RBD) de Spike del Coronavirus SARS-COV-2 unido a ACE2

La proteína Spike (S) de coronavirus (UniProt ID: P0DTC2, SPIKE_SARS2) corresponde a una proteína de membrana tipo I, de entre 180-200 kDa que presenta 1273 residuos y numerosas glicosilaciones.

Cada monómero se encuentra formado por un extremo N-terminal que constituye la mayoría de la proteína y se encuentra orientado hacia el espacio extracelular, un dominio transmembrana (TM) y un segmento C-terminal intracelular corto (IC). Spike se organiza formando trímeros en la superficie del virus, otorgando la apariencia de corona distintiva para la especie.

En el extremo N-terminal, a su vez, se pueden distinguir un péptido señal (residuos 1-13) y dos regiones denominadas S1 (residuos 14-685) y S2 (residuos 686-1273). Estas son las encargadas de mediar la unión y fusión de la membrana viral a la célula hospedera.

Adicionalmente, S1 está compuesta por dos secciones; una región N-terminal (NTD) (residuos 14–305) y **un dominio llamado RBD (Receptor Binding Domain, residuos 333–527), que es indispensable para que el SARS-CoV-2 pueda unirse a su receptor, la enzima convertidora de angiotensina 2 (ACE2). Dentro del dominio RBD se encuentra el motivo RBM (Receptor-Binding Motif, aminoácidos 438-506) que interacciona de forma directa con ACE2.**

Por otra parte, S2 se encuentra muy conservada entre todos los coronavirus. Contiene dos regiones, HR1 y HR2, en las que se repiten grupos de siete aminoácidos (heptad repeats) y el péptido de fusión (FP). De esta forma, durante el proceso de infección, S1 reconoce y se une a la enzima ACE2 presente en la membrana de la célula hospedadora. Esta unión trae aparejada la escisión proteolítica de los dominios S1 y S2, conduciendo a la activación del péptido de fusión que conecta la envoltura viral con la membrana plasmática. La reconfiguración de la región existente entre los dominios HR1 y HR2 da lugar a una estructura compuesta por 6 hélices (6-HB) que une ambas membranas, catalizando su fusión y permitiendo la entrada del virus a la célula. En este link puedes ver la estructura de Spike [Ver](https://www.frontiersin.org/journals/immunology/articles/10.3389/fimmu.2021.641447/full)

El propósito central de los ejercicios es introducir a los estudiantes en el uso de Chimera como herramienta para el estudio estructural de complejos proteicos. Tomando como modelo la estructura del complejo RBD-ACE2, se aplicarán metodologías básicas de visualización que faciliten el análisis de los diferentes niveles de organización de las proteínas. La práctica se enfocará en el reconocimiento de las cadenas polipeptídicas y de los elementos que las rodean, además de la exploración de los distintos tipos de estructuras secundarias en relación con la secuencia primaria. Finalmente, se abordará el estudio de interacciones clave que contribuyen al establecimiento y estabilidad de la estructura terciaria.


1. **Cargar la estructura**  
    `open 6m0j`
    > **Info:** Corresponde a un complejo RBD-ACE2 resuelto por difracción de rayos X a 2.45 Å.

2. **Reconocer cadenas** y pintarlas de distintos colores:  
    ```
    color red #0:.A
    color blue #0:.E
    rainbow chain #0
    ```
   - ¿Cuál corresponde a ACE2 y cuál al RBD?
   - ¿Cuántas cadenas hay?
   - Localize el ion Zn. `select @zn`
3. **Visualizar la secuencia primaria**  
   - *Favorites → Sequence* o comando `sequence #0`  
   - Identifique los N-terminal y C-terminal.  
4. **Explorar visualizaciones**: Vaya el menu `Presets` *ribbons, átomos, superficies hidrofóbicas*.  
5. **Analizar estructuras secundarias** y colorearlas:  
   - *Tools → Depiction → Color Secondary Structure* 
   - O usando el comando:
   ```
   color red,r helix; color purple,r strand; color gray,r coil
   ```
   - Compare predominancia de hélices y láminas en ACE2 y RBD.  
6. **Entorno molecular**: seleccionar y visualizar moléculas de agua `:HOH`.  
7. **Puentes disulfuro**: seleccionar `cys` y observar conexiones.
   ```
   sel #0:cys
   represent bs sel
   ```
8. **Medir longitud de enlaces disulfuro** con *Tools → Structure Analysis → Distances*.  
9. **Modificaciones postraduccionales**: inspeccionar residuos unidos (ej. 343 de la cadena E)
    ```
    focus :343.e
    ```
    - ¿Qué molécula está unida? ¿Qué indica su presencia?
10. **Puentes de hidrógeno**  
    ```
    hbonds selRestrict any reveal false showDist false color yellow
    ```  
    - Analizar en hélices y láminas β seleccionadas.  
11. **Gráfico de Ramachandran**  

    > **Info:**
    > El gráfico de Ramachandran es una representación bidimensional que muestra los valores de los ángulos de torsión (también llamados ángulos diedros) de la cadena principal de los aminoácidos en una proteína. En el eje X se representan los ángulos phi (φ), que corresponden al giro entre el nitrógeno y el carbono alfa, mientras que en el eje Y se ubican los ángulos psi (ψ), definidos entre el carbono alfa y el carbono carbonilo. Cada punto del gráfico representa un residuo de la proteína, y su ubicación indica cómo está orientada su cadena principal en el espacio.
    > 
    > En este tipo de representación, no todos los valores de φ y ψ son posibles, ya que los átomos ocupan espacio y se restringen por impedimentos estéricos. Por eso, los puntos suelen agruparse en zonas específicas que corresponden a conformaciones estables y comunes: una región característica de las hélices alfa (con valores de φ y ψ negativos), otra que corresponde a las láminas beta extendidas (φ negativo y ψ positivo) y áreas menos pobladas que reflejan giros o conformaciones raras.
    > 
    > Al analizar un gráfico de Ramachandran se espera observar que la mayoría de los residuos de una proteína se encuentren en estas regiones “permitidas” o “favorecidas”. Una alta proporción de residuos fuera de estas zonas puede indicar problemas en el modelo estructural, errores en la resolución experimental o, en algunos casos, la presencia de conformaciones particulares en residuos específicos como la glicina o la prolina. En resumen, este gráfico permite evaluar la validez y estabilidad de la estructura y comprender mejor la distribución de las conformaciones secundarias dentro de una proteína.
        
    - *Favorites → Model Panel → Ramachandran plot*  
    - Compare las distribuciones de hélices y láminas.  

---

## ❓ Preguntas de reflexión
1. ¿Qué ventajas tiene Chimera frente a otras herramientas de visualización estructural?  
2. ¿Qué información aporta la comparación de visualizaciones (ribbon, surface, sticks)?  
3. ¿Qué se puede deducir sobre estabilidad estructural al observar puentes disulfuro e hidrógeno?  
4. ¿Qué significan los puntos fuera de las regiones permitidas en un gráfico de Ramachandran?  

## 📌 Nota
Un archivo **PDB (Protein Data Bank)** contiene información sobre la estructura tridimensional de biomoléculas obtenida experimentalmente (difracción de rayos X, RMN o cryo-EM). Incluye:  
- **SEQRES:** la secuencia completa de aminoácidos de cada cadena.  
- **HELIX:** definición de segmentos de hélice α.  
- **SHEET:** definición de láminas β.  
- **ATOM/HETATM:** coordenadas de cada átomo en el espacio 3D.  
- **REMARKS:** metadatos sobre métodos experimentales, resolución y anotaciones adicionales.