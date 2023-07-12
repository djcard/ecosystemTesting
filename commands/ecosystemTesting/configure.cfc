component {

	property name="core"     inject="core@ecosystemTesting";
	property name="settings" inject="commandbox:configsettings";



	function run(){
		core.checkModuleKeyExists();
		var data = core.obtainData( getcwd() );

		var projectName              = ask( message = "What is the name of this project? : " );
		data.projects[ projectname ] = data.projects.keyExists( projectName ) ? data.projects[ projectName ] : core.projectModel();

		var projectSettings = settings.modules.ecosystemTesting.keyExists( projectName ) ? settings.modules.ecosystemTesting[
			projectName
		] : {};

		var rootFolder = ask(
			message         = "What is the root folder of the project (Please end with trailing slash)? : ",
			defaultResponse = data.projects[ projectname ].keyExists( "rootFolder" ) && data.projects[ projectname ].rootFolder.len() ? data.projects[
				projectname
			].rootFolder : getcwd()
		);
		data.projects[ projectName ].rootfolder = rootFolder;
		command( "config set modules.ecosystemTesting.#projectName#.rootfolder=#rootFolder#" ).run();

		var username = ask(
			message         = "What is your repository username? :",
			defaultResponse = projectSettings.keyExists( "username" ) && projectSettings.username.len() ? projectSettings.username : ""
		);
		command( "config set modules.ecosystemTesting.#projectname#.username=#username#" ).run();

		var pat = ask(
			message         = "What is your repository PAT (remains local to this machine)? : ",
			defaultResponse = projectSettings.keyExists( "pat" ) && projectSettings.pat.len() ? projectSettings.pat : ""
		);
		command( "config set modules.ecosystemTesting.#projectname#.pat=#pat#" ).run();

		core.createENVFolder( rootFolder );

		core.writeData( getCwd(), data );

		var site = ask( "Set up site? y/n : " );
		while ( site != "n" ) {
			setupsite( projectName );
			site = ask( "Set up another site? y/n : " );
		}
	}

	/*
 - uri
 - homeFolder
 - launchScripts
 - repoSite
 - repoName
 - port
 - parentBranch
 - framework
 - fileNames
 - dockerContainer

*/
	function setUpSite( projectName ){
		var data = core.obtainData( getcwd() );

		siteName = ask(
			message         = "What is the name of the site? : ",
			defaultResponse = !isNull( sitename ) ? sitename : ""
		);
		data.projects[ projectName ].sites[ sitename ] = data.projects[ projectName ].sites.keyExists( sitename ) ? data.projects[
			projectName
		].sites[ sitename ] : core.siteModel();

		data.projects[ projectName ].sites[ sitename ][ "repoSite" ] = multiselect(
			message = "What Repo Host do you want to use? : "
		).options( [ "gitlab", "github" ] ).ask();


		data.projects[ projectName ].sites[ sitename ][ "repoName" ] = ask(
			message         = "What is the name of the repository for this site? : ",
			defaultResponse = data.projects[ projectName ].sites[ sitename ].keyExists( "repoName" ) && data.projects[
				projectName
			].sites[ sitename ].repoName.len() ? data.projects[ projectName ].sites[ sitename ].repoName : ""
		);

		data.projects[ projectName ].sites[ sitename ][ "parentBranch" ] = ask(
			message         = "What should the parent branch be for this site? : ",
			defaultResponse = data.projects[ projectName ].sites[ sitename ].keyExists( "parentBranch" ) && data.projects[
				projectName
			].sites[ sitename ].parentBranch.len() ? data.projects[ projectName ].sites[ sitename ].parentBranch : ""
		);

		data.projects[ projectName ].sites[ sitename ][ "homefolder" ] = ask(
			message         = "What is the relative path to the site folder? : ",
			defaultResponse = data.projects[ projectName ].sites[ sitename ].keyExists( "homeFolder" ) && data.projects[
				projectName
			].sites[ sitename ].homefolder.len() ? data.projects[ projectName ].sites[ sitename ].homefolder : ""
		);

		data.projects[ projectName ].sites[ sitename ][ "uri" ] = ask(
			message         = "what is the URL of this site? : ",
			defaultResponse = data.projects[ projectName ].sites[ sitename ].keyExists( "uri" ) && data.projects[
				projectName
			].sites[ sitename ].uri.len() ? data.projects[ projectName ].sites[ sitename ].uri : ""
		);

		data.projects[ projectName ].sites[ sitename ][ "port" ] = ask(
			message         = "what is the PORT of this site? : ",
			defaultResponse = data.projects[ projectName ].sites[ sitename ].keyExists( "port" ) && data.projects[
				projectName
			].sites[ sitename ].port.len() ? data.projects[ projectName ].sites[ sitename ].port : 80
		);

		var fileNameResponse = data.projects[ projectName ].sites[ sitename ][ "fileNames" ].map( function( item ){
			return "#item.source#:#item.target#";
		} );

		var envFiles = ask(
			message         = "List all files from the envFile folder which should be copied source:destination ? : ",
			defaultResponse = fileNameResponse.len() ? fileNameResponse.tolist() : ""
		);

		data.projects[ projectName ].sites[ sitename ][ "fileNames" ] = envFiles
			.listToArray()
			.map( function( item ){
				return {
					"source" : listFirst( item, ":" ),
					"target" : listLast( item, ":" )
				};
			} );

		data.projects[ projectName ].sites[ sitename ][ "framework" ] = multiselect(
			message         = "What is the framework of this site? : ",
			defaultResponse = data.projects[ projectName ].sites[ sitename ].keyExists( "framework" ) && data.projects[
				projectName
			].sites[ sitename ].framework.len() ? data.projects[ projectName ].sites[ sitename ].framework : ""
		).options( "javascript,CF" ).ask();


		var scripts = ask(
			message         = "List out the scripts which should be run after cloning (will run one by one in CommandBox) ? : ",
			defaultResponse = data.projects[ projectName ].sites[ sitename ].keyExists( "launchScripts" ) && data.projects[
				projectName
			].sites[ sitename ].launchScripts.len() ? data.projects[ projectName ].sites[ sitename ].launchScripts.toList() : ""
		);

		data.projects[ projectName ].sites[ sitename ].launchScripts = scripts
			.listToArray()
			.map( function( item ){
				return item;
			} );

		data.projects[ projectName ].sites[ sitename ][ "dockerContainer" ] = ask(
			message         = "What is the name of the site docker container (if any. leave blank for none) ? : ",
			defaultResponse = data.projects[ projectName ].sites[ sitename ].keyExists( "dockerContainer" )
			&& data.projects[ projectName ].sites[ sitename ].dockerContainer.len()
			 ? data.projects[ projectName ].sites[ sitename ].dockerContainer
			 : data.projects[ projectName ].sites[ sitename ].repoName.len()
			 ? data.projects[ projectName ].sites[ sitename ].repoName
			 : ""
		);

		core.writeData( getCwd(), data );
	}

}
