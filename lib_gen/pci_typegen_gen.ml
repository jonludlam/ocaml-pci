open Pci_bindings

let _ =
  let c_types_fmt = Format.formatter_of_out_channel @@ open_out "lib/pci_typegen.c" in
  Format.fprintf c_types_fmt "#include <pci/pci.h>@.";
  Cstubs.Types.write_c c_types_fmt (module Type_Bindings);
