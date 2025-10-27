#  Pipelined 8-Point 1D DCT Hardware Accelerator

##  Overview
This project implements a **pipelined hardware accelerator** for the **8-point 1D Discrete Cosine Transform (DCT)** in **Verilog**.  
It includes 4 computation stages with pipeline registers, control logic using CSR registers, and a testbench for simulation.  
The design is intended for **ASIC implementation**.

---

## Algoorithm 
## 📘 Overview
The **Discrete Cosine Transform (DCT-II)** is one of the most important transforms used in **image and video compression**, forming the core of standards such as **JPEG**, **MPEG**, and **HEVC**.

It converts image data from the **spatial domain** (pixel intensities) into the **frequency domain**, where most of the image’s visual information is concentrated in fewer coefficients — allowing efficient compression with minimal quality loss.

---

## 🧩 What is DCT-II?

For a 1D signal \( x[n] \) of length \( N \):

\[
X[k] = \sum_{n=0}^{N-1} x[n] \cos\left[\frac{\pi}{N}\left(n + \frac{1}{2}\right)k\right]
\]

for \( k = 0, 1, 2, ..., N-1 \).

The **2D DCT-II**, used for images, is obtained by applying the 1D DCT twice — first along rows, then along columns.

---

## 🖼️ Why Transform Images?

Images have **spatial redundancy** — nearby pixels often have similar values.  
The DCT helps by concentrating most of the image’s energy into **low-frequency coefficients**:

- **Low frequencies** → smooth areas (backgrounds)
- **High frequencies** → edges and textures

This makes it possible to:
- Store fewer coefficients
- Discard high-frequency details that are less perceptible to the human eye

---

## ⚙️ How DCT-II Is Used in Image Compression (JPEG Example)

### 1️⃣ Divide Image into Blocks
The image is divided into **8×8 pixel blocks**.

### 2️⃣ Apply 2D DCT-II
Each block is transformed into frequency coefficients:

\[
C(u,v) = \frac{1}{4}\alpha(u)\alpha(v)\sum_{x=0}^{7}\sum_{y=0}^{7}f(x,y)\cos\left[\frac{(2x+1)u\pi}{16}\right]\cos\left[\frac{(2y+1)v\pi}{16}\right]
\]

where \( f(x,y) \) is the pixel value and \( C(u,v) \) is the DCT coefficient.

### 3️⃣ Quantization
Each DCT coefficient is divided by a **quantization matrix** and rounded:

- Low frequencies → small quantization step (retain detail)
- High frequencies → large quantization step (discard small variations)

This step achieves **most of the compression**.

### 4️⃣ Entropy Coding
The quantized coefficients are encoded efficiently using **Run-Length Encoding** and **Huffman Coding**.

---

# ⚙️ Pipelined DCT Controller Architecture

## 🧠 Overview
This module implements a **4-stage pipelined architecture** for computing the **1D Discrete Cosine Transform (DCT)** efficiently in hardware.  
The system is designed around a **streaming handshake interface** and achieves high throughput by **decoupling input/output flow control** from the internal computation pipeline.

The design includes:
- A **4-stage pipelined DCT core** using **Canonical Signed Digit (CSD)** multiplication
- A **controller** that manages valid/ready handshakes and pipeline stalls
- Efficient **data forwarding and output registration** logic to maintain stability during stalls

---

### 🔄 Handshake Flow
The controller uses **AXI-like valid/ready signaling** for synchronization:

| Signal | Direction | Description |
|---------|------------|-------------|
| `data_in_valid` | Input | Indicates new input data is available |
| `data_in_ready` | Output | Indicates DCT can accept new data |
| `data_out_valid` | Output | Output data is valid |
| `data_out_ready` | Input | External module ready to accept result |

**Pipeline stall** occurs if `data_out_valid` is high but `data_out_ready` is low.  
This stall signal freezes both the DCT pipeline and output registers to maintain data coherency.

---


## ⚡ 4-Stage DCT Pipeline



This structure ensures **one new input can be accepted each clock cycle** (throughput = 1 block/cycle after pipeline fill).

---
