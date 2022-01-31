# Requirements:
#  - ASXXXX (https://shop-pdp.net/ashtml/asxxxx.php)
#  - SRecord (http://srecord.sourceforge.net/)

all: bnkcod.bin diff

bnkcod.bin: bnkcod.asm
	as6500 -l -p -w -o bnkcod.asm
	aslink -i bnkcod
	srec_cat bnkcod.ihx -intel -offset -0xa000 -fill 0xff 0 2048 -o bnkcod.bin -binary
	rm bnkcod.hlr bnkcod.ihx bnkcod.rel

clean:
	rm -f *.bin *.hlr *.ihx *.lst *.rel *.rst *.sha1

diff: bnkcod.bin
	echo "9281a2f7ec4fac9d27caaee35ed8b308de88b06c" > original.sha1
	openssl sha1 bnkcod.bin | cut -d ' ' -f 2 > bnkcod.sha1
	diff original.sha1 bnkcod.sha1
