close all
clear all

% Numeric Computations


R1 = 1.01258106833e3 %Ohm
R2 = 2.01414322128e3 %Ohm
R3 = 3.14471800951e3 %Ohm
R4 = 4.0512295385e3  %Ohm
R5 = 3.04120010333e3 %Ohm
R6 = 2.02925076831e3 %Ohm
R7 = 1.01071894298e3 %Ohm

Va = 5.2435704532    %V
Id = 1.0346810568e-3 %A

Kb = 7.06081365014e-3 %S
Kc = 8.16086836519e3  %Ohm


% Nodal Method

A = [-1/R1,1/R1 + 1/R2 + 1/R3, -1/R2, 0, -1/R3, 0, 0, 0;0, -1/R2 - Kb, 1/R2, 0, Kb, 0, 0, 0;0, Kb, 0, 0, -Kb-1/R5, 1/R5, 0, 0;0,0,0, -1/R6, 0, 0, 1/R6 + 1/R7, - 1/R7;0,0,0,0,0,0,0, 1;0,0,0,0, 1/Kc, 0, -1/R7, 1/R7 - 1/Kc;1, 0, 0, -1, 0, 0, 0, 0;1/R1, -1/R1, 0, 1/R4 + 1/R6, -1/R4, 0, -1/R6, 0]

B = [0; 0; Id; 0; 0; 0; Va; 0]

D = A\B

Vb = D(2) - D(5)
Ic = 1/Kc * D(5) - 1/Kc * D(8)

f1 = fopen('NodalMethod.tex', 'w+');

for i = 1 : size(D)
    fprintf(f1, '$V_%d$ (V) & %f \\\\ \\hline\n', i, D(i));
end

fprintf(f1, '$V_b$ (V) & %f \\\\ \\hline\n', Vb);
fprintf(f1, '$I_c$ (A) & %f \\\\ \\hline\n', Ic);

fclose(f1);


% Mesh Method

E = [R1 + R3 + R4, - R3, -R4, 0; -R4, 0, R6 + R7 + R4 - Kc, 0; 0, 0, 0, 1; Kb*R3, 1 - Kb*R3, 0, 0]

F = [Va; 0; -Id; 0]

G = E\F

Vb = R3 * (G(1) - G(2))
Ic = - G(3)

f2 = fopen('MeshMethod.tex', 'w+');

for i = 1 : size(G)
    fprintf(f2, '$I_%d$ (A) & %f \\\\ \\hline\n', i, G(i));
end

fprintf(f2, '$V_b$ (V) & %f \\\\ \\hline\n', Vb);
fprintf(f2, '$I_c$ (A) & %f \\\\ \\hline\n', Ic);

fclose(f2);