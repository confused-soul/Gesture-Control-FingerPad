s.boot; //boots the server
SerialPort.devices; //gives the available devices/ports connected

~port = SerialPort.new("/dev/cu.usbmodem14101", 115200); //saves the port in use to access serial monitor


(
x = [ ];
30.do{x = x.add(~port.read.postln)}; //just to check inputs
x = x.collect(_.asAscii);
)
 // a synthdef for gesture 1
(
SynthDef.new(\pulseTest, {
	arg ampHz = 4, fund = 45, maxPart = 4, width = 0.5, vol = 0;
	var amp1, amp2, freq1, freq2, sig1, sig2;
	amp1 = LFPulse.kr(ampHz, 0, 0.12)*vol;
	amp2 = LFPulse.kr(ampHz, 0.5, 0.12)*vol;
	freq1 = LFNoise0.kr(4).exprange(fund, fund*maxPart).round(fund);
	freq2 = LFNoise0.kr(4).exprange(fund, fund*maxPart).round(fund);
	freq1 = freq1*LFPulse.kr(8, add:1);
	freq2 = freq2*LFPulse.kr(6, add:1);
	sig1 = Pulse.ar(freq1, width, amp1);
	sig2 = Pulse.ar(freq2, width, amp2);
	sig1 = FreeVerb.ar(sig1, 0.7, 0.8, 0.25);
	sig2 = FreeVerb.ar(sig2, 0.7, 0.8, 0.25);
	Out.ar(0, sig1);
	Out.ar(1, sig2);
}).add;
)

//getting values from serial monitor and saving each ldr's reading individually
(
~charArray = [ ] ; //to save characters that will be combined to form one reading
~ldrs = [ ] ; //to save the 5 ldrs reading that are taken at a time
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

//creating synth for each finger.
(
~g1 = Synth.new(\pulseTest);
~g2={
	arg freq = 440,amp = 0;
	var sig;
	sig = PinkNoise.ar(freq)*amp;
}.play;
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
var l1, l2, l3, l4, pf,th, a1, a2, a3, a4, f1, f2, f3, f4, t1, t2, t3, t4, g1, g2;
~createSound = Routine.new({
	{

		//light intensity in each finger.
		l1 = ~ldr1;
		l2 = ~ldr2;
		l3 = ~ldr3;
		l4 = ~ldr4;
	    pf = ~ldr5;
		//saving ldr reading of each finger

		t1 = ~ldr1<150;
		t2 = ~ldr2<150;
		t3 = ~ldr3<150;
		t4 = ~ldr4<150; //checking if the light intensity is low

		g1 = t1&&t2&&t3&&t4; //condition for gesture 1
		g2 = t2&&t3; //condition for gesture 2

		while( {g1}, { //if gesture 1 is done
			~g1.set(\vol, 0.75); //increasing volume

			w.set(\amp, 0);
			x.set(\amp, 0);
			y.set(\amp, 0);
			z.set(\amp, 0);
			t1 = ~ldr1<150; //checking if gesture is still made in loop
			t2 = ~ldr2<150;
			t3 = ~ldr3<150;
			t4 = ~ldr4<150;
			g1 = t1&&t2&&t3&&t4;

			0.25.wait;
		});
		~g1.set(\vol, 0); //cutting gesture sound since gesture condition is false

		while( {g2}, {//if gesture 2 is done
			~g2.set(\amp, 1); //increasing volume

			w.set(\amp, 0);
			x.set(\amp, 0);
			y.set(\amp, 0);
			z.set(\amp, 0);
			t1 = ~ldr1<150;//checking if gesture is still made
			t2 = ~ldr2<150;
			t3 = ~ldr3<150;
			t4 = ~ldr4<150;
			g2 = t2&&t3;

			0.25.wait;
		});
		~g2.set(\amp, 0);//cutting gesture sound since gesture condition is false

		//calculating amplitude/volume of synth for each finger;
		a1 = l1.linlin(0, 600, 1, 0);
		a2 = l2.linlin(0, 600, 1, 0);
		a3 = l3.linlin(0, 600, 1, 0);
		a4 = l4.linlin(0, 600, 1, 0);

		th = pf.linlin(0, 400, 400, 0);

		//calculating freq with pf
		f1 = 440 + th;
		f2 = 600 + th;
		f3 = 720 + th;
		f4 = 990 + th;

		//creating sound.
		w.set(\amp, a1, \freq, f1);
		x.set(\amp, a2, \freq, f2);
		y.set(\amp, a3, \freq, f3);
		z.set(\amp, a4, \freq, f4);

		(0.25).wait;
	}.loop;
}).play;
)

//stoping routine.
~getValues.stop;
~createSound.stop;

//freeing all synth
(
w.free;
x.free;
y.free;
z.free;
~g1.free;
~g2.free;
)


//quiting server.
s.quit;

//normal light condition should read the reading of the thumb more than 600 otherwise it will start increasing the frequencies of other fingers

//AKNOWLEDGEMENT: THE SYNTHDEF AT THE LINE 13 TO 29 IS DERIVED FROM "Eli Fieldsteel" 's YOUTUBHE VIDEO ON SUPERCOLLIDER NAMING "SuperCollider Tutorial: 3. Synth and SynthDef"

