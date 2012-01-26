from __future__ import print_function

import random

from myhdl import (
    enum,
    intbv,

    Simulation,
    Signal,

    bin,
    traceSignals,

    delay,
    instance,
    always,
    always_comb,
)

from common import (
    data_bus,
)

def Rom(dout, addr, CONTENT):

    @always_comb
    def read():
        dout.next = CONTENT[int(addr)]

    return read

CONTENT = (17, 134, 52, 9)
dout = Signal(intbv(0)[8:])
addr = Signal(intbv(0)[4:])

if __name__ == '__main__':
    from myhdl import toVHDL
    toVHDL(Rom, dout, addr, CONTENT)
