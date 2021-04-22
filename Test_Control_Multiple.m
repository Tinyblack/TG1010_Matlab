%% Clear the working environment
close all
clear 

%% Instrument Connection
% For TG1010
% <rmt>   <RESPONSE MESSAGE TERMINATOR>
% <cpd>   <CHARACTER PROGRAM DATA>, i.e. a short mnemonic or string     ...
%         such as ON or OFF.
% <nrf>   A number in any format. e.g. 12, 12.00, 1.2 e 1 and 120 e-1   ...
%         are all accepted as the number 12. Any number, when received, ...
%         is converted to the required precision consistent with the use...
%         then rounded up to obtain the value of the command. 
% <nr1>   A number with no fractional part, i.e. an integer.
% [..]    Any item(s) enclosed in these brackets are optional           ...
%         parameters. If more than one item is enclosed then all or none...
%         of the items are required.
% The commands which begin with a * are those specified by IEEE Std.    ...
% 488.2 as Common commands. All will function when used on the RS232    ... 
% interface but some are of little use.


% Find a serial port object.
TG1010 = instrfind('Type', 'serial', 'Port', 'COM1');

% Create the serial port object if it does not exist
% otherwise use the object that was found.
if isempty(TG1010)
    TG1010 = serial('COM1');
else
    fclose(TG1010);
    TG1010 = TG1010(1);
end

TG1010.Terminator={'CR','LF'};
TG1010.FlowControl='software';
TG1010.InputBufferSize=256;
TG1010.outputBufferSize=256;
TG1010.RequestToSend='off';

% Connect to instrument object, obj1.
fopen(TG1010);
fprintf(TG1010, '%s\n', ';*RST;');
while(str2double(query(TG1010,';*OPC?;'))~=1.0)
end
fprintf(TG1010, '%s\n', ';*IDN?;');
TG1010__Identification=fscanf(TG1010,'%s');


fprintf(TG1010, '%s\n', ';OUTPUT ON;');% Set output <ON>, <OFF>, <NORMAL> or <INVERT>
fprintf(TG1010, '%s\n', ';FREQ 1000;');% Set main frequency to <nrf> Hz
% fprintf(TG1010, '%s\n', ';PER 1;');% Set main period to <nrf> seconds
fprintf(TG1010, '%s\n', ';EMFPP 5;');% Set output level to <nrf> emf Vpp
% fprintf(TG1010, '%s\n', ';EMFRMS 5;');% Set output level to <nrf> emf Vrms
% fprintf(TG1010, '%s\n', ';PDPP 5;');% Set output level to <nrf> pd Vpp
% fprintf(TG1010, '%s\n', ';PDRMS 5;');% Set output level to <nrf> pd Vrms
%fprintf(TG1010, '%s\n', ';DBM -10;');% Set output level to <nrf> pd dBm
fprintf(TG1010, '%s\n', ';ZOUT 50;');% Set output impedance to <nrf>; only 50 or 600 are legal.
fprintf(TG1010, '%s\n', ';DCOFFS 0;');% Set dc offset to <nrf> Volts
fprintf(TG1010, '%s\n', ';SYMM 50;');% Set symmetry to <nrf> %
% fprintf(TG1010, '%s\n', ';PHASE 0;');% Set phase to <nrf> degrees

% fprintf(TG1010, '%s\n', ';SINE;');% Set sine function
fprintf(TG1010, '%s\n', ';SQUARE;');% Set square function
% fprintf(TG1010, '%s\n', ';TRIAN;');% Set triangle function
% fprintf(TG1010, '%s\n', ';POSPUL;');% Set positive pulse function
% fprintf(TG1010, '%s\n', ';NEGPUL;');% Set negative pulse function
% fprintf(TG1010, '%s\n', ';POSRAMP;');% Set positive ramp function
% fprintf(TG1010, '%s\n', ';NEGRAMP;');% Set negative ramp function
% fprintf(TG1010, '%s\n', ';STAIR;');% Set staircase function
% fprintf(TG1010, '%s\n', ';ARB;');% Set arbitrary function
% fprintf(TG1010, '%s\n', ';NOISE ON;');% Set NOISE <ON> or <OFF>

Tektronix= instrfind('Type', 'visa-usb', 'RsrcName', 'USB0::0x0699::0x0365::C030655::0::INSTR');

if isempty(Tektronix)
    Tektronix = visa('TEK', 'USB0::0x0699::0x0365::C030655::0::INSTR');
else
    fclose(Tektronix);
    Tektronix = Tektronix(1);
end

Tektronix.EOIMode='on';
% Buffer size should be larger than points*datasize
Tektronix.InputBufferSize=5120;

Tektronix.EOSMode='read&write';

fopen(Tektronix);

%% Instrument Configuration and Control

% Communicating with instrument object.


fprintf(Tektronix, '%s\n', ';*RST;');
while(str2double(query(Tektronix,';*OPC?;'))~=1.0)
end

fprintf(Tektronix, '%s\n', ';AUTOSet EXECute;');
while(str2double(query(Tektronix,';*OPC?;'))~=1.0)
end

fprintf(Tektronix, '%s\n', ';*IDN?;');
Tek_Identification = fscanf(Tektronix,'%s');

fprintf(Tektronix, '%s\n', ';SELECT:CH1 ON;');
fprintf(Tektronix, '%s\n', ';CH1:Probe 1;');

fprintf(Tektronix, '%s\n', ';SELECT:CH2 ON;');
fprintf(Tektronix, '%s\n', ';CH2:Probe 1;');

%fprintf(Tektronix, '%s\n', ';HORizontal?;');
%hor=fscanf(Tektronix,'%s');

fprintf(Tektronix, '%s\n', ';HORizontal:MAIn:SCAle?;');
hor_div=fscanf(Tektronix,':HORIZONTAL:MAIN:SCALE%f');

fprintf(Tektronix, '%s\n', ';CH1:SCAle?;');
CH1_ver_div=fscanf(Tektronix,':CH1:SCALE%f');

fprintf(Tektronix, '%s\n', ';CH2:SCAle?;');
CH2_ver_div=fscanf(Tektronix,':CH2:SCALE%f');

fprintf(Tektronix, '%s\n', ';CH1:POSition?;');
CH1_pos_div=fscanf(Tektronix,':CH1:POSITION%f');

fprintf(Tektronix, '%s\n', ';CH2:POSition?;');
CH2_pos_div=fscanf(Tektronix,':CH2:POSITION%f');

%fprintf(Tektronix, '%s\n', ';WFMPre?;');
%wfm=fscanf(Tektronix,'%s');
for i=5:-1:2
fprintf(TG1010, '%s\n', [';EMFPP ' num2str(i) ';']);% Set output level to <nrf> emf Vpp

fprintf(Tektronix, '%s\n', ';ACQUIRE:STATE OFF;');
fprintf(Tektronix, '%s\n', ';ACQUIRE:MODE SAMPLE;');
fprintf(Tektronix, '%s\n', ';ACQuire:STOPAfter SEQuence;');
fprintf(Tektronix, '%s\n', ';ACQuire:STATE ON;');

fprintf(Tektronix, '%s\n', ';MEASUREMENT:IMMED:TYPE AMPLITUDE;');
fprintf(Tektronix, '%s\n', ';MEASUREMENT:IMMED:SOURCE CH1;');
while(str2double(query(Tektronix,';*OPC?;'))~=1.0)
end
fprintf(Tektronix, '%s\n', ';MEASUREMENT:MEAS1:VALUE?;');
measure_CH1=fscanf(Tektronix,'%s');

fprintf(Tektronix, '%s\n', ';MEASUREMENT:IMMED:SOURCE CH2;');
while(str2double(query(Tektronix,';*OPC?;'))~=1.0)
end
fprintf(Tektronix, '%s\n', ';MEASUREMENT:MEAS2:VALUE?;');
measure_CH2=fscanf(Tektronix,'%s');

fprintf(Tektronix, '%s\n', ';DATa:SOUrce CH1;');
fprintf(Tektronix, '%s\n', ';DATa:ENCdg RIBinary;');
fprintf(Tektronix, '%s\n', ';DATa:WIDth 2;');
fprintf(Tektronix, '%s\n', ';DATa:STARt 1;');
fprintf(Tektronix, '%s\n', ';DATa:STOP 2500;');
fprintf(Tektronix, '%s\n', ';CURV?;');

data_raw_CH1(:,i) = fread(Tektronix, 2506, 'int16');
data_CH1(:,i)=(data_raw_CH1(7:2506,i)./32767).*(5*CH1_ver_div);
% data_CH1_offset=(data_raw_CH1(7:2506)./32767).*(5*CH1_ver_div);
% data_CH1=data_CH1_offset-CH1_ver_div*CH1_pos_div;
[t_size_CH1,~]=size(data_CH1(:,i));
t_CH1=1:1:t_size_CH1;
t_CH1=t_CH1.*(hor_div/(2500/10));

fprintf(Tektronix, '%s\n', ';DATa:SOUrce CH2;');
fprintf(Tektronix, '%s\n', ';DATa:ENCdg RIBinary;');
fprintf(Tektronix, '%s\n', ';DATa:WIDth 2;');
fprintf(Tektronix, '%s\n', ';DATa:STARt 1;');
fprintf(Tektronix, '%s\n', ';DATa:STOP 2500;');
fprintf(Tektronix, '%s\n', ';CURV?;');

data_raw_CH2(:,i) = fread(Tektronix, 2506, 'int16');
data_CH2(:,i)=(data_raw_CH2(7:2506,i)./32767).*(5*CH2_ver_div);
% data_CH2_offset=(data_raw_CH2(7:2506)./32767).*(5*CH2_ver_div);
% data_CH2=data_CH2_offset-CH2_ver_div*CH2_pos_div;
[t_size_CH2,~]=size(data_CH2(:,i));
t_CH2=1:1:t_size_CH2;
t_CH2=t_CH2.*(hor_div/(2500/10));
figure
plot(t_CH1,data_CH1(:,i),t_CH2,data_CH2(:,i));
end
%% Disconnect and Clean Up

% Disconnect from instrument object, obj1.
fclose(TG1010);
fclose(Tektronix);

% The following code has been automatically generated to ensure that any
% object manipulated in TMTOOL has been properly disposed when executed
% as part of a function or script.

% Clean up all objects.
delete(TG1010);
delete(Tektronix);
clear Tektronix
clear TG1010;
