# Analyzing the role of DSO in electricity trading of VPPs

This code solves a **Stackelbergn game via a bilevel optimization model**. Two approaches to solving this problem are included:

- The typical approach using time-trajectories to model the uncertainty is included in folder "[trajectories](trajectories/)". For more info on this approach, check book "Decision Making Under Uncertainty in Electricity Markets" by Conejo et al.
- An alternative approach which models uncertainty through a scenario tree is included in folder "[scenario_tree](scenario_tree/)". This approach is inspired by [this paper](https://ieeexplore.ieee.org/document/6026941).

The optimisation problem is solved via the toolbox **YALMIP**, you can find instructions for how to install it [here](https://yalmip.github.io/tutorial/installation/). You will also need to install some external solver like Mosek or Gurobi, both of which have academic licenses available. Remember to also install the Matlab functionalities of that solver.

The main elements of this work include:
- [Stackelberg game](https://en.wikipedia.org/wiki/Stackelberg_competition)
- [Bilevel model](https://en.wikipedia.org/wiki/Bilevel_optimization)
- [Big-M method](https://en.wikipedia.org/wiki/Big_M_method)
- [Karush–Kuhn–Tucker conditions](https://en.wikipedia.org/wiki/Karush%E2%80%93Kuhn%E2%80%93Tucker_conditions)
- [Distribution system operator (DSO)](https://www.camus.energy/blog/what-is-a-distribution-system-operator)
- [Virtual power plant (VPP)](https://en.wikipedia.org/wiki/Virtual_power_plant#:~:text=A%20virtual%20power%20plant%20(VPP,aggregate%20and%20market%20their%20power)
- [Julia programming](https://julialang.org/)

The main work includes:
1. Model building and solving: In the two-layer model, DSO maximizes benefits in the upper layer, which requires the Big M method to build its model. VPPs minimize their respective operating costs in the lower layer, and they are converted into KKT conditions for further solution. DSO and VPPs are in a game relationship.

2. Transaction behavior analysis: The selfish transaction behavior of DSO and VPPs is analyzed, which highlights the role of DSO in transactions. Their respective profits or costs have been improved, and the displayed benefits of non-strategic players have been damaged, but the overall (whole system or market) benefits are balanced, only the distribution of benefits has changed.

The following is the program running process (assuming it is in Visual Studio Code)
Step 1: How to install Julia in VsCode (https://code.visualstudio.com/docs/languages/julia)
Step 2: In the comments of this program, there are necessary package installation instructions, just copy and paste.
Step 3: Run the program.


----

If you find something helpful or use this code for your own work, please cite this paper:
<ol> 
    Now "under review".
</ol>  
