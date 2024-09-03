# engine-build
Liquid bipropellant rocket engine design tools and and thermal network modeling.

To get started, clone the repository into your desired filepath. See engine_build.m as a template for how to design and simulate an engine.

All models are wrong. This one is fun. 

## Design Tools
The "engine" object contains a bunch of methods for performing high-level isentropic sizing, combustion gas property calcs, and chamber/nozzle contour design.

## Simulation Suite
The "thermal_network" object is a suite for simulating heat transfer in your TCA via a convection-diffusion eqn solver. Regenerative, film, ablative, and radiative cooling design inputs are implemented as nonlinear boundary conditions. There are a few on-board temperature-dependent property libraries for structural materials and coolants.

The model is "1.5D", which is to say that heat is diffused *only radially* through your chamber wall and is advected *only axially* along the direction of coolant flow.

## TODOs

### @engine
* Chemical equilibrium calcs (Timmy?)
  * Compile thermochemical data of relevant species for kerolox/methalox
  * Write rootfinding scheme
  * Write test cases
* Nozzle design tooling (Andrew?)
  * Add ability to parameterize by chamber diameter by contraction ratio
  * Write parabolic contour generation method
  * Wtite rao contour generation method
  * Write contour .dxf import/export methods
 
### @steady_state_thermal
* Material models
  * Extend Jet-A model to multiphase for film cooling (Kenny?)
  * Add Multiphase LNG or LCH4 model (Kenny?)
  * Add SS 304L model
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




