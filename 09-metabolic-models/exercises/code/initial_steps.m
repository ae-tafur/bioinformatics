initCobraToolbox();

% Define a dir where to save all the results
outputDir = '~/Documents/Training/04_bioinformatics/09-metabolic-models/exercises/results';


% Load the E. coli core model
fileName = 'ecoli_core_model.mat';
if ~exist('modelOri','var')
    modelOri = readCbModel(fileName);
end


%backward compatibility with primer requires relaxation of upper bound on
%ATPM
modelOri = changeRxnBounds(modelOri,'ATPM',1000,'u');
model = modelOri;


%%
printConstraints(model,-1000,1000)


%% Calculate growth rates 

% change uptake rate of glucose
model = changeRxnBounds(model,'EX_glc(e)',-18.5,'l');
 
% change oxygen uptake (unbounded)
model = changeRxnBounds(model,'EX_o2(e)',-1000,'l');

% set biomass as objetive function
model = changeObjective(model,'Biomass_Ecoli_core_N(w/GAM)-Nmet2');


% perform a FBA
FBAsolution = optimizeCbModel(model,'max')

% FBAsolution
fluxData = FBAsolution.v;
nonZeroFlag = 1;
printFluxVector(model, fluxData, nonZeroFlag)


%% Display the optimal vector in a metabolic map

outputFormatOK = changeCbMapOutput('matlab');
map=readCbMap('ecoli_core_map');
options.zeroFluxWidth = 0.1;
options.rxnDirMultiplier = 10;
drawFlux(map, model, FBAsolution.v, options);

set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperOrientation', 'landscape');
set(gcf, 'PaperPosition', [1 1 28 19]);
saveas(f,'flux_distribtuion_glucose_aerobic.pdf')

%% Let's change the aerobic conditions to anaerobic
model = changeRxnBounds(model,'EX_o2(e)',0,'l');

FBAsolution2 = optimizeCbModel(model,'max');
FBAsolution2.f

% check the change in fluxes
fluxData = [FBAsolution.v,FBAsolution2.v];
nonZeroFlag = 1;
excFlag = 1;
printFluxVector(model, fluxData, nonZeroFlag, excFlag)

drawFlux(map, model, FBAsolution2.v, options);

set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperOrientation', 'landscape');
set(gcf, 'PaperPosition', [1 1 28 19]);
saveas(f,'flux_distribtuion_glucose_anaerobic.pdf')

%% Changing the carbon source

% set to zero glucose
model = changeRxnBounds(model,'EX_o2(e)',-1000,'l');
model_ac = changeRxnBounds(model,'EX_glc(e)',0,'l');

% allow acetate consumption
model_ac = changeRxnBounds(model_ac,'EX_ac(e)',-20,'l');

checkObjective(model);

FBAsolution3 = optimizeCbModel(model_ac,'max');
FBAsolution3.f

% check the change in fluxes
fluxData = [FBAsolution.v,FBAsolution3.v];
nonZeroFlag = 1;
excFlag = 1;
printFluxVector(model, fluxData, nonZeroFlag, excFlag)

drawFlux(map, model, FBAsolution3.v, options);

set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperOrientation', 'landscape');
set(gcf, 'PaperPosition', [1 1 28 19]);
saveas(f,'flux_distribtuion_acetate_aerobic.pdf')

%% FLux variability analysis

FVAresults=cell(size(model.S,2)+1,1);
FVAresults{1,1}='Reaction';
FVAresults{1,2}='Minimum Flux';
FVAresults{1,3}='Maximum Flux';
FVAresults(2:end,1)=model.rxns;
[minFlux, maxFlux, ~, ~] = fluxVariability(model, 100, 'max', [], 0, 1, 'FBA');
for n=1:size(model.S,2)
    FVAresults{n+1,2}=minFlux(n);
    FVAresults{n+1,3}=maxFlux(n);
end
bool=abs(maxFlux-minFlux)>=1e-6;
bool=[true;bool];
FVAresults=FVAresults(bool,:)

%% Robutsness analysis for glucose
model = changeRxnBounds(model,'EX_o2(e)',-17,'b');
glucoseUptakeRates = zeros(21,1);
growthRates = zeros(21,1);
for i = 0:20
	model = changeRxnBounds(model,'EX_glc(e)',-i,'b');
        glucoseUptakeRates(i+1)=-i;
	FBAsolution = optimizeCbModel(model,'max');
	growthRates(i+1) = FBAsolution.f;
end

figure; 
plot(-glucoseUptakeRates,growthRates,'-', 'LineWidth', 2)
xlabel('Glucose Uptake Rate (mmol/gDW h)')
ylabel('Growth Rate (1/h)')
set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperOrientation', 'landscape');
set(gcf, 'PaperPosition', [1 1 28 19]);
saveas(f,'robutsness_analysis_glucose.pdf')

%% Robutsness analysis for oxigen

model = changeRxnBounds(model,'EX_glc(e)',-10,'b');
oxygenUptakeRates = zeros(25,1);
growthRates = zeros(25,1);
for i = 0:25
	model = changeRxnBounds(model,'EX_o2(e)',-i,'b');
        oxygenUptakeRates(i+1)=-i;
	FBAsolution = optimizeCbModel(model,'max');
	growthRates(i+1) = FBAsolution.f;
end

figure; 
plot(-oxygenUptakeRates,growthRates,'-', 'LineWidth', 2)
xlabel('Oxygen Uptake Rate (mmol/gDW h)')
ylabel('Growth Rate (1/h)')
set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperOrientation', 'landscape');
set(gcf, 'PaperPosition', [1 1 28 19]);
saveas(f,'robutsness_analysis_oxigen.pdf')

%% Plots three phenotype phase planes

% Plots three phenotype phase planes for two reactions.  The first plot is
% a double robustness analysis, a kind of 3D surface plot.  The second
% two plots show the shadow prices of the metabolites from the two control
% reactions, which define the phases.

[growthRates, shadowPrices1, shadowPrices2] = phenotypePhasePlane(model, 'EX_glc(e)', 'EX_o2(e)');


%% Dynamic model aerobic
model = modelOri;

substrateRxns = { 'EX_glc(e)'; 'EX_ac(e)'; 'EX_nh4(e)'; 'EX_pi(e)'};

initConcentrations = [ 217.16; 0.001; 200; 200];

plotRxns = { 'Biomass_Ecoli_core_N(w/GAM)-Nmet2'; 'EX_glc(e)'; 'EX_succ(e)'; 
    'EX_ac(e)'; 'EX_for(e)'; 'EX_etoh(e)'; 'EX_lac-D(e)'; 'EX_mal-L(e)'};

[dFBAsol] = dynamicFBA(model, substrateRxns, initConcentrations, ...
    0.033, 0.1, 500, plotRxns);


%% Dynamic model anaerobic

model = changeRxnBounds(model,'EX_o2(e)',0,'l');

[dFBAsol] = dynamicFBA(model, substrateRxns, initConcentrations, ...
    0.033, 0.1, 500, plotRxns);

%% KO genes

model = modelOri;

[grRatio,grRateKO,grRateWT] = doubleGeneDeletion(model);

%% OptKnock targets prediction
outputDir = '~/Documents/Training/04_bioinformatics/09-metabolic-models/exercises/results';

model = modelOri;

biomass = 'Biomass_Ecoli_core_N(w/GAM)-Nmet2';

threshold = 5;

selectedRxnList = {'GLCabcpp'; 'GLCptspp'; 'HEX1'; 'PGI'; 'PFK'; 'FBA'; 'TPI'; 'GAPD'; ...
                   'PGK'; 'PGM'; 'ENO'; 'PYK'; 'LDH_D'; 'PFL'; 'ALCD2x'; 'PTAr'; 'ACKr'; ...
                   'G6PDH2r'; 'PGL'; 'GND'; 'RPI'; 'RPE'; 'TKT1'; 'TALA'; 'TKT2'; 'FUM'; ...
                   'FRD2'; 'SUCOAS'; 'AKGDH'; 'ACONTa'; 'ACONTb'; 'ICDHyr'; 'CS'; 'MDH'; ...
                   'MDH2'; 'MDH3'; 'ACALD'};


% prespecified amount of glucose uptake 10 mmol/grDW*hr
model = changeRxnBounds(model, 'EX_glc(e)', -10, 'b');
 
% Unconstrained uptake routes for inorganic phosphate, and ammonia
Exchange={'EX_o2(e)';'EX_pi(e)'; 'EX_nh4(e)'};
Bounds=[-1000;-1000;-1000];
model = changeRxnBounds(model, Exchange, Bounds, 'l');
 
% Enable secretion routes  for acetate, carbon dioxide, ethanol, formate, lactate
% and succinate
Exchange = {'EX_ac(e)';'EX_co2(e)';'EX_etoh(e)';'EX_for(e)';'EX_lac-D(e)';'EX_succ(e)'};
Bounds = [1000;1000;1000;1000;1000;1000];
model = changeRxnBounds(model, Exchange, Bounds, 'u');


% determine succinate production and growth rate
fbaWT = optimizeCbModel(model);
succFluxWT = fbaWT.x(strcmp(model.rxns, 'EX_succ(e)'));
etohFluxWT = fbaWT.x(strcmp(model.rxns, 'EX_etoh(e)'));
formFluxWT = fbaWT.x(strcmp(model.rxns, 'EX_for(e)'));
lactFluxWT = fbaWT.x(strcmp(model.rxns, 'EX_lac-D(e)'));
acetFluxWT = fbaWT.x(strcmp(model.rxns, 'EX_ac(e)'));
growthRateWT = fbaWT.f;
fprintf('The production of succinate before optimization is %.1f \n', succFluxWT);
fprintf('The growth rate before optimization is %.1f \n', growthRateWT);
fprintf(['The production of other products such as ethanol, formate, lactate and'...
         'acetate are %.1f, %.1f, %.1f and %.1f, respectively. \n'], ...
        etohFluxWT, formFluxWT, lactFluxWT, acetFluxWT);

%% Predicting targets for succinate

fprintf('\n...EXAMPLE 1: Finding optKnock sets of size 5 or less for succinate...\n\n')

% Set optKnock options
% The exchange of succinate will be the objective of the outer problem
options = struct('targetRxn', 'EX_succ(e)', 'numDel', 5);
% We will impose that biomass be at least 50% of the biomass of wild-type
constrOpt = struct('rxnList', {{biomass}},'values', 0.5*fbaWT.f, 'sense', 'G');
% We will try to find 10 optKnock sets of a maximun length of 2
previousSolutions_succ = cell(5, 1);
contPreviousSolutions = 1;
nIter = 1;
while nIter <= threshold
    fprintf('...Performing optKnock analysis...\n')
    if isempty(previousSolutions_succ{1})
        optKnockSol = OptKnock(model, selectedRxnList, options, constrOpt);
    else
        optKnockSol = OptKnock(model, selectedRxnList, options, constrOpt, previousSolutions_succ, 1);
    end
    
    % determine succinate production and growth rate after optimization
    succFluxM1 = optKnockSol.fluxes(strcmp(model.rxns, 'EX_succ(e)'));
    growthRateM1 = optKnockSol.fluxes(strcmp(model.rxns, biomass));
    etohFluxM1 = optKnockSol.fluxes(strcmp(model.rxns, 'EX_etoh(e)'));
    formFluxM1 = optKnockSol.fluxes(strcmp(model.rxns, 'EX_for(e)'));
    lactFluxM1 = optKnockSol.fluxes(strcmp(model.rxns, 'EX_lac-D(e)'));
    acetFluxM1 = optKnockSol.fluxes(strcmp(model.rxns, 'EX_ac(e)'));
    setM1 = optKnockSol.rxnList;
    
    if ~isempty(setM1)
        previousSolutions_succ{contPreviousSolutions} = setM1;
        contPreviousSolutions = contPreviousSolutions + 1;
        %printing results
        fprintf('optKnock found a optKnock set of large %d composed by ', length(setM1));
        for j = 1:length(setM1)
            if j == 1
                fprintf('%s', setM1{j});
            elseif j == length(setM1)
                fprintf(' and %s', setM1{j});
            else
                fprintf(', %s', setM1{j});
            end
        end
        fprintf('\n');
        fprintf('The production of succinate after optimization is %.2f \n', succFluxM1);
        fprintf('The growth rate after optimization is %.2f \n', growthRateM1);
        fprintf(['The production of other products such as ethanol, formate, lactate and acetate are' ...
                 '%.1f, %.1f, %.1f and %.1f, respectively. \n'], etohFluxM1, formFluxM1, lactFluxM1, acetFluxM1);
        fprintf('...Performing coupling analysis...\n');
        [type, maxGrowth, maxProd, minProd] = analyzeOptKnock(model, setM1, 'EX_succ(e)');
        fprintf('The solution is of type: %s\n', type);
        fprintf('The maximun growth rate given the optKnock set is %.2f\n', maxGrowth);
        fprintf(['The maximun and minimun production of succinate given the optKnock set is ' ...
                 '%.2f and %.2f, respectively \n\n'], minProd, maxProd);

        singleProductionEnvelope(model, setM1, 'EX_succ(e)', biomass, 'savePlot', 1, 'showPlot', 1, ...
            'fileName', ['succ_mutant_' num2str(nIter)], 'outputFolder', 'OptKnockResults');
    else
        if nIter == 1
            fprintf('optKnock was not able to found an optKnock set\n');
        else
            fprintf('optKnock was not able to found additional optKnock sets\n');
        end
        break;
    end
    nIter = nIter + 1;
end


% run a dynamicFBA for the mutants found
for i = 1:size(previousSolutions_succ, 1)
    
    % select the rxns to delete
    toDelete_succ = previousSolutions_succ{i,1};
    
    % block the reactions flux, so you can simulate a deletion
    model_mut_succ = changeRxnBounds(model, toDelete_succ, 0, 'b');
    
    % perform dynamicFBA for this mutant
    dFBAsol = dynamicFBA(model_mut_succ, substrateRxns, initConcentrations, ...
                         plotRxns, 'savePlot', 1, 'showPlot', 1, ...
            'fileName', ['succ_mutant_' num2str(nIter) '_dFBA'], 'outputFolder', outputDir);
    
end


%% Predicting targets for acetate

fprintf('\n...EXAMPLE 2: Finding optKnock sets of size 5 or less for acetate...\n\n')

% Set optKnock options
% The exchange of succinate will be the objective of the outer problem
options = struct('targetRxn', 'EX_ac(e)', 'numDel', 5);
% We will impose that biomass be at least 50% of the biomass of wild-type
constrOpt = struct('rxnList', {{biomass}},'values', 0.5*fbaWT.f, 'sense', 'G');
% We will try to find 10 optKnock sets of a maximun length of 2
previousSolutions_ac = cell(5, 1);
contPreviousSolutions = 1;
nIter = 1;
while nIter <= threshold
    fprintf('...Performing optKnock analysis...\n')
    if isempty(previousSolutions_ac{1})
        optKnockSol = OptKnock(model, selectedRxnList, options, constrOpt);
    else
        optKnockSol = OptKnock(model, selectedRxnList, options, constrOpt, previousSolutions_ac, 1);
    end
    
    % determine acetate production and growth rate after optimization
    succFluxM1 = optKnockSol.fluxes(strcmp(model.rxns, 'EX_succ(e)'));
    growthRateM1 = optKnockSol.fluxes(strcmp(model.rxns, biomass));
    etohFluxM1 = optKnockSol.fluxes(strcmp(model.rxns, 'EX_etoh(e)'));
    formFluxM1 = optKnockSol.fluxes(strcmp(model.rxns, 'EX_for(e)'));
    lactFluxM1 = optKnockSol.fluxes(strcmp(model.rxns, 'EX_lac-D(e)'));
    acetFluxM1 = optKnockSol.fluxes(strcmp(model.rxns, 'EX_ac(e)'));
    setM1 = optKnockSol.rxnList;
    
    if ~isempty(setM1)
        previousSolutions_ac{contPreviousSolutions} = setM1;
        contPreviousSolutions = contPreviousSolutions + 1;
        %printing results
        fprintf('optKnock found a optKnock set of large %d composed by ', length(setM1));
        for j = 1:length(setM1)
            if j == 1
                fprintf('%s', setM1{j});
            elseif j == length(setM1)
                fprintf(' and %s', setM1{j});
            else
                fprintf(', %s', setM1{j});
            end
        end
        fprintf('\n');
        fprintf('The production of acetate after optimization is %.2f \n', acetFluxM1);
        fprintf('The growth rate after optimization is %.2f \n', growthRateM1);
        fprintf(['The production of other products such as ethanol, formate, lactate and succinate are ' ...
                 '%.1f, %.1f, %.1f and %.1f, respectively. \n'], etohFluxM1, formFluxM1, lactFluxM1, succFluxM1);
        fprintf('...Performing coupling analysis...\n');
        [type, maxGrowth, maxProd, minProd] = analyzeOptKnock(model, setM1, 'EX_ac(e)');
        fprintf('The solution is of type: %s\n', type);
        fprintf('The maximun growth rate given the optKnock set is %.2f\n', maxGrowth);
        fprintf(['The maximun and minimun production of acetate given the optKnock set is ' ...
                 '%.2f and %.2f, respectively \n\n'], minProd, maxProd);
        singleProductionEnvelope(model, setM1, 'EX_ac(e)', biomass, 'savePlot', 1, 'showPlot', 1, ...
            'fileName', ['ac_mutant_' num2str(nIter)], 'outputFolder', outputDir);
    else
        if nIter == 1
            fprintf('optKnock was not able to found an optKnock set\n');
        else
            fprintf('optKnock was not able to found additional optKnock sets\n');
        end
        break;
    end
    nIter = nIter + 1;
end


% run a dynamicFBA for the mutants found
for i = 1:size(previousSolutions_ac, 1)
    
    % select the rxns to delete
    toDelete_ac = previousSolutions_ac{i,1};
    
    % block the reactions flux, so you can simulate a deletion
    model_mut_ac = changeRxnBounds(model, toDelete_ac, 0, 'b');
    
    % perform dynamicFBA for this mutant
    dFBAsol = dynamicFBA(model_mut_ac, substrateRxns, initConcentrations, ...
                         plotRxns, 'savePlot', 1, 'showPlot', 1, ...
            'fileName', ['ac_mutant_' num2str(nIter) '_dFBA'], 'outputFolder', outputDir);
    
end