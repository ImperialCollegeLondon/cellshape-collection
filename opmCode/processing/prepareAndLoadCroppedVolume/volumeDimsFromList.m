function [dimensions] = volumeDimsFromList(list)
Image.info = imfinfo([list(1).folder '\' list(1).name]);
dimensions = [Image.info.Height, Image.info.Width, numel(list)];
end