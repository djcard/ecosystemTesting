component {

	property name="dbMethods" inject="dbMethods@ecosystemTesting";
	property name="core"      inject="core@ecosystemTesting";

	/***
	 *Attempts to restore a .bak file to the DB server
	 *
	 * @projectName             The ecosystem project whose settings you wish to use
	 * @dbname                  The name of the db you wish to restore (must exist already on the DB server)
	 * @bakFileFileName         The .bak file from which to restore. Must be in the SQL Server's default backup folder
	 * @absoluteWriteToLocation The path where you wish the .mdf and .ldf files to be written. Typically the already existing data folder.
	 **/
	function run(
		required string projectName,
		required string dbname,
		required string bakFileFileName,
		required string absoluteWriteToLocation,
		datasource
	){
		var dsourceMade     = dbmethods.createDataSourceFromSettings( projectName, "target" );
		var projectSettings = core.obtainProjectSettings( projectName );
		if ( !projectSettings.keyExists( "dbs" ) || !projectSettings.dbs.keyExists( "target" ) ) {
			print.line( "The target database does not exist. Please run `ecosystem dbs config` " );
			return;
		}

		dbmethods.restoreDB(
			dbname,
			bakFileFileName,
			absoluteWriteToLocation,
			false,
			!isNull( arguments.datasource ) ? arguments.datasource : projectSettings.dbs.target.name
		);
		print.line( "Post run" );
	}

}
