function data = readFileInfo(filename)


data = struct;
temp = split(filename, '_');
data.property = temp{1};
for i = 2:2:length(temp)-1
    fieldName = temp{i};
    fieldValue = temp{i+1};
    data.(fieldName) = str2double(fieldValue);
end

dataframe = load(filename);

interval = 1;
natural_base = dataframe.natural_config_detection;
x0 = natural_base(1:interval:end, 2);
y0 = natural_base(1:interval:end, 3);

natural_opt = dataframe.pred_config_opt;
x = natural_opt(1:interval:end, 1);
y = natural_opt(1:interval:end, 2);

data.error_opt = mean(sqrt(sum(([x0, y0] - [x, y]).^2, 2))) ;

pred_noise = dataframe.pred_config_noise;
x = pred_noise(1:interval:end, 1);
y = pred_noise(1:interval:end, 2);


data.error_noise = mean(sqrt(sum(([x0, y0] - [x, y]).^2, 2))) ;

end