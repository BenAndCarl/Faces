THEOS_PACKAGE_DIR_NAME = debs
TARGET = :clang
ARCHS = armv7 armv7s arm64
THEOS_DEVICE_IP = 192.168.2.3

include theos/makefiles/common.mk

BUNDLE_NAME = Faces
Faces_FILES = Faces.mm
Faces_INSTALL_PATH = /Library/PreferenceBundles
Faces_FRAMEWORKS = UIKit Twitter MessageUI
Faces_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/Faces.plist$(ECHO_END)
