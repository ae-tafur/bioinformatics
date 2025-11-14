%% Define the working path
clear; 
clc;
if ~exist([pwd() '/model_reconstruction.m']); error(['Make sure that '...
        'your Current Folder is the one containing the reconstructionProtocol file.']); 
end

cd ../;

root = [pwd() '/'];
data    = [root 'data/'];
code = [root 'code/'];

% return to code dir
cd(code)

%% Check RAVEN installation

% remember that you can install RAVEN via github download zip file or via
% Add-Ons

initCobraToolbox(); % For cobraToolbox
checkInstallation(); % For RAVEN

%% Import template models

% For this purpose we will use the as template for reconstruction of a
% model for Escherichia coli BL21
% Escherichia coli str. K-12 substr. MG1655 (iML1515) Publication PMID:  29020004 
% Escherichia coli ATCC 8739 (iEC1349_Crooks) Publication PMID:  27667363 

iML1515 = importModel([data 'templateModels/iML1515.xml'],[],false);
iML1515.name = 'Monk2017 - Genome-scale metabolic network of Escherichia coli str. K-12 substr. MG1655 (iML1515)';


iEC1349 = importModel([data 'templateModels/iEC1349_Crooks.xml'],[],false);
iEC1349.id = 'iEC1349';
iEC1349.name = 'Monk2016 - Genome-scale metabolic network of Escherichia coli ATCC 8739 (iEC1349_Crooks)';


% Fix some gene rules that can be troubleshooting 
iEC1349.grRules(662) = {'(G_ECOLC_RS23000 and G_ECOLC_RS22995 and G_ECOLC_RS22990 and G_ECOLC_RS23025 and G_ECOLC_RS23020 and G_ECOLC_RS23015 and G_ECOLC_RS23010 and G_ECOLC_RS23005 and G_ECOLC_RS22985) or (G_ECOLC_RS23000 and G_ECOLC_RS22995 and G_ECOLC_RS22990 and G_ECOLC_RS23025 and G_ECOLC_RS23020 and G_ECOLC_RS23015 and G_ECOLC_RS23010 and G_ECOLC_RS23005)'};
iEC1349.grRules(1169) = {'(G_ECOLC_RS18850 and G_ECOLC_RS12725 and G_ECOLC_RS03670 and G_ECOLC_RS03665)'};
iEC1349.grRules(1247) = {'(G_ECOLC_RS02355 and G_ECOLC_RS02350) and G_ECOLC_RS03520'};
iEC1349.grRules(1253) = {'(G_EcolC_3948 and G_ECOLC_RS06420 and G_ECOLC_RS06415 and G_deleted and G_ECOLC_RS06405 and G_ECOLC_RS06400 and G_ECOLC_RS06395 and G_ECOLC_RS06390 and G_ECOLC_RS06385 and G_ECOLC_RS06380 and G_ECOLC_RS06375) or (G_EcolC_3948 and G_ECOLC_RS05295 and G_ECOLC_RS05290 and G_ECOLC_RS05285 and G_ECOLC_RS05280 and G_ECOLC_RS05275 and G_ECOLC_RS05270)'};
iEC1349.grRules(1512) = {'(G_ECOLC_RS14470 and G_ECOLC_RS14465) or (G_ECOLC_RS14470 and G_ECOLC_RS03100) or (G_ECOLC_RS21895 and G_ECOLC_RS21890) or (G_ECOLC_RS14470 and G_ECOLC_RS14465 and G_ECOLC_RS05900)'};
iEC1349.grRules(1535) = {'(G_ECOLC_RS14470 and G_ECOLC_RS14465 and G_ECOLC_RS05900) or (G_ECOLC_RS14470 and G_ECOLC_RS14465) or (G_ECOLC_RS14470 and G_ECOLC_RS03100)'};
iEC1349.grRules(1668) = {'(G_ECOLC_RS07750 and G_ECOLC_RS07735 and G_ECOLC_RS07755)'};
iEC1349.grRules(1682) = {'(G_ECOLC_RS07750 and G_ECOLC_RS07735 and G_ECOLC_RS07755 and G_ECOLC_RS07740 and G_ECOLC_RS07745)'};
iEC1349.grRules(1753) = {'(G_ECOLC_RS07585 and G_ECOLC_RS07580 and G_ECOLC_RS22790) or (G_ECOLC_RS07585 and G_ECOLC_RS07580 and G_ECOLC_RS05880)'};
iEC1349.grRules(1754) = {'(G_ECOLC_RS07585 and G_ECOLC_RS07580 and G_ECOLC_RS22790) or (G_ECOLC_RS07585 and G_ECOLC_RS07580 and G_ECOLC_RS05880)'};
iEC1349.grRules(1755) = {'(G_ECOLC_RS07585 and G_ECOLC_RS07580 and G_ECOLC_RS05880) or (G_ECOLC_RS07585 and G_ECOLC_RS07580 and G_ECOLC_RS22790)'};
iEC1349.grRules(1781) = {'(G_ECOLC_RS07585 and G_ECOLC_RS07580 and G_ECOLC_RS22790) or (G_ECOLC_RS07585 and G_ECOLC_RS07580 and G_ECOLC_RS05880)'};
iEC1349.grRules(2135) = {'(G_ECOLC_RS15230 and G_ECOLC_RS12725 and G_ECOLC_RS03670 and G_ECOLC_RS03665) or (G_ECOLC_RS07990 and G_ECOLC_RS12725 and G_ECOLC_RS03670 and G_ECOLC_RS03665)'};
iEC1349.grRules(2150) = {'(G_ECOLC_RS13600 and G_ECOLC_RS05515 and G_ECOLC_RS05510) or (G_ECOLC_RS00520 and G_ECOLC_RS05515 and G_ECOLC_RS05510) or (G_ECOLC_RS10620 and G_ECOLC_RS05515 and G_ECOLC_RS05510) or (G_ECOLC_RS14755 and G_ECOLC_RS05515 and G_ECOLC_RS05510)'};
iEC1349.grRules(2151) = {'(G_ECOLC_RS14755 and G_ECOLC_RS05515 and G_ECOLC_RS05510) or (G_ECOLC_RS00520 and G_ECOLC_RS05515 and G_ECOLC_RS05510) or (G_ECOLC_RS13600 and G_ECOLC_RS05515 and G_ECOLC_RS05510) or (G_ECOLC_RS10620 and G_ECOLC_RS05515 and G_ECOLC_RS05510)'};
iEC1349.grRules(2615) = {'(G_ECOLC_RS14755 and G_ECOLC_RS05515 and G_ECOLC_RS05510) or (G_ECOLC_RS00520 and G_ECOLC_RS05515 and G_ECOLC_RS05510) or (G_ECOLC_RS10620 and G_ECOLC_RS05515 and G_ECOLC_RS05510) or (G_ECOLC_RS13600 and G_ECOLC_RS05515 and G_ECOLC_RS05510)'};
iEC1349.grRules(2617) = {'(G_ECOLC_RS14755 and G_ECOLC_RS05515 and G_ECOLC_RS05510) or (G_ECOLC_RS13600 and G_ECOLC_RS05515 and G_ECOLC_RS05510) or (G_ECOLC_RS00520 and G_ECOLC_RS05515 and G_ECOLC_RS05510) or (G_ECOLC_RS10620 and G_ECOLC_RS05515 and G_ECOLC_RS05510)'};
iEC1349.grRules(2618) = {'(G_ECOLC_RS16305 and G_ECOLC_RS16300 and G_ECOLC_RS16295 and G_ECOLC_RS16310)'};


%% Generate a model from homology

% run a BLAST to get the models based on homology
blast = getBlast('bl21', [data 'genomes/bl21.faa'], {'iML1515', 'iEC1349'}, ...
    {[data 'genomes/iML1515.faa'], [data 'genomes/iEC1349.faa']})

model = getModelFromHomology({iML1515, iEC1349}, blast, 'bl21', ...
    {'iML1515', 'iEC1349'}, 1, false, 10^-30, 100, 80, false);

%% Contract the model

% since we are using two templates, there could be duplicated reactions,
% mainly because izoenzymes. Same reaction, different gene rules.

model = contractModel(model);


%% Add reactions that represents the media components

mediumComps = {'R_EX_pi_e',
    'R_EX_co2_e',
    'R_EX_fe3_e',
    'R_EX_h_e',
    'R_EX_mn2_e',
    'R_EX_fe2_e',
    'R_EX_glc__D_e',
    'R_EX_zn2_e',
    'R_EX_mg2_e',
    'R_EX_ca2_e',
    'R_EX_ni2_e',
    'R_EX_cu2_e',
    'R_EX_sel_e',
    'R_EX_cobalt2_e',
    'R_EX_h2o_e',
    'R_EX_mobd_e',
    'R_EX_so4_e',
    'R_EX_nh4_e',
    'R_EX_k_e',
    'R_EX_na1_e',
    'R_EX_cl_e',
    'R_EX_o2_e',
    'R_EX_tungs_e',
    'R_EX_slnt_e',
    'R_EX_meoh_e',
    'R_BIOMASS_Ec_iML1515_core_75p37M',
    'R_BIOMASS_Ec_iML1515_WT_75p37M'};

model = addRxnsGenesMets(model, iML1515, mediumComps);

%% Test the model now

% Use biomass production as objective function
model = setParam(model,'obj','R_BIOMASS_Ec_iML1515_WT_75p37M',1);

% Run FBA
sol = solveLP(model)

%% Add some important transport reactions

%transportRxns_model = getTransportRxns(model);
%transportRxns_model = model.rxns(transportRxns_model);

%transportRxns_iML1515 = getTransportRxns(iML1515);
%transportRxns_iML1515 = iML1515.rxns(transportRxns_iML1515);

%common = setdiff(transportRxns_iML1515, transportRxns_model);


common = {'R_MEOHtrpp',
    'R_MG2t3_2pp',
    'R_O2tpp',
    'R_THMDt2pp_copy2',
    'R_URIt2pp_copy2',
    'R_CO2tpp'};

model = addRxnsGenesMets(model, iML1515, common);

% Run FBA
sol = solveLP(model)

%% Run gap-filling

% Force grow to a minimum so we can get results
model = setParam(model,'lb','R_BIOMASS_Ec_iML1515_WT_75p37M',0);

% From the iML1515 and iEC1349 models, remove all exchange reactions (the
% necessary ones we already added, don't want to add new ones)
modelDatabase = removeReactions(iML1515,getExchangeRxns(iML1515,'both'),true,true,true);
biomassRxns = modelDatabase.rxns(startsWith(modelDatabase.rxnNames,'R_BIOMASS_Ec_iML1515_'));
modelDatabase = removeReactions(modelDatabase,biomassRxns,true,true,true);

% Run fillGaps function
[~,~, addedRxns, model2] = fillGaps(model,{modelDatabase},false,true);

%%

[allGaps, rootGaps, downstreamGaps] = gapFind(model, 'true');

weights.MetabolicRxns = 0.1; % Kegg metabolic reactions
weights.ExchangeRxns = 0.5; % Exchange reactions
weights.TransportRxns = 10; % Transport reactions

cnt = 1;
Stats{cnt,1} = 'Model name';cnt = cnt+1;
Stats{cnt,1} = 'Size S (original model)';cnt = cnt+1;
Stats{cnt,1} = 'Number of compartments';cnt = cnt+1;
Stats{cnt,1} = 'List of compartments';cnt = cnt+1;
Stats{cnt,1} = 'Number of blocked reactions';cnt = cnt+1;
Stats{cnt,1} = 'Number of solvable blocked reactions';cnt = cnt+1;
Stats{cnt,1} = 'Size S (flux consistent)';cnt = cnt+1;
Stats{cnt,1} = 'Size SUX (including solvable blocked reactions)';cnt = cnt+1;
Stats{cnt,1} = 'Number of added reactions (all)';cnt = cnt+1;
Stats{cnt,1} = 'Number of added metabolic reactions ';cnt = cnt+1;
Stats{cnt,1} = 'Number of added transport reactions ';cnt = cnt+1;
Stats{cnt,1} = 'Number of added exchange reactions ';cnt = cnt+1;
Stats{cnt,1} = 'Time preprocessing';cnt = cnt+1;
Stats{cnt,1} = 'Time fastGapFill';cnt = cnt+1;

% Initiate parameters.
col = 1;
RxnList={};
cnt = 1;

% Remove constraints from exchange reactions.
EX = strmatch('EX_',model.rxns);
model.lb(EX)=-100;
model.ub(EX)=100;
clear EX

% Get basic model statistics.
Stats{cnt,2} = filename;cnt = cnt+1;
[a,b] = size(model.S);
Stats{cnt,2} = strcat(num2str(a),'x',num2str(b));cnt = cnt+1;

% List of compartments in the model that will be considered during the gap filling.
[tok,rem] = strtok(model.mets,'\[');
rem = unique(rem);
Stats{cnt,2} = num2str(length(rem));cnt = cnt+1;
Rem = rem{1};
for j = 2:length(rem)
    Rem = strcat(Rem,',',rem{j});
end
Stats{cnt,2} = Rem;cnt = cnt+1;
clear Rem tok rem;

% prepare fast gapfill
tic; 
[consistModel,consistMatricesSUX,BlockedRxns] = prepareFastGapFill(model);
tpre=toc;

% add more statistics
Stats{cnt,2} = num2str(length(BlockedRxns.allRxns));cnt = cnt+1;
Stats{cnt,2} = num2str(length(BlockedRxns.solvableRxns));cnt = cnt+1;
[a,b] = size(consistModel.S);
Stats{cnt,2} = strcat(num2str(a),'x',num2str(b));cnt = cnt+1;
[a,b] = size(consistMatricesSUX.S);
Stats{cnt,2} = strcat(num2str(a),'x',num2str(b));cnt = cnt+1;

% perform fast gap fill
epsilon = 1e-4;
tic; 
[AddedRxns] = fastGapFill(consistMatricesSUX,epsilon, weights);
tgap=toc;
Stats{cnt,i+1} = num2str(length(AddedRxns.rxns));cnt = cnt+1;

%%


