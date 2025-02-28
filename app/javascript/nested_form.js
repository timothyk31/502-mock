
document.addEventListener("DOMContentLoaded", function() {
    document.querySelectorAll(".remove_fields").forEach(function(link) {
      link.addEventListener("click", function(event) {
        event.preventDefault();
        let field = link.closest(".nested-fields");
        field.querySelector("input[name*='_destroy']").value = "1";
        field.style.display = "none";
      });
    });
  
    document.querySelector("#add_payment").addEventListener("click", function(event) {
      event.preventDefault();
      let newField = document.querySelector(".nested-fields").cloneNode(true);
      newField.querySelectorAll("input, select").forEach(function(input) {
        input.value = "";
      });
      document.querySelector("#transaction_payments").appendChild(newField);
    });
  });