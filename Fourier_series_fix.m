function Result = Fourier_series_fix(a0, a, b, EpsCoeff, Time_int, Freq_fourier, DistortionFourierLength)
c = sqrt(a.*a + b.*b); %Summary fourier coefficients
[cSortTemp cSortIndexTemp] = sort(abs(c), 'descend'); %Sort arrays of sinus fourier coefficients

    %Create a structure for saving sorted coeffictints 0
for i = 1:size(cSortTemp,2)
    cSort{i} = cSortTemp(:,i);
    cSortIndex{i} = cSortIndexTemp(:,i);
    Eps(i,1) = max(cSort{i})*EpsCoeff; %Cutting off threshold
end

    %Fix summary fourier coefficient   
for p = 1:length(cSort)
j = 1; %Intial value of counter    
    for i = 1:DistortionFourierLength
        if cSort{p}(i,1) >= Eps(p,1)
            cFix{p}(j,1) = cSort{p}(i,1); 
            j = j + 1;    
        end
    end
cFixIndex{p} = sort(cSortIndex{p}(1:j-1,1)); %Sort index of permutation    
end

    %Fix input fourier coefficients  
for p = 1:length(cSort)
    for k = 1:length(cFixIndex{p})
        aFix{p}(k,1) = a(cFixIndex{p}(k,1),p);   
        bFix{p}(k,1) = b(cFixIndex{p}(k,1),p);  
    end
end

    %Calculate fix fourier series for time vector
Distortion_fourier_fix = zeros(length(Time_int),length(cSort)); %Create empty array
MaxDistortion_fourier_fix = zeros(length(cSort)-1,1); %Create empty array
for p = 1:length(cSort)    
    for k = 1:length(Time_int) 
        t = Time_int(k); %Current time
        Distortion_fourier_fix(k,p) = a0(p) + aFix{p}'*cos(t*Freq_fourier*cFixIndex{p}) + bFix{p}'*sin(t*Freq_fourier*cFixIndex{p}); %Full fourier series
    end
    MaxDistortion_fourier_fix(p,:) = max(abs(Distortion_fourier_fix(:,p))); %Maximum of distortions
    %MaxDistortion_fourier_fix(p,:) = sum(abs(Distortion_fourier_fix(:,p))); %Average sum
end
    Result = {Distortion_fourier_fix, MaxDistortion_fourier_fix cFixIndex};
end