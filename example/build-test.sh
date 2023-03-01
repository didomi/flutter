# Script used to build the test bundle for one specific test file.

OUTPUT="../build/ios_integ"
PRODUCT="build/ios_integ/Build/Products"

FILE_NAME=$1

if [ -z "$FILE_NAME" ]
  then
    echo "No argument supplied, in order to run all tests in the integration_test directory, execute ./build-all-tests.sh which will execute ./build-test.sh"
    exit 1
fi

# Pass --simulator if building for the simulator.
flutter build ios integration_test/"$FILE_NAME" --release

pushd ios >/dev/null || exit 1
xcodebuild -workspace Runner.xcworkspace -scheme Runner -config Flutter/Release.xcconfig -derivedDataPath $OUTPUT -sdk iphoneos build-for-testing -quiet
popd >/dev/null || exit 1

FILE_NAME_WITHOUT_EXTENSION=${FILE_NAME%".dart"}
ZIP_FILE="ios_tests_$FILE_NAME_WITHOUT_EXTENSION.zip"
echo "Will zip $ZIP_FILE"

pushd $PRODUCT >/dev/null || exit 1
zip -r "$ZIP_FILE" "Release-iphoneos" Runner_iphoneos*.xctestrun
popd >/dev/null || exit 1
