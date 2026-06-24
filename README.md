## 📂 Repository Structure (文件说明)

### 1. Algorithm Source Code (算法源码)
* `OMC_STFT.m`: The core adaptive phase filtering algorithm. It utilizes a `parfor` parallelized architecture to rapidly process spatial-variant bandwidths and extract the optimal phase via constructive interference energy.

### 2. Simulated Datasets (模拟数据集)
These datasets are generated to quantitatively evaluate the filtering performance across varying topographic complexities and noise gradients (coherence from 0.1 to 0.9):
* `dataCone.mat`: Dense circular fringes representing highly concentrated deformations.
* `dataPeaks.mat`: Multi-scale complex deformations with extreme phase gradients.
* `dataRamp.mat`: Linear background deformations for evaluating extreme low-coherence robustness.

### 3. Real-World Datasets & Scripts (真实世界数据集与辅助脚本)
* `cpx_Aykol.mat`: D-InSAR data from the 2024 Mw 7.0 **Aykol earthquake** in China. Acquired by Sentinel-1 (C-band) with dense fringes and complex mountain topography.
* `cpx_Etna.mat`: The processed wrapped phase dataset of the **Mt. Etna volcano** in Italy.
* `etna_dat1.mat` & `etna_dat2.mat`: Legacy benchmark raw Single Look Complex (SLC) matrices from the Mt. Etna volcano. Acquired by ERS-2 (C-band) in 2000.
* `infere.m`: A helper script provided alongside the Etna datasets for processing the raw SLC `.mat` files to generate the interferogram.

---

## 🚀 Usage (使用说明)

You can run the filter using the default parameters optimized for standard InSAR scenarios (Window Size = 80, Step = 4, Bandwidth Candidates = 0.1 to 3.0):

```matlab
% Load your noisy phase data (radians)
load('dataCone.mat'); % Load example dataset
cpx = exp(1i.* dataRamp.psi_noisy);

% Apply OMC-STFT Filtering
psi_filtered = OMC_STFT(cpx);

% Display the result
figure;
subplot(1,2,1); imagesc(dataRamp.psi_noisy); title('Noisy Phase'); colormap jet;
subplot(1,2,2); imagesc(psi_filtered); title('OMC-STFT Filtered Phase'); colormap jet;
```

If you are dealing with extremely dense fringes mixed with severe noise, you can manually adjust the sliding window size (e.g., to 56) to better preserve high-frequency details, as discussed in the paper:

```matlab
psi_filtered = OMC_STFT(psi_noisy, 56, 4, 0.1:0.5:3.0);
```

---

## 💻 System Requirements (系统配置要求)

**There are no strict hardware requirements to run the OMC-STFT algorithm.** It is designed to be highly efficient and adaptable to standard personal computers. 

However, if you wish to precisely reproduce the specific computational execution times (e.g., the 4.31s parallel processing time) reported in Section III.E of our paper, your testing environment should closely match our benchmark setup:
* **Software:** MATLAB R2024a (Parallel Computing Toolbox required for `parfor` multi-core acceleration).
* **Hardware:** Intel Core i7-13650HX (14 physical cores) with 32 GB RAM.

*(**运行 OMC-STFT 算法没有严格的硬件配置要求**。该算法具有极高的运行效率，可适配常规个人电脑。但如果您希望精确复现论文 Section III.E 中报告的具体运行时间基准（如 4.31 秒的并行处理时间），建议使用与我们测试环境相近的配置：MATLAB R2024a 及包含 Parallel Computing Toolbox，配合 Intel Core i7 14核处理器 / 32GB 内存。)*
