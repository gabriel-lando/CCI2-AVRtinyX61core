------------------------------------------------------------------------------
--
-- Written by: Andreas Hilvarsson, avmcu�opencores.org (www.syntera.se)
-- Project...: AVRtinyX61core
--
-- Purpose:
-- pm to tiny core, reads hexfile
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
use iEEE.numeric_std.ALL;
use std.textio.all;

entity tb_pm_hex is
	Generic (
		g_only_use_12bits : std_logic := '1'; -- 1=> only PM_A(11 downto 0) used as address, for compatibility with gcc-code for tinyX61 chips
		g_pm_size		: natural := 4096; -- Number of words of PM
		g_hex_filename	: string := "../test/build/test.hex"
	);
	Port (
			Clk		: in std_logic;
			Rst		: in std_logic; -- Reset when Rst='1'
			-- PM
			PM_A		: in std_logic_vector(15 downto 0);
			PM_Drd	: out std_logic_vector(15 downto 0));
end tb_pm_hex;

architecture Beh of tb_pm_hex is
------------------------------------------------------------------------------
	type PM_mem_type is array(0 to g_pm_size-1) of std_logic_vector(15 downto 0);
	signal PM_mem : PM_mem_type;
------------------------------------------------------------------------------
begin
------------------------------------------------------------------------------
	pm : process (Clk)
		variable a_int : natural;
	begin
		if (clk'event and clk='1') then
			if (g_only_use_12bits = '1') then
				a_int := CONV_INTEGER(PM_A(11 downto 0));
			else
				a_int := CONV_INTEGER(PM_A);
			end if;
			PM_Drd <= PM_mem(a_int);
		end if;
	end process pm;
------------------------------------------------------------------------------
	lpm : process -- Load pm
		file InFile : text;
		variable l : line;
		variable Temp_Char : character;
		variable ok : file_open_status;
		--
		function CHAR_2_STDLOGICVECTOR4(Char : in character) return std_logic_vector;
		function CHAR_2_STDLOGICVECTOR4(Char : in character) return std_logic_vector is
			variable tmp : std_logic_vector(3 downto 0);
			variable int : integer range 0 to 255;
		begin
			case Char is
				when '0'|'1'|'2'|'3'|'4'|'5'|'6'|'7'|'8'|'9' =>
					int := character'pos(Char) - character'pos('0');
					tmp := CONV_std_logic_vector(int,4);
				when 'A'|'B'|'C'|'D'|'E'|'F' =>
					int := character'pos(Char) - character'pos('A') + 10;
					tmp := CONV_std_logic_vector(int,4);
				when 'a'|'b'|'c'|'d'|'e'|'f' =>
					int := character'pos(Char) - character'pos('a') + 10;
					tmp := CONV_std_logic_vector(int,4);
				when others =>
					tmp := "UUUU";
			end case;
			return tmp;
		end function; 
		--
		--variable cc : natural; -- char count
		variable cl : std_logic_vector(7 downto 0); -- char left
		variable ht : std_logic_vector(7 downto 0); -- hex type
		variable a_int : natural;
		variable data : std_logic_vector(15 downto 0); -- data
		variable adr : std_logic_vector(15 downto 0); -- adr (not used)
		--
 	begin
 		wait for 1 ns;
		file_open(ok,InFile,g_hex_filename,READ_MODE); 
		wait for 1 ns;
		assert ok = OPEN_OK
			report "Error opening hex-file!"
				severity FAILURE;
		a_int := 0;
		while (not endfile(InFile)) loop 
			readline(InFile,l);
			read(L,Temp_Char);
			wait for 1 ns;
			if (Temp_Char = ':') then
				read(L,Temp_Char); -- read char count msb
				cl(7 downto 4) := CHAR_2_STDLOGICVECTOR4(Temp_Char);
				read(L,Temp_Char); -- read char count lsb
				cl(3 downto 0) := CHAR_2_STDLOGICVECTOR4(Temp_Char);
				--wait for 1 ns;
				read(L,Temp_Char); -- adr msb
				adr(15 downto 12) := CHAR_2_STDLOGICVECTOR4(Temp_Char);
				read(L,Temp_Char); -- adr
				adr(11 downto 8) := CHAR_2_STDLOGICVECTOR4(Temp_Char);
				read(L,Temp_Char); -- adr
				adr(7 downto 4) := CHAR_2_STDLOGICVECTOR4(Temp_Char);
				read(L,Temp_Char); -- adr lsb
				adr(3 downto 0) := CHAR_2_STDLOGICVECTOR4(Temp_Char);
				--wait for 1 ns;
				read(L,Temp_Char); -- read hex type msb
				ht(7 downto 4) := CHAR_2_STDLOGICVECTOR4(Temp_Char);
				read(L,Temp_Char); -- read hex type lsb
				ht(3 downto 0) := CHAR_2_STDLOGICVECTOR4(Temp_Char);
				--wait for 1 ns;
				while(cl /= 0) loop
					case ht is
						when X"00" => -- data
							read(L,Temp_Char); -- read data msb
							data(7 downto 4) := CHAR_2_STDLOGICVECTOR4(Temp_Char);
							read(L,Temp_Char); -- read data
							data(3 downto 0) := CHAR_2_STDLOGICVECTOR4(Temp_Char);
							read(L,Temp_Char); -- read data
							data(15 downto 12) := CHAR_2_STDLOGICVECTOR4(Temp_Char);
							read(L,Temp_Char); -- read data lsb
							data(11 downto 8) := CHAR_2_STDLOGICVECTOR4(Temp_Char);
							PM_mem(a_int) <= data;
							--wait for 1 ns;
							a_int := a_int + 1;
							cl := cl - 2;
							data := (others => 'X'); -- for simpler simulation
						when X"01" => -- end
							NULL; -- Do nothing
						when X"02" => -- "page"
							-- read data but ignore
							read(L,Temp_Char); -- read data msb
							read(L,Temp_Char); -- read data lsb
							--wait for 1 ns;
							cl := cl - 1;
						when others =>
							REPORT "Unknown ht"
								SEVERITY FAILURE;
					end case; -- ht
				end loop; -- cl /= 0
				-- read crc but ignore
				read(L,Temp_Char); -- read crc msb
				read(L,Temp_Char); -- read crc lsb
			end if; -- if :
		end loop; -- /=feof
		report "InFile - DONE."
			severity NOTE;
		wait; -- forever
	end process lpm;
------------------------------------------------------------------------------
end architecture Beh;
