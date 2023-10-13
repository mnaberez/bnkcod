# Requirements:
#  - ASXXXX (https://shop-pdp.net/ashtml/asxxxx.php)
#  - SRecord (http://srecord.sourceforge.net/)

# default build target
all: bnkcod.bin diff

# assemble the source to a 2K binary
bnkcod.bin: bnkcod.asm
	as6500 -l -p -w -o bnkcod.asm
	aslink -i bnkcod
	srec_cat bnkcod.hex -intel -offset -0xa000 -fill 0xff 0 2048 -o bnkcod.bin -binary
	rm bnkcod.hlr bnkcod.hex bnkcod.rel

# show the assembler listing file
list: bnkcod.bin
	cat bnkcod.lst

# compare the assembled binary against the original binary
# "sp2516.bin" dumped by Chuck Hutchins
diff: bnkcod.bin
	echo "9281a2f7ec4fac9d27caaee35ed8b308de88b06c" > original.sha1
	openssl sha1 bnkcod.bin | cut -d ' ' -f 2 > bnkcod.sha1
	diff original.sha1 bnkcod.sha1

# remove all build artifacts
clean:
	rm -f *.bin *.hlr *.ihx *.lst *.rel *.rst *.sha1
