function mpc = caseUtilitiesKerteh
%CASEUK   Power flow data for Utility Kerteh - Distribution level
% The purpose of this power system case data is for optimal PMU placement
% formulation which only concerns the connection of each bus in the power
% system. 
% 
% The data is extracted from the Utility Kerteh distribution level
% power system single line diagram and incompleteness of bus data is
% expected. This case data is formatted by referring to the MATPOWER Case
% Format : Version 2
% 
% The bus numbering convention is done to assist in the OPP formulation and
% is not the indication of the real bus number & data as the real system.
% The numbering convention can be viewed at the SLD annotation png file
% attached together with this file. 
% 
% References:
% [1]   Ahmed Amirul Arefin, Khairul Nisak Binti Md Hasan. A PMU-Based 
%       Island Detection Technique Validated by a Real-Case Study of a 
%       Distribution System in Malaysia. Authorea. November 23, 2023.
%       DOI: 10.22541/au.170074074.49352690/v1

%% MATPOWER Case Format : Version 2
mpc.version = '2';

%%-----  Power Flow Data  -----%%
%% system MVA base
% mpc.baseMVA = 100;

%% bus data
%	bus_i	type	Pd	Qd	Gs	Bs	area	Vm	Va	baseKV	zone	Vmax	Vmin
mpc.bus = [
	1	0	0	0	0	0	0	0	0	0	0	0   0;
	2	0	0	0	0	0	0	0	0	0	0	0   0;
	3	0	0	0	0	0	0	0	0	0	0	0   0;
	4	0	0	0	0	0	0	0	0	0	0	0   0;
	5	0	0	0	0	0	0	0	0	0	0	0   0;
	6	0	0	0	0	0	0	0	0	0	0	0   0;
	7	0	0	0	0	0	0	0	0	0	0	0   0;
	8	0	0	0	0	0	0	0	0	0	0	0   0;
	9	0	0	0	0	0	0	0	0	0	0	0   0;
	10	0	0	0	0	0	0	0	0	0	0	0   0;
	11	0	0	0	0	0	0	0	0	0	0	0   0;
	12	0	0	0	0	0	0	0	0	0	0	0   0;
	13	0	0	0	0	0	0	0	0	0	0	0   0;
	14	0	0	0	0	0	0	0	0	0	0	0   0;
	15	0	0	0	0	0	0	0	0	0	0	0   0;
	16	0	0	0	0	0	0	0	0	0	0	0   0;
];
% 0 denotes incomplete data as '-' cannot be used in working code
%% generator data
%	bus	Pg	Qg	Qmax	Qmin	Vg	mBase	status	Pmax	Pmin	Pc1	Pc2	Qc1min	Qc1max	Qc2min	Qc2max	ramp_agc	ramp_10	ramp_30	ramp_q	apf
mpc.gen = [
	1	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0;
	6	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0;
	8	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0;
	9	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0;
	10	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0;
	14	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0;
	15	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0;
];
% 0 denotes incomplete data as '-' cannot be used in working code
%% branch data
%	fbus	tbus	r	x	b	rateA	rateB	rateC	ratio	angle	status	angmin	angmax
mpc.branch = [
	1	2	0	0	0	0	0	0	0	0	0	0	0;
	1	4	0	0	0	0	0	0	0	0	0	0	0;
	2	3	0	0	0	0	0	0	0	0	0	0	0;
	3	4	0	0	0	0	0	0	0	0	0	0	0;
	4	5	0	0	0	0	0	0	0	0	0	0	0;
	5	6	0	0	0	0	0	0	0	0	0	0	0;
	5	7	0	0	0	0	0	0	0	0	0	0	0;
	5	13	0	0	0	0	0	0	0	0	0	0	0;
	7	8	0	0	0	0	0	0	0	0	0	0	0;
	7	9	0	0	0	0	0	0	0	0	0	0	0;
	7	10	0	0	0	0	0	0	0	0	0	0	0;
	7	11	0	0	0	0	0	0	0	0	0	0	0;
	7	12	0	0	0	0	0	0	0	0	0	0	0;
	7	13	0	0	0	0	0	0	0	0	0	0	0;
	13	14	0	0	0	0	0	0	0	0	0	0	0;
	13	15	0	0	0	0	0	0	0	0	0	0	0;
	13	16	0	0	0	0	0	0	0	0	0	0	0;
];
% 0 denotes incomplete data as '-' cannot be used in working code

%%-----  OPF Data  -----%%
%% generator cost data
%	1	startup	shutdown	n	x1	y1	...	xn	yn
%	2	startup	shutdown	n	c(n-1)	...	c0
% mpc.gencost = [
% 	1	-	-	-	-	-	-;
% 	6	-	-	-	-	-	-;
% 	8	-	-	-	-	-	-;
% 	9	-	-	-	-	-	-;
% 	10	-	-	-	-	-	-;
% 	14	-	-	-	-	-	-;
% 	15	-	-	-	-	-	-;
% ];