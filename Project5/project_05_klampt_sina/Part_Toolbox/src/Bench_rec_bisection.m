% Benchmark for recursively partitioning meshes, based on various
% bisection approaches
%
% D.P & O.S for HPC Lab for CSE at ETH Zurich



% add necessary paths
addpaths_GP;
nlevels_a = 3;
nlevels_b = 4;

fprintf('       *********************************************\n')
fprintf('       ***  Recursive graph bisection benchmark  ***\n');
fprintf('       *********************************************\n')

% load cases
cases = {
    'airfoil1.mat';
    '3elt.mat';
    'barth4.mat';
    'mesh3e1.mat';
    'crack.mat';
    };

names = {
    'airfoil1';
    '3elt';
    'barth4';
    'mesh3e1';
    'crack';
    };

nc = length(cases);
maxlen = 0;
for c = 1:nc
    if length(cases{c}) > maxlen
        maxlen = length(cases{c});
    end
end

for c = 1:nc
    fprintf('.');
    sparse_matrices(c) = load(cases{c});
end


fprintf('\n\n Report Cases         Nodes     Edges\n');
fprintf(repmat('-', 1, 40));
fprintf('\n');
for c = 1:nc
    spacers  = repmat('.', 1, maxlen+3-length(cases{c}));
    [params] = Initialize_case(sparse_matrices(c));
    fprintf('%s %s %10d %10d\n', cases{c}, spacers,params.numberOfVertices,params.numberOfEdges);
end

%% Create results table
fprintf('\n%7s %16s %20s %16s %16s\n','Bisection','Spectral','Metis 5.0.2','Coordinate','Inertial');
fprintf('%10s %10d %6d %10d %6d %10d %6d %10d %6d\n','Partitions',8,16,8,16,8,16,8,16);
fprintf(repmat('-', 1, 100));
fprintf('\n');


for c = 1:nc
    spacers = repmat('.', 1, maxlen+3-length(cases{c}));
    fprintf('%s %s', cases{c}, spacers);
    sparse_matrix = load(cases{c});
    
    
    % Recursively bisect the loaded graphs in 8 and 16 subgraphs.
    % Steps
    % 1. Initialize the problem
    [params] = Initialize_case(sparse_matrices(c));
    W      = params.Adj;
    coords = params.coords;
    
    
    % 2. Recursive routines
    cnt = 1;
    data = ones(8,1);
    for p = 4:4
        % i. Spectral
        [m1, s1, A1] = rec_bisection(@bisection_spectral, p, W, coords, 0);
        figure(1);
        gplotmap(W, coords, m1);
        title(sprintf('Spectral recursive bisection %s', cases{c}));
        saveas(figure(1), sprintf('../figures/task4/spectral_rec_%s_%i.png', names{c}, 2^p));
        pause;
        % ii. Metis
        [m2, s2, A2] = rec_bisection(@bisection_metis, p, W, coords, 0);
        figure(2);
        gplotmap(W, coords, m2);
        title(sprintf('Metis recursive bisection %s', cases{c}));
        saveas(figure(2), sprintf('../figures/task4/metis_rec_%s_%i.png', names{c}, 2^p));
        pause;
        % iii. Coordinate
        [m3, s3, A3] = rec_bisection(@bisection_coordinate, p, W, coords, 0);
        figure(3);
        gplotmap(W, coords, m3);
        title(sprintf('Coordinate recursive bisection %s', cases{c}));
        saveas(figure(3), sprintf('../figures/task4/coordinate_rec_%s_%i.png', names{c}, 2^p));
        pause;
        % iv. Inertial
        [m4, s4, A4] = rec_bisection(@bisection_inertial, p, W, coords, 0);
        figure(4);
        gplotmap(W, coords, m4);
        title(sprintf('Inertial recursive bisection %s', cases{c}));
        saveas(figure(4), sprintf('../figures/task4/inertial_rec_%s_%i.png', names{c}, 2^p));
        pause;
        
        
        
        % 3. Calculate number of cut edges
        [i,j] = find(W);
        f1 = find(m1(i) > m1(j));
        f2 = find(m2(i) > m2(j));
        f3 = find(m3(i) > m3(j));
        f4 = find(m4(i) > m4(j));
        a1 = length(f1);
        a2 = length(f2);
        a3 = length(f3);
        a4 = length(f4);
        data((cnt-1)*4+(1:4)) = [a1 a2 a3 a4]; 
        cnt = cnt + 1;
    end
    
    % 4. Visualize the partitioning result
    %     figure(1)
    %     gplotmap(W,coords,m1_8);
    %     title(sprintf('Spectral recursive bisection %s', cases{c}));
    %     saveas(figure(1), sprintf('../figures/task4/spectral_rec_%s_%i.png', cases{c}, 2^3));
    %
    %     figure(2)
    %     gplotmap(W,coords,m1_16);
    %     title(sprintf('Spectral recursive bisection %s', cases{c}));
    %     saveas(figure(2), sprintf('../figures/task4/spectral_rec_%s_%i.png', cases{c}, 2^4));
    %
    %     figure(3)
    %     gplotmap(W,coords,m1_8);
    %     title(sprintf('Metis recursive bisection %s', cases{c}));
    %     saveas(figure(3), sprintf('../figures/task4/metis_rec_%s_%i.png', cases{c}, 2^3));
    %
    %     figure(4)
    %     gplotmap(W,coords,m1_16);
    %     title(sprintf('Metis recursive bisection %s', cases{c}));
    %     saveas(figure(4), sprintf('../figures/task4/metis_rec_%s_%i.png', cases{c}, 2^4));
    %
    %     figure(5)
    %     gplotmap(W,coords,m1_8);
    %     title(sprintf('Coordinate recursive bisection %s', cases{c}));
    %     saveas(figure(5), sprintf('../figures/task4/coordinate_rec_%s_%i.png', cases{c}, 2^3));
    %
    %     figure(6)
    %     gplotmap(W,coords,m1_16);
    %     title(sprintf('Coordinate recursive bisection %s', cases{c}));
    %     saveas(figure(6), sprintf('../figures/task4/coordinate_rec_%s_%i.png', cases{c}, 2^4));
    %
    %     figure(7)
    %     gplotmap(W,coords,m1_8);
    %     title(sprintf('Inertial recursive bisection %s', cases{c}));
    %     saveas(figure(7), sprintf('../figures/task4/inertial_rec_%s_%i.png', cases{c}, 2^3));
    %
    %     figure(8)
    %     gplotmap(W,coords,m1_16);
    %     title(sprintf('Inertial recursive bisection %s', cases{c}));
    %     saveas(figure(8), sprintf('../figures/task4/inertial_rec_%s_%i.png', cases{c}, 2^4));
    
    
    fprintf('%6d %6d %10d %6d %10d %6d %10d %6d\n',0,0,...
        0,0,0,0,0,0);
    
end
