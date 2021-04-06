------------------------------------------------------------------------------
--
-- Written by: Andreas Hilvarsson, avmcu¤opencores.org (www.syntera.se)
-- Project...: AVRtinyX61core
--
-- Purpose:
-- pm to tiny core
--
------------------------------------------------------------------------------
--    AVR tiny261/461/861 core
--    Copyright (C) 2008  Andreas Hilvarsson
--
--    This library is free software; you can redistribute it and/or
--    modify it under the terms of the GNU Lesser General Public
--    License as published by the Free Software Foundation; either
--    version 2.1 of the License, or (at your option) any later version.
--
--    This library is distributed in the hope that it will be useful,
--    but WITHOUT ANY WARRANTY; without even the implied warranty of
--    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
--    Lesser General Public License for more details.
--
--    You should have received a copy of the GNU Lesser General Public
--    License along with this library; if not, write to the Free Software
--    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
--
--    Andreas Hilvarsson reserves the right to distribute this core under
--    other licenses aswell.
------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_pm is
	Port (
			Clk	: in std_logic;
			Rst	: in std_logic; -- Reset when Rst='1'
			-- PM
			PM_A		: in std_logic_vector(15 downto 0);
			PM_Drd	: out std_logic_vector(15 downto 0));
end tb_pm;

architecture Beh of tb_pm is
------------------------------------------------------------------------------
	type PM_mem_type is array(0 to 62) of std_logic_vector(15 downto 0);
	signal PM_mem : PM_mem_type := (
		X"0000",--      nop
		X"27ff",--      clr r31
		X"e6e0",--      ldi r30,0x60
		X"27dd",--      clr r29
		X"e6c0",--      ldi r28,0x60
		X"e225",--      ldi R18,0x25
		X"e336",--      ldi R19,0x36
		X"9321",--      st z+,r18
		X"9331",--      st z+,r19
		X"9049",--      ld r4,y+
		X"9059",--      ld r5,y+
		X"e308",--      ldi r16,0x38
		X"e112",--      ldi r17,0x12
		X"0108",--      movw r0,r16
		X"2e20",--      mov r2,r16
		X"0c01",--      add r0,r1
		X"0000",--      nop
		X"906a",--      ld r6,-y
		X"907a",--      ld r7,-y
		X"27bb",--      clr r27
		X"e6a0",--      ldi r26,0x60
		X"908d",--      ld r8,x+
		X"909d",--      ld r9,x+
		X"90ae",--      ld r10,-x
		X"80b0",--      ld r11,z
		X"e71f",--      ldi r17,0x7f
		X"bf1d",--      out 0x3d,r17
		X"e010",--      ldi r17,0
		X"bf1e",--      out 0x3e,r17
		X"90c0",--
		X"0061",-- lds r12,0x0061
		X"9320",--
		X"0062",-- sts 0x0062,r18
		X"92cf",--      push r12
		X"90df",--      pop r13
		X"9408",--      bset 0
		X"9418",--      bset 1
		X"9428",--      bset 2
		X"9478",--      bset 7
		X"9488",--      bclr 0
		X"9498",--      bclr 1
		X"94a8",--      bclr 2
		X"94e8",--      bclr 6
		X"94f8",--      bclr 7
		X"8141",--      ldd r20,z+1
		X"834b",--      std y+3,r20
		X"e0e2",--      ldi r30,0x02
		X"95c8",--      lpm
		X"95e3",--      inc r30
		X"90e5",--      lpm r14,Z+
		X"90f4",--      lpm r15,Z
		X"9631",--      adiw r30,1
		X"9731",--      sbiw r30,1
		X"ef10",--      ldi r17,0xF0
		X"b912",--      out 2,r17
		X"9a11",--      sbi 2,1
		X"9817",--      cbi 2,7
		X"b112",--      in r17,2
		X"d001",--      rcall b
		X"cfff",--      a: rjmp a
		X"0000",--      b: nop
		X"9508",--      ret
		X"cfff");--      a: rjmp a
------------------------------------------------------------------------------
begin
------------------------------------------------------------------------------
	pm : process (Clk)
		variable a_int : natural;
	begin
		if (clk'event and clk='1') then
			a_int := CONV_INTEGER(PM_A);
			PM_Drd <= PM_mem(a_int);
		end if;
	end process pm;
------------------------------------------------------------------------------
end architecture Beh;
