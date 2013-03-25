// $Id: hardware.h,v 1.3 2010-06-29 22:07:52 scipio Exp $

/*
 * Copyright (c) 2007-2008 The Regents of the University of
 * California.  All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * - Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the
 *   distribution.
 * - Neither the name of the copyright holders nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL
 * THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * Copyright (c) 2004-2005 Intel Corporation
 * All rights reserved.
 *
 * This file is distributed under the terms in the attached
 * INTEL-LICENSE file. If you do not find these files, copies can be
 * found by writing to Intel Research Berkeley, 2150 Shattuck Avenue,
 * Suite 1300, Berkeley, CA, 94704.  Attention: Intel License Inquiry.
 */

/**
 * Hardware definition for the Hemera platform.
 *
 * @author Brad Campbell
 */
#ifndef _H_hardware_h
#define _H_hardware_h

#include "msp430hardware.h"

#warning "platform hardware hemera"
// enum so components can override power saving,
// as per TEP 112.
enum {
  TOS_SLEEP_NONE = MSP430_POWER_ACTIVE,
};

// internal flash is 16 bits in width
typedef uint16_t in_flash_addr_t;
// external flash is 32 bits in width
typedef uint32_t ex_flash_addr_t;

void wait(uint16_t t) {
  for ( ; t > 0; t-- );
}

// LEDS
TOSH_ASSIGN_PIN(RED_LED, 4, 0);
TOSH_ASSIGN_PIN(GREEN_LED, 4, 3);
TOSH_ASSIGN_PIN(YELLOW_LED, 4, 7);

// CC2420 RADIO
TOSH_ASSIGN_PIN(RADIO_CSN, 4, 2);
TOSH_ASSIGN_PIN(RADIO_VREF, 4, 5);
TOSH_ASSIGN_PIN(RADIO_RESET, 4, 6);
TOSH_ASSIGN_PIN(RADIO_FIFOP, 1, 0);
TOSH_ASSIGN_PIN(RADIO_SFD, 4, 1);
TOSH_ASSIGN_PIN(RADIO_GIO0, 1, 3);
TOSH_ASSIGN_PIN(RADIO_FIFO, 1, 3);
TOSH_ASSIGN_PIN(RADIO_GIO1, 1, 4);
TOSH_ASSIGN_PIN(RADIO_CCA, 1, 4);

TOSH_ASSIGN_PIN(CC_FIFOP, 1, 0);
TOSH_ASSIGN_PIN(CC_FIFO, 1, 3);
TOSH_ASSIGN_PIN(CC_SFD, 4, 1);
TOSH_ASSIGN_PIN(CC_VREN, 4, 5);
TOSH_ASSIGN_PIN(CC_RSTN, 4, 6);

// USART0
TOSH_ASSIGN_PIN(SIMO0, 3, 1);
TOSH_ASSIGN_PIN(SOMI0, 3, 2);
TOSH_ASSIGN_PIN(UCLK0, 3, 3);

// USART1
TOSH_ASSIGN_PIN(SIMO1, 5, 1);
TOSH_ASSIGN_PIN(SOMI1, 5, 2);
TOSH_ASSIGN_PIN(UCLK1, 5, 3);

// UART1
TOSH_ASSIGN_PIN(UTXD0, 3, 4);
TOSH_ASSIGN_PIN(URXD0, 3, 5);
TOSH_ASSIGN_PIN(UTXD1, 3, 6);
TOSH_ASSIGN_PIN(URXD1, 3, 7);

// User Interupt Pin
TOSH_ASSIGN_PIN(USERINT, 2, 7);

// FLASH
TOSH_ASSIGN_PIN(FLASH_CS, 4, 4);

// 1-Wire
TOSH_ASSIGN_PIN(ONEWIRE, 2, 4);

// Voltage Regulator
TOSH_ASSIGN_PIN(VOLTAGE_REG, 5, 6);

// PIR Sensor
#define IO_PIR Port12
TOSH_ASSIGN_PIN(PIR, 1, 2);

// SHT11
#define IO_SHT11_VDD Port17
#define IO_SHT11_SCK Port16
#define IO_SHT11_DATA Port15
TOSH_ASSIGN_PIN(SHT11_VDD, 1, 7);
TOSH_ASSIGN_PIN(SHT11_SCK, 1, 6);
TOSH_ASSIGN_PIN(SHT11_DATA, 1, 5);

// Battery Voltage
#define IO_BATTERY_VOLTAGE Port60
TOSH_ASSIGN_PIN(BATTERY_VOLTAGE, 6, 0);

// External Connections
#define IO_EXT0 Port20
#define IO_EXT1 Port21
TOSH_ASSIGN_PIN(EXT0, 2, 0);
TOSH_ASSIGN_PIN(EXT1, 2, 1);

// BH17 Reset Line
#define IO_LIGHT_RST Port57
TOSH_ASSIGN_PIN(LIGHT_RST, 5, 7);

void TOSH_SET_PIN_DIRECTIONS(void)
{
  P3SEL = 0x0E; // set SPI and I2C to mod func
  
  P1DIR = 0xe0;
  P1OUT = 0x00;
  
  P2DIR = 0x7b;
  P2OUT = 0x10;
  
  P3DIR = 0xf1;
  P3OUT = 0x00;
  
  P4DIR = 0xfd;
  P4OUT = 0xdd;
  
  P5DIR = 0xff;
  P5OUT = 0xff;
  
  P6DIR = 0xff;
  P6OUT = 0x00;
}

// need to undef atomic inside header files or nesC ignores the directive
#undef atomic

#endif // _H_hardware_h
