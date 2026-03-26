import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    clock = Clock(dut.clk, 10, unit="us")
    cocotb.start_soon(clock.start())

    dut._log.info("Reset")

    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0

    await ClockCycles(dut.clk, 10)

    dut.rst_n.value = 1

    dut._log.info("Running test")

    dut.ui_in.value = 20
    dut.uio_in.value = 30

    await ClockCycles(dut.clk, 5)

    dut._log.info(f"Output value: {dut.uo_out.value}")

    dut._log.info("Test completed")
