function temp_prediction(a)
%TEMP_PREDICTION Temperature prediction and rate-of-change monitoring
% Monitors temperature continuously, estimates the rate of temperature
% change, predicts the temperature expected in 5 minutes, and applies LED
% logic for stable, fast-rising, or fast-falling conditions.
a = arduino()
% Sensor constants for MCP9700A
V0 = 0.5;
TC = 0.01;

% Comfort range
lowerLimit = 18;
upperLimit = 24;

% Rate thresholds in degC/min
highRateLimit = 4;
lowRateLimit = -4;

% LED pins
greenPin = 'D10';
yellowPin = 'D11';
redPin = 'D12';

% Storage arrays
timeData = [];
temperatureData = [];

startTime = tic;

while true
    % Current time
    currentTime = toc(startTime);

    % Read voltage from Arduino
    V = readVoltage(a,'A0');

    % Convert to temperature
    temperature = (V - V0) / TC;

    % Store data
    timeData(end+1) = currentTime;
    temperatureData(end+1) = temperature;

    % Estimate rate of change using the last few points
    if length(temperatureData) >= 5
        recentTemps = temperatureData(end-4:end);
        recentTimes = timeData(end-4:end);
        p = polyfit(recentTimes, recentTemps, 1);
        rateDegPerSec = p(1);
    else
        rateDegPerSec = 0;
    end

    % Convert rate to degC/min
    rateDegPerMin = rateDegPerSec * 60;

    % Predict temperature in 5 minutes (300 s)
    predictedTemp = temperature + rateDegPerSec * 300;

    % Limit prediction to realistic range
    if predictedTemp > 100
        predictedTemp = 100;
    elseif predictedTemp < -50
        predictedTemp = -50;
    end

    % Print values to screen
    fprintf('Current Temp: %.2f C | Rate: %.2f C/s (%.2f C/min) | Predicted Temp in 5 min: %.2f C\n', ...
        temperature, rateDegPerSec, rateDegPerMin, predictedTemp);

    % LED logic
    if temperature >= lowerLimit && temperature <= upperLimit && abs(rateDegPerMin) <= 4
        disp('GREEN LED ON - Stable and in comfort range');
        writeDigitalPin(a, greenPin, 1);
        writeDigitalPin(a, yellowPin, 0);
        writeDigitalPin(a, redPin, 0);

    elseif rateDegPerMin > highRateLimit
        disp('RED LED ON - Temperature rising too quickly');
        writeDigitalPin(a, greenPin, 0);
        writeDigitalPin(a, yellowPin, 0);
        writeDigitalPin(a, redPin, 1);

    elseif rateDegPerMin < lowRateLimit
        disp('YELLOW LED ON - Temperature falling too quickly');
        writeDigitalPin(a, greenPin, 0);
        writeDigitalPin(a, yellowPin, 1);
        writeDigitalPin(a, redPin, 0);

    else
        disp('No LED alert condition triggered');
        writeDigitalPin(a, greenPin, 0);
        writeDigitalPin(a, yellowPin, 0);
        writeDigitalPin(a, redPin, 0);
    end

    pause(1);
end

end