.data
# Tape with 30000 cells initialized to 0
tape:   .space 30000

# Example Brainfuck code: +++++++++[>++++++++<-]>+.+.
code:   .asciiz "+++++++++[>++++++++<-]>+.+."

.text
.globl main
main:
    # Initialize pointers
    la $t0, tape      # $t0 = data pointer (tape)
    la $t1, code      # $t1 = instruction pointer (code)

interpret_loop:
    lb $t2, 0($t1)       # Load current BF command
    beqz $t2, exit       # End of string (null terminator)

    # Handle each command
    li $t3, '>'          # >
    beq $t2, $t3, inc_ptr
    li $t3, '<'          # <
    beq $t2, $t3, dec_ptr
    li $t3, '+'          # +
    beq $t2, $t3, inc_val
    li $t3, '-'          # -
    beq $t2, $t3, dec_val
    li $t3, '.'          # .
    beq $t2, $t3, print_val
    li $t3, ','          # ,
    beq $t2, $t3, input_val
    li $t3, '['          # [
    beq $t2, $t3, loop_start
    li $t3, ']'          # ]
    beq $t2, $t3, loop_end

next_instr:
    addi $t1, $t1, 1     # Move to next instruction
    j interpret_loop

# >>>>>>>>>>>>>>>>>

inc_ptr:
    addi $t0, $t0, 1     # data_ptr++
    j next_instr

dec_ptr:
    addi $t0, $t0, -1    # data_ptr--
    j next_instr

inc_val:
    lb $t4, 0($t0)
    addi $t4, $t4, 1
    sb $t4, 0($t0)
    j next_instr

dec_val:
    lb $t4, 0($t0)
    addi $t4, $t4, -1
    sb $t4, 0($t0)
    j next_instr

print_val:
    lb $a0, 0($t0)
    li $v0, 11           # syscall: print char
    syscall
    j next_instr

input_val:
    li $v0, 12           # syscall: read char
    syscall
    sb $v0, 0($t0)
    j next_instr

# Simple loop control — only works with flat (non-nested) loops
loop_start:
    lb $t4, 0($t0)
    bnez $t4, next_instr     # if non-zero, enter loop
    # Skip to matching ']'
find_closing:
    addi $t1, $t1, 1
    lb $t5, 0($t1)
    li $t3, ']'
    bne $t5, $t3, find_closing
    addi $t1, $t1, 1     # move past ']'
    j interpret_loop

loop_end:
    lb $t4, 0($t0)
    beqz $t4, next_instr     # if zero, exit loop
    # Jump back to matching '['
find_opening:
    addi $t1, $t1, -1
    lb $t5, 0($t1)
    li $t3, '['
    bne $t5, $t3, find_opening
    j interpret_loop

exit:
    li $v0, 10
    syscall
