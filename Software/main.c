#include "system.h"
#include "stdio.h"
#include "io.h"
#include <DE10_Lite_VGA_Driver.h>
#include <alt_types.h>

//
// Simple delay function
// ---------------------
// Creates a blocking delay based on an empty loop.
// This delay is *approximate* because it depends on compiler optimization
// and CPU clock frequency.
// Used here just for demonstration purposes.
//
void delay(int ms)
{
    volatile int i;
    for (i = 0; i < ms * 1000; i++);  // Roughly ~1 µs per iteration (platform dependent)
}

int main()
{
    unsigned int time = 0;   // Total elapsed time in seconds
    char text[] = "Klocka:"; // Label to display before the time (Swedish: "Clock:")
    char time_str[10];       // Buffer for formatted "HH:MM:SS" output


    //-----------------------------------------------------------------------
    // Initial screen message
    //-----------------------------------------------------------------------
    tty_print(50, 50, "Design: Menyar Hees", Col_White, Col_Black);
    delay(1000);   // Wait 1 second before starting the clock display


    //-----------------------------------------------------------------------
    // Main loop
    //-----------------------------------------------------------------------
    while (1)
    {
        //
        // Convert the elapsed time (in seconds) into hours, minutes, seconds
        //
        int hours   = time / 3600;          // 1 hour = 3600 seconds
        int minutes = (time % 3600) / 60;   // remainder converted to minutes
        int seconds = time % 60;            // remainder converted to seconds

        //
        // Format the time as a string:
        // Example: "01:23:45"
        //
        sprintf(time_str, "%02d:%02d:%02d", hours, minutes, seconds);

        //
        // Clear previous text on the VGA screen before writing new content.
        // (Spaces overwrite old characters)
        //
        tty_print(100, 100, "       ", Col_White, Col_Black);   // Clear "Klocka:"
        tty_print(100, 120, "        ", Col_White, Col_Black);  // Clear previous time value

        //
        // Print the time label and the formatted HH:MM:SS value
        //
        tty_print(100, 100, text, Col_White, Col_Black);
        tty_print(100, 120, time_str, Col_White, Col_Black);

        //
        // Increment total elapsed time by 1 second
        //
        time++;

        //
        // Wait 1 second before next update
        //
        delay(1000);
    }

    return 0;
}
