open Pci_bindings

let _ =
  let c_fmt = Format.formatter_of_out_channel @@ open_out "lib/pci_stubs.c" in
  let ml_fmt = Format.formatter_of_out_channel @@ open_out "lib/pci_generated.ml" in
  Format.fprintf c_fmt "#include <pci/pci.h>@.";
  Cstubs.write_c c_fmt ~prefix:"libpci_stub_" (module Bindings);
  Cstubs.write_ml ml_fmt ~prefix:"libpci_stub_" (module Bindings);
