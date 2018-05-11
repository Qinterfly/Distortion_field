function Result = Fourier_series(Signal_ch_int, Time_int, Period, Cols_range_data, Length_series, Shift_ind)
Freq_fourier = 2*pi/Period; %Fourier frequency
s = (1:Length_series)'; %Array of harmonics numbers
Signal_fourier = zeros(length(Signal_ch_int),Cols_range_data(2) - Cols_range_data(1) + 1); %Create array of zeros
Signal_fourier_PhaseShift = zeros(length(Signal_ch_int),Cols_range_data(2) - Cols_range_data(1) + 1); %Create array of zeros
for i = Cols_range_data(1):Cols_range_data(2) 
    a0 = 2/Period * trapz(Time_int,Signal_ch_int(:,i)); %First coeffcient
    for j = 1:Length_series
        a(j) = 2/Period * trapz(Time_int,cos(Freq_fourier*j*Time_int).*Signal_ch_int(:,i)); %Coeffs of cosinus
        b(j) = 2/Period * trapz(Time_int,sin(Freq_fourier*j*Time_int).*Signal_ch_int(:,i)); %Coeffs of sinus
    end
    for k = 1:length(Time_int) 
            t = Time_int(k); %Current time
            Signal_fourier(k,i) = a0 + a*cos(t*Freq_fourier*s) + b*sin(t*Freq_fourier*s); %Full fourier series
            if Shift_ind == 1 %Calculate phase shifted fourier series
                Signal_fourier_PhaseShift(k,i) = a0 + a*cos(t*Freq_fourier*s - pi/2) + b*sin(t*Freq_fourier*s - pi/2); %Full fourier series shifted
            end
    end
Fourier_coeffs(:,i) = [Freq_fourier a0 a b]'; %Write fourier coeffs  
end
Result{1} = Fourier_coeffs; Result{2} = Signal_fourier; %Output data
if Shift_ind == 1 %Print phase shifted fourier series
    Result{3} = Signal_fourier_PhaseShift; 
end
end