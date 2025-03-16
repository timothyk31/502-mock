function initializeNestedForm() {
  console.log("initializeNestedForm");
  // Clear all old event listeners by cloning nodes and replacing
  document.querySelectorAll(".remove_fields").forEach(function(link) {
    let newLink = link.cloneNode(true);
    link.parentNode.replaceChild(newLink, link);
  }
  );
  let add_item = document.querySelector("#add_item");
  if (add_item) {
    let newAddItem = add_item.cloneNode(true);
    add_item.parentNode.replaceChild(newAddItem, add_item);
  }

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

  document.querySelector("#parent").addEventListener("click", function(event) {
    if (event.target.classList.contains("remove_fields")) {
      console.log("Remove clicked");
      event.preventDefault();
      
      let field = event.target.closest(".nested-fields");
      if (!field) return;
  
      let destroyInput = field.querySelector("input[name*='_destroy']");
      if (destroyInput) {
        destroyInput.value = "1"; // Mark for removal in Rails
      }
      
      field.style.display = "none"; // Hide the field
  
      if (field.classList.contains("new")) {
        field.remove(); // Remove new fields completely
      }
    }
  });

}

// document.addEventListener("DOMContentLoaded", initializeNestedForm);
document.addEventListener("turbo:load", initializeNestedForm);