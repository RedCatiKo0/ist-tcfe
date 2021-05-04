close all 
clear all

R=4.9e3;
C=3.1e-6;

A=23;
t=linspace(0, 20e-3, 1000);
f=50;
w=2*pi*f;
vS = A * cos(w*t);
vOhr = zeros(1, length(t));
vO = zeros(1, length(t));

tOFF = 1/w * atan(1/w/R/C)

vOnexp = A*cos(w*tOFF)*exp(-(t-tOFF)/R/C);
vOnexp2 = A*cos(w*tOFF)*exp(-(t-(tOFF+1/(2*f)))/R/C);

for i=1:length(t)
    vOhr(i) = abs(vS(i));
endfor

ED = figure();
plot(t * 1000, vOhr, "b")
hold on;
plot(t * 1000 + 20, vOhr, "b")
hold on;
plot(t * 1000 + 40, vOhr, "b")
hold on;
plot(t * 1000 + 60, vOhr, "b")
hold on;
plot(t * 1000 + 80, vOhr, "b")
hold on;
plot(t * 1000 + 100, vOhr, "b")
hold on;
plot(t * 1000 + 120, vOhr, "b")
hold on;
plot(t * 1000 + 140, vOhr, "b")
hold on;
plot(t * 1000 + 160, vOhr, "b")
hold on;
plot(t * 1000 + 180, vOhr, "b")
hold on;

for i=1:length(t)
  if t(i) < (tOFF + 1/(2*f))
    if t(i) < tOFF
        vO(i) = vS(i);
    elseif vOnexp(i) > vOhr(i)
        vO(i) = vOnexp(i);
    else
        vO(i) = abs(vS(i));
    endif
  else
    if vOnexp2(i) > vOhr(i)
        vO(i) = vOnexp2(i);
    else
        vO(i) = abs(vS(i));
    endif
  endif
endfor

plot(t * 1000, vO, "r")
hold on;
plot(t * 1000 + 20, vO, "r")
hold on;
plot(t * 1000 + 40, vO, "r")
hold on;
plot(t * 1000 + 60, vO, "r")
hold on;
plot(t * 1000 + 80, vO, "r")
hold on;
plot(t * 1000 + 100, vO, "r")
hold on;
plot(t * 1000 + 120, vO, "r")
hold on;
plot(t * 1000 + 140, vO, "r")
hold on;
plot(t * 1000 + 160, vO, "r")
hold on;
plot(t * 1000 + 180, vO, "r")
title("Envelope Detector, Output Voltage v_o(t)")
xlabel ("Time [ms]")
ylabel ("Voltage [V]")
grid on;
print ("venvlope.eps", "-depsc");
close(ED);


% Voltage Regulator

V_S = (max(vO) + min(vO)) / 2
v_s = (max(vO) - min(vO)) / 2

V_ON  = 6.667062e-01;
r_d   = 1.672289e+01;
n     = 18;

V_O    = n * V_ON
v_o    = n * r_d / (n * r_d + R) * v_s
Ripple = 2 * v_o


fid = fopen('TeoIncrementalAnalysis.tex', 'w+');

fprintf(fid, '$V_O$ (V) & %f \\\\ \\hline\n', V_O);
fprintf(fid, '$Ripple(v_O)$ (V) & %f \\\\ \\hline\n', Ripple);

fclose(fid);



VR = figure();
plot(t * 1000, v_o / v_s * (vO - V_S) + V_O, "r")
hold on;
plot(t * 1000 + 20, v_o / v_s * (vO - V_S) + V_O, "r")
hold on;
plot(t * 1000 + 40, v_o / v_s * (vO - V_S) + V_O, "r")
hold on;
plot(t * 1000 + 60, v_o / v_s * (vO - V_S) + V_O, "r")
hold on;
plot(t * 1000 + 80, v_o / v_s * (vO - V_S) + V_O, "r")
hold on;
plot(t * 1000 + 100, v_o / v_s * (vO - V_S) + V_O, "r")
hold on;
plot(t * 1000 + 120, v_o / v_s * (vO - V_S) + V_O, "r")
hold on;
plot(t * 1000 + 140, v_o / v_s * (vO - V_S) + V_O, "r")
hold on;
plot(t * 1000 + 160, v_o / v_s * (vO - V_S) + V_O, "r")
hold on;
plot(t * 1000 + 180, v_o / v_s * (vO - V_S) + V_O, "r")
title("Voltage Regulator, Output Voltage v_O(t)")
xlabel ("Time [ms]")
ylabel ("Voltage [V]")
grid on;
print ("volreg.eps", "-depsc");
close(VR);

OD = figure();
plot(t * 1000, v_o / v_s * (vO - V_S), "r")
hold on;
plot(t * 1000 + 20, v_o / v_s * (vO - V_S), "r")
hold on;
plot(t * 1000 + 40, v_o / v_s * (vO - V_S), "r")
hold on;
plot(t * 1000 + 60, v_o / v_s * (vO - V_S), "r")
hold on;
plot(t * 1000 + 80, v_o / v_s * (vO - V_S), "r")
hold on;
plot(t * 1000 + 100, v_o / v_s * (vO - V_S), "r")
hold on;
plot(t * 1000 + 120, v_o / v_s * (vO - V_S), "r")
hold on;
plot(t * 1000 + 140, v_o / v_s * (vO - V_S), "r")
hold on;
plot(t * 1000 + 160, v_o / v_s * (vO - V_S), "r")
hold on;
plot(t * 1000 + 180, v_o / v_s * (vO - V_S), "r")
title("Output Deviation, AC Component v_o(t)")
xlabel ("Time [ms]")
ylabel ("Voltage [V]")
grid on;
print ("outdev.eps", "-depsc");
close(OD);