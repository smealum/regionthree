# regionthree
region free loader for 3DS/3DSXL/2DS on firmware versions 9.0-9.4

### How to use

- Download Launcher.dat from the repo (or compile it yourself) : https://github.com/smealum/regionthree/raw/master/Launcher.dat
- Copy Launcher.dat to the root of your SD card
- Insert the game you want to run into your 3DS and power it up
- Open the "Download Play" application
- Hit the home menu button, but do *not* exit the Download Play application (keep it running in the background)
- Open the Web Browser applet
- Go to Gateway's exploit page (not linking directly to it here because not a fan of their whole piracy thing they've got going)
- Wait a few seconds; screen should turn black and after a bit your game should boot up !

### FAQ

- Does this work on the latest firmware version ? Yes, 9.4 is supported.
- Does this let me run homebrew and/or roms ? No, it just lets you run legit physical games from other regions.
- Will this work on my New 3DS ? No, at the moment this only works on 3DS, 3DS XL and 2DS models.
- Do you take donations ? No, I do not.
- How does it work ? See below.

### Technical stuff

Basically we use GW's entrypoint to get ROP (not code execution, either userland or kernel) under spider (that's what the browser applet is called). From there, we use the GPU DMA vuln to take over the download play application (this is done by overwriting the GSP interrupt handler funcptr table). The download play application has access to the ns:s service (spider does not), and we use that service to launch our out-of-region game.

For more detail on the webkit/spider exploit, visit http://yifan.lu/2015/01/10/reversing-gateway-ultra-first-stage-part-1/
For more detail on the GPU DMA exploit, visit http://smealum.net/?p=517

### Credits

- All ROP and code written on this repo written by smea
- ns:s region free booting trick found by yellows8
- Neatly packaged spider exploit by Gateway
- Bond697, sm, yifanlu for working on the GW payload so I wouldn't have to.
