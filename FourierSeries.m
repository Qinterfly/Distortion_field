function Result = FourierSeries(SignalChInt, TimeInt, Period, ColsRangeData, LengthSeries, ShiftInd)
% Evalute fourier series for interpolated signal

FreqFourier = 2 * pi / Period; % Fourier frequency
s = (1:LengthSeries)'; % Array of harmonics numbers
SignalFourier = zeros(length(SignalChInt), ColsRangeData(2) - ColsRangeData(1) + 1); % Create array of zeros
SignalFourierPhaseShift = zeros(length(SignalChInt), ColsRangeData(2) - ColsRangeData(1) + 1); % Create array of zeros
for i = ColsRangeData(1):ColsRangeData(2)
    a0 = 2 / Period * trapz(TimeInt, SignalChInt(:, i)); % First coeffcient
    for j = 1:LengthSeries
        a(j) = 2 / Period * trapz(TimeInt, cos(FreqFourier * j * TimeInt) .* SignalChInt(:, i)); % Coeffs of cosinus
        b(j) = 2 / Period * trapz(TimeInt, sin(FreqFourier * j * TimeInt) .* SignalChInt(:, i)); % Coeffs of sinus
    end
    for k = 1:length(TimeInt)
        t = TimeInt(k); % Current time
        SignalFourier(k,i) = a0 + a * cos(t * FreqFourier * s) + b * sin(t * FreqFourier * s); % Full fourier series
        if ShiftInd == 1 % Calculate phase shifted fourier series
            SignalFourierPhaseShift(k, i) = a0 + a * cos(t * FreqFourier * s - pi/2) + b * sin(t * FreqFourier * s - pi/2); % Full fourier series shifted
        end
    end
    FourierCoeffs(:, i) = [FreqFourier, a0, a, b]'; % Write fourier coeffs
end
Result{1} = FourierCoeffs; Result{2} = SignalFourier; % Output data
if ShiftInd == 1 % Print phase shifted fourier series
    Result{3} = SignalFourierPhaseShift;
end

end