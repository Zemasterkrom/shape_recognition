function tests()
    % calcul des descripteurs de Fourier de la base de données
    img_db_path = './db/';
    img_db_list = glob([img_db_path, '*.gif']);
    img_db = cell(1);
    label_db = cell(1);
    fd_db = cell(1);
    for im = 1:numel(img_db_list)
        img_db{im} = logical(imread(img_db_list{im}));
        label_db{im} = get_label(img_db_list{im});
        disp(label_db{im}); 
        [fd_db{im},~,~,~] = compute_fd(img_db{im});
    end

    % importation des images de requête dans une liste
    img_path = './dbq/';
    img_list = glob([img_path, '*.gif']);

    % pour chaque image de la liste...
    for im = 1:numel(img_list)

        % calcul du descripteur de Fourier de l'image
        img = logical(imread(img_list{im}));
        [fd,r,m,poly] = compute_fd(img);
        

        % calcul et tri des scores de distance aux descripteurs de la base
        for i = 1:length(fd_db)
            scores(i) = norm(fd-fd_db{i});
        end
        [scores, I] = sort(scores);

        % affichage des résultats    
        close all;
        figure(1);
        top = 5; % taille du top-rank affiché
        subplot(2,top,1);
        imshow(img); hold on; 
        plot(poly(:,1),poly(:,2),'v-g','MarkerSize',1,'LineWidth',1); % affichage du contour calculé
        subplot(2,top,2:top);
        plot(r); % affichage du profil de forme

        for i = 1:top
            subplot(2,top,top+i);
            imshow(img_db{I(i)}); % affichage des top plus proches images
        end

        drawnow();
        waitforbuttonpress();
    end
end

function P = point(pOne, pTwo, length)
    P = pOne + (pTwo - pOne) / norm(pTwo - pOne) * length;
end

function [fd,r,m,poly] = compute_fd(img)
    % calcul du barycentre de l'image
    m = barycenter(img);
    
    % calcul des lignes d'intersection
    N = 90; % à modifier !!!
    M = 512; % à modifier !!!
    [cx, cy] = get_intersection_lines(img, m, N);
    
    h = size(img,1);
    w = size(img,2);
    t = linspace(0,2*pi,100);
    R = 10;
    poly = [m(1)+R*cos(t'), m(2)+R*sin(t')]; % à modifier !!!
    r = R*ones(1,N); % à modifier !!!
    fd = rand(1,M); % à modifier !!!
end