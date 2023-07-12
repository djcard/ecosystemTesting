component {

	property name="awsMethods" inject="awsMethods@ecosystemTesting";
	property name="core"       inject="core@ecosystemTesting";

	/**
	 * Pushes a file up to AWS S3 if the appropriate keys are set up in the settings project
	 *
	 * @projectName The name of the ecosystem project whose settings you want to use
	 * @fileName    The absolute path and name of the file you wish to upload
	 * @uri         The name of the file on S3. Defaults to the filename submitted
	 * @bucketName  The name of the AWS S3 bucket. Will default to the bucket in the project settings
	 **/
	function run(
		required string projectName,
		required string fileName,
		uri,
		bucketName
	){
		var delim           = core.obtainDelim();
		var projectSettings = core.obtainProjectSettings( projectName );
		var bucket          = !isNull( arguments.bucketName ) ? arguments.bucketName : projectSettings.bucketName;
		var s3Key           = !isNull( arguments.uri ) ? arguments.uri : listLast( filename, delim );
		print.line( bucket );
		print.line( s3key );
		var sentData = awsMethods.pushToS3(
			bucket,
			filename,
			s3Key,
			projectSettings.awsKey,
			projectSettings.awsSecret,
			"us-west-2"
		);
		print.line( sentData );
	}

}
