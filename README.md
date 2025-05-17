# ✅ MIPS Cheat Sheet (Beginner-Friendly)

---

## 📌 BASIC TERMS

* **Register**: Small storage inside CPU (32 total)
* **Memory**: Large storage (RAM), slower than registers
* **Word**: 4 bytes (MIPS uses word-aligned memory)
* **Immediate**: A number written directly in the instruction
* **PC**: Program counter, stores current instruction address

---

## 🧠 REGISTER NAMES

| Name      | Number      | Usage                  |
| --------- | ----------- | ---------------------- |
| `$zero`   | 0           | Always 0               |
| `$t0-$t9` | 8–15, 24–25 | Temporary              |
| `$s0-$s7` | 16–23       | Saved across functions |
| `$a0-$a3` | 4–7         | Function arguments     |
| `$v0-$v1` | 2–3         | Function return values |
| `$ra`     | 31          | Return address         |
| `$sp`     | 29          | Stack pointer          |
| `$fp`     | 30          | Frame pointer          |

---

## ➕ ARITHMETIC

| Instruction        | Meaning         |
| ------------------ | --------------- |
| `add $d, $s, $t`   | `$d = $s + $t`  |
| `sub $d, $s, $t`   | `$d = $s - $t`  |
| `addi $d, $s, imm` | `$d = $s + imm` |
| `mul $d, $s, $t`   | `$d = $s × $t`  |

---

## 🔢 LOGICAL (Bitwise Ops)

| Instruction        | Meaning              |
| ------------------ | -------------------- |
| `and $d, $s, $t`   | `$d = $s AND $t`     |
| `or $d, $s, $t`    | `$d = $s OR $t`      |
| `nor $d, $s, $t`   | `$d = NOT($s OR $t)` |
| `andi $d, $s, imm` | `$d = $s AND imm`    |
| `ori $d, $s, imm`  | `$d = $s OR imm`     |

---

## 🔁 SHIFTING

| Instruction         | Meaning                          |
| ------------------- | -------------------------------- |
| `sll $d, $t, shamt` | Shift left (`$d = $t << shamt`)  |
| `srl $d, $t, shamt` | Shift right (`$d = $t >> shamt`) |

> `sll $t1, $t0, 2` means multiply \$t0 by 4

---

## 💾 MEMORY ACCESS

| Instruction         | Meaning                     |
| ------------------- | --------------------------- |
| `lw $t, offset($s)` | Load word from memory       |
| `sw $t, offset($s)` | Store word to memory        |
| `lb/lbu`            | Load byte (signed/unsigned) |
| `lh/lhu`            | Load halfword               |
| `sb`                | Store byte                  |
| `sh`                | Store halfword              |

> Example: `lw $t0, 8($s1)` loads word at address `$s1 + 8`

---

## 🧮 COMPARISONS

| Instruction         | Meaning                       |
| ------------------- | ----------------------------- |
| `beq $s, $t, label` | If `$s == $t`, jump           |
| `bne $s, $t, label` | If `$s != $t`, jump           |
| `slt $d, $s, $t`    | `$d = 1` if `$s < $t`, else 0 |
| `slti $d, $s, imm`  | Same, but with a constant     |
| `sltu`, `sltiu`     | Unsigned version              |

---

## 🚀 JUMPS

| Instruction | Meaning                            |
| ----------- | ---------------------------------- |
| `j label`   | Jump to label                      |
| `jal label` | Jump to function, save return addr |
| `jr $ra`    | Return from function               |

---

## 📞 FUNCTION CALLING

### Before calling:

* Put arguments in `$a0-$a3`
* Use `jal func`

### Inside the function:

* Save `$ra`, `$s0-$s7` if used
* Do stuff
* Return result in `$v0`
* Use `jr $ra`

---

## 🌿 LEAF PROCEDURE (doesn’t call others)

```mips
leaf_example:
  addi $sp, $sp, -4
  sw   $s0, 0($sp)
  add  $t0, $a0, $a1
  sub  $s0, $t0, $a2
  move $v0, $s0
  lw   $s0, 0($sp)
  addi $sp, $sp, 4
  jr   $ra
```

---

## 🌳 NON-LEAF PROCEDURE (calls others, like recursion)

```mips
fact:
  addi $sp, $sp, -8
  sw   $ra, 4($sp)
  sw   $a0, 0($sp)
  slti $t0, $a0, 1
  beq  $t0, $zero, L1
  li   $v0, 1
  addi $sp, $sp, 8
  jr   $ra
L1:
  addi $a0, $a0, -1
  jal  fact
  lw   $a0, 0($sp)
  lw   $ra, 4($sp)
  mul  $v0, $a0, $v0
  addi $sp, $sp, 8
  jr   $ra
```

---

## 🔡 STRING COPY

```mips
strcpy:
  addi $s0, $zero, 0
L1:
  add  $t1, $s0, $a1    # y[i]
  lbu  $t2, 0($t1)
  add  $t3, $s0, $a0    # x[i]
  sb   $t2, 0($t3)
  beq  $t2, $zero, L2
  addi $s0, $s0, 1
  j    L1
L2:
  jr $ra
```

---

## 💡 PSEUDOINSTRUCTIONS

| Shortcut        | Real Instructions                       |
| --------------- | --------------------------------------- |
| `move $d, $s`   | `add $d, $s, $zero`                     |
| `li $d, imm`    | `addi $d, $zero, imm` or `lui` + `ori`  |
| `blt $s, $t, L` | `slt $at, $s, $t` → `bne $at, $zero, L` |

---

## 🔐 SYNCHRONIZATION

Use when multiple processors use the same variable:

```mips
try:
  ll  $t1, 0($s1)
  sc  $t0, 0($s1)
  beq $t0, $zero, try
  move $s4, $t1
```

---

## 🔢 LOADING 32-BIT CONSTANTS

Use `lui` and `ori` to load full values:

```mips
lui $t0, 0x1234
ori $t0, $t0, 0x5678
```

---

## ⚠️ COMMON MISTAKES (Pitfalls)

* **Words = 4 bytes**, not 1. So A\[1] = 4(A)
* Don’t return pointer to local variable!
* Stack pointer (`$sp`) must be properly adjusted

---

## 💭 DESIGN PRINCIPLES

1. **Simplicity favors regularity**
2. **Smaller is faster**
3. **Make common case fast**
4. **Good design = good compromises**

---


