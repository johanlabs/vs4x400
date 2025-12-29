# Whitepaper: Vector-K Architecture

## Abstract
This paper presents **Vector-K**, a specialized dual-core hardware accelerator designed for high-efficiency vector similarity search on edge devices. By implementing a dedicated Multiply-Accumulate (MAC) pipeline with AXI-Lite integration, Vector-K achieves significant speedups in k-NN (k-Nearest Neighbors) tasks compared to general-purpose CPUs, while maintaining a minimal silicon footprint.

## 1. Introduction
As semantic search and AI embeddings move from the cloud to the edge, the demand for energy-efficient vector operations has surged. Traditional CPUs struggle with the parallel nature of dot-product calculations. Vector-K addresses this by providing an autonomous engine that offloads these tasks from the main application processor.

## 2. Architecture
Vector-K utilizes a **Dual-Core MAC** architecture:
- **Cycle Efficiency:** Processes 2 dimensions per clock cycle.
- **Precision:** Optimized for `int8` quantization to reduce memory bandwidth.
- **Autonomous Search:** The core iterates through the internal SRAM without CPU intervention after the initial trigger.



## 3. Performance Metrics
Initial benchmarks at 100MHz indicate a latency of approximately:
$$L = \frac{N \times (D/2 + 2)}{f}$$
Where:
- $N$: Number of vectors
- $D$: Dimensions
- $f$: Clock frequency

Compared to Python-based execution, Vector-K reduces execution time by up to 50x in embedded scenarios.

## 4. Conclusion
Vector-K is a viable candidate for integration into modern SoCs (System-on-Chip) for smartphones and IoT devices, enabling private, fast, and low-power semantic computing.