# engine-build
**Liquid bipropellant rocket engine design tools and and thermal network modeling.**

All models are wrong. Fortunately, this model is fun. 

## Where does the heat come from? Where does it go?
The structural matter of a thrust chamber assembly (TCA) will have some maximum total heat capacity bounded by a melting temperature, or a temperature above/below which the material properties of the TCA are unnaceptable.

The propellants enter the TCA vaporized or as close to saturation temperature as is desirable for your injector design. Chemical potential energy is converted to the kinetic/vibrational energy of reacting particles. They'll do two things to echange heat with your thrust chamber. First, they'll smack into the wall. Second, dipoles will emit radiation, some of which the TCA will absorb. Once all this energy is transfered to the TCA, we must figure out what to do with it quickly. We can expell it by convection with a coolant or by radiating it outwards. Additionally, we can put coolants or ablators between the wall and the combustion gas to eat this energy before it reaches the TCA in the first place.

## How ought we model this?
Below was my first pass at this. A system of nonlinear equations can be constructed by performing a heat balance in a chamber wall and a regenerative coolant in steady-state conditions. I tried solving it via rootfinding and got some shoddy results that look neat but are definitley fake:

<img width="1256" alt="PNG image" src="https://github.com/user-attachments/assets/dd5a3ed7-0073-4184-9f5d-179a5f1115bb">


This has been abandoned in favor of a finite element IBVP solver that I've had some initial successes with. A convection-diffusion problem is solved via an explicit, first-order-in-time (euler) scheme on a 2D grid. Though, the problem is really reduced to multple 1D finite differencing problems. Diffusion along the length of the chamber is considered negligible. It is only differenced in the radial direction. The steady flow of coolant carries heat along the chamber by advection. It only needs differencing along the length of the nozzle. Convective heat transfer and radiative heat transfer is treated by additional volumetric source terms in coolant and outer-most wall nodes.

The library is broken into two classes of objects that contain all the methods to design an engine and simulate its thermal performance. I'd like it to be straightforward to run many analyses on one engine design or many engine designs through one analysis.

## @engine
The "engine" object contains a bunch of methods for performing high-level isentropic sizing calcs, combustion gas equilibrium property calcs, and nozzle contour design.

### @engine TODOs
* Chemical equilibrium calcs (Timmy and/or Andrew)
  * Compile thermochemical data of relevant species for kerolox/methalox
  * Write gibbs free energy minimization physics
  * Write test cases
* Nozzle design tooling
  * Add ability to parameterize by chamber diameter by contraction ratio
  * Write parabolic contour generation method (Andrew)
  * Wtite rao contour generation method
  * Write contour .dxf import/export methods
 
## @steady_state_thermal
The "thermal_network" object is a suite for simulating heat transfer in your TCA and charactertizing your cooling system design.

### @steady_state_thermal TODOs
* Material models
  * Extend Jet-A model to multiphase (l/g) for film cooling (Kenny?)
  * Add Multiphase (l/g) LNG or LCH4 model (Kenny?)
  * Add SS 304L material model
  * Add Inco 625 material model
* Physics models
  * Finish implementing film cooling physics (Sam)
    * Add option to use Grisson's model for emissivity 
    * Advection term finite differencing check 
  * Total system energy tracking (sam)
  * Ablation physics (low priority)
* Solver 
  * Implement command-window output during simulaton
    * Elapsed time, simulated time, percent completion, etc.
  * Test cases for finite differencing functions (Sam)
  * Add stability criteria for explicit scheme (Sam)
  * Crank-Nickelson or other explicit-implicit methdos? 2nd-order Lax-Wendroff?




