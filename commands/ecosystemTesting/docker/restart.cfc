component {
    property name="core" inject="core@ecosystemTesting";

    function run(required string container){
        core.restartContainer( container );
    }
}
