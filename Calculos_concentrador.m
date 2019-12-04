clc,clear all,close all

% calculo de energia disponivel no receptor segundo (CASTELLANOS,2012)

%lambda=0.99;% fator de sombreamento  
rho=0.94; %refletividade do espelho (tabelado)
%tal=; %transmitancia
%alfa=; %absorbancia do absorvedor
talfa=0.99; %produto tal*alfa
teta_i=0; %angulo de incidencia
A_conc=0.6^2*pi/4 ; % area do concentrador (m²)
G_b=200:100:800; % irradiação (W/m²)
sigma=5.67*10^(-8); % constante de stefan-boltzmann (w/(m²K^4))
T_amb=27+273; %temperatura ambiente (K)
f_s=0.95; % Abertura sem sombra
cos_teta_i=1; % Fator de seguimento solar
phi=0.9; % fator de intercepção (Zanganeh et al., 2010)
R=287.0530; %constante de gases (J/kg*K)
V_max=0.3; %volume de expansão (L)
V_min=0.0434; %volume de compressão(L) 

%---------------Início dos cálculos no concentrador ---------------

%formula da energia no concentrador (W)
Q_abs=A_conc*G_b; %Energia no concentrador ideal
n_conc=f_s*cos_teta_i*rho*phi; % eficiencia do concentrador 
Q_conc_real=Q_abs*n_conc; %energia do concentrador corrigida
%------------- Fim dos Cálculos no concentador----------------------------


%------------ Início dos Cálculos no Receptor---------------------

%variaveis receptor
alfa_abs=0.9;  %absorbancia do receptor
e=0.24; % emissividade do cilindro-pistão (valor tabelado)ferro e aço
A_recp=0.05^2*pi/4; % Area do receptor (m²)

%temperatura teorica no receptor
C = A_conc/A_recp;
Cmax_real = C*alfa_abs*rho;
k = 0.06; %fator de atenuação
T_recp_teo=(G_b*Cmax_real*alfa_abs*k/(sigma*e)).^(1/4); %Temperatura teórica no receptor, corrigindo com o material
T_recp_teo_celsius=T_recp_teo-273.15;
%Perda por convecção
v_vento = 2.77; %velocidade média do vento em bsb
hc=7.12*(v_vento^0.775) + 5.129^(-0.6*v_vento); %coeficiente de convecção
Q_conv = hc*A_recp*(T_recp_teo-T_amb); % [W] energia perdida por convecção

%Perda por radiação
T_sky=0.055*T_amb^1.5; %temperatura infinita
Q_rad = e*sigma*A_recp*(T_recp_teo.^4 - T_sky.^4);

%Energia Útil no receptor
Qfinal_receptor = Q_conc_real - Q_rad - Q_conv;
%-----------Finaliza-se o calculo no receptor-----------------%
%Q_rad+Q_conv
rendimento= Qfinal_receptor./Q_conc_real*100;
%-----------Inicia-se o calculo da energia no motor----------------------%

%Eficiência Stirling
ks = 0.55; %coeficiente de stirling, 0,55 a 0,88 segundo Bancha e Somai 2005
n_str = ks*(1-(T_amb./T_recp_teo));

%Energia no stirling
P_str = Qfinal_receptor.*n_str; %energia disponível ao final do ciclo stirling

%Calcular aqui o trabalho do ciclo stirling (só pra completar)
%W_str=R*m*(T_recp_teo-T_amb)*log(V_max/V_min);
%------------Finaliza-se o calculo da energia no motor-------------

%----------- Inicia-se o cálculo da energia no gerador----------
n_gerador = 0.94;% %segundo (CASTELLANOS,2012)
W_gerador = n_gerador.*P_str; %Potência disponível no gerador
tensao_ger= 6; % Esse valor pode mudar 
Corrente=W_gerador./6; %Corrente de operação para 6V


