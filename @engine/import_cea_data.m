function import_cea_data(engine, filename)
%{
This function reads in requested gas property data from NASA CEA tabulated 
output files. 
%}
    % read in file
    cea_table = readtable(filename);
    
    % pull each property
    prop_names = fieldnames(table2struct(cea_table));
    [N_props, ~] = size(prop_names);
    
    % pack struct
    for i = 1:N_props
        prop_i = convertCharsToStrings(cell2mat(prop_names(i)));
        engine.cea_data.(prop_i) = cea_table.(prop_i);
    end
    
end