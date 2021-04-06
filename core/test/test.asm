;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Written by: Andreas Hilvarsson, avmcu¤opencores.org (www.syntera.se)
;; Project...: AVRtinyX61core
;;
;; Purpose:
;; Test most instructions and try to check results and sreg after every
;; instruction.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;    AVR tiny261/461/861 core
;;    Copyright (C) 2008  Andreas Hilvarsson
;;
;;    This library is free software; you can redistribute it and/or
;;    modify it under the terms of the GNU Lesser General Public
;;    License as published by the Free Software Foundation; either
;;    version 2.1 of the License, or (at your option) any later version.
;;
;;    This library is distributed in the hope that it will be useful,
;;    but WITHOUT ANY WARRANTY; without even the implied warranty of
;;    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;;    Lesser General Public License for more details.
;;
;;    You should have received a copy of the GNU Lesser General Public
;;    License along with this library; if not, write to the Free Software
;;    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
;;
;;    Andreas Hilvarsson reserves the right to distribute this core under
;;    other licenses aswell.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.equ IFLAG, 7
.equ TFLAG, 6
.equ HFLAG, 5
.equ SFLAG, 4
.equ VFLAG, 3
.equ NFLAG, 2
.equ ZFLAG, 1
.equ CFLAG, 0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.equ IO_SREG,	0x3F
.equ IO_SPH,	0x3E
.equ IO_SPL,	0x3D
.equ IO_OCR0B,	0x12
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.equ IO_STEP_REG,		0x1B ;; PORTA
.EQU IO_STATUS_REG,	0x18 ;; PORTB
.equ STATUS_WORKING,	0x15
.equ STATUS_DONE_OK,	0x33
.equ STATUS_ERROR,	0xF3
.equ ARITH_LOOPS,		130
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	nop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Setup defaults
	ldi R16,0x7f
	clr r0

	out IO_SPL,R16
	out IO_SPH,R0
	out IO_SREG,r0

	out IO_STEP_REG,r0 ;; Set step
	ldi r16,STATUS_WORKING
	out IO_STATUS_REG,r16 ;; Set status
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Load registers with default info
	clr r0
	clr r1
	clr r2
	clr r3
	clr r4
	clr r5
	clr r6
	clr r7
	clr r8
	clr r9
	clr r10
	clr r11
	clr r12
	clr r13
	clr r14
	clr r15
	clr r16
	clr r17
	clr r18
	clr r19
	clr r20
	clr r21
	clr r22
	clr r23
	clr r24
	clr r25
	clr r26
	clr r27
	clr r28
	clr r29
	clr r30
	clr r31
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;; DO TESTS
test:
    clr r20
    ldi r22,1
    ldi r24,2
	ldi r26,3
    ldi r28,4
	ldi r30,5

    add r20,r22     ; R20 = 0 + 1 = 1
    add r20,r24     ; R20 = 1 + 2 = 3
    sub r20,r26     ; R20 = 3 - 3 = 0
    sub r20,r22     ; R20 = 0 - 1 = 255 (-1)
    inc r20         ; R20 = 255 (-1) + 1 = 0
    add r20,r28     ; R20 = 0 + 4 = 4
    dec r20         ; R20 = 4 - 1 = 3
    dec r20         ; R20 = 3 - 1 = 2
    dec r20         ; R20 = 2 - 1 = 1
    dec r20         ; R20 = 1 - 1 = 0

    nop

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
done:
	push r16
	ldi r16,STATUS_DONE_OK
	out IO_STATUS_REG,r16 ;; Set status
	pop r16
done2:	
	rjmp done2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

