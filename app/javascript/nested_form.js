function initializeNestedForm() {
  let nested_fields = document.querySelector(".nested-fields").cloneNode(true);

  function attachRemoveHandler(link) {
    link.addEventListener("click", function(event) {
      console.log("remove");
      event.preventDefault();
      let field = link.closest(".nested-fields");
      field.querySelector("input[name*='_destroy']").value = "1";
      field.style.display = "none";

      if (field.classList.contains("new")) {
        field.remove();
      }
    });
  }

  document.querySelectorAll(".remove_fields").forEach(function(link) {
    attachRemoveHandler(link);
  });

  document.querySelector("#add_item").addEventListener("click", function(event) {
    event.preventDefault();
    let newField = nested_fields.cloneNode(true);
    // Add class "new" to the new field
    newField.classList.add("new");
    newField.querySelectorAll("input, select").forEach(function(input) {
      input.value = "";
    });
    document.querySelector("#parent").appendChild(newField);
    attachRemoveHandler(newField.querySelector(".remove_fields"));
  });
}

document.addEventListener("DOMContentLoaded", initializeNestedForm);
document.addEventListener("turbo:load", initializeNestedForm);