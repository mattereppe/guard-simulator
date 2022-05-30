# guard-simulator

Simulator for the Medial Records application. It emulates a doctor that access the data of two patients.

There are two optional parameters, to repeat the request and to set the "speed" to make calls within the request:
- -u <N> number of iterations;
- -d <D> the maximum delay between http calls (the real value is a random number betweeen 0 and D).

With a smaller value of D, the session will be faster; with a larger value of D, the session will be faster.
  
Example: 
```
  ./simulator.sh -d 3 -u 2
```
This emulates two times access to data of two patients, with a maximum delay of 3 seconds between every http request.
  
The Docker version provides the two arguments as environment variables. Specifically:
  - REPEAT is the argument to be provided to -u (default=1);
  - MAXDELAY is the argument to be provided to -d in seconds (default=4).


