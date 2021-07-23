
# module same name as function_name
module "test" {
    source = "../test/terraform"
    function_name = "test"
}

module "getTest" {
    source = "../getTest/terraform"
    function_name = "getTest"
}
