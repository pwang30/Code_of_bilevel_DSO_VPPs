# Analyzing the role of DSO in electricity trading of VPPs

This code solves a **Stackelberg game via a bilevel optimization model**.

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
- Step 2: In the comments of the code, there are necessary package installation instructions, you just need to copy and paste them to your own code.
- Step 3: Run the program.

**Note that this work can be easily extended to larger-scale problems because of the structural independence of each agent, such as those involving more
aggregators and DER, and market mechanisms (demand response, time-of-use tariff, etc.).**

----

If you find something helpful or use this code for your own work, please cite this paper:
<ol>
     P. Wang, X. Zhang and L. Badesa, "Analyzing the Role of the DSO in Electricity Trading of VPPs via a Stackelberg Game Model," 2025 IEEE Kiel PowerTech, Kiel, Germany, 2025, pp. 1-6, doi: 10.1109/PowerTech59965.2025.11180491.
</ol>
      <br>
      
<ol> 
@INPROCEEDINGS{11180491, <br>
  author={Wang, Peng and Zhang, Xi and Badesa, Luis}, <br>
  booktitle={2025 IEEE Kiel PowerTech}, <br>
  title={Analyzing the Role of the DSO in Electricity Trading of VPPs via a Stackelberg Game Model}, <br>
  year={2025},<br>
  volume={},<br>
  number={},<br>
  pages={1-6},<br>
  keywords={Costs;Profitability;Games;Virtual power plants;Electricity supply industry;Market research;Power markets;Regulation;Stakeholders;Optimization;Electricity market;bilevel optimization;virtual power plants;distribution system operator},<br>
  doi={10.1109/PowerTech59965.2025.11180491}}<br>
</ol>  

----

This work was supported by MICIU/AEI/10.13039/501100011033 and ERDF/EU under grant PID2023-150401OA-C22, as well as by the Madrid Government (Comunidad de Madrid-Spain) under the Multiannual Agreement 2023-2026 with Universidad Politécnica de Madrid, ``Line A - Emerging PIs''. The work of Peng Wang was also supported by China Scholarship Council under grant 202408500065.

<figure style="display:inline-block; margin:10px; text-align:center;">
   <img src="./logos/MICIU+Cofinanciado+AEI.jpg" style="width:600px; height:140px; object-fit:contain; display:block;">
</figure>
<figure style="display:inline-block; margin:10px; text-align:center;">
   <img src="./logos/Logo_CM.png" style="width:200px; height:160px; object-fit:contain; display:block;">
</figure>
