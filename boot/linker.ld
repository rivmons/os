ENTRY(start)
OUTPUT_FORMAT("binary")
phys = 0x7C00

SECTIONS
{
    . = phys;

    .entry              : { __entry_start = .;
                            *(.entry)   
                          }

    .bios_footer 0x7DFE : { SHORT(0xAA55)       }
}