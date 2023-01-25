component {
    property name="core" inject="core@sitesetup";

    function run(required string container){
        core.restartContainer( container );
    }
}
