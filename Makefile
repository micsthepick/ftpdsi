#---------------------------------------------------------------------------------
.SUFFIXES:
#---------------------------------------------------------------------------------

TARGET   := $(shell basename $(CURDIR))

export GITREV  := $(shell git rev-parse HEAD 2>/dev/null | cut -c1-8)
export VERSION_MAJOR := 0
export VERSION_MINOR := 1
export VERSION_MICRO := 0
export VERSION := $(VERSION_MAJOR).$(VERSION_MINOR).$(VERSION_MICRO)

ifneq ($(strip $(GITREV)),)
export VERSION := $(VERSION)-$(GITREV)
endif

export OUTPUT := $(CURDIR)/$(TARGET)

GAME_TITLE := ftpdsi
GAME_SUBTITLE1 := v$(VERSION)
GAME_SUBTITLE2 := unofficial fork of ftpd
GAME_ICON := meta/icon32.bmp

$(OUTPUT).dsi: $(OUTPUT).arm7.elf $(OUTPUT).arm9.elf dsiwifi $(NITRO_FILES) $(GAME_ICON)
	ndstool	-c $(TARGET).dsi -9 $(TARGET).arm9.elf -7 $(TARGET).arm7.elf -b $(GAME_ICON) "$(GAME_TITLE);$(GAME_SUBTITLE1);$(GAME_SUBTITLE2)"

$(OUTPUT).arm7.elf: dsiwifi7
	@$(MAKE) -f Makefile_ARM7 build

$(OUTPUT).arm9.elf: dsiwifi9
	@$(MAKE) -f Makefile_ARM9 build

clean:
	@$(MAKE) -f Makefile_ARM7 clean
	@$(MAKE) -f Makefile_ARM9 clean

	@$(MAKE) -C $(CURDIR)/dsiwifi/arm_host clean
	@$(MAKE) -C $(CURDIR)/dsiwifi/arm_iop clean
	@rm -rf $(OUTPUT).dsi

dsiwifi9:
	mkdir -p $(CURDIR)/dsiwifi/arm_host/lib
	@$(MAKE) -C $(CURDIR)/dsiwifi/arm_host release

dsiwifi7:
	mkdir -p $(CURDIR)/dsiwifi/arm_iop/lib
	@$(MAKE) -C $(CURDIR)/dsiwifi/arm_iop release


