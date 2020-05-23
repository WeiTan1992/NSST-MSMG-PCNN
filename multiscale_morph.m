function FM = multiscale_morph(img, num)
%========================================================================
%This is a function to compute the multiscale morphological gradient
%Input: 
%       img: the input image
%     scale: the number of the scales
%Output:
%        FM: Focus-measure
%========================================================================
img = double(img);
FM = double(zeros(size(img))); 

for ii = 1 : num
    scale = 2 * ii + 1;
    se = strel('disk', scale);
    g = imdilate(img, se) - imerode(img, se);
	FM = FM + 1 / scale *(g);
end

return