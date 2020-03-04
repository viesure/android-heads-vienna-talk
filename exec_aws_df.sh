#!/bin/bash


setup_environment
## We assum that artifacts where build with gradle:
./gradlew :app:assembleDebugAndroidTest :app:assembleDebug

source ./aws_device_farm.sh


echo "Get Project"
ARN_PROJECT=$(aws devicefarm list-projects | jq -r ".projects[] | select(.name == \"AndroidHeads\") | .arn")

echo "Get Pool"
ARN_POOL=$(aws devicefarm list-device-pools --arn $ARN_PROJECT | jq -r ".devicePools[] | select(.name == \"AndroidHeads\") | .arn")

echo "Upload app-debug.apk"
ARN_APK=$(upload_artifact $ARN_PROJECT "./app/build/outputs/apk/debug/app-debug.apk" ANDROID_APP)

echo "Upload app-debug-androidTest.apk"
ARN_TEST_APK=$(upload_artifact $ARN_PROJECT "./app/build/outputs/apk/androidTest/debug/app-debug-androidTest.apk" INSTRUMENTATION_TEST_PACKAGE)

# aws needs some time to process
sleep 10

aws devicefarm schedule-run --project-arn $ARN_PROJECT --app-arn $ARN_APK --device-pool-arn $ARN_POOL --name "$(uuidgen)" --test type=INSTRUMENTATION,testPackageArn=$ARN_TEST_APK

## cleanup
echo "CLEANUP"
echo "ARN_APK: $ARN_APK"
echo "ARN_TEST_APK: $ARN_TEST_APK"
# aws devicefarm delete-upload --arn $ARN_APK
# aws devicefarm delete-upload --arn $ARN_TEST_APK

