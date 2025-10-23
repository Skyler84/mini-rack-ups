# Mini Rack UPS
Designing the optimal 10" mini rack UPS.

This project aims to create the perfect custom 10" mini rack UPS. It will include options for multiple battery chemistries, fit several form factors, and have a plethora of functionality.

My aim is to have the prototype complete by 12/2025 in time for some travel.

## Status

I have acquired most of the parts for the prototype including:
- power supply
- batteries
- BMS
- buck converters
- ideal diodes
- ina231/3221 current/voltage sensors
- LCD current/voltage sensors

I am awaiting an electronic load to enable testing of the 18650 cell capacities. 

## Requirements

The requirements for each user may be different based on space, capacity, power and safety. Several options will be considered in this project for each of these different preferences.

### Space

The UPS should have several options for space usage. These variations are based on available depth in rack, width (nominally 210mm for 10") and Unit height.
This includes, but is not limited to:
- Height:
  - 1U (44.45mm)
  - 2U (88.9mm)
  - 1.5U (66.7mm)
    - This option is intended to fit in the bottom U of TecMojo (maybe DeskPi as well?) racks.
- Depth:
  - 200mm (TecMojo, maybe DeskPi racks)
- Width:
  - 210mm (Maximum recommended for 10")

### Energy Storage

There are many options for energy storage, some people may prefer one over another for safety, capacity, weight or energy density. I will weigh up these options below.

Li-Ion (18650)
Li-Po
LFP
Pb

#### Comparison

| ...                      | Li-Ion    | Li-Po     | LFP      | Pb      |
| -                        | -         | -         | -        | -       |
| Energy density (volume)  | 600Wh/L   | 600Wh/L   | 325Wh/L  | 90Wh/L  |
| Specific Energy (weight) | 250Wh/Kg  | 250Wh/Kg  | 200Wh/Kg | 40Wh/Kg |
| Specific Power (weight)  | >1000W/Kg | >1000W/Kg | 200W/Kg  | 180W/Kg |
| Cell voltage | 3.0-4.2V | 3.0-4.2V | 2.5-3.6V | 2.05V |
| Maximum discharge | 10C | 50C | 3C | 3C |

In my personal build, I have opted for Li-Ion. More specifically I'm using Samsung 18650-INR-30Q high discharge cells.While not the highest capacity available (3Ah/3.5Ah), these are rated at much higher charge/discharge currents.This is preferable as the ability to recharge quickly is important to me - I plan to take my rack portable regularly. Additionally the higher current rating paired with parallel cells should allow very high peak power draw.

Additionally, the use of 18650 cells (in my opinion) is suited to the form factor - with clearance and spacing for airflow a single 18650 cell horizontally is ~0.5U high. This makes scaling the pack very simple and space efficient.

##### Li-Ion (18650/21700 cells)

While many people may be hesitant to use these cells due to their potential fire/explosion safety hazard, if treated correctly I would argue that these are one of the best options available for this use case. They have amazing energy density and specific energy. Once assembled into a pack they are less easy to damage than their Li-Po sibling due to the metal casing on the cells.
Additionally, with their metal casings Li-Ion cells do not puff/expand like Li-Po do, and often have better thermal performance as well.

##### Li-Po

While their performance is pretty much on par with Li-Ion, they can excel at high discharge. For this use case, it's not at all necessary that we can use all the energy in a matter of a few minutes (unless you really just want a few minutes of failure time).
Their polymer jacket is susceptible to puncture. In this event, the cell can puff, vent hazardous gasses and even catch fire. As the cells age they can also puff up which may cause improper pressure on other components and if there are sharp items nearby could cause spontateous puncture.
For this reason these are my 3rd choice.

##### LiFePO4 (LFP)

Similarly to Li-Ion, these are available in 18650 cell format. 

#### BMS

For battery management, I've found a lot of people online using the JKBMS products for large diy solar installations. While it is probably overkill for this use case, the configurability and monitoring/telemetry is what i'm particularly after. People have written integrations for home-assistant!

### Power Input

Depending on your use case you may wish to have AC input (C13 socket for input), DC input (XT60 connector) or both. I will also (at a later date) be including Solar input compatibility with MPPT.

In my prototype, there is a requirement that the DC input (or DC output from AC input) be higher than the battery voltage. This is due to the use of Ideal Diodes for power path, and a Buck converter for battery charging. Depending on this setup this may not be the same.

#### 110/240V AC->DC power supplies

There are no end to cheap power supplies available on AliExpress or other corners of the internet. For low power applications these may be just fine for your use case, however many of them are made with cheap components and may have undesirable switching noise/ripple on their output. Additionally they can get rather large, especially given the size constraints.

Having scoured far and wide for the best option, I found that the MeanWell provide high quality power supplies with good power density. 
For lower power (40-120W), their EPS series provides compact and efficient options that will fit in just about anything, all with >1" height.
For higher power (200-600W), their LOP series provides incredibly power dense power supplies which can operate at 1.5x capacity for 3s, have very low output ripple and can even operate fanless up to ~60% continuous load. These range from 2"\*4"\*1" (200W) up to 3"\*5"\*1.5" (600W), easily fitting within the height requirements of 1U.

#### External DC input

This option removes the requirement of an internal power supply, increasing the available space for energy storage and other features. For continuous use this must be able to provide enough power. Additionally there is no boost conversion in my current prototype, so the limitations of DC input mentioned above apply.

#### Solar input

Not currently supported, however there are plans to upgrade the power path and charge controller to support MPPT and input current/voltage limiting.

### Power Output

Some people will prefer DC output to minimise conversion losses while others will prefer AC inverter output to simplify use with other devices. 

#### DC output

For this option, I will be providing 3 power rails to the rack:
- System/Battery voltage
  - This will be capable of very high power as there are no intermediate conversions
- 12V 8A rail for any devices that want regulated 12V
- 5V 8A rail for any devices that want regulated 5V
- 4\*65W USB-C PD output

#### AC output

## My build

For my UPS, I will be going with 1.5U to fit at the bottom of my TecMojo 6U mini rack. This will hold:
- 6S4P 3Ah 18650 pack (65mm\*70mm\*165mm)
- MeanWell LOP-600 600W (400W passive cooled) 27V DC power supply (76mm\*115mm\*35mm)
- JKBMS 8S 40A active balance smart BMS (bluetooth, coulomb counting, multi-chemistry, highly configurable)
- 3\*300W 8A Buck converters
  - Charge CC/CV
  - 12V
  - 5V
