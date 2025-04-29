# engine-build

Thermal network modeling tools for supersonic nozzles w/ single-pass cooling.

*!!! Under Construction !!!*
Solver is currently unstable and is crying out for documentation. 

## @engine TODOs
* Nozzle design toos
  * Expand options for high-level sizing parameterization
  * Rao contour generation/method of characteristics
  * Contour .dxf import/export methods
 
## @thermal_network TODOs
* Fluid/material libraries
  * Add LNG to temp-dependent transport properties library
  * Extend Inco 625 material model to cryo ranges
  * Need SS model
* Physics models
  * Total system energy tracking, power/efficiency calcs, etc.
  * Film cooling
    * Update Grisson's emissivity function
    * Finish space marching routine
    * Write post-evaporation entrainment physics
* Solver 
  * Test cases for finite differencing functions
  * Better Von-Neumann stability checks for explicit integrator
  * Crank-Nickelson or other explicit-implicit methdos? 2nd-order Lax-Wendroff?


