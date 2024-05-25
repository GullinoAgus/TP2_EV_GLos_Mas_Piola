************************************************************************
* Quartus HSPICE Writer I/O Simulation Deck
*
* This spice simulation deck was automatically generated by Quartus for
* the following IO settings:
*
*  Device:       EP4CE22F17C6
*  Speed Grade:  C6
*  Pin:          D1 (op1_num[13])
*  Bank:         IO Bank 1 (Row I/O)
*  I/O Standard: 2.5 V
*  OCT:          Off
*
* Quartus' default I/O timing delays assume the following slow corner
* simulation conditions.
*
*  Specified Test Conditions For Quartus Tco
*    Temperature:      85C (Slowest Temperature Corner)
*    Transistor Model: TT (Typical Transistor Corner)
*    Vccn:             2.325V (Vccn_min = Nominal - 5%)
*    Load:             No Load
*    Vtt:              1.25V (Voltage reference is Nominal Vccn/2)
*    Vcc:              1.1V (Vcc_min = Minimum Recommended)
*
* For C6, C8L and I8L devices, the TT transistor corner provides an approximation
* for worst case timing. However, for functionality simulations,
* it is recommended that the SS corner be simulated as well.
*
* Note: Actual production devices can be as fast as the FF corner.
*       Any simulations for hold times should be conducted using the
*       fast process corner with the following simulation conditions.
*         Temperature:      0C (Fastest Temperature Corner)
*         Transistor Model: FF (Fastest Transistor Corner)
*         Vccn:             2.625V (Vccn_hold = Nominal + 5%)
*         Vtt:              1.25V (Vtt_hold = Vccn/2)
*         Vcc:              1.25V (Vcc_hold = Maximum Recommended)
*         Package Model:    Short-circuit from pad to pin (no parasitics)
*
*       For a detailed description of hold time analysis see
*       the Quartus II HSPICE Writer AppNote.
*
* Usage:
*
*    1) Replace the sample board and termination circuit below with
*       your desired circuit.
*    2) Replace the sample driver circuit with a model of the actual
*       I/O driver that will be driving the FPGA input pin.
*    3) Replace the VccN and Vccpd voltages with your desired value or
*       leave them unchanged for a slow corner simulation.
*
*
* Warnings:
*
************************************************************************

************************************************************************
* Process Settings
************************************************************************
.options brief 
.inc 'lib/cive_tt.inc' * TT process corner

************************************************************************
* Simulation Options
************************************************************************
.options brief=0
.options badchr co=132 scale=1e-6 acct ingold=2 nomod dv=1.0
+        dcstep=1 absv=1e-3 absi=1e-8 probe captab converge=1 
.options csdf=2
.temp 85
 
************************************************************************
* Constant Definition
************************************************************************
voeb       oeb       0     vc * Set to 0 to enable buffer output
vopdrain   opdrain   0     0 * Set to vc to enable open drain 
vrambh     rambh     0     0 * Set to vc to enable bus hold
vrpullup   rpullup   0     0 * Set to vc to enable weak pullup
vpci       rpci      0     0 * Set to vc to enable pci mode
vrpcdnextra rpcdnextra 0 dc rngateextra * These control bits set the IO standard
vpcdp7     rpcdp7    0     rp7 
vpcdp6     rpcdp6    0     rp6  
vpcdp5     rpcdp5    0     rp5
vpcdp4     rpcdp4    0     rp4
vpcdp3     rpcdp3    0     rp3
vpcdp2     rpcdp2    0     rp2
vpcdp1     rpcdp1    0     rp1
vpcdp0     rpcdp0    0     rp0

vpcdn7     rpcdn7    0     rn7
vpcdn6     rpcdn6    0     rn6
vpcdn5     rpcdn5    0     rn5
vpcdn4     rpcdn4    0     rn4
vpcdn3     rpcdn3    0     rn3
vpcdn2     rpcdn2    0     rn2
vpcdn1     rpcdn1    0     rn1
vpcdn0     rpcdn0    0     rn0
vpdly      rpdly     0     rpdly
vndly      rndly     0     rndly
vrpcdsr1   rpcdsr1   0     rsr1
vrpcdsr0   rpcdsr0   0     rsr0

vdin       din       0     0
 
************************************************************************
* IO Buffer Netlist 
************************************************************************
.include 'cir/hio_buffer.inc'

************************************************************************
* Drive Strength Settings
************************************************************************
.lib 'lib/drive_select_hio.lib' p_25_oct_50
************************************************************************
* Programmable Output Delay Control Settings
************************************************************************
.lib 'lib/output_delay_control.lib' nodelay

************************************************************************
* Programmable Slew Rate Control Settings
************************************************************************
.lib 'lib/slew_rate.lib' fast
 
************************************************************************
* I/O Buffer Instantiation
************************************************************************

* Supply Voltages Settings
.param vcn=2.325
.param vc=1.1
.param vrefx   = 'vcn/2'

* Instantiate Power Supplies
vvcc       vcc       0     vc     * FPGA core voltage
vvccn      vccn      0     vcn    * IO supply voltage
vvssn      vssn      0     0      * IO ground
vvss       vss       0     0      * FPGA core ground
vvref      vref      0 	   vrefx

* Instantiate I/O Buffer
xhio_buf die din oeb vccn vssn vss vcc vref
+ rpcdp7 rpcdp6 rpcdp5 rpcdp4 rpcdp3 rpcdp2 rpcdp1 rpcdp0 
+ rpcdn7 rpcdn6 rpcdn5 rpcdn4 rpcdn3 rpcdn2 rpcdn1 rpcdn0 
+ rpcdnextra rpdly rndly rpci rpullup rpcdsr1 rpcdsr0
+ rambh opdrain hio_buf

* Internal Loading on Pad
* - No loading on this pad due to differential buffer/support circuitry


* I/O Buffer Package Model
* - Standard Row I/O package trace
.lib 'lib/package.lib' pkglib_F256
xpkg die pinp pkg_F256
* /////////////////////////////////////////////////////////////////// *
* I/O Board Trace And Termination Description                         *
*   - Replace this with your board trace and termination description  *
* /////////////////////////////////////////////////////////////////// *
wtline pinp vssn board1 vssn N=1 L=1 RLGCMODEL=tlinemodel
.MODEL tlinemodel W MODELTYPE=RLGC N=1 Lo=7.13n Co=2.85p
rsource board1 source 50

* /////////////////////////////////////////////////////////////////// *
* Sample source stimulus placeholder                                  *
*  - Replace this with your I/O driver model                          *
* /////////////////////////////////////////////////////////////////// *

vsource source 0 pulse(0 vcn 0s 0.4ns 0.4ns 8.5ns 17.4ns)

************************************************************************
* Simulation Analysis Setup
************************************************************************

* Print out the voltage waveform at both the source and the FPGA pin
.print tran v(source)  v(pinp)
.tran 0.020ns 17ns

* Measure the propagation delay from the source pin to the FPGA pin
* referenced against the 50% voltage threshold crossing point
.measure TRAN tpd_rise TRIG v(source) val='vcn*0.5' rise=1 TARG v(pinp) val ='vcn*0.5' rise=1
.measure TRAN tpd_fall TRIG v(source) val='vcn*0.5' td=8.7ns fall=1 TARG v(pinp) val ='vcn*0.5' td=8.7ns fall=1

.end
