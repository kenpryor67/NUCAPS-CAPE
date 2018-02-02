% read_python_Lift_Parcel_profile.m
%
% Read in CAPE and other variables from text file created by python script
% Used in calculation of CAPE and other values
%
% revised: rok JMG UW-SSEC 21 June 2016
% revised: rok     UW-SSEC 22 June 2016
% revised: 29 June 2017 CEAB ROK 
% revised: 03 July 2017 ROK  Check if file exists

python_FILE = 'Lift_Parcel_profile.txt';
%
if exist(python_FILE,'file')==2
    % file exists
    fid = fopen(python_FILE, 'r');
    line_1 = fgetl(fid);    %"profile   20060906T193534"
    line_2 = fgetl(fid);
    line_3 = fgetl(fid);
    line_4 = fgetl(fid);    %"Surface CAPE = 83.952187079"
    line_5 = fgetl(fid);    %"Surface CIN = -278.821288945"
    line_6 = fgetl(fid);    %"Surface LCL = 828.707024183"
    line_7 = fgetl(fid);    %"Surface LFC = 6121.99514343"
    line_8 = fgetl(fid);    %"Surface EL = 8852.78106776"
    line_9 = fgetl(fid);    %"Surface LI = 1.73940362271"
    line_10 = fgetl(fid);   %
    line_11 = fgetl(fid);   %
    line_12 = fgetl(fid);   %"Forecast CAPE = 0.0"
    line_13 = fgetl(fid);   %"Forecast CIN = 0.0"
    line_14 = fgetl(fid);   %"Forecast LCL = 2448.3605"
    line_15 = fgetl(fid);   %"Forecast LFC = --"
    line_16 = fgetl(fid);   %"Forecast EL = 2448.3605"
    line_17 = fgetl(fid);   %"Forecast LI = 6.11315500859"
    line_18 = fgetl(fid);   %
    line_19 = fgetl(fid);   %
    line_20 = fgetl(fid);   %"Most-Unstable CAPE = 83.952187079"
    line_21 = fgetl(fid);   %"Most-Unstable CIN = -278.821288945"
    line_22 = fgetl(fid);   %"Most-Unstable LCL = 828.707024183"
    line_23 = fgetl(fid);   %"Most-Unstable LFC = 6121.99514343"
    line_24 = fgetl(fid);   %"Most-Unstable EL = 8852.78106776"
    line_25 = fgetl(fid);   %"Most-Unstable LI = 1.73940362271"
    line_26 = fgetl(fid);   %
    line_27 = fgetl(fid);   %
    line_28 = fgetl(fid);   %"Mean Layer CAPE = 0.0"
    line_29 = fgetl(fid);   %"Mean Layer CIN = 0.0"
    line_30 = fgetl(fid);   %"Mean Layer LCL = 2161.13682459"
    line_31 = fgetl(fid);   %"Mean Layer LFC = --"
    line_32 = fgetl(fid);   %"Mean Layer EL = 2161.13682459"
    line_33 = fgetl(fid);   %"Mean Layer LI = 7.75183840964"
    % disp('----------------------------------------------------------------------------------------------')
    % disp(python_FILE)
    % disp(line_1);disp(line_2);disp(line_3);disp(line_4);disp(line_5);
    % disp(line_6);disp(line_7);disp(line_8);disp(line_9);disp(line_10);
    % disp(line_11);disp(line_12);disp(line_13);disp(line_14);disp(line_15);
    % disp(line_16);disp(line_17);disp(line_18);disp(line_19);disp(line_20);
    % disp(line_21);disp(line_22);disp(line_23);disp(line_24);disp(line_25);
    % disp(line_26);disp(line_27);disp(line_28);disp(line_29);disp(line_30);
    % disp(line_31);disp(line_32);disp(line_33);
    fclose(fid);
    % Assign SHARPpy variables 
    str=line_4(strfind(line_4,'=')+1:end-1);[value,count]=sscanf(str,'%f'); if count==1, tmp_scape_SHARPpy=value; else tmp_scape_SHARPpy=NaN; end
    str=line_5(strfind(line_5,'=')+1:end-1);[value,count]=sscanf(str,'%f'); if count==1, tmp_scin_SHARPpy=value; else tmp_scin_SHARPpy=NaN; end  
    str=line_6(strfind(line_6,'=')+1:end-1);[value,count]=sscanf(str,'%f'); if count==1, tmp_slcl_SHARPpy=value; else tmp_slcl_SHARPpy=NaN; end  
    str=line_7(strfind(line_7,'=')+1:end-1);[value,count]=sscanf(str,'%f'); if count==1, tmp_slfc_SHARPpy=value; else tmp_slfc_SHARPpy=NaN; end  
    str=line_8(strfind(line_8,'=')+1:end-1);[value,count]=sscanf(str,'%f'); if count==1, tmp_sel_SHARPpy=value; else tmp_sel_SHARPpy=NaN; end  
    str=line_9(strfind(line_9,'=')+1:end-1);[value,count]=sscanf(str,'%f'); if count==1, tmp_sli_SHARPpy=value; else tmp_sli_SHARPpy=NaN; end  
    % disp('... Surface CAPE, CIN, LCL, LFC, EL, LI')
    % disp(num2str([tmp_scape_SHARPpy tmp_scin_SHARPpy tmp_slcl_SHARPpy tmp_slfc_SHARPpy tmp_sel_SHARPpy tmp_sli_SHARPpy]))
    %
    str=line_12(strfind(line_12,'=')+1:end-1);[value,count]=sscanf(str,'%f'); if count==1, tmp_fcape_SHARPpy=value; else tmp_fcape_SHARPpy=NaN; end
    str=line_13(strfind(line_13,'=')+1:end-1);[value,count]=sscanf(str,'%f'); if count==1, tmp_fcin_SHARPpy=value; else tmp_fcin_SHARPpy=NaN; end  
    str=line_14(strfind(line_14,'=')+1:end-1);[value,count]=sscanf(str,'%f'); if count==1, tmp_flcl_SHARPpy=value; else tmp_flcl_SHARPpy=NaN; end  
    str=line_15(strfind(line_15,'=')+1:end-1);[value,count]=sscanf(str,'%f'); if count==1, tmp_flfc_SHARPpy=value; else tmp_flfc_SHARPpy=NaN; end  
    str=line_16(strfind(line_16,'=')+1:end-1);[value,count]=sscanf(str,'%f'); if count==1, tmp_fel_SHARPpy=value; else tmp_fel_SHARPpy=NaN; end  
    str=line_17(strfind(line_17,'=')+1:end-1);[value,count]=sscanf(str,'%f'); if count==1, tmp_fli_SHARPpy=value; else tmp_fli_SHARPpy=NaN; end  
    %disp('... Forecast CAPE, CIN, LCL, LFC, EL, LI')
    %disp(num2str([tmp_fcape_SHARPpy tmp_fcin_SHARPpy tmp_flcl_SHARPpy tmp_flfc_SHARPpy tmp_fel_SHARPpy tmp_fli_SHARPpy]))
    %
    str=line_20(strfind(line_20,'=')+1:end-1);[value,count]=sscanf(str,'%f'); if count==1, tmp_mucape_SHARPpy=value; else tmp_mucape_SHARPpy=NaN; end
    str=line_21(strfind(line_21,'=')+1:end-1);[value,count]=sscanf(str,'%f'); if count==1, tmp_mucin_SHARPpy=value; else tmp_mucin_SHARPpy=NaN; end  
    str=line_22(strfind(line_22,'=')+1:end-1);[value,count]=sscanf(str,'%f'); if count==1, tmp_mulcl_SHARPpy=value; else tmp_mulcl_SHARPpy=NaN; end  
    str=line_23(strfind(line_23,'=')+1:end-1);[value,count]=sscanf(str,'%f'); if count==1, tmp_mulfc_SHARPpy=value; else tmp_mulfc_SHARPpy=NaN; end  
    str=line_24(strfind(line_24,'=')+1:end-1);[value,count]=sscanf(str,'%f'); if count==1, tmp_muel_SHARPpy=value; else tmp_muel_SHARPpy=NaN; end  
    str=line_25(strfind(line_25,'=')+1:end-1);[value,count]=sscanf(str,'%f'); if count==1, tmp_muli_SHARPpy=value; else tmp_muli_SHARPpy=NaN; end  
    % disp('... Most-Unstable CAPE, CIN, LCL, LFC, EL, LI')
    % disp(num2str([tmp_mucape_SHARPpy tmp_mucin_SHARPpy tmp_mulcl_SHARPpy tmp_mulfc_SHARPpy tmp_muel_SHARPpy tmp_muli_SHARPpy]))
    %
    str=line_28(strfind(line_28,'=')+1:end-1);[value,count]=sscanf(str,'%f'); if count==1, tmp_mlcape_SHARPpy=value; else tmp_mlcape_SHARPpy=NaN; end
    str=line_29(strfind(line_29,'=')+1:end-1);[value,count]=sscanf(str,'%f'); if count==1, tmp_mlcin_SHARPpy=value; else tmp_mlcin_SHARPpy=NaN; end  
    str=line_30(strfind(line_30,'=')+1:end-1);[value,count]=sscanf(str,'%f'); if count==1, tmp_mllcl_SHARPpy=value; else tmp_mllcl_SHARPpy=NaN; end  
    str=line_31(strfind(line_31,'=')+1:end-1);[value,count]=sscanf(str,'%f'); if count==1, tmp_mllfc_SHARPpy=value; else tmp_mllfc_SHARPpy=NaN; end  
    str=line_32(strfind(line_32,'=')+1:end-1);[value,count]=sscanf(str,'%f'); if count==1, tmp_mlel_SHARPpy=value; else tmp_mlel_SHARPpy=NaN; end  
    str=line_33(strfind(line_33,'=')+1:end-1);[value,count]=sscanf(str,'%f'); if count==1, tmp_mlli_SHARPpy=value; else tmp_mlli_SHARPpy=NaN; end  
    % disp('... Mean Layer CAPE, CIN, LCL, LFC, EL, LI')
    % disp(num2str([tmp_mlcape_SHARPpy tmp_mlcin_SHARPpy tmp_mllcl_SHARPpy tmp_mllfc_SHARPpy tmp_mlel_SHARPpy tmp_mlli_SHARPpy]))
    % disp('----------------------------------------------------------------------------------------------')
else
    %  File does not exist
    tmp_scape_SHARPpy=NaN;tmp_scin_SHARPpy=NaN;tmp_slcl_SHARPpy=NaN;tmp_slfc_SHARPpy=NaN;tmp_sel_SHARPpy=NaN;tmp_sli_SHARPpy=NaN;
    tmp_fcape_SHARPpy=NaN;tmp_fcin_SHARPpy=NaN;tmp_flcl_SHARPpy=NaN;tmp_flfc_SHARPpy=NaN;tmp_fel_SHARPpy=NaN;tmp_fli_SHARPpy=NaN;
    tmp_mucape_SHARPpy=NaN;tmp_mucin_SHARPpy=NaN;tmp_mulcl_SHARPpy=NaN;tmp_mulfc_SHARPpy=NaN;tmp_muel_SHARPpy=NaN;tmp_muli_SHARPpy=NaN;
    tmp_mlcape_SHARPpy=NaN;tmp_mlcin_SHARPpy=NaN;tmp_mllcl_SHARPpy=NaN;tmp_mllfc_SHARPpy=NaN;tmp_mlel_SHARPpy=NaN;tmp_mlli_SHARPpy=NaN;    
end

