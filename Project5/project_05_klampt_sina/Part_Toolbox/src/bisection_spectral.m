function [part1,part2] = bisection_spectral(A,xy,picture)

n = size(A, 1);
map = zeros(n, 1);
diagonal = sum(A, 1);
D = diag(diagonal);
L = D - A;

[V, Diag] = eigs(L, 2, 'smallestabs');

eigenvalues = diag(Diag);
lam2 = eigenvalues(2);
v2 = V(:, 2);

M = median(v2);

for i = 1:n
    if v2(i) < M
        map(i) = 1;
    end
end
[part1, part2] = other(map);

% bisection_spectral : Spectral partition of a graph.
%
% [part1,part2] = bisection_spectral(A) returns a partition of the n vertices
%                 of A into two lists part1 and part2 according to the
%                 spectral bisection algorithm of Simon et al:
%                 Label the vertices with the components of the Fiedler vector
%                 (the second eigenvector of the Laplacian matrix) and partition
%                 them around the median value or 0.



disp(' ');
disp(' HPC Lab for CSE at ETH:   ');
disp(' Implement spectral bisection');
disp(' ');


% Steps
% 1. Construct the Laplacian.
% 2. Calculate its eigensdecomposition.
% 3. Label the vertices with the components of the Fiedler vector.
% 4. Partition them around their median value, or 0.




% <<<< Dummy implementation to generate a partitioning
% n = size(A,1);
% map = zeros(n,1);
% map(1:round((n/2))) = 0;
% map((round((n/2))+1):n) = 1;
% [part1,part2] = other(map);

if picture == 1
    gplotpart(A,xy,part1);
    title('Spectral bisection using the Fiedler Eigenvector');
end

% Dummy implementation to generate a partitioning >>>>


end
