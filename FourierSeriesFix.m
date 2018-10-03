function Result = FourierSeriesFix(a0, a, b, EpsCoeff, Time_int, FreqFourier, DistortionFourierLength)
% Evalute fourier series for interpolated signal

nSignals = size(a, 2); % Number of signals
c = sqrt(a .* a + b .* b); % Summary fourier coefficients
[cSort, cSortIndex] = sort(abs(c), 'descend'); %Sort arrays of sinus fourier coefficients

% Create a structure for saving sorted coeffictints (reshaping)
for i = 1:nSignals % for all signals
    Eps(i, 1) = max(cSort(:, i)) * EpsCoeff; %Cutting off threshold
end

% Fix summary fourier coefficient by Eps
for j = 1:nSignals % for all signals
    k = 1; % Intial value of counter    
    for i = 1:DistortionFourierLength
        if cSort(i, j) >= Eps(j, 1) % Find elements, and its' indexices, greater that epsilon
            cFix{j}(k, 1) = cSort(i, j); % Value of coefficient
            cFixIndex{j}(k, 1) = cSortIndex(i, j); % Index of permutation    
            k = k + 1; % Increase counter
        end
    end
end

% Fix input fourier coefficients  
for j = 1:nSignals
    for k = 1:length(cFixIndex{j})
        aFix{j}(k, 1) = a(cFixIndex{j}(k, 1), j);   
        bFix{j}(k, 1) = b(cFixIndex{j}(k, 1), j);  
    end
end

% Calculate fix fourier series for time vector
DistortionFourierFix = zeros(length(Time_int), nSignals); % Create empty array
MaxDistortionFourierFix = zeros(nSignals, 1); % Create empty array
for j = 1:nSignals    
    for k = 1:length(Time_int) 
        t = Time_int(k); % Current time
        DistortionFourierFix(k, j) = a0(j) + aFix{j}' * cos(t * FreqFourier * cFixIndex{j}) + bFix{j}' * sin(t * FreqFourier * cFixIndex{j}); % Full fourier series
    end
    MaxDistortionFourierFix(j, :) = max(abs(DistortionFourierFix(:, j))); % Maximum of distortions
    % MaxDistortionFourierFix(j, :) = sum(abs(DistortionFourierFix(:, j))); % Average sum
end

Result = {DistortionFourierFix, MaxDistortionFourierFix, cFixIndex}; % Write results in one variable

end
