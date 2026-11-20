
ARCHS = arm64
TARGET = iphone:clang:latest:15.0

include $(THEOS)/makefiles/common.mk

APPLICATION_NAME = YouTubePiP

YouTubePiP_FILES = Tweak.m
YouTubePiP_FRAMEWORKS = UIKit AVKit AVFoundation WebKit
YouTubePiP_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/application.mk
