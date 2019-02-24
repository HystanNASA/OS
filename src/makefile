bootloader.bin: bootloader.asm printStr.asm readDisk.asm printh.asm
	nasm -f bin bootloader.asm -o bootloader.bin
	
clean:
	rm bootloader.bin

run:
	qemu-system-x86_64 bootloader.bin