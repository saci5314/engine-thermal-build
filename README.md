# engine-build
Liquid bipropellant rocket engine design tools and and thermal network modeling.

All models are wrong. This one is fun.

## How-to
See engine_build.m as a template for how to design and simulate an engine:

1. Clone the repository into your desired filepath and make a new script.
2. Create an "engine" object
3. Do all your gas property calcs, isentropic sizing, chamber contour design, etc. 
4. Create a "thermal_network" object and pass it your "engine" object
5. Configure your cooling system, mesh your nozzle, and see how toasty things get.

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
* Solver 
  * Implement command-window output during simulaton
    * Elapsed time, simulated time, percent completion, etc.
  * Test cases for finite differencing functions (Sam)
  * Add stability criteria for explicit scheme (Sam)
  * Crank-Nickelson or other explicit-implicit methdos? 2nd-order Lax-Wendroff?




