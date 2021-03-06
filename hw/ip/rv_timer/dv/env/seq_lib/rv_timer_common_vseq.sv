// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

class rv_timer_common_vseq extends rv_timer_base_vseq;
  `uvm_object_utils(rv_timer_common_vseq)
  `uvm_object_new

  constraint num_trans_c {
    num_trans inside {[1:3]};
  }

  virtual task body();
    run_common_vseq_wrapper(num_trans);
  endtask : body

  // function to add csr exclusions of the given type using the csr_excl_item item
  virtual function void add_csr_exclusions(string           csr_test_type,
                                           csr_excl_item    csr_excl,
                                           string           scope = "ral");
    // write exclusions - these should not apply to hw_reset test
    if (csr_test_type != "hw_reset") begin
      // prevent timer from being enabled
      csr_excl.add_excl({scope, ".", "ctrl.active*"}, CsrExclWrite);

      // intr_test csr is WO which - it reads back 0s, plus it affects the intr_state csr
      csr_excl.add_excl({scope, ".", "intr_test*"}, CsrExclWrite);
    end
  endfunction

endclass
