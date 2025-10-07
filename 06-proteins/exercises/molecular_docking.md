
## Docking Molecular

El docking molecular es una técnica computacional que predice la afinidad de unión de los ligandos a las proteínas receptoras.  Existen varias herramientas computacionales y algoritmos disponibles para las técnicas de acoplamiento molecular, tanto comerciales como gratuitos. Estos programas y herramientas se han desarrollado y se utilizan actualmente en la investigación de fármacos y en el ámbito académico. Según Sahoo et al., algunos de los programas de acoplamiento más utilizados son AutoDock Vina, Discovery Studio, Surflex, AutoDock GOLD, Glide, MCDock, MOE-Dock, FlexX, DOCK, LeDock, rDock, ICM, Cdcker, LigandFit, FRED y UCSF Dock. Entre estos programas, AutoDock Vina, Glide y AutoDock GOLD han sido identificados como las opciones mejor valoradas con las mejores puntuaciones. Además, algunos de estos programas han sido eficaces a la hora de predecir desviaciones cuadráticas medias (RMSD) que oscilan entre 1,5 y 2 Å, dependiendo de las poses experimentales. Sin embargo, el acoplamiento de receptores flexibles, en concreto la flexibilidad de la espina dorsal del receptor, sigue siendo un reto para los programas de acoplamiento actuales.

La electrostática computacional del complejo ligando-receptor puede evaluarse, analizarse y predecirse mediante el estudio de acoplamiento (docking), como afirman Sahoo et al. Según Mohapatra et al, este estudio suele seguir dos pasos distintos. En segundo lugar, las conformaciones se clasifican según una función de puntuación. Los algoritmos de muestreo deben reproducir teóricamente los modos de unión experimentales, y las confirmaciones obtenidas deben clasificarse según una función de puntuación, según Dash et al. El enfoque de laboratorio seco ofrece una ventaja significativa sobre los estudios de laboratorio in vivo en términos de inversión de recursos y tiempo, como señalan Sahoo et al. y Pramanik et al. Nanda et al. explicaron que este enfoque predice la orientación del ligando en un complejo formado por el propio ligando con proteínas o enzimas. Además, la forma del complejo acoplado y la interacción electrostática cuantifican la interacción.

La utilidad del Molecular Docking en el descubrimiento y diseño de fármacos está bien establecida. Sin embargo, Tao et al. han informado recientemente de un aumento del interés por la aplicación de este método en la ciencia de los alimentos. En concreto, el acoplamiento molecular se está utilizando para autentificar las dianas moleculares de los nutracéuticos en el tratamiento de enfermedades.
[leer mas](https://doi.org/10.1038/s41598-023-40160-2)


### Ejercicio 1. Docking con AutoDock4.

Luego de dos años y numerosos intentos de modelación por homología y diseño de fármacos _in silico_, se ha logrado diseñar un fármaco, pero necesita evaluar la afinidad del ligando con el receptor. 

#### Setup

1. Antes de empezar, necesita instalar los siguientes programas en su ordenador:
    - **ChimeraX** 
    - **Cygwin** (sólo para PCs, los Macs o Linux usarán la terminal). Puede descargarse [aquí](https://www.cygwin.com/install.html), haga la instalación estándar, ocupa unos 100 MB.
    - **Autodock**. Puede descargarse [aqui](https://autodock.scripps.edu/download-autodock4/). La versión más reciente de AutoDock funciona de forma nativa en Windows, véanse las [instrucciones de instalación](http://autodock.scripps.edu/downloads/autodock-4-2-x-installation-on-windows). Autodock también está disponible para plataformas Mac OS X y Linux. Los archivos principales son Autodock y AutoGrid, necesarios para ejecutar el predocking (mapas de energía), el docking y el cálculo de la puntuación, vease el [manual](https://autodock.scripps.edu/wp-content/uploads/sites/56/2021/10/AutoDock4.2.6_UserGuide.pdf) para más información.
    - **AutoDock tools (MGLtools)**. Puede descargarse [aqui](https://ccsb.scripps.edu/mgltools/downloads/). Se trata de una interfaz gráfica de usuario utilizada para preparar la entrada, ejecutar y analizar los acoplamientos generados a partir de Autodock (añadir cargas atómicas, fijar enlaces, añadir hidrógenos, preparar el ligando y la diana en un formato PDBQT compatible con Autodock, crear rejillas y archivos de parámetros de acoplamiento y visualizar interactivamente los resultados del acoplamiento).
   
    **Nota**: Copie autodock4.exe y autogrid4.exe y peguelo en My computer\ C drive\ Cygwin\ bin

2. Ahora que ya tenemos los programas necesarios, vamos a descargar la proteina y el ligando que vamos a utilizar. La estructura cristalizada de Imipenem-hydrolyzing beta-lactamase SME-1 (1DY6) se puede descargar del [Protein Data Bank](http://www.rcsb.org). La estructura de imipenem-hydrolyzing beta-lactamase SME-1 descargada tiene dos cadenas, puede eliminar una pues el imipenem puede interactuar con cualquiera de las dos cadenas, hagalo en Chimera. Esta tiene 267 residuos de aminoácidos y el monómero tiene una resolución de 2,13 Angstroms. Puede obtener el ligando (Imipenem) de las dos mayores bases de datos, [drugbank](http://www.drugbank.ca/) o [pubchem](http://pubchem.ncbi.nlm.nih.gov/), descarguelo y luego abralo en Chimera y guardelo en formato .pdb.

    **Nota**: Se recomienda a los usuarios que regeneren los archivos target.pdb y ligand.pdb utilizando el [Swiss-PdbViewer](http://spdbv.unil.ch/).

#### Preparación de archivos

Los siguientes pasos son críticos porque dictan el procedimiento para ejecutar AutoGrid y AutoDock y proporcionan parámetros de acoplamiento precisos. Los archivos coordinados y la información correspondiente deben crearse en un formato específico denominado PDBQT, que contiene tipos de átomos/vínculos, cargas atómicas parciales, etc. Estos tipos de datos se preparan (normalmente) utilizando AutoDockTools. En esta sección, limitaremos nuestro experimento de docking a la configuración por defecto.

3. El proceso de creación de un PDBQT de destino a partir de un archivo PDB (de estructura cristalina) consta de los siguientes pasos:
   1. Abra las herramientas MGLTools y Autodock desde su escritorio o archivos de programa.
   3. Asegúrese de que los archivos target.pdb y ligand.pdb están en la misma carpeta, por ejemplo, ~Desktop\autodock (para usuarios de Windows).
   4. En el menú File > Open > Read Molecule
   5. Seleccione target.pdb de la carpeta ~Desktop\autodock.
   6. La estructura cristalina 3D de la enzyma aparecerá en la pantalla (3D viewer).
   7. Para visualizar, seleccionar o colorear la proteína, haga uso del tablero situado en la parte izquierda del visor 3D.
   8. Haga clic en el menú Edit > Hydrogens > Add: añada hidrógenos polares, fije el orden de los enlaces y renumere los residuos incluyendo los átomos de hidrógeno recién añadidos.
   9. Haga clic en el menú Edit > Charges > Add: añada cargas de Kollman. Éstas se derivan de la mecánica cuántica. Esto añade cargas parciales convenientes a la proteína.
   10. Haga clic en el menú Grid > Macromolecules > Choose and select target molecule y guárdelo bajo target.pdbqt en la misma carpeta donde creó target.pdb. Esto almacena las cargas parciales y los tipos de átomos de Autodock que son compatibles con la computación en grid de Autodock.


4. El proceso de creación de un ligand.pdbqt a partir de un archivo ligand.pdb (de estructura cristalina) consiste en los siguientes pasos.

   1. Click en Ligand > Input > Open seleccione ligand.pdb from folder: ~Desktop\autodock. Cambie el formato de .pdbqt to .pdb
   2. Click de nuevo en Ligand > Torsion Tree > Detect Root
   3. Click de nuevo en Ligand > Torsion Tree > Set Number of Torsions. Set number of active torsions between 1 to 6
   4. Click de nuevo en Ligand > Aromatic Carbons > Aromaticity Criterion. Define as 7.5
   5. Click de nuevo en Ligand > Output > Save as PDBQT

#### Preparación de los parameters de Grid

5. Abra el menú Grid en AutoDockTools para preparar los parámetros para los cálculos de Autogrid.
6. Haga clic en Set Map Types > Choose Ligand: seleccione y abra el archivo ligand.pdbqt guardado anteriormente (AutoGrid calcula mapas de cuadrícula de energías de interacción para varios tipos de átomos. Esto es importante para calibrar el procedimiento de docking).
7. Haga clic de nuevo en el menú Grid > Grid Box (Esto elegirá las coordenadas del sitio de unión para el motor de búsqueda. En nuestro caso, debe estar centrado en el ligando porque el sitio es conocido).
8. Centrar las coordenadas atómicas X, Y, Z en el ligando (En nuestro caso de estudio, el sitio de unión del ligando es conocido, sin embargo en otros casos la caja de grid puede ser aproximada).
9. En grid options box > File > Close guardando la opción actual. Esto guardará la caja de grid central.
10. Haga clic de nuevo en el menú Grid > Output > Save gpf. Guardar como dock.gpf. Esto crea un mapa de grid para cada tipo de átomo en el ligando más un mapa electrostático y un mapa de desolvatación (Guardar en el mismo directorio que los otros archivos pdbqt).

#### Preparación de los parameters para Docking

Abra el menú Docking en AutoDockTools para preparar los parámetros para Autodock:

11. Abra el menú Docking > Macromolecule > Set Rigid Filename > select target.pdbqt.
12. Click en Docking > Ligand > Choose > Choose > ligand (si el ligando en formato pdbqt está abierto en el visor).
13. Si no está en el visor, haga clic en Docking > open: elija la ubicación del archivo ligand.pdbqt.
14. En el Autodpf4 parameters box, click Accept Ligand Parameters.
15. Click en Docking > Search Parameters > Genetic Algorithm > Accept (Mantenemos los parámetros por defecto pero los usuarios avanzados pueden jugar con los ajustes).
16. Click en Docking > Docking Parameters > Accept
17. Click en Docking > Output > LamarkianGA algorithm > Save. Guarde el archivo como dock.dpf en el mismo directorio (~Desktop\autodock).

Ahora tienes todos los archivos necesarios para el docking (target.pdbqt, ligand.pdbqt, dock.gpf, dock.dpf).

#### Ejecutando autodock

Despues de descargar e instalar AutoDock

    Para usuarios de Windows, Start > Run y escriba "cmd.exe" luego escriba el commando: "C:\Program Files (x86)\The Scripps Research Institute\Autodock\4.2.6\autodock4.exe"
    
    Luego debería ver un mensaje como este:

```
C:\Users\mgl>"C:\Program Files\The Scripps
Research Institute\Autodock"\autodock4.exe
usage: AutoDock -p parameter_filename
-l log_filename
-k (Keep original residue numbers)
-i (Ignore header-checking)
-t (Parse the PDBQT file to check torsions,
then stop.)
-d (Increment debug level)
-C (Print copyright notice)
--version (Print autodock version)
--help (Display this message)
C:\Users\mgl>
```
    Para entornos operativos tipo Unix, los usuarios deben copiar el ejecutable en la carpeta usr/local/bin.

Start > Run y escriba "cmd.exe", cambie su directorio de trabajo a ~Desktop\autodock (usando el comando cd ).

Escriba en la consola: autogrid4.exe -p dock.gpf -l dock.glg &
Escriba en la consola: autodock4.exe -p dock.dpf -l dock.dlg &

Esto llevará algún tiempo, dependiendo de la capacidad de tu CPU y de tu memoria.

El archivo dlg contiene toda la información sobre las ejecuciones de acoplamiento, la energía de enlace estimada en Kcal/mol y otra información como la RMSD frente a la pose de enlace del cristal.

#### Analizando los resultados

Para analizar los resultados del docking, abra el menú Analyze.

1. Los resultados de docking se encuentran en el archivo de registro .dlg.
2. Abra el menú Analyze > Docking > Open > dock.dlg
3. Abra el menú Analyze > Conformations > Play. Esto muestra la conformación de 1 a 10 del ligando unido a la betalactamsa. La mejor conformación tiene una energía de unión (ΔG) de -5,75 kcal/mol y una constante de inhibición (Ki) de 60,87 µM y una RMSD (desviación cuadrática media de las posiciones atómicas) de la estructura de referencia de 1,22 Å. Esto demuestra que los resultados de Autodock son fiables y precisos (en el rango nanomolar para un inhibidor conocido). El docking y el cribado virtual serían una baza importante para identificar nuevos inhibidores de BACE1.

### Ejercicio 2. Docking con AutoDock vina.

Se han desarrollado dos métodos de acoplamiento en paralelo, para responder a dos necesidades diferentes. El desarrollo comenzó con AutoDock, y sigue siendo la plataforma de experimentación en métodos de acoplamiento. AutoDock Vina se desarrolló más recientemente para satisfacer la necesidad de un método de docking llave en mano que no requiriera amplios conocimientos expertos por parte de los usuarios1. Está altamente optimizado para realizar experimentos de docking utilizando métodos por defecto bien probados. Ambos métodos están actualmente disponibles de forma gratuita. AutoDock Vina es rápido y eficaz para la mayoría de los sistemas, mientras que AutoDock está disponible para los sistemas que requieren mejoras metodológicas adicionales.

Ambos métodos están diseñados como herramientas genéricas de acoplamiento computacional, aceptan archivos de coordenadas para el receptor y el ligando y predicen conformaciones acopladas óptimas. Normalmente, los usuarios parten de coordenadas del receptor obtenidas por cristalografía o espectroscopia de RMN, y de coordenadas del ligando generadas a partir de cadenas SMILES u otros métodos.[leer mas](https://doi.org/10.1038/nprot.2016.051)

Para este ejercicio usaremos Autodock vina

#### Setup

Autodock vina. Puede ser descargado [aqui](https://vina.scripps.edu/downloads/) 

