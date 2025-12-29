#ifndef VECTOR_K_H
#define VECTOR_K_H
#include <stdint.h>

#define VECTOR_K_BASE 0x40000000
#define V_REG_CTRL       (*(volatile uint32_t*)(VECTOR_K_BASE + 0x00))
#define V_REG_STAT       (*(volatile uint32_t*)(VECTOR_K_BASE + 0x0C))
#define V_REG_DATA_LO    (*(volatile uint32_t*)(VECTOR_K_BASE + 0x10))
#define V_REG_DATA_HI    (*(volatile uint32_t*)(VECTOR_K_BASE + 0x14))
#define V_REG_WRITE_ADDR (*(volatile uint32_t*)(VECTOR_K_BASE + 0x18))
#define V_REG_ID         (*(volatile uint32_t*)(VECTOR_K_BASE + 0x1C))
#define V_REG_MAX_SCORE  (*(volatile uint32_t*)(VECTOR_K_BASE + 0x20))

#define V_CTRL_START     (1 << 0)
#define V_CTRL_COMMIT    (1 << 1)
#define V_STAT_BUSY      (1 << 0)

#endif