.486
.model flat
.stack 10000h
option casemap: none;case sensetive


include \masm32\include\kernel32.inc
includelib \masm32\lib\kernel32.lib

	Fibo PROTO NEAR32 C

.data
Number dd 0Ah;Given as param to Fibo

.code

_start:
	call main;call main procedure
	xor eax, eax;reset eax
	invoke ExitProcess, eax;exit process with exit status 0

main proc
	push [Number];push parameter
	call Fibo;call Fibo procedure
	add esp, 4;clear parameter from stack
	ret;return to _start
main endp

;-------------Fibo near cdecl-----------
;Calculates the n'th element of the Fibonacci series
;Param:DWORD - represents n
;return to eax- Fi(param) or -1 if error occured
Param equ dword ptr[ebp + 8]
Fibo proc NEAR32 C
	push ebp;preserve ebp 
	mov ebp, esp;new stack frame
	mov edx, Param
	cmp edx, 1
	je StopCondition;if param = 1 stop recursion
	jl ReturnError;if param is less than 1 return error
	dec edx;decrement param
	push edx;insert param to function
	call Fibo
	add esp, 4;clear parameter from stack
	push eax;save current elemet value
	add eax, ecx;add previous to current, thus we get next
	pop ecx;current element turns to previous
	pop ebp;set ebp to preserved value
	ret
	
StopCondition:
	xor ecx, ecx;set ecx to 0
	xor eax, eax;set eax to 1
	inc eax	
	pop ebp;set ebp to preserved value
	ret
	
ReturnError:
	mov eax, -1
	pop ebp;set ebp to preserved value
	ret
Fibo endp

END _start