% Generated by MATLAB(R) 24.2 (R2024b) and LTE Toolbox 24.2 (R2024b).
% Generated on: 04-Oct-2024 03:39:40

% Brad added RFF

%% Generating Uplink RMC waveform
% Uplink RMC configuration
cfg = struct('RC', 'A1-1', ...
    'NULRB', 100, ...
    'DuplexMode', 'FDD', ...
    'NCellID', 0, ...
    'RNTI', 1, ...
    'TotSubframes', 10, ...
    'Windowing', 0)

cfg.PUSCH.RVSeq = [0 2 3 1]
cfg = lteRMCUL(cfg)

% input bit source:
in = [1; 0; 0; 1]

% Generation
[waveform, grid, cfg] = lteRMCULTool(cfg, in)

% Specify the sample rate of the waveform in Hz
Fs = 1000



%% ADD RF Fingerprint here

function add_fingerprint = add_RF_fingerprint(signal, fs, fingerprint_strength)
    % Signal: Original signal sine wave
    % fs: Sample frequency
    % fingerprint_strength: controls strength of fingerprint, how easy it is to spot

    % Create a unique fingerprint patter
    numberOfSamples = length(signal);
    time = (0:numberOfSamples-1) / fs;

    % Add a phase shift to simulate a fingerprint
    phase_shift = 2*pi*rand();
    phase_modulation = fingerprint_strength * cos(2 * pi * 0.5 * time + phase_shift);

    %Frequency shift to simulate subltle RF variations
    freq_modulation = fingerprint_strength * cos(2 * pi * 0.2 * time);

    % Apply fingerprint to signal
    fingerprinted_signal = signal .* cos(phase_modulation + freq_modulation);

    %Normalize
    fingerprinted_signal = fingerprinted_signal / max(abs(fingerprinted_signal));
end

fingerprint_strength = 0.1;

% MULLET


waveform = add_RF_fingerprint(waveform, Fs, fingerprint_strength)

%% Impairments
% IQ imbalance
waveform = iqimbal(waveform, 8, (180/pi)*pi/5)

% Phase noise
phaseNoise = comm.PhaseNoise('FrequencyOffset', [200 400], ...
    'Level', 					[-60 -80], ...
    'SampleRate', 			Fs)
waveform = phaseNoise(waveform)


% DC offset
waveform = waveform + 0.1+0.2i


% AWGN
waveform = awgn(waveform, 20, 'measured')

fprintf('Brad\n\n')

%% Visualize
% Time Scope
%timeScope = timescope('SampleRate', Fs, ...
%    'TimeSpanOverrunAction', 'scroll', ...
%    'TimeSpanSource', 'property', ...
%    'TimeSpan', 9.7656e-07)
%timeScope(waveform)
%release(timeScope)

% Spectrum Analyzer
%spectrum = spectrumAnalyzer('SampleRate', Fs)
% spectrum(waveform)
%release(spectrum)
