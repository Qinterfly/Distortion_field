function Fig = PlotTimeSignal(TimeInt, SignalChInt, FirstHarmonic, Distortion, Channel)
% Plot graph of time signal

Fig = figure; % Create a graphic window
subplot(2, 1, 1) % Splitting the screen into parts
plot(TimeInt, SignalChInt(:, Channel)); % The plotting of the interpolated time signal

% Display of Fourier series for selected channel
hold on; % Plotting graph in one axes
plot(TimeInt, FirstHarmonic(:, Channel)); % Plotting of the graphic of first harmonic for selected channel
title(['Time signal for channel #' num2str(Channel)]); % Title of graphic
grid on; % Mesh display
xlabel('t, s'); ylabel('g, m/s^2'); % Names of axes
legend('Interpolated signal', 'First harmonic of the signal'); % Create legend

% Display twists for selected channel
subplot(2, 1, 2) % Splitting the screen into parts
plot(TimeInt, Distortion(:, Channel)); % Plot distortions for this channel
grid on; % Mesh display
xlabel('t, s'); ylabel('g, m/s^2'); % Names of axes
title(['Distortion for channel #' num2str(Channel)]); % Title of graphic
legend('Distortion'); % Create legend

end

