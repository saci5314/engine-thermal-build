function Nu = nusselt_forced(coolant, Re_cool, Pr_cool, T_wc, T_c)
%{ 
This function finds local Nusselt numbers (ratio of total to convective 
heat transfer at a fluid boundary) for the case of forced convection with 
a transpirational/regenerative coolant.

Author:
    Samuel Ciesielski

Sources:
    [1] "Thermal Analysis of Thrust Chamebrs"...

Inputs:
    coolant = name of coolant (string)
    Re_cool = local coolant Reynold's numbers 
    Pr_cool = local coolant Prantl numbers 
    T_wc =  local cold wall temps [K]
    T_c = local coolant temps [K]

Sources:
    [1] Ponomarenko, A., "Thermal Analysis of Thrust Chambers", RPA: Tool
        for Rocket Propulsion Analyis. https://www.rocket-propulsion.com/d
        ownloads/pub/RPA_ThermalAnalysis.pdf.
%}
    
    if coolant == "Kerosene"
        Nu = .021 * Re_cool.^.8 .* Pr_cool.^.4 .* (.64 + .36*(T_c./T_wc));
    
    elseif coolant == "LCH4"
        Nu = .0185 * Re_cool.^.8 .* Pr_cool.^.4 .* (T_c./T_wc).^.1;
    
    elseif coolant == "LH2"
        Nu = .033 * Re_cool.^.8 .* Pr_cool.^.4 .* (T_c./T_wc).^.57;
    
    else            
        Nu = .023 * Re_cool.^.8 .* Pr_cool.^.4;
    
    end

end