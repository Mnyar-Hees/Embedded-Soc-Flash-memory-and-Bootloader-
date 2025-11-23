# Embedded-Soc-Flash-memory-and-Bootloader-
A hardware/software SoC design for the DE10-Lite board where a Nios II CPU reads program code from on-chip flash memory and drives VGA output. The project demonstrates a full HW/SW boot flow, custom VHDL top-level integration, and a C-based application running on the soft-core processor.
This project demonstrates how a complete SoC (System-on-Chip) can be built by combining hardware (VHDL) and software (C) on an FPGA.
The goal is to create a system that:

# Boots a Nios II CPU from internal flash memory

# Runs a software clock application written in C

# Uses a VGA driver to display time in real-time on screen

# Shows system status on LEDs

# Uses a clean and modular hardware/software architecture

# The project demonstrates a real embedded workflow:

# Custom hardware design in VHDL

# SoC generation in Platform Designer

# C application build using BSP drivers

# Flash programming and standalone boot

# Execution on FPGA hardware

🧩 System Architecture
Hardware (FPGA / VHDL)

Top-level wrapper for the SoC system

MAX10 clock input

Reset via SW(9)

LED output (LEDR)

VGA output:

VGA_R, VGA_G, VGA_B

HSYNC / VSYNC

Instantiation of the generated system:

Flash memory controller

VGA controller

Nios II processor

Interconnect, timers, and bridges

Software (C Program)

Runs on the Nios II CPU

Reads time (seconds → hours/min/sec)

Formats display as HH:MM:SS

Prints text onto VGA via driver library

Delay routine mimics 1-second ticks
