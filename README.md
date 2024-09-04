# engine-build

All models are wrong. Fortunately, this model is fun. 

## Where does the heat come from? Where does it go?
The structural matter of a thrust chamber assembly (TCA) will have some maximum total heat capacity bounded by a melting temperature, or a temperature above/below which the material properties of the TCA are unnaceptable.

The propellants enter the TCA vaporized or as close to saturation temperature as is desirable for your injector design. Chemical potential energy is converted to the kinetic/vibrational energy of reacting particles. They'll do two things to echange heat with your thrust chamber. First, they'll smack into the wall. Second, dipoles will emit radiation, some of which the TCA will absorb. Once all this energy is transfered to the TCA, we must figure out how to get rid of it quickly. We can dump it into a coolant or radiate it outwards. Additionally, we can place coolant or ablators between the chamber wall and combustion gas to eat much of this energy up front.

## How ought we model this?
Below was my first pass at this. A system of nonlinear equations can be constructed by performing a 1D heat balance on a regeneratively cooled engine. With some troublesome rootfinding I got some shoddy results that look promising but do not close, physically or numerically:

<img width="1256" alt="PNG image" src="https://github.com/user-attachments/assets/dd5a3ed7-0073-4184-9f5d-179a5f1115bb">


This project abandons rootfinding in favor of a transient IBVP solver that I've had some tentative successes with. The convection-diffusion equation is solved via an explicit, first-order-in-time (euler) scheme on a 2D grid. Though, the problem is reduced to a system of 1D finite differencing problems. Diffusion along the length of the chamber is considered negligible. It is only differenced in the radial direction. The steady flow of coolant carries heat longitudinally along the chamber boundaries by advection. It only needs differencing along the length of the nozzle. Convective and radiative heat transfer are treated as volumetric heat sources in boundary layer nodes and outer-most wall nodes.

The library is broken into two classes of objects that contain all the methods to design an engine and simulate its thermal performance. I'd like it to be straightforward to perform many analyses on one engine design or run many engine designs through one analysis.

## @engine
The "engine" object contains a bunch of methods for performing high-level isentropic sizing calcs, combustion gas equilibrium property calcs, and nozzle contour design.

### @engine TODOs
* Chemical equilibrium calcs (Timmy and/or Andrew?)
  * Compile thermochemical data of relevant species for kerolox/methalox
  * Write gibbs free energy minimization algorithm
  * Write test cases
* Nozzle design tooling
  * Add ability to parameterize by chamber diameter by contraction ratio
  * Write parabolic contour generation method (Andrew)
  * Wtite rao contour generation method
  * Write contour .dxf import/export methods
 
## @steady_state_thermal
The "thermal_network" object is a suite for simulating heat transfer in your TCA and charactertizing your cooling system design.

### @steady_state_thermal TODOs
* Material library
  * Extend Jet-A model to multiphase (l/g) for film cooling
  * Add Multiphase (l/g) LNG or LCH4 model 
  * Extend Inco 625 material model to cryo
* Physics models
  * Film cooling (under construction)
    * Update Grisson's emissivity function
    * Finish space marching routine
    * Write post-evaporation entrainment physics
    * Write phase change checker in solver function
  * Total system energy tracking, power/efficiency calcs, etc.
  * Ablation physics (low priority)
* Solver 
  *  Command-window output during simulaton
    * Elapsed time, simulated time, percent completion, etc.
  * Test cases for finite differencing functions
  * Finish implementing Von-Neumann stability checks for explicit method
  * Crank-Nickelson or other explicit-implicit methdos? 2nd-order Lax-Wendroff?




