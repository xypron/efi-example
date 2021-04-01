ARCH            = $(shell uname -m | sed s,i[3456789]86,ia32,)

OBJS		= main.o
TARGET		= hello.efi

LIB		= /usr/lib
EFI_CRT_OBJS	= $(LIB)/crt0-efi-$(ARCH).o
EFI_LDS		= $(LIB)/elf_$(ARCH)_efi.lds

CFLAGS		= -fshort-wchar -fno-builtin -ffreestanding \
		  -fno-common -fno-stack-protector -fpic \
		  -Wall

ifeq ($(ARCH),x86_64)
  CFLAGS += -DEFI_FUNCTION_WRAPPER
endif

LDFLAGS         = -nostdlib -znocombreloc -T $(EFI_LDS) -shared \
		  -Bsymbolic -L $(LIB) $(EFI_CRT_OBJS)

all: $(TARGET)

hello.so: $(OBJS)
	ld $(LDFLAGS) $(OBJS) -o $@ -lefi -lgnuefi

%.efi: %.so
	objcopy -j .text -j .sdata -j .data -j .dynamic -j .dynsym \
		-j .rel -j .rela -j .rel.* -j .rela.* -j .rel* -j .rela* \
		-O binary $^ $@

clean:
	rm -f rm *.o *.so *.efi
