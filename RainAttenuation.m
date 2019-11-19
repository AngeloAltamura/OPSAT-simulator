clear
clc
close all

%% Rain parameters
lambda=1550e-9;
Pin=10; %watt
muShapeFactor=3; % 1 or 2 or 3
DSDType="Ulbrich";
rainSlabLength=2000; %meters
R=0:1:100; % Rain Range

%% Visibility 

load VisibilityToRainFit.mat;
Visibility=feval(VisibilityToRainFit,R)'; % Visibility in meters as a function of Rain
figure
loglog(R,Visibility);
title('Visibility as a function of rain rate');
xlabel('Rain rate mm/hr');
ylabel('Visibility [m]');
grid on;

%% Rain attenuation


% OGM approach
[Pout,LossdB] = rainAttenuationOGM(R,muShapeFactor,rainSlabLength,DSDType,Pin);

% Carbonneau law
LossCarbdB=1.076*R.^0.67*rainSlabLength/1000;
PoutCarb=Pin*10.^(-LossCarbdB/10);

% Multiple scattering Gain
[Gms,Gmsnat]=msGain(R,rainSlabLength,muShapeFactor);

% Marshall
LossMardB=0.365*R.^0.63*rainSlabLength/1000;
PoutMar=Pin*10.^(-LossMardB/10);

% David Atlas
LossAtldB=10*log10(exp(2.9./Visibility*rainSlabLength));
PoutAtl=Pin*10.^(-LossAtldB/10);



%% Plot 
figure
plot(R,Pout)
hold on
plot(R,Pout.*Gmsnat)
plot(R,PoutCarb);
plot(R,PoutCarb.*Gmsnat);
%plot(R,PoutMar);
%plot(R,PoutMar.*Gmsnat);
plot(R,PoutAtl);
plot(R,PoutAtl.*Gmsnat);
title('Output power');
xlabel('Rain Rate mm/hr');
ylabel('Pout [W]');
legend('OGM Model','OGM with G_{ms}','Carbonneau Model','Carbonneau Model with G_{ms}','Atlas Model','Atlas Model with G_{ms}');
%legend('OGM Model','OGM with G_{ms}','Carbonneau Model','Carbonneau Model with G_{ms}','Marshall Model','Marshall Model with G_{ms}','Atlas Model','Atlas Model with G_{ms}');
grid on;
figure
subplot(2,1,1)
plot(R,LossdB);
hold on
plot(R,LossCarbdB);
%plot(R,LossMardB);
plot(R,LossAtldB);
title('Optical loss ');
xlabel('Rain Rate mm/hr');
ylabel('dB');
grid on;
legend('OGM Model','Carbonneau Model','Atlas model');
%legend('OGM Model','Carbonneau Model','Marshall model','Atlas model');
subplot(2,1,2)
plot(R,Gms);
title('Multiple Scattering Gain G_{ms}');
xlabel('Rain Rate mm/hr');
ylabel('G_{ms} [dB]');
grid on
