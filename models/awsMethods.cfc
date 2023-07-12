component {

    property name="settings" inject="commandbox:configsettings";
    property name="aws" inject="AmazonS3@s3sdk";
    property name="print" inject="PrintBuffer";

    function pushToS3(
        required bucket,
        required string uri,
        required data,
        required string awsKey,
        required string awsSecretKey,
        required awsRegion,
    ) {
        aws.setAccessKey(arguments.awsKey);
        aws.setSecretKey(arguments.awsSecretKey);
        aws.setAwsRegion('us-west-2');
        return aws.putObjectFile(arguments.bucket, arguments.uri, arguments.data);
    }

    function obtainFromS3(
        required bucket,
        required uri,
        required string awsKey,
        required string awsSecretKey,
        required awsRegion,
        required string targetPath
    ) {
        aws.setAccessKey(arguments.awsKey);
        aws.setSecretKey(arguments.awsSecretKey);
        aws.setAwsRegion(arguments.awsRegion);
        aws.seturlStyle("virtual");
        var gettier = aws.getObject(bucket, uri);
        fileWrite(targetPath, gettier.response);
        return fileExists(targetPath);
    }

}
