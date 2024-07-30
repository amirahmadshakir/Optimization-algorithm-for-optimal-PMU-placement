# Optimization-algorithm-for-optimal-PMU-placement
This repository contains the MATLAB files of optimization algorithms for optimal PMU placement.
The original files were obtained from this repository: https://github.com/xupei0610/OPP

The files included are:
4 IEEE test cases - 14, 30, 57, 118-bus test case
1 case study of Utilities Kerteh distribution level power system network
1 limited PMU channel algorithm - mixed integer linear programming (MILP),
7 unlimited PMU channel algorithms - MILP, depth first search (DFS), graphic theoretic procedure using merger method (GThM),
graphic theoretic procedure using nonlinear method (GThN), Simulated Annealing (SA), modified Simulated Annealing (SAB),
recursive security N (RSN)

To run the MILP program, simply open either MILP_limited or MILP_unlimited file.
For other algorithms, open the main_unlimitedCase file to run the program.
The UKbus.png file outlines the case study bus data used in this program.

Included also the output obtained from the algorithms ran on MATLAB R2023b with machine specifications:
Intel Core i7 @ 2.60GHz CPU
16GB SODIMM RAM
SATA HDD with upto 160MB/s write speed
(Lenovo Legion Y540-15IRH)
