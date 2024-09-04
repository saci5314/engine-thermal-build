# engine-build
Liquid bipropellant rocket engine design tools and and thermal network modeling.

All models are wrong. Fortunately, this model is fun. 

Here is some test data that is wrong but looks pleasant:
<img width="1256" alt="PNG image" src="https://github.com/user-attachments/assets/dd5a3ed7-0073-4184-9f5d-179a5f1115bb">

## Design Tools
The "engine" object contains a bunch of methods for performing high-level isentropic sizing calcs, combustion gas equilibrium property calcs, and nozzle contour design.

## Simulation Suite
The "thermal_network" object is a suite for simulating heat transfer in your TCA via a convection-diffusion IBVP. Regenerative, film, and radiative cooling design inputs are taken by the user and to form nonlinear boundary conditions. There are a few on-board temperature-dependent property libraries for structural materials and coolants.

The convection-diffusion problem is solved via an explicit, first-order in time (euler) scheme on a 2D grid. Though the probelm is really reduced to multple 1D finite differencing problems. Diffusion along the length of the chamber is considered negligible. It is only differenced in the radial direction. Advection (heat transport by mass transport) is the assumed mechanism for the the heat carried through the system by the steady flow of coolant. It only needs to be differenced along the length of the nozzle. Convective heat transfer and radiative heat transfer is treated by additional volumetric source terms in coolant and outer-most wall nodes.

## TODOs

### @engine
* Chemical equilibrium calcs (Timmy and/or Andrew?)
  * Compile thermochemical data of relevant species for kerolox/methalox
  * Write rootfinding scheme
  * Write test cases
* Nozzle design tooling
  * Add ability to parameterize by chamber diameter by contraction ratio (Sam)
  * Write parabolic contour generation method (Andrew)
  * Wtite rao contour generation method
  * Write contour .dxf import/export methods (Sam)
 
### @steady_state_thermal
* Material models
  * Extend Jet-A model to multiphase (l/g) for film cooling (Kenny?)
  * Add Multiphase (l/g) LNG or LCH4 model (Kenny?)
  * Add SS 304L material model
  * Add Inco 625 material model
* Physics models
  * Finish implementing film cooling physics (Sam)
    * Add option to use Grisson's model for emissivity (Sam)
    * Advection term finite differencing check (Sam)
  * Total system energy tracking (Sam)
  * Ablation physics (not critical)
* Solver 
  * Implement command-window output during simulaton
    * Elapsed time, simulated time, percent completion, etc.
  * Test cases for finite differencing functions (Sam)
  * Add stability criteria for explicit scheme (Sam)
  * Crank-Nickelson or other explicit-implicit methdos? 2nd-order Lax-Wendroff?




