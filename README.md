# engine-build

Thermal network modeling tools for liquid rocket engine nozzles.

!!! Under Construction !!!

## Where does the heat come from? Where does it go?
The structural matter of a thrust chamber assembly (TCA) will have some maximum total heat capacity bounded by a melting temperature, or a temperature above/below which the material properties of the TCA are unnaceptable.

The propellants enter the TCA vaporized or as close to saturation temperature as is desirable for your injector design. Chemical potential energy is converted to the kinetic/vibrational energy of reacting particles. They'll do two things to echange heat with your thrust chamber. First, they'll smack into the wall. Second, dipoles will emit radiation, some of which the TCA will absorb. Once all this energy is transfered to the TCA, we must figure out how to get rid of it quickly. We can dump it into a coolant or radiate it outwards. Additionally, we can place coolant or ablators between the chamber wall and combustion gas to eat much of this energy up front.

## @engine TODOs
* Nozzle design toos
  * Expand options for nozzle sizing parameterization
  * Write parabolic contour generation method
  * Rao contour generation method
  * Contour .dxf import/export methods
 
## @thermal_network TODOs
* Fluid/material libraries
  * Add LNG to temp-dependent transport properties library
  * Extend Inco 625 material model to cryo ranges
  * Need 316 SS model
* Physics models
  * Total system energy tracking, power/efficiency calcs, etc.
  * Ablation physics (low priority)
  * Film cooling
    * Update Grisson's emissivity function
    * Finish space marching routine
    * Write post-evaporation entrainment physics
* Solver 
  * Test cases for finite differencing functions
  * Better Von-Neumann stability checks for explicit method
  * Crank-Nickelson or other explicit-implicit methdos? 2nd-order Lax-Wendroff?


