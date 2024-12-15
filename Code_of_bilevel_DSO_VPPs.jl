# Analyzing the Role of DSO in Electricity Trading of VPPs via a Stackelberg Game Model
# Author: Peng Wang       from Technical University of Madrid (UPM)
# Supervisor: Luis Badesa
# This code is full. 
# 03.Dec.2024

#----------------------Pkgs introduction----------------
import Pkg 
using JuMP,BilevelJuMP,SCIP,XLSX
#----------------------define model----------------
model = BilevelModel(
   SCIP.Optimizer,
)


#----------------------related parameters input---------------
T=24
P_Wmax_1=[2,1.5,1.6,1.8,1.3,0.6,2.8,3.3,3.9,4,3.3,2.9,2.7,2,0.2,3.2,5.1,3.1,1.8,2,1.3,1,2,3.8]               # Wind_prediction-VPP1
load_1=[2.2,1.8,3,6,5.8,5.2,5.6,3.8,2.5,2.7,3,2.6,2.2,2.1,4.2,5.8,6.2,6.3,6.5,6.6,6.3,6.2,6,5.7]             # interruptible load-VPP1

P_Wmax_2=[4.7,5.1,4.3,4.1,3.8,3.9,4,5,5,4.8,3.9,4.3,5,5.2,5.8,5.6,1.6,0.9,5.8,4.1,3.6,3.5,3.1,3.8]     # Wind_prediction-VPP2
load_2=[5,4,4,4.2,4.1,3.6,3.4,3.7,3.9,3.8,3.9,4,4.1,4.2,3.7,3,5.1,6.1,5.8,6.2,6.3,5.5,5,3.8]           # interruptible load-VPP2

P_Wmax_3=[9.3,10.1,7.2,7.5,7.9,6.4,7.1,6.9,5.6,5.4,5.2,4,3.8,3,2.8,3.2,2.5,1.1,2.1,2.9,2.7,3,4.6,5.5]          # Wind_prediction-VPP3
load_3=[4,2.1,1.1,1.1,0.7,1,1.9,3.6,3.8,4.2,5.8,5.6,5.8,5.6,5.7,6.1,8,10,9.4,8.2,6.2,5.5,4.8,2.2]            # interruptible load-VPP3

λ_PMb= [0.4,0.4,0.4,0.4,0.4,0.4,0.4,0.75,0.75,0.75,0.75,1.2,1.2,1.2,0.75,0.75,0.75,0.75,1.2,1.2,1.2,1.2,0.4,0.4]   # energy prices: DSO buy energy from PM
λ_PMs= [0,0,0,0,0,0,0,0.35,0.35,0.35,0.35,0.5,0.5,0.5,0.35,0.35,0.35,0.35,0.5,0.5,0.5,0.5,0,0]                # energy prices: DSO sell energy to PM


λ_ES=[0.05,0.05,0.05]      # ES cost coefficients
#λ_IL=[1.4,1.4,1.4]        # IL cost coefficients
P_ES_max=[0.6,0.6,1.2]     # output bounds of ES
SOC_min=[0.2,0.2,0.2]     # min of SOC 
SOC_max=[0.9,0.9,0.9]      # max of SOC 
SOC_initial=[0.4,0.4,0.4]   # initial SOC
ES_capacity=[1,1,2]        # capacity of ES

a_MT=[0.08, 0.1,  0.15]    # MT cost coefficients
b_MT=[0.9,  0.6,  0.5]      # MT cost coefficients
c_MT=[1.2, 1, 0.8]        # MT cost coefficients
P_MT_max=[6,5,4]            # output bounds of MT
P_MT_dn=[-3.5, -3.0, -2]   # climbing down bound of MT
P_MT_up=[3.5, 3.0, 2]      # climbing up bound of MT

trade_max=[10,10,10]          # Set the maximum amount of electricity purchased and sold betwwen VPP and DSO to 10MW

M_1=30 #judgement 1
M_2=30 #judgement 2

#-------------------------body-------------

# definations and constraints of lower-level problem: VPPs energy management (VPP1)
@variable(Lower(model), 0<=P_MT_1[1:T]<=P_MT_max[1])                      # bounds for MT output
for i in 2:T
@constraint(Lower(model), P_MT_1[i]-P_MT_1[i-1]<=P_MT_up[1])  # bounds for MT climbing
end
for i in 2:T
    @constraint(Lower(model), P_MT_dn[1]<=P_MT_1[i]-P_MT_1[i-1])  # bounds for MT climbing
end

@variable(Lower(model), -P_ES_max[1]<=P_ES_1[1:T]<=P_ES_max[1])           # bounds for ES output
@variable(Lower(model), SOC_min[1]<=SOC_1[1:T]<=SOC_max[1])               # min and max of SOC 
@constraint(Lower(model), SOC_1[T]==SOC_initial[1])                          # the start and end of SOC must be the same
@constraint(Lower(model), SOC_1[1]==SOC_initial[1]-P_ES_1[1]/ES_capacity[1])              # 0-1 period of SoC, initial SOC is 0.4 here
for i in 2:T
@constraint(Lower(model), SOC_1[i]==SOC_1[i-1]-P_ES_1[i]/ES_capacity[1])               # bouns of SoC in 24 hours
end

#@variable(Lower(model), 0<=P_IL_1[i in 1:T]<=IL_portion[1]*load_1[i])                  # Upper and lower limit constraints of interruptible load

@variable(Lower(model),0<=P_W_1[i in 1:T]<=P_Wmax_1[i])                        # Wind turbine output upper and lower limits

@variable(Lower(model),0<=P_VPP_1_s[1:T]<=trade_max[1])  # % Set the maximum quantity of electricity traded between VPP and DSO to 10MW
@variable(Lower(model),0<=P_VPP_1_b[1:T]<=trade_max[1])  # % Set the maximum quantity of electricity traded between VPP and DSO to 10MW
@variable(Lower(model),P_VPP_1[1:T])
@constraint(Lower(model),P_VPP_1[1:T]==P_VPP_1_b-P_VPP_1_s)            # The quantity of electricity traded between VPP and DSO, positive(purchased), negative (sold)
@constraint(Lower(model),P_VPP_1+P_MT_1+P_ES_1+P_W_1==load_1)  # power balance constraint





# definations and constraints of lower-level problem: VPPs energy management (VPP2)
@variable(Lower(model), 0<=P_MT_2[1:T]<=P_MT_max[2])                      # bounds for MT output
for i in 2:T
@constraint(Lower(model), P_MT_2[i]-P_MT_2[i-1]<=P_MT_up[2])         # bounds for MT climbing
end
for i in 2:T
    @constraint(Lower(model), P_MT_dn[2]<=P_MT_2[i]-P_MT_2[i-1])  # bounds for MT climbing
end

@variable(Lower(model), -P_ES_max[2]<=P_ES_2[1:T]<=P_ES_max[2])           # bounds for ES output
@variable(Lower(model), SOC_min[2]<=SOC_2[1:T]<=SOC_max[2])               # min and max of SOC 
@constraint(Lower(model), SOC_2[T]==SOC_initial[2])                          # the start and end of SOC must be the same
@constraint(Lower(model), SOC_2[1]==SOC_initial[2]-P_ES_2[1]/ES_capacity[2])              # 0-1 period of SoC, initial SOC is 0.4 here
for i in 2:T
@constraint(Lower(model), SOC_2[i]==SOC_2[i-1]-P_ES_2[i]/ES_capacity[2])               # bouns of SoC in 24 hours
end

#@variable(Lower(model), 0<=P_IL_2[i in 1:T]<=IL_portion[2]*load_2[i])                  # Upper and lower limit constraints of interruptible load

@variable(Lower(model),0<=P_W_2[i in 1:T]<=P_Wmax_2[i])                        # Wind turbine output upper and lower limits

@variable(Lower(model),0<=P_VPP_2_s[1:T]<=trade_max[2])  # % Set the maximum quantity of electricity traded between VPP and DSO to 10MW
@variable(Lower(model),0<=P_VPP_2_b[1:T]<=trade_max[2])  # % Set the maximum quantity of electricity traded between VPP and DSO to 10MW
@variable(Lower(model),P_VPP_2[1:T])
@constraint(Lower(model),P_VPP_2[1:T]==P_VPP_2_b-P_VPP_2_s)            # The quantity of electricity traded between VPP and DSO, positive(purchased), negative (sold)
@constraint(Lower(model),P_VPP_2+P_MT_2+P_ES_2+P_W_2==load_2)  # power balance constraint



# definations and constraints of lower-level problem: VPPs energy management (VPP3)
@variable(Lower(model), 0<=P_MT_3[1:T]<=P_MT_max[3])                      # bounds for MT output
for i in 2:T
@constraint(Lower(model), P_MT_3[i]-P_MT_3[i-1]<=P_MT_up[3])         # bounds for MT climbing
end
for i in 2:T
    @constraint(Lower(model), P_MT_dn[3]<=P_MT_3[i]-P_MT_3[i-1])  # bounds for MT climbing
end

@variable(Lower(model), -P_ES_max[3]<=P_ES_3[1:T]<=P_ES_max[3])           # bounds for ES output
@variable(Lower(model), SOC_min[3]<=SOC_3[1:T]<=SOC_max[3])               # min and max of SOC 
@constraint(Lower(model), SOC_3[T]==SOC_initial[3])                          # the start and end of SOC must be the same
@constraint(Lower(model), SOC_3[1]==SOC_initial[3]-P_ES_3[1]/ES_capacity[3])              # 0-1 period of SoC, initial SOC is 0.4 here
for i in 2:T
@constraint(Lower(model), SOC_3[i]==SOC_3[i-1]-P_ES_3[i]/ES_capacity[3])               # bouns of SoC in 24 hours
end

#@variable(Lower(model), 0<=P_IL_3[i in 1:T]<=IL_portion[3]*load_3[i])                  # Upper and lower limit constraints of interruptible load

@variable(Lower(model),0<=P_W_3[i in 1:T]<=P_Wmax_3[i])                        # Wind turbine output upper and lower limits

@variable(Lower(model),0<=P_VPP_3_s[1:T]<=trade_max[3])  # % Set the maximum quantity of electricity traded between VPP and DSO to 10MW
@variable(Lower(model),0<=P_VPP_3_b[1:T]<=trade_max[3])  # % Set the maximum quantity of electricity traded between VPP and DSO to 10MW
@variable(Lower(model),P_VPP_3[1:T])
@constraint(Lower(model),P_VPP_3[1:T]==P_VPP_3_b-P_VPP_3_s)            # The quantity of electricity traded between VPP and DSO, positive(purchased), negative (sold)
@constraint(Lower(model),P_VPP_3+P_MT_3+P_ES_3+P_W_3==load_3)  # power balance constraint




# definations and constraints of lupper-level problem: max profits of DSO   (big-M representing the logical judgement)
#      let's double check the logical judgement, next we use big-M to rewrite it:
#      first, the upper-level obj has this judgement(here the time interval is only 1 hour, we dropped off the whole time domain: 24 hours):
#               P_DSO=sum(P_j_VPPb-P_j_VPPs)

#             if P_DSO>=0,   which means that DSO should buy energy from PM to support VPPs operation
#                then P_DSO,b=P_DSO
#             else if P_DSO<0                               （judgement 1）
#                then P_DSO,b=0

#             if P_DSO<0,   which means that DSO should sell energy to PM to support VPPs operation
#                then P_DSO,b=-P_DSO
#             else if P_DSO>0                                (judgement 2）
#                then P_DSO,s=0
@variable(Upper(model), P_DSO_b[1:T])   # P_DSO_b
@variable(Upper(model), P_DSO_s[1:T])   # P_DSO_s
@variable(Upper(model), λ_PMs[i]<=λ_VPPb[i in 1:T]<=λ_PMb[i])  # bounds for VPP buying energy from DSO
@variable(Upper(model), λ_PMs[i]<=λ_VPPs[i in 1:T]<=λ_PMb[i])  # bounds for VPP selling energy to DSO

@variable(Upper(model), N_1[1:T] ,Bin)   #judgement 1
@variable(Upper(model), N_2[1:T] ,Bin)   #judgement 2
@constraint(Upper(model),N_1-N_2==0)    # N_2 & N_1 must be the same

# big-M formulation of judgement 2
@constraint(Upper(model),P_VPP_1+P_VPP_2+P_VPP_3<=M_2*N_2)
@constraint(Upper(model),-M_2*(ones(1,T)'-N_2).<=P_VPP_1+P_VPP_2+P_VPP_3)
@constraint(Upper(model),-M_2*N_2.<=P_DSO_s+(P_VPP_1+P_VPP_2+P_VPP_3))
@constraint(Upper(model),P_DSO_s+(P_VPP_1+P_VPP_2+P_VPP_3).<=M_2*N_2)
@constraint(Upper(model),-M_2*(ones(1,T)'-N_2).<=P_DSO_s)
@constraint(Upper(model),P_DSO_s.<=M_2*(ones(1,T)'-N_2))

# big-M formulation of judgement 1
@constraint(Upper(model),P_VPP_1+P_VPP_2+P_VPP_3<=M_1*N_1)
@constraint(Upper(model),-M_1*(ones(1,T)'-N_1).<=P_VPP_1+P_VPP_2+P_VPP_3)
@constraint(Upper(model),-M_1*(ones(1,T)'-N_1).<=P_DSO_b-(P_VPP_1+P_VPP_2+P_VPP_3))
@constraint(Upper(model),P_DSO_b-(P_VPP_1+P_VPP_2+P_VPP_3).<=M_1*(ones(1,T)'-N_1))
@constraint(Upper(model),-M_1*N_1.<=P_DSO_b)
@constraint(Upper(model),P_DSO_b.<=M_1*N_1)

# objs of upper-level problems and lower-level problems
@objective(Upper(model), Max, sum(λ_PMs.*P_DSO_s-λ_PMb.*P_DSO_b) + sum(λ_VPPb.*(P_VPP_1_b+P_VPP_2_b+P_VPP_3_b))-sum(λ_VPPs.*(P_VPP_1_s+P_VPP_2_s+P_VPP_3_s)))

C_VPP1=sum(λ_VPPb.*P_VPP_1_b-λ_VPPs.*P_VPP_1_s)+
a_MT[1]*sum(P_MT_1.*P_MT_1)+b_MT[1]*sum(P_MT_1)+c_MT[1]+
λ_ES[1]*sum(P_ES_1.*P_ES_1)
#λ_IL[1]*sum(P_IL_1)

C_VPP2=sum(λ_VPPb.*P_VPP_2_b-λ_VPPs.*P_VPP_2_s)+
a_MT[2]*sum(P_MT_2.*P_MT_2)+b_MT[2]*sum(P_MT_2)+c_MT[2]+
λ_ES[2]*sum(P_ES_2.*P_ES_2)
#λ_IL[2]*sum(P_IL_2)

C_VPP3=sum(λ_VPPb.*P_VPP_3_b-λ_VPPs.*P_VPP_3_s)+
a_MT[3]*sum(P_MT_3.*P_MT_3)+b_MT[3]*sum(P_MT_3)+c_MT[3]+
λ_ES[3]*sum(P_ES_3.*P_ES_3)
#λ_IL[3]*sum(P_IL_3)

@objective(Lower(model), Min, C_VPP1+C_VPP2+C_VPP3)


#---------------------------solve the bi-level model-------------------
 BilevelJuMP. set_mode(model , BilevelJuMP. StrongDualityMode())
# set_optimizer(model , SCIP.Optimizer)
 set_attribute(model, "limits/gap", 0.0257)
# set_time_limit_sec(model, 700.0)
optimize!(model)



#----------------------------output and save the solutions------------------

XLSX.openxlsx("solutions of M=30_gamenoIL.xlsx", mode="w") do xf
    sheet = xf[1]
    XLSX.rename!(sheet, "M=30")  
 


    sheet["A1"]="P_MT_1"
    sheet[2,:] = JuMP.value.(P_MT_1)
    sheet["A3"]="P_MT_2"
    sheet[4,:] = JuMP.value.(P_MT_2)
    sheet["A5"]="P_MT_3"
    sheet[6,:] = JuMP.value.(P_MT_3)


    sheet["A7"]="P_ES_1"
    sheet[8,:] = JuMP.value.(P_ES_1)
    sheet["A9"]="P_ES_2"
    sheet[10,:] = JuMP.value.(P_ES_2)
    sheet["A11"]="P_ES_3"
    sheet[12,:] = JuMP.value.(P_ES_3)

    sheet["A13"]="SOC_1"
    sheet[14,:] = JuMP.value.(SOC_1)
    sheet["A15"]="SOC_2"
    sheet[16,:] = JuMP.value.(SOC_2)
    sheet["A17"]="SOC_3"
    sheet[18,:] = JuMP.value.(SOC_3)

    sheet["A19"]="P_W_1"
    sheet[20,:] = JuMP.value.(P_W_1)
    sheet["A21"]="P_W_2"
    sheet[22,:] = JuMP.value.(P_W_2)
    sheet["A23"]="P_W_3"
    sheet[24,:] = JuMP.value.(P_W_3)

    sheet["A25"]="P_VPP_1_s"
    sheet[26,:] = JuMP.value.(P_VPP_1_s)
    sheet["A27"]="P_VPP_2_s"
    sheet[28,:] = JuMP.value.(P_VPP_2_s)
    sheet["A29"]="P_VPP_3_s"
    sheet[30,:] = JuMP.value.(P_VPP_3_s)

    sheet["A31"]="P_VPP_1_b"
    sheet[32,:] = JuMP.value.(P_VPP_1_b)
    sheet["A33"]="P_VPP_2_b"
    sheet[34,:] = JuMP.value.(P_VPP_2_b)
    sheet["A35"]="P_VPP_3_b"
    sheet[36,:] = JuMP.value.(P_VPP_3_b)

    sheet["A37"]="P_VPP_1"
    sheet[38,:] = JuMP.value.(P_VPP_1)
    sheet["A39"]="P_VPP_2"
    sheet[40,:] = JuMP.value.(P_VPP_2)
    sheet["A41"]="P_VPP_3"
    sheet[42,:] = JuMP.value.(P_VPP_3)

    
    sheet["A43"]="obj of lower"
    sheet[44,1] = JuMP.value.(C_VPP1+C_VPP2+C_VPP3)

    sheet["A45"]="obj of VPP1"
    sheet[46,1] = JuMP.value.(C_VPP1)

    sheet["A47"]="obj of VPP2"
    sheet[48,1] = JuMP.value.(C_VPP2)

    sheet["A49"]="obj of VPP3"
    sheet[50,1] = JuMP.value.(C_VPP3)

    sheet["A51"]="λ_VPPb"
    sheet[52,1] = JuMP.value.(λ_VPPb)

    sheet["A53"]="λ_VPPs"
    sheet[54,1] = JuMP.value.(λ_VPPs)

    sheet["A55"]="obj of upper"
    sheet[56,1] = JuMP.value.(sum(λ_PMs.*P_DSO_s-λ_PMb.*P_DSO_b) + sum(λ_VPPb.*(P_VPP_1_b+P_VPP_2_b+P_VPP_3_b))-sum(λ_VPPs.*(P_VPP_1_s+P_VPP_2_s+P_VPP_3_s)))

end


