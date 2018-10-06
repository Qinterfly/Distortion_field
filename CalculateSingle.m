function [Distortion, MaxDistortionFix, SignalChInt, FirstHarmonic, SignalFourierPhaseShift, TimeInt] = CalculateSingle(Period,...   
     FreqProcess, TimeSim, SignalTimeFix, ColsRangeData, nAccel)

% Calculate distortion
% Interpolate time signal
h = Period / 10 ^ 3; % Time step
TimeInt = (0:h:Period)'; % Grid for interpolation
SignalChInt = interp1(TimeSim, SignalTimeFix, TimeInt, 'spline', 'extrap'); % Interpolating the input time signal

% Separation of harmonics
DistortionFourierLength = floor(5000 / FreqProcess); % Harmonics number
FreqFourier = 2 * pi / Period; % Fourier frequency
FSeries = FourierSeries(SignalChInt, TimeInt, Period, ColsRangeData, DistortionFourierLength, 1);
SignalFourierCoeffs = FSeries{1}; SignalFourier = FSeries{2}; SignalFourierPhaseShift = FSeries{3};
a0 = SignalFourierCoeffs(2, :); % First fourier coefficient
a = SignalFourierCoeffs(3:DistortionFourierLength + 2, :); % Fourier cosinus coefficients
b = SignalFourierCoeffs(DistortionFourierLength + 3:size(SignalFourierCoeffs, 1), :); % Fourier sinus coefficients

FirstHarmonic = GetFirstHarmonic(a0, a, b, TimeInt, FreqFourier); % Call FSerires function
% Calculating of distortions
for i = ColsRangeData(1):ColsRangeData(2)
    Distortion(:, i) = SignalChInt(:, i) - FirstHarmonic(:, i); % Finding the twist vector
    MaxDistortion(i, :) = max(abs(Distortion(:, i))) / max(abs(FirstHarmonic(:))); % Maximum of distortions
end
% Reduction of distortions from force sensor
MaxDistortionFix = MaxDistortion(1:nAccel, :); % Base

end

