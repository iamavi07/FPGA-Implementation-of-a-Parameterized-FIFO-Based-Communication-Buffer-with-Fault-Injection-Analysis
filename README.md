# FPGA Implementation of a Parameterized FIFO-Based Communication Buffer with Fault Injection Analysis

A parameterized RTL implementation of a synchronous FIFO-based communication buffer featuring handshake-controlled data transfer, runtime fault injection, functional verification in ModelSim, and FPGA validation on the Intel (Altera) Cyclone V DE1-SoC development board.

---

## Project Overview

Reliable communication between digital hardware modules depends not only on data storage but also on correct flow-control mechanisms. While a FIFO guarantees ordered storage of data, reliable communication additionally requires protocol-based synchronization between producer and consumer modules.

This project extends a conventional synchronous FIFO into a communication-aware buffering system by introducing a **Valid-Ready handshake interface** and a **runtime-selectable fault injection mechanism**.

Two operating modes are implemented:

- **Normal Mode**
  - Communication follows the Valid-Ready protocol.
  - Overflow and underflow requests are prevented.
  - Ordered data transfer is maintained.

- **Fault Injection Mode**
  - Handshake protection is intentionally bypassed.
  - Invalid communication requests are generated.
  - The effect of protocol violations is observed while the FIFO core continues protecting memory integrity.

The complete design was verified through RTL simulation and validated on the Terasic DE1-SoC FPGA development board.

---

# Features

- Parameterized synchronous FIFO
- Configurable data width and FIFO depth
- Valid-Ready communication protocol
- Modular RTL architecture
- Runtime selectable fault injection
- Overflow and underflow protection
- Circular buffer implementation
- Full and Empty status generation
- ModelSim functional verification
- Intel Quartus Prime synthesis
- FPGA implementation on DE1-SoC
- Seven-segment display output
- Hardware validation
<img width="1536" height="1024" alt="FIFO-based communication system architecture" src="https://github.com/user-attachments/assets/c740cf71-fb5e-4919-9362-f29fdb5f48e3" />

---

# System Architecture

```
               +------------------------+
               |     Input Interface    |
               | valid_in   ready_out   |
               | data_in                |
               +-----------+------------+
                           |
                           v
                +-----------------------+
                | Communication Wrapper |
                | Valid-Ready Control   |
                | Fault Injection Logic |
                +-----------+-----------+
                            |
                            v
                 +----------------------+
                 | Parameterized FIFO   |
                 | Circular Buffer      |
                 | Full/Empty Detection |
                 +-----------+----------+
                             |
                             v
                +------------------------+
                |    Output Interface    |
                | valid_out   ready_in   |
                | data_out               |
                +------------------------+
```

---

# RTL Modules

## fifo_core.v

Implements a parameterized synchronous FIFO using circular addressing.

### Responsibilities

- Data storage
- Circular memory management
- Read pointer
- Write pointer
- Occupancy counter
- Full detection
- Empty detection

### Parameters

```
WIDTH = 8 bits
DEPTH = 16 words
```

---

## fifo_comm_wrapper.v

Implements communication-level flow control.

### Responsibilities

- Valid-Ready handshake
- Input buffering
- Output synchronization
- Runtime fault injection
- Communication control

The wrapper separates protocol logic from storage logic, improving modularity and scalability.

---

## fifo_system_top.v

Top-level FPGA integration module.

Interfaces include

- Clock
- Reset
- Input data
- Valid signal
- Ready signal
- Fault mode control

Outputs include

- Data output
- Ready output
- Valid output
- Full flag
- Empty flag

---

## fifo_system_tb.v

Self-contained testbench used for functional verification.

Simulation includes two operating phases:

### Phase 1

Fault Injection Mode

- Handshake bypass enabled
- Protocol violations generated
- Communication behaviour analysed

### Phase 2

Normal Mode

- Handshake enabled
- Correct communication restored
- Ordered FIFO operation verified

---

# Fault Injection Strategy

The project introduces protocol-level fault injection through a runtime control signal.

During normal operation

```
wr_en = valid_in && !full

rd_en = ready_in && !empty
```

During fault mode

```
wr_en = valid_in

rd_en = ready_in
```

This intentionally bypasses communication-level protection while the FIFO core continues preventing illegal memory accesses.

The objective is to study how incorrect control logic affects communication even when the storage hardware remains functionally correct.

---

# Simulation Results

Simulation was performed using Intel ModelSim Starter Edition.

Verified behaviour includes

- FIFO write operation
- FIFO read operation
- Simultaneous read/write
- Full detection
- Empty detection
- Handshake-controlled communication
- Fault mode behaviour
- Recovery to normal operation

Waveform analysis confirms

- Correct data ordering
- Stable handshake operation
- Controlled latency
- Predictable behaviour after fault recovery

---

# FPGA Validation

Target Board

**Terasic DE1-SoC**

FPGA Device

**Intel (Altera) Cyclone V SoC**

Implementation Flow

```
RTL Design

↓

Functional Simulation

↓

Quartus Compilation

↓

Pin Assignment

↓

Bitstream Generation

↓

FPGA Programming

↓

Hardware Validation
```

Hardware validation confirms successful implementation of both operating modes.

---

# Performance Summary

| Parameter | Value |
|------------|--------|
| Data Width | 8 bits |
| FIFO Depth | 16 words |
| FIFO Type | Synchronous |
| Read Latency | ~1–2 clock cycles |
| Throughput | ~1 word per clock |
| Flow Control | Valid-Ready Handshake |
| Fault Injection | Runtime Selectable |
| FPGA | Intel Cyclone V |

---

# Design Highlights

- Modular RTL architecture
- Parameterized implementation
- Clear separation between storage and communication logic
- Runtime protocol fault injection
- Synthesizable Verilog HDL
- FPGA validated implementation
- Scalable architecture suitable for larger communication systems

---

# Tools Used

- Verilog HDL
- Intel Quartus Prime
- Intel ModelSim Starter Edition
- Terasic DE1-SoC Development Board

---

# Future Improvements

Potential extensions include

- Asynchronous FIFO implementation
- Dual-clock communication support
- Error detection using parity or ECC
- AXI-Stream compatible interface
- UVM-based constrained random verification
- SystemVerilog Assertions (SVA)
- Functional coverage analysis
- DMA-based communication support

---

# Skills Demonstrated

- RTL Design
- Verilog HDL
- FPGA Prototyping
- Digital Communication Systems
- Flow-Control Design
- FIFO Architecture
- Hardware Verification
- Functional Simulation
- Quartus Synthesis
- Timing-aware Digital Design

---

# Author

**Avinash Tanti**

M.Tech – Communication Engineering and Networks (CEN)

National Institute of Technology Karnataka (NITK), Surathkal

---

If you found this project useful or have suggestions for improvement, feel free to open an issue or connect for discussion on FPGA and Digital Design.
