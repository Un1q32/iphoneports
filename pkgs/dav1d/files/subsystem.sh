if [ TARGET_OS_IOS = 1 ]; then
    subsystem=ios
elif [ TARGET_OS_OSX = 1 ]; then
    subsystem=macos
elif [ TARGET_OS_WATCH = 1 ]; then
    subsystem=watchos
elif [ TARGET_OS_TV = 1 ]; then
    subsystem=tvos
else
    echo "UNSUPPORTED PLATFORM"
    exit 1
fi

if [ TARGET_OS_SIMULATOR = 1 ]; then
    subsystem="$subsystem-simulator"
fi
