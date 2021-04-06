close all
clear all


% Read Values From File

fin = fopen('../data.txt', 'r');

template = '\n \n Please enter the lowest student number in your group: \n \n \n Units for the values: V, mA, kOhm, mS and uF \n \n \n Values: R1 = %f \n R2 = %f \n R3 = %f \n R4 = %f \n R5 = %f \n R6 = %f \n R7 = %f \n Vs = %f \n C = %f \n Kb = %f \n Kd = %f \n \n \n \n';
D = fscanf(fin, template);

fclose(fin);



% Assign Values to Variables

R1 = D(1)  * 1e+3 %Ohm
R2 = D(2)  * 1e+3 %Ohm
R3 = D(3)  * 1e+3 %Ohm
R4 = D(4)  * 1e+3 %Ohm
R5 = D(5)  * 1e+3 %Ohm
R6 = D(6)  * 1e+3 %Ohm
R7 = D(7)  * 1e+3 %Ohm

Vs = D(8)  * 1e+0 %V
C  = D(9)  * 1e-6 %F
Kb = D(10) * 1e-3 %S
Kd = D(11) * 1e+3 %Ohm



% 1. Node Analysis with t < 0

A = [1, 0 , 0 , 0 , 0 , 0 , 0; -1/R1, 1/R1 + 1/R2 + 1/R3, -1/R2, -1/R3, 0, 0, 0; 0, 1/R2 + Kb, - 1/R2, -Kb, 0, 0, 0; 0, -1/R3, 0, 1/R3 + 1/R4 + 1/R5, -1/R5, -1/R7, 1/R7; 0, Kb, 0, -1/R5 - Kb, 1/R5, 0, 0; 0, 0, 0, 0, 0, 1/R6 + 1/R7, -1/R7; 0, 0, 0, 1, 0, Kd/R6, -1]
B = [Vs; 0; 0; 0; 0; 0; 0]

V = A \ B              %V
Vd = Kd * (-V(6) / R6) %V
Vb = V(2) - V(4)       %V

Id  = -V(6) / R6         %A
Ib  = Kb * (V(2) - V(4)) %A
I1 = (V(1) - V(2)) / R1  %A
I2 = (V(2) - V(3)) / R2  %A
I3 = (V(2) - V(4)) / R3  %A
I4 = -V(4) / R4          %A
I5 = (V(4) - V(5)) / R5  %A
I6 = -V(6) / R6          %A
I7 = (V(6) - V(7)) / R7  %A


fid = fopen('Teo1-NodalMethod.tex', 'w+');

fprintf(fid, '$I_d$ (mA)    & %f \\\\ \\hline\n', Id * 1e+3);
fprintf(fid, '$I_b$ (mA)    & %f \\\\ \\hline\n', Ib * 1e+3);
fprintf(fid, '$I_{R1}$ (mA) & %f \\\\ \\hline\n', I1 * 1e+3);
fprintf(fid, '$I_{R2}$ (mA) & %f \\\\ \\hline\n', I2 * 1e+3);
fprintf(fid, '$I_{R3}$ (mA) & %f \\\\ \\hline\n', I3 * 1e+3);
fprintf(fid, '$I_{R4}$ (mA) & %f \\\\ \\hline\n', I4 * 1e+3);
fprintf(fid, '$I_{R5}$ (mA) & %f \\\\ \\hline\n', I5 * 1e+3);
fprintf(fid, '$I_{R6}$ (mA) & %f \\\\ \\hline\n', I6 * 1e+3);
fprintf(fid, '$I_{R7}$ (mA) & %f \\\\ \\hline\n', I7 * 1e+3);

fprintf(fid, '$V_1$ (V) & %f \\\\ \\hline\n', V(1));
fprintf(fid, '$V_2$ (V) & %f \\\\ \\hline\n', V(2));
fprintf(fid, '$V_3$ (V) & %f \\\\ \\hline\n', V(3));
fprintf(fid, '$V_4$ (V) & 0  \\\\ \\hline\n');
fprintf(fid, '$V_5$ (V) & %f \\\\ \\hline\n', V(4));
fprintf(fid, '$V_6$ (V) & %f \\\\ \\hline\n', V(5));
fprintf(fid, '$V_7$ (V) & %f \\\\ \\hline\n', V(6));
fprintf(fid, '$V_8$ (V) & %f \\\\ \\hline\n', V(7));
fprintf(fid, '$V_d$ (V) & %f \\\\ \\hline\n', Vd);
fprintf(fid, '$V_b$ (V) & %f \\\\ \\hline\n', Vb);

fclose(fid);



% First Simulation Variables

fout = fopen('../sim/FirstSimVars.mod', 'w+');

fprintf(fout, 'R1 1 2  %f\n'  , R1);
fprintf(fout, 'R2 2 3  %f\n'  , R2);
fprintf(fout, 'R3 2 5  %f\n'  , R3);
fprintf(fout, 'R4 0 5  %f\n'  , R4);
fprintf(fout, 'R5 5 6  %f\n'  , R5);
fprintf(fout, 'R6 0 7a %f\n'  , R6);
fprintf(fout, 'R7 7b 8 %f\n\n', R7);

fprintf(fout, 'Vs   1  0  %f\n', Vs);
fprintf(fout, 'Vaux 7a 7b 0\n\n');

fprintf(fout, 'Gb 6 3 2 5  %f\n', Kb);
fprintf(fout, 'Hd 5 8 Vaux %f'  , Kd);

fclose(fout);



% 2. Equivalent Resistance

V6 = V(5)
V8 = V(7)
Vx = V6 - V8

clear A B V

A = [1/R1 + 1/R2 + 1/R3, -1/R2, -1/R3, 0, 0, 0; 1/R2 + Kb, -1/R2, -Kb, 0, 0, 0; 0, 0, 1, 0, Kd/R6, -1; 0, 0, 0, 1, 0, -1; 0, 0, 0, 0, 1/R6 + 1/R7, -1/R7; -1/R3 + Kb, 0, 1/R3 + 1/R4 - Kb, 0, -1/R7, 1/R7]
B = [0; 0; 0; Vx; 0; 0]

V = A \ B              %V
Vd = Kd * (-V(5) / R6) %V
Vb = V(1) - V(3)       %V

Id  = -V(5) / R6             %A
Ib  = Kb * (V(1) - V(3))     %A
I1 = -V(1) / R1              %A
I2 = (V(1) - V(2)) / R2      %A
I3 = (V(1) - V(3)) / R3      %A
I4 = -V(3) / R4              %A
I5 = (V(3) - V(4)) / R5      %A
I6 = -V(5) / R6              %A
I7 = (V(5) - V(6)) / R7      %A
Ix = (V(4) - V(3)) / R5 + Ib %A

Req = Vx / Ix %Ohm
tau = Req * C %s

f2 = fopen('Teo2-EquivalentResistance.tex', 'w+');

fprintf(fid, '$I_d$ (mA)    & %f \\\\ \\hline\n', Id * 1e+3);
fprintf(fid, '$I_b$ (mA)    & %f \\\\ \\hline\n', Ib * 1e+3);
fprintf(fid, '$I_{R1}$ (mA) & %f \\\\ \\hline\n', I1 * 1e+3);
fprintf(fid, '$I_{R2}$ (mA) & %f \\\\ \\hline\n', I2 * 1e+3);
fprintf(fid, '$I_{R3}$ (mA) & %f \\\\ \\hline\n', I3 * 1e+3);
fprintf(fid, '$I_{R4}$ (mA) & %f \\\\ \\hline\n', I4 * 1e+3);
fprintf(fid, '$I_{R5}$ (mA) & %f \\\\ \\hline\n', I5 * 1e+3);
fprintf(fid, '$I_{R6}$ (mA) & %f \\\\ \\hline\n', I6 * 1e+3);
fprintf(fid, '$I_{R7}$ (mA) & %f \\\\ \\hline\n', I7 * 1e+3);

fprintf(fid, '$V_1$ (V) & 0  \\\\ \\hline\n');
fprintf(fid, '$V_2$ (V) & %f \\\\ \\hline\n', V(1));
fprintf(fid, '$V_3$ (V) & %f \\\\ \\hline\n', V(2));
fprintf(fid, '$V_4$ (V) & 0  \\\\ \\hline\n');
fprintf(fid, '$V_5$ (V) & %f \\\\ \\hline\n', V(3));
fprintf(fid, '$V_6$ (V) & %f \\\\ \\hline\n', V(4));
fprintf(fid, '$V_7$ (V) & %f \\\\ \\hline\n', V(5));
fprintf(fid, '$V_8$ (V) & %f \\\\ \\hline\n', V(6));
fprintf(fid, '$V_b$ (V) & %f \\\\ \\hline\n', Vb);
fprintf(fid, '$V_d$ (V) & %f \\\\ \\hline\n', Vd);

fprintf(fid, '$V_x$ (V) & %f  \\\\ \\hline\n', Vx);
fprintf(fid, '$I_x$ (mA) & %f \\\\ \\hline\n', Ix * 1e+3);
fprintf(fid, '$R_{eq}$ ($\\Omega$) & %f \\\\ \\hline\n', Req);
fprintf(fid, '$\\tau$ (ms)         & %f \\\\ \\hline\n', tau * 1e+3);

fclose(fid);



% Second Simulation Variables

fout = fopen('../sim/SecondSimVars.mod', 'w+');

fprintf(fout, 'R1 1 2  %f\n'  , R1);
fprintf(fout, 'R2 2 3  %f\n'  , R2);
fprintf(fout, 'R3 2 5  %f\n'  , R3);
fprintf(fout, 'R4 0 5  %f\n'  , R4);
fprintf(fout, 'R5 5 6  %f\n'  , R5);
fprintf(fout, 'R6 0 7a %f\n'  , R6);
fprintf(fout, 'R7 7b 8 %f\n\n', R7);

fprintf(fout, 'Vs   1  0  0\n');
fprintf(fout, 'Vaux 7a 7b 0\n');
fprintf(fout, 'Vx   6  8  %f\n\n', Vx);

fprintf(fout, 'Gb 6 3 2 5  %f\n', Kb);
fprintf(fout, 'Hd 5 8 Vaux %f'  , Kd);

fclose(fout);



% 3. Natural Solution

pkg load symbolic

syms t vc(t)

t=0:1e-6:20e-3;
v6n = Vx * exp(-t / tau);

hf = figure();
plot(1000 * t, v6n, "b");
xlabel("t [ms]");
ylabel("v_{6n}(t) [V]");
grid on;
print(hf, "NaturalSolution.eps", "-depsc");
close(hf);



% Third Simulation Variables

fout = fopen('../sim/ThirdSimVars.mod', 'w+');

fprintf(fout, '.ic V(6) = %f V(8) = %f\n\n', V6, V8);

fprintf(fout, 'R1 1 2  %f\n'  , R1);
fprintf(fout, 'R2 2 3  %f\n'  , R2);
fprintf(fout, 'R3 2 5  %f\n'  , R3);
fprintf(fout, 'R4 0 5  %f\n'  , R4);
fprintf(fout, 'R5 5 6  %f\n'  , R5);
fprintf(fout, 'R6 0 7a %f\n'  , R6);
fprintf(fout, 'R7 7b 8 %f\n'  , R7);
fprintf(fout, 'C1 6  8 %f\n\n', C);

fprintf(fout, 'Vs   1  0  0\n');
fprintf(fout, 'Vaux 7a 7b 0\n\n');

fprintf(fout, 'Gb 6 3 2 5  %f\n', Kb);
fprintf(fout, 'Hd 5 8 Vaux %f'  , Kd);

fclose(fout);



% Fourth Simulation Variables

fout = fopen('../sim/FourthSimVars.mod', 'w+');

fprintf(fout, '.ic V(6) = %f V(8) = %f\n\n', V(4), V(6));

fprintf(fout, 'R1 1 2  %f\n'  , R1);
fprintf(fout, 'R2 2 3  %f\n'  , R2);
fprintf(fout, 'R3 2 5  %f\n'  , R3);
fprintf(fout, 'R4 0 5  %f\n'  , R4);
fprintf(fout, 'R5 5 6  %f\n'  , R5);
fprintf(fout, 'R6 0 7a %f\n'  , R6);
fprintf(fout, 'R7 7b 8 %f\n'  , R7);
fprintf(fout, 'C1 6 8  %f\n\n', C);

fprintf(fout, 'Vs   1  0  0.0 ac 1.0 sin(0 1 1K)\n');
fprintf(fout, 'Vaux 7a 7b 0\n\n');

fprintf(fout, 'Gb 6 3 2 5  %f\n', Kb);
fprintf(fout, 'Hd 5 8 Vaux %f'  , Kd);

fclose(fout);



% 4. Forced Solution

clear A B V
clear t

j = i
f = 1000 % Hz
w = 2 * pi * f % rad/s
Vs_p = -j

A = [1, 0, 0, 0, 0, 0, 0; -1/R1, 1/R1 + 1/R2 + 1/R3, -1/R2, -1/R3, 0, 0, 0; 0, 1/R2 + Kb, -1/R2, -Kb, 0, 0, 0; 0, 0, 0, 1, 0, Kd/R6, -1; 0, Kb, 0, -Kb-1/R5, 1/R5 + j*w*C, 0, -j*w*C; 0, 0, 0, 0, 0, 1/R6 + 1/R7, -1/R7; 0, -1/R3, 0, 1/R3 + 1/R4 + 1/R5, -j*w*C - 1/R5, -1/R7, 1/R7 + j*w*C]
B = [Vs_p; 0; 0; 0; 0; 0; 0]

V = A \ B

fid = fopen('Teo3-ForcedSolution.tex', 'w+');

fprintf(fid, '$|\\widetilde{V_1}|$  (V) & %f \\\\ \\hline\n', abs(V(1)));
fprintf(fid, '$|\\widetilde{V_2}|$  (V) & %f \\\\ \\hline\n', abs(V(2)));
fprintf(fid, '$|\\widetilde{V_3}|$  (V) & %f \\\\ \\hline\n', abs(V(3)));
fprintf(fid, '$|\\widetilde{V_4}|$  (V) & 0  \\\\ \\hline\n');
fprintf(fid, '$|\\widetilde{V_5}|$  (V) & %f \\\\ \\hline\n', abs(V(4)));
fprintf(fid, '$|\\widetilde{V_6}|$  (V) & %f \\\\ \\hline\n', abs(V(5)));
fprintf(fid, '$|\\widetilde{V_7}|$  (V) & %f \\\\ \\hline\n', abs(V(6)));
fprintf(fid, '$|\\widetilde{V_8}|$  (V) & %f \\\\ \\hline\n', abs(V(7)));

fclose(fid);

syms t v6(t) vs(t)

t=0:1e-6:20e-3;
v6f = abs(V(5)) * cos(w*t + arg(V(5)));
vs = sin(w*t);

ht = figure();
plot (1000 * t, v6f, "g");
xlabel ("t [ms]");
ylabel ("v_{6f}(t) [V]");
grid on;
print (ht, "ForcedSolution.eps", "-depsc");
close(ht);



% 5. Total Solution

hs = figure();
line ([-5 0], [V6 V6], "linestyle", "-", "color", "g");
hold on;
plot (1000 * t, v6n + v6f, "g");
hold on;
line ([-5 0], [Vs Vs], "linestyle", "-", "color", "r");
hold on;
plot (1000 * t, vs, "r");

xlabel ("t [ms]");
ylabel ("v_s(t) and v_6(t) [V]");
grid on;
print (hs, "TotalSolution.eps", "-depsc");
close(hs);


% 6. Frequency Responses

clear f
clear A B V
clear R1 R2 R3 R4 R5 R6 R7 Vs C Kd Kb

R1 = vpa(D(1)  * 1e+3)  
R2 = vpa(D(2)  * 1e+3)  
R3 = vpa(D(3)  * 1e+3) 
R4 = vpa(D(4)  * 1e+3)  
R5 = vpa(D(5)  * 1e+3) 
R6 = vpa(D(6)  * 1e+3)  
R7 = vpa(D(7)  * 1e+3)  

Vs = vpa(D(8)  * 1e+0)  
C  = vpa(D(9)  * 1e-6)  
Kb = vpa(D(10) * 1e-3)  
Kd = vpa(D(11) * 1e+3)  

j    = vpa(i)
Vs_p = vpa(-i)
Z    = vpa(0)
I    = vpa(1)
TWO  = vpa(2)

syms f

A = [I, Z, Z, Z, Z, Z, Z; -I/R1, I/R1 + I/R2 + I/R3, -I/R2, -I/R3, Z, Z, Z; Z, I/R2 + Kb, -I/R2, -Kb, Z, Z, Z; Z, Z, Z, I, Z, Kd/R6, -I; Z, Kb, Z, -Kb-I/R5, I/R5 + j*TWO*pi*f*C, Z, -j*TWO*pi*f*C; Z, Z, Z, Z, Z, I/R6 + I/R7, -I/R7; Z, -I/R3, Z, I/R3 + I/R4 + I/R5, -j*TWO*pi*f*C - I/R5, -I/R7, I/R7 + j*TWO*pi*f*C]
B = [Vs_p; Z; Z; Z; Z; Z; Z]
V = A \ B

f = logspace(-1, 6, 100);

TvcM = function_handle(20*log10(abs((V(5) - V(7)) / Vs_p)));
Tv6M = function_handle(20*log10(abs(V(5) / Vs_p)));
TvsM = 0;

htM = figure();
semilogx(f, TvcM(f), "b");
hold on;
semilogx(f, Tv6M(f), "g");
hold on;
line ([0.1 1e+6], [0 0], "linestyle", "-", "color", "r");
xlabel ("f [Hz]");
ylabel ("Magnitude [dB]");
grid on;
print(htM, "FrequencyResponseMag.eps", "-depsc");
close(htM)

TvcP = function_handle(arg((V(5) - V(7)) / Vs_p) * 180/pi);
Tv6P = function_handle(arg(V(5) / Vs_p) * 180/pi);

htP = figure();
semilogx(f, TvcP(f), "b");
hold on;
semilogx(f, Tv6P(f), "g");
hold on;
line ([0.1 1e+6], [0 0], "linestyle", "-", "color", "r");
xlabel ("f [Hz]");
ylabel ("Phase [Degrees]");
grid on;
print(htP, "FrequencyResponsePhase.eps", "-depsc");
close(htP);