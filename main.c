#include <efi/efi.h>
#include <efi/efilib.h>

static void printargs(EFI_HANDLE ImageHandle)
{
	int  argc, i;
	CHAR16 **argv;

	argc = GetShellArgcArgv(ImageHandle, &argv);
	if (argc < 1)
		Print(L"No command line arguments\n");
	else
		Print(L"%d command line arguments\n", argc);
	for (i = 0; i < argc; ++i)
		Print(L"argv[%d]: %s\n", i, argv[i]);
}

EFI_STATUS
EFIAPI
efi_main (EFI_HANDLE ImageHandle, EFI_SYSTEM_TABLE *SystemTable) {

	InitializeLib(ImageHandle, SystemTable);
	Print(L"Hello world, compiled with gnu-efi\n");

	printargs(ImageHandle);

	return EFI_SUCCESS;
}
