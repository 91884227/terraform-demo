# local variable
locals {
  local_var_1 = "local_value_1"
  local_var_2 = "local_value_2"
}

# use module
module "use_module_1" {
  source = "./modules/moduleOne"

  module_one_var1 = "vm1"
}

module "use_module_2" {
  source = "./modules/moduleOne"

  module_one_var1 = "vm2"
}