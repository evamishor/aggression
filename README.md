This is the full Matlab code for Eva Mishor's FC-PSAP experiment.
The setup includes two squeezable balls connected to an Arduino board or a 
NI DAQ board. The data is acquired using Matlab and analyzed in a background thread. 
Squeeze/release detection information is passed to main thread using global variables.

The main file is cleanup_PSAP4.m.