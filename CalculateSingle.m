function [Distortion, MaxDistortionFix, SignalChInt, FirstHarmonic, FirstHarmonicPhaseShift, TimeInt] = CalculateSingle(Period, ThroughpFreq, TimeSim, SignalTimeFix, ColsRangeData, nAccel)
% Main calculation module : distortions and first harmonics of the time signals ( + phase shifts)

% Interpolate time signal
h = Period / ThroughpFreq; % Time step
TimeInt = (0:h:Period)'; % Grid for interpolation
SignalChInt = interp1(TimeSim, SignalTimeFix, TimeInt, 'spline', 'extrap'); % Interpolating the input time signal

% Separation of the first harmonic
[FirstHarmonic, FirstHarmonicPhaseShift] = FourierSeries(SignalChInt, TimeInt, Period, ColsRangeData, 1, 1); % Call FSerires function for selection of the first harmonic for each signal

% Calculating of distortions
for i = ColsRangeData(1):ColsRangeData(2)
    Distortion(:, i) = SignalChInt(:, i) - FirstHarmonic(:, i); % Finding the twist vector
    MaxDistortion(i, :) = max(abs(Distortion(:, i))) / max(abs(FirstHarmonic(:, i))); % Maximum of distortions [normalize by max of the firsts harmonic]
end

% Reduction of distortions from force sensor
MaxDistortionFix = MaxDistortion(1:nAccel, :); % Base
% MaxDistortionFix = MaxDistortionFix ./ max(MaxDistortionFix); % Normalize vector of a distortions by maximum [ Another variant : abs(max(FirstHarmonic(:))) ]

end

