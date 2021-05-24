function [part1,part2] = bisection_inertial(A,xy,picture)
% bisection_inertial : Inertial partition of a graph.
%
% [p1,p2] = bisection_inertial(A,xy) returns a list of the vertices on one side of a partition
%     obtained by bisection with a line or plane normal to a moment of inertia
%     of the vertices, considered as points in Euclidean space.
%     Input A is the adjacency matrix of the mesh (used only for the picture!);
%     each row of xy is the coordinates of a point in d-space.
%
% bisection_inertial(A,xy,1) also draws a picture.
%
% See also PARTITION

n = size(A, 1);
map = zeros(n, 1);

x = xy(:, 1);
y = xy(:, 2);
x_mean = mean(x);
y_mean = mean(y);

xx = sum((x - x_mean).^2);
xy2 = sum((x - x_mean).*(y - y_mean));
yy = sum((y - y_mean));

M = [yy, xy2; xy2, xx];

[V, Diag] = eigs(M, 1, 'smallestabs');

eigenvalues = diag(Diag);
lam1 = eigenvalues(1);
u1 = V(:, 1);

u1 = u1 / norm(u1);

[part1, part2] = partition(xy - [x_mean, y_mean], u1);


disp(' ');
disp(' HPC Lab for CSE at ETH:   ');
disp(' Implement inertial bisection');
disp(' ');


% Steps
% 1. Calculate the center of mass.
% 2. Construct the matrix M.
%  (Consult the pdf of the assignment for the creation of M) 
% 3. Calculate the smallest eigenvector of M.  
% 4. Find the line L on which the center of mass lies.
% 5. Partition the points around the line L.
%   (you may use the function partition.m)


% <<<< Dummy implementation to generate a partitioning
% n   = size(A,1);
% map = zeros(n,1);
% map(1:round((n/2)))     = 0; 
% map((round((n/2))+1):n) = 1;
% 
% 
% [part1,part2] = other(map);

if picture == 1
    gplotpart(A,xy,part1);
    title('Inertial bisection using the Fiedler Eigenvector');
end

% Dummy implementation to generate a partitioning >>>>

end
