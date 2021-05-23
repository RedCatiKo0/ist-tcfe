%gain stage

VT=25e-3
BFN=178.7
VAFN=69.7
RE1=100
RC1=1100
RB1=80000
RB2=20000
VBEON=0.7
VCC=12
RS=100
RL=8

RB=1/(1/RB1+1/RB2)
VEQ=RB2/(RB1+RB2)*VCC
IB1=(VEQ-VBEON)/(RB+(1+BFN)*RE1)
IC1=BFN*IB1
IE1=(1+BFN)*IB1
VE1=RE1*IE1
VO1=VCC-RC1*IC1
VCE=VO1-VE1


gm1=IC1/VT
rpi1=BFN/gm1
ro1=VAFN/IC1

RSB=RB*RS/(RB+RS)

AV1 = RSB/RS * RC1*(RE1-gm1*rpi1*ro1)/((ro1+RC1+RE1)*(RSB+rpi1+RE1)+gm1*RE1*ro1*rpi1 - RE1^2)
AVI_DB = 20*log10(abs(AV1))
AV1simple = RB/(RB+RS) * gm1*RC1/(1+gm1*RE1)
AVIsimple_DB = 20*log10(abs(AV1simple))

RE1=0
AV1_c = RSB/RS * RC1*(RE1-gm1*rpi1*ro1)/((ro1+RC1+RE1)*(RSB+rpi1+RE1)+gm1*RE1*ro1*rpi1 - RE1^2)
AVI_DB_c = 20*log10(abs(AV1))
AV1simple_c =  - RSB/RS * gm1*RC1/(1+gm1*RE1)
AVIsimple_DB_c = 20*log10(abs(AV1simple))

RE1=100
ZI1 = 1/(1/RB+1/(((ro1+RC1+RE1)*(rpi1+RE1)+gm1*RE1*ro1*rpi1 - RE1^2)/(ro1+RC1+RE1)))
ZX = ro1*((RSB+rpi1)*RE1/(RSB+rpi1+RE1))/(1/(1/ro1+1/(rpi1+RSB)+1/RE1+gm1*rpi1/(rpi1+RSB)))
ZX = ro1*(   1/RE1+1/(rpi1+RSB)+1/ro1+gm1*rpi1/(rpi1+RSB)  )/(   1/RE1+1/(rpi1+RSB) ) 
ZO1 = 1/(1/ZX+1/RC1)

RE1=0
ZI1 = 1/(1/RB+1/(((ro1+RC1+RE1)*(rpi1+RE1)+gm1*RE1*ro1*rpi1 - RE1^2)/(ro1+RC1+RE1)))
ZO1 = 1/(1/ro1+1/RC1)
RE1=100


fid = fopen('OP-GainStage.tex', 'w+');

fprintf(fid, '$R_B$ ($\\Omega$)    & %f \\\\ \\hline\n', RB);
fprintf(fid, '$V_{eq}$ (V)    & %f \\\\ \\hline\n', VEQ);
fprintf(fid, '$I_E$ (A) & %f \\\\ \\hline\n', IE1);
fprintf(fid, '$I_B$ (A) & %f \\\\ \\hline\n', IB1);
fprintf(fid, '$I_C$ (A) & %f \\\\ \\hline\n', IC1);
fprintf(fid, '$V_O$ (V) & %f \\\\ \\hline\n', VO1);
fprintf(fid, '$V_E$ (V) & %f \\\\ \\hline\n', VE1);
fprintf(fid, '$V_{CE}$ (V) & %f \\\\ \\hline\n', VCE);

fclose(fid);


fid = fopen('AC-GainStage.tex', 'w+');

fprintf(fid, '$g_m$ (mS)    & %f \\\\ \\hline\n', gm1 * 1E3);
fprintf(fid, '$r_{\\pi}$ ($\\Omega$)    & %f \\\\ \\hline\n', rpi1);
fprintf(fid, '$r_o$ ($\\Omega$)    & %f \\\\ \\hline\n', ro1);
fprintf(fid, '$ \\frac{v_{o_1}}{v_i}$ (Ganho sem o condensador de \\emph{bypass})  & %f \\\\ \\hline\n', AV1);
fprintf(fid, '$ \\frac{v_{o_1}}{v_i}$ (Ganho com o condensador de \\emph{bypass})  & %f \\\\ \\hline\n', AV1_c);


fclose(fid);


% Output stage
BFP = 227.3
VAFP = 37.2
RE2 = 100
VEBON = 0.7
VI2 = VO1
IE2 = (VCC-VEBON-VI2)/RE2
IC2 = BFP/(BFP+1)*IE2
VO2 = VCC - RE2*IE2

gm2 = IC2/VT
go2 = IC2/VAFP
gpi2 = gm2/BFP
ge2 = 1/RE2

AV2 = gm2/(gm2+gpi2+go2+ge2)
ZI2 = (gm2+gpi2+go2+ge2)/gpi2/(gpi2+go2+ge2)
ZO2 = 1/(gm2+gpi2+go2+ge2)

fid = fopen('OP-OutputStage.tex', 'w+');

fprintf(fid, '$I_{out}$ (A)    & %f \\\\ \\hline\n', IE2);
fprintf(fid, '$I_{col_2}$ (A)    & %f \\\\ \\hline\n', IC2);
fprintf(fid, '$V_{O_2}$ (V)    & %f \\\\ \\hline\n', VO2);

fclose(fid);

fid = fopen('AC-OutputStage.tex', 'w+');

fprintf(fid, '$g_{\\pi}$ (mS)    & %f \\\\ \\hline\n', gpi2 * 1E3);
fprintf(fid, '$g_{E}$ (mS)    & %f \\\\ \\hline\n', ge2 * 1E3);
fprintf(fid, '$g_{o}$ (mS)    & %f \\\\ \\hline\n', go2 * 1E3);
fprintf(fid, '$g_{m}$ (mS)    & %f \\\\ \\hline\n', gm2 * 1E3);
fprintf(fid, '$ \\frac{v_{o_2}}{v_i} (\\textnormal{Ganho})$   & %f \\\\ \\hline\n', AV2);

fclose(fid);


%total
gB = 1/(1/gpi2+ZO1)
AV = (gB+gm2/gpi2*gB)/(gB+ge2+go2+gm2/gpi2*gB)*AV1
AV_DB = 20*log10(abs(AV))
ZI=ZI1
ZO=1/(go2+gm2/gpi2*gB+ge2+gB)


fid = fopen('Impedances.tex', 'w+');

fprintf(fid, '$Z_{I_1}$ ($\\Omega$)    & %f \\\\ \\hline\n', ZI1);
fprintf(fid, '$Z_{O_1}$ ($\\Omega$)    & %f \\\\ \\hline\n', ZO1);
fprintf(fid, '$Z_{I_2}$ ($\\Omega$)    & %f \\\\ \\hline\n', ZI2);
fprintf(fid, '$Z_{O_2}$ ($\\Omega$)    & %f \\\\ \\hline\n', ZO2);
fprintf(fid, '$Z_I$ ($\\Omega$)    & %f \\\\ \\hline\n', ZI);
fprintf(fid, '$Z_O$ ($\\Omega$)    & %f \\\\ \\hline\n', ZO);
fprintf(fid, '$\\frac{v_{out}}{v_{s}}$     & %f \\\\ \\hline\n', AV);
fprintf(fid, '$\\frac{v_{out}}{v_{s}} (dB)$     & %f \\\\ \\hline\n', AV_DB);

fclose(fid);


% 2. frequency response - gain stage

pkg load symbolic

RB1_s = vpa(RB1)
RB2_s = vpa(RB2)
RE_s = vpa(RE1)
RB_s = vpa(RB)
RS_s = vpa(RS)
RC1_s = vpa(RC1)
RE1_s = vpa(RE1)
RE2_s = vpa(RE2)
CI_s = vpa(2e-3)
CE_s = vpa(1.9e-3)
CO_s = vpa(1.8e-3)
gm1_s = vpa(gm1)
gm2_s = vpa(gm2)
ro1_s = vpa(ro1)
rpi1_s = vpa(rpi1)
ro2_s = vpa(1/go2)
rpi2_s = vpa(1/gpi2)
vi_s = vpa(10e-3*exp(-i*pi/2))
RL_s = vpa(RL)

j = vpa(i)
ZERO = vpa(0)
ONE = vpa(1)
TWO = vpa(2)
syms f

% A = [1/(j*TWO*pi*f*CE_s) + r0_s + RC_s, ZERO, -r0_s, -ONE/(j*TWO*pi*f*CE_s); ZERO, RS_s + RB_s + rpi_s + RE_s + ONE/(j*TWO*pi*f*CI_s), ZERO, -RE_s; ZERO, gm_s * rpi_s, 1, ZERO; -1/(j*TWO*pi*CE_s), -RE_s, ZERO, RE_s+1/(j*TWO*pi*f*CE_s)]

A=[ONE,ZERO,ZERO,ZERO,ZERO,ZERO,ZERO;-ONE/RS_s, ONE/RS_s + j*f*TWO*pi*CI_s,-j*f*TWO*pi*CI_s,ZERO,ZERO,ZERO,ZERO; ZERO,-j*f*TWO*pi*CI_s,ONE/RB1_s+1/RB2_s+j*f*TWO*pi*CI_s+ONE/rpi1_s,-ONE/rpi1_s,ZERO,ZERO,ZERO;ZERO,ZERO,-ONE/rpi1_s-gm1_s,ONE/rpi1_s+ONE/RE1_s+j*TWO*pi*f*CE_s+gm1_s+ONE/ro1_s,-ONE/ro1_s,ZERO,ZERO;ZERO,ZERO,gm1_s,-gm1_s-ONE/ro1_s,ONE/ro1_s+ONE/RC1_s+ONE/rpi2_s,-ONE/rpi2_s,ZERO;ZERO,ZERO,ZERO,ZERO,-ONE/rpi2_s-gm2_s,ONE/RE2_s+ONE/rpi2_s+ONE/ro2_s+gm2_s+j*TWO*pi*f*CO_s,-j*TWO*pi*f*CO_s;ZERO,ZERO,ZERO,ZERO,ZERO,-j*TWO*pi*f*CO_s,j*TWO*pi*f*CO_s+ONE/RL_s]
B=[vi_s;ZERO;ZERO;ZERO;ZERO;ZERO;ZERO]

V = A \ B

f = logspace(1, 8, 100);

vo_P = function_handle(atan(imag(V(7) / vi_s) / real(V(7) / vi_s) ) * 180 / pi)
vo_M = function_handle(20*log10(abs(V(7) / vi_s)))

htP = figure();
semilogx(f, vo_P(f), "g")
hold on;
xlabel ("f [Hz]");
ylabel ("T2(f) - Phase [Degrees]");
grid on;
print(htP, "FrequencyResponsePhaseOutput.eps", "-depsc");
close(htP);


htM = figure();
semilogx(f, vo_M(f), "b")
hold on;
xlabel ("f [Hz]");
ylabel ("T2(f) - Magnitude [dB]");
grid on;
print(htM, "FrequencyResponseMagOutput.eps", "-depsc");
close(htM);

vg_P = function_handle(atan(imag(V(5) / vi_s) / real(V(5) / vi_s) ) * 180 / pi)
vg_M = function_handle(20*log10(abs(V(5) / vi_s)))

htP1 = figure();
semilogx(f, vg_P(f), "g")
hold on;
xlabel ("f [Hz]");
ylabel ("T1(f) - Phase [Degrees]");
grid on;
print(htP1, "FrequencyResponsePhaseGainStage.eps", "-depsc");
close(htP1);


htM1 = figure();
semilogx(f, vg_M(f), "b")
hold on;
xlabel ("f [Hz]");
ylabel ("T1(f) - Magnitude [dB]");
grid on;
print(htM1, "FrequencyResponseMagGainStage.eps", "-depsc");
close(htM1);