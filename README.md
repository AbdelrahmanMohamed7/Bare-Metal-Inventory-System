# Bare-Metal Inventory & Auto-Reorder Management System

A high-performance, ultra-low-overhead real-time inventory tracking application engineered entirely in **16-bit x86 Assembly Language (8086 Mnemonics)**. Operating directly within the MS-DOS environment via the **Turbo Assembler (TASM)** runtime, this system bypasses modern operating system abstractions to manipulate hardware registers, manage low-level file I/O operations, and process user interaction pipelines natively.

## 🛠️ Architectural & System Specifications
* **Instruction Architecture:** Intel 8086 Assembly Language (16-Bit Real Mode)
* **Development Toolkit:** Turbo Assembler (TASM) Core Engine & Linker Utility
* **Target Runtime Environment:** MS-DOS System API Architecture / DOSBox Emulator
* **Data Layer Management:** Plain-Text Flat-File Databases (`temp.txt` for product records, `temp1.txt` for stock arrays)

## 🏗️ Core Engineering Implementations

### 1. Low-Level File Stream Mapping (`LOAD_DATA` & `WRITE_DATA`)
Bypasses high-level language wrappers by intercepting **MS-DOS Interrupt 21H** routines. It utilizes **Service 3DH** for raw file handle acquisition and **Service 3FH** to read data streams sequentially from the flat-file database directly into pre-allocated physical system memory buffers.

### 2. Micro-Optimization Parsing Loops (`CHECK_INVENTORY_LEVELS`)
Leverages advanced pointer manipulation by controlling the **Source Index (SI)** register to step through raw string bytes. The application detects when a record's quantitative value dips below a static critical threshold (5 units) and automatically routes execution flags to trigger real-time auto-reorder alerts.

### 3. Hardware-Level ASCII Mathematics
Implements inline byte sanitization routines using subtraction mnemonics (`SUB AL, '0'`) to scrub raw character formatting read from disk. This normalizes ASCII strings into pure binary integers, enabling direct hardware-level CPU arithmetic and register comparisons (`CMP`).

### 4. Data Persistence Engine
Features a reliable data-flush routine built on **Service 40H**, ensuring modifications made to inventory boundaries are entirely written back to disk upon an application escape sequence (`ASK_TO_QUIT`), preventing data corruption or memory leaks.

## 📂 Repository File Structures
* `work.asm` - Core system application architecture and hardware event hooks.
* `temp.txt` - Flat-file structural database storing raw string product records.
* `temp1.txt` - Flat-file positional database tracking item quantity integer strings.

## 🚀 Execution Instructions
To run this 16-bit real-mode system application on modern platforms (macOS / Windows / Linux):
1. Install the **DOSBox Emulator**.
2. Mount your local project folder directory inside the DOSBox terminal shell environment.
3. Compile the application assembly engine:
   ```cmd
   tasm work.asm
