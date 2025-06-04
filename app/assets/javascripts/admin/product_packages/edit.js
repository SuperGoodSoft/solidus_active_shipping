document
  .querySelector("#cancel_link")
  .addEventListener("click", function (event) {
    event.preventDefault();
    document.querySelector("#product_packages").innerHTML = "";
  });
