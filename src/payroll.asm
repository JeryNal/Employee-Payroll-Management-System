.386
.model flat, stdcall
option casemap:none

include windows.inc
include kernel32.inc
include user32.inc
includelib kernel32.lib
includelib user32.lib

; Constants
STD_OUTPUT_HANDLE equ -11
STD_INPUT_HANDLE equ -10
GENERIC_READ equ 80000000h
GENERIC_WRITE equ 40000000h
OPEN_EXISTING equ 3
OPEN_ALWAYS equ 4
FILE_ATTRIBUTE_NORMAL equ 80h
FILE_END equ 2
MAX_NAME_LENGTH equ 50
MAX_NUMBER_LENGTH equ 10
MAX_SALARY_LENGTH equ 10
MAX_JOBGROUP_LENGTH equ 10
MAX_DEPARTMENT_LENGTH equ 2
BUFFER_SIZE equ 1024

; Error codes
ERROR_SUCCESS equ 0
ERROR_INVALID_PARAMETER equ 87
ERROR_FILE_NOT_FOUND equ 2
ERROR_ACCESS_DENIED equ 5

.data
    ; File handles and buffers
    hFile HANDLE ?
    hStdOut HANDLE ?
    hStdIn HANDLE ?
    
    ; File name
    szFileName db "employees.txt",0
    
    ; Menu options
    szMenu db "Employee Payroll Management System",13,10
           db "1. Add Employee",13,10
           db "2. View Employees",13,10
           db "3. Exit",13,10
           db "Enter your choice: ",0
    
    ; Input prompts
    szNamePrompt db "Enter employee name: ",0
    szNumberPrompt db "Enter employee number (EMPXXX): ",0
    szSalaryPrompt db "Enter salary: ",0
    szJobGroupPrompt db "Enter job group: ",0
    szDepartmentPrompt db "Enter department (1-5): ",13,10
                      db "1. Software Development & Engineering",13,10
                      db "2. Cybersecurity & Risk Management",13,10
                      db "3. Cloud Computing & Infrastructure",13,10
                      db "4. AI & Data Science",13,10
                      db "5. IT Support & Managed Services",13,10
                      db "Choice: ",0
    
    ; Error messages
    szError db "Error: ",0
    szFileError db "Error opening file",0
    szWriteError db "Error writing to file",0
    szReadError db "Error reading from file",0
    szInvalidChoice db "Invalid choice. Please try again.",0
    szInvalidName db "Invalid name. Name cannot be empty.",0
    szInvalidNumber db "Invalid employee number. Must be in EMPXXX format.",0
    szInvalidSalary db "Invalid salary. Must be a positive number.",0
    szInvalidDepartment db "Invalid department. Must be between 1 and 5.",0
    
    ; Success messages
    szSuccess db "Operation completed successfully",0
    szEmployeeAdded db "Employee added successfully",0
    
    ; Input buffers
    szName db MAX_NAME_LENGTH dup(0)
    szNumber db MAX_NUMBER_LENGTH dup(0)
    szSalary db MAX_SALARY_LENGTH dup(0)
    szJobGroup db MAX_JOBGROUP_LENGTH dup(0)
    szDepartment db MAX_DEPARTMENT_LENGTH dup(0)
    szChoice db 2 dup(0)
    szBuffer db BUFFER_SIZE dup(0)
    
    ; Department names
    szDepartments db "Software Development & Engineering",0
                  db "Cybersecurity & Risk Management",0
                  db "Cloud Computing & Infrastructure",0
                  db "AI & Data Science",0
                  db "IT Support & Managed Services",0
    
    ; Format strings
    szEmployeeFormat db "Name: %s",13,10
                     db "Number: %s",13,10
                     db "Salary: %s",13,10
                     db "Job Group: %s",13,10
                     db "Department: %s",13,10
                     db "------------------------",13,10,0

.code
; Error handling procedure
HandleError proc
    push ebp
    mov ebp, esp
    
    invoke GetLastError
    test eax, eax
    jz @F
    
    invoke FormatMessage, FORMAT_MESSAGE_ALLOCATE_BUFFER or FORMAT_MESSAGE_FROM_SYSTEM,
                         NULL, eax, 0, addr szBuffer, BUFFER_SIZE, NULL
    
    invoke WriteConsole, hStdOut, offset szError, sizeof szError, NULL, NULL
    invoke WriteConsole, hStdOut, szBuffer, eax, NULL, NULL
    
    invoke LocalFree, szBuffer
    
@@:
    mov esp, ebp
    pop ebp
    ret
HandleError endp

; Input validation procedures
ValidateName proc
    push ebp
    mov ebp, esp
    
    mov esi, offset szName
    mov ecx, MAX_NAME_LENGTH
    xor eax, eax
    
    @@:
    lodsb
    test al, al
    jz @F
    cmp al, ' '
    je @B
    cmp al, 13
    je @F
    cmp al, 10
    je @F
    inc eax
    loop @B
    
@@:
    test eax, eax
    jnz @F
    
    invoke WriteConsole, hStdOut, offset szInvalidName, sizeof szInvalidName, NULL, NULL
    mov eax, 0
    jmp done
    
@@:
    mov eax, 1
    
done:
    mov esp, ebp
    pop ebp
    ret
ValidateName endp

ValidateNumber proc
    push ebp
    mov ebp, esp
    
    mov esi, offset szNumber
    mov ecx, MAX_NUMBER_LENGTH
    
    ; Check EMP prefix
    lodsb
    cmp al, 'E'
    jne number_invalid
    lodsb
    cmp al, 'M'
    jne number_invalid
    lodsb
    cmp al, 'P'
    jne number_invalid
    
    ; Check 3 digits
    mov ecx, 3
    @@:
    lodsb
    cmp al, '0'
    jl number_invalid
    cmp al, '9'
    jg number_invalid
    loop @B
    
    mov eax, 1
    jmp number_done
    
number_invalid:
    invoke WriteConsole, hStdOut, offset szInvalidNumber, sizeof szInvalidNumber, NULL, NULL
    mov eax, 0
    
number_done:
    mov esp, ebp
    pop ebp
    ret
ValidateNumber endp

ValidateSalary proc
    push ebp
    mov ebp, esp
    
    mov esi, offset szSalary
    mov ecx, MAX_SALARY_LENGTH
    xor eax, eax
    
    @@:
    lodsb
    test al, al
    jz @F
    cmp al, '0'
    jl salary_invalid
    cmp al, '9'
    jg salary_invalid
    loop @B
    
@@:
    test eax, eax
    jnz @F
    
salary_invalid:
    invoke WriteConsole, hStdOut, offset szInvalidSalary, sizeof szInvalidSalary, NULL, NULL
    mov eax, 0
    jmp salary_done
    
@@:
    mov eax, 1
    
salary_done:
    mov esp, ebp
    pop ebp
    ret
ValidateSalary endp

ValidateDepartment proc
    push ebp
    mov ebp, esp
    
    mov al, [szDepartment]
    sub al, '0'
    cmp al, 1
    jl dept_invalid
    cmp al, 5
    jg dept_invalid
    
    mov eax, 1
    jmp dept_done
    
dept_invalid:
    invoke WriteConsole, hStdOut, offset szInvalidDepartment, sizeof szInvalidDepartment, NULL, NULL
    mov eax, 0
    
dept_done:
    mov esp, ebp
    pop ebp
    ret
ValidateDepartment endp

main proc
    ; Get standard handles
    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov hStdOut, eax
    invoke GetStdHandle, STD_INPUT_HANDLE
    mov hStdIn, eax

menu_loop:
    ; Display menu
    invoke WriteConsole, hStdOut, offset szMenu, sizeof szMenu, NULL, NULL
    
    ; Get user choice
    invoke ReadConsole, hStdIn, offset szChoice, sizeof szChoice, NULL, NULL
    
    ; Process choice
    mov al, [szChoice]
    cmp al, '1'
    je add_employee
    cmp al, '2'
    je view_employees
    cmp al, '3'
    je exit_program
    
    ; Invalid choice
    invoke WriteConsole, hStdOut, offset szInvalidChoice, sizeof szInvalidChoice, NULL, NULL
    jmp menu_loop

add_employee:
    ; Get and validate employee details
    invoke WriteConsole, hStdOut, offset szNamePrompt, sizeof szNamePrompt, NULL, NULL
    invoke ReadConsole, hStdIn, offset szName, sizeof szName, NULL, NULL
    call ValidateName
    test eax, eax
    jz add_employee
    
    invoke WriteConsole, hStdOut, offset szNumberPrompt, sizeof szNumberPrompt, NULL, NULL
    invoke ReadConsole, hStdIn, offset szNumber, sizeof szNumber, NULL, NULL
    call ValidateNumber
    test eax, eax
    jz add_employee
    
    invoke WriteConsole, hStdOut, offset szSalaryPrompt, sizeof szSalaryPrompt, NULL, NULL
    invoke ReadConsole, hStdIn, offset szSalary, sizeof szSalary, NULL, NULL
    call ValidateSalary
    test eax, eax
    jz add_employee
    
    invoke WriteConsole, hStdOut, offset szJobGroupPrompt, sizeof szJobGroupPrompt, NULL, NULL
    invoke ReadConsole, hStdIn, offset szJobGroup, sizeof szJobGroup, NULL, NULL
    
    invoke WriteConsole, hStdOut, offset szDepartmentPrompt, sizeof szDepartmentPrompt, NULL, NULL
    invoke ReadConsole, hStdIn, offset szDepartment, sizeof szDepartment, NULL, NULL
    call ValidateDepartment
    test eax, eax
    jz add_employee
    
    ; Open file for appending
    invoke CreateFile, offset szFileName, GENERIC_WRITE, 0, NULL, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL
    mov hFile, eax
    cmp eax, INVALID_HANDLE_VALUE
    je file_error
    
    ; Write employee data
    invoke SetFilePointer, hFile, 0, NULL, FILE_END
    invoke WriteFile, hFile, offset szName, sizeof szName, NULL, NULL
    invoke WriteFile, hFile, offset szNumber, sizeof szNumber, NULL, NULL
    invoke WriteFile, hFile, offset szSalary, sizeof szSalary, NULL, NULL
    invoke WriteFile, hFile, offset szJobGroup, sizeof szJobGroup, NULL, NULL
    invoke WriteFile, hFile, offset szDepartment, sizeof szDepartment, NULL, NULL
    
    ; Close file
    invoke CloseHandle, hFile
    
    ; Show success message
    invoke WriteConsole, hStdOut, offset szEmployeeAdded, sizeof szEmployeeAdded, NULL, NULL
    jmp menu_loop

view_employees:
    ; Open file for reading
    invoke CreateFile, offset szFileName, GENERIC_READ, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL
    mov hFile, eax
    cmp eax, INVALID_HANDLE_VALUE
    je file_error
    
    ; Read and display employee data
    invoke ReadFile, hFile, offset szBuffer, BUFFER_SIZE, NULL, NULL
    test eax, eax
    jz read_error
    
    invoke WriteConsole, hStdOut, offset szBuffer, BUFFER_SIZE, NULL, NULL
    
    ; Close file
    invoke CloseHandle, hFile
    jmp menu_loop

file_error:
    invoke WriteConsole, hStdOut, offset szError, sizeof szError, NULL, NULL
    invoke WriteConsole, hStdOut, offset szFileError, sizeof szFileError, NULL, NULL
    call HandleError
    jmp menu_loop

read_error:
    invoke WriteConsole, hStdOut, offset szError, sizeof szError, NULL, NULL
    invoke WriteConsole, hStdOut, offset szReadError, sizeof szReadError, NULL, NULL
    call HandleError
    invoke CloseHandle, hFile
    jmp menu_loop

exit_program:
    invoke ExitProcess, 0

main endp
end main 