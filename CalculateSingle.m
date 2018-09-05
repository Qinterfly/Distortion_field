function [MaxDistortionFix, SignalChInt, SignalFourierPhaseShift,...
    MaxDistortionFourierFix, EpsCoeffForce, SignalFourierFix,...
    DistortionFourierFix, DistortionFourier, TimeInt] = CalculateSingle(Period,...
    FreqProcess, TimeSim, SignalTimeFix,...
    ColsRangeData, AccelQuant)

%Interpolate time signal
h = Period / 10^3; %Time step
TimeInt = (0:h:Period)'; %Grid for interpolation
SignalChInt = interp1(TimeSim, SignalTimeFix, TimeInt, 'spline', 'extrap'); %Interpolating the input time signal

%Separation of harmonics
DistortionFourierLength = floor(5000 / FreqProcess); %Harmonics number
EpsCoeffForce.Base = 0.8; %Accuracy coefficient
FreqFourier = 2 * pi / Period; %Fourier frequency
FSeries = FourierSeries(SignalChInt, TimeInt, Period, ColsRangeData, DistortionFourierLength, 1);
SignalFourierCoeffs = FSeries{1}; SignalFourier = FSeries{2}; SignalFourierPhaseShift = FSeries{3};
a0 = SignalFourierCoeffs(2, :); %First fourier coefficient
a = SignalFourierCoeffs(3:DistortionFourierLength + 2, :); %Fourier cosinus coefficients
b = SignalFourierCoeffs(DistortionFourierLength + 3:size(SignalFourierCoeffs, 1), :); %Fourier sinus coefficients

FSeriesFix = FourierSeriesFix(a0, a, b, EpsCoeffForce.Base, TimeInt, FreqFourier, DistortionFourierLength); %Call FSerires function
%SignalFourier_fix = FSeriesFix{1};
MaxSignalFourier_fix = FSeriesFix{2}; %Format output data
cFixIndex = FSeriesFix{3};
for p = 1:size(a,2)
    s = 1; %Intial number of increment
    for i = 1:length(cFixIndex{end})
        aFix(s,p) = a(cFixIndex{end}(i),p); %Fix fourier coeffs on force accel.
        bFix(s,p) = b(cFixIndex{end}(i),p);
        s = s + 1; %Increment
    end
    for k = 1:length(TimeInt)
        t = TimeInt(k); %Current time
        SignalFourierFix(k,p) = a0(1,p) + aFix(:,p)'*cos(t*FreqFourier.*cFixIndex{end}) + bFix(:,p)'*sin(t*FreqFourier.*cFixIndex{end}); %Full fourier series
    end
end

%Calculating of twists
for i = ColsRangeData(1):ColsRangeData(2)
    Distortion(:,i) = SignalChInt(:,i) - SignalFourierFix(:,i); %Finding the twist vector !TODO! - Last force accel.
    MaxDistortion(i,:) = max(abs(Distortion(:,i))) / max(abs(SignalFourierFix(:))); %Maximum of distortions
end

%Fourier series for distortion
FSeries = FourierSeries(Distortion, TimeInt, Period, ColsRangeData, DistortionFourierLength, 0); %Call FourierSeries function
DistortionFourierCoeffs = FSeries{1}; DistortionFourier = FSeries{2}; %Result
a0 = DistortionFourierCoeffs(2, :); %First fourier coefficient
a = DistortionFourierCoeffs(3:DistortionFourierLength+2, :); %Fourier cosinus coefficients
b = DistortionFourierCoeffs(DistortionFourierLength + 3:size(DistortionFourierCoeffs, 1), :); %Fourier sinus coefficients

EpsCoeffForce.Fourier = 1e-1; %Accuracy coefficient
FSeriesFix = FourierSeriesFix(a0, a, b, EpsCoeffForce.Fourier, TimeInt, FreqFourier, DistortionFourierLength); %Call FSerires function
DistortionFourierFix = FSeriesFix{1}; %MaxDistortionFourierFix = FSeriesFix{2}; %Format output data
for p = 1:size(DistortionFourierFix, 2)
    MaxDistortionFourierFix(p, :) = sum(abs(DistortionFourierFix(:, p))); %Average sum
end
%Reduction of distortions from force sensor
MaxDistortionFix = MaxDistortion(1:AccelQuant, :); %Base
MaxDistortionFourierFix = MaxDistortionFourierFix(1:AccelQuant, :); %Fourier

end

