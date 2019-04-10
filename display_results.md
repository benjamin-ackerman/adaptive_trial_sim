Maximizing power and minimizing treatment failures in clinical trials
================
Benjamin Ackerman
April 9, 2019

This document contains the results from a simulation I conducted to replicate the simulation findings in Rosenberger & Hu (2004).

Table 3:
--------

##### Simulated expected treatment failures (standard deviation) for complete randomization and the doubly-adaptive biased coin design with *γ* = 2, 10,000 replications

|  *p*<sub>*A*</sub>|  *p*<sub>*B*</sub>|   *n*| Complete  | *γ* = 2   |
|------------------:|------------------:|-----:|:----------|:----------|
|                0.9|                0.3|    24| 10 (2.4)  | 7 (2.4)   |
|                0.9|                0.5|    50| 16 (3.2)  | 13 (2.9)  |
|                0.9|                0.7|   162| 33 (5.1)  | 32 (4.8)  |
|                0.9|                0.8|   532| 80 (8.2)  | 79 (8.1)  |
|                0.7|                0.3|    62| 31 (3.9)  | 28 (4.2)  |
|                0.7|                0.5|   248| 100 (7.7) | 97 (7.6)  |
|                0.5|                0.4|  1036| 570 (16)  | 567 (17)  |
|                0.3|                0.1|   158| 127 (5)   | 119 (8.6) |
|                0.2|                0.1|   532| 453 (8.3) | 443 (18)  |

Table 4:
--------

##### Simulated maximum number of treatment failures for complete randomization and the doubly-adaptive biased coin design (DCBD) with *γ* = 2, 10,000 replications

|  *p*<sub>*A*</sub>|  *p*<sub>*B*</sub>|   *n*|  Complete|  DBCD|
|------------------:|------------------:|-----:|---------:|-----:|
|                0.9|                0.3|    24|        18|    17|
|                0.9|                0.5|    50|        28|    27|
|                0.9|                0.7|   162|        54|    51|
|                0.9|                0.8|   532|       112|   117|
|                0.7|                0.3|    62|        45|    45|
|                0.7|                0.5|   248|       129|   126|
|                0.5|                0.4|  1036|       625|   661|
|                0.3|                0.1|   158|       144|   152|
|                0.2|                0.1|   532|       480|   499|
