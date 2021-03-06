# exemplo de registro
#	nome: string de ateh 30 caracteres + caractere de final de string = 31 bytes
#	idade: tipo inteiro de 4 bytes
#	CPF:	11 caracteres + 1 final de string = 12 bytes ou 4 bytes para 1 inteiro
#	Genero: masculino ou feminimo -> M ou F -> 1 byte -> 4 bytes
#	prox: 4 bytes para conter o endereco do proximo registro
#	
#	total de bytes: 55 bytes

#nome completo, 
#endereço (rua, número, bairro, CEP, cidade, telefone, Email), 
#data de nascimento, 
#gênero, 
#CPF, RG, data de contratação, cargo e salário.

#MODOS:
#1 -> Inserção
#2 -> Remoção
#3 -> Consulta
#4 -> Relatório (printar todos regs)

.section .data

	titgeral: .asciz "\n*** APLICAÇÃO DE LISTA DE REGISTROS DE RH ***"
	titinser: .asciz "\nINSERÇÃO: "
	titremov: .asciz "\nREMOÇÃO: "
	titmostra: .asciz "\nREGISTROS DA LISTA: "
	titreg: .asciz "\nRegistro numero %d: "

	menu: .asciz "\n1-Inserção\n2-Remoção\n3-Consulta\n4-Relatório\n0-Sair\n> "

	msgerro: .asciz "\nOpcao incorreta!\n"
	msgvazia: .asciz "\nLista vazia"
	msgremov: .asciz "\nRegistro removido!"
	msginser: .asciz "\nRegistro inserido!"
	
	pedenome: .asciz "\nDigite o nome: "
	pededatanasc: .asciz "\nDigite a data de nascimento: "
	pedesexo: .asciz "\nQual o sexo, <f>eminino ou <m>asculino? "
	pedecpf: .asciz "\nDigite o cpf: "
	pederg: .asciz "\nDigite o rg: "
	pededatacont: .asciz "\nDigite a data da contratação: "
	pedecargo: .asciz "\nDigite o nome do cargo: "
	pedesalario: .asciz "\nEntre com o valor do salario: "
	pederua: .asciz "\nEntre com o nome da rua: "
	pedenum: .asciz "\nInforme o número do endereço: "
	pedebairro: .asciz "\nDigite o nome do bairro: "
	pedecidade: .asciz "\nCidade: "
	pedetel: .asciz "\nInforme o número de telefone: "
	pedemail: .asciz "\nDigite o endereço de email: "

	nome_consulta:	.space 44
	nome_remove: 	.space 44

	mostranome: .asciz "\nNome: %s"
	mostraidade: .asciz "\nIdade: %d"
	mostrasexo: .asciz "\nSexo: %c"
	mostracpf: .asciz "\nCPF: %s"
	abert_consulta:	.asciz	"\nEntre com um nome para consultar seu registro: "
	abert_remove:	.asciz	"\nEntre com um nome para remover seu registro: "

	mostrapt: .asciz "\nptlista = %d"

	formastr: .asciz "%s"
	formach: .asciz "%c"
	formanum: .asciz "%d"

	pulalin: .asciz "\n"

	NULL: .int 0

	opcao: .int 0

	regtam: .int 84
	lista: .int NULL
	ptreg: .int NULL
	ptratual: .int NULL
	ptrant: .int NULL
	ptrfim: .int NULL

.section .text

.globl _start
_start:
	jmp main

#CONSULTA NOME#
consulta:
	pushl $abert_consulta
	call printf
	pushl $nome_consulta
	call gets
	addl $8, %esp

	jmp procura

mostra_reg:
	pushl $mostranome
	call printf
	add $4, %esp

	popl %edi		#recupera %edi
	addl $44, %edi		#avanca para o proximo campo
	pushl %edi		#armazena na lista

	pushl (%edi)
	pushl $mostraidade
	call printf
	addl $8, %esp

	popl %edi
	addl $8, %edi
	pushl %edi

	pushl (%edi)
	pushl $mostrasexo
	call printf
	addl $8, %esp

	popl %edi
	addl $4, %edi
	pushl %edi

	pushl $mostracpf
	call printf
	addl $4, %esp

	popl %edi
	subl $56, %edi

	jmp fimconsulta

percorre_dados:
	pushl %edi		#endereco inicial do registro, contendo todos os campos
	pushl $nome_consulta
	call strcmp
	addl $4, %esp
	cmpl $0, %eax
	jz mostra_reg

	popl %edi		#recupera %edi
	addl $44, %edi		#avanca para o proximo campo
	pushl %edi		#armazena na lista

	popl %edi
	addl $8, %edi
	pushl %edi

	popl %edi
	addl $4, %edi
	pushl %edi

	popl %edi
	subl $56, %edi

	RET

procura:

	pushl $titmostra
	call printf

	movl lista, %edi 
	cmpl $NULL, %edi
	jnz continua3

	pushl $msgvazia
	call printf
	addl $4, %esp

	ret

continua3:

	movl lista, %edi
	movl $1, %ecx

volta2:
	cmpl $NULL, %edi
	jz menuop

	pushl %edi
	pushl %ecx

	movl 4(%esp), %edi		#recupera %edi sem desempilhar
	call percorre_dados

	popl %ecx
	incl %ecx
	popl %edi
	movl 80(%edi), %edi

	jmp volta2

	ret

fimconsulta:
	ret
	
#INSERIR REG#
procura_pos:

	movl %eax, ptrant
	movl 80(%eax), %ebx
	movl %ebx, ptratual

	pushl lista
	pushl %edi
	call strcasecmp
	addl $8, %esp
	cmpl $0, %eax
	jle inserirnoinicio
	
	pushl ptrfim
	pushl %edi
	call strcasecmp
	addl $8, %esp
	cmpl $0, %eax
	jge inserirnofim

avanca:
	movl ptratual, %eax
	cmpl %eax, ptrfim
	je inserenomeio

	movl %eax, ptratual
	pushl ptratual
	pushl %edi
	call strcasecmp
	addl $8, %esp
	cmpl $0, %eax
	jle inserenomeio

	movl ptratual, %eax
	movl %eax, ptrant
	movl 80(%eax), %ebx
	movl %ebx, ptratual
	jmp avanca

inserenomeio:
	movl ptratual, %eax
	movl ptrant, %esi
	movl %edi, 80(%esi)
	movl %eax, 80(%edi)
	pushl $msginser
	call printf
	addl $4, %esp
	jmp menuop

inserirnoinicio:
	movl lista, %esi
	movl %esi, 80(%edi)
	movl %edi, lista
	pushl $msginser
	call printf
	addl $4, %esp
	jmp menuop

inserirnofim:
	movl ptrfim, %eax
	movl %edi, 80(%eax)
	movl %edi, ptrfim
	pushl $msginser
	call printf
	addl $4, %esp
	jmp menuop

novo_reg:

	pushl $titinser
	call printf

	movl regtam, %ecx
	pushl %ecx
	call malloc
	movl %eax, ptreg

	addl $8, %esp
	movl ptreg, %edi
	call le_dados

	movl lista, %eax
	cmpl $NULL, %eax
	jne procura_pos	
	movl %eax, 80(%edi)	#move a lista para o final do novo reg
	movl %edi, lista	#move uma copia de edi para lista
	movl %edi, ptrfim

	pushl $msginser
	call printf
	addl $4, %esp

	jmp menuop

le_dados:
	pushl %edi		#endereço inicial registro

	pushl $pedenome
	call printf
	addl $4, %esp
	call gets

	popl %edi		#recupera %edi
	addl $44, %edi		#avanca para o proximo campo
	pushl %edi		#armazena na lista

	pushl $pedeidade
	call printf
	addl $4, %esp
	pushl $formanum
	call scanf
	addl $4, %esp

	popl %edi		#recupera %edi
	addl $8, %edi		#avanca para o proximo campo
	pushl %edi		#armazena na lista
	
	pushl $formach		#para remover o enter
	call scanf
	addl $4, %esp

	pushl $pedesexo
	call printf
	addl $4, %esp
	pushl $formach
	call scanf
	addl $4, %esp

	popl %edi		#recupera %edi
	addl $4, %edi		#avanca para o proximo campo
	pushl %edi		#armazena na pilha

	pushl $formach		#para remover o enter
	call scanf
	addl $4, %esp
	
	pushl $pedecpf
	call printf
	addl $4, %esp
	call gets

	popl %edi		#recupera %edi
	addl $24, %edi		#avanca para o proximo campo
	movl $NULL, (%edi)
	
	subl $80, %edi		#retorna o edi para o estado inicial

	RET

#REMOVER REG#
remover_reg:
	pushl $titremov
	call printf
	addl $4, %esp

	pushl $abert_remove
	call printf
	pushl $nome_remove
	call gets
	addl $8, %esp

	movl lista, %edi
	cmpl $NULL, %edi
	jnz continua

	pushl $msgvazia
	call printf
	addl $4, %esp

	jmp menuop

removeprimeiro:
	movl lista, %edi
	pushl %edi
	movl 80(%edi), %edi
	movl %edi, lista

	pushl $msgremov
	call printf
	addl $4, %esp

	call free
	addl $4, %esp

	jmp menuop

remove:
	movl ptrant, %esi
	movl 80(%edi), %eax
	movl %eax, 80(%esi)
	pushl %edi
	call free

	pushl $msgremov
	call printf
	addl $8, %esp
	jmp menuop

procurareg:
	pushl %edi
	pushl $nome_remove
	call strcmp
	addl $4, %esp
	cmpl $0, %eax
	jz remove
	movl %edi, ptrant

	popl %edi
	addl $44, %edi
	pushl %edi

	popl %edi 
	addl $8, %edi
	pushl %edi

	popl %edi
	addl $4, %edi
	pushl %edi

	popl %edi
	subl $56, %edi

	ret

continua:
	movl lista, %edi
	movl $1, %ecx

procurainicio:
	cmpl $NULL, %edi
	jz menuop
	pushl %edi
	pushl %ecx
	movl 4(%esp), %edi

	pushl %edi
	pushl $nome_remove
	call strcmp
	addl $4, %esp
	cmpl $0, %eax
	jz removeprimeiro
	movl %edi, ptrant

	popl %edi
	addl $44, %edi
	pushl %edi

	popl %edi 
	addl $8, %edi
	pushl %edi

	popl %edi
	addl $4, %edi
	pushl %edi

	popl %edi
	subl $56, %edi

	popl %ecx
	incl %ecx
	popl %edi
	movl 80(%edi), %edi

voltaremove:
	cmpl $NULL, %edi
	jz menuop
	
	pushl %edi
	pushl %ecx

	movl 4(%esp), %edi
	call procurareg

	popl %ecx
	incl %ecx
	popl %edi
	movl 80(%edi), %edi

	jmp voltaremove
	ret

#RELATORIO#
mostra_dados: 

	pushl %edi		#endereco inicial do registro, contendo todos os campos
	
	pushl $mostranome
	call printf
	addl $4, %esp

	popl %edi		#recupera %edi
	addl $44, %edi		#avanca para o proximo campo
	pushl %edi		#armazena na lista

	pushl (%edi)
	pushl $mostraidade
	call printf
	addl $8, %esp

	popl %edi
	addl $8, %edi
	pushl %edi

	pushl (%edi)
	pushl $mostrasexo
	call printf
	addl $8, %esp

	popl %edi
	addl $4, %edi
	pushl %edi

	pushl $mostracpf
	call printf
	addl $4, %esp

	popl %edi
	subl $56, %edi

	RET

relatorio:

	pushl $titmostra
	call printf

	movl lista, %edi 
	cmpl $NULL, %edi
	jnz continua2

	pushl $msgvazia
	call printf
	addl $4, %esp

	jmp menuop

continua2:

	movl lista, %edi
	movl $1, %ecx

volta:

	cmpl $NULL, %edi
	jz menuop

	pushl %edi

	pushl %ecx
	pushl $titreg
	call printf
	addl $4, %esp

	movl 4(%esp), %edi		#recupera %edi sem desempilhar
	call mostra_dados

	popl %ecx
	incl %ecx
	popl %edi
	movl 80(%edi), %edi

	jmp volta

	jmp menuop

#MENU#
menuop:

	pushl $menu
	call printf
	
	pushl $opcao	
	pushl $formanum
	call scanf

	addl $12, %esp
	
	pushl $formach			#para remover o enter
	call scanf
	addl $4, %esp

	cmpl $1, opcao
	jz novo_reg

	cmpl $2, opcao
	jz remover_reg

	cmpl $3, opcao
	jz consulta

	cmpl $4, opcao
	jz relatorio

	cmpl $0, opcao
	jz fim

	pushl $msgerro
	call printf
	addl $4, %esp

	jmp menuop

main:
	
	pushl $titgeral
	call printf
	jmp menuop

fim:
	pushl $0 
	call exit
