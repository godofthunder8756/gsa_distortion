; Distortion.csd
; Guitar Studio Ahern 2020
;
; Powershape opcode for wave distortion
;
; CONTROLS
; --------
; Test Tone	--	a glissandoing test tone
; Distortion	--	amount of distortion
; Level		--	output level

<Cabbage>
form caption("GSA DISTORTION") size(300, 475), colour(58, 110, 182), pluginid("def1")
;REMOVED FOR COMPATIBILITY-------image bounds(-32, -20, 367, 513) file("D:\Guitar Studio Ahern\Pedal\distortionpedal.png")

checkbox bounds(86, 180, 130, 20), channel("TestTone"), ,  , text("Tone Test"), colour:1(255, 48, 164, 255)
rslider bounds(32, 24, 97, 95),          colour(255, 255, 255, 255), trackercolour(255, 255, 255, 255), channel("amount"), range(0.1, 1000, 1, 0.25, 0.001) text("Distortion") textcolour(255, 48, 164, 255)


numberbox  bounds(100, 65,100, 40), text("Amount [type]"),  channel("amount"),  range(0.1, 1000, 1,1,0.001), textcolour(white)

rslider bounds(90, 24, 245, 99),          , ,  range(0, 50, 0.5, 0.25, 1)  channel("level") trackercolour(255, 255, 255, 255) text("Level") textcolour(255, 48, 164, 255)
rslider bounds(94, 84, 102, 99), channel("gain"), range(0, 1, 0, 1, 0.01), text("Gain"), trackercolour(0, 255, 0, 255), outlinecolour(0, 0, 0, 50), textcolour(255, 48, 164, 255)

}

</Cabbage>

<CsoundSynthesizer>

<CsOptions>
-d -n
</CsOptions>

<CsInstruments>

sr 		= 	44100	;SAMPLE RATE
ksmps 		= 	32	;NUMBER OF AUDIO SAMPLES IN EACH CONTROL CYCLE
nchnls 		= 	2	;NUMBER OF CHANNELS (2=STEREO)
0dbfs		=	1

gisine	ftgen	0,0,4096,10,1 ;,0,1/2,0,1/4,0,1/8,0,1/16,0,1/32,0,1/64

instr	1
	kporttime	linseg	0,0.001,0.05				; portamento time ramps up from zero
	gkshape		chnget	"amount"				; READ WIDGETS...
	gkshape		portk	gkshape,kporttime
	gklevel		chnget	"level"					;
	gklevel		portk	gklevel,kporttime
	gklevel		portk	gklevel,kporttime
	kGain       chnget   "gain"

	gkTestTone	chnget	"TestTone"
	if gkTestTone==1 then						; if test tone selected...
	 koct	rspline	4,8,0.2,0.5						
	 asigL		poscil	1,cpsoct(koct),gisine			; ...generate a tone
	 asigR		=	asigL					; right channel equal to left channel
	else								; otherwise...
	 asigL, asigR	ins						; read live inputs
	endif
	ifullscale	=	0dbfs	;DEFINE FULLSCALE AMPLITUDE VALUE
	aL 		powershape 	asigL, gkshape, ifullscale	;CREATE POWERSHAPED SIGNAL
	aR 		powershape 	asigR, gkshape, ifullscale	;CREATE POWERSHAPED SIGNAL
	alevel		interp		gklevel
			outs		aL * alevel, aR * alevel		;WAVESET OUTPUT ARE SENT TO THE SPEAKERS
endin
		
</CsInstruments>

<CsScore>
i 1 0 [3600*24*7]
</CsScore>


</CsoundSynthesizer>
