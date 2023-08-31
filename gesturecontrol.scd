(
SynthDef.new(\pulseTest, {
	arg ampHz = 4, fund = 40, maxPart = 4, width = 0.5;
	var amp1, amp2, freq1, freq2, sig1, sig2;
	amp1 = LFPulse.kr(ampHz, 0, 0.12)*0.75;
	amp2 = LFPulse.kr(ampHz, 0.5, 0.12)*0.75;
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
x = Synth.new(\pulseTest);

x.set(\ampHz,0);


x.free;


(
a = {
arg amp = 0;
var sig;
sig = SinOsc.ar(440)*amp;
}.play;
)

(
~val = 4;
r = Routine.new({
	{

		if(~val > 5, {
			x.set(\ampHz, 4);
			0.5.wait;
		});
		if(~val < 5, {
			x.set(\ampHz, 0);
		});

		0.25.wait;
	}.loop;
}).play;
)

(
x.set(\ampHz, 4);
2.wait;
x.set(\ampHz, 0);
a.set(\amp, 1);
)
r.stop;
a.set(\amp, 0);
s.boot;
s.quit;
