%
% Run Me for single test
%
clc; clear all;
%%
disp('Which Test Case do you want to use?');
disp('1. IEEE 14-bus');
disp('2. IEEE 30-bus');
disp('3. IEEE 57-bus');
disp('4. IEEE 118-bus');
disp('5. Utilities Kerteh Distribution Level Test Case System');
while true
    userInput = input('Please input 1, 2, 3, 4, or 5: ');
    if userInput == 1
        data = case14();
        test_case = 'IEEE 14-bus System';
        break;
    elseif userInput == 2
        data = case30();
        test_case = 'IEEE 30-bus System';
        break;
    elseif userInput == 3
        data = case57();
        test_case = 'IEEE 57-bus System';
        break;
    elseif userInput == 4
        data = case118();
        test_case = 'IEEE 118-bus System';
        break;
    elseif userInput == 5
        data = caseUtilitiesKerteh();
        test_case = 'Utilities Kerteh Distribution Level Test Case System';
        break;
    end
end
fprintf('\n')
disp('Which Algorithm do you want to use?');
disp('1. Depth First Search');
disp('2. Graphic Theoretic Procedure using Merger Method');
disp('3. Graphic Theoretic Procedure using Nonlinear Constraint Function Method');
disp('4. Original Simulated Annealing Method');
disp('5. Modified Simulated Annealing Method');
disp('6. Recursive Security N Algorithm');
while true
    userInput = input('Please input 1, 2, 3, 4, 5 or 6: ');
    if userInput == 1
        alg = 'DFS';
        break;
    elseif userInput == 2
        alg = 'GThM';
        break;
    elseif userInput == 3
        alg = 'GThN';
        break;
    elseif userInput == 4
        alg = 'SA';
        break;
    elseif userInput == 5
        alg = 'SAB';
        break;
    elseif userInput == 6
        alg = 'RSN';
        break;
    end
end

%% Load case

% The number of buses in the system
[num_buses, ~] = size(data.bus);

% Construct A matrix
% This is not the admittance matrix but the adjacent matrix where the
% diagonal elements are all 1.
[branch_len, ~] = size(data.branch);
r1 = zeros(branch_len, 1);
r2 = r1; c1 = r1; c2 = r2; v1 = r1; v2 = r2;
for i=1:1:branch_len
    r1(i) = data.branch(i, 1);
    c1(i) = data.branch(i, 2);
    v1(i) = 1;
    r2(i) = data.branch(i, 2);
    c2(i) = data.branch(i, 1);
    v2(i) = 1;
end
diag_vector = transpose(1:1:num_buses);
r = [r1; r2; diag_vector];
c = [c1; c2; diag_vector];
v = [v1; v2; diag(eye(num_buses, num_buses))];
A_sparse = sparse(r, c, v, num_buses, num_buses);
A = full(A_sparse);
%clear r r1 r2 c c1 c2 v v1 v2 diag_vector branch_len i;

% Identify zero injection buses
ZI_buses = zeros(num_buses, 1);
% Find all buses with generators
gen_buses = data.gen(:, 1);
for i=1:1:num_buses
    % Find all buses with no load and no generator
    if data.bus(i, 3) == 0 && data.bus(i, 4) == 0 && ~any(gen_buses == i)
        ZI_buses(i) = i;
    end
end
ZI_buses = nonzeros(ZI_buses);
clear gen_buses;

%% Obtain connections of bus in each row
connections = zeros(num_buses, num_buses);
%unlimited channel only deals in square matrix

for i = 1:num_buses
    [~, nz_col] = find(A(i, :));
    %nz_col will contain all the bus connected to each row
    for j = 1:length(nz_col)
        connections(i,j) = nz_col(j);
        %connections will store the connection data of bus in each row
    end
end

%% Begin Solving the OPP
fprintf('\nSolver starts work...\n');

eval(sprintf('[p, m, x] = OPP_%s(A, ZI_buses);', alg));

diary('output_RSN.txt'); %saves output to external file
fprintf('\n=================================================================\n')
fprintf('Test Case: %s', test_case)
fprintf('\n=================================================================\n')
fprintf('Zero Injection Buses: ');
for i = 1:length(ZI_buses)
    fprintf('%d ', ZI_buses(i))
end

fprintf('\nMethod: %s', m.method);
fprintf('\nTime taken:%fs\n\n', m.time)

% %% Obtaining PMU placement on bus
% [PMU_bus, ~] =  find(x);
% %unlimited PMU channel only has square matrix

%% Display results
fprintf('Test case: %s', test_case);
fprintf('\nNo. of PMUs: %d\nPlacement (bus no.):\n', length(p));
for i=1:1:size(p,1)
    fprintf('  ')
    fprintf('%d ', p(i,:));
    fprintf('\n')
end

fprintf('\nPMU location (connections):\n');
if userInput == 6 %RSN has several solutions; this list the solutions
    [RSNrow, RSNcol] = size(p);
    for i = 1:RSNrow
        fprintf('Solution %d - ', i);
        for j = 1:RSNcol
            fprintf('Bus %d ( ', p(i, j));
            %displaying the bus which a PMU is located
            for k = 1:(num_buses)
                chcknz = connections(p(i, j), k);
                %PMU_bus stores the info where the PMU is installed, chcknz 
                %extracts the bus connection stored in connections and then 
                %displayed it below
                if chcknz ~= 0
                    fprintf('%d ', chcknz);
                end
            end
            fprintf(') ');
        end
        fprintf('\n');
    end
else
    for i = 1:length(p)
        fprintf('Bus %d ( ', p(i));
        %displaying the bus which a PMU is located
    
        for k = 1:(num_buses)
            chcknz = connections(p(i), k);
            %placement_row contains the row of modifiedA where the PMU is
            %installed, chcknz extracts the bus connection stored in
            %connections and then displayed it below
            if chcknz ~= 0
                fprintf('%d ', chcknz);
            end
        end
        fprintf(')\n');
    end
end
diary off; %stop saving output
%open('output_RSN.txt')
%clear p m alg [num_buses, column] = size(data.bus);

%% Clear global system variables
%clear data num_buses A ZI_buses;