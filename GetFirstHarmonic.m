function DistortionFourierFix = GetFirstHarmonic(a0, a, b, Time_int, FreqFourier)
% Evalute fourier series for interpolated signal

nSignals = size(a, 2); % Number of signals
% Calculate fix fourier series for time vector
DistortionFourierFix = zeros(length(Time_int), nSignals); % Create empty array
MaxDistortionFourierFix = zeros(nSignals, 1); % Create empty array
for j = 1:nSignals    
    for k = 1:length(Time_int) 
        t = Time_int(k); % Current time
        DistortionFourierFix(k, j) = a0(j) + a(1, j) * cos(t * FreqFourier) + b(1, j) * sin(t * FreqFourier); % Full fourier series    end
        MaxDistortionFourierFix(j, :) = max(abs(DistortionFourierFix(:, j))); % Maximum of distortions
        % MaxDistortionFourierFix(j, :) = sum(abs(DistortionFourierFix(:, j))); % Average sum
    end
end

end
