close all
clear all

[Textdata, data, concs] = read_spreadsheet_csv('Spreadsheet_of_data.csv');
fileID = fopen('../crumb_data.csv','w');
fprintf(fileID,'Compound,Channel,Experiment,Dose,Response\n');

% Find all the drug names
NumDrugs = 30;
NumChannels = 7;
drug_idx = [1:NumDrugs];
start_drug_idx = 1 + 9*(drug_idx-1);

for i=1:NumDrugs
    drug_names{i} = Textdata{start_drug_idx(i)};
end

for i=1:NumChannels
    channel_names{i} = Textdata{1+i};
end

for drug = 1:NumDrugs
    for channel = 1:NumChannels        
        doses = unique(data(start_drug_idx(drug),:));
        doses = doses(~isnan(doses)); 
        for dose = 1:length(doses)
            % Find relevant columns of the data table
            this_dose_idx = find(data(start_drug_idx(drug),:)==doses(dose));
            % Find relevant columns for this channel
            this_dose_this_channel_idx = find(~isnan(data(start_drug_idx(drug)+channel,this_dose_idx)));
            for expt = 1:length(this_dose_this_channel_idx)
                response = data(start_drug_idx(drug)+channel,this_dose_idx(this_dose_this_channel_idx(expt)));
                % Write out data, note that we translate concentrations in
                % nM to uM with this line.
                fprintf(fileID,'%s,%s,%i,%g,%g\n',drug_names{drug}, channel_names{channel}, expt, doses(dose)./1000.0, response);
            end
        end
    end
end
fclose(fileID);
