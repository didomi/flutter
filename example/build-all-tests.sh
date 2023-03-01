# Script used to iterate through all the dart test files contained in the integration_test directory and execute ./build-test.sh for each one of them.

TEST_FILE_PATHS=$(ls integration_test/*_test.dart)

for TEST_FILE_PATH in $TEST_FILE_PATHS
do
  TEST_FILE=${TEST_FILE_PATH#"integration_test/"}
  echo "Creating tests for $TEST_FILE"
  ./build-test.sh "$TEST_FILE"
done
