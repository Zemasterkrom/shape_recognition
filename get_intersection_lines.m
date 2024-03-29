% permet d'obtenir les coordonnées des lignes en intersection avec les
% pixels blancs sur leur direction
function [x, y] = get_intersection_lines(img, barycenter, nbLines)
    
    % définition des variables : facteur de rotation de chaque ligne),
    % degrés de chaque ligne, taille de la ligne pour différentes
    % coordonnées
    factor = round(360/nbLines);
    deg = 0 : factor : 359;
    maxSize = max(size(img));
    space = 1:2:maxSize;

    % calcul des coordonnées maximales des différentes lignes sur les
    % différents angles
    x = ceil(space.*cosd(deg(:)) + barycenter(1));
    y = ceil(space.*sind(deg(:)) + barycenter(2));
    
    %élimination des coordonnées "out-of-bounds"
    sX = size(x);
    sI = size(img);
    
    for i = 1:sX(1)
        for j = 1:sX(2)
            if (x(i, j) <= 0 || y(i, j) <= 0)
                x(i, j:end) = 1;
                y(i, j:end) = 1;
                break;
            elseif (x(i, j) >= sI(2) - 1 || y(i, j) >= sI(1) - 1)
                x(i, j:end) = 1;
                y(i, j:end) = 1;
                break;
            end
        end
    end
    
    %intersection des coordonnées sur un plan linéaire
    tempX = x;
    x = x.*img(sub2ind(size(img), y, x));
    y = y.*img(sub2ind(size(img), y, tempX));

    %récupération des lignes en intersection avec les derniers pixels blancs sur leur direction
    [indexes, x, y] = get_coordinates_till_last_white_pixel(img, x, y, factor, barycenter);
   
    %création des deux matrices pour l'affichage des lignes
    x = [ones(size(indexes(:)))*barycenter(1) x(indexes)];
    y = [ones(size(indexes(:)))*barycenter(2) y(indexes)];
end