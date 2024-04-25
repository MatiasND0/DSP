#include <stdio.h>
#include <stdbool.h>
#include <unistd.h>
#include <string.h>

#include "freertos/FreeRTOS.h"
#include "freertos/task.h"

#include "esp_system.h"
#include "esp_event.h"
#include "esp_log.h"

#include "driver/dac_cosine.h"
#include "esp_check.h"

static const char *TAG = "main";

void app_main(void)
{
    dac_cosine_handle_t chan0_handle;
    
    dac_cosine_config_t cos0_cfg = {
        .chan_id = DAC_CHAN_0,
        .freq_hz = 500, // It will be covered by 8000 in the latter configuration
        .clk_src = DAC_COSINE_CLK_SRC_DEFAULT,
        .offset = 0,
        .phase = DAC_COSINE_PHASE_0,
        .atten = DAC_COSINE_ATTEN_DEFAULT,
        .flags.force_set_freq = false,
    };

    ESP_ERROR_CHECK(dac_cosine_new_channel(&cos0_cfg, &chan0_handle));
    ESP_ERROR_CHECK(dac_cosine_start(chan0_handle));

    printf("DAC inicializado con \nf=%ld\noffset=%d\nphase=%d",cos0_cfg.freq_hz,cos0_cfg.offset,cos0_cfg.phase);

    while (1)
    {
        vTaskDelay(pdMS_TO_TICKS(100));
    }
    
}
