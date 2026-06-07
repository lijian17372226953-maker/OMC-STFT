# OMC-STFT
OMC-STFT: An Adaptive Phase Filtering Method for InSAR Based on Optimal Magnitude Combination
# OMC-STFT

**OMC-STFT: An Adaptive Phase Filtering Method for InSAR Based on Optimal Magnitude Combination**

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

## 📖 Introduction (简介)

This repository contains the official datasets for the paper **"OMC-STFT: An Adaptive Phase Filtering Method for InSAR Based on Optimal Magnitude Combination"**. 

To strictly ensure the absolute reproducibility of our experiments and to facilitate further research in the community, we have fully open-sourced all simulated and real-world interferometric phase datasets used in our study. **The core algorithm source code of OMC-STFT will be uploaded to this repository immediately upon the publication of the paper.**

(本仓库包含论文《OMC-STFT: An Adaptive Phase Filtering Method for InSAR Based on Optimal Magnitude Combination》的官方数据集。为了严格确保实验的完全可复现性，并促进社区的后续研究，我们全面开源了研究中使用的所有模拟与真实干涉相位数据集。**OMC-STFT 的核心算法源码将在论文正式发表后立即上传至本仓库。**)

## 📂 Repository Structure (文件说明)

### 1. Simulated Datasets (模拟数据集)
These datasets are generated to quantitatively evaluate the filtering performance across varying topographic complexities and noise gradients (coherence from 0.1 to 0.9):
* `dataCone.mat`: Dense circular fringes representing highly concentrated deformations.
* `dataPeaks.mat`: Multi-scale complex deformations with extreme phase gradients.
* `dataRamp.mat`: Linear background deformations for evaluating extreme low-coherence robustness.

### 2. Real-World Datasets & Scripts (真实世界数据集与辅助脚本)
* `cpx_Aykol.mat`: D-InSAR data from the 2024 Mw 7.0 **Aykol earthquake** in China. Acquired by Sentinel-1 (C-band) with dense fringes and complex mountain topography.
* `cpx_Etna.mat`: The processed wrapped phase dataset of the **Mt. Etna volcano** in Italy.
* `etna_dat1.mat` & `etna_dat2.mat`: Legacy benchmark raw Single Look Complex (SLC) matrices from the Mt. Etna volcano. Acquired by ERS-2 (C-band) in 2000.
* `infere.m`: A helper script provided alongside the Etna datasets for processing the raw SLC `.mat` files to generate the interferogram. *(Note: This is not the OMC-STFT algorithm code).*

### 3. Algorithm Source Code (算法源码)
* ⏳ *Coming soon upon publication...* (核心代码将在论文录用后开源)

## 💻 System Requirements (系统配置要求)

**There are no strict hardware requirements to run the upcoming OMC-STFT algorithm.** It is designed to be highly efficient and adaptable to standard personal computers. 

However, if you wish to precisely reproduce the specific computational execution times (e.g., the 4.31s parallel processing time) reported in Section III.E of our paper, your testing environment should closely match our benchmark setup:
* **Software:** MATLAB R2024a (Parallel Computing Toolbox recommended for multi-core acceleration).
* **Hardware:** Intel Core i7-13650HX (14 physical cores) with 32 GB RAM.

(**运行即将开源的 OMC-STFT 算法没有严格的硬件配置要求**。该算法具有极高的运行效率，可适配常规个人电脑。但如果您希望精确复现论文 Section III.E 中报告的具体运行时间基准（如 4.31 秒的并行处理时间），建议使用与我们测试环境相近的配置：MATLAB R2024a 及 Intel Core i7 14核处理器 / 32GB 内存。)

## 📝 Citation (引用)

If you find these datasets or the upcoming code useful in your research, please consider citing our paper:

```bibtex
@article{OMC_STFT_2026,
  title={OMC-STFT: An Adaptive Phase Filtering Method for InSAR Based on Optimal Magnitude Combination},
  author={Li, Jian and Fan, Hongdong and Tian, Zeming and Sen, Du and Huang, Hai},
  journal={IEEE Transactions on Geoscience and Remote Sensing},
  year={2026},
  note={Under Review / Accepted}
}
