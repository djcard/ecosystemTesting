component {

    property name="core" inject="core@sitesetup";

    function run2(siteName, projectName, branch = 'dev') {
        var siteData = core.obtainSiteData(siteName, projectName);
        print.line('clearing ' & getcwd() & siteData.homeFolder);
        core.clearFolder(getcwd() & siteData.homeFolder);
        core.cloneBranch(sitename, projectName, branch);
    }

}
