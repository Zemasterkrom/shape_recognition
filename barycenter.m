function m = barycenter(img)
    img = logical(img);
    [rows, cols] = size(img);
    [x, y] = meshgrid(1:cols, 1:rows);
    m = mean([x(img), y(img)]);
end