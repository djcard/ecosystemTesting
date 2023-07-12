component {

	property name="awsMethods" inject="awsMethods@ecosystemTesting";
	property name="core"       inject="core@ecosystemTesting";

	/***
	 * Obtains a file from AWS S3 and writes it to the local file system
	 *
	 * @projectName The project whose settings you want to use
	 * @url         The path and filename (S3 key) of the file you wish to get
	 * @targetPath  The location (including filename) where you want the file to be written.
	 **/
	function run(
		required string projectName,
		required string uri,
		required string targetPath,
		string bucketName
	){
		var projectSettings = core.obtainProjectSettings( projectName );
		print.line("Using project #projectName#").toConsole();
		var bucket          = !isNull( arguments.bucketName ) ? arguments.bucketName : projectSettings.bucketname;
			print.line("Using bucket #bucket#").toConsole();
		var response        = awsMethods.obtainFromS3(
			bucket,
			arguments.uri,
			projectSettings.awsKey,
			projectSettings.awsSecret,
			projectSettings.region,
			arguments.targetPath
		);
		print.line( response );
	}

}
