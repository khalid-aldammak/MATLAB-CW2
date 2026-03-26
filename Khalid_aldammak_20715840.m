% Insert name here
% Khalid Al Dammak
% Insert email address here
% egyka14@nottingham.ac.uk

%% PRELIMINARY TASK - ARDUINO AND GIT INSTALLATION [5 MARKS]
clc
clear

% Create Arduino object
a = arduino();

% Choose LED digital pin
ledPin = 'D12';

% Turn LED on
writeDigitalPin(a, ledPin, 1);
pause(1);

% Turn LED off
writeDigitalPin(a, ledPin, 0);
pause(1);

% Make LED blink at 0.5 s intervals
for k = 1:10
    writeDigitalPin(a, ledPin, 1);   % LED ON
    pause(0.5);

    writeDigitalPin(a, ledPin, 0);   % LED OFF
    pause(0.5);
end
%% TASK 1 - READ TEMPERATURE DATA, PLOT, AND WRITE TO A LOG FILE [20 MARKS]
clear a
a = arduino;
% Acquisition duration in seconds
duration = 600;

% MCP9700A sensor constants
V0 = 0.5;         % Voltage at 0 degC [V]
TC = 0.01;        % Temperature coefficient [V/degC]

% Analogue input pin used by the temperature sensor
sensorPin = 'A0';

% Number of samples from 0 s to duration s
numSamples = duration + 1;

% Preallocate arrays
timeData = zeros(numSamples,1);
voltageData = zeros(numSamples,1);
temperatureData = zeros(numSamples,1);

% Read voltage approximately every 1 second
for k = 1:numSamples
    timeData(k) = k - 1;
    voltageData(k) = readVoltage(a, sensorPin);
    temperatureData(k) = (voltageData(k) - V0) / TC;

    if k < numSamples
        pause(1);
    end
end

% Calculate statistics
minTemp = min(temperatureData);
maxTemp = max(temperatureData);
avgTemp = mean(temperatureData);

% Plot temperature against time
figure;
plot(timeData, temperatureData, '-o');
xlabel('Time (s)');
ylabel('Temperature (°C)');
title('Capsule Temperature vs Time');
grid on;

% Save plot as image
saveas(gcf, 'capsule_temperature_plot.png');

% Date and location
currentDate = datestr(now, 'dd/mm/yyyy');
locationName = 'Nottingham';

% Build formatted output text
outputText = sprintf('Data logging initiated - %s\n\n', currentDate);
outputText = [outputText, sprintf('Location - %s\n\n', locationName)];

for minute = 0:10
    index = minute * 60 + 1;
    if index <= length(temperatureData)
        outputText = [outputText, sprintf('Minute\t\t%d\n\n', minute)];
        outputText = [outputText, sprintf('Temperature\t%.2f C\n\n\n', temperatureData(index))];
    end
end

outputText = [outputText, sprintf('Max temp\t%.2f C\n', maxTemp)];
outputText = [outputText, sprintf('Min temp\t%.2f C\n', minTemp)];
outputText = [outputText, sprintf('Average temp\t%.2f C\n\n', avgTemp)];
outputText = [outputText, sprintf('Data logging terminated\n')];

% Print to Command Window
fprintf('%s', outputText);

% Write to text file
fileID = fopen('capsule_temperature.txt', 'w');
fprintf(fileID, '%s', outputText);
fclose(fileID);
%% TASK 2 - LED TEMPERATURE MONITORING DEVICE IMPLEMENTATION [25 MARKS]

% Insert answers here
clear a
a = arduino
temp_monitor(a)
%% TASK 3 - ALGORITHMS – TEMPERATURE PREDICTION [30 MARKS]

% Insert answers here
clear a
a = arduino
temp_prediction(a)
%% TASK 4 - REFLECTIVE STATEMENT [5 MARKS]

% No need to enter any answers here, please answer on the .docx template.


%% TASK 5 - COMMENTING, VERSION CONTROL AND PROFESSIONAL PRACTICE [15 MARKS]

% No need to enter any answers here, but remember to:
% - Comment the code throughout.
% - Commit the changes to your git repository as you progress in your programming tasks.
% - Hand the Arduino project kit back to the lecturer with all parts and in working order.