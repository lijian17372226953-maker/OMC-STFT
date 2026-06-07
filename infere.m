S1 = load("etna_dat1.mat");
S2 = load("etna_dat2.mat");
S1 = S1.etna_dat1;
S2 = S2.etna_dat2;
interfe = angle(S1.*conj(S2));
% interfe = angle(S2);
imagesc(interfe);
colormap("jet")
colorbar