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
    % rencontré, on retourne la coordonnée limite sur l'angle
    if (undefinedRows) 
        undefinedRows = [undefinedRows(:)-1 (undefinedRows - 1) * rotation];
        [x, y] = compute_line_bounds(img, barycenter, undefinedRows(:, 2));
        [rows, cols] = ind2sub(size(img), sub2ind(size(img), y(:)+1, x(:)+1));
        xMatrix(undefinedRows(:, 1)+1, 1) = cols;
        yMatrix(undefinedRows(:, 1)+1, 1) = rows;
        indexes(undefinedRows(:, 1)+1) = 1;
    end
    
    indexes = sub2ind(size(xMatrix), rowNumber(:), indexes(:));
end