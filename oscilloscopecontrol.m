%% oscilloscopecontrol.m
% Author: John Sandford O'Neill
% Date: 02/11/2020
% This short script demonstrates control of Tektronix oscilloscopes.
% TekVISA is required and can be downloaded from https://uk.tek.com/oscilloscope/tds7054-software/tekvisa-connectivity-software-v411
% Other VISA implementations may work. 



osc = visa('tek', 'USB0::0x0699::0x0365::C030655::0::INSTR');

fopen(osc);
fprintf(osc, '*RST'); % resets instrrument
fprintf(osc, 'SEL:CH2 1'); % turns on channel 2

% The following lines set up a "measurement" on the oscilloscope so that
% the mean of channel 2 is being measured.
fprintf(osc, 'MEASU:MEAS1:SOU CH2'); % sets measurement 1 to channel 2
fprintf(osc, 'MEASU:MEAS1:TYPE MEAN'); % sets measurement 1 to mean

% THe following lines set up the probe attenuation/compensation for each
% channel
fprintf(osc, 'CH1:PRO 1'); 
fprintf(osc, 'CH2:PRO 1');

% The following lines set up the scale for each channel. 
fprintf(osc, 'CH1:SCA 5'); % sets channel 1 to 5V / scale division
fprintf(osc, 'CH2:SCA 0.02'); % sets channel 2 to 0.02V / scale division