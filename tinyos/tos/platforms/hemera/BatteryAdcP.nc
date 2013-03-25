#include "Msp430Adc12.h"

module BatteryAdcP {
	uses {
		interface Msp430Adc12SingleChannel as ReadSingleChannel;
		interface Resource as AdcResource;
	}
	provides {
	//	interface AdcConfigure<const msp430adc12_channel_config_t *> as AdcConfigure;
		interface Read<uint16_t> as ReadAdc;
	}
}
implementation {
	
	msp430adc12_channel_config_t config = {
		inch:			INPUT_CHANNEL_A0,			// hemera
	//	inch:			INPUT_CHANNEL_A4,			// irene
		sref:			REFERENCE_VREFplus_AVss,
		ref2_5v:		REFVOLT_LEVEL_2_5,
		adc12ssel:		SHT_SOURCE_ACLK,
		adc12div:		SHT_CLOCK_DIV_1,
		sht:			SAMPLE_HOLD_16_CYCLES,
		sampcon_ssel:	SAMPCON_SOURCE_ACLK,
		sampcon_id:		SAMPCON_CLOCK_DIV_1
	};
		
	command error_t ReadAdc.read () {
		call AdcResource.request();
		return SUCCESS;
	}
	
	event void AdcResource.granted () {
		call ReadSingleChannel.configureSingle(&config);
		call ReadSingleChannel.getData();
	}
	
	async event error_t ReadSingleChannel.singleDataReady (uint16_t data) {
		call AdcResource.release();
		atomic {
			signal ReadAdc.readDone(SUCCESS, data);
		}
		return SUCCESS;
	}
	
	async event uint16_t* COUNT_NOK(numSamples) ReadSingleChannel.multipleDataReady(uint16_t *COUNT(numSamples) buffer, uint16_t numSamples) {
		return NULL;
	}


//	async command const msp430adc12_channel_config_t* AdcConfigure.getConfiguration() {
//		return &config;
//	}

}
