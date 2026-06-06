# Módulo 7: Proteínas — De la Secuencia a la Estructura y Función

## Introducción

En los módulos anteriores aprendió a obtener y comparar secuencias de ácidos nucleicos, reconstruir genomas y anotarlos funcionalmente. Al final de ese proceso, la anotación genómica le asigna a cada gen un producto: una **proteína**. Pero saber el nombre de una proteína no es lo mismo que entender cómo funciona. Para eso necesita conocer su **estructura tridimensional**.

Las proteínas son las moléculas ejecutoras de la vida. Casi toda reacción bioquímica, señal celular, estructura mecánica y proceso de regulación depende de ellas. La bioinformática estructural nació precisamente de la necesidad de predecir, comparar y analizar estructuras proteicas a una escala que los métodos experimentales solos no pueden alcanzar.

Este módulo lo guiará desde los fundamentos químicos de las proteínas hasta las herramientas computacionales más modernas para predecir y analizar su estructura:

1. **Química de los aminoácidos** — los bloques que forman las proteínas.
2. **Código genético y síntesis de proteínas** — cómo la información genética se traduce en secuencia de aminoácidos.
3. **Niveles de estructura proteica** — de la cadena lineal al complejo tridimensional.
4. **Bases de datos de proteínas** — UniProt, PDB y cómo usarlas.
5. **Modelación por homología** — predecir estructura usando proteínas conocidas como molde.
6. **Modelación *ab initio*** — predicción de estructura desde la secuencia, incluyendo AlphaFold.
7. **Evaluación de modelos** — cómo saber si un modelo es confiable.
8. **Docking molecular** — cómo las proteínas interaccionan con ligandos.
9. **Dinámica molecular** — simular el movimiento de proteínas en el tiempo.

> [!NOTE]
> Este módulo requiere familiaridad con BLAST y alineamientos (Módulo 3), con búsqueda en bases de datos (Módulo 1) y con conceptos básicos de programación (Módulo 2). Las prácticas usan herramientas web que no requieren instalación local (salvo las de docking y MD).

---

## Prerrequisitos y conexión con módulos previos

### Del Módulo 1
- Búsqueda en NCBI y descarga de secuencias en formato FASTA/GenBank.
- Conceptos de gen, ORF y producto génico.

### Del Módulo 3
- Alineamiento global y local, identidad y similitud de secuencias.
- BLAST: cómo buscar secuencias similares en bases de datos.

### Del Módulo 6
- Anotación genómica: números EC, dominios proteicos (Pfam, InterPro).
- Concepto de gen anotado con producto funcional.

> [!NOTE]
> Si necesita repasar:
> - Módulo 1 → [README Módulo 1](../01-introduction/README.md)
> - Módulo 3 → [README Módulo 3](../03-sequence_analysis/README.md)
> - Módulo 6 → [README Módulo 6](../06-genomics/README.md)

---

## 1. Química de los Aminoácidos

### 1.1 ¿Qué es una proteína?

Una **proteína** es un polímero de **aminoácidos** unidos mediante enlaces peptídicos. Las proteínas son las moléculas más versátiles de la célula: catalizan reacciones (enzimas), transmiten señales (receptores), dan estructura (colágeno), transportan moléculas (hemoglobina), defienden al organismo (anticuerpos) y regulan la expresión génica (factores de transcripción).

```text
H2N — AA1 — CO — NH — AA2 — CO — NH — AA3 — CO — ... — COOH
            |                 |
       enlace peptídico   enlace peptídico
```

La secuencia de aminoácidos de una proteína determina completamente su estructura tridimensional y, por tanto, su función. Esta es la esencia del **dogma central de la biología estructural**, formulado por Anfinsen: *la información en la secuencia primaria es suficiente para determinar la estructura nativa*.

### 1.2 Estructura química de los aminoácidos

Todos los aminoácidos comparten una misma arquitectura central con **cuatro grupos** unidos al carbono α:

```text
        H
        |
H2N — C-alfa — COOH
        |
        R  <- cadena lateral (radical)
```

| Grupo                        | Símbolo   | Función biológica                                    |
|:-----------------------------|:---------:|:-----------------------------------------------------|
| **Amino**                    |   —NH₂    | Base débil; extremo N-terminal de la proteína        |
| **Carboxilo**                |   —COOH   | Ácido débil; extremo C-terminal de la proteína       |
| **Hidrógeno**                |    —H     | Completa la tetravalencia del carbono α              |
| **Cadena lateral (radical)** |    —R     | Define la identidad y propiedades de cada aminoácido |

> [!IMPORTANT]
> El carbono α es **quiral** en todos los aminoácidos excepto la glicina (que tiene dos hidrógenos). Esto genera los enantiómeros L y D. Solo los aminoácidos en configuración **L** se incorporan en proteínas naturales.

### 1.3 El enlace peptídico

Cuando dos aminoácidos se unen, el grupo carboxilo del primero reacciona con el grupo amino del segundo liberando agua:

```text
     O            H                     O   H   O
     ||            |                    ||   |   ||
 -C-OH   +   H2N-C-COOH   ->   -C -- N - C - COOH  +  H2O
                  |                         |
                  R1                        R2
                                  ^
                            enlace peptídico
                         (carácter parcial de doble enlace)
```

El enlace peptídico tiene **carácter parcial de doble enlace** por resonancia: esto lo hace **planar y rígido**, con restricciones a la rotación que son críticas para la estructura secundaria.

### 1.4 Los 20 aminoácidos estándar

Los 20 aminoácidos codificados genéticamente se clasifican según las propiedades de su cadena lateral:

#### Aminoácidos no polares (hidrofóbicos)

Se concentran en el **interior** de la proteína, alejados del agua:

| Aminoácido   | 3 letras   | 1 letra   | Cadena lateral                                         |
|:-------------|:----------:|:---------:|:-------------------------------------------------------|
| Glicina      |    Gly     |     G     | —H (sin cadena lateral real; máxima flexibilidad)      |
| Alanina      |    Ala     |     A     | —CH₃                                                   |
| Valina       |    Val     |     V     | —CH(CH₃)₂                                              |
| Leucina      |    Leu     |     L     | —CH₂CH(CH₃)₂                                           |
| Isoleucina   |    Ile     |     I     | —CH(CH₃)CH₂CH₃                                         |
| Prolina      |    Pro     |     P     | Cadena cíclica unida al N del backbone (rompe hélices) |
| Fenilalanina |    Phe     |     F     | —CH₂—anillo bencénico                                  |
| Triptófano   |    Trp     |     W     | —CH₂—indol (anillo bicíclico)                          |
| Metionina    |    Met     |     M     | —CH₂CH₂—S—CH₃ (también es el codón de inicio)          |

#### Aminoácidos polares sin carga (hidrofílicos)

Forman puentes de hidrógeno; aparecen en superficie y en sitios activos:

| Aminoácido | 3 letras   | 1 letra   | Cadena lateral                                    |
|:-----------|:----------:|:---------:|:--------------------------------------------------|
| Serina     |    Ser     |     S     | —CH₂—OH                                           |
| Treonina   |    Thr     |     T     | —CH(OH)—CH₃                                       |
| Cisteína   |    Cys     |     C     | —CH₂—SH (forma puentes disulfuro entre cisteínas) |
| Tirosina   |    Tyr     |     Y     | —CH₂—C₆H₄—OH (aromático + OH)                     |
| Asparagina |    Asn     |     N     | —CH₂—CO—NH₂                                       |
| Glutamina  |    Gln     |     Q     | —CH₂CH₂—CO—NH₂                                    |

#### Aminoácidos con carga positiva (básicos, hidrofílicos)

| Aminoácido | 3 letras   | 1 letra   |                    pKa aprox.                       |
|:-----------|:----------:|:---------:|:---------------------------------------------------:|
| Lisina     |    Lys     |     K     |      ~10.5 — cargado positivo a pH fisiológico      |
| Arginina   |    Arg     |     R     |          ~12.5 — siempre cargado positivo           |
| Histidina  |    His     |     H     | ~6.0 — puede actuar como ácido o base cerca de pH 7 |

#### Aminoácidos con carga negativa (ácidos, hidrofílicos)

| Aminoácido      | 3 letras   | 1 letra   | Nota                                         |
|:----------------|:----------:|:---------:|:---------------------------------------------|
| Ácido aspártico |    Asp     |     D     | pKa ~3.9 — cargado negativo a pH fisiológico |
| Ácido glutámico |    Glu     |     E     | pKa ~4.1 — cargado negativo a pH fisiológico |

> [!TIP]
> **Truco mnemotécnico para los tipos:** Los aminoácidos con cadenas carbónicas largas sin grupos funcionales polares son hidrofóbicos (Val, Leu, Ile, Phe, Trp). Los que tienen —OH, —SH, —NH₂, o grupos iónicos son hidrofílicos. La posición de un residuo en la estructura (superficie vs. núcleo) refleja directamente su carácter.

---

## 2. Código Genético

### 2.1 Del ARNm a la proteína

La **traducción** convierte la secuencia de nucleótidos del ARNm en una secuencia de aminoácidos. La regla de correspondencia se llama **código genético**.

- Usa **codones**: tripletes de nucleótidos. Con 4 bases y tripletes → 4³ = **64 codones** posibles.
- Solo hay **20 aminoácidos** estándar + **3 codones de parada** (UAA, UAG, UGA).
- El código es **degenerado**: varios codones codifican el mismo aminoácido.
- El código es casi **universal** (con excepciones en mitocondrias y algunos protistas).

### 2.2 Tabla del código genético estándar

| 1ª pos. | 2ª pos. **U**   | 2ª pos. **C** | 2ª pos. **A**  | 2ª pos. **G**  | 3ª pos.  |
|:-------:|:----------------|:--------------|:---------------|:---------------|:--------:|
|  **U**  | UUU — Phe (F)   | UCU — Ser (S) | UAU — Tyr (Y)  | UGU — Cys (C)  |    U     |
|  **U**  | UUC — Phe (F)   | UCC — Ser (S) | UAC — Tyr (Y)  | UGC — Cys (C)  |    C     |
|  **U**  | UUA — Leu (L)   | UCA — Ser (S) | UAA — **STOP** | UGA — **STOP** |    A     |
|  **U**  | UUG — Leu (L)   | UCG — Ser (S) | UAG — **STOP** | UGG — Trp (W)  |    G     |
|  **C**  | CUU — Leu (L)   | CCU — Pro (P) | CAU — His (H)  | CGU — Arg (R)  |    U     |
|  **C**  | CUC — Leu (L)   | CCC — Pro (P) | CAC — His (H)  | CGC — Arg (R)  |    C     |
|  **C**  | CUA — Leu (L)   | CCA — Pro (P) | CAA — Gln (Q)  | CGA — Arg (R)  |    A     |
|  **C**  | CUG — Leu (L)   | CCG — Pro (P) | CAG — Gln (Q)  | CGG — Arg (R)  |    G     |
|  **A**  | AUU — Ile (I)   | ACU — Thr (T) | AAU — Asn (N)  | AGU — Ser (S)  |    U     |
|  **A**  | AUC — Ile (I)   | ACC — Thr (T) | AAC — Asn (N)  | AGC — Ser (S)  |    C     |
|  **A**  | AUA — Ile (I)   | ACA — Thr (T) | AAA — Lys (K)  | AGA — Arg (R)  |    A     |
|  **A**  | AUG — Met (M) ⭐ | ACG — Thr (T) | AAG — Lys (K)  | AGG — Arg (R)  |    G     |
|  **G**  | GUU — Val (V)   | GCU — Ala (A) | GAU — Asp (D)  | GGU — Gly (G)  |    U     |
|  **G**  | GUC — Val (V)   | GCC — Ala (A) | GAC — Asp (D)  | GGC — Gly (G)  |    C     |
|  **G**  | GUA — Val (V)   | GCA — Ala (A) | GAA — Glu (E)  | GGA — Gly (G)  |    A     |
|  **G**  | GUG — Val (V)   | GCG — Ala (A) | GAG — Glu (E)  | GGG — Gly (G)  |    G     |

> ⭐ AUG es el único **codón de inicio** en el código estándar (además de codificar Met). Los tres **STOP** son UAA (*ochre*), UAG (*amber*) y UGA (*opal*).

### 2.3 Degeneración del código genético

| Aminoácido   | N.º de codones   | Codones                             |
|:-------------|:----------------:|:------------------------------------|
| Met (M)      |        1         | AUG (también es el codón de inicio) |
| Trp (W)      |        1         | UGG                                 |
| Leu (L)      |        6         | UUA, UUG, CUU, CUC, CUA, CUG        |
| Ser (S)      |        6         | UCU, UCC, UCA, UCG, AGU, AGC        |
| Arg (R)      |        6         | CGU, CGC, CGA, CGG, AGA, AGG        |

> [!NOTE]
> La mayoría de la redundancia ocurre en la **tercera posición del codón** (posición *wobble* o de tambaleo). Muchas mutaciones en esa posición son **sinónimas** (no cambian el aminoácido) y por tanto **neutrales** a nivel de la proteína — una ventaja evolutiva que permite acumular diversidad genética sin alterar la función.

---

## 3. Niveles de Estructura Proteica

La estructura de una proteína se organiza en **cuatro niveles jerárquicos**:

### 3.1 Estructura primaria

La secuencia lineal de aminoácidos leída del extremo **N-terminal** al **C-terminal**:

```text
H2N — Met — Ala — Gly — Lys — Phe — Trp — ... — COOH
       |                                    |
   N-terminal                           C-terminal
```

La estructura primaria está codificada en el ADN y **contiene toda la información necesaria** para el plegamiento espontáneo en condiciones fisiológicas.

### 3.2 Estructura secundaria

Patrones regulares de plegamiento local estabilizados por **puentes de hidrógeno** entre grupos del esqueleto peptídico (NH···O=C). Las cadenas laterales no participan directamente en la estructura secundaria.

#### α-hélice

```text
  ->  3.6 residuos por vuelta completa
  ->  Puente de H entre residuo i y residuo i+4
  ->  Cadenas laterales apuntan hacia fuera
  ->  Paso de 5.4 Å por vuelta
```

Estabilizada principalmente por **puentes de hidrógeno** paralelos al eje de la hélice. Es la estructura secundaria más común en las proteínas.

#### Hoja β (lámina β)

```text
  Paralela:           ->  ->  ->  (misma dirección)
  Antiparalela:       ->  <-  ->  (alternando dirección)
```

Las cadenas están casi completamente extendidas (~3.5 Å por residuo). Los puentes de hidrógeno son perpendiculares a la dirección de las cadenas. La hoja antiparalela suele ser más estable.

#### Lazos y giros (*loops* y *turns*)

Regiones que conectan hélices y hojas β sin patrón repetitivo. Frecuentemente localizadas en la **superficie** de la proteína donde participan en el reconocimiento de ligandos y otras proteínas.

### 3.3 Estructura terciaria

La disposición tridimensional **completa** de todos los átomos de una cadena polipeptídica. Estabilizada por múltiples interacciones:

| Interacción                  | Descripción                                            |                  Importancia                  |
|:-----------------------------|:-------------------------------------------------------|:---------------------------------------------:|
| **Efecto hidrofóbico**       | Agrupamiento de residuos no polares en el interior     |          ⭐⭐⭐⭐⭐ (mayor contribución)           |
| **Puentes de hidrógeno**     | Entre grupos donadores y aceptores (cadenas laterales) |                     ⭐⭐⭐⭐                      |
| **Interacciones iónicas**    | Entre grupos cargados opuestamente (sal bridges)       |                      ⭐⭐⭐                      |
| **Fuerzas de van der Waals** | Atracciones entre dipolos transitorios                 |                      ⭐⭐                       |
| **Puentes disulfuro**        | Enlace covalente —S—S— entre dos cisteínas             | ⭐⭐⭐ (estabilidad en proteínas extracelulares) |

> [!IMPORTANT]
> El **efecto hidrofóbico** es el principal motor del plegamiento: los residuos no polares se agrupan en el interior de la proteína para minimizar su contacto con el agua. Este proceso es termodinámicamente favorable porque **aumenta la entropía del agua** (las moléculas de agua estructuradas alrededor de residuos hidrofóbicos quedan liberadas).

### 3.4 Estructura cuaternaria

Organización de **múltiples cadenas polipeptídicas** (subunidades) en un complejo funcional. No todas las proteínas tienen este nivel de organización.

```text
  Ejemplo: Hemoglobina (tetrámero)

      alfa1   beta1
          \   /
           [H]    <- grupo hemo (cofactor)
          /   \
      beta2   alfa2
```

| Término                       | Definición                                                                                  |
|:------------------------------|:--------------------------------------------------------------------------------------------|
| **Monómero**                  | Una sola cadena polipeptídica                                                               |
| **Homodímero**                | Dos subunidades idénticas                                                                   |
| **Heterodímero**              | Dos subunidades diferentes                                                                  |
| **Tetrámero**                 | Cuatro subunidades (ej. hemoglobina, ADN polimerasa)                                        |
| **Cooperatividad alostérica** | El cambio conformacional en una subunidad afecta las demás (ej. unión de O₂ en hemoglobina) |

---

## 4. Bases de Datos de Proteínas

### 4.1 UniProt — Secuencias y anotaciones

La **Universal Protein Resource (UniProt)** ([uniprot.org](https://www.uniprot.org)) es la base de datos más completa de secuencias y anotaciones proteicas.

| Recurso                  | Descripción                                       | Revisado manualmente   |
|:-------------------------|:--------------------------------------------------|:----------------------:|
| **UniProtKB/Swiss-Prot** | Secuencias con anotación manual experta           |           ✅            |
| **UniProtKB/TrEMBL**     | Secuencias con anotación automática               |           ❌            |
| **UniRef100**            | Clusters de secuencias idénticas                  |           —            |
| **UniRef90**             | Clusters al 90% de identidad                      |           —            |
| **UniRef50**             | Clusters al 50% de identidad                      |           —            |
| **UniParc**              | Archivo de todas las secuencias únicas reportadas |           —            |

> [!NOTE]
> **CDS vs. ORF:** Una secuencia codificante (CDS) es una región de ADN o ARN cuya secuencia determina la secuencia de aminoácidos en una proteína. No se debe confundir con un marco abierto de lectura (ORF): todos los CDS son ORFs, pero no todos los ORFs son CDS (los ORFs incluyen intrones en eucariotas). UniProt almacena las secuencias de las proteínas maduras derivadas de CDS verificados.

**Contenido de una entrada UniProt:**
- Secuencia canónica e isoformas (producto de splicing alternativo)
- Función molecular y proceso biológico
- Localización subcelular
- Dominios, sitios funcionales y motivos
- Modificaciones post-traduccionales (fosforilación, glicosilación, etc.)
- Estructuras 3D disponibles (IDs de PDB)
- Variantes de secuencia y mutaciones
- Literatura asociada

### 4.2 PDB — Estructuras 3D experimentales

El **Protein Data Bank (PDB)** ([rcsb.org](https://www.rcsb.org)) es el repositorio global de estructuras 3D de macromoléculas biológicas determinadas experimentalmente.

| Método                        | Resolución típica   | Fracción del PDB   | Ventajas                              |
|:------------------------------|:-------------------:|:------------------:|:--------------------------------------|
| **Cristalografía de rayos X** |        1–3 Å        |        ~85%        | Alta resolución, proteínas grandes    |
| **RMN**                       |          —          |        ~8%         | Proteínas en solución, flexibilidad   |
| **Cryo-EM**                   |        2–4 Å        |  ~7% y creciendo   | Complejos grandes, sin cristalización |

El archivo PDB (`.pdb` / `.cif`) contiene coordenadas atómicas (x, y, z) para cada átomo, factores B (temperatura/incertidumbre), ligandos, cofactores y agua de cristalización.

### 4.3 AlphaFold DB y otras bases de datos

| Base de datos    | URL                    | Contenido                                      |
|:-----------------|:-----------------------|:-----------------------------------------------|
| **AlphaFold DB** | alphafold.ebi.ac.uk    | ~200M estructuras predichas por AF2            |
| **InterPro**     | interpro.ebi.ac.uk     | Dominios proteicos: Pfam, SMART, PROSITE, etc. |
| **SCOP2**        | scop.mrc-lmb.cam.ac.uk | Clasificación estructural evolutiva            |
| **CATH**         | cathdb.info            | Clasificación por arquitectura y topología     |
| **DrugBank**     | drugbank.ca            | Proteínas diana de fármacos conocidos          |

---

## 5. Alineamiento de Secuencias Proteicas

### 5.1 Identidad vs. Similitud

| Métrica       | Definición                                                             | Ejemplo                                 |
|:--------------|:-----------------------------------------------------------------------|:----------------------------------------|
| **Identidad** | Posiciones con exactamente el mismo aminoácido                         | Ala ≡ Ala                               |
| **Similitud** | Posiciones con aminoácidos iguales **o** conservativamente sustituidos | Asp ≈ Glu (ambos ácidos, carga similar) |

> [!IMPORTANT]
> **Regla práctica de identidad estructural:**
> - **> 50%** → estructuras casi idénticas; molde confiable para homología
> - **30–50%** → estructuras probablemente similares
> - **20–30%** → zona gris ("*twilight zone*")
> - **< 20%** → no es posible inferir similitud estructural solo por secuencia

### 5.2 Matrices de sustitución

Las **matrices de sustitución** (PAM, BLOSUM) cuantifican la probabilidad de que un aminoácido sea reemplazado por otro durante la evolución. Un valor positivo = sustitución conservativa; negativo = sustitución no conservativa.

- **BLOSUM62**: estándar para búsquedas generales con BLAST (construida de alineamientos con ~62% identidad)
- **BLOSUM45**: más sensible para proteínas divergentes
- **PAM250**: adecuada para proteínas muy divergentes

### 5.3 Alineamiento global vs. local en proteínas

| Tipo                   | Algoritmo         | Cuándo usar                                                  |
|:-----------------------|:------------------|:-------------------------------------------------------------|
| **Global**             | Needleman-Wunsch  | Proteínas de longitud similar y alta identidad global        |
| **Local**              | Smith-Waterman    | Buscar dominios conservados en proteínas de diferente tamaño |
| **BLAST** (heurístico) | BLAST             | Búsqueda rápida en bases de datos (proteinBLAST, pBLAST)     |
| **Perfil HMM**         | HHpred, jackHMMer | Detectar homologías muy remotas (< 20% identidad)            |

---

## 6. Modelación por Homología

### 6.1 Fundamento y flujo de trabajo

La **modelación por homología** (comparative modeling, template-based modeling) predice la estructura 3D de una proteína query usando como molde la estructura experimental de una proteína homóloga (template):

```text
1. Obtener secuencia query (FASTA)
         |
2. Buscar template en PDB (BLAST-PDB, HHpred)
         |
3. Evaluar: cobertura, % identidad, resolución del template
         |
4. Alinear query vs. template (alineamiento par o múltiple)
         |
5. Construir modelo (copiar backbone; modelar loops y cadenas laterales)
         |
6. Refinar (minimización de energía)
         |
7. Evaluar calidad (Ramachandran, Verify3D, ERRAT)
         |
8. Analizar / usar para docking
```

### 6.2 Herramientas de modelación por homología

| Servidor/Software   | URL                      | Descripción                                                         |
|:--------------------|:-------------------------|:--------------------------------------------------------------------|
| **Swiss-Model**     | swissmodel.expasy.org    | Servidor automático más usado; busca template y construye el modelo |
| **HHpred**          | toolkit.tuebingen.mpg.de | Búsqueda sensible HMM vs. HMM + usa Modeller para construir         |
| **Phyre2**          | sbg.bio.ic.ac.uk/phyre2  | Alternativa automática; bueno para baja identidad                   |
| **Modeller**        | salilab.org/modeller     | Software standalone con máximo control                              |

> [!NOTE]
> **HHpred** compara perfiles HMM contra perfiles HMM — mucho más sensible que BLAST para detectar relaciones evolutivas remotas con identidades tan bajas como 10–15%.

---

## 7. Modelación *Ab Initio* y AlphaFold

### 7.1 AlphaFold2 — La revolución en predicción de estructuras

En 2021, **AlphaFold2** (DeepMind) resolvió el problema del plegamiento de proteínas con precisión sin precedentes. Usa una arquitectura de red neuronal profunda:

```text
Secuencia de aminoácidos
         |
Búsqueda MSA (MMseqs2 / jackHMMer) + templates del PDB
         |
Módulo Evoformer (itera sobre MSA y representación de pares de residuos)
         |
Módulo estructural (genera coordenadas 3D atómicas)
         |
Estructura 3D predicha + métricas de confianza
```

#### Métricas de confianza de AlphaFold2

| Métrica   |      Rango        | Interpretación                                                                                                                |
|:----------|:-----------------:|:------------------------------------------------------------------------------------------------------------------------------|
| **pLDDT** | 0–100 por residuo | > 90: azul oscuro (muy alta). 70–90: azul claro (buena). 50–70: amarillo (baja). < 50: naranja (muy baja / probable desorden) |
| **PAE**   |       0–∞ Å       | Error en posición relativa de pares de residuos. Bajo = relación espacial confiable; permite identificar dominios             |

> [!WARNING]
> Regiones con **pLDDT < 50** frecuentemente corresponden a regiones **intrínsecamente desordenadas (IDRs)**. No es un error de predicción; refleja que esa región genuinamente carece de estructura definida en solución.

#### Acceso a AlphaFold

| Opción           | URL                       | Descripción                                                   |
|:-----------------|:--------------------------|:--------------------------------------------------------------|
| **AlphaFold DB** | alphafold.ebi.ac.uk       | Estructura ya predicha para ~200M proteínas                   |
| **ColabFold**    | colab.research.google.com | Corre AF2 en GPU gratuita de Google; para proteínas < 1000 aa |
| **ESMFold**      | esmatlas.com              | Predicción ultrarrápida sin MSA (Meta AI)                     |

---

## 8. Evaluación de la Calidad de Modelos Proteicos

### 8.1 Diagrama de Ramachandran

El **diagrama de Ramachandran** grafica los ángulos diedros del esqueleto proteico para cada residuo:
- **φ (phi)**: ángulo de rotación alrededor del enlace N–Cα
- **ψ (psi)**: ángulo de rotación alrededor del enlace Cα–C(carbonilo)

```text
ψ
180 |
    |    [hoja-beta]
    |    ######
    |
  0 |              [alfa-helix]
    |              ######
    |
-180|_________________________
    -180          0         180
                              φ

###### = Regiones favorecidas
        (hélices alfa y hojas beta)
```

**Criterios de calidad (PROCHECK):**

| Porcentaje en regiones favorecidas   | Calidad                                                         |
|:------------------------------------:|:----------------------------------------------------------------|
|                > 90%                 | Muy buena — estructuras de alta resolución o modelos excelentes |
|                80–90%                | Aceptable — modelos de homología razonables                     |
|                < 80%                 | Pobre — revisar el modelo; posibles errores estructurales       |

### 8.2 Otras métricas de calidad

| Herramienta               | ¿Qué mide?                                            | Umbral de aceptación              |
|:--------------------------|:------------------------------------------------------|:----------------------------------|
| **Verify3D**              | Compatibilidad entre cada residuo y su entorno 3D     | > 80% de residuos con score > 0.1 |
| **ERRAT**                 | Calidad de las interacciones no-enlazantes por región | > 50 (mejor cuanto más alto)      |
| **MolProbity**            | Choques estéricos, geometría de cadena, rotámeros     | Puntuación MolProbity baja        |
| **DOPE score** (Modeller) | Energía estadística del modelo                        | Más negativo = mejor              |

### 8.3 Minimización de energía

Después de modelar, se realiza **minimización de energía** para:
- Eliminar choques estéricos (átomos demasiado cercanos)
- Optimizar geometría de enlaces
- Mejorar posiciones de cadenas laterales

Herramientas: GROMACS, AMBER, CHARMM, o la opción de relajación con Amber que incluye ColabFold.

> [!TIP]
> Antes de usar un modelo para docking o análisis funcional, verifique siempre:
> 1. ¿Ramachandran > 90% en regiones favorecidas? → Geometría correcta
> 2. ¿Verify3D > 80%? → Compatibilidad secuencia-estructura
> 3. ¿pLDDT > 70 en las regiones de interés (si es AlphaFold)? → Confianza local alta

---

## 9. Docking Molecular

### 9.1 ¿Qué es el docking molecular?

El **docking molecular** es una técnica computacional que predice la **pose de unión** (orientación y conformación) más favorable de una molécula pequeña (ligando) dentro del sitio de unión de una proteína (receptor).

```text
  Receptor (proteina)         Ligando

      ___________
     |    (  )   |    +      O==C-NH
     |___________|               |
                                 C6H5
             |
             v  Docking
             |
      ___________
     |    (O==C) |    <- ligando en sitio de unión
     |___________|
```

### 9.2 Algoritmos y herramientas principales

| Herramienta             |    Acceso      | Algoritmo                | Notas                              |
|:------------------------|:--------------:|:-------------------------|:-----------------------------------|
| **AutoDock Vina**       | Gratuito/local | Quasi-Newton + gradiente | El más usado en academia           |
| **AutoDock4**           | Gratuito/local | Lamarckian GA            | Más opciones de configuración      |
| **SwissDock**           |  Servidor web  | EADock DSS               | Fácil para principiantes           |
| **DockThor**            |  Servidor web  | Evolución diferencial    | Libre y sin instalación            |
| **Glide** (Schrödinger) |   Comercial    | SP / XP modes            | Estándar en industria farmacéutica |

### 9.3 Interpretación del scoring

```text
ΔG de unión estimado (kcal/mol):

  Pose 1: -9.2 kcal/mol  <- MEJOR (más negativo = mayor afinidad)
  Pose 2: -7.8 kcal/mol
  Pose 3: -5.3 kcal/mol  <- Menor afinidad predicha

  Ki estimado ≈ e^(ΔG / RT)  (R = 0.00198 kcal/mol·K, T = 298 K)
```

> [!WARNING]
> Las puntuaciones de docking son **estimaciones semicualitativas**. Sirven para ranquear candidatos pero **no son predicciones cuantitativas exactas**. Todo resultado de docking debe validarse experimentalmente (IC50, SPR, ITC, etc.).

---

## 10. Dinámica Molecular

### 10.1 ¿Qué es la dinámica molecular?

La **dinámica molecular (MD)** simula el movimiento atómico de una proteína (y el solvente) en el tiempo siguiendo la segunda ley de Newton:

$$\mathbf{F} = m \cdot \mathbf{a} = -\nabla U(\mathbf{r})$$

Donde $U$ es la energía potencial calculada por un **campo de fuerza** (AMBER, CHARMM, GROMOS) que describe energías de enlace, ángulo, diedro, cargas electrostáticas y van der Waals.

### 10.2 Escalas de tiempo y fenómenos accesibles

|        Escala           | Fenómenos observables                                      |
|:-----------------------:|:-----------------------------------------------------------|
| Femtosegundos (10⁻¹⁵ s) | Vibraciones de enlace; paso de integración estándar (2 fs) |
| Picosegundos (10⁻¹² s)  | Movimiento de cadenas laterales, agua                      |
|  Nanosegundos (10⁻⁹ s)  | Rotación de dominios, unión de ligandos pequeños           |
| Microsegundos (10⁻⁶ s)  | Plegamiento de proteínas pequeñas                          |
|  Milisegundos (10⁻³ s)  | Cambios conformacionales lentos (enzimas, canales iónicos) |

### 10.3 Flujo de trabajo de MD

| Paso   | Descripción                                                   |
|:------:|:--------------------------------------------------------------|
|   1    | Preparar sistema: añadir hidrógenos, cargas, caja de solvente |
|   2    | Minimización de energía                                       |
|   3    | Equilibración NVT (temperatura constante)                     |
|   4    | Equilibración NPT (presión constante)                         |
|   5    | Producción (simulación real)                                  |
|   6    | Análisis: RMSD, RMSF, PCA, MM-GBSA                            |

**Software principal:** GROMACS, AMBER, NAMD, OpenMM (Python)

---

## Resumen del Módulo

| Concepto clave               | Lo esencial                                                                                                              |
|:-----------------------------|:-------------------------------------------------------------------------------------------------------------------------|
| **Aminoácidos**              | 20 tipos clasificados por su cadena lateral (hidrofóbicos, polares, cargados). El grupo R define identidad y propiedades |
| **Código genético**          | 64 codones para 20 aa + 3 stops. Degenerado: varios codones por aminoácido. Casi universal                               |
| **Estructura proteica**      | 4 niveles: primaria (secuencia) → secundaria (hélices, hojas β) → terciaria (3D una cadena) → cuaternaria (complejo)     |
| **UniProt**                  | Secuencias con anotación manual (Swiss-Prot) y automática (TrEMBL). Referencia de función y estructura                   |
| **PDB**                      | Coordenadas atómicas 3D de estructuras experimentales. Archivos PDB/mmCIF                                                |
| **Identidad vs. similitud**  | Identidad = mismo aa. Similitud = mismo o conservativo. Regla: >30% identidad → modelación por homología viable          |
| **Modelación por homología** | Usa un template experimental como molde. Swiss-Model, HHpred + Modeller. Requiere >20–30% identidad                      |
| **AlphaFold2**               | Predicción ab initio de alta precisión. pLDDT < 50 → posible desorden. ColabFold para correr gratis                      |
| **Ramachandran**             | Valida geometría del esqueleto. >90% en regiones favorecidas = modelo bueno                                              |
| **Docking**                  | Predice pose de unión ligando-proteína. Scores en kcal/mol; siempre validar experimentalmente                            |
| **Dinámica molecular**       | Simula movimiento atómico en el tiempo. Escala de nanosegundos accesible en GPU modernas                                 |

---

## Prácticas del Módulo

| Práctica                                                                                 | Descripción                                                                                   |
|:-----------------------------------------------------------------------------------------|:----------------------------------------------------------------------------------------------|
| [01 — Bases de datos de proteínas](exercises/01_protein_databases.md)                    | Exploración de UniProt, PDB, Pfam e InterPro; búsqueda y descarga de secuencias y estructuras |
| [02 — Visualización de proteínas](exercises/02_protein_visualization.md)                 | Visualizar y analizar estructuras 3D con ChimeraX                                             |
| [03 — Predicción ab initio (AlphaFold2)](exercises/03_structure_prediction_ab_initio.md) | Predicción de estructura con ColabFold; interpretación de pLDDT y PAE                         |
| [04 — Docking con servidores web](exercises/04_homology_docking_server.md)               | Docking en línea usando servidores web sin instalación                                        |
| [05 — Modelación por homología](exercises/05_modeling_homology.md)                       | Construcción de modelos con HHpred + Modeller; evaluación con Ramachandran y Verify3D         |
| [06 — Docking molecular (AutoDock)](exercises/06_molecular_docking.md)                   | Docking con AutoDock4/Vina; preparación de receptor y ligando; análisis de poses              |
| [07 — Dinámica molecular](exercises/07_molecular_dynamics.md)                            | Simulación MD básica con GROMACS/OpenMM; análisis de RMSD y flexibilidad                      |

