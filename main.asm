org 0x00 
jmp fun
org 0x1B
jmp INT_T0 ;obrada prekida T0

status data 20h		;pristupimo svakom bitu

brzina data 22h
 ;deklarisanje promjenljive,adrese od 20h do 2Fh,ako zelimo da pristupimo bitu posebno
status1 data 23h
status2 data 24h

prom data 30h;na 1 sekundu
prom1 data 31h
i data 33h

counter data 34h
counterSave data 35h

prog:
	
	db 00h
	db 42h
	db 24h			  ;lookup tabela
	db 18h
	db 24h
	db 42h
	db 81h



	
INT_T0:
	push ACC
   	mov TH1,#26h
	mov TL1,#26h
	djnz prom,krajPrekida ;+			
	djnz prom1,krajPrekida
	setb status.1
	setb status2.1
	jb brzina.0,labela1
	jb brzina.1,labela2
	jmp krajPrekida
labela1:
	mov brzina,#0
	mov prom1,#16
	setb brzina.0
	mov prom,#250
	jmp krajPrekida
labela2:
	mov brzina,#0
	mov prom1,#8
	setb brzina.1
	mov prom,#250
	jmp krajPrekida
krajPrekida:				  ;	+
	pop ACC
	reti					   

fun:
	mov brzina,#0
	mov status,#0
	mov TMOD,#20h
	mov TH1,#26
	mov TL1,#26
	setb TR1
	setb EA
	setb ET1

while:
	;citanje ulaza
	jb P0.0,check1 ;if(P0_0==0) status=1
	setb status.0
	;mov P2,#1

check1:
	jb P0.1,logic //if(P0_1==0) status=0;
	clr status.0
	;mov P2,#0
	
logic:
	jb status.0,rad
	jmp while
	
rad:
	
	jnb P0.6,brzina1
	jnb P0.7,brzina2
funkc:
	jnb P0.2,program_1	 ;biranje rada programa od 1 do 4
	jnb P0.3,program_2
	jnb P0.4,f3
	jnb P0.5,f1
	jmp while
brzina1:
	mov prom1,#16
	setb brzina.0
	mov prom,#250
	jmp funkc
brzina2:
	mov prom1,#8
	setb brzina.1
	mov prom,#100
	jmp funkc
program_1:

	mov P2,#0 ;inicijalno stanje P2 tokom programa 1

program_111:
	jnb P0.6,dalje1
	jnb P0.7,dalje2
	jb brzina.0,prog1
	jb brzina.1,prog1
	jmp prog1
dalje1:
	mov prom1,#16
	setb brzina.0
	mov prom,#250
	jmp prog1
dalje2:
	mov prom1,#8
	setb brzina.1
	mov prom,#250
prog1:
		
	jnb P0.1,program11
	jnb P0.3,program_2
	jnb P0.4,program_3
	jnb P0.5,f1
	jb status2.1,funkcija11
	jmp program_111
funkcija11:
	clr status2.1
program1:
	mov A,P2
	cpl A ;invertovanje bitova,ali moze samo sa registrima
	mov P2,A
	
	
	jmp program_111

program11:
	clr status.0
	jmp logic
f4:
	jmp program_1
f3:
	jmp	program_3
f1:
	jmp program_4

program_2:
	mov P2,#1	 ;inicijalno stanje P2 tokom programa 2

program_222:
	jnb P0.6,dalje11
	jnb P0.7,dalje22
	jb brzina.0,prog11
	jb brzina.1,prog11
	jmp prog11
dalje11:

	mov prom1,#16
	setb brzina.0
	mov prom,#250
	jmp prog11
dalje22:
	
	mov prom1,#8
	setb brzina.1
	mov prom,#250
	jmp prog11
prog11:
		jnb P0.1,program22
		jnb P0.2,program_1
	jnb P0.4,program_3
	jnb P0.5,program_4

funkcija2:
	jb status2.1,funkcija22
	jmp program_222
funkcija22:
	clr status2.1
	
program2:
	mov A,P2
	rl A
	mov P2,A
	
	jmp program_222


program22:
	clr status.0
	jmp logic

f2:
jmp program_1
program_3:				;algoritam za rijesavanje zadatka 3

  	mov DPTR,#prog
	mov counter,#6
	mov counterSave,#6
prog3:
	jnb P0.6,dalje111
	jnb P0.7,dalje222
	jb brzina.0,while1
	jb brzina.1,while1
	jmp while1
dalje111:
		mov prom1,#16
	setb brzina.0
	mov prom,#250
	jmp while1
dalje222:
	mov prom1,#8
	setb brzina.1
	mov prom,#250
	jmp while1
while1:
	
	jnb P0.1,program33
	jnb P0.2,f4
	jnb P0.3,program_2
	jnb P0.5,program_4
funkcija3:
	jb status2.1,funkcija33
	jmp prog3
funkcija33:
	clr status2.1
	mov A,counter
	movc A,@A+DPTR
	mov P2,A
	djnz counter,while1
	mov counter,counterSAVE
	jmp while1


program33:
	clr status.0
	jmp logic
f5:
	jmp program_2
;izmedju ide implementacija ukrstanja bitova
f6:
	jmp program_3
program_4:			
		mov P2,#80h	  ;inicijalno stanje P2 tokom programa 4
prog4:
	jnb P0.6,dalje1111
	jnb P0.7,dalje2222
	jb brzina.0,funkcija4
	jb brzina.1,funkcija4
	jmp funkcija4
dalje1111:
		mov prom1,#16
	setb brzina.0
	mov prom,#250
	jmp funkcija4
dalje2222:
	mov prom1,#8
	setb brzina.1
	mov prom,#250
	jmp funkcija4
program_444:
	jnb P0.1,program44
	jnb P0.2,f2
	jnb P0.3,f5
	jnb P0.4,f6
	
funkcija4:
	jb status2.1,funkcija44
	jmp prog4
funkcija44:
	clr status2.1

program4:
	mov A,P2
	rr A
	mov P2,A
	jmp program_444

program44:
	clr status.0
	jmp logic	
	 
end	
