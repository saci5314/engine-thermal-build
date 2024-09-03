# engine-build
Liquid bipropellant rocket engine design tools and and thermal network modeling.

## How-to
Clone the repository into your respective repo. 

See engine_build.m as an example to start designing engines.

## TODOs

### @engine
* Chemical equilibrium calcs (Timmy?)
  * Compile reactant thermochemical data
  * Write rootfinding scheme
  * Write test cases
* Nozzle design tooling
  * Add ability to parameterize by chamber diameter by contraction ratio
  * Write parabolic contour generation method
  * Wtite rao contour generation method
  * Write contour .dxf import/export methods
 
### @steady_state_thermal
* Material models
  * Extend Jet-A model to multiphase
  * Multiphase LNG or LCH4 model
  * Stainless steel models
  * Inco 625 material model
* Physics models
  * Finish implementing film cooling physics (Sam)
    * Radiation & convection coefficient functions (Sam)
    * Advection term finite differencing (Sam)
  * Total system energy tracking (Sam)
  * Implement ablation physics (long term)
* Solver 
  * Simulation command-window interface
    * Elapsed time, simulated time, percent completion, etc.
  * Test cases for finite differencing functions (Sam)
  * stability criteria for explicit scheme (Sam)
  * Implement 2nd order runge-kutta
  * Crank-Nickelson methods? 2nd-order Lax-Wendroff method?




