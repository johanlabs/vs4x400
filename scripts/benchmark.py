import numpy as np
import time
import statistics

CPU_POWER_W = 10.0
HW_POWER_W = 0.1
CLOCK_MHZ = 400
RUNS = 20

CONFIGS = [
    (1024, 128),
    (4096, 256),
    (8192, 512),
    (16384, 1024),
]

def benchmark_software(num_vectors, dim):
    times = []
    query = np.random.randint(-50, 50, size=(dim,), dtype=np.int8)
    db = np.random.randint(-50, 50, size=(num_vectors, dim), dtype=np.int8)
    _ = np.dot(db.astype(np.int32), query.astype(np.int32))

    for _ in range(RUNS):
        start = time.perf_counter()
        scores = np.dot(db.astype(np.int32), query.astype(np.int32))
        _ = np.argmax(scores)
        end = time.perf_counter()
        times.append((end - start) * 1000)
    return {"mean_ms": statistics.mean(times), "std_ms": statistics.stdev(times)}

def estimate_hardware(num_vectors, dim, cores=8):
    cycles_per_vector = (dim / cores)
    total_cycles = num_vectors * cycles_per_vector

    time_ms = (total_cycles / (CLOCK_MHZ * 1e6)) * 1000
    return {"cycles": int(total_cycles), "time_ms": time_ms}

def run():
    print("\n=== VECTOR-K v0.4.0: ZERO-OVERHEAD BENCHMARK ===\n")
    for num_vectors, dim in CONFIGS:
        sw = benchmark_software(num_vectors, dim)
        hw = estimate_hardware(num_vectors, dim)

        speedup = sw["mean_ms"] / hw["time_ms"]
        energy_sw = CPU_POWER_W * (sw["mean_ms"] / 1000) * 1000
        energy_hw = HW_POWER_W * (hw["time_ms"] / 1000) * 1000

        print(f"Config: N={num_vectors}, D={dim}")
        print(f"  Hardware Cycles: {hw['cycles']}")
        print(f"  Hardware Time:   {hw['time_ms']:.4f} ms")
        print(f"  Software Time:   {sw['mean_ms']:.4f} ms")
        print(f"  SPEEDUP:         {speedup:.2f}x")
        print(f"  ENERGY GAIN:     {(energy_sw/energy_hw):.1f}x\n")

if __name__ == "__main__":
    run()