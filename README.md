This is the full Matlab code for Eva Mishor's FC-PSAP and TAP experiments.
"Sniffing the Human Body-Volatile Hexadecanal Blocks Aggression in Men but Triggers Aggression in Women"
doi: https://doi.org/10.1101/2020.09.29.318287 
The setup includes two squeezable balls connected to an Arduino board or a 
NI DAQ board. The data is acquired using Matlab and analyzed in a background thread. 
Squeeze/release detection information is passed to main thread using global variables.

The main file is cleanup_PSAP4.m.
Analyses codes are also included in this repository (PSAP-PTB analyses)
