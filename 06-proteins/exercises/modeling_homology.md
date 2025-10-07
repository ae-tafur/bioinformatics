# Modelación por Homología

El término "modelamiento por homología", también conocido como comparativo o basado en plantilla (template-based modelling, TBM), consiste en modelar la estructura en 3D de una proteína utilizando a manera de molde otra estructura ya determinada experimentalmente. La estructura de la proteína es de gran ayuda en el estudio de su función, su dinámica, las interacciones con los ligandos y con otras proteínas. ([Chalarcá-Velez, J; Gaviviria, D; 2021](https://doi.org/10.18257/raccefyn.1154))

Existen diferentes software y servidores donde el proceso de modelación por homología se puede realizar (Chimera, [Swiss-Model](https://swissmodel.expasy.org), [Phyre2](http://www.sbg.bio.ic.ac.uk/~phyre2/html/page.cgi?id=index)), sin embargo en este modulo utilizaremos HHPred ([https://toolkit.tuebingen.mpg.de/tools/hhpred](https://toolkit.tuebingen.mpg.de/tools/hhpred))

Las siguientes opciones permiten restringir la búsqueda de puentes de hidrógeno:

### Ejercicio 1. Modelado mistery protein.

Luego de dos años y numerosos intentos fallidos, usted logra determinar por resonancia magnética nuclear una región de una proteína misteriosa y deposita la estructura en la base de datos de proteínas PDB (PDB: 1F46).

Años después ocurre una pandemia de una enfermedad respiratoria causada por *Actinobacillus pleuropneumoniae* que está causando un rápido aumento en la mortalidad de la población porcina, trayendo terribles consecuencias en la actividad económica mundial. Una vez que se logró aislar la cepa responsable, se cree que una proteína que comparte casi el 25 % de identidad con su proteína misteriosa es un posible blanco para el diseño de una droga. Sin embargo, se desconoce la estructura de la misma. Como usted es el único experto en esa proteína en el mundo, la Asociación del Centro Médico Epidemiológico (ACME) se pone en contacto con usted en busca de una solución. Para solucionar el problema, Ud. decide primero intentar un modelado por homología de la nueva proteína.

1. Ingrese la secuencia de la proteína misteriosa patogénica en [HHPred](https://toolkit.tuebingen.mpg.de/tools/hhpred)
   
    ```
    >Pathogenic Mistery Protein
    MELHILFFILAGLLIAVLISFSLWSARREKSRIFSNTFSTRPPSTPINNIVSDVPPSLNPQSYAQT
    TGQHGETEADNPVQIQQEVESSLREIKINLPGQDSAAYQSKVEETPIYSGQPVLPVQPQYQTQVQY
    QTQPQHIEPAFTQAPQSPIAEATSVLEQSVEELERQAAQGDVDIYSDASVRVELAKNSMQADSVAE
    QKPVAENNMLTLYVVAPEGQQFRGDYVVQSLEALGFQYGEYQIFHRHQHMGNSASPVIFSVANMMQ
    PGIFDLTKIEHFSTVGLVLFMHLPSEGNDVVNFKLLLKTTENLAQALGGFVLNEHREIFDENSRQS
    YLARVS
    ```

2.  Haga click en **Submit** en la parte inferior de la página y seleccione el hit que le parezca más conveniente:
    
    * ¿por qué es el más conveniente?
    * ¿Que e-value tiene?
    * ¿que porcentaje de identidad posee con su proteína misteriosa (en la pate inferior está el alineamiento)?
    
    Luego seleccione en la parte superior **Model using selection**.
    
    * ¿Qué se muestra en la nueva ventana? (Mueva la barra inferior para ver que hay en la ventana).

3. Haga click en **Forward to Modeller** y luego en **Submit**.
   
   !!! warning "Atencion"
   
        De ser necesario ingrese la siguiente key: **MODELIRANJE** en el recuadro que dice **Modeller key** y luego haga click en Submit.
    
    * ¿Qué aparece en la nueva ventana?

4. Descargue el archivo PDB (**Download PDB File**)

5. La herramienta **Verify3D** permite determinar la compatibilidad de un modelo 3D de una proteína con su secuencia aminoacídica en base a cuál es el ambiente en el cual se encuentra cada residuo y la compatibilidad con la estructura secundaria en la que se encuentra.
   
   Vaya a la web de [UCLA-DOE LAB](https://saves.mbi.ucla.edu/), suba el archivo PDB obtenido en el paso anterior y clickee en **Run programs**.
    
    * Seleccione **Verify3D** y espere por los resultados.
   
   El gráfico reporta la calidad del modelo por posición y en él se observan tres regiones:
   
   !!! Info
   
        * Posiciones con **score menor a cero** están **mal** modeladas,
        * Posiciones con **score entre cero y 0.1** están **pobremente** modeladas,
        * Posiciones con **score mayor a 0.1** están modeladas con **buena calidad**.
   
   **Verify 3D** asigna como aceptado a un modelo con más del 80% de las posiciones posiciones con un score promedio en el área **bien modelada**.
   
   Observe el resultado obtenido (Si tarda haga click en el botón *Check status*) y responda:
    
    * ¿Cuál es el porcentaje de residuos con un score promedio en el **área de bien modelados**?
    * ¿Qué región está **pobremente modelada** según **Verify 3D**?

6. La herramienta **Procheck** permite analizar la calidad de la geometría de los residuos en una estructura proteica dada en comparación a parámetros estereoquímicos derivados de estructuras tridimensionales de alta resolución ya conocidas.
   
   En la parte superior de la página de los resultados de **Verify 3D** vaya a **Control Panel**
   
   Seleccione **Procheck** y espere por los resultados.
    
    * Investigue el **Ramachandran Plot**. Reconozca las regiones a los distintos elementos de estructura secundaria y responda:
        * ¿Cuántas estructuras se utilizaron para construir este Ramachandran?
        * ¿Qué residuos no están en el área esperada?
        * ¿Qué criterio se utiliza para considerar que el modelo es de buena calidad?
        * ¿Qué porcentaje de residuos en la estructura modelada se encuentran en las regiones más favorecidas?
    
    * Investigue los gráficos de ramchandran para todos los residuos en **All Ramachandrans** debe elegir el pdf.
        * ¿Cuántas estructuras se utilizaron para construir este Ramachandran?
        * ¿Qué residuos no están en el área esperada?
    
    * Investigue los gráficos de las longitudes de enlace en la cadena principal (M/c bond lengths) y los ángulos de unión de la cadena principal (M/c bond angles).
        * ¿Existen aminoácidos que se alejen significativamente de los resultados esperados?

7. En base a los resultados obtenidos por **Verify 3D** y **ProCheck** responda: ¿Es bueno el modelo? ¿Por qué?

8. Abra chimera y busque el modelo que determinó usted años atrás:
   
   *File* → *Fetch by ID* → 1F46
   
   (¿Recuerda cómo hacerlo por la línea de comandos?)
   
   Si no funciona, el pdb se encuentra en su carpeta de datos y puede utilizar:
   
   *File → Open*

9. Luego, cargue en la misma ventana de Chimera la estructura de la proteína misteriosa patogénica
   
   *File → Open*

10. Para tener una noción de cuán similar es la estructura de dos proteínas, podemos realizar un **Alineamiento Estructural**, que consiste en superponer las estructuras de ambas proteínas en el espacio intentando alinear sus cadenas aminoacídicas. Alinear estructuras en chimera es muy fácil, sólo requiere un comando.
    
    Vaya a *Tools → Structure Comparison → MatchMaker*
    
    Se abrirá una nueva ventana.
    
    * En *Reference structure* (el panel de la izquierda) puede seleccionar una de las estructuras de referencia. Esta estructura es la que se mantendrá fija. (**Ej. 1F46**)
    
    * En *Structure(s) to match* (el panel de la derecha) seleccione la estructura que será superpuesta y alineada con la que se eligió como referencia. (Ej. el modelo)
    
    * En *Matching* asegurése que *Iterate by pruning long atom pairs untilo no pair exceeds* está clickeado.
    
    O bien, ingrese en la command line:
    
    ```
    mm #0 #1
    ```
    
    * Piense, ¿Porqué está utilizando el PDB:1F46?
    
    * Observe el resultado del alineamiento: ¿Son parecidas las estructuras? ¿En donde se observan las mayores diferencias?
    
    Vaya a *Favorites → Reply Log*
    
    * ¿Cuál es el RMSD global reportado?

11. Para ver cómo se corresponde el grado de similitud estructural con el grado de similitud en secuencia podemos realizar un alineamiento de ambas secuencias guiado por el alineamiento estructural. Para esto, vaya a:
    
    *Tools → Structure comparison → “Match->Align”*
    
    **Ahora, observando la estructura y el alineamiento responda:**
    
    **I.** ¿Qué son las regiones marcadas en rosa en el alineamiento?
    
    **II.** ¿Este alineamiento, identifica regiones que no alinean estructuralmente? ¿A qué se debe?
    
    **III.** En la parte superior de la ventana del alineamiento de secuencia vaya a **Headers** y seleccione RMSD:*ca*
    
    * ¿Qué regiones poseen mayor RMSD? ¿A qué elementos estructurales corresponden? Para responder esto, seleccione estas regiones con el mouse en el alineamiento y visualícelas en la estructura alineada.

12. Para cuantificar el alineamiento de secuencia obtenido, podemos calcular el % de identidad de secuencia. Para ello, en la ventana del alineamiento de secuencias vaya a:
    
    *Info → Percent identity*.
    
    Seleccione una estructura en *Compare* y la otra estructura en *with*. En *Divide by* seleccione *longer sequence length*. Presiona en Ok.
    
    * ¿Qué valor de identidad de secuencia obtiene? ¿Porque cree que difiere del reportado anteriormente?
    
    * En la parte superior de la ventana del alineamiento de secuencia vaya a Headers y seleccione *Conservation* ¿Las sustituciones observadas en las secuencias son conservativas?
    
    * En base a los resultados obtenidos. ¿Intentaría obtener experimentalmente la estructura de la nueva proteína, o confiaría en el modelo?

