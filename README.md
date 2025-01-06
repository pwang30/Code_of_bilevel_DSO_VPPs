# Analyzing the role of DSO in electricity trading of VPPs

This code solves a **Stackelberg game via a bilevel optimization model**. Two approaches to solving this problem are included:


The main elements of this work include:
- [Stackelberg game](https://en.wikipedia.org/wiki/Stackelberg_competition)
- [Bilevel model](https://en.wikipedia.org/wiki/Bilevel_optimization)
- [Big-M method](https://en.wikipedia.org/wiki/Big_M_method)
- [Karush–Kuhn–Tucker conditions](https://en.wikipedia.org/wiki/Karush%E2%80%93Kuhn%E2%80%93Tucker_conditions)
- [Distribution system operator (DSO)](https://www.camus.energy/blog/what-is-a-distribution-system-operator)
- [Virtual power plant (VPP)](https://en.wikipedia.org/wiki/Virtual_power_plant)
- [Julia programming](https://julialang.org/)


The main work includes:
- Model building and solving: In the Bilevel model, DSO maximizes profits in the upper level, which requires the Big-M method to build its model. VPPs take the prices set by DSO and minimize their respective operating costs in the lower level, and they are converted into KKT conditions for further solution. DSO and VPPs are in a Stackelberg game relationship.
- Transaction behavior analysis: The selfish transaction behaviors of DSO and VPPs are analyzed, which highlight the role of DSO in trading. Their respective profits or costs have been improved, and the explicit benefits of non-strategic player have been compromised, but the overall (whole system or market) benefits are reserved, only the distribution of benefits has changed.


The following is the program running process (assuming it is in Visual Studio Code):
- Step 1: How to install [Julia in VsCode](https://code.visualstudio.com/docs/languages/julia).
- Step 2: In the comments of this program, there are necessary package installation instructions, just copy and paste.
- Step 3: Run the program.

**Note that this work can be easily extended to larger-scale problems due to the independence of each VPP, such as those involving more
aggregators and DER, and market mechanisms (demand response, time-of-use tariff, etc.).**

----

**Discussion on the solving time and optimality**

When solving the bilevel model (MINLP, convex lower level, non-convex upper level due to the binary variables in ‘big-M’ method), we encountered the problem of slow convergence of the duality gap [(this challenge can be effectively solved)](https://ieeexplore.ieee.org/abstract/document/8107289). In this extremely time-consuming process, we found that the solution when gap equals 2.59% was no more explanatory than the solution with a gap of 2.81%. Due to limited computer memory (simulations were carried out on
a MacBook Air-M1, 2020), the solution with a gap equal to 2.59% was used for the case study, which is still better than the solution of Mode 1 (without binary variables, the upper
and lower levels are both convex, duality gap = 0, the solution time is 0.05s), is further capable of proving the above results and analysis.

----

If you find something helpful or use this code for your own work, please cite this paper:
<ol> 
    P. Wang, X. Zhang, and L. Badesa, "Analyzing the Role of the DSO in Electricity Trading of VPPs via a Stackelberg Game Model," 16th IEEE PowerTech 2025, under review.
</ol>  
