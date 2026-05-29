%[text] # 🧬 Práctica: Construcción de un Modelo COBRA desde Cero
%[text] 
%[text] ## Introducción
%[text] En esta práctica, usted aprenderá a \*\*construir un modelo metabólico COBRA (Constraint-Based Reconstruction and Analysis) de forma programática\*\* utilizando MATLAB.
%[text] 
%[text] En los módulos previos, usted aprendió a:
%[text] -  - Buscar y descargar secuencias de genes (Módulo 1 y 3)
%[text] -  - Anotar genomas e identificar genes funcionales (Módulo 6)
%[text] -  - Alinear y comparar secuencias homólogas (Módulo 3 y 4) \
%[text] Ahora, el siguiente paso natural es: **¿Cómo conectamos los genes anotados con la biología metabólica celular?.** La respuesta es mediante **modelos metabólicos a escala genómica (GEM)**. Un GEM es una representación matemática del metabolismo celular que integra:
%[text] - - Genes anotados y sus números EC (Enzyme Commission)
%[text] - - Reacciones bioquímicas y rutas metabólicas
%[text] - - Restricciones termodinámicas y de balance de masa \
%[text] Al construir un modelo manualmente (como lo haremos aquí), usted comprenderá:
%[text] 1. Cómo se estructura un GEM internamente
%[text] 2. Cómo las anotaciones genómicas se traducen en reacciones metabólicas
%[text] 3. Cómo se formulan las reglas gen-proteína-reacción (GPR)
%[text] 4. Cómo se usan límites de flujo para imponer restricciones biológicas \
%[text] ## Contexto del Ejemplo
%[text] 
%[text] **Escenario:** Usted ha secuenciado y anotado un microorganismo y encontró que su metabolismo principal incluye:
%[text] - Glucólisis (10 reacciones): Convierte glucosa en piruvato
%[text] - Ciclo TCA (5 reacciones): Genera poder reductor (NADH)
%[text] - Fermentación (3 reacciones): Produce etanol como producto final
%[text] - Intercambios y síntesis (1 reacción): Síntesis de ATP \
%[text] Total: 19 reacciones, 22 metabolitos, 13 genes
%[text] 
%[text] ## Objetivos
%[text] 
%[text] Al finalizar esta práctica, usted será capaz de:
%[text] 1. **Crear la lista de metabolitos** — Identificar y enumerar todos los metabolitos con sus identificadores seguros la convención de compartimentos (\_c = citosol, \_m = mitocondria, \_e = extracelular)
%[text] 2. Construir la matriz estequiométrica S — Representar cada reacción como una columna, con coeficientes estequiométricos (-1 sustrato, +1 producto)
%[text] 3. Asignar límites de flujo\*— Especificar qué reacciones son reversibles, irreversibles y dónde hay transportes limitados (uptake, excreción)
%[text] 4. Formular reglas gen-proteína-reacción (GPR) — Conectar genes anotados con reacciones bioquímicas (ej: gene\_pfk → reacción PFK)
%[text] 5. Crear una estructura COBRA-compatible — Empaquetar todo en un formato que funcione con COBRA Toolbox y RAVEN
%[text] 6. Resolver el modelo con FBA — Ejecutar optimización linear para predecir flujos y crecimiento bajo las restricciones \
%[text] ## 
%[text] ## Preguntas guia
%[text] 
%[text] Mientras trabaja en esta práctica, tenga en mente:
%[text] - ¿Cómo se relacionan los identificadores de metabolitos con su ubicación celular?
%[text] - ¿Por qué la estequiometría debe estar balanceada en cada reacción?
%[text] - ¿Qué diferencia hay entre una reacción reversible e irreversible?
%[text] - ¿Cómo se expresa que "si el gen X no existe, la reacción no puede ocurrir"?
%[text] - ¿Qué sucede cuando resuelvo el modelo? ¿Qué flujos predice FBA? \
%[text] 
%[text] ## Estructura de la practica
%[text] - Parte 1: Definir metabolitos (IDs y nombres)
%[text] - Parte 2: Definir reacciones (IDs y nombres)
%[text] - Parte 3: Construir la matriz estequiométrica S
%[text] - Parte 4: Asignar límites de flujo (reversibilidad)
%[text] - Parte 5: Crear reglas gen-proteína-reacción
%[text] - Parte 6: Empaquetar en estructura COBRA
%[text] - Parte 7: Resolver el modelo con FBA
%[text] - Parte 8: Método alternativo rápido con createModel() \
%[text] ### Notas técnicas
%[text] - Este script crea un modelo compacto y didáctico (NO un modelo a escala genómica completo). La estequiometría está simplificada para mayor claridad.
%[text] - Los identificadores siguen convención COBRA:  \_c = citosol      | \_m = mitocondria   | \_e = extracelular
%[text] - Las reglas GPR son ilustrativas; en práctica usan identificadores reales.
%[text] - Para usarlo con COBRA Toolbox, asegúrese de que S, mets, rxns, lb, ub, grRules y genes estén presentes en el struct del modelo.
%[text] - Este modelo es compatible con RAVEN Toolbox (usado en MATLAB) y puede exportarse a SBML para usarse con COBRApy (Python). \
%[text] ## Referencias
%[text] - Orth et al. 2010. What is flux balance analysis? Nat Biotechnol 28(3):245-248
%[text] - Reed & Palsson 2003. Genome-scale in silico models of E. coli. Trends Microbiol
%[text] - Schellenberger et al. 2011. Quantitative prediction of cellular metabolism with constraint-based models. Nat Rev Microbiol \
%%
%[text] Ahora que entendemos el contexto, vamos a construir el modelo paso a paso.
%[text] 
%[text] ## Parte 1: definir los metabolitos
%[text] 
%[text] Lista de metabolitos con identificadores siguiendo convención COBRA.
%[text] Convención:
%[text]   \_c = citosol (compartimento principal)
%[text]   \_m = mitocondria
%[text]   \_e = extracelular
%[text] 
%[text] #### Metabolites (IDs and names)
%[text] 
%[text] Convención: metabolito\_compartimento
%[text] 1. glc\_c = glucosa en citosol
%[text] 2. atp\_c = ATP en citosol
%[text] 3. acoa\_m = acetil-CoA en mitocondria \
%[text] Total: 22 metabolitos distribuidos en 3 compartimentos
%%
mets = { ...
    'glc_e';          % Glucosa extracelular
    'glc_c'; ...      % Glucosa citoplásmica
    'g6p_c'; ...      % Glucosa-6-fosfato
    'f6p_c'; ...      % Fructosa-6-fosfato
    'f16bp_c'; ...    % Fructosa-1,6-bisfosfato
    'g3p_c'; ...      % Glicerol-3-fosfato
    'bpg_c'; ...      % 1,3-bisfosfoglicerato
    'pep_c'; ...      % Fosfoenolpiruvato
    'pyr_c'; ...      % Piruvato (citoplásma)
    'acoa_m'; ...     % Acetil-CoA (mitocondria)
    'cit_m'; ...      % Citrato (mitocondria)
    'akg_m'; ...      % α-cetoglutarato (mitocondria)
    'oaa_m'; ...      % Oxaloacetato (mitocondria)
    'mal_m'; ...      % Malato (mitocondria)
    'co2_m'; ...      % CO2 (mitocondria)
    'co2_e'; ...      % CO2 (extracelular)
    'etoh_e'; ...     % Etanol (extracelular)
    'etoh_c'; ...     % Etanol (citoplasma)
    'adp_c'; ...      % ADP (citoplasma)
    'atp_c'; ...      % ATP (citoplasma)
    'nad_c'; ...      % NAD+ (citoplasma)
    'nadh_c' ...      % NADH (citoplasma)
    };
%%
%[text] ## Parte 2: Nombre de los Metabolitos
%[text] 
%[text] Para cada metabolito, asignamos un nombre descriptivo que facilite interpretación de resultados
metNames = { ...
    'glucose [extracellular]';
    'glucose [cytosol]'; ...
    'glucose-6-phosphate [cytosol]';
    'fructose-6-phosphate [cytosol]'; ...
    'fructose-1,6-bisphosphate [cytosol]';
    'glyceraldehyde-3-phosphate [cytosol]'; ...
    '1,3-bisphosphoglycerate [cytosol]';
    'phosphoenolpyruvate [cytosol]'; ...
    'pyruvate [cytosol]'; 'acetyl-CoA [mitochondrion]';
    'citrate [mitochondrion]'; ...
    'alpha-ketoglutarate [mitochondrion]';
    'oxaloacetate [mitochondrion]'; ...
    'malate [mitochondrion]';
    'CO2 [mitochondrion]';
    'CO2 [extracellular]'; ...
    'ethanol [extracellular]'; ...
    'ethanol [cytosol]'; ...
    'ADP [cytosol]'; ...
    'ATP [cytosol]'; ...
    'NAD+ [cytosol]'; ...
    'NADH [cytosol]' ...
    };

%%
%[text] ## Parte 3: Definir reacciones
%[text] 
%[text] Ahora ya que hemos definido los metabolitos, definimos las 19 reacciones del modelo con sus IDs y nombres descriptivos
%[text]  Reaction IDs (siguiendo convención COBRA: mayúsculas, sin espacios)
rxns = { ...
    'GLCtex';       % Transporte de glucosa (extracelular → citosol)
    'GLCpts';       % Sistema de fosfotransferasa (PTS)
    'HEX';          % Hexoquinasa
    'PGI';          % Isomerasa glucosa-6-fosfato
    'PFK';          % Fosfofructoquinasa (paso limitante)
    'ALD';          % Aldolasa (escisión)
    'GAPDH';        % Glicerol-3-fosfato deshidrogenasa
    'PGK';          % Fosfoglicerato quinasa
    'ENO';          % Enolasa
    'PYK';          % Piruvato quinasa
    'PDH';          % Piruvato deshidrogenasa (citosol → mitocondria)
    'CS';           % Citrato sintasa
    'IDH';          % Isocitrato deshidrogenasa
    'AKGDH';        % α-cetoglutarato deshidrogenasa
    'MDH';          % Malato deshidrogenasa
    'PDC';          % Piruvato descarboxilasa (fermentación)
    'ADH';          % Alcohol deshidrogenasa (fermentación)
    'EX_etoh';      % Intercambio (excreción) de etanol
    'ATPSynth' ...  % Síntesis de ATP
    };

% Reaction Names (nombres descriptivos para interpretación)
rxnNames = { ...
    'glucose transport (extracellular -> cytosol)'; ...
    'glucose transport (phosphotransferase system)'; ...
    'hexokinase'; ...
    'phosphoglucose isomerase'; ...
    'phosphofructokinase (rate-limiting step)'; ...
    'aldolase (fructose-1,6-bisphosphate scission)'; ...
    'glyceraldehyde-3-phosphate dehydrogenase'; ...
    'phosphoglycerate kinase'; ...
    'enolase'; ...
    'pyruvate kinase'; ...
    'pyruvate dehydrogenase complex (citosol to mitochondrion)'; ...
    'citrate synthase'; ...
    'isocitrate dehydrogenase'; ...
    'alpha-ketoglutarate dehydrogenase complex'; ...
    'malate dehydrogenase'; ...
    'pyruvate decarboxylase (ethanol fermentation)'; ...
    'alcohol dehydrogenase (ethanol fermentation)'; ...
    'ethanol exchange (excretion)'; ...
    'ATP synthase (coupled with oxidative phosphorylation)' ...
    };

%%
%[text] ## Parte 4: Construir la matriz estequiométrica S
%[text] 
%[text]  La matriz estequiométrica S es de dimensión m × n donde:
%[text]    m = número de metabolitos (filas)
%[text]    n = número de reacciones (columnas)
%[text] 
%[text]  Cada elemento S(i,j) es el coeficiente estequiométrico:
%[text]    \-1 = el metabolito i es CONSUMIDO en la reacción j (sustrato)
%[text]    \+1 = el metabolito i es PRODUCIDO en la reacción j (producto)
%[text]     0 = el metabolito i no participa en la reacción j
%[text] 
%[text]  En estado estacionario: S · v = 0 (balance de masa para cada metabolito)
%[text] 
%[text]  **Preguntas clave mientras construimos S:**
%[text] -  ¿Cuántos metabolitos participa en cada reacción?
%[text] -  ¿Cuál es la estequiometría exacta (1:1, 1:2, etc.)?
%[text] -  ¿Los coeficientes negativos suman exactamente a los positivos? \
%%
% Initialize stoichiometric matrix S (nMets x nRxns)

nMets = numel(mets);
nRxns = numel(rxns);% Initialize stoichiometric matrix S (nMets x nRxns)
S = zeros(nMets, nRxns);

% Helper to set stoichiometry: change S(row, col) by coeff
metIdx = @(id) find(strcmp(mets, id),1);
rxnIdx = @(id) find(strcmp(rxns, id),1);

% Reaction definitions (simplified stoichiometry)
% 1) GLCtex: glc_e -> glc_c
S(metIdx('glc_e'), rxnIdx('GLCtex')) = -1;
S(metIdx('glc_c'), rxnIdx('GLCtex')) =  1;

% 2) GLCpts: glc_c + PEP -> g6p_c + pyruvate (PTS system simplified)
% Use pep_c and pyr_c; include ATP usage implicitly via PEP consumption
S(metIdx('glc_c'), rxnIdx('GLCpts')) = -1;
S(metIdx('pep_c'), rxnIdx('GLCpts')) = -1;
S(metIdx('g6p_c'), rxnIdx('GLCpts')) =  1;
S(metIdx('pyr_c'), rxnIdx('GLCpts')) =  1;

% 3) HEX: glc_c + atp_c -> g6p_c + adp_c
S(metIdx('glc_c'), rxnIdx('HEX')) = -1;
S(metIdx('atp_c'), rxnIdx('HEX')) = -1;
S(metIdx('g6p_c'), rxnIdx('HEX')) =  1;
S(metIdx('adp_c'), rxnIdx('HEX')) =  1;

% 4) PGI: g6p_c <-> f6p_c
S(metIdx('g6p_c'), rxnIdx('PGI')) = -1;
S(metIdx('f6p_c'), rxnIdx('PGI')) =  1;

% 5) PFK: f6p_c + atp_c -> f16bp_c + adp_c
S(metIdx('f6p_c'), rxnIdx('PFK')) = -1;
S(metIdx('atp_c'), rxnIdx('PFK')) = -1;
S(metIdx('f16bp_c'), rxnIdx('PFK')) =  1;
S(metIdx('adp_c'), rxnIdx('PFK')) =  1;

% 6) ALD: f16bp_c -> 2 g3p_c
S(metIdx('f16bp_c'), rxnIdx('ALD')) = -1;
S(metIdx('g3p_c'), rxnIdx('ALD')) =  2;

% 7) GAPDH: g3p_c + nad_c + adp_c -> bpg_c + nadh_c + atp_c
S(metIdx('g3p_c'), rxnIdx('GAPDH')) = -1;
S(metIdx('nad_c'), rxnIdx('GAPDH')) = -1;
S(metIdx('adp_c'), rxnIdx('GAPDH')) = -1;
S(metIdx('bpg_c'), rxnIdx('GAPDH')) =  1;
S(metIdx('nadh_c'), rxnIdx('GAPDH')) =  1;
S(metIdx('atp_c'), rxnIdx('GAPDH')) =  1;

% 8) PGK: bpg_c -> pep_c (lumping PGK+others for simplicity)
S(metIdx('bpg_c'), rxnIdx('PGK')) = -1;
S(metIdx('pep_c'), rxnIdx('PGK')) =  1;

% 9) ENO: pep_c -> pyr_c
S(metIdx('pep_c'), rxnIdx('ENO')) = -1;
S(metIdx('pyr_c'), rxnIdx('ENO')) =  1;

% 10) PYK: (can be combined with ENO; keep as alternative route)
% For simplicity, set PYK: pep_c + adp_c -> pyr_c + atp_c
S(metIdx('pep_c'), rxnIdx('PYK')) = -1;
S(metIdx('adp_c'), rxnIdx('PYK')) = -1;
S(metIdx('pyr_c'), rxnIdx('PYK')) =  1;
S(metIdx('atp_c'), rxnIdx('PYK')) =  1;

% 11) PDH: pyr_c -> acoa_m + co2_m + nadh_c (pyruvate dehydrogenase)
S(metIdx('pyr_c'), rxnIdx('PDH')) = -1;
S(metIdx('acoa_m'), rxnIdx('PDH')) =  1;
S(metIdx('co2_m'), rxnIdx('PDH')) =  1;
S(metIdx('nadh_c'), rxnIdx('PDH')) =  1;

% 12) CS: acoa_m + oaa_m -> cit_m
S(metIdx('acoa_m'), rxnIdx('CS')) = -1;
S(metIdx('oaa_m'), rxnIdx('CS')) = -1;
S(metIdx('cit_m'), rxnIdx('CS')) =  1;

% 13) IDH: cit_m -> akg_m + co2_m + nadh_c
S(metIdx('cit_m'), rxnIdx('IDH')) = -1;
S(metIdx('akg_m'), rxnIdx('IDH')) =  1;
S(metIdx('co2_m'), rxnIdx('IDH')) =  1;
S(metIdx('nadh_c'), rxnIdx('IDH')) =  1;

% 14) AKGDH: akg_m -> suc_coa (lumped) + co2_m + nadh_c
% We will represent product as oaa_m for simplicity (lumped TCA)
S(metIdx('akg_m'), rxnIdx('AKGDH')) = -1;
S(metIdx('oaa_m'), rxnIdx('AKGDH')) =  1;
S(metIdx('co2_m'), rxnIdx('AKGDH')) =  1;
S(metIdx('nadh_c'), rxnIdx('AKGDH')) =  1;

% 15) MDH: mal_m <-> oaa_m + nadh_c
S(metIdx('mal_m'), rxnIdx('MDH')) = -1;
S(metIdx('oaa_m'), rxnIdx('MDH')) =  1;
S(metIdx('nadh_c'), rxnIdx('MDH')) =  1;

% 16) PDC: pyr_c -> etoh_c + co2_c (pyruvate decarboxylase)
% We don't have co2_c; send CO2 to mitochondrial then extracellular
S(metIdx('pyr_c'), rxnIdx('PDC')) = -1;
S(metIdx('etoh_c'), rxnIdx('PDC')) =  1;
S(metIdx('co2_m'), rxnIdx('PDC')) =  1; % simplification

% 17) ADH: etoh_c + nadh_c -> etoh_e + nad_c (alcohol dehydrogenase, export)
S(metIdx('etoh_c'), rxnIdx('ADH')) = -1;
S(metIdx('nadh_c'), rxnIdx('ADH')) = -1;
S(metIdx('etoh_e'), rxnIdx('ADH')) =  1;
S(metIdx('nad_c'), rxnIdx('ADH')) =  1;

% 18) EX_etoh: etoh_e <-> (exchange)
S(metIdx('etoh_e'), rxnIdx('EX_etoh')) = -1;

% 19) ATPSynth: adp_c + pi (not present) -> atp_c
% Lump as ADP -> ATP
S(metIdx('adp_c'), rxnIdx('ATPSynth')) = -1;
S(metIdx('atp_c'), rxnIdx('ATPSynth')) =  1;

%%
%[text] ## Parte 5: Asignar límites de flujo
%[text] 
%[text] Ahora que tenemos la matriz estequiométrica, debemos especificar cuáles reacciones pueden ocurrir (forward, backward, o ambas) mediante límites de flujo:
%[text] -    lb = límite inferior (lower bound) — velocidad mínima (negativo = reverso)
%[text] -    ub = límite superior (upper bound) — velocidad máxima (positivo = hacia adelante) \
%[text] Restricciones biológicas típicas:
%[text] - Reacciones irreversibles (termodinámicamente): lb = 0
%[text] - Reacciones reversibles: lb \< 0
%[text] - Transport/uptake limitado por disponibilidad en medio: ub = máx esperado
%[text] -  Excreción: típicamente lb = 0, ub = grande \
% Initialize bounds: por defecto, permitir reversibilidad
lb = -1000 * ones(nRxns,1);
ub =  1000 * ones(nRxns,1);

% Set specific bounds: uptake and exchange
% Glucose transport (limited by availability in medium)
lb(rxnIdx('GLCtex')) = -10;   % can uptake up to 10 mmol/gDW/h
ub(rxnIdx('GLCtex')) =  10;

% If using GLCpts or HEX pathway, constrain one of them to represent pathway choice
% Let's allow HEX and PTS both but limit flux
lb(rxnIdx('GLCpts')) = 0; % irreversible forward
lb(rxnIdx('HEX')) = 0;
lb(rxnIdx('PFK')) = 0;
lb(rxnIdx('GAPDH')) = 0;
lb(rxnIdx('PGK')) = 0;
lb(rxnIdx('ALD')) = 0;
lb(rxnIdx('EN O')) = 0;

% PDC, ADH for ethanol production
lb(rxnIdx('PDC')) = 0;
lb(rxnIdx('ADH')) = 0;

% Ethanol export only outward
lb(rxnIdx('EX_etoh')) = 0; 
ub(rxnIdx('EX_etoh')) = 1000;

% For safety, set bounds for ATP synthase directionality
lb(rxnIdx('ATPSynth')) = 0;

%%
%[text] ## Parte 6: Crear reglas Gen-Proteína-Reacción (GPR)
%[text] Las reglas GPR conectan genes anotados con reacciones bioquímicas. Permiten simular el impacto de mutaciones y knockouts genéticos.
%[text] Notación:
%[text] - 'gene\_X' = Si el gen X está presente, la reacción ocurre
%[text] - 'gene\_X AND gene\_Y' = Ambos genes necesarios (enzima con 2 subunidades)
%[text] - 'gene\_X OR gene\_Y' = Al menos un gen necesario (isoenzimas) \
%[text] En nuestro modelo, asignamos un gen a cada reacción de forma simplificada
%[text] 
% Genes (lista de identificadores)
genes = {'gene_glcpt'; 'gene_hex'; 'gene_pgi'; 'gene_pfk'; 'gene_ald'; ...
         'gene_gapdh'; 'gene_pgk'; 'gene_eno'; 'gene_pyk'; 'gene_pdh'; ...
         'gene_pdc'; 'gene_adh'; 'gene_tca'};

% Map grRules (Gene Reaction Rules) to reactions (strings)
grRules = repmat({''}, nRxns, 1);
grRules = repmat({''}, nRxns, 1);
grRules{rxnIdx('GLCpts')} = 'gene_glcpt';
grRules{rxnIdx('HEX')}    = 'gene_hex';
grRules{rxnIdx('PGI')}    = 'gene_pgi';
grRules{rxnIdx('PFK')}    = 'gene_pfk';
grRules{rxnIdx('ALD')}    = 'gene_ald';
grRules{rxnIdx('GAPDH')}  = 'gene_gapdh';
grRules{rxnIdx('PGK')}    = 'gene_pgk';
grRules{rxnIdx('ENO')}    = 'gene_eno';
grRules{rxnIdx('PYK')}    = 'gene_pyk';
grRules{rxnIdx('PDH')}    = 'gene_pdh';
grRules{rxnIdx('PDC')}    = 'gene_pdc';
grRules{rxnIdx('ADH')}    = 'gene_adh';

% Lump TCA enzymes under gene_tca
grRules{rxnIdx('CS')}     = 'gene_tca';
grRules{rxnIdx('IDH')}    = 'gene_tca';
grRules{rxnIdx('AKGDH')}  = 'gene_tca';
grRules{rxnIdx('MDH')}    = 'gene_tca';
grRules{rxnIdx('ATPSynth')}= 'gene_tca';
%%
%[text] ## Parte 7: Empaquetar en estructura COBRA
%[text] Ahora que tenemos toda la información (metabolitos, reacciones, matriz S, límites, y reglas GPR), empaquetamos todo en una estructura MATLAB compatible con COBRA Toolbox y RAVEN.
%[text] Esta estructura será la base para realizar análisis de FBA, simulaciones de knockouts y predicción de flujos metabólicos.
% Build model struct (COBRA-style)
model.S = S;
model.mets = mets;
model.metNames = metNames;
model.rxns = rxns;
model.rxnNames = rxnNames;
model.lb = lb;
model.ub = ub;
model.c = zeros(nRxns,1); % objective vector

% Set objective to ethanol export (maximize EX_etoh)
model.c(rxnIdx('EX_etoh')) = 1;
model.b = zeros(nMets,1); % RHS (steady-state)
model.rev = model.lb < 0;
model.grRules = grRules;
model.genes = genes;
model.rules = grRules; % duplicate for compatibility
model.description = 'Small glycolysis-TCA-ethanol toy model for tutorial';
model.version = '1.0';

% Provide some basic checks / display summary
fprintf('Model created: %d metabolites, %d reactions, %d genes\n', nMets, nRxns, numel(genes));
fprintf('Objective set to reaction: %s (EX_etoh)\n', rxnIdx('EX_etoh')*0 + 'EX_etoh');
%%
%[text] Ya que tenemos el modelo, veamos si encuentra alguna solución:
sol = solveLP(model)
%%
%[text] ## Parte 8: Método alternativo rápido con createModel()
%[text] 
%[text] Alternativamente, si tenemos muchas reacciones, podemos usar la función createModel() de RAVEN Toolbox que parsea automáticamente las fórmulas de reacciones y construye la matriz S, los metabolitos y otros campos.
%[text] Esto es más rápido para modelos grandes, pero requiere que escribamos las ecuaciones de reacción en formato estándar.
%[text] 
%[text] Formato de ecuación:
%[text]    'glc\_c + ATP -\> G6P + ADP'   (irreversible, derecha a izquierda)
%[text]    'G6P \<-\> F6P'                 (reversible)
%[text] 
%[text] Ventajas:
%[text] - Mucho más rápido para modelos grandes
%[text] - Menos propenso a errores en estequiometría
%[text] - Genera automáticamente metabolitos si no existen \
%[text] Desventajas:
%[text] -  Menos control sobre detalles finos
%[text] -  Requiere que las fórmulas sean correctas \
% ...existing code for empty model setup...
emptyModel = struct(); %create blank model, with all required fields.
emptyModel.S = sparse(0,0);
emptyModel.mets = cell(0,1);
emptyModel.metNames = cell(0,1);
emptyModel.metComps = cell(0,1);
emptyModel.rxns = cell(0,1);
emptyModel.rxnNames = cell(0,1);
emptyModel.lb = zeros(0,1);
emptyModel.ub = zeros(0,1);
emptyModel.comps = cell(0,1);
emptyModel.compNames = cell(0,1);
emptyModel.comps = {'c';'e';'p'};
emptyModel.compNames = {'cytoplasm';'extracellular';'periplasm'};
emptyModel.c = zeros(0,1); % objective vector
emptyModel.b = zeros(0,1);
emptyModel.rev = zeros(0,1);
emptyModel.grRules = cell(0,1);
emptyModel.genes = cell(0,1);
emptyModel.description = 'Empty Model';
emptyModel.version = '1.0';
%%
rxnFormulas = {
    'glc_e -> glc_c', 
    'glc_c + PEP -> g6p_c',
    'glc_c + atp_c -> g6p_c + adp_c',
    'g6p_c <-> f6p_c',
    'f6p_c + atp_c -> f16bp_c + adp_c',
    'f16bp_c -> 2 g3p_c',
    'g3p_c + nad_c + adp_c -> bpg_c + nadh_c + atp_c',
    'bpg_c -> pep_c',
    'pep_c -> pyr_c',
    'pep_c + adp_c -> pyr_c + atp_c',
    'pyr_c -> acoa_m + co2_m + nadh_c',
    'acoa_m + oaa_m -> cit_m',
    'cit_m -> akg_m + co2_m + nadh_c',
    'akg_m -> oaa_m + co2_m + nadh_c',
    'mal_m <-> oaa_m + nadh_c',
    'pyr_c -> etoh_c + co2_c',
    'etoh_c + nadh_c -> etoh_e + nad_c',
    'etoh_e ->',
    'adp_c -> atp_c'
    };

modelNew = createModel(rxns, rxnNames, rxnFormulas);

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
