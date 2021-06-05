R1 = 0.5*10^3
R2 = 1*10^3
C1 = 220*10^(-9)
C2 = 220*10^(-9)
Ra= 1/(1/100000 + 1/100000 + 1/100000 + 1/10000)
Rb = 5000

% Cálculo da Frequência Central

pkg load symbolic
syms fs

Z1s = R1 + 1/(j*2*pi*fs*C1)
Z2s = 1/(1/R2 + j * 2*pi*fs *C2)
Zas = vpa(Ra)
Zbs = vpa(Rb)

fM = abs(solve(Zas*(Z1s+Z2s)-Z1s*(Zas+Zbs) == 0))
fc = double(fM(1))



% Cálculo da Impedância de Entrada

j = i
w = 2*pi*double(fc)
Z1 = R1 + 1/(j*w*C1)
Z2 = 1/(1/R2 + j * w *C2)
Za = Ra
Zb = Rb

ZI = Z1 / (1 - 1/(Z1 * (1/Z1 + 1/Z2 - Zb/Z2 * (1/Za + 1/Zb))))
abs(ZI)


% Cálculo do Gain na frequência central

clear f w Z1 Z2 Za Zb j

syms f;

j = vpa(i)
w = 2*pi*f
Z1 = R1 + 1/(j*w*C1)
Z2 = 1/(1/R2 + j * w *C2)
Za = vpa(Ra)
Zb = vpa(Rb)

f = logspace(1, 8, 1000);

G = function_handle(abs(Z2*(Zb + Za)/(Za*(Z1+Z2) - Z1*(Za+Zb))))
G_dB = function_handle(20*log10(abs(Z2*(Zb + Za)/(Za*(Z1+Z2) - Z1*(Za+Zb)))))
G_phase = function_handle(arg(Z2*(Zb + Za)/(Za*(Z1+Z2) - Z1*(Za+Zb))))

G_centralF = double(G_dB(fc))

% Frequency Response

htM = figure();
semilogx(f, G_dB(f), "b");
xlabel ("f [Hz]");
ylabel ("Magnitude [dB]");
grid on;
print(htM, "FrequencyResponseMag.eps", "-depsc");
close(htM)

htP = figure();
semilogx(f, G_phase(f), "b");
xlabel ("f [Hz]");
ylabel ("Phase [Degrees]");
grid on;
print(htP, "FrequencyResponsePhase.eps", "-depsc");
close(htP);


% Impressão de Resultados


fid = fopen('TeoAnalysis.tex', 'w+');

fprintf(fid, 'Central Frequency - $f_c$ (Hz)   & %f \\\\ \\hline\n', fc);
fprintf(fid, 'Input Impedance at Central Frequency - $Z_I$ ($\\Omega$)   & %f + %f j \\\\ \\hline\n', real(ZI), imag(ZI));
fprintf(fid, 'Absolute Value of Input Impedance at Central Frequency - $abs(Z_I)$ ($\\Omega$)   & %f \\\\ \\hline\n', abs(ZI));
fprintf(fid, 'Output Impedance at Central Frequency - $Z_O$ ($\\Omega$)   & %f \\\\ \\hline\n', 0);
fprintf(fid, 'Gain at Central Frequency - $G(f = f_c)$  & %f \\\\ \\hline\n', G_centralF);

fclose(fid);