-------------------------------------------------------------------------------
-- Project:       – SoC Flash System with VGA Output
-- File:           task_7_b.vhd
-- Description:    Top-level integration for an Intel MAX10 SoC system.
--                 
--                 This design instantiates the Qsys-generated component
--                 "flash_system", which includes:
--                     • A Nios II CPU
--                     • Flash memory interface
--                     • VGA display controller
--                     • LED output block
--                 
--                 This top-level file connects the SoC system to:
--                     • 50 MHz MAX10 system clock
--                     • Reset input (SW9)
--                     • LED outputs
--                     • VGA RGB + sync signals
--
-- Author:         Mnyar Hees
-- Date:           2025
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--===============================================================
-- Entity Declaration
--===============================================================
entity task_7_b is
    port (
        MAX10_CLK1_50 : in  std_logic;                     -- 50 MHz system clock
        SW            : in  std_logic_vector(9 downto 0);  -- Switches: SW(9) = reset

        LEDR          : out std_logic_vector(7 downto 0);  -- LED outputs

        -- VGA Output Signals
        VGA_B         : out std_logic_vector(3 downto 0);  -- Blue channel
        VGA_G         : out std_logic_vector(3 downto 0);  -- Green channel
        VGA_HS        : out std_logic;                     -- Horizontal sync
        VGA_R         : out std_logic_vector(3 downto 0);  -- Red channel
        VGA_VS        : out std_logic                      -- Vertical sync
    );
end entity;

--===============================================================
-- Architecture
--===============================================================
architecture rtl of task_7_b is

    ---------------------------------------------------------------------------
    -- Component Declaration: Qsys / Platform Designer System
    -- flash_system is generated from Platform Designer and contains:
    --     - CPU subsystem
    --     - VGA controller
    --     - LED output
    --     - Reset and clock adapters
    ---------------------------------------------------------------------------
    component flash_system is
        port (
            clk_clk       : in  std_logic;                      -- system clock
            led_export    : out std_logic_vector(7 downto 0);   -- LED output
            reset_reset_n : in  std_logic;                      -- active-low reset

            -- VGA signal group
            vga_vga_b     : out std_logic_vector(3 downto 0);   -- Blue
            vga_vga_g     : out std_logic_vector(3 downto 0);   -- Green
            vga_vga_hs    : out std_logic;                      -- H-sync
            vga_vga_r     : out std_logic_vector(3 downto 0);   -- Red
            vga_vga_vs    : out std_logic                       -- V-sync
        );
    end component;

begin

    ---------------------------------------------------------------------------
    -- Instantiate the Qsys SoC System
    -- SW(9) acts as active-low reset for the SoC.
    ---------------------------------------------------------------------------
    u0 : component flash_system
        port map (
            clk_clk       => MAX10_CLK1_50,  -- Connect 50 MHz clock
            reset_reset_n => SW(9),           -- Reset from switch SW9
            led_export    => LEDR,            -- LED output

            -- VGA color + sync
            vga_vga_b     => VGA_B,
            vga_vga_g     => VGA_G,
            vga_vga_hs    => VGA_HS,
            vga_vga_r     => VGA_R,
            vga_vga_vs    => VGA_VS
        );

end rtl;
