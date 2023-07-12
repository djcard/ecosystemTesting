component {

	property name="core"     inject="core@ecosystemTesting";
	property name="settings" inject="commandbox:configsettings";

	function run( string siteName = "", string projectName = "" ){
		if ( siteName.len() ) {
			print.line( "Getting site Data for #sitename#" ).toConsole();
			var siteData = core.obtainSiteData( siteName, projectname );
			if ( directoryExists( settings.modules.ecosystemTesting.rootfolder & sitedata.homefolder ) ) {
				command( "cd #settings.modules.ecosystemTesting.rootfolder & sitedata.homefolder#" ).run();
			} else {
				print.line( "Site not set up" );
			}
		}

		command( "!git status" ).run();
		command( "ecosystemTesting goHome" ).run();
	}

}
