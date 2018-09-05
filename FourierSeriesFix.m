function Result = FourierSeriesFix(a0, a, b, EpsCoeff, Time_int, FreqFourier, DistortionFourierLength)
% Evalute fourier series for interpolated signal

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
DistortionFourierFix = zeros(length(Time_int),length(cSort)); %Create empty array
MaxDistortionFourierFix = zeros(length(cSort)-1,1); %Create empty array
for p = 1:length(cSort)    
    for k = 1:length(Time_int) 
        t = Time_int(k); %Current time
        DistortionFourierFix(k,p) = a0(p) + aFix{p}'*cos(t*FreqFourier*cFixIndex{p}) + bFix{p}'*sin(t*FreqFourier*cFixIndex{p}); %Full fourier series
    end
    MaxDistortionFourierFix(p,:) = max(abs(DistortionFourierFix(:,p))); %Maximum of distortions
    %MaxDistortionFourierFix(p,:) = sum(abs(DistortionFourierFix(:,p))); %Average sum
end
    Result = {DistortionFourierFix, MaxDistortionFourierFix cFixIndex};
end