#include "vs4x400.h"
#include <stdio.h>

void update_database_octa(uint32_t addr, uint32_t part_lo, uint32_t part_hi) {
    V_REG_WRITE_ADDR = addr;
    V_REG_DATA_LO = part_lo;
    V_REG_DATA_HI = part_hi;
    V_REG_CTRL |= V_CTRL_COMMIT;
    V_REG_CTRL &= ~V_CTRL_COMMIT;
}

int main() {
    printf("VS4x400: Online\n");

    update_database_octa(0, 0x04030201, 0x08070605);

    V_REG_CTRL = V_CTRL_START;
    while(V_REG_STAT & V_STAT_BUSY);

    printf("Search Complete. Winner ID: %u, Score: %d\n", 
            (unsigned int)V_REG_ID, (int)V_REG_MAX_SCORE);
    return 0;
}