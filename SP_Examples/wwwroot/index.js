const btn = document.querySelector(".btn");
const items = [...document.querySelectorAll(".grid__item")];
const body = document.querySelector("body");
const gridSize = getComputedStyle(body).getPropertyValue("--gridSize");

let availablePositions;
let props;
let x;
let y;

let getItemProperties = el => {
  el.props = {
    posX: parseInt(getComputedStyle(el).getPropertyValue("--posX")),
    posY: parseInt(getComputedStyle(el).getPropertyValue("--posY")),
    size: parseInt(getComputedStyle(el).getPropertyValue("--size"))
  };
};

const setNewPosition = () => {
  items.forEach(item => {
    getItemProperties(item);
    // creates an empty array of the number of available positions for the grid item - so that it won’t exceed 6 grid tracks
    availablePositions = [...Array(gridSize - (item.props.size - 1))];
    const itemAvailablePositions = availablePositions.map((u, i) => {
      return i + 1;
    });

    const getRandom = () => {
      return itemAvailablePositions[
        Math.floor(Math.random() * itemAvailablePositions.length)
      ];
    };

    const calcNewPos = el => {
      el.style.setProperty("--posX", getRandom());
      el.style.setProperty("--posY", getRandom());
    };

    calcNewPos(item);
  });
};

btn.addEventListener("click", setNewPosition);

/**********************************************************************/

/* Toggle between adding and removing the "responsive" class to topnav when the user clicks on the icon */
function myFunction() {
  var x = document.getElementById("myTopnav");
  if (x.className === "topnav") {
    x.className += " responsive";
  } else {
    x.className = "topnav";
  }
}
