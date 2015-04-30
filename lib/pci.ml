open Ctypes

module B = Pci_bindings.Bindings(Pci_generated)

module Pci_dev = struct
  type t = B.Pci_dev.t
  let domain t = getf !@t B.Pci_dev.domain |> Unsigned.UInt16.to_int
  let bus t = getf !@t B.Pci_dev.bus |> Unsigned.UInt8.to_int
  let dev t = getf !@t B.Pci_dev.dev |> Unsigned.UInt8.to_int
  let func t = getf !@t B.Pci_dev.func |> Unsigned.UInt8.to_int
  let vendor_id t = getf !@t B.Pci_dev.vendor_id |> Unsigned.UInt16.to_int
  let device_id t = getf !@t B.Pci_dev.device_id |> Unsigned.UInt16.to_int
  let device_class t = getf !@t B.Pci_dev.device_class |> Unsigned.UInt16.to_int
  let irq t = getf !@t B.Pci_dev.irq
  let base_addr t = getf !@t B.Pci_dev.base_addr |> CArray.to_list
end

module Pci_access = struct
  type t = B.Pci_access.t

  let devices t =
    let rec list_of_linked_list acc = function
    | None -> acc
    | Some d -> list_of_linked_list (d::acc) (getf !@d B.Pci_dev.next) in
    list_of_linked_list [] (getf !@t B.Pci_access.devices)
end

type pci_fill_flag =
  | PCI_FILL_IDENT
  | PCI_FILL_IRQ
  | PCI_FILL_BASES
  | PCI_FILL_ROM_BASE
  | PCI_FILL_SIZES
  | PCI_FILL_CLASS
  | PCI_FILL_CAPS
  | PCI_FILL_EXT_CAPS
  | PCI_FILL_PHYS_SLOT
  | PCI_FILL_MODULE_ALIAS
  | PCI_FILL_RESCAN

let int_of_pci_fill_flag = function
  | PCI_FILL_IDENT -> 1
  | PCI_FILL_IRQ -> 2
  | PCI_FILL_BASES -> 4
  | PCI_FILL_ROM_BASE -> 8
  | PCI_FILL_SIZES -> 16
  | PCI_FILL_CLASS -> 32
  | PCI_FILL_CAPS -> 64
  | PCI_FILL_EXT_CAPS -> 128
  | PCI_FILL_PHYS_SLOT -> 256
  | PCI_FILL_MODULE_ALIAS -> 512
  | PCI_FILL_RESCAN -> 0x10000

let pci_alloc = B.pci_alloc
let pci_init = B.pci_init
let pci_cleanup = B.pci_cleanup
let pci_scan_bus = B.pci_scan_bus
let pci_fill_info d flag_list =
  let crush_flags f =
    List.fold_left (fun i o -> i lor (f o)) 0 in
  let flags = crush_flags int_of_pci_fill_flag flag_list in
  B.pci_fill_info d flags
let pci_read_byte d pos = B.pci_read_byte d pos |> Unsigned.UInt8.to_int
