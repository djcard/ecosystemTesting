component {

	property name="dbMethods" inject="dbMethods@ecosystemTesting";
	property name="core"      inject="core@ecosystemTesting";

	/***
	 * Backups up a MSSQL database
	 *
	 * @projectName The ecosystem project whose settings you wish to use
	 * @dbname      The name of the database you wish to back up
	 * @location    Directory to where you want the .bak file written (from the database's perspective)
	 **/
	function run(
		required string projectName,
		required string dbname,
		required string location,
		datasource
	){
		var dsourceMade     = dbmethods.createDataSourceFromSettings( projectName, "source" );
		var projectSettings = core.obtainProjectSettings( projectName );
		if ( !projectSettings.keyExists( "dbs" ) || !projectSettings.dbs.keyExists( "source" ) ) {
			print.line( "The source database does not exist. Please run `ecosystem dbs config` " );
			return;
		}

		dbMethods.backUpDb(
			arguments.dbname,
			arguments.location,
			!isNull( arguments.datasource ) ? arguments.datasource : projectSettings.dbs.source.name
		);
	}

}
