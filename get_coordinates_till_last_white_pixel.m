% permet d'obtenir les coordonnées maximales pour chaque angle d'une ligne
% selon le barycentre (jusqu'au dernier pixel blanc sur la direction de la
% ligne)
function [indexes, xMatrix, yMatrix] = get_coordinates_till_last_white_pixel(img, xMatrix, yMatrix, rotation, barycenter)

    % pour chaque ligne de la matrice des abscisses, on retourne l'indice
    % maximal sur la ligne dont la valeur associée est supérieure à 1
    % (position définie)
    flipped_matrix = fliplr(xMatrix);
    indexes = size(xMatrix, 2) - sum(cumprod(flipped_matrix <= 1, 2), 2);
    rowNumber = 1:size(indexes);
    
    % lignes infinies : aucune valeur n'est strictement positive dans la ligne, il n'y
    % a donc aucune collision
    undefinedRows = find(indexes == 0);

    % si des lignes sont infinies, dans le seul ou aucun pixel blanc n'est
    % rencontré, on retourne le barycentre
    if (undefinedRows) 
        undefinedRows = [undefinedRows(:)-1 (undefinedRows - 1) * rotation];
        xMatrix(undefinedRows(:, 1)+1, 1) = 1;
        yMatrix(undefinedRows(:, 1)+1, 1) = 1;
        indexes(undefinedRows(:, 1)+1) = 1;
        indexes = sub2ind(size(xMatrix), rowNumber(:), indexes(:));
        lastUndefinedPixel = undefinedRows(end, 1)+2;

        % on lie les lignes infinies au prochain point fini afin de créer
        % une forme de contour réaliste et donc une reconnaissance plus
        % précise
        if (lastUndefinedPixel <= size(xMatrix, 1) && lastUndefinedPixel > 0)
            xMatrix(undefinedRows(:, 1)+1, 1) = xMatrix(indexes(lastUndefinedPixel));
            yMatrix(undefinedRows(:, 1)+1, 1) = yMatrix(indexes(lastUndefinedPixel));
        end
    else 
        indexes = sub2ind(size(xMatrix), rowNumber(:), indexes(:));
    end
end