import numpy as np
import os

def quantize_to_int8(data):
    return np.round(np.clip(data * 127, -128, 127)).astype(np.int8)

if __name__ == "__main__":
    query = np.random.uniform(-1, 1, 8).astype(np.float32)
    db = [np.random.uniform(-1, 1, 8).astype(np.float32) for _ in range(3)]

    os.makedirs('sim', exist_ok=True)
    
    with open('sim/query.hex', 'w') as f:
        for val in quantize_to_int8(query): f.write(f"{val.tobytes().hex()}\n")

    with open('sim/database.hex', 'w') as f:
        for vec in db:
            for val in quantize_to_int8(vec): f.write(f"{val.tobytes().hex()}\n")

    print("✅ Success.")