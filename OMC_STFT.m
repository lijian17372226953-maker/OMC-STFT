function psi_filtered = OMC_STFT(psi_noisy, win_size, stft_step, sigma_candidates)
% OMC_STFT: An Adaptive Phase Filtering Method for InSAR Based on Optimal Magnitude Combination
%
% This function implements the OMC-STFT algorithm, which adaptively filters 
% InSAR phase noise by constructing a multi-bandwidth candidate pool and 
% selecting the optimal phase pixel-by-pixel via constructive interference energy.
%
% Reference:
% J. Li, H. Fan, Z. Tian, D. Sen and H. Huang, "OMC-STFT: An Adaptive Phase 
% Filtering Method for InSAR Based on Optimal Magnitude Combination," in 
% IEEE Transactions on Geoscience and Remote Sensing, doi: 10.1109/TGRS.2026.3706355.
%
% Inputs:
%   psi_noisy        - 2D matrix of the noisy wrapped phase (radians).
%   win_size         - (Optional) Sliding window size. Default is 80.
%   stft_step        - (Optional) Spatial stride for the sliding window. Default is 4.
%   sigma_candidates - (Optional) Array of bandwidth candidates. Default is 0.1:0.5:3.0.
%
% Outputs:
%   psi_filtered     - 2D matrix of the adaptively filtered wrapped phase.

    % Set default parameters based on the paper's experimental setup
    if nargin < 2 || isempty(win_size), win_size = 80; end
    if nargin < 3 || isempty(stft_step), stft_step = 4; end
    if nargin < 4 || isempty(sigma_candidates), sigma_candidates = 0.1:0.5:3.0; end

    % Map to complex unit circle
    complex_sig = exp(1i * psi_noisy);
    [rows, cols] = size(complex_sig);
    num_candidates = length(sigma_candidates);

    % Symmetric padding to avoid edge artifacts
    pad_size = floor(win_size / 2);
    padded_sig = padarray(complex_sig, [pad_size, pad_size], 'symmetric', 'both');
    [p_rows, p_cols] = size(padded_sig);

    % Define 2D separable Hanning window
    win_func = hann(win_size) * hann(win_size)';
    
    % Precompute accumulation weights for Overlap-Add (OLA) reconstruction
    acc_weight = zeros(p_rows, p_cols);
    r_limit = p_rows - win_size + 1;
    c_limit = p_cols - win_size + 1;
    for r = 1 : stft_step : r_limit
        for c = 1 : stft_step : c_limit
            acc_weight(r : r+win_size-1, c : c+win_size-1) = ...
                acc_weight(r : r+win_size-1, c : c+win_size-1) + win_func;
        end
    end
    acc_weight(acc_weight == 0) = 1; % Prevent division by zero
    
    U_cell = cell(1, num_candidates);
    Mag_cell = cell(1, num_candidates);

    % Precompute base distance grid for Gaussian masking
    [fX, fY] = meshgrid(-win_size/2 : win_size/2 - 1);
    base_dist_sq = ifftshift(fX).^2 + ifftshift(fY).^2;

    fprintf('Starting parallel OMC-STFT filtering...\n');
    
    % Task-level multi-core parallelization for bandwidth candidates
    parfor k = 1:num_candidates
        current_sigma = sigma_candidates(k);
        acc_U = compute_stft_filtering_kernel(padded_sig, win_size, stft_step, current_sigma, win_func, base_dist_sq);

        % Normalize via OLA weights and remove padding
        U_cur_padded = acc_U ./ acc_weight; 
        U_cur = U_cur_padded(pad_size+1 : pad_size+rows, pad_size+1 : pad_size+cols);
        Mag_cur = abs(U_cur);
        
        U_cell{k} = U_cur;
        Mag_cell{k} = Mag_cur;
    end

    % Pixel-wise selection based on optimal magnitude combination
    global_best_mag = zeros(rows, cols);
    global_best_U = complex(zeros(rows, cols));
    
    for k = 1:num_candidates
        U_cur = U_cell{k};
        Mag_cur = Mag_cell{k};
        mask = Mag_cur > global_best_mag;
        
        global_best_mag(mask) = Mag_cur(mask);
        global_best_U(mask) = U_cur(mask);
    end

    % Extract optimally filtered phase
    psi_filtered = angle(global_best_U);
    fprintf('Filtering complete.\n');
end

function acc_U = compute_stft_filtering_kernel(U_in, win_size, step, freq_sigma, win_func, base_dist_sq)
% Local STFT filtering and OLA accumulation for a single bandwidth candidate
    [p_rows, p_cols] = size(U_in);
    acc_U = complex(zeros(p_rows, p_cols));

    r_limit = p_rows - win_size + 1;
    c_limit = p_cols - win_size + 1;

    % Parameterized 2D Gaussian transfer function
    base_mask = exp(-base_dist_sq / (2 * freq_sigma^2));

    for r = 1 : step : r_limit
        for c = 1 : step : c_limit
            block = U_in(r : r+win_size-1, c : c+win_size-1);
            block_win = block .* win_func;

            Spec = fft2(block_win); 
            AbsSpec = abs(Spec);

            % Locate dominant 2D spatial frequency
            [~, max_idx] = max(AbsSpec(:));
            p_y = mod(max_idx - 1, win_size) + 1;
            p_x = floor((max_idx - 1) / win_size) + 1;

            % Shift mask to dominant frequency and apply filter
            mask = circshift(base_mask, [p_y-1, p_x-1]);
            Spec_filt = Spec .* mask;
            
            % Reconstruct and accumulate
            block_out = ifft2(Spec_filt); 
            acc_U(r : r+win_size-1, c : c+win_size-1) = ...
                acc_U(r : r+win_size-1, c : c+win_size-1) + block_out;
        end
    end
end