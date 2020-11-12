SaludoPROC PROTO :DWORD

ImprimirTexto MACRO texto
	INVOKE StdOut, ADDR texto
ENDM