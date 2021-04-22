%% AFG.m
% Author: John Sandford O'Neill
% Date: 02/11/2020
% This short script demonstrates control of Tektronix function generators.
% TekVISA is required and can be downloaded from https://uk.tek.com/oscilloscope/tds7054-software/tekvisa-connectivity-software-v411
% Other VISA implementations may work. 


instrreset
afg = visa('tek','USB0::0x0699::0x0340::C010200::0::INSTR'); % must be changed for the correct address

fopen(afg);
fprintf(afg, '*RST'); % resets instrument
fprintf(afg, 'OUTP1:IMP INF'); % sets output impedance to high Z
fprintf(afg, 'SOURCE1:FUNCTION SQUARE'); % sets square waveform
fprintf(afg, 'SOURCE1:FREQ:FIX 1KHZ'); % sets frequency
fprintf(afg, 'SOURCE1:VOLT:UNIT VRMS'); % sets the voltage units to Vrms
fprintf(afg, 'OUTP1:STAT ON'); % turns on the output

%%

voltage = 3.7;

fprintf(afg, ['SOURCE1:VOLT:LEV:IMM ' num2str(voltage) 'VRMS']); % sets voltage
