# ECE 552 Project: Dynamic Branch Prediction Comparison
Contributors: Stephen Hughes, Yitaek Hwang

## Abstract
Branch prediction is critical to the overall performance of any pipelined processor. Mispredicted branches will flush the subsequent instructions from the pipeline while the correct branch target is fetched. In this paper, we discuss various dynamic branch prediction techniques. Dynamic implementations use branch history behavior collected from the program at runtime in order to predict later branches. We first introduce Yeh and Patt’s two level branch prediction scheme, discuss its various configurations, and analyze the overall performance through a preexisting simoutorder implementation. Next, we introduce and implement (through simoutorder) the perceptron and piecewise linear based schemes. In forming an overall comparison between these three predictors, it is necessary to consider practical hardware constraints. For each scheme, we analyze the percentage of mispredicted branches as a function of the hardware budget. In doing so, we hope to gain a better understanding into the arguments for and against different branch prediction mechanisms.

## File Structure
- Data: txt files used for the simulations
- Graphs: MATLAB generated graphs for analysis
- SimulationOutput: Output csv files from the simulation
- src: Java, C, and MATLAB code used for simulations
- FinalProjectReport.pdf
