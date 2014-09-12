THEOS_PACKAGE_DIR_NAME = debs
TARGET = :clang
ARCHS = armv7 armv7s arm64
THEOS_DEVICE_IP = 192.168.2.3

include theos/makefiles/common.mk

TWEAK_NAME = Faces
Faces_FILES = Tweak.xm
Faces_FRAMEWORKS = UIKit CoreGraphics
Faces_PRIVATE_FRAMEWORKS = SpringBoardUIServices TelephonyUI

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 Preferences"
SUBPROJECTS += faces
include $(THEOS_MAKE_PATH)/aggregate.mk
