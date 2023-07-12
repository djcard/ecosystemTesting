component {

	property name="core"     inject="core@ecosystemTesting";
	property name="settings" inject="commandbox:configsettings";

	function run(
		required string sitename,
		required string branch,
		required string projectName,
		required evergreenBranches,
		string parentBranch
	){
		core.goHome( arguments.projectName );

		var rootFolder  = settings.modules.ecosystemTesting[ projectName ].rootFolder;
		var projectData = core.obtainData( projectName );
		print.line( "Getting site Data for #sitename#" ).toConsole();

		var siteData = core.obtainSiteData( siteName, projectName );
		if ( directoryExists( rootfolder & sitedata.homefolder ) ) {
			print.line( "Stopping all servers" ).toConsole();
			core.changeFolder( rootFolder & siteData.homeFolder );
			try {
				command( "server stop" ).run();
			} catch ( any err ) {
				// print.line('Error stopping server: #err.message#').toConsole();
			}
			sleep( 2000 );
			try {
				command( "server forget --force" ).run();
			} catch ( any err ) {
				// print.line('Error stopping server: #err.message#').toConsole();
			}
			command( "ecosystemTesting goHome #arguments.projectName#" ).run();

			print.line( "clearing " & rootFolder & siteData.homeFolder ).toConsole();
			core.clearFolder( rootFolder & siteData.homeFolder );
		} else {
			directoryCreate( rootfolder & sitedata.homefolder );
		}
		print.line( "Cloning the #siteData.repoName# repo into the folder: /#siteData.homeFolder#" );
		core.cloneBranch(
			siteData.repoName,
			arguments.branch,
			siteData.homeFolder,
			arguments.projectName,
			arguments.siteName,
			siteData.repoSite
		);

		var parentB = isNull( arguments.parentBranch ) ?  siteData.parentBranch : arguments.parentBranch;
		print.line("We will be evergreening from the #parentB# Branch").toConsole();
		print.line( "switching to the #arguments.branch# branch of #siteData.repoName# in the folder /#siteData.homeFolder#" );
		core.changeBranch(
			arguments.branch,
			rootFolder & siteData.homeFolder,
			arguments.projectName
		);
		if ( arguments.evergreenBranches ) {

			print.line( "merging #parentB# into  #branch#" );
			core.mergeInto(
				parentB,
				rootFolder & siteData.homeFolder,
				arguments.projectName
			);
		} else {
			print.line( "Skipping evergreening the branch" ).toConsole();
		}
		print.line( "Getting files" );
		core.obtainFiles( arguments.projectName, siteName );

		print.line( "Running Scripts" );
		core.runScripts( siteData, arguments.projectName );

		if ( siteData.framework == "javascript" ) {
			print.line( "Forcing rebuild of image" );
			try {
				core.reBuildImage( arguments.sitename );
			} catch ( any err ) {
				print.line( "Could not rebuild image" );
			}
		}

		if (
			projectData.keyExists( "usesDocker" ) && projectData.usesDocker && siteData.keyExists( "dockerContainer" ) && siteData.dockerContainer.len()
		) {
			try {
				core.restartContainer( siteName );
			} catch ( any err ) {
				print.line( "Could not restart #sitedata.dockerContainer#" );
			}
		}

		core.goHome( projectName );
		print.line("Complete");
	}

}
