function temp_monitor(a)
%TEMP_MONITOR Live temperature monitoring with LED control

% Sensor constants (MCP9700A)
V0 = 0.5;
TC = 0.01;

% Temperature thresholds
lowerLimit = 18;
upperLimit = 24;

% LED pins (change if needed)
greenPin = 'D10';
yellowPin = 'D11';
redPin = 'D12';

% Data storage
timeData = [];
temperatureData = [];

% Create live plot
figure;
xlabel('Time (s)');
ylabel('Temperature (°C)');
title('Live Capsule Temperature Monitoring');
grid on;
hold on;

startTime = tic;

% States for blinking
yellowState = 0;
redState = 0;

while true
    % Time
    currentTime = toc(startTime);

    % Smart input (works with or without Arduino)
    if nargin < 1
        voltage = 0.72 + 0.08*randn;   % Fake data
    else
        voltage = readVoltage(a,'A0'); % Real sensor
    end

    % Convert to temperature
    temperature = (voltage - V0) / TC;

    % Store data
    timeData(end+1) = currentTime;
    temperatureData(end+1) = temperature;

    % Update graph
    cla;
    plot(timeData, temperatureData, '-o');
    xlabel('Time (s)');
    ylabel('Temperature (°C)');
    title('Live Capsule Temperature Monitoring');
    grid on;
    drawnow;

    % -------- LED LOGIC --------
    if temperature >= lowerLimit && temperature <= upperLimit
        disp('GREEN LED ON - Comfort range');

        if nargin >= 1
            writeDigitalPin(a, greenPin, 1);
            writeDigitalPin(a, yellowPin, 0);
            writeDigitalPin(a, redPin, 0);
        end

        pause(1);

    elseif temperature < lowerLimit
        yellowState = ~yellowState;

        if yellowState
            disp('YELLOW LED ON - Too cold');
        else
            disp('YELLOW LED OFF');
        end

        if nargin >= 1
            writeDigitalPin(a, greenPin, 0);
            writeDigitalPin(a, redPin, 0);
            writeDigitalPin(a, yellowPin, yellowState);
        end

        pause(0.5);

    else
        redState = ~redState;

        if redState
            disp('RED LED ON - Too hot');
        else
            disp('RED LED OFF');
        end

        if nargin >= 1
            writeDigitalPin(a, greenPin, 0);
            writeDigitalPin(a, yellowPin, 0);
            writeDigitalPin(a, redPin, redState);
        end

        pause(0.25);
    end
end

end