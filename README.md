# regionthree

region free loader for 3DS/3DSXL/2DS on firmware versions 9.0-9.4

loads games from other regions and runs them in YOUR language if possible !

video can be found here : https://www.youtube.com/watch?v=ZQwAEqSmU7w

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
- Do I need to connect to the internet every time I want to use this ? Yes.
- Do I need a flashcart/game/hardware for this ? No.
- Will this work on my New 3DS ? No, at the moment this only works on 3DS, 3DS XL and 2DS models.
- Will it ever work on the New 3DS ? Maybe. I don't plan on working on it, like, ever, but the code is out there now so...
- Will this break or brick my 3DS ? No. There's virtually 0 chance of that happening, all this runs is run of the mill usermode code, nothing dangerous. Nothing unusual is written to your NAND, nothing permanent is done. With that in mind, use at your own risk, I won't take responsibility if something weird does happen.
- Do you take donations ? No, I do not.
- How does it work ? See below.

### Technical stuff

Basically we use GW's entrypoint to get ROP (not code execution, either userland or kernel) under spider (that's what the browser applet is called). From there, we use the GPU DMA vuln to take over the download play application (this is done by overwriting the GSP interrupt handler funcptr table). The download play application has access to the ns:s service (spider does not), and we use that service to launch our out-of-region game.


For more detail on the webkit/spider exploit, visit http://yifan.lu/2015/01/10/reversing-gateway-ultra-first-stage-part-1/

For more detail on the GPU DMA exploit, visit http://smealum.net/?p=517

To build the ROP, use Kingcom's armips assembler https://github.com/Kingcom/armips

### Credits

- All ROP and code written on this repo written by smea
- ns:s region free booting trick found by yellows8
- Neatly packaged spider exploit by Gateway
- Bond697, sm, yifanlu for working on the GW payload so I wouldn't have to.
- Myria for helping with testing.
