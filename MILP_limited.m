clc; clear all;

%% Obtain user input
disp("Select a test case.");
disp("1. IEEE 14-Bus Test Case System");
disp("2. IEEE 30-Bus Test Case System");
disp('3. IEEE 57-Bus Test Case System');
disp('4. IEEE 118-Bus Test Case System');
disp('5. Utilities Kerteh Distribution Level Test Case System');
userInput = input("\nSelect 1, 2, 3, 4, or 5: ");

if userInput == 1
    testCase = case14();
    selection = 'IEEE 14-Bus Test Case System';
elseif userInput == 2
    testCase = case30();
    selection = 'IEEE 30-Bus Test Case System';
elseif userInput == 3
    testCase = case57();
    selection = 'IEEE 57-Bus Test Case System';
elseif userInput == 4
    testCase = case118();
    selection = 'IEEE 118-Bus Test Case System';
elseif userInput == 5
    testCase = caseUtilitiesKerteh();
    selection = 'Utilities Kerteh Distribution Level Test Case System';
end

fprintf('Selection: %s\n', selection)
PMUlimit = input("\nPlease choose PMU channel capacity limit: ");

%% Time start
MILP_timer = tic;

%% Constructing adjacent matrix
[num_buses, ~] = size(testCase.bus); %num rows corresponds to num of bus
[num_branch, ~] = size(testCase.branch); %num rows corresponds to num of branch

A_matrix = zeros(num_buses, num_buses); %create empty adjacent matrix

%filling the off-diagonal elements
for i = 1:num_branch
    A_matrix(testCase.branch(i, 1), testCase.branch(i, 2)) = 1; %FROM --> TO bus
    A_matrix(testCase.branch(i, 2), testCase.branch(i, 1)) = 1; %TO --> FROM bus
    %the FROM and TO bus numbers are taken as coord for A matrix; = 1 is set
    %to indicate connection between the two bus
end
%in branch section, 1st colummn shows the FROM bus while 2nd column shows
%TO bus; off-diagonal elements mirrored on diagonal axis

%filling the diagonal elements
for i = 1:num_buses
    A_matrix(i, i) = 1;
end

A_matrix_sparse = sparse(A_matrix);

%% Modified adjacency matrix
A_modified_sparse_wBusData = sparse([]);

for i = 1 : num_buses
    if sum(A_matrix(:, i)) < PMUlimit %self bus also uses one PMU channel
        nz = find(A_matrix(:, i)); %extract the non-zero of i-th column into nz
        temp = zeros(1, num_buses + 1); %create 1-by-num_buses+1 zero matrix 
        temp(1, nz) = 1; %puts 1 at all nz-th column element
        temp(1, num_buses + 1) = i; %see what bus the row belongs to
        A_modified_sparse_wBusData = sparse([A_modified_sparse_wBusData; temp]);
    else
        nz = nchoosek(find(A_matrix(:, i)), PMUlimit);
        [a, b] = size(nz);
        temp = zeros(a, num_buses + 1); %create a-by-num_buses+1 zero matrix 
        for j = 1 : a
            for k = 1 : b
                temp(j, i) = 1;
                temp(j, nz(j, k)) = 1;
                temp(j, num_buses + 1) = i; %see what bus the row belongs to
            end
        end
        A_modified_sparse_wBusData = sparse([A_modified_sparse_wBusData; temp]);
    end
    %fprintf('Bus %d\n', i)
end
A_modified_wBusData = full(A_modified_sparse_wBusData);

%% Separate A matrix and row data
[num_rows, tempCol] = size(A_modified_wBusData); %num column corresponds to num of bus (modifiedA)
num_buses = tempCol - 1; %last column contain bus no. corresponding to each row

busData = [A_modified_wBusData(:, tempCol)];
%busData stores the bus which corresponds to each row

A_modified  = A_modified_wBusData;
A_modified(:, tempCol) = [];
%A_modified now exclude the last column which contain bus data of each row

%% Obtain connections of bus in each row
connections = zeros(num_rows, PMUlimit + 1);

for i = 1:num_rows
    [~, nz_col] = find(A_modified(i, :));
    %nz_col will contain all the bus connected to each row
    for j = 1:length(nz_col)
        connections(i,j) = nz_col(j);
        %connections will store the connection data of bus in each row
    end
end

%% Mixed integer linear programming algorithm
%number of  rows
n = size(A_modified, 1);

% Define the cost vector w
w = ones(n, 1);

% Define the U vector
%same size as the number of bus
U = ones(size(A_modified, 2), 1);

% Define the optimization problem
f = w;  % Objective function coefficients
intcon = 1:n;  % Indices of integer variables
A = -A_modified.';  % Coefficient matrix for inequalities
b = -U;  % Right-hand side vector for inequalities

% Solve the integer linear programming problem
options = optimoptions('intlinprog', 'Display', 'off');  % Suppress output
[x, fval, exitflag, output] = intlinprog(f, intcon, A, b, [], [], zeros(n, 1), ones(n, 1), options);

%% Obtaining PMU placement on bus
[placement_row, ~] =  find(x);
PMU_bus = busData(placement_row);
%PMU_bus extracts the bus number stored in busData where a PMU is installed
%of which the data is stored in placement_row

%% Time stop
time = toc(MILP_timer);

%% Display results
% diary('output_MILPlimited.txt'); %saves output to external file

fprintf('\n=================================================================\n')
fprintf('Status: %s', output.message);
fprintf('\nOptimal PMU placement: \n%s\n', mat2str(x'));

fprintf('\nTest case: %s', selection);
fprintf('\nLimited PMU channel capacity; Channel limit: %d', PMUlimit);
fprintf('\nMinimum number of PMU: %.0f', fval); %suppress exponential output
fprintf('\nTime taken: %f\n', time);
fprintf('\nPMU location (connections):\n');

for i = 1:length(PMU_bus)
    fprintf('Bus %d ( ', PMU_bus(i));
    %displaying the bus which a PMU is located

    for j = 1:(PMUlimit + 1)
        chcknz = connections(placement_row(i), j);
        %placement_row contains the row of modifiedA where the PMU is
        %installed, chcknz extracts the bus connection stored in
        %connections and then displayed it below
        if chcknz ~= 0
            fprintf('%d ', chcknz);
        end
    end
    fprintf(')\n');
end
fprintf('\n=================================================================\n')

% diary off; %stop saving output
% open('output_MILPlimited.txt')
