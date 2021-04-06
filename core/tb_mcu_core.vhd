------------------------------------------------------------------------------
--
-- Written by: Andreas Hilvarsson, avmcu¤opencores.org (www.syntera.se)
-- Project...: AVRtinyX61core
--
-- Purpose:
-- Test bench for AVR tiny162/461/861 core
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

entity tb_mcu_core is
	Port (clkout : out std_logic);
end tb_mcu_core;

architecture Beh of tb_mcu_core is
------------------------------------------------------------------------------
	component mcu_core is
		Port (
			Clk	: in std_logic;
			Rst	: in std_logic; -- Reset core when Rst='1'
			En		: in std_logic; -- CPU stops when En='0', could be used to slow down cpu to save power
			-- PM
			PM_A		: out std_logic_vector(15 downto 0);
			PM_Drd	: in std_logic_vector(15 downto 0);
			-- DM
			DM_A		: out std_logic_vector(15 downto 0); -- 0x00 - xxxx
			DM_Areal	: out std_logic_vector(15 downto 0); -- 0x60 - xxxx (same as above + io-adr offset)
			DM_Drd	: in std_logic_vector(7 downto 0);
			DM_Dwr	: out std_logic_vector(7 downto 0);
			DM_rd		: out std_logic;
			DM_wr		: out std_logic;
			-- IO
			IO_A		: out std_logic_vector(5 downto 0); -- 0x00 - 0x3F
			IO_Drd	: in std_logic_vector(7 downto 0);
			IO_Dwr	: out std_logic_vector(7 downto 0);
			IO_rd		: out std_logic;
			IO_wr		: out std_logic;
			-- OTHER
			OT_InstrErr	: out std_logic -- Instruction error! (Unknown instruction)
		);
	end component mcu_core;

	signal clk : std_logic;
	signal rst : std_logic;
	signal vcc : std_logic;
	signal gnd : std_logic;
	signal gnd8 : std_logic_vector(7 downto 0);
	signal gnd16 : std_logic_vector(15 downto 0);
------------------------------------------------------------------------------
	--PM
	component tb_pm_hex is
		Port (
				Clk	: in std_logic;
				Rst	: in std_logic; -- Reset when Rst='1'
				-- PM
				PM_A		: in std_logic_vector(15 downto 0);
				PM_Drd	: out std_logic_vector(15 downto 0)
		);
	end component tb_pm_hex;

	signal PM_A		: std_logic_vector(15 downto 0);
	signal PM_Drd	: std_logic_vector(15 downto 0);
------------------------------------------------------------------------------
	-- DM
	signal DM_A			: std_logic_vector(15 downto 0); -- 0x00 - xxxx
	signal DM_Areal	: std_logic_vector(15 downto 0); -- 0x60 - xxxx (same as above + io-adr offset)
	signal DM_Drd		: std_logic_vector(7 downto 0);
	signal DM_Dwr		: std_logic_vector(7 downto 0);
	signal DM_rd		: std_logic;
	signal DM_rd_d		: std_logic;
	signal DM_wr		: std_logic;
	signal DM_wr_d		: std_logic;
	type DM_mem_type	is array(0 to 127) of std_logic_vector(7 downto 0);
	signal DM_mem : DM_mem_type;
------------------------------------------------------------------------------
	-- IO
	signal IO_A		: std_logic_vector(5 downto 0); -- 0x00 - 0x3F
	signal IO_Drd	: std_logic_vector(7 downto 0);
	signal IO_Dwr	: std_logic_vector(7 downto 0);
	signal IO_rd	: std_logic;
	signal IO_rd_d	: std_logic;
	signal IO_wr	: std_logic;
	signal IO_wr_d	: std_logic;
	type IO_mem_type is array(0 to 63) of std_logic_vector(7 downto 0);
	signal IO_mem : IO_mem_type;
------------------------------------------------------------------------------
begin
------------------------------------------------------------------------------
	vcc <= '1';
	gnd <= '0';
	gnd8 <= (others => '0');
	gnd16 <= (others => '0');
------------------------------------------------------------------------------
	cp : process
	begin
		clk <= '0';
		wait for 5 ns;
		clk <= '1';
		wait for 5 ns;
	end process cp;
	clkout <= clk;
	
	rp : process
	begin
		rst <= '1';
		wait for 500 ns;
		rst <= '0';
		wait; -- for ever
	end process rp;
------------------------------------------------------------------------------
	core : mcu_core Port map (
		Clk	=> Clk,
		Rst	=> Rst,
		En		=> vcc,
		-- PM
		PM_A		=> PM_A,
		PM_Drd	=> PM_Drd,
		-- DM
		DM_A		=> DM_A,
		DM_Areal	=> DM_Areal,
		DM_Drd	=> DM_Drd,
		DM_Dwr	=> DM_Dwr,
		DM_rd		=> DM_rd,
		DM_wr		=> DM_wr,
		-- IO
		IO_A		=> IO_A,
		IO_Drd	=> IO_Drd,
		IO_Dwr	=> IO_Dwr,
		IO_rd		=> IO_rd,
		IO_wr		=> IO_wr,
		-- OTHER
		OT_InstrErr	=> open
	);
------------------------------------------------------------------------------
	pm : tb_pm_hex port map (
			Clk	=> Clk,
			Rst	=> Rst,
			-- PM
			PM_A		=> PM_A,
			PM_Drd	=> PM_Drd
	);
------------------------------------------------------------------------------
	dm : process (Clk)
		variable a_int : natural;
		variable rdwr : std_logic_vector(1 downto 0);
	begin
		if (clk'event and clk='1') then
			DM_rd_d <= DM_rd;
			DM_wr_d <= DM_wr;
			a_int := CONV_INTEGER(DM_A);
			rdwr := DM_rd & DM_wr;
			DM_Drd <= (others => '0');
			case rdwr is
				when "10" => -- rd
					DM_Drd <= DM_mem(a_int);
				when "01" => -- wr
					DM_mem(a_int) <= DM_Dwr;
				when "11" => -- error
					REPORT "Rd and Wr of DM at same time"
						SEVERITY error;
				when others => NULL; -- do nothing
			end case;
			--if (DM_rd='1' and DM_rd_d='1') then
			--	REPORT "DM_rd active for more then one clk pulse"
			--		SEVERITY NOTE;
			--end if;
			--if (DM_wr='1' and DM_wr_d='1') then
			--	REPORT "DM_wr active for more then one clk pulse"
			--		SEVERITY NOTE;
			--end if;
		end if;
	end process dm;
------------------------------------------------------------------------------
	im : process (Clk)
		variable a_int : natural;
		variable rdwr : std_logic_vector(1 downto 0);
	begin
		if (clk'event and clk='1') then
			IO_rd_d <= IO_rd;
			IO_wr_d <= IO_wr;
			a_int := CONV_INTEGER(IO_A);
			rdwr := IO_rd & IO_wr;
			IO_Drd <= (others => '0');
			case rdwr is
				when "10" => -- rd
					IO_Drd <= IO_mem(a_int);
				when "01" => -- wr
					IO_mem(a_int) <= IO_Dwr;
				when "11" => -- error
					REPORT "Rd and Wr of IO at same time"
						SEVERITY error;
				when others => NULL; -- do nothing
			end case;
			if (IO_rd='1' and IO_rd_d='1') then
				REPORT "IO_rd active for more then one clk pulse"
					SEVERITY NOTE;
			end if;
			if (IO_wr='1' and IO_Wr_d='1') then
				REPORT "IO_wr active for more then one clk pulse"
					SEVERITY NOTE;
			end if;
		end if;
	end process im;
------------------------------------------------------------------------------
end architecture Beh;
