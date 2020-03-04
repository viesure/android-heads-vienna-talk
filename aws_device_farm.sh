#!/bin/bash

echo_all_vars() {
    echo "ARN_PROJECT="$ARN_PROJECT
    echo "ARN_POOL="$ARN_POOL
    echo "ARN_APK="$ARN_APK
    echo "ARN_TEST_APK="$ARN_TEST_APK

}

upload_artifact () {
    # Preparation
    ARN_PROJECT=$1
    FILE=$2
    TYPE=$3
    TMP=$(uuidgen)".json"
    AWS_DEFAULT_OUTPUT="json"
    
    # Execution
    aws devicefarm create-upload --project-arn $ARN_PROJECT --name "app-debug.apk" --type $TYPE > $TMP
    ARN_APK=$(cat $TMP | jq -r ".upload.arn")
    URL_APK=$(cat $TMP | jq -r ".upload.url")
    curl -T $FILE $URL_APK
    
    # Cleanup
    rm $TMP

    # Return result
    echo $ARN_APK
}

