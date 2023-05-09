/**
 * My BDD Test
 */
component extends="coldbox.system.testing.BaseTestCase" {

    /*********************************** LIFE CYCLE Methods ***********************************/

    // executes before all suites+specs in the run() method
    function beforeAll() {
        super.beforeAll();
    }

    // executes after all suites+specs in the run() method
    function afterAll() {
    }

    /*********************************** BDD SUITES ***********************************/

    function run() {
        describe(
            title = 'calculatePaginationData should ',
            labels = 'automated',
            body = function() {
                beforeEach(function() {
                    testObj = getinstance('clearFolder@ecosystemTesting');
                    writeDump(testObj);
                });
                it('should return a struct with the keys offset, maxRows, page, totalRecords, and totalPages', function() {
                    testme = testObj.calculatePaginationData(testData.len(), 1, 5);
                    expect(testme).tohavekey('offset');
                    expect(testme).tohavekey('maxRows');
                    expect(testme).tohavekey('page');
                    expect(testme).tohavekey('totalRecords');
                    expect(testme).tohavekey('totalPages');
                });
            }
        );
    }

}
