@echo off
rem ///////////////////////////////////////////////////////////////////////////
rem
rem Written by: Andreas Hilvarsson, avmcu�opencores.org (www.syntera.se)
rem Project...: Test code for TinyXcore
rem
rem Purpose:
rem Compile test
rem
rem ///////////////////////////////////////////////////////////////////////////
rem    AVR tiny261/461/861 core
rem    Copyright (C) 2008  Andreas Hilvarsson
rem
rem    This library is free software; you can redistribute it and/or
rem    modify it under the terms of the GNU Lesser General Public
rem    License as published by the Free Software Foundation; either
rem    version 2.1 of the License, or (at your option) any later version.
rem
rem    This library is distributed in the hope that it will be useful,
rem    but WITHOUT ANY WARRANTY; without even the implied warranty of
rem    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
rem    Lesser General Public License for more details.
rem
rem    You should have received a copy of the GNU Lesser General Public
rem    License along with this library; if not, write to the Free Software
rem    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
rem
rem    Andreas Hilvarsson reserves the right to distribute this core under
rem    other licenses aswell.
rem ///////////////////////////////////////////////////////////////////////////

if not exist build mkdir build
cd build
if exist *.elf del *.elf
if exist *.out del *.out
if exist *.hex del *.hex
if exist *.lss del *.lss
avr-as -mmcu=attiny261 --gdwarf2 ../test.asm
avr-ld -o test.elf a.out
avr-objcopy -O ihex -R .eeprom  test.elf test.hex
avr-objdump -h -S test.elf > test.lss
cd ..