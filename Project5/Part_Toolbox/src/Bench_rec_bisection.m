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
    % i. Spectral
    [m1_8, s1_8, A1_8] = rec_bisection('bisection_spectral', 3, W, coords, 0);
    [m1_16, s1_16, A1_16]  = rec_bisection('bisection_spectral', 4, W, coords, 0);

    % ii. Metis
    [m2_8, s2_8, A2_8]  = rec_bisection('bisection_metis', 3, W, coords, 0);
    [m2_16, s2_16, A2_16]  = rec_bisection('bisection_metis', 4, W, coords, 0);

    % iii. Coordinate
    [m3_8, s3_8, A3_8]  = rec_bisection('bisection_coordinate', 3, W, coords, 0);
    [m3_16, s3_16, A3_16]  = rec_bisection('bisection_coordinate', 4, W, coords, 0);

    % iv. Inertial
    [m4_8, s4_8, A4_8]  = rec_bisection('bisection_inertial', 3, W, coords, 0);
    [m4_16, s4_16, A4_16]  = rec_bisection('bisection_inertial', 4, W, coords, 0);

    
    % 3. Calculate number of cut edges
    cut_edges_1_8 = size(s1_8, 1);
    cut_edges_2_8 = size(s2_8, 1);
    cut_edges_3_8 = size(s3_8, 1);
    cut_edges_4_8 = size(s4_8, 1);
    
    cut_edges_1_16 = size(s1_16, 1);
    cut_edges_2_16 = size(s2_16, 1);
    cut_edges_3_16 = size(s3_16, 1);
    cut_edges_4_16 = size(s4_16, 1);
    
    
    % 4. Visualize the partitioning result
    figure(1)
    gplotmap(W,coords,m1_8);
    title(sprintf('Spectral recursive bisection %s', cases{c}));
    saveas(figure(1), sprintf('../figures/task4/spectral_rec_%s_m1_16.png', cases{c}, 2^3));

    figure(2)
    gplotmap(W,coords,m1_16);
    title(sprintf('Spectral recursive bisection %s', cases{c}));
    saveas(figure(2), sprintf('../figures/task4/spectral_rec_%s_m1_16.png', cases{c}, 2^4));
    
    figure(3)
    gplotmap(W,coords,m1_8);
    title(sprintf('Metis recursive bisection %s', cases{c}));
    saveas(figure(3), sprintf('../figures/task4/metis_rec_%s_m1_8.png', cases{c}, 2^3));

    figure(4)
    gplotmap(W,coords,m1_16);
    title(sprintf('Metis recursive bisection %s', cases{c}));
    saveas(figure(4), sprintf('../figures/task4/metis_rec_%s_m1_16.png', cases{c}, 2^4));
    
    figure(5)
    gplotmap(W,coords,m1_8);
    title(sprintf('Coordinate recursive bisection %s', cases{c}));
    saveas(figure(5), sprintf('../figures/task4/coordinate_rec_%s_m1_8.png', cases{c}, 2^3));

    figure(6)
    gplotmap(W,coords,m1_16);
    title(sprintf('Coordinate recursive bisection %s', cases{c}));
    saveas(figure(6), sprintf('../figures/task4/coordinate_rec_%s_m1_16.png', cases{c}, 2^4));
    
    figure(7)
    gplotmap(W,coords,m1_8);
    title(sprintf('Inertial recursive bisection %s', cases{c}));
    saveas(figure(7), sprintf('../figures/task4/inertial_rec_%s_m1_8.png', cases{c}, 2^3));

    figure(8)
    gplotmap(W,coords,m1_16);
    title(sprintf('Inertial recursive bisection %s', cases{c}));
    saveas(figure(8), sprintf('../figures/task4/inertial_rec_%s_m1_16.png', cases{c}, 2^4));
    
    
    fprintf('%6d %6d %10d %6d %10d %6d %10d %6d\n',0,0,...
    0,0,0,0,0,0);
    
end
