#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "freertos/queue.h"

#include "driver/gpio.h"
#include "driver/adc.h"
#include "driver/dac_oneshot.h"
#include "driver/dac_continuous.h"
#include "driver/gptimer.h"

#include "esp_adc_cal.h"
#include <rom/ets_sys.h>

#include "esp_log.h"
#include "esp_sleep.h"
#include "sdkconfig.h"

#define WIDTH       ADC_WIDTH_BIT_12
#define ATTEN       ADC_ATTEN_DB_12
#define CHANNEL     ADC_CHANNEL_6

//#define DAC_ONESHOT

static void periodic_timer_callback(void* arg);

static const char* TAG = "main";

uint8_t buffer;
int aux;

//--------------------DAC_ONESHOT---------------------------//
dac_oneshot_handle_t chan0_handle;
dac_oneshot_config_t chan0_cfg = {
    .chan_id = DAC_CHAN_1
};
//----------------------------------------------------------//

typedef struct {
    uint64_t event_count;
} example_queue_element_t;

static bool example_timer_on_alarm_cb(gptimer_handle_t timer, const gptimer_alarm_event_data_t *edata, void *user_ctx)
{
    BaseType_t high_task_awoken = pdFALSE;
    QueueHandle_t queue = (QueueHandle_t)user_ctx;
    // Retrieve the count value from event data
    example_queue_element_t ele = {
        .event_count = edata->count_value
    };
    // Optional: send the event data to other task by OS queue
    // Do not introduce complex logics in callbacks
    // Suggest dealing with event data in the main loop, instead of in this callback
    xQueueSendFromISR(queue, &ele, &high_task_awoken);
    // return whether we need to yield at the end of ISR

    ESP_ERROR_CHECK(dac_oneshot_output_voltage(chan0_handle, (uint8_t) (adc1_get_raw(CHANNEL)/16)));

    return high_task_awoken == pdTRUE;
}

void app_main(void)
{
    example_queue_element_t ele;
    QueueHandle_t queue = xQueueCreate(10, sizeof(example_queue_element_t));
    if (!queue) {
        ESP_LOGE(TAG, "Creating queue failed");
        return;
    }

    adc_digi_configuration_t adc_cfg = {
        .sample_freq_hz = 1000000
    };

    adc_digi_controller_configure(&adc_cfg);
    adc1_config_width(WIDTH);
    adc1_config_channel_atten(CHANNEL,ATTEN);

    dac_oneshot_new_channel(&chan0_cfg, &chan0_handle);
 
    gptimer_handle_t gptimer = NULL;
    gptimer_config_t timer_config = {
        .clk_src = GPTIMER_CLK_SRC_DEFAULT,
        .direction = GPTIMER_COUNT_UP,
        .resolution_hz = 10000000, // 1MHz, 1 tick = 1us
    };
    ESP_ERROR_CHECK(gptimer_new_timer(&timer_config, &gptimer));

    gptimer_alarm_config_t alarm_config = {
        .reload_count = 0, // counter will reload with 0 on alarm event
        .alarm_count = 1, // period = 1s @resolution 1MHz
        .flags.auto_reload_on_alarm = true, // enable auto-reload
    };
    ESP_ERROR_CHECK(gptimer_set_alarm_action(gptimer, &alarm_config));
    
    gptimer_event_callbacks_t cbs = {
        .on_alarm = example_timer_on_alarm_cb, // register user callback
    };
    ESP_ERROR_CHECK(gptimer_register_event_callbacks(gptimer, &cbs, queue));
    ESP_ERROR_CHECK(gptimer_enable(gptimer));
    ESP_ERROR_CHECK(gptimer_start(gptimer));
    
    
    while (1)
    {

        //vTaskDelay(pdMS_TO_TICKS(10));
    }
    

}
