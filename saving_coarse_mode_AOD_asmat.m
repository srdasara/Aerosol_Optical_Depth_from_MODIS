

%%%%%% VARIABLES WERE SAVED USING wget command at this link:
% https://ladsweb.modaps.eosdis.nasa.gov/archive/allData/61/MYD08_D3/
% Information on page 38 of this document:
% https://atmosphere-imager.gsfc.nasa.gov/sites/default/files/ModAtmo/L3_ATBD_C6_C61_2019_02_20.pdf

%%

% Here is how I read AOD data and saved out the variables needed! 

% script home path
cd /Users/srishtidasarathy/Documents/'Documents - Srishti’s MacBook Pro '/Bowman/SouthernOcean_Causal_Analysis/Code

% AOD Coarse Mode data path
% cd /Volumes/'G-DRIVE mobile USB'/NEW_AOD/MYD08_D3/2018
cd /Volumes/'G-DRIVE mobile USB'/trying_again/MYD08_D3/2018

%%

clear;
% Bellingshausen Spatial Subset
 LatLims  = [-90  -50];
 LonLims  = [-100 -54];
 
 Latitude = [];
 Longitude = [];
 scale_factor_AOD_TOTAL = [];
 add_offset_AOD_TOTAL = [];
 
 %
 Master_count_2018     = [];
 Master_filename_2018  = [];
 Master_time_2018 = [];

 Master_AOD_total_2018     = [];
 Master_AOD_total_std_2018 = [];
 Master_AOD_total_min_2018 = [];
 Master_AOD_total_max_2018 = [];
 Master_AOD_fine_2018      = [];
 Master_AOD_coarse_2018    = [];
 Master_AOD_total_pixelcounts_2018 = [];
 Master_Ff_small_mean_2018         = [];
 Master_Ff_small_std_2018          = [];
 Master_Ff_small_min_2018          = [];
 Master_Ff_small_max_2018     = [];
 Master_Ff_small_QA_mean_2018 = [];
 
    
%%
  
S = dir(fullfile('*'));
N = setdiff({S([S.isdir]).name},{'.','..'}); % list of subfolders of D.

for ii = 1:numel(N)
    T  = dir(fullfile(N{ii},'*hdf*')); % improve by specifying the file extension.
    C  = {T(~[T.isdir]).name}; % files in subfolder.
    
    for jj = 1:numel(C)
        
        F  = fullfile(N{ii},C{jj});
        disp(F) 
        
        
        product_name        = 'YDim';
        Latitude            = hdfread( F , product_name );
        
        inRange_Lat = Latitude >= LatLims(1) & Latitude < LatLims(end);
        
        product_name        = 'XDim';
        Longitude           = hdfread( F , product_name );
        
        inRange_Lon = Longitude >= LonLims(1) & Longitude < LonLims(end) ;
        
       

        HDFFILEINFO = hdfinfo(F);
        INFO_AOD_TOTAL = HDFFILEINFO.Vgroup(1).Vgroup(1).SDS(32).Attributes;
        scaleandoffset_AOD_TOTAL = extractfield(INFO_AOD_TOTAL,'Value');
        scale_factor_AOD_TOTAL = cell2mat(scaleandoffset_AOD_TOTAL(5));
        add_offset_AOD_TOTAL = cell2mat(scaleandoffset_AOD_TOTAL(6));
        
        INFO_Ff =  HDFFILEINFO.Vgroup(1).Vgroup(1).SDS(91).Attributes;
        scaleandoffset_Ff = extractfield(INFO_Ff, 'Value');
        scale_factor_Ff = cell2mat(scaleandoffset_Ff(5));
        add_offset_Ff = cell2mat(scaleandoffset_Ff(6));
        
        
        product_name = 'Aerosol_Optical_Depth_Land_Ocean_Mean';
        Aerosol_Optical_Depth_Land_Ocean_Mean = hdfread(F, product_name) ; % This is AOD Total
        AOD_total_mean = double(Aerosol_Optical_Depth_Land_Ocean_Mean);
        AOD_total_mean(AOD_total_mean == -9999) = NaN;
        AOD_total_mean = scale_factor_AOD_TOTAL .* (AOD_total_mean - add_offset_AOD_TOTAL);
        clear Aerosol_Optical_Depth_Land_Ocean_Mean
        
        product_name  = 'Aerosol_Optical_Depth_Small_Ocean_Mean';
        Aerosol_Optical_Depth_Small_Ocean_Mean = hdfread(F, product_name); % This is Ff as in Dror et al. 2018
        Ff_small_mean = double(squeeze(Aerosol_Optical_Depth_Small_Ocean_Mean(2,:,:))); % this should correspond to 0.55 microns
        Ff_small_mean(Ff_small_mean == -9999) = NaN;
        Ff_small_mean = scale_factor_Ff .* (Ff_small_mean - add_offset_Ff); 
        clear Aerosol_Optical_Depth_Small_Ocean_Mean
       
        % And now I can calculate coarse mode and fine mode AOD as in the ATBD. 
        % I did a check to make sure these values add up to AOD Total. 
        AOD_coarse = (1 - Ff_small_mean) .* AOD_total_mean;
        AOD_fine = AOD_total_mean .* Ff_small_mean;
        
        
        
        % Back to Total AOD Error Statistics:
        product_name = 'Aerosol_Optical_Depth_Land_Ocean_Standard_Deviation';
        Aerosol_Optical_Depth_Land_Ocean_Standard_Deviation = hdfread(F, product_name);
        AOD_total_std = double(Aerosol_Optical_Depth_Land_Ocean_Standard_Deviation);
        AOD_total_std(AOD_total_std==-9999) = NaN;
        AOD_total_std = scale_factor_AOD_TOTAL.* (AOD_total_std - add_offset_AOD_TOTAL);
        clear Aerosol_Optical_Depth_Land_Ocean_Standard_Deviation
        
        product_name = 'Aerosol_Optical_Depth_Land_Ocean_Minimum';
        Aerosol_Optical_Depth_Land_Ocean_Minimum = hdfread(F, product_name);
        AOD_total_min = double(Aerosol_Optical_Depth_Land_Ocean_Minimum);
        AOD_total_min(AOD_total_min == -9999) = NaN;
        AOD_total_min = scale_factor_AOD_TOTAL .* (AOD_total_min - add_offset_AOD_TOTAL);
        clear Aerosol_Optical_Depth_Land_Ocean_Minimum
        
        product_name = 'Aerosol_Optical_Depth_Land_Ocean_Maximum';
        Aerosol_Optical_Depth_Land_Ocean_Maximum = hdfread(F, product_name);
        AOD_total_max = double(Aerosol_Optical_Depth_Land_Ocean_Maximum); 
        AOD_total_max(AOD_total_max == -9999) = NaN;
        AOD_total_max = scale_factor_AOD_TOTAL .* (AOD_total_max - add_offset_AOD_TOTAL);
        clear Aerosol_Optical_Depth_Land_Ocean_Maximum
        
        product_name = 'Aerosol_Optical_Depth_Land_Ocean_Pixel_Counts'; % This is now information on the number of samples.
        Aerosol_Optical_Depth_Land_Ocean_Pixel_Counts = hdfread(F, product_name) ;
        AOD_total_pixelcounts = double(Aerosol_Optical_Depth_Land_Ocean_Pixel_Counts);
        AOD_total_pixelcounts(AOD_total_pixelcounts == -9999) = NaN; % you don't have to use scale_factor or add_offset for this one
        clear Aerosol_Optical_Depth_Land_Ocean_Pixel_Counts
        
        
        
        product_name = 'Aerosol_Optical_Depth_Small_Ocean_Standard_Deviation';
        Aerosol_Optical_Depth_Small_Ocean_Standard_Deviation = hdfread(F, product_name); 
        Ff_small_std = double(squeeze(Aerosol_Optical_Depth_Small_Ocean_Standard_Deviation(2,:,:)));
        Ff_small_std(Ff_small_std == -9999) = NaN;
        Ff_small_std = scale_factor_Ff .* (Ff_small_std - add_offset_Ff);
        clear Aerosol_Optical_Depth_Small_Ocean_Standard_Deviation
        
        
        product_name = 'Aerosol_Optical_Depth_Small_Ocean_Minimum';
        Aerosol_Optical_Depth_Small_Ocean_Minimum = hdfread(F, product_name);
        Ff_small_min = double(squeeze(Aerosol_Optical_Depth_Small_Ocean_Minimum(2,:,:)));
        Ff_small_min(Ff_small_min == -9999) = NaN;
        Ff_small_min = scale_factor_Ff .* (Ff_small_min - add_offset_Ff);
        clear Aerosol_Optical_Depth_Small_Ocean_Minimum
        
        
        product_name = 'Aerosol_Optical_Depth_Small_Ocean_Maximum';
        Aerosol_Optical_Depth_Small_Ocean_Maximum = hdfread(F, product_name);
        Ff_small_max = double(squeeze(Aerosol_Optical_Depth_Small_Ocean_Maximum(2,:,:)));
        Ff_small_max(Ff_small_max == -9999) = NaN;
        Ff_small_max = scale_factor_Ff .* (Ff_small_max - add_offset_Ff);
        clear Aerosol_Optical_Depth_Small_Ocean_Maximum
        
        product_name = 'Aerosol_Optical_Depth_Small_Ocean_QA_Mean';
        Aerosol_Optical_Depth_Small_Ocean_QA_Mean = hdfread(F, product_name);
        Ff_small_QA_mean = double(squeeze(Aerosol_Optical_Depth_Small_Ocean_QA_Mean(2,:,:)));
        Ff_small_QA_mean(Ff_small_QA_mean == -9999) = NaN;
        Ff_small_QA_mean = scale_factor_Ff .* (Ff_small_QA_mean - add_offset_Ff);
        clear Aerosol_Optical_Depth_Small_Ocean_QA_Mean
        
        clear scale_factor add_offset scale_factor_AOD_TOTAL scale_factor_Ff add_offset_AOD_TOTAL add_offset_Ff 
        
        
        time              = F(15:21);  
        % filename has year followed by number of days from first day of year
        % to year then end of number of days from first day of year
       
        AOD_Latitude_subset  = Latitude(inRange_Lat) ;
        AOD_Longitude_subset = Longitude(inRange_Lon) ;

        AOD_total_mean        = AOD_total_mean(inRange_Lat, inRange_Lon);
        AOD_total_std         = AOD_total_std(inRange_Lat, inRange_Lon);
        AOD_total_min         = AOD_total_min(inRange_Lat, inRange_Lon);
        AOD_total_max         = AOD_total_max(inRange_Lat, inRange_Lon);
        AOD_fine              = AOD_fine(inRange_Lat, inRange_Lon);
        AOD_coarse            = AOD_coarse(inRange_Lat, inRange_Lon);
        AOD_total_pixelcounts = AOD_total_pixelcounts(inRange_Lat, inRange_Lon);
        Ff_small_mean         = Ff_small_mean(inRange_Lat, inRange_Lon);
        Ff_small_std          = Ff_small_std(inRange_Lat, inRange_Lon);
        Ff_small_min          = Ff_small_min(inRange_Lat, inRange_Lon);
        Ff_small_max          = Ff_small_max(inRange_Lat, inRange_Lon);
        Ff_small_QA_mean      = Ff_small_QA_mean(inRange_Lat, inRange_Lon);
        
        if  ii == 1
            % counter
            Master_count_2018     = ii;
            Master_filename_2018  = F;
            Master_time_2018 = time ;
            
            Master_AOD_total_2018             = AOD_total_mean; 
            Master_AOD_total_std_2018         = AOD_total_std;
            Master_AOD_total_min_2018         = AOD_total_min;
            Master_AOD_total_max_2018         = AOD_total_max;
            Master_AOD_fine_2018              = AOD_fine;
            Master_AOD_coarse_2018            = AOD_coarse;
            Master_AOD_total_pixelcounts_2018 = AOD_total_pixelcounts; 
            Master_Ff_small_mean_2018         = Ff_small_mean; 
            Master_Ff_small_std_2018          = Ff_small_std; 
            Master_Ff_small_min_2018          = Ff_small_min;
            Master_Ff_small_max_2018          = Ff_small_max;
            Master_Ff_small_QA_mean_2018      = Ff_small_QA_mean;
            
        else
            
            % counter
            Master_count_2018     = cat(1, Master_count_2018, ii);
            Master_filename_2018  = cat(1, Master_filename_2018, F);
            Master_time_2018      = cat(1, Master_time_2018, time) ;

            Master_AOD_total_2018             = cat(3, Master_AOD_total_2018, AOD_total_mean);
            Master_AOD_total_std_2018         = cat(3, Master_AOD_total_std_2018, AOD_total_std);
            Master_AOD_total_min_2018         = cat(3, Master_AOD_total_min_2018, AOD_total_min);
            Master_AOD_total_max_2018         = cat(3, Master_AOD_total_max_2018, AOD_total_max);
            Master_AOD_fine_2018              = cat(3, Master_AOD_fine_2018, AOD_fine);
            Master_AOD_coarse_2018            = cat(3, Master_AOD_coarse_2018, AOD_coarse);
            Master_AOD_total_pixelcounts_2018 = cat(3, Master_AOD_total_pixelcounts_2018, AOD_total_pixelcounts);
            Master_Ff_small_mean_2018         = cat(3, Master_Ff_small_mean_2018, Ff_small_mean);
            Master_Ff_small_std_2018          = cat(3, Master_Ff_small_std_2018, Ff_small_std);
            Master_Ff_small_min_2018          = cat(3, Master_Ff_small_min_2018, Ff_small_min);
            Master_Ff_small_QA_mean_2018      = cat(3, Master_Ff_small_QA_mean_2018, Ff_small_QA_mean);
            Master_Ff_small_max_2018          = cat(3, Master_Ff_small_max_2018, Ff_small_max);
        end
        
    end
end


   
      
  

% CHANGE DIRECTORY!!!!!

cd /Volumes/'G-DRIVE mobile USB'/NEW_AOD/AOD_matfiles
%  Saving the variables here

%  save('Dimensions_AOD.mat', 'AOD_Latitude_subset', 'AOD_Longitude_subset', '-v7.3')

save('Master_MODIS_files_2018.mat',...
    'Master_count_2018',...
    'Master_filename_2018',...
    'Master_time_2018',...
    'Master_AOD_total_2018',...
    'Master_AOD_total_std_2018',...
    'Master_AOD_total_min_2018',...
    'Master_AOD_total_max_2018',...
    'Master_AOD_fine_2018',...
    'Master_AOD_coarse_2018',...
    'Master_AOD_total_pixelcounts_2018',...
    'Master_Ff_small_mean_2018',...
    'Master_Ff_small_std_2018',...
    'Master_Ff_small_min_2018',...
    'Master_Ff_small_max_2018',...
    'Master_Ff_small_QA_mean_2018', ...
    '-v7.3');


load handel
sound(y,Fs)



