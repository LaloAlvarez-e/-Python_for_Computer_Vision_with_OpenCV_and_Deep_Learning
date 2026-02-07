#include "simpletools.h"                      // Include simple tools
#include "propeller.h"

void sineWavePWM(void *par);
void monitorTask(void *par);
void task1(void);
void task2(void);

volatile int *cogSinePWM; 
volatile int *cogMonitor;
volatile int *cogTask1; 
volatile int *cogTask2; 

const short *sineWave = (const short*)0xE000;  // ROM sine table (2048 entries)

// PWM parameters structure - make it volatile for sharing between COGs
typedef struct {
    int pin;              // Output pin
    long frequency;        // PWM frequency in Hz
    long sineFrequency;    // Sine wave frequency in Hz
} PWMParams;

// PWM status structure - updated by PWM COG, read by monitor COG
typedef struct {
    int sineIndex;        // Current sine table index
    long sineVal;          // Current sine value
    long dutyValue;        // Current duty cycle value
    long pwmPeriod;        // PWM period in cycles
    long highEnd;        // PWM period in cycles
    long periodEnd;        // PWM period in cycles
    unsigned long cycleCount; // Total PWM cycles completed
} PWMStatus;

volatile PWMParams pwmConfig;
volatile PWMStatus pwmStatus;

int main(void)
{
    clkset(0x6F, 80000000);  // Set clock to 80 MHz
    DIRA |= 0x00FF;          // Set first 8 pins as output
    
    print("First PA0-7 pins as output\n");
    print("Sine wave lookup table (first 20 values):\n");
    
    // Display first 20 sine wave values
    for(int i = 0; i < 20; i++)
    {
        printf("%d ", sineWave[i]);  
    }   
    print("\n\n");
    
    // Configure PWM on pin 2
    pwmConfig.pin = 2;
    pwmConfig.frequency = 333;      // 333 Hz PWM carrier frequency
    pwmConfig.sineFrequency = 1;    // Not used - step=1 gives ~0.163 Hz actual
    
    // Initialize status structure
    pwmStatus.sineIndex = 0;
    pwmStatus.sineVal = 0;
    pwmStatus.dutyValue = 0;
    pwmStatus.pwmPeriod = 0;
    pwmStatus.cycleCount = 0;
    
    // Small delay to ensure values are written
    pause(10);
    
    
    
    // Launch additional tasks
    cogTask1 = cog_run(task1, 128);
    printf("Task 1 launched (blink pin 0), COG %p\n", cogTask1);
    
    cogTask2 = cog_run(task2, 128);
    printf("Task 2 launched (blink pin 1), COG %p\n", cogTask2);
    
    // Launch sine wave PWM in separate cog
    cogSinePWM = cog_run(sineWavePWM, 256);
    printf("PWM COG launched, COG %p\n", cogSinePWM);
    
    // Launch monitor task in separate cog
    cogMonitor = cog_run(monitorTask, 128);
    printf("Monitor COG launched, COG %p\n", cogMonitor);
    // Close terminal in main COG before launching PWM COG
    simpleterm_close();
    // Main loop - monitor or add additional functionality
    while(1)
    {
        pause(1000);
    }
}


// Sine Wave PWM Generator - Using pause() for reliability
void sineWavePWM(void *par)
{
    // Read parameters
    int pin = pwmConfig.pin;
    
    // Phase accumulator for sine wave
    unsigned int phaseAccumulator = 0;
    unsigned long cycleCount = 0;
    
    DIRA |= (1 << pin);
    pwmStatus.pwmPeriod = 4000;  // ~10ms period for 100Hz PWM
    
    while(1)
    {
        // Get sine value
        int sineIndex = (phaseAccumulator >> 8) & 0x7FF;
        int sineVal = sineWave[sineIndex];
        unsigned int normalized = (unsigned int)(sineVal + 32768);
        int dutyPercent = (int)((normalized * 100UL) >> 16);
        
        // Update status
        pwmStatus.sineIndex = sineIndex;
        pwmStatus.sineVal = sineVal;
        pwmStatus.dutyValue = (dutyPercent * 4000) / 100;
        pwmStatus.cycleCount = cycleCount;
        
        // Clamp duty to 20-80% to ensure minimum pause times
        if(dutyPercent > 80) dutyPercent = 80;
        if(dutyPercent < 20) dutyPercent = 20;
        
        // Generate PWM pulses at this duty cycle
        // For ~333Hz: generate 3 pulses per sine point (~9ms total)
        for(int i = 0; i < 3; i++)
        {
            // Adjust to 3ms period: duty 20-80% = 0.6-2.4ms on, 2.4-0.6ms off
            int onTime = (dutyPercent * 3) / 100;   // 0.6-2.4ms
            int offTime = ((100 - dutyPercent) * 3) / 100;  // 2.4-0.6ms
            
            // Ensure minimum 1ms for both on and off
            if(onTime < 1) onTime = 1;
            if(offTime < 1) offTime = 1;
            
            high(pin);
            pause(onTime);
            low(pin);
            pause(offTime);
            cycleCount++;
        }
        
        // Move to next sine point - STEP = 1 for smooth progression
        phaseAccumulator += 1;  // Step by 1 (not 256) in phase accumulator
    }
}


// Monitor Task - prints PWM status periodically
void monitorTask(void *par)
{
    // Wait for PWM COG to start
    pause(100);
    
    // Open serial terminal for this COG
    simpleterm_open();
    
    printf("Monitor COG Started\n");
    printf("PWM Status Monitor - updates every 500ms\n");
    printf("==========================================\n");
    
    int lastCycles = 0;
    int idxPrev = -1;
    while(1)
    {
        // Read current status
        int idx = pwmStatus.sineIndex;
        long sine = pwmStatus.sineVal;
        long duty = pwmStatus.dutyValue;
        long period = pwmStatus.pwmPeriod;
        long cycles = pwmStatus.cycleCount;
        long highEnd = pwmStatus.highEnd;
        long periodEnd = pwmStatus.periodEnd;
        
        // Check if PWM is running
        long cyclesDiff = cycles - lastCycles;
        lastCycles = cycles;
        
        // Calculate duty percentage
        long dutyPercent = (period > 0) ? (duty * 100) / period : 0;
        
        // Always print status to see if PWM is running
       /* if(idx == idxPrev)
        {
            printf("Idx:%4d Sine:%6d Duty:%4d/%4d (%3d%%) Cycles:%lu (+%d/sec) highEnd:%lu periodEnd:%lu\n",
                idx, sine, duty, period, dutyPercent, cycles, cyclesDiff * 2, highEnd, periodEnd);
        }
        else
        {
            idxPrev = idx;
        }
            */
        //printf("Idx:%4d Sine:%6d Duty:%4d/%4d (%3d%%) Cycles:%lu (+%d/sec) highEnd:%lu periodEnd:%lu\n",
        //    idx, sine, duty, period, dutyPercent, cycles, cyclesDiff * 2, highEnd, periodEnd);
        
        // Wait 500ms before next update
        pause(100);
    }
}


// Task 1: Fast blink on pin 0
void task1(void)
{
    while(1)
    {
        high(0);                           // Pin 0 on
        pause(100);                        // 0.1 seconds
        low(0);                           // Pin 0 off
        pause(100);                        // 0.1 seconds
    }
}


// Task 2: Slow blink on pin 1
void task2(void)
{
    while(1)
    {
        high(1);                           // Pin 1 on
        pause(200);                        // 0.2 seconds
        low(1);                           // Pin 1 off
        pause(200);                        // 0.2 seconds
    }
}
