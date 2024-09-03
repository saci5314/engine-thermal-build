# engine-build
Liquid bipropellant rocket engine design tools and and thermal network modeling.

All models are wrong. At least this model is fun. Here is some shitty data that is wrong but looks pleasant:
<img width="1256" alt="PNG image" src="https://github.com/user-attachments/assets/dd5a3ed7-0073-4184-9f5d-179a5f1115bb">

## Design Tools
The "engine" object contains a bunch of methods for performing high-level isentropic sizing, combustion gas property calcs, and chamber/nozzle contour design.

## Simulation Suite
The "thermal_network" object is a suite for simulating heat transfer in your TCA via a convection-diffusion eqn solver. Regenerative, film, ablative, and radiative cooling design inputs are implemented as nonlinear boundary conditions. There are a few on-board temperature-dependent property libraries for structural materials and coolants.

The model is "1.5D", which is to say each phenomenon is differenced in 1D orthogonal to eachother. Heat is diffused *only radially* through your chamber wall and is advected *only axially* along the direction of coolant mass flow. Convective heat transfer (boundary conduction, not mass trasnport) is treated by additional volumetric source terms.

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




