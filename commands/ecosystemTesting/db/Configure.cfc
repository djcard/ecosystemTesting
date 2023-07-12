component {

	property name="core"      inject="core@ecosystemTesting";
	property name="dbMethods" inject="dbMethods@ecosystemTesting";

	function run(){
		var projectName     = "";
		var projectData     = {};
		var projectSettings = {};
		print.line( "This will set up the values needed to back up and restore a DB to S3" );
		var start = confirm( message = "Do you want to get started? y/n ", defaultValue = "Y" );
		print.line( start );
		if ( start ) {
			projectName     = ask( "For what project should this configuration be used? " );
			projectData     = core.obtainProjectData( projectName );
			projectSettings = core.obtainProjectSettings( projectName );
			print.line( projectData );
			configureAWS( projectName, projectSettings );
			configureDB( "source", projectName, projectSettings );
			configureDB( "target", projectName, projectSettings );
		}
	}

	function configureAWS( projectName, projectSettings ){
		var bucketName = ask(
			message         = "In what S3 bucket will your backups be placed? ",
			defaultResponse = projectSettings.keyExists( "bucketName" ) ? projectSettings.bucketName : ""
		);
		command( "config set modules.ecosystemTesting.#projectName#.bucketName=#bucketName#" ).run();
		var awsKey = ask(
			message         = "What is your AWS key? ",
			defaultResponse = projectSettings.keyExists( "awsKey" ) ? projectSettings.awsKey : ""
		);
		command( "config set modules.ecosystemTesting.#projectName#.awsKey=#awsKey#" ).run();
		var awsSecret = ask(
			message         = "What is your AWS Secret Key?",
			defaultResponse = projectSettings.keyExists( "awsSecret" ) ? projectSettings.awsSecret : ""
		);
		command( "config set modules.ecosystemTesting.#projectName#.awsSecret=#awsSecret#" ).run();
		var region = ask(
			message         = "In what region is this bucket?",
			defaultResponse = projectSettings.keyExists( "region" ) ? projectSettings.region : ""
		);
		command( "config set modules.ecosystemTesting.#projectName#.region=#region#" ).run();
		print.line( "done" );
	}

	function configureDB( role, projectName, projectSettings ){
		var dbData = projectSettings.keyExists( "dbs" ) && projectSettings.dbs.keyExists( role ) ? projectSettings.dbs[
			role
		] : {};
		var doDB = confirm(
			message         = "This will configure the #role# database. Do you want to continue? y/n",
			defaultResponse = "Y"
		);
		if ( doDB ) {
			dbData.name = ask(
				message         = "What do you want to call the #role# datasource? ",
				defaultResponse = dbData.keyExists( "name" ) ? dbData.name : ""
			);
			command( "config set modules.ecosystemTesting.#projectName#.dbs.#role#.name=#dbData.name#" ).run();
			dbData.type = ask(
				message         = "What type of database is the #role# datasource (mysql, mssql)? ",
				defaultResponse = dbData.keyExists( "type" ) ? dbData.type : ""
			);
			command( "config set modules.ecosystemTesting.#projectName#.dbs.#role#.type=#dbData.type#" ).run();

			dbData.host = ask(
				message         = "What is the host of the #role# datasource? ",
				defaultResponse = dbData.keyExists( "host" ) ? dbData.host : ""
			);
			command( "config set modules.ecosystemTesting.#projectName#.dbs.#role#.host=#dbData.host#" ).run();

			dbData.dbname = ask(
				message         = "What database should the #role# datasource use? ",
				defaultResponse = dbData.keyExists( "dbname" ) ? dbData.dbname : ""
			);
			command( "config set modules.ecosystemTesting.#projectName#.dbs.#role#.dbname=#dbData.dbname#" ).run();

			dbData.userName = ask(
				message         = "What is the user name of the #role# datasource? ",
				defaultResponse = dbData.keyExists( "userName" ) ? dbData.userName : ""
			);
			command( "config set modules.ecosystemTesting.#projectName#.dbs.#role#.userName=#dbData.userName#" ).run();

			dbData.password = ask(
				message         = "What is the password of the #role# datasource? ",
				defaultResponse = dbData.keyExists( "password" ) ? dbData.password : ""
			);
			command( "config set modules.ecosystemTesting.#projectName#.dbs.#role#.password=#dbData.password#" ).run();

			dbData.port = ask(
				message         = "What is the port of the #role# datasource? ",
				defaultResponse = dbData.keyExists( "port" ) ? dbData.port : ""
			);
			command( "config set modules.ecosystemTesting.#projectName#.dbs.#role#.port=#dbData.port#" ).run();

			if ( dbdata.keyExists( "name" ) ) {
				dbMethods.createDataSourceFromSettings( projectName, role, dbdata );
			}
		};
	}

}
