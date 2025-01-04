# Analyzing the role of DSO in electricity trading of VPPs

This code solves a **Stackelbergn game via a bilevel optimization model**. Two approaches to solving this problem are included:


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
- Step 1: How to install [Julia in VsCode](https://code.visualstudio.com/docs/languages/julia)
- Step 2: In the comments of this program, there are necessary package installation instructions, just copy and paste.
- Step 3: Run the program.


----

If you find something helpful or use this code for your own work, please cite this paper:
<ol> 
    Now "under review".
</ol>  
