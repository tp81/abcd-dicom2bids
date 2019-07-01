function eta = eta_squared(input_image, ref_image) 

%% Read in NIFTIs, reshape to 1D vector, concatenate vectors into zmap mat.
%addpath('/mnt/max/shared/code/external/utilities/nifti_toolbox_20140122');

input=load_untouch_nii(input_image);
ref=load_untouch_nii(ref_image);
input_vec=input.img(:);
ref_vec=ref.img(:);
zmap=[ref_vec, input_vec];
[n,m]=size(zmap);

%% Compare several correlation matrices to get eta - fixed by Alex 10/6/08

eta_matrix=zeros(m);

for i=1:m-1
    for j=i+1:m
        % mean correlation value over all locations in both images
        Mgrand = (mean(zmap(:,i)) + mean(zmap(:,j)))/2;
        % mean value matrix for each location in the 2 images
        Mwithin = (zmap(:,i)+zmap(:,j))/2;
        SSwithin = sum((zmap(:,i)-Mwithin).^2) + sum((zmap(:,j)-Mwithin).^2);
        SStot = sum((zmap(:,i)-Mgrand).^2) + sum((zmap(:,j)-Mgrand).^2);
        % N.B. SStot = SSwithin + SSbetween so eta can also be written as SSbetween/SStot
        eta_matrix(i,j) = 1- SSwithin/SStot;
        eta_matrix(j,i) = eta_matrix (i,j);
    end
    eta_matrix(i,i)=1;
end
eta_matrix(m,m)=1;
eta = eta_matrix(1,2);
format long
eta

