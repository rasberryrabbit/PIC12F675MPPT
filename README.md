# PIC12F675MPPT
Solar MPPT circuit.  
  
This is simple MPPT for solar panel.  
New 3.2 firmware from 16F676 project.  
Test is ok as expected. ( jan 18 2019 )  
It's 50W limit design. Consider D6,D1,D2,L1 with more high power solar panel.  
  
11 mili-ohm N-ch logic level FET(BUK9511 or BUK9508) used for current sensor. 
It can replace by 11 mili-ohm or lower Rds-on resistance logic level FET.  
  
Transistor 2N2222A -> BC547 or compatible(reverse pin order)  
Transistor 2N2907A -> BC557 or compatible(reverse pin order)  
  
L1 100~330uH  
  
LM358N can replace by other pin-compatible regular OP-AMP. TLC272 is more works better.  
  
D8-D9 used for 3.6v Reference. Each has about 1.8v voltage drop.  
  
Q1 gate voltage is 3.6v. It's depend on FET specification.  
  
Q1, Q2 can skip heat spreader with low POWER Solar panel. No heat with 10W panel.  
  
(Note) Sometimes MPPT stalls no output. It caused by low FET bootstrap voltage.  
It's very rare condition. It may fixed by R9 change.  

