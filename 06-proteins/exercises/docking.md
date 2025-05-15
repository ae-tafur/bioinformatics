# Modelado por homologia

El modelado por homología es una técnica utilizada para predecir la estructura tridimensional de una proteína a partir de su secuencia de aminoácidos. Esta técnica se basa en la premisa de que las proteínas con secuencias similares suelen tener estructuras tridimensionales similares. A continuación, se describen los pasos para realizar el modelado por homología utilizando el servidor Swiss-Model:

1. Vaya al sitio [swissmodel](https://swissmodel.expasy.org)

2. De click en ```startmodeling```

3. En el promt pegue la secuencia de la proteina de la cual quiere predecir su estructura tridimensional

4. Defina un titulo para el trabajo y si lo desea puede escribir un correo para ser notificado cual es trabajo termine, esto puede tomar algunos minutos dependiendo del servidor y la lista de espera.

5. El proceso de modelación por homologia necesita una plantilla molde. Para esto de clic en ```templates```, para que se realice una busqueda de posibles plantillas. En la parte inferior de la página se mostrará una lista de plantillas que pueden ser utilizadas para modelar la proteína. De clic en ```select``` para elegir la plantilla que más le convenga. Si no encuentra una plantilla adecuada, puede intentar con otra secuencia o buscar en otras bases de datos. Haga una consulta en la sección de ayuda para del servidor para mas información sobre las metricas de calidad de las plantillas.

6. Una vez que haya elegido la plantilla, de clic en ```build models``` para iniciar el proceso de modelación por homologia. El servidor generará un modelo tridimensional de la proteína basado en la plantilla seleccionada.

7. Una vez que el modelo esté listo, podrá descargarlo en formato PDB. De clic en ```download``` para descargar el archivo. Si desea, puede visualizar el modelo en el servidor utilizando el visor de estructuras 3D. De clic en 'view' para abrir el visor y explorar la estructura tridimensional del modelo. Revise que tan parecido es su modelo con el molde, si no es parecido, intente con otro molde o secuencia. Si el modelo es bueno, puede proceder a realizar el docking.

# Docking

El docking es una técnica utilizada para predecir la interacción entre dos moléculas, como una proteína y un ligando. Esta técnica se basa en la premisa de que las moléculas que interactúan suelen tener formas complementarias. A continuación, se describen los pasos para realizar el docking utilizando el software AutoDock Vina en el servidor [SwissDock](https://www.swissdock.ch):

1. Vaya al sitio [SwissDock](https://www.swissdock.ch)

2. De clic en ```start docking```. En la parte inferior de la página, encontrará un formulario para cargar los archivos necesarios para el docking.

3. Para realizar el docking vamos a usar dos archivos, el primero es el archivo PDB de la proteína y el segundo es el archivo PDBQT del ligando. Usualmente es necesario convertir el archivo PDB del ligando a PDBQT. Para esto puede usar el software Open Babel o el servidor [Open Babel](http://openbabel.org/wiki/Main_Page). Si no tiene el archivo PDBQT del ligando, puede buscarlo en la base de datos [ZINC](http://zinc.docking.org/) o en la base de datos [PubChem](https://pubchem.ncbi.nlm.nih.gov/).

4. Vamos a descargar la proteina y el ligando que vamos a utilizar. La estructura cristalizada de Imipenem-hydrolyzing beta-lactamase SME-1 (1DY6) se puede descargar del [Protein Data Bank](http://www.rcsb.org). La estructura de imipenem-hydrolyzing beta-lactamase SME-1 descargada tiene dos cadenas, puede eliminar una pues el imipenem puede interactuar con cualquiera de las dos cadenas, hagalo en Chimera. Esta tiene 267 residuos de aminoácidos y el monómero tiene una resolución de 2,13 Angstroms. Puede obtener el ligando (Imipenem) de las dos mayores bases de datos, [drugbank](http://www.drugbank.ca/) o [pubchem](http://pubchem.ncbi.nlm.nih.gov/), descarguelo y luego abralo en Chimera y guardelo en formato .pdb. Tambien puede ingresar el smiles de imipinen observado en pubchem y pegarlo en el servidor SwissDock, el servidor lo convertira a pdbqt o el pdb ID de la proteina y el servidor se encargara de procesarlo, recuerde seleccionar solo una cadena, la A o la B, no conserve ningun heteroatom, ni agua, ni iones, ni ligandos. Si el ligando tiene un heteroatom, como un ion de zinc o un grupo sulfato.

    **Nota**: Se recomienda a los usuarios que regeneren los archivos target.pdb y ligand.pdb utilizando el [Swiss-PdbViewer](http://spdbv.unil.ch/), cuando se elimina desde chimera.

4. De clic en ```prepare ligand``` o ```prepare target``` luego de cargar el archivo PDB de la proteína y el archivo PDBQT del ligando.

5. Luedo defina el espacio de busqueda, el tamaño del grid y el centro del grid. El tamaño del grid debe ser lo suficientemente grande para cubrir toda la proteína y el ligando, en este caso usaremos 30Å. El centro del grid debe estar centrado en la región donde se espera que ocurra la interacción entre la proteína y el ligando.

6. Finalmente, escriba un nombre para su trabajo y escriba un correo electrónico para recibir notificaciones sobre el estado de su trabajo. De clic en ```start docking``` para iniciar el proceso de docking. El servidor generará un archivo con los resultados del docking, que podrá descargar en formato PDBQT.

