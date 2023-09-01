SerialPort.devices;

~port = SerialPort.new("/dev/cu.usbmodem14101", 115200);

//checking inputs
(
x = [ ];
30.do{x = x.add(~port.read.postln)};
x = x.collect(_.asAscii);
)

//getting values
(
~charArray = [ ] ;
~ldrs = [ ] ;
~ldr1 = 0; //index - A1
~ldr2 = 0; //middle - A2
~ldr3 = 0; //ring - A3
~ldr4 = 0; //pinky - A4
~ldr5 = 0; //thumb -A5
~getValues = Routine.new({
	var ascii;
	{
		ascii = ~port.read.asAscii;
	    if(ascii.isDecDigit, {~charArray = ~charArray.add(ascii)});
		if(ascii == $x, {
			~val = ~charArray.collect(_.digit).convertDigits;
			~ldrs = ~ldrs.add(~val);
			~charArray = [ ];
		});
		if(ascii == $a, {
			~ldr1 = ~ldrs[0];
			~ldr2 = ~ldrs[1];
			~ldr3 = ~ldrs[2];
			~ldr4 = ~ldrs[3];
			~ldr5 = ~ldrs[4];
			~ldrs = [ ];
		});
	}.loop;
}).play;
)

//checking values from LDRs
[ ~ldr1, ~ldr2, ~ldr3, ~ldr4, ~ldr5 ];

//booting the server
s.boot;

//creating synth for each finger.
(
z={
		arg freq = 440,amp = 0;
		var sig;
		sig = SinOsc.ar(freq)*amp;
}.play;
y={
		arg freq = 600,amp = 0;
		var sig;
		sig = SinOsc.ar(freq)*amp;
}.play;
x={
		arg freq = 720,amp = 0;
		var sig;
		sig = SinOsc.ar(freq)*amp;
}.play;
w={
		arg freq = 990,amp = 0;
		var sig;
		sig = SinOsc.ar(freq)*amp;
}.play;
)

//looping routine for reading gestures and manupilating sound.
(
var l1, l2, l3, l4, pf, a1, a2, a3, a4, f1, f2, f3, f4;
~createSound = Routine.new({
	{
		//light intensity in each finger.
		l1 = ~ldr1;
		l2 = ~ldr2;
		l3 = ~ldr3;
		l4 = ~ldr4;
	    pf = ~ldr5;

    	//no change upto a threshold light intensity.
		if(pf>600 ,{
			pf = 0;
		});

		//calculating amplitude;
		a1 = l1.linlin(0, 600, 1, 0);
		a2 = l2.linlin(0, 600, 1, 0);
		a3 = l3.linlin(0, 600, 1, 0);
		a4 = l4.linlin(0, 600, 1, 0);

		//calculating freq
		f1 = 440 + pf;
		f2 = 600 + pf;
		f3 = 720 + pf;
		f4 = 990 + pf;

		//manupilating sound.
		w.set(\amp, a1, \freq, f1);
		x.set(\amp, a2, \freq, f2);
		y.set(\amp, a3, \freq, f3);
		z.set(\amp, a4, \freq, f4);

		(0.25).wait;
	}.loop;
}).play;
)

//stoping routine.
~createSound.stop;
~getValues.stop;

//freeing all synths.
(
w.free;
x.free;
y.free;
z.free;
)

//quiting server.
s.quit;
