bootloader.bin: bootloader.asm printStr.asm readDisk.asm printh.asm testA20.asm enableA20.asm checklm.asm gdt.asm
	nasm -f bin bootloader.asm -o bootloader.bin
	
clean:
	rm bootloader.bin

run:
	qemu-system-x86_64 bootloader.bin