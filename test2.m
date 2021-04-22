%% TEST Code for communicating with an instrument.
%
%   This is the machine generated representation of an instrument control
%   session. The instrument control session comprises all the steps you are
%   likely to take when communicating with your instrument. These steps are:
%   
%       1. Instrument Connection
%       2. Instrument Configuration and Control
%       3. Disconnect and Clean Up
% 
%   To run the instrument control session, type the name of the file,
%   test, at the MATLAB command prompt.
% 
%   The file, TEST.M must be on your MATLAB PATH. For additional information 
%   on setting your MATLAB PATH, type 'help addpath' at the MATLAB command 
%   prompt.
% 
%   Example:
%       test;
% 
%   See also SERIAL, GPIB, TCPIP, UDP, VISA, BLUETOOTH, I2C, SPI.
% 
%   Creation time: 03-Nov-2020 20:32:36

%% Instrument Connection

% Find a serial port object.
% obj1 = instrfind('Type', 'serial', 'Port', 'COM1', 'Tag', '');
% 
% % Create the serial port object if it does not exist
% % otherwise use the object that was found.
% if isempty(obj1)
%     obj1 = serial('COM1');
% else
%     fclose(obj1);
%     obj1 = obj1(1);
% end
obj1 = serial('COM1');
obj1.Terminator={'CR','LF'};

% Connect to instrument object, obj1.
fopen(obj1);

%% Instrument Configuration and Control

% Communicating with instrument object, obj1.
fprintf(obj1, '%s\n', '*IDN?');
data1=fscanf(obj1,'%s');
data2=query(obj1,'*IDN?\n');

%% Disconnect and Clean Up

% Disconnect from instrument object, obj1.
fclose(obj1);

% The following code has been automatically generated to ensure that any
% object manipulated in TMTOOL has been properly disposed when executed
% as part of a function or script.

% Clean up all objects.
delete(obj1);
clear obj1;

