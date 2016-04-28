%% Evaluation of the Ishigami Function using the gPC OLS Regression Method
%% Deleting everything before running the code
% clear variables;
% clc;
% close all;
%% Initializing UQLab
uqlab
clearvars

%% Creation of a Model
MOpts.mFile = 'uq_ishigami' ;
myModel = uq_createModel(MOpts);

%% Creating an Input
for i = 1:3
    IOpts.Marginals(i).Type = 'Uniform' ;
    IOpts.Marginals(i).Parameters = [-pi, pi] ;
end

myInput = uq_createInput(IOpts);

%% Setup of PCE

MetaOpts.Type = 'uq_metamodel';
MetaOpts.MetaType = 'PCE';

% Type definition for the polynomials that are classicaly orthogonal
% regarding their distribution. By now, only the Hermite and Legendre are
% available.
MetaOpts.PolyTypes = {'Legendre','Legendre','Legendre'};

% Specification of the input
MetaOpts.Input = myInput;

% Specification of the model...the used model will be all the time the
% Ishigami model that was created
MetaOpts.FullModel = myModel;

%% Creation and Calculation of a gPC Least-Square Model

%Calculation of a OLS regression model by sweeping the polynomial degree
MetaOpts.Method = 'OLS';

MetaOpts.ExpDesign.Sampling = 'MC';

mean_ols = zeros(1,15);
sd_ols = zeros(1,15);
degreeOLS = zeros(1,15);
error_ols = zeros(1,15);
numbOLSSamp = zeros(1,15);

% Sweeping over the polynomial degree
for n=1:15
    MetaOpts.Degree = n;
    % Expressing the amount of samples in dependece on the polynomial
    % degree...the higher the polynomial degree, the more samples you need,
    % but unforutunately this relation is not linear
    numbOLSSamp (n) = 100*MetaOpts.Degree;
    MetaOpts.ExpDesign.NSamples = numbOLSSamp(n);
    PCE_OLS = uq_createModel(MetaOpts);
    mean_ols(n) = PCE_OLS.PCE.Moments.Mean;
    sd_ols(n) = sqrt(PCE_OLS.PCE.Moments.Var);
    
    if PCE_OLS.Error.LOO < 1e-20
        error_ols(n) = 0;
    else
         error_ols(n) = PCE_OLS.Error.LOO;
    end
    degreeOLS(n) = n;
end

%% Plots for the OLS Regression Method

figure;
subplot(2,1,1);
uq_plot(degreeOLS,mean_ols,'g');
xlabel('Degrees'),ylabel('Mean');
title('Mean Convergence in Dependence on the Pol. Degree');
drawnow

subplot(2,1,2);
uq_plot(numbOLSSamp,mean_ols,'g');
xlabel('Amount of Samples'),ylabel('Mean');
title('Mean Convergence in Dependence on the Samp. Points');
drawnow


figure;
subplot(2,1,1);
uq_plot(degreeOLS,sd_ols,'g');
xlabel('Degrees'),ylabel('SD of OLS');
title('SD Convergence in Dependence on the Pol. Degree');
drawnow

subplot(2,1,2);
uq_plot(numbOLSSamp,sd_ols,'g');
xlabel('Amount of Samples'),ylabel('SD');
title('SD Convergence in Dependence on the Samp. Points');
drawnow

figure;
subplot(2,1,1);
uq_plot(degreeOLS,log10(error_ols),'g');
xlabel('Degree'),ylabel('log(error)');
xlim([0 15]);
title('OLS Regression Error Depending on the Polynomial Degree');
drawnow

subplot(2,1,2);
uq_plot(numbOLSSamp,log10(error_ols),'g');
xlabel('Amount of Samples'),ylabel('log(error)');
title('OLS Regression Error Depending on the Polynomial Degree');
drawnow
