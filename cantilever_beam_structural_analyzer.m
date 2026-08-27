%% CANTILEVER BEAM STRUCTURAL ANALYZER
% Analytical structural sizing and parametric design study for a
% rectangular cantilever beam under an end point load.
%
% Outputs include:
% - bending moment, stress, strain, slope and deflection
% - strength and serviceability checks
% - allowable load and required beam height
% - redesign validation
% - parametric height study and feasible-design selection
% - five engineering plots

clear
clc
close all

%% INPUT DATA

L = 1.5;          % Beam length [m]
b = 0.05;         % Beam width [m]
h = 0.10;         % Beam height [m]

E = 69e9;         % Young's modulus [Pa]
F = 2500;         % Applied load [N]

yieldStrength = 276e6;   % Yield strength [Pa]

%% BEAM POSITION

x = linspace(0,L,101);

%% SECTION PROPERTIES

I = b*h^3/12;
c = h/2;

%% BENDING MOMENT

M = F*(L - x);

%% BENDING STRESS

sigma = (M * c)/I;

%% DEFLECTION

y = F*(x.^2).*(3*L - x)/(6*E*I);

%% Max Results

maxDeflection = max(y);
maxStress = max(sigma);
isYielding = maxStress > yieldStrength;

maxStressMpa = maxStress / 10^6;
maxDeflectionmm = maxDeflection * 10^3;
factorOfsafety = yieldStrength/ maxStress;

%% CRITICAL LOCATIONS

[maxStress, stressIndex] = max( sigma );

[maxDeflection, deflectionIndex] = max( y );

stressLocation = x(stressIndex);

deflectionLocation = x(deflectionIndex);
%% ENGINEERING SUMMARY

fprintf('\n=== CANTILEVER BEAM STRUCTURAL ANALYSIS ===\n');

fprintf('Beam Length          : %.2f m\n', L);
fprintf('Applied Load         : %.0f N\n', F);

fprintf('Maximum Stress       : %.2f MPa\n', maxStressMpa);
fprintf('Maximum Deflection   : %.2f mm\n', maxDeflectionmm);
fprintf('Factor of Safety     : %.2f\n', factorOfsafety);

if isYielding
    fprintf('Structural Status     : FAIL - Yielding predicted\n');
else
    fprintf('Structural Status     : PASS - Below yield strength\n');
end

fprintf('Critical Stress Location        : %.2f m\n', stressLocation);

fprintf('Maximum Deflection Location     : %.2f m\n', deflectionLocation);

%% BENDING MOMENT PLOT

figure

plot( x, M/1e3, 'LineWidth' , 2 );

xlabel( 'Beam position, x [m]' )
ylabel( 'Bending Moment, M [kN-m]' )
title( 'Bending Moment Distribution' )

grid on

%% BENDING STRESS PLOT

figure

plot( x, sigma/1e6, 'LineWidth', 2 );
hold on
plot(stressLocation, maxStressMpa, 'o', 'MarkerSize', 8, 'LineWidth', 2);
xlabel( 'Beam position, x [m]' )

ylabel( 'Bending stress, sigma [MPa] ' )

title( 'Bending Stress Distribution' )

grid on

%% DEFLECTION PLOT

figure

plot( x, y*1e3, 'LineWidth', 2 );
hold on

plot( deflectionLocation, maxDeflectionmm, 'o', 'MarkerSize', 8, 'LineWidth', 2 );
xlabel( 'Beam position, x [m]' )

ylabel( 'Deflection, y [mm]' )

title( 'Beam Deflection Distribution' )

grid on

%% SUPPORT REACTIONS AND SHEAR FORCE

reactionForce = F;

reactionMoment = F * L;

V = F * ones(size(x));

%% SECTION MODULUS AND BENDING STRAIN

Z = I/ c;

strain = sigma/E;

maxStrain = max(strain);

maxStrainMicro = maxStrain * 1e6;

%% BEAM SLOPE / ROTATION

theta = F*x.*(2*L - x)/(2*E*I);

maxSlope = max( theta );

maxSlopeDeg = maxSlope * 180/pi;

%% MAXIMUM SLOPE LOCATION

[maxSlope, slopeIndex] = max( theta );

slopeLocation = x( slopeIndex );

%% ALLOWABLE LOAD CALCULATION

yieldLoad = (yieldStrength*I)/(L*c);

loadUtilization = (F/yieldLoad)*100;

%% DEFLECTION-BASED LOAD LIMIT

allowableDeflection = 5/1e3;

deflectionLoadLimit = (3*E*I*allowableDeflection)/(L^3);

governingLoad = min( yieldLoad, deflectionLoadLimit );

%% SERVICEABILITY CHECK

deflectionUtilization = (maxDeflection/allowableDeflection)*100;

isDeflectionExceeded = maxDeflection > allowableDeflection;

overallPass = ~isYielding && ~isDeflectionExceeded;

%% REQUIRED BEAM HEIGHT

requiredHeightStrength = sqrt((6*F*L)/(b*yieldStrength));

requiredHeightDeflection = ((4*F*L^3)/(E*b*allowableDeflection))^(1/3);

requiredHeight = max( requiredHeightStrength, requiredHeightDeflection );

%% GOVERNING DESIGN CRITERION

if requiredHeightStrength > requiredHeightDeflection
    governingCriterion = ' Strength governs ';
else
    governingCriterion = ' Deflection governs ';
end

%% REDESIGNED SECTION PROPERTIES

Irequired = (b*requiredHeight^3)/12;

Zrequired = Irequired/(requiredHeight/2);

areaRequired = b* requiredHeight;
%% REDESIGN VALIDATION

redesignStress = (F*L)/Zrequired;

redesignDeflection = (F*L^3)/(3*E*Irequired);

redesignFoS = yieldStrength/redesignStress;

%% REDESIGN COMPARISON

heightIncreasePercent = ((requiredHeight-h)/h)*100;

stressReductionPercent = ((maxStress - redesignStress)/maxStress)*100;

deflectionReductionPercent = ((maxDeflection - redesignDeflection)/maxDeflection)*100;

%% PARAMETRIC HEIGHT STUDY

heightRange = linspace(0.06, 0.15, 50);

stressStudy = zeros(size(heightRange));

deflectionStudy = zeros(size(heightRange));

fosStudy = zeros(size(heightRange));

for i = 1:length(heightRange)

    hTest = heightRange(i);

    ITest = b*hTest^3/12;

    cTest = hTest/2;

    stressStudy(i) = (F*L*cTest)/ITest;

    deflectionStudy(i) = (F*L^3)/(3*E*ITest);

    fosStudy(i) = yieldStrength/stressStudy(i);

end

%% FEASIBLE DESIGN SELECTION

meetsStress = stressStudy <= yieldStrength;

meetsDeflection = deflectionStudy <= allowableDeflection;

feasibleDesign = meetsStress & meetsDeflection;

firstFeasibleIndex = find(feasibleDesign, 1, 'first');

selectedHeight = heightRange(firstFeasibleIndex);

%% PARAMETRIC DEFLECTION STUDY

figure

plot(heightRange*1e3, deflectionStudy*1e3, ...
    'LineWidth', 2);

hold on

yline(allowableDeflection*1e3, '--', ...
    'Allowable Deflection');

plot(selectedHeight*1e3, ...
    deflectionStudy(firstFeasibleIndex)*1e3, ...
    'o', 'MarkerSize', 8, 'LineWidth', 2);

xlabel('Beam Height, h [mm]');

ylabel('Maximum Deflection [mm]');

title('Effect of Beam Height on Maximum Deflection');

legend('Maximum Deflection', ...
    'Allowable Limit', ...
    'Selected Design', ...
    'Location', 'best');

grid on

%% ORIGINAL VS REDESIGNED UTILIZATION

originalStressUtilization = ...
    (maxStress/yieldStrength)*100;

originalDeflectionUtilization = ...
    (maxDeflection/allowableDeflection)*100;

redesignStressUtilization = ...
    (redesignStress/yieldStrength)*100;

redesignDeflectionUtilization = ...
    (redesignDeflection/allowableDeflection)*100;

utilizationComparison = [
    originalStressUtilization, originalDeflectionUtilization;
    redesignStressUtilization, redesignDeflectionUtilization
    ];

figure

bar(categorical({'Original Design','Redesigned Design'}), ...
    utilizationComparison);

hold on

yline(100, '--', 'Design Limit');

ylabel('Utilization [%]');

title('Original vs Redesigned Beam Performance');

legend('Stress Utilization', ...
    'Deflection Utilization', ...
    'Design Limit', ...
    'Location', 'best');

grid on
