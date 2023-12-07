% Simulate disease spreading on a 2D grid

% Set parameter values
N=100;              % Grid size (NxN)
beta=0.05;          % Infection rate
gamma=0.07;         % Immunity rate

% define grid
x = zeros(N, N);    % The grid x, is coded as:  0=Susceptible, 1=Infected, 2=Removed

% Set the initial grid, x with a circle of infected individuals in the
% center of the grid, and with a radius of 10 cells.
for i=1:N
    for j=1:N
        dx = i-N/2;
        dy = j-N/2;
        R = sqrt(dx*dx+dy*dy);
        if ( R<10 )
            x(i,j)=1;
        end
    end
end


% Define the Moore neighborhood, i.e. the 8 nearest neighbors
neigh = [-1 -1; 0 -1; 1 -1; 1 0; 1 1; 0 1; -1 1; -1 0];

% Create a new figure
figure

% main loop, iterating the time variable, t
for t=1:100000
 
    % iterate over all cells in grid x, for index i=1..N and j=1..N
    for i=1:N
        for j=1:N

            
            % Iterate over the neighbors and spread the disease
            for k=1:8
            
                i2 = i+neigh(k, 1);
                j2 = j+neigh(k, 2);
                % Check that the cell is within the grid boundaries
                if ( i2>=1 && j2>=1 && i2<=N && j2<=N )

%                     % add mobility, some people move to random location
%                     if rem(t,50) == 0
%                         i1 = ceil(rand*N);
%                         j1 = ceil(rand*N);
%                         i = i1;
%                         j = j1;
%                     end

                    % if cell is in state Susceptible and neighboring cell
                    % Infected => Spread infection with probability beta
                    if ( x(i,j)==0 && x(i2, j2)==1 )
                        if ( rand<beta )
                            x(i,j) = 1;
                        end
                    end
                end
            end


          
            
            % If infected => Recover from disease with probability gamma
            if ( x(i,j)==1 && rand<gamma )
                x(i,j) = 2;
            end            
            
        end
    end

    % Animate
    clf                                 % Clear figure
    imagesc(x, [0 2])                   % Display grid
    pause(0.01)                         % Pause for 0.01 s
    colormap([1 0 0; 0 1 0; 0 0 1]);    % Define colors: Red, Green, Blue
    
    % If no more infected => Stop the simulation
    if ( sum(x==1)==0 )
        break;
    end


end
