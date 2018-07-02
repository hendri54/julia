module test_allLH

reload("configLH_test")
using configLH_test

reload("displayLH_test")
using displayLH_test

reload("statsLH_test")
using statsLH_test

function run()
    configLH_test.test_all()
    displayLH_test.test_all()
    statsLH_test.test_all()
end


end
