# AVR-Assembly-Make
Learning ASM on AVR and Makefiles

# Make Commands

To compile
``` Bash
make
````
To flash
``` Bash
make flash
````
To clean directories
``` Bash
make clean
````

## WSL Link ATMega328

[Microsoft - WSL - Connect USB](https://learn.microsoft.com/en-us/windows/wsl/connect-usb)

Windows CMD
``` PowerShell
usbipd list
````

``` PowerShell
usbipd attach --wsl --busid <busid>
````

Linux Terminal
``` Bash
lsusb
````