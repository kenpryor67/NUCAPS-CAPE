% calc_NUCAPS_MADIS_CAPE
%
% input: gridded,smoothed MADIS and NUCAPS files. 
% SHARPpy is used to calculate convective parameters
% output: matfile containing matching grid of parameters
%
% revised: 29 June 2017 CEAB ROK
% revised: 30 June 2017 CEAB ROK
% revised: 03 July 2017 CEAB ROK adding in MADIS files
% revised: 05 July 2017 CEAB ROK output names with and without MADIS
% revised: 21 Nov  2017 ROK      put surface in filename
% revised: 30 Nov  2017 ROK      use MADIS file within 45 minutes of overpass
%
% Format of SHARPpy Lift_Parcel_profile.txt
% "profile   20060906T193534"
% "
% "
% "Surface CAPE = 83.952187079"
% "Surface CIN = -278.821288945"
% "Surface LCL = 828.707024183"
% "Surface LFC = 6121.99514343"
% "Surface EL = 8852.78106776"
% "Surface LI = 1.73940362271"
% "
% "
% "Forecast CAPE = 0.0"
% "Forecast CIN = 0.0"
% "Forecast LCL = 2448.3605"
% "Forecast LFC = --"
% "Forecast EL = 2448.3605"
% "Forecast LI = 6.11315500859"
% "
% "
% "Most-Unstable CAPE = 83.952187079"
% "Most-Unstable CIN = -278.821288945"
% "Most-Unstable LCL = 828.707024183"
% "Most-Unstable LFC = 6121.99514343"
% "Most-Unstable EL = 8852.78106776"
% "Most-Unstable LI = 1.73940362271"
% "
% "
% "Mean Layer CAPE = 0.0"
% "Mean Layer CIN = 0.0"
% "Mean Layer LCL = 2161.13682459"
% "Mean Layer LFC = --"
% "Mean Layer EL = 2161.13682459"
% "Mean Layer LI = 7.75183840964"

input_pname = 'matfiles/';
output_pname = 'matfiles/';
% Raman Height Levels 202  levels
load('raman_height_202.mat')
make_plots = 0; % set = 1 to view plots
with_MADIS = 0; % with MADIS = 0, NUCAPS surface = 1

MADIS_path = '../../../../MADIS/current/matfiles/';

files = dir([input_pname 'gridded_NUCAPS_profile_*smooth.mat']);
numfiles = length(files);
 
for ifile= 1:numfiles
    %
    filename = files(ifile).name;
    if with_MADIS == 0
        outfile = ['SHARPpy_parameters_MADIS_' filename(1:end-4) '.mat'];
    else
        outfile = ['SHARPpy_parameters_' filename(1:end-4) '.mat'];
    end
    if exist([output_pname outfile],'file') == 2  % if matfile exists, skip to next file
        disp(['...skipping file: ' filename])
        continue
    end
    disp(['...loading ' filename])
    load([input_pname filename]);
    if with_MADIS == 0
        % Find MADIS matfile closest in time but prior to overpass
        MADIS_surface_filename = [];
        surf_files = dir([MADIS_path 'gridded_MADIS_*smooth.mat']);
        numsurffiles = length(surf_files);
        for isurf = 1:numsurffiles
            load([MADIS_path surf_files(isurf).name], 'MADIS_case_time');
            disp(['...MADIS time: ' datestr(MADIS_case_time)])
            if abs(MADIS_case_time - NUCAPS_case_time) < 45/(60*24), 
                disp(['...found value within 45 minutes of selected time ']) 
                MADIS_surface_filename = surf_files(isurf).name;
                break 
            end
        end
        if length(MADIS_surface_filename) <= 0 
            disp(['...skipping: no MADIS found matching NUCAPS ' filename])
            continue
        end
        % load MADIS file
        disp(['...loading ' MADIS_surface_filename])
        sfc_tmp = load([MADIS_path MADIS_surface_filename]);
        %sfc.smoothpresmatrix = sfc_tmp.MADIS_smoothpresmatrix;
        sfc.smoothtempmatrix = sfc_tmp.MADIS_smoothtempmatrix;
        sfc.smoothdewtmatrix = sfc_tmp.MADIS_smoothdewtmatrix;
        % using NUCAPS surface pressure
         NUCAPS_surface_filename = [filename(1:15) 'surface_' filename(24:end)];
        disp(['...loading ' NUCAPS_surface_filename])
        sfc_tmp = load([input_pname NUCAPS_surface_filename]);
        sfc.smoothpresmatrix = sfc_tmp.NUCAPS_smoothpresmatrix;
    else 
        % load corresponding NUCAPS surface file
        NUCAPS_surface_filename = [filename(1:15) 'surface_' filename(24:end)];
        disp(['...loading ' NUCAPS_surface_filename])
        sfc_tmp = load([input_pname NUCAPS_surface_filename]);
        sfc.smoothpresmatrix = sfc_tmp.NUCAPS_smoothpresmatrix;
        sfc.smoothtempmatrix = sfc_tmp.NUCAPS_smoothtempmatrix;
        sfc.smoothdewtmatrix = sfc_tmp.NUCAPS_smoothdewtmatrix;
    end
    %
    numrow = size(latmatrix,1);
    numcol = size(latmatrix,2);
    
    scape = nan(numrow,numcol); mucape = nan(numrow,numcol);
    scin = nan(numrow,numcol); mucin = nan(numrow,numcol);
    slcl = nan(numrow,numcol); mulcl = nan(numrow,numcol);
    slfc = nan(numrow,numcol);mulfc = nan(numrow,numcol);
    sel = nan(numrow,numcol); muel = nan(numrow,numcol);
    sli = nan(numrow,numcol); muli = nan(numrow,numcol);
    %
    fcape = nan(numrow,numcol); mlcape = nan(numrow,numcol);
    fcin = nan(numrow,numcol); mlcin = nan(numrow,numcol);
    flcl = nan(numrow,numcol); mllcl = nan(numrow,numcol);
    flfc = nan(numrow,numcol); mllfc = nan(numrow,numcol);
    fel = nan(numrow,numcol); mlel = nan(numrow,numcol);
    fli = nan(numrow,numcol); mlli = nan(numrow,numcol);
    %
    
    for irow = 1:numrow
        for icol = 1:numcol
            % 
            % output profile in SPC format (Storm Prediction Center)
            % Extract the NUCAPS surface values
            latz = latmatrix(irow,icol);
            lonz = lonmatrix(irow,icol);
            surfPress = sfc.smoothpresmatrix(irow,icol);
            surfTempAir = sfc.smoothtempmatrix(irow,icol);
            surfWVDEWT = sfc.smoothdewtmatrix(irow,icol);
%             surfPress = NUCAPS_sfc.NUCAPS_smoothpresmatrix(irow,icol);
%             surfTempAir = NUCAPS_sfc.NUCAPS_smoothtempmatrix(irow,icol);
%             surfWVDEWT = NUCAPS_sfc.NUCAPS_smoothdewtmatrix(irow,icol);
            % Extract the profile where it is valid
            % test if surface pressure is not a number, skip to next grid
            if isnan(surfPress), continue, end 
            % test if profile is nan, skip to next grid
            if isnan(NUCAPS_smoothpresmatrix(1,irow,icol)), continue, end
            disp('...found a valid profile!!!')
            % Insert Surface variables as lowest level.
            index = find(NUCAPS_smoothpresmatrix(:,irow,icol) > surfPress,1);
            num_valid_levels = index-1;
            pz=[NUCAPS_smoothpresmatrix(1:num_valid_levels,irow,icol); surfPress];  % AIRS fixed pressure levels plus SurfacePressure
            tz=[NUCAPS_smoothtempmatrix(1:num_valid_levels,irow,icol); surfTempAir] -273.15;   % Convert to Celsius
            tdz=[NUCAPS_smoothdewtmatrix(1:num_valid_levels,irow,icol); surfWVDEWT] -273.15;   % Convert to Celsius
            %
            % Computing pressure altitude in feet then converted to meters
            alt_feet=(1-(pz/1013.25).^0.190284).*145366.45;    % Calculate pressure altitude in Feet
            alt_meters=alt_feet*0.3048;                        % Convert feet to meters
            hz=alt_meters-alt_meters(end)+2;                   % AG height = altitude - surface altitude + 2 meters (2 meter AGL)
            % Interpolate from AIRS levels to 202 Raman Height levels
            pz_202 = interp1(hz,pz,1000.*raman_height_202);    % This flips presssure order to descending 
            tz_202 = interp1(hz,tz,1000.*raman_height_202);
            tdz_202 = interp1(hz,tdz,1000.*raman_height_202);
            hz_202  = 1000.*raman_height_202;                   % hz_202 is in meters AGL in ascending order
%           hz_202  = 1000.*raman_height_202 + alt_meters(end);   % Change from AGL to MSL height while keeping profile the same
            %

                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Diagnostic plot of interpolated profile
                if make_plots == 1
                    %
                    figure(1)
                    clf
                    marker_size = 10;
                    plot(tz,hz,'bs-',tdz,hz,'bd--','MarkerSize',marker_size);grid on; hold on
                    plot(tz_202,hz_202,'ks-',tdz_202,hz_202,'kx--','MarkerSize',marker_size)
%                     plot(ASOS.temperature,hz_202(1),'rs',ASOS.dewpoint,hz_202(1),'rx','MarkerSize',marker_size)
                    set(gca,'XLim',[-5 35])
%                     set(gca,'YLim',[0 120])
                    set(gca,'FontSize',12)
                    xlabel('Tair / Tdew  (C)')
                    ylabel('Height (m)')             
                    legend('Tair AIRS-101','DewT AIRS-101','Tair AIRS-202','DewT AIRS-202','ASOS 2m Tair','ASOS 2m Tdew')
                    title(['Overpass Time:  ' datestr(NUCAPS_case_time)])
%                     disp('... press any key to continue'); pause
                    pause(1)
                    %
                end
            % Output in SPC format
                out_matrix_202=cat(2,pz_202, hz_202, tz_202, tdz_202, zeros(length(pz_202),1), zeros(length(pz_202),1))';
                %
                output_filename = ['profile'  '.csv'];
                fid=fopen(output_filename,'w');
                fprintf(fid,'%s\n','%TITLE%');
                fprintf(fid,'%s\n',['profile   ' datestr(NUCAPS_case_time, 'yyyymmddTHHMMSS')]);
                fprintf(fid,'%10.5f\n',latz);
                fprintf(fid,'%10.5f\n',lonz);
                fprintf(fid,'%s\n','%RAW%');
                fprintf(fid,'%10.2f,  %10.2f,  %10.2f,  %10.2f,  %10.2f,  %10.2f\n',out_matrix_202);
                fprintf(fid,'%s\n','%END%');
                fclose(fid);
                % Call python
                unix_command=['./run_get_CAPE_matlab_15June2016.scr'];
                unix(unix_command);
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Read values from python output
                read_python_Lift_Parcel_profile_3July2017
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                scape(irow,icol) = tmp_scape_SHARPpy;
                scin(irow,icol) = tmp_scin_SHARPpy;
                slcl(irow,icol) = tmp_slcl_SHARPpy;
                slfc(irow,icol) = tmp_slfc_SHARPpy;
                sel(irow,icol) = tmp_sel_SHARPpy;
                sli(irow,icol) = tmp_sli_SHARPpy;
                %
                fcape(irow,icol) = tmp_fcape_SHARPpy;
                fcin(irow,icol) = tmp_fcin_SHARPpy;
                flcl(irow,icol) = tmp_flcl_SHARPpy;
                flfc(irow,icol) = tmp_flfc_SHARPpy;
                fel(irow,icol) = tmp_fel_SHARPpy;
                fli(irow,icol) = tmp_fli_SHARPpy;
                %
                mucape(irow,icol) = tmp_mucape_SHARPpy;
                mucin(irow,icol) = tmp_mucin_SHARPpy;
                mulcl(irow,icol) = tmp_mulcl_SHARPpy;
                mulfc(irow,icol) = tmp_mulfc_SHARPpy;
                muel(irow,icol) = tmp_muel_SHARPpy;
                muli(irow,icol) = tmp_muli_SHARPpy;
                %
                mlcape(irow,icol) = tmp_mlcape_SHARPpy;
                mlcin(irow,icol) = tmp_mlcin_SHARPpy;
                mllcl(irow,icol) = tmp_mllcl_SHARPpy;
                mllfc(irow,icol) = tmp_mllfc_SHARPpy;
                mlel(irow,icol) = tmp_mlel_SHARPpy;
                mlli(irow,icol) = tmp_mlli_SHARPpy;
                
        end
    end
    disp(['...saving matfile: ' outfile ])
    save([output_pname outfile],'NUCAPS_case_time','latmatrix','lonmatrix',...
          'scape','scin','slcl','slfc','sel','sli', ...
          'fcape','fcin','flcl','flfc','fel','fli', ...
          'mucape','mucin','mulcl','mulfc','muel','muli', ...
          'mlcape','mlcin','mllcl','mllfc','mlel','mlli')
end
            
            
            
            
            
