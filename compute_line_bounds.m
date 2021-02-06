% permet d'obtenir les coordonnées limites d'une ligne à l'intérieur d'une
% image selon un angle donné
function [x, y] = compute_line_bounds(img, point, thetaAngles)
    s = size(thetaAngles, 1);
    [height, width] = size(img);
    x = zeros(s, 1);
    y = zeros(s, 1);
    
    if (s > 0 && height > 0  && size(point, 1) > 0)
        for n = 1:s
            cosX = cos(deg2rad(thetaAngles(n)));
            sinY = sin(deg2rad(thetaAngles(n)));

            if (cosX > 0)
                tempY = ceil((width - point(1)) * sinY / cosX + point(2));

                if (tempY <= height && tempY >= 0)
                    y(n) = tempY-1;
                    x(n) = width-1;
                end
            else
                tempY = round(-point(1) * sinY / cosX + point(2));

                if (tempY <= height && tempY >= 0)
                    y(n) = tempY-1;
                    x(n) = 0;
                end
            end

            if (sinY > 0)
                tempX = round((height - point(2)) * cosX / sinY + point(1));

                if (tempX <= width && tempX >= 0)
                    y(n) = height-1;
                    x(n) = tempX-1;
                end
            else
                tempX = round(-point(2) * cosX / sinY + point(1));

                if (tempX <= width && tempX >= 0)
                    y(n) = 0;
                    x(n) = tempX-1;
                end
            end
        end
    end
end